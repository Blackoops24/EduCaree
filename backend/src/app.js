const crypto = require('node:crypto');
const express = require('express');

const now = () => new Date().toISOString();
const validKey = (value) => /^[a-z][a-z0-9_-]{1,63}$/i.test(value);

function hashPassword(password, salt = crypto.randomBytes(16).toString('hex')) {
  const hash = crypto.pbkdf2Sync(password, salt, 120000, 32, 'sha256').toString('hex');
  return { hash, salt };
}

function createApp(database) {
  const app = express();
  app.disable('x-powered-by');
  app.use(express.json({ limit: '2mb' }));
  app.use((request, response, next) => {
    response.setHeader('Access-Control-Allow-Origin', request.headers.origin ?? '*');
    response.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    response.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    if (request.method === 'OPTIONS') return response.sendStatus(204);
    next();
  });

  app.get('/health', (_request, response) => response.json({ status: 'ok', database: 'sqlite' }));

  app.post('/auth/register', (request, response) => {
    const { name, email, password, category = 'Staff', role = 'Admin' } = request.body ?? {};
    if (!name?.trim() || !email?.trim() || typeof password !== 'string' || password.length < 8) {
      return response.status(400).json({ error: 'Name, valid email, and an 8-character password are required.' });
    }
    if (database.get('SELECT id FROM users WHERE email = ?', [email.trim()])) {
      return response.status(409).json({ error: 'Email is already registered.' });
    }
    const credentials = hashPassword(password);
    const timestamp = now();
    const id = database.run(
      'INSERT INTO users(name,email,password_hash,password_salt,category,role,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?)',
      [name.trim(), email.trim(), credentials.hash, credentials.salt, category, role, timestamp, timestamp],
    );
    database.persist();
    return response.status(201).json({ id, name: name.trim(), email: email.trim(), category, role });
  });

  app.get('/auth/users', (_request, response) => {
    return response.json(database.all('SELECT id,name,email,category,role FROM users ORDER BY id'));
  });

  app.put('/auth/users/:id', (request, response) => {
    const id = Number(request.params.id);
    const { name, email, category, role } = request.body ?? {};
    if (!Number.isInteger(id) || !name?.trim() || !email?.trim() || !category || !role) {
      return response.status(400).json({ error: 'Complete user details are required.' });
    }
    database.run(
      'UPDATE users SET name = ?, email = ?, category = ?, role = ?, updated_at = ? WHERE id = ?',
      [name.trim(), email.trim(), category, role, now(), id],
    );
    database.persist();
    const user = database.get('SELECT id,name,email,category,role FROM users WHERE id = ?', [id]);
    return user ? response.json(user) : response.status(404).json({ error: 'User not found.' });
  });

  app.delete('/auth/users/:id', (request, response) => {
    const id = Number(request.params.id);
    if (!database.get('SELECT id FROM users WHERE id = ?', [id])) {
      return response.status(404).json({ error: 'User not found.' });
    }
    database.run('DELETE FROM users WHERE id = ?', [id]);
    database.persist();
    return response.status(204).send();
  });

  app.post('/auth/login', (request, response) => {
    const { email, password } = request.body ?? {};
    const user = database.get('SELECT * FROM users WHERE email = ?', [email?.trim() ?? '']);
    if (!user || hashPassword(password ?? '', user.password_salt).hash !== user.password_hash) {
      return response.status(401).json({ error: 'Invalid email or password.' });
    }
    const token = crypto.randomBytes(32).toString('hex');
    database.run('UPDATE users SET token = ?, updated_at = ? WHERE id = ?', [token, now(), user.id]);
    database.persist();
    return response.json({ id: user.id, name: user.name, email: user.email, token, category: user.category, role: user.role });
  });

  app.put('/auth/profile/:id', (request, response) => {
    const id = Number(request.params.id);
    const { name, email } = request.body ?? {};
    if (!Number.isInteger(id) || !name?.trim() || !email?.trim()) return response.status(400).json({ error: 'Valid profile fields are required.' });
    database.run('UPDATE users SET name = ?, email = ?, updated_at = ? WHERE id = ?', [name.trim(), email.trim(), now(), id]);
    database.persist();
    const user = database.get('SELECT id,name,email,category,role FROM users WHERE id = ?', [id]);
    return user ? response.json(user) : response.status(404).json({ error: 'User not found.' });
  });

  app.post('/auth/change-password', (request, response) => {
    const { email, currentPassword, newPassword } = request.body ?? {};
    const user = database.get('SELECT * FROM users WHERE email = ?', [email?.trim() ?? '']);
    if (!user || hashPassword(currentPassword ?? '', user.password_salt).hash !== user.password_hash) {
      return response.status(400).json({ error: 'Current password is incorrect.' });
    }
    if (typeof newPassword !== 'string' || newPassword.length < 8) {
      return response.status(400).json({ error: 'New password must contain at least 8 characters.' });
    }
    const credentials = hashPassword(newPassword);
    database.run('UPDATE users SET password_hash = ?, password_salt = ?, updated_at = ? WHERE id = ?', [credentials.hash, credentials.salt, now(), user.id]);
    database.persist();
    return response.status(204).send();
  });

  app.use('/api', (request, response, next) => {
    const token = request.headers.authorization?.replace(/^Bearer\s+/i, '');
    if (!token || !database.get('SELECT id FROM users WHERE token = ?', [token])) {
      return response.status(401).json({ error: 'Authentication required.' });
    }
    next();
  });

  app.get('/api/state/:module', (request, response) => {
    if (!validKey(request.params.module)) return response.status(400).json({ error: 'Invalid module key.' });
    const row = database.get('SELECT payload,version,updated_at FROM module_state WHERE module_key = ?', [request.params.module]);
    if (!row) return response.status(404).json({ error: 'Module state not found.' });
    return response.json({ data: JSON.parse(row.payload), version: row.version, updatedAt: row.updated_at });
  });

  app.put('/api/state/:module', (request, response) => {
    if (!validKey(request.params.module) || typeof request.body?.data !== 'object' || Array.isArray(request.body.data)) {
      return response.status(400).json({ error: 'A valid module key and data object are required.' });
    }
    const existing = database.get('SELECT version FROM module_state WHERE module_key = ?', [request.params.module]);
    const version = Number(existing?.version ?? 0) + 1;
    database.run(
      `INSERT INTO module_state(module_key,payload,version,updated_at) VALUES(?,?,?,?)
       ON CONFLICT(module_key) DO UPDATE SET payload=excluded.payload,version=excluded.version,updated_at=excluded.updated_at`,
      [request.params.module, JSON.stringify(request.body.data), version, now()],
    );
    database.persist();
    return response.json({ data: request.body.data, version });
  });

  app.get('/api/records/:resource', (request, response) => {
    if (!validKey(request.params.resource)) return response.status(400).json({ error: 'Invalid resource.' });
    const rows = database.all('SELECT id,data,created_at,updated_at FROM records WHERE resource = ? ORDER BY id', [request.params.resource]);
    return response.json(rows.map((row) => ({ id: row.id, ...JSON.parse(row.data), createdAt: row.created_at, updatedAt: row.updated_at })));
  });

  app.post('/api/records/:resource', (request, response) => {
    if (!validKey(request.params.resource) || typeof request.body !== 'object' || Array.isArray(request.body)) {
      return response.status(400).json({ error: 'Valid resource data is required.' });
    }
    const timestamp = now();
    const id = database.run('INSERT INTO records(resource,data,created_at,updated_at) VALUES(?,?,?,?)', [request.params.resource, JSON.stringify(request.body), timestamp, timestamp]);
    database.persist();
    return response.status(201).json({ id, ...request.body, createdAt: timestamp, updatedAt: timestamp });
  });

  app.put('/api/records/:resource/:id', (request, response) => {
    const id = Number(request.params.id);
    if (!validKey(request.params.resource) || !Number.isInteger(id) || typeof request.body !== 'object') {
      return response.status(400).json({ error: 'Valid resource data is required.' });
    }
    const existing = database.get('SELECT id FROM records WHERE id = ? AND resource = ?', [id, request.params.resource]);
    if (!existing) return response.status(404).json({ error: 'Record not found.' });
    database.run('UPDATE records SET data = ?, updated_at = ? WHERE id = ? AND resource = ?', [JSON.stringify(request.body), now(), id, request.params.resource]);
    database.persist();
    return response.json({ id, ...request.body });
  });

  app.delete('/api/records/:resource/:id', (request, response) => {
    const id = Number(request.params.id);
    const existing = database.get('SELECT id FROM records WHERE id = ? AND resource = ?', [id, request.params.resource]);
    if (!existing) return response.status(404).json({ error: 'Record not found.' });
    database.run('DELETE FROM records WHERE id = ? AND resource = ?', [id, request.params.resource]);
    database.persist();
    return response.status(204).send();
  });

  app.use((error, _request, response, _next) => {
    console.error(error);
    response.status(500).json({ error: 'Internal server error.' });
  });
  return app;
}

function seedDemoUser(database) {
  if (database.get('SELECT id FROM users WHERE email = ?', ['testing@educaree.com'])) return;
  const credentials = hashPassword('testing@2026');
  const timestamp = now();
  database.run(
    'INSERT INTO users(name,email,password_hash,password_salt,category,role,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?)',
    ['EduCare Tester', 'testing@educaree.com', credentials.hash, credentials.salt, 'Admin', 'Super Admin', timestamp, timestamp],
  );
  database.persist();
}

module.exports = { createApp, seedDemoUser };
