# EduCare Backend

Node 18+, Express, and SQLite (through `sql.js`).

## Run

```powershell
cd backend
npm install
npm start
```

The API listens on `http://127.0.0.1:3000` and creates
`backend/data/educare.sqlite`.

The seeded development login is the same one shown in the Flutter login form.

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
