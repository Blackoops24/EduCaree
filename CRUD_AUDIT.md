# EduCare CRUD Audit

Audit date: 2026-06-27

The current application is a demo client: management records are stored in widget
state and reset when the application restarts. The checks below cover functional
UI/state CRUD. Durable CRUD requires connecting these flows to the REST backend.

| Module | Records checked | Create | Read | Update | Delete |
|---|---|:---:|:---:|:---:|:---:|
| Authentication | User registration | Yes | Yes | Yes | Yes |
| Students | Admissions and profiles | Yes | Yes | Yes | Yes |
| Students | Documents and photos | Yes | Yes | Yes | Yes |
| Students | Parent details | N/A | Yes | Yes | N/A |
| Students | Promotions | Yes | Yes | Yes | Yes |
| Students | Transfer certificates | Generate | Yes | N/A | Revoke |
| Students | Alumni | Yes | Yes | Yes | Yes |
| Staff | Employees and profiles | Yes | Yes | Yes | Yes |
| Staff | Leave, attendance, performance | Yes | Yes | Yes | Yes |
| Staff | Salary records | Yes | Yes | Yes | Yes |
| Academics | Classes, sections, subjects | Yes | Yes | Yes | Yes |
| Academics | Timetables and exams | Yes | Yes | Yes | Yes |
| Academics | Marks and report cards | Yes | Yes | Yes | Yes |
| Attendance | Student and staff attendance | Yes | Yes | Yes | Yes |
| Attendance | Biometric and face records | Yes | Yes | Yes | Yes |
| Fees | Structures, categories, installments | Yes | Yes | Yes | Yes |
| Fees | Collections | Yes | Yes | Yes | Yes |
| Fees | Payment gateway settings | Fixed set | Yes | Yes | N/A |
| Library | Categories and books | Yes | Yes | Yes | Yes |
| Library | Issues, returns, and fines | Yes | Yes | Yes | Yes |
| Transport | Vehicles, drivers, routes | Yes | Yes | Yes | Yes |
| Transport | Student allocations | Yes | Yes | Yes | Yes |
| Inventory | Assets and equipment | Yes | Yes | Yes | Yes |
| Inventory | Stock movements | Yes | Yes | Yes | Yes |
| Notifications | Channels and alert types | Yes | Yes | Yes | Yes |
| Messages | Internal messages | Yes | Yes | Yes | Yes |
| Calendar | Events | Yes | Yes | Yes | Yes |
| Access control | Role access profiles | Yes | Yes | Yes | Yes |
| Account | Current-user profile/settings | N/A | Yes | Yes | N/A |

## Verification

- `flutter analyze`: no issues.
- `flutter test`: six tests passed.
- Static scan: no empty `onPressed` handlers, TODO CRUD handlers, or
  `UnimplementedError` placeholders remain under `lib/`.
