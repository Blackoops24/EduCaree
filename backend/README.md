# EduCare Backend

Node 18+, Express, and SQLite (through `sql.js`).

## First-time setup

```powershell
cd backend
npm install
```

`npm install` is required before `npm start` or `npm test`; the API uses the `sql.js` package for SQLite-backed persistence.

## Run

```powershell
cd backend
npm start
```

The API listens on `http://127.0.0.1:3000` and creates
`backend/data/educare.sqlite`.

## Seeded login

The first server start seeds the same development login shown in the Flutter login form:

- Email: `testing@educaree.com`
- Password: `testing@2026`

If you delete `backend/data/educare.sqlite`, the next start recreates the database and reseeds that account.

## Test

```powershell
cd backend
npm test
```

## Endpoints

- `GET /health`
- `POST /auth/login`
- `POST /auth/register`
- `PUT /auth/profile/:id`
- `POST /auth/change-password`
- `GET|PUT /api/state/:module`
- `GET|POST /api/records/:resource`
- `PUT|DELETE /api/records/:resource/:id`

Set `DATABASE_PATH` or `PORT` to override the defaults.
