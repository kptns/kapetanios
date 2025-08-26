// @ts-decheck

import * as config from '../utils/config';
import fs from 'fs';
import initSqlJs from 'sql.js';
import * as path from 'path';

// Database constants and global variables
const DBNotPresent = -1;
const DBInitialTables = 1;
const maxDBVersion = DBInitialTables;
const dbLocalPath = config.get('KAPETANIOS_DATABASEPATH') || 'database/';
const dbFullFilename = path.join(dbLocalPath, 'Kapetanios.db');

var db: any = null; // The global database instance
var SQL: any = null; // The global sql.js instance

// --- Helper Functions ---

/**
 * Ensures the local database directory exists. If not, it creates it.
 */
const ensureLocalPath = () => {
  !fs.existsSync(dbLocalPath) && fs.mkdirSync(dbLocalPath, { recursive: true });

};

/**
 * Initializes the 'teams' table if a database upgrade is needed.
 */
const initializeTeamsTable = (db: any, dbUpgradeNeeded: boolean, updateToVersion: number) => {
  if (!dbUpgradeNeeded) {
    return 0;
  }
  if (updateToVersion === DBNotPresent || updateToVersion < DBInitialTables) {
    const initClustersTable = `
      CREATE TABLE IF NOT EXISTS clusters (
        id INTEGER PRIMARY KEY NOT NULL,
        cluster TEXT,
        provider TEXT,
        token TEXT
      );`;
    /*const initTeamsTableTeamIdIndex = `
      CREATE INDEX IF NOT EXISTS index_teamId_teams ON teams (teamId);`;*/
    try {
      console.log('Going to create clusters table.');
      db.exec(initClustersTable);
      //db.exec(initTeamsTableTeamIdIndex);
    } catch (err) {
      console.log('Failed to execute initTeamsTable, error: ' + err);
      return -1;
    }
  }
  return 0;
};

/**
 * Checks the database version and determines if an upgrade is necessary.
 */
const initializeVersionTableAndCheckUpgrade = (db: any) => {
  let updateFromVersion = DBNotPresent;
  let isDBUpgradeNeeded = false;
  const initVersionTable = `
    CREATE TABLE IF NOT EXISTS version (
      id INTEGER PRIMARY KEY NOT NULL,
      availableSince TEXT
    );`;
  try {
    console.log('Going to ensure version table.');
    db.exec(initVersionTable);
  } catch (err) {
    console.error('Failed to execute initVersionTable, error: ' + err);
    return { result: -1, isDBUpgradeNeeded: null, updateFromVersion: null };
  }
  try {
    const statement = db.prepare(`SELECT MAX(id) AS maxVersion FROM version`);
    const dbSelect = statement.get();
    statement.free();
    if (!dbSelect) {
      console.error('Failed to get data from db - version.');
      return { result: -2, isDBUpgradeNeeded: null, updateFromVersion: null };
    }
    if (dbSelect.maxVersion === null || dbSelect.maxVersion === undefined) {
      console.log('Max db version is not defined. Need to create whole db.');
      isDBUpgradeNeeded = true;
      updateFromVersion = DBNotPresent;
    } else {
      console.log('Max db version is ' + dbSelect.maxVersion + ', current code has db version ' + maxDBVersion);
      if (maxDBVersion > dbSelect.maxVersion) {
        isDBUpgradeNeeded = true;
        updateFromVersion = dbSelect.maxVersion;
      } else if (maxDBVersion < dbSelect.maxVersion) {
        console.error('Server code db version ' + maxDBVersion + ' is smaller than database version ' + dbSelect.maxVersion);
      }
    }
  } catch (err) {
    console.error('Failed to get data from version table, error: ' + err);
    return { result: -2, isDBUpgradeNeeded: null, updateFromVersion: null };
  }
  return { result: 0, isDBUpgradeNeeded: isDBUpgradeNeeded, updateFromVersion: updateFromVersion };
};

const openDB = async (dbtype: string) => {
  if (dbtype !== 'local') {
    console.log('Database type is not local. Using cloud provider storage.');
    // need to download db from provider and add it to database/db.db
  }
  else {
    console.log('going to create this file ??? ')
    if (!fs.existsSync(dbFullFilename)) {
      fs.writeFileSync(dbFullFilename, '');
    }
  }

  // Ensure sql.js is initialized
  if (SQL === null) {
    SQL = await initSqlJs({
      locateFile: file => `node_modules/sql.js/dist/${file}`
    });
  }

  try {
    const fileBuffer = fs.readFileSync(dbFullFilename);
    db = new SQL.Database(fileBuffer);
    console.log('Existing database (' + dbFullFilename + ') opened.');
  } catch (err) {
    console.error('Failed to open existing database or it is not a valid SQLite file. Creating a new one.', err);
    db = new SQL.Database();
    console.log('New in-memory database created.');
  }
}

export const initializeDatabase = async (dbtype: string) => {
  ensureLocalPath();
  await openDB(dbtype);
  // Perform initialization and upgrades.
  const dbInitUpgrade = initializeVersionTableAndCheckUpgrade(db);
  const isDBUpgradeNeeded = dbInitUpgrade.isDBUpgradeNeeded;
  const updateFromVersion = dbInitUpgrade.updateFromVersion;
  if (isDBUpgradeNeeded) {
    console.log('DB update is needed. Upgrading from version ' + updateFromVersion + ' to ' + maxDBVersion);
    initializeTeamsTable(db, isDBUpgradeNeeded, updateFromVersion);
  } else {
    console.log('DB version (' + maxDBVersion + ') is up to date.');
  }
};

/**
 * Gets the current database instance. This is your "login" function.
 * Call this whenever you need to perform a database operation.
 * @returns The global sql.js database instance.
 */
export const getDB = () => {
  if (!db) {
    throw new Error('Database not initialized. Call initializeDatabase first.');
  }
  return db;
};


const saveIntervalMinutes = 5;
setInterval(() => {
  saveBackup();
},
  //saveIntervalMinutes * 60 * 1000);
  10000);

export const saveBackup = () => {
  // if not local, save in S3 or alibaba storage
  if (!db) {
    console.warn('Cannot finish database. It is not open.');
    return;
  }
  try {
    const data = db.export();
    const buffer = Buffer.from(data);
    fs.writeFileSync(dbFullFilename, buffer);
    // Remove these two lines:
    // db.close();
    // db = null;
    console.log('Database saved');
  } catch (err) {
    console.error('Failed to save and close the database:', err);
  }
};

export const listTables = () => {
  try {
    const db = getDB();
    const query = `SELECT name FROM sqlite_master WHERE type='table';`;
    const statement = db.prepare(query);
    const tables = [];
    while (statement.step()) {
      tables.push(statement.get()[0]);
    }
    statement.free();
    return tables;
  } catch (err) {
    console.error('Failed to list tables:', err);
    return [];
  }
};
