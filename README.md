# EduCare

EduCare is a Flutter-based School ERP application with a clean architecture, MVVM structure, Riverpod state management, Go Router navigation, and support for Android, iOS, and Web.

## Project Structure

- `android/` - Android platform project files.
- `ios/` - iOS platform project files.
- `web/` - Web platform build targets.
- `lib/` - Main Flutter application code.
  - `core/` - Shared application layers:
    - `constants/` - Route names and app constants.
    - `network/` - Network utilities and API setup.
    - `services/` - Core services such as API and auth.
    - `theme/` - App theming and Material 3 configuration.
    - `utils/` - Shared utilities like responsive helpers.
    - `widgets/` - Reusable UI widgets.
  - `database/` - Data storage and persistence helpers.
  - `features/` - Feature modules split by domain and clean architecture:
    - `authentication/` - Login, auth entities, repository, and viewmodels.
    - `dashboard/` - Dashboard use cases, pages, and components.
    - `students/` - Student management, admission, profile, documents, transfer certificate, alumni.
    - `staff/` - Staff management, registration, profile, leave, attendance, performance, salary.
    - `fees/`, `inventory/`, `library/`, `notifications/`, `reports/`, `transport/` - placeholder modules for future ERP features.
  - `models/` - Shared data models used across the app.
  - `repositories/` - Shared repository interfaces or base repository implementations.
  - `routes/` - App routing configuration using Go Router.
- `test/` - Unit and widget tests.
- `assets/` - Fonts, icons, and image assets.

## Architecture

EduCare uses a layered clean architecture approach with the following patterns:

- `presentation` - UI pages, widgets, and state management.
- `domain` - Entities, repositories, and use cases.
- `data` - Data sources, models, and repository implementations.
- Riverpod for dependency injection and state management.
- Go Router for declarative routing.
- Responsive design helpers for multiple screen sizes.

## Key Features

- Authentication with login flow.
- Student management module with admission, profile, documents, transfer certificate, and alumni handling.
- Staff management module with employee registration, profile, leave management, attendance tracking, performance reviews, and salary details.

## Requirements

- Flutter SDK (latest stable recommended)
- Dart SDK compatible with Flutter
- Android SDK / Xcode for mobile builds
- Chrome or Edge for web builds

## Setup and Execution

1. Clone the repository:

```bash
git clone <repository-url>
cd EduCare
```

2. Get dependencies:

```bash
flutter pub get
```

3. Install and start the backend API in a separate terminal:

```bash
cd backend
npm install
npm start
```

The login flow depends on the backend being available at `http://127.0.0.1:3000` by default. The backend seeds this development account on first start:

- Email: `testing@educaree.com`
- Password: `testing@2026`

If you run the API on a different host or port, pass it to Flutter with `--dart-define`, for example:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:3000
```

4. Run the app on a connected device or emulator:

```bash
flutter run
```

5. Run on a specific platform:

- Android:
  ```bash
  flutter run -d android
  ```
- iOS:
  ```bash
  flutter run -d ios
  ```
- Web:
  ```bash
  flutter run -d chrome
  ```

6. Analyze the project:

```bash
flutter analyze
```

7. Run tests:

```bash
flutter test
```

## Backend Integration

EduCare expects the bundled Node.js backend in `backend/` for authentication, module persistence, and record storage. Configure the base API URL with `--dart-define=API_BASE_URL=...` or adjust the default in `lib/core/services/api_service.dart`.

Example backend endpoints:

- `POST /auth/login` - Authenticate users and return a token.
- `GET /staff` - List all staff members.
- `POST /staff` - Register a new staff member.
- `GET /staff/{id}` - Fetch staff profile details.
- `GET /staff/{id}/leaves` - Fetch staff leave requests.
- `GET /staff/{id}/attendance` - Fetch attendance records.
- `GET /staff/{id}/performance` - Fetch performance reviews.
- `GET /staff/{id}/salary` - Fetch salary details.
- `GET /students` - List all students.
- `POST /students/admission` - Submit a student admission request.
- `GET /students/{id}` - Fetch student profile details.
- `GET /students/{id}/documents` - Fetch student documents.
- `GET /students/{id}/transfer-certificate` - Request transfer certificate details.
- `GET /students/alumni` - List alumni records.

Adjust request/response payloads to match the app's model fields and authentication flow.

## Notes

- Add backend base URL and authentication settings in `lib/core/services/api_service.dart` or environment config.
- Extend additional ERP modules such as fees, library, transport, and reports following existing feature patterns.
- Use centralized route constants in `lib/core/constants/app_constants.dart`.

## Contact

For questions or extension work, update the README with module-specific guidance and backend API information.
