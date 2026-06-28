const path = require('node:path');
const { Database } = require('./database');
const { createApp, seedDemoUser } = require('./app');

async function start() {
  const port = Number(process.env.PORT ?? 3000);
  const databasePath = process.env.DATABASE_PATH ?? path.join(__dirname, '..', 'data', 'educare.sqlite');
  const database = await Database.open(databasePath);
  seedDemoUser(database);
  const server = createApp(database).listen(port, '127.0.0.1', () => {
    console.log(`EduCare API listening on http://127.0.0.1:${port}`);
    console.log(`SQLite database: ${databasePath}`);
  });
  const shutdown = () => server.close(() => {
    database.close();
    process.exit(0);
  });
  process.on('SIGINT', shutdown);
  process.on('SIGTERM', shutdown);
}

start().catch((error) => {
  console.error(error);
  process.exit(1);
});
