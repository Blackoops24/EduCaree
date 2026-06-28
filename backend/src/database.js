const fs = require('node:fs');
const path = require('node:path');
const initSqlJs = require('sql.js');

class Database {
  constructor(db, filePath) {
    this.db = db;
    this.filePath = filePath;
  }

  static async open(filePath) {
    const SQL = await initSqlJs({
      locateFile: (file) => require.resolve(`sql.js/dist/${file}`),
    });
    fs.mkdirSync(path.dirname(filePath), { recursive: true });
    const bytes = fs.existsSync(filePath) ? fs.readFileSync(filePath) : undefined;
    const database = new Database(new SQL.Database(bytes), filePath);
    database.migrate();
    return database;
  }

  migrate() {
    this.db.run(`
      PRAGMA foreign_keys = ON;
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE COLLATE NOCASE,
        password_hash TEXT NOT NULL,
        password_salt TEXT NOT NULL,
        category TEXT NOT NULL DEFAULT 'Staff',
        role TEXT NOT NULL DEFAULT 'Admin',
        token TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      );
      CREATE TABLE IF NOT EXISTS module_state (
        module_key TEXT PRIMARY KEY,
        payload TEXT NOT NULL,
        version INTEGER NOT NULL DEFAULT 1,
        updated_at TEXT NOT NULL
      );
      CREATE TABLE IF NOT EXISTS records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        resource TEXT NOT NULL,
        data TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      );
      CREATE INDEX IF NOT EXISTS idx_records_resource ON records(resource);
    `);
    this.persist();
  }

  run(sql, params = []) {
    this.db.run(sql, params);
    return this.db.exec('SELECT last_insert_rowid() AS id')[0]?.values[0][0];
  }

  all(sql, params = []) {
    const statement = this.db.prepare(sql);
    statement.bind(params);
    const rows = [];
    while (statement.step()) rows.push(statement.getAsObject());
    statement.free();
    return rows;
  }

  get(sql, params = []) {
    return this.all(sql, params)[0] ?? null;
  }

  persist() {
    const temporary = `${this.filePath}.tmp`;
    fs.writeFileSync(temporary, Buffer.from(this.db.export()));
    fs.copyFileSync(temporary, this.filePath);
    fs.unlinkSync(temporary);
  }

  close() {
    this.persist();
    this.db.close();
  }
}

module.exports = { Database };
