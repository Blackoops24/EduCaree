const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');
const { Database } = require('../src/database');
const { createApp, seedDemoUser } = require('../src/app');

async function withServer(run) {
  const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'educare-api-'));
  const database = await Database.open(path.join(directory, 'test.sqlite'));
  seedDemoUser(database);
  const server = createApp(database).listen(0, '127.0.0.1');
  await new Promise((resolve) => server.once('listening', resolve));
  const address = server.address();
  try {
    await run(`http://127.0.0.1:${address.port}`);
  } finally {
    await new Promise((resolve) => server.close(resolve));
    database.close();
    fs.rmSync(directory, { recursive: true, force: true });
  }
}

test('health, login, module persistence, and record CRUD', async () => {
  await withServer(async (baseUrl) => {
    const health = await fetch(`${baseUrl}/health`).then((response) => response.json());
    assert.equal(health.status, 'ok');

    const loginResponse = await fetch(`${baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ email: 'testing@educaree.com', password: 'testing@2026' }),
    });
    assert.equal(loginResponse.status, 200);
    const token = (await loginResponse.json()).token;
    assert.ok(token);
    const authorization = { authorization: `Bearer ${token}` };

    const saveState = await fetch(`${baseUrl}/api/state/students`, {
      method: 'PUT',
      headers: { 'content-type': 'application/json', ...authorization },
      body: JSON.stringify({ data: { students: [{ name: 'Test Student' }] } }),
    });
    assert.equal(saveState.status, 200);
    const state = await fetch(`${baseUrl}/api/state/students`, { headers: authorization }).then((response) => response.json());
    assert.equal(state.data.students[0].name, 'Test Student');

    const created = await fetch(`${baseUrl}/api/records/events`, {
      method: 'POST',
      headers: { 'content-type': 'application/json', ...authorization },
      body: JSON.stringify({ title: 'Assembly' }),
    }).then((response) => response.json());
    assert.ok(created.id);

    const updated = await fetch(`${baseUrl}/api/records/events/${created.id}`, {
      method: 'PUT',
      headers: { 'content-type': 'application/json', ...authorization },
      body: JSON.stringify({ title: 'Updated Assembly' }),
    });
    assert.equal(updated.status, 200);
    const records = await fetch(`${baseUrl}/api/records/events`, { headers: authorization }).then((response) => response.json());
    assert.equal(records[0].title, 'Updated Assembly');

    const deleted = await fetch(`${baseUrl}/api/records/events/${created.id}`, { method: 'DELETE', headers: authorization });
    assert.equal(deleted.status, 204);
  });
});
