# my-hospital

The front door of **Mini-Hospital 2026**: one page from which the five
applications and the ten device simulators are opened.

**https://my-hospital-2026.web.app**

It is deliberately thin. No database, no sign-in, no patient data — a page of
links that knows where everything lives. What it does share with the rest of
the suite is the design system, the badges and the three languages, so the
door looks like the rooms behind it.

## The suite

| Application | What it is for | Repository |
| --- | --- | --- |
| EHR | Patient file, prescriptions, observations, notes | [EHR](https://github.com/LucaProcaryote/EHR) |
| ADT | Admissions, transfers, discharges, bed board | [ADT](https://github.com/LucaProcaryote/ADT) |
| PHARM | The pharmacy cabinet: stock and dispensing | [PHARM](https://github.com/LucaProcaryote/PHARM) |
| EAI | FHIR resources and the visual flow editor | [EAI](https://github.com/LucaProcaryote/EAI) |
| Devices | DEV1…DEV10 vital-sign simulators | [Dev_Central](https://github.com/LucaProcaryote/Dev_Central) |

Everything shared — the domain model, FHIR mapping, the trilingual strings,
the design system — lives in `packages/hospital_core`, vendored from
[Dev_Central](https://github.com/LucaProcaryote/Dev_Central). Refresh it with
`./tools/sync_core.sh`.

## Pointing it somewhere else

The five URLs default to the hosted sites, so the portal works with no
configuration. Both of the suite's usual override routes apply.

At build time:

```bash
flutter run -d chrome --dart-define=EHR_URL=http://localhost:8081
```

Per visitor — this is what makes a lab session work. A student running the
`docker-compose` stack on their own machine opens the hosted portal with their
own URLs, and every link on the page points at their laptop:

```
https://my-hospital-2026.web.app/?ehr=http://localhost:8081&adt=http://localhost:8082
```

`?backend=` and `?auth=` are carried onto every link, so the whole hospital can
be switched to a real backend from one place. `?api=` is deliberately **not**
carried: each application has its own API service, and forwarding one shared
value would send four of the five to the wrong database.

The device buttons append `?device=DEV1` … `?device=DEV10` to the simulator's
URL. Ten students, one deployment, no per-student build.

## Administration

The portal is also the way in to account management: an **Administration**
page that lists everybody who can sign in, and lets an administrator create
accounts, change roles, reset passwords, disable and delete.

It needs two things, and says which one is missing when it does not have them:

| | What it is | How to set it |
| --- | --- | --- |
| `ADMIN_API_URL` | the API service that mounts `/admin` | repository variable, or `?admin=<url>` |
| `FIREBASE_*` | the project the administrator signs in against | repository variables, as for the five applications |

Nothing privileged happens in this page. Setting a role means writing a custom
claim, which needs credentials no web build may hold, so the console asks the
server, carrying the administrator's own Firebase token, and the server checks
it again. See `Dev_Central/FIREBASE.md`, section 1.

## Running it

```bash
flutter pub get
flutter run -d chrome
```

```bash
flutter test          # 11 tests
flutter analyze
```

## Deploying

```bash
./tools/deploy_hosting.sh
```

Or push to `main`: `.github/workflows/deploy-hosting.yml` builds and publishes
it, given a `FIREBASE_SERVICE_ACCOUNT` secret. The portal goes on the
project's **default** Hosting site, which exists from the moment the Firebase
project does — unlike the five application sites, there is nothing to create.
