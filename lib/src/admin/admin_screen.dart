import 'package:flutter/material.dart';
import 'package:hospital_core/hospital_core.dart';

import '../l10n/generated/portal_localizations.dart';
import 'admin_client.dart';
import 'admin_config.dart';

/// The administration console: who can sign in, and as what.
///
/// It is a thin face over `/admin` on the API server. Nothing privileged
/// happens here - the page cannot create an account or grant a role by itself,
/// it can only ask, carrying the administrator's own token. Everything it
/// offers, the server checks again.
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key, required this.config, this.auth, this.client});

  final AdminConfig config;

  /// Injected by tests. In the running application the console builds its own
  /// Firebase service on first open, so visiting the portal does not require
  /// Firebase to be configured at all.
  final AuthService? auth;
  final AdminClient? client;

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  AuthService? _auth;
  AdminClient? _client;

  /// Set when the console cannot even offer a sign-in form.
  String? _startupError;

  List<AdminUser>? _users;
  bool _busy = false;
  String? _errorCode;
  String? _notice;

  @override
  void initState() {
    super.initState();
    if (widget.config.isConfigured) _start();
  }

  Future<void> _start() async {
    final auth = widget.auth ?? FirebaseAuthService();
    try {
      await auth.initialize();
    } on StateError {
      // Thrown when the build carries no Firebase keys. That is a build-time
      // fact, not a failure the user can retry out of.
      if (mounted) setState(() => _startupError = 'firebase-missing');
      return;
    }
    if (!mounted) return;
    auth.addListener(_onAuthChanged);
    setState(() {
      _auth = auth;
      _client =
          widget.client ??
          AdminClient(config: widget.config, tokenSource: auth.idToken);
    });
    _onAuthChanged();
  }

  void _onAuthChanged() {
    if (!mounted) return;
    setState(() {});
    final user = _auth?.currentUser;
    if (user != null && user.role.canAdminister && _users == null && !_busy) {
      _load();
    }
    if (user == null && _users != null) setState(() => _users = null);
  }

  @override
  void dispose() {
    _auth?.removeListener(_onAuthChanged);
    // Only dispose what this screen made; an injected service belongs to
    // whoever injected it.
    if (widget.auth == null) _auth?.dispose();
    if (widget.client == null) _client?.close();
    super.dispose();
  }

  // ---- actions -------------------------------------------------------------

  Future<void> _run(Future<void> Function() action, {String? notice}) async {
    setState(() {
      _busy = true;
      _errorCode = null;
      _notice = null;
    });
    try {
      await action();
      if (mounted) setState(() => _notice = notice);
    } on AdminException catch (failure) {
      if (mounted) setState(() => _errorCode = failure.code);
    } on AuthFailure catch (failure) {
      if (mounted) setState(() => _errorCode = failure.code);
    } catch (_) {
      if (mounted) setState(() => _errorCode = 'unknown');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _load() => _run(() async {
    final users = await _client!.users();
    if (mounted) setState(() => _users = users);
  });

  Future<void> _signIn(String email, String password) =>
      _run(() => _auth!.signIn(email: email, password: password));

  Future<void> _signOut() async {
    await _auth?.signOut();
    if (mounted) setState(() => _users = null);
  }

  Future<void> _reload() async {
    setState(() => _users = null);
    await _load();
  }

  // ---- build ---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l10n = PortalLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminTitle),
        actions: <Widget>[
          const LanguageSelector(compact: true),
          if (_auth?.isSignedIn ?? false)
            IconButton(
              tooltip: l10n.adminSignOut,
              onPressed: _signOut,
              icon: const Icon(Icons.logout_rounded),
            ),
          Gap.w8,
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.all(Gap.lg),
              children: <Widget>[_body(context, l10n)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, PortalLocalizations l10n) {
    if (!widget.config.isConfigured) {
      return _InfoCard(
        icon: Icons.cloud_off_rounded,
        title: l10n.adminUnavailableTitle,
        body: l10n.adminUnavailableBody,
      );
    }
    if (_startupError == 'firebase-missing') {
      return _InfoCard(
        icon: Icons.key_off_rounded,
        title: l10n.adminFirebaseMissingTitle,
        body: l10n.adminFirebaseMissingBody,
      );
    }

    final auth = _auth;
    if (auth == null || !auth.isReady) {
      return const Padding(
        padding: EdgeInsets.all(Gap.xl),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final user = auth.currentUser;
    if (user == null) {
      return _SignInForm(
        busy: _busy,
        errorMessage: _errorCode == null
            ? null
            : _messageFor(l10n, _errorCode!),
        onSubmit: _signIn,
      );
    }
    if (!user.role.canAdminister) {
      return _InfoCard(
        icon: Icons.block_rounded,
        title: l10n.adminNotAdminTitle,
        body: l10n.adminNotAdminBody(user.role.display.of(context)),
        action: OutlinedButton.icon(
          onPressed: _signOut,
          icon: const Icon(Icons.logout_rounded, size: 18),
          label: Text(l10n.adminSignOut),
        ),
      );
    }
    return _console(context, l10n, user);
  }

  Widget _console(
    BuildContext context,
    PortalLocalizations l10n,
    HospitalUser me,
  ) {
    final theme = Theme.of(context);
    final users = _users;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(l10n.adminIntro, style: theme.textTheme.bodyLarge),
        Gap.h8,
        Text(
          l10n.adminSignedInAs(me.email),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Gap.h24,
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                l10n.adminAccounts,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              tooltip: l10n.adminRefresh,
              onPressed: _busy ? null : _reload,
              icon: const Icon(Icons.refresh_rounded),
            ),
            Gap.w8,
            FilledButton.icon(
              onPressed: _busy ? null : () => _openNewUserDialog(l10n),
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: Text(l10n.adminAddUser),
            ),
          ],
        ),
        if (_errorCode != null) ...<Widget>[
          Gap.h16,
          _Banner(
            message: _messageFor(l10n, _errorCode!),
            colour: theme.colorScheme.errorContainer,
            onColour: theme.colorScheme.onErrorContainer,
            icon: Icons.error_outline_rounded,
          ),
        ],
        if (_notice != null) ...<Widget>[
          Gap.h16,
          _Banner(
            message: _notice!,
            colour: theme.colorScheme.secondaryContainer,
            onColour: theme.colorScheme.onSecondaryContainer,
            icon: Icons.check_circle_outline_rounded,
          ),
        ],
        Gap.h16,
        if (users == null && _busy)
          const Padding(
            padding: EdgeInsets.all(Gap.xl),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (users == null)
          // The load failed. The banner above says why; this is the way back.
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: _reload,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(l10n.adminRefresh),
            ),
          )
        else if (users.isEmpty)
          Text(l10n.adminNoAccounts)
        else
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                for (var index = 0; index < users.length; index++) ...<Widget>[
                  if (index > 0) const Divider(height: 1),
                  _UserTile(
                    user: users[index],
                    isSelf: users[index].uid == me.uid,
                    busy: _busy,
                    onRole: (role) => _run(() async {
                      await _client!.setRole(users[index].uid, role);
                      await _reload();
                    }, notice: l10n.adminRoleTakesEffect),
                    onDisabled: (disabled) => _run(() async {
                      await _client!.setDisabled(
                        users[index].uid,
                        disabled: disabled,
                      );
                      await _reload();
                    }, notice: l10n.adminSaved),
                    onPassword: () => _openPasswordDialog(l10n, users[index]),
                    onDelete: () => _confirmDelete(l10n, users[index]),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  // ---- dialogs -------------------------------------------------------------

  Future<void> _openNewUserDialog(PortalLocalizations l10n) async {
    final draft = await showDialog<_NewUser>(
      context: context,
      builder: (_) => const _NewUserDialog(),
    );
    if (draft == null) return;
    await _run(() async {
      await _client!.create(
        email: draft.email,
        password: draft.password,
        displayName: draft.displayName,
        role: draft.role,
      );
      await _reload();
    }, notice: l10n.adminSaved);
  }

  Future<void> _openPasswordDialog(
    PortalLocalizations l10n,
    AdminUser user,
  ) async {
    final password = await showDialog<String>(
      context: context,
      builder: (_) => _PasswordDialog(email: user.email),
    );
    if (password == null) return;
    await _run(
      () => _client!.setPassword(user.uid, password),
      notice: l10n.adminSaved,
    );
  }

  Future<void> _confirmDelete(PortalLocalizations l10n, AdminUser user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(l10n.adminDeleteTitle),
        content: Text(l10n.adminDeleteBody(user.email)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.adminCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.adminDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _run(() async {
      await _client!.delete(user.uid);
      await _reload();
    }, notice: l10n.adminSaved);
  }

  /// Turns the API's error code into something a reader can act on, keeping
  /// the code itself visible when there is nothing better to say.
  String _messageFor(PortalLocalizations l10n, String code) => switch (code) {
    'EMAIL_EXISTS' => l10n.adminErrorEmailExists,
    'weak-password' || 'WEAK_PASSWORD' => l10n.adminErrorWeakPassword,
    'cannot-demote-yourself' ||
    'cannot-disable-yourself' ||
    'cannot-delete-yourself' => l10n.adminErrorSelf,
    'unreachable' => l10n.adminErrorUnreachable,
    'not-an-administrator' => l10n.adminErrorNotAdmin,
    'invalid-credentials' => l10n.adminErrorGeneric(code),
    _ => l10n.adminErrorGeneric(code),
  };
}

// ---------------------------------------------------------------------------
// Pieces
// ---------------------------------------------------------------------------

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Gap.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, color: theme.colorScheme.primary),
                Gap.w16,
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            Gap.h16,
            Text(body, style: theme.textTheme.bodyMedium),
            if (action != null) ...<Widget>[Gap.h16, action!],
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.message,
    required this.colour,
    required this.onColour,
    required this.icon,
  });

  final String message;
  final Color colour;
  final Color onColour;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Gap.md),
      decoration: BoxDecoration(
        color: colour,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 20, color: onColour),
          Gap.w8,
          Expanded(
            child: Text(message, style: TextStyle(color: onColour)),
          ),
        ],
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  const _SignInForm({
    required this.busy,
    required this.onSubmit,
    this.errorMessage,
  });

  final bool busy;
  final String? errorMessage;
  final Future<void> Function(String email, String password) onSubmit;

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = PortalLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Gap.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                l10n.adminSignInTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gap.h8,
              Text(l10n.adminSignInBody, style: theme.textTheme.bodyMedium),
              Gap.h24,
              TextFormField(
                controller: _email,
                autofillHints: const <String>[AutofillHints.username],
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.adminEmail,
                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                ),
                validator: (value) =>
                    (value ?? '').contains('@') ? null : l10n.adminRequired,
              ),
              Gap.h16,
              PasswordField(
                controller: _password,
                label: l10n.adminPassword,
                autofillHints: const <String>[AutofillHints.password],
                prefixIcon: Icons.lock_outline_rounded,
                onSubmitted: _submit,
                validator: (value) =>
                    (value ?? '').isEmpty ? l10n.adminRequired : null,
              ),
              if (widget.errorMessage != null) ...<Widget>[
                Gap.h16,
                Text(
                  widget.errorMessage!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
              Gap.h24,
              FilledButton(
                onPressed: widget.busy ? null : _submit,
                child: Text(l10n.adminSignIn),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSubmit(_email.text.trim(), _password.text);
  }
}

/// A password field that can be read back.
///
/// Masking protects a password from the room, which matters at a lectern and
/// on a projector. It does not help the person typing one, and every password
/// here is being *chosen* rather than recalled - a new account, a reset. Typing
/// eighteen characters blind into a field that will not tell you what it holds,
/// twice, is how people end up locked out of accounts they created themselves.
///
/// So: masked by default, and revealed on request. Firebase stores only a
/// hash, so this is the single moment at which a password can be checked at
/// all - afterwards nobody can read it back, not the console, not this
/// application, not Google.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.helper,
    this.prefixIcon,
    this.autofocus = false,
    this.autofillHints,
    this.onSubmitted,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String? helper;
  final IconData? prefixIcon;
  final bool autofocus;
  final Iterable<String>? autofillHints;
  final VoidCallback? onSubmitted;
  final String? Function(String?)? validator;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final l10n = PortalLocalizations.of(context);
    final label = _visible ? l10n.adminHidePassword : l10n.adminShowPassword;

    return TextFormField(
      controller: widget.controller,
      obscureText: !_visible,
      autofocus: widget.autofocus,
      autofillHints: widget.autofillHints?.toList(),
      decoration: InputDecoration(
        labelText: widget.label,
        helperText: widget.helper,
        prefixIcon: widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
        suffixIcon: IconButton(
          tooltip: label,
          // Named for a screen reader too: the icon alone says nothing.
          icon: Icon(
            _visible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            semanticLabel: label,
          ),
          onPressed: () => setState(() => _visible = !_visible),
        ),
      ),
      onFieldSubmitted: widget.onSubmitted == null
          ? null
          : (_) => widget.onSubmitted!(),
      validator: widget.validator,
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    required this.user,
    required this.isSelf,
    required this.busy,
    required this.onRole,
    required this.onDisabled,
    required this.onPassword,
    required this.onDelete,
  });

  final AdminUser user;
  final bool isSelf;
  final bool busy;
  final void Function(String role) onRole;
  final void Function(bool disabled) onDisabled;
  final VoidCallback onPassword;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = PortalLocalizations.of(context);
    final name = user.displayName.isEmpty ? user.email : user.displayName;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Gap.md,
        vertical: Gap.sm,
      ),
      leading: CircleAvatar(
        backgroundColor: user.disabled
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.primaryContainer,
        child: Icon(
          user.role == 'admin' ? Icons.shield_rounded : Icons.person_rounded,
          size: 20,
          color: user.disabled
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          decoration: user.disabled ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        user.displayName.isEmpty
            ? _lastSignIn(l10n)
            : '${user.email} - ${_lastSignIn(l10n)}',
        style: theme.textTheme.bodySmall,
      ),
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: Gap.sm,
        children: <Widget>[
          _RoleDropdown(
            role: user.role,
            // Nobody may take their own administrator rights away, so the
            // console does not even offer it - the server refuses it too.
            enabled: !busy && !isSelf,
            onChanged: onRole,
          ),
          PopupMenuButton<String>(
            enabled: !busy,
            onSelected: (value) => switch (value) {
              'password' => onPassword(),
              'disable' => onDisabled(!user.disabled),
              'delete' => onDelete(),
              _ => null,
            },
            itemBuilder: (_) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'password',
                child: Text(l10n.adminSetPassword),
              ),
              PopupMenuItem<String>(
                value: 'disable',
                enabled: !isSelf,
                child: Text(
                  user.disabled ? l10n.adminEnabled : l10n.adminDisabled,
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                enabled: !isSelf,
                child: Text(l10n.adminDelete),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _lastSignIn(PortalLocalizations l10n) {
    final at = user.lastSignInAt;
    if (at == null) return '${l10n.adminLastSignIn}: ${l10n.adminNever}';
    final local = at.toLocal();
    final date =
        '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/${local.year}';
    return '${l10n.adminLastSignIn}: $date';
  }
}

class _RoleDropdown extends StatelessWidget {
  const _RoleDropdown({
    required this.role,
    required this.enabled,
    required this.onChanged,
  });

  final String role;
  final bool enabled;
  final void Function(String role) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = PortalLocalizations.of(context);
    final known = UserRole.values.any((r) => r.name == role);

    return DropdownButton<String>(
      value: known ? role : '',
      underline: const SizedBox.shrink(),
      onChanged: enabled
          ? (value) {
              if (value != null && value.isNotEmpty) onChanged(value);
            }
          : null,
      items: <DropdownMenuItem<String>>[
        if (!known)
          DropdownMenuItem<String>(value: '', child: Text(l10n.adminNoRole)),
        for (final option in UserRole.values)
          DropdownMenuItem<String>(
            value: option.name,
            child: Text(option.display.of(context)),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Dialogs
// ---------------------------------------------------------------------------

class _NewUser {
  const _NewUser({
    required this.email,
    required this.password,
    required this.displayName,
    required this.role,
  });

  final String email;
  final String password;
  final String displayName;
  final String role;
}

class _NewUserDialog extends StatefulWidget {
  const _NewUserDialog();

  @override
  State<_NewUserDialog> createState() => _NewUserDialogState();
}

class _NewUserDialogState extends State<_NewUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  UserRole _role = UserRole.student;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = PortalLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.adminAddUser),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: l10n.adminEmail),
                validator: (value) =>
                    (value ?? '').contains('@') ? null : l10n.adminRequired,
              ),
              Gap.h16,
              TextFormField(
                controller: _name,
                decoration: InputDecoration(labelText: l10n.adminDisplayName),
              ),
              Gap.h16,
              PasswordField(
                controller: _password,
                label: l10n.adminPassword,
                helper: l10n.adminPasswordRule,
                validator: (value) =>
                    (value ?? '').length >= 8 ? null : l10n.adminPasswordRule,
              ),
              Gap.h16,
              DropdownButtonFormField<UserRole>(
                initialValue: _role,
                decoration: InputDecoration(labelText: l10n.adminRole),
                items: <DropdownMenuItem<UserRole>>[
                  for (final option in UserRole.values)
                    DropdownMenuItem<UserRole>(
                      value: option,
                      child: Text(option.display.of(context)),
                    ),
                ],
                onChanged: (value) =>
                    setState(() => _role = value ?? UserRole.student),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.adminCancel),
        ),
        FilledButton(
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) return;
            Navigator.pop(
              context,
              _NewUser(
                email: _email.text.trim(),
                password: _password.text,
                displayName: _name.text.trim(),
                role: _role.name,
              ),
            );
          },
          child: Text(l10n.adminCreate),
        ),
      ],
    );
  }
}

class _PasswordDialog extends StatefulWidget {
  const _PasswordDialog({required this.email});

  final String email;

  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = PortalLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.adminSetPassword),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(widget.email),
            Gap.h16,
            PasswordField(
              controller: _password,
              label: l10n.adminNewPassword,
              helper: l10n.adminPasswordRule,
              autofocus: true,
              validator: (value) =>
                  (value ?? '').length >= 8 ? null : l10n.adminPasswordRule,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.adminCancel),
        ),
        FilledButton(
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) return;
            Navigator.pop(context, _password.text);
          },
          child: Text(l10n.adminSetPassword),
        ),
      ],
    );
  }
}
