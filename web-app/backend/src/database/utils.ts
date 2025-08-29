// @ts-decheck

import * as config from '../utils/config';
import fs from 'fs';
import initSqlJs from 'sql.js';
import * as path from 'path';

// Database constants and global variables
const DBNotPresent = -1;
const DBUsersTables = 1;
const DBClustersTables = 2;
const DBDeploymentsTables = 3;
const DBuserclusterMapTables = 4;
const maxDBVersion = DBuserclusterMapTables;  // this needs to be the version variable 
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

const initializeUsersTable = (db: any, dbUpgradeNeeded: boolean, updateToVersion: number) => {
  if (!dbUpgradeNeeded) {
    return 0;
  }

  switch (updateToVersion) {
    case DBUsersTables: {
      try {
        const initUsersTable = `
          CREATE TABLE IF NOT EXISTS users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user TEXT NOT NULL,
              guid TEXT UNIQUE NOT NULL,
              token TEXT,
              email TEXT NOT NULL
          );`;
        /*const initUsersTableIndex = `
            CREATE INDEX IF NOT EXISTS index_userId_teams ON users (userId);`;*/
        console.log('Going to create users table.');
        db.exec(initUsersTable);
        //db.exec(initUsersTableIndex);
      } catch (err) {
        console.log('Failed to execute initTeamsTable, error: ' + err);
        return -1;
      }

    }
  }
  return 0;
};

const initializeClustersTable = (db: any, dbUpgradeNeeded: boolean, updateToVersion: number) => {
  if (!dbUpgradeNeeded) {
    return 0;
  }

  switch (updateToVersion) {
    case DBClustersTables: {
      try {
        const initClustersTable = `
          CREATE TABLE IF NOT EXISTS clusters (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              cluster_guid TEXT UNIQUE NOT NULL,
              name TEXT NOT NULL,
              provider TEXT
          );`;
        /*const initTeamsTableTeamIdIndex = `
          CREATE INDEX IF NOT EXISTS index_teamId_teams ON teams (teamId);`;*/
        console.log('Going to create clusters table.');
        db.exec(initClustersTable);
        //db.exec(initTeamsTableTeamIdIndex);
      } catch (err) {
        console.log('Failed to execute initTeamsTable, error: ' + err);
        return -1;
      }

    }
  }

  return 0;
};

const initializeDeploymentsTable = (db: any, dbUpgradeNeeded: boolean, updateToVersion: number) => {
  if (!dbUpgradeNeeded) {
    return 0;
  }

  switch (updateToVersion) {
    case DBDeploymentsTables: {
      try {
        const initDeploymentsTable = `
          CREATE TABLE IF NOT EXISTS deployments (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              cluster_id INTEGER NOT NULL,
              name TEXT NOT NULL,
              model TEXT NOT NULL,
              enabled BOOLEAN NOT NULL,
              min_replicas INTEGER NOT NULL,
              max_replicas INTEGER NOT NULL,
              hpa_available BOOLEAN NOT NULL,
              hpa_name TEXT,
              target_spec_name TEXT,
              FOREIGN KEY (cluster_id) REFERENCES clusters(id)
          );`;
        /*const initTeamsTableTeamIdIndex = `
          CREATE INDEX IF NOT EXISTS index_teamId_teams ON teams (teamId);`;*/
        console.log('Going to create deployments table.');
        db.exec(initDeploymentsTable);
        //db.exec(initTeamsTableTeamIdIndex);
      } catch (err) {
        console.log('Failed to execute initTeamsTable, error: ' + err);
        return -1;
      }

    }
  }

  return 0;
}

const initializeuser_cluster_mapTable = (db: any, dbUpgradeNeeded: boolean, updateToVersion: number) => {
  if (!dbUpgradeNeeded) {
    return 0;
  }

  switch (updateToVersion) {
    case DBuserclusterMapTables: {
      try {
        const inituser_cluster_mapTable = `
          CREATE TABLE IF NOT EXISTS user_cluster_map (
            user_id INTEGER NOT NULL,
            cluster_id INTEGER NOT NULL,
            PRIMARY KEY (user_id, cluster_id),
            FOREIGN KEY (user_id) REFERENCES users(id),
            FOREIGN KEY (cluster_id) REFERENCES clusters(id)
        );`;
        /*const initTeamsTableTeamIdIndex = `
          CREATE INDEX IF NOT EXISTS index_teamId_teams ON teams (teamId);`;*/
        console.log('Going to create user_cluster_map table.');
        db.exec(inituser_cluster_mapTable);
        //db.exec(initTeamsTableTeamIdIndex);
      } catch (err) {
        console.log('Failed to execute user_cluster_map, error: ' + err);
        return -1;
      }

    }
  }

  return 0;
}


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
    // need to download .db file from provider and add it to database/db.db
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

export const upgradeOrInitializeTables = async (db: any, dbUpgradeNeeded: boolean, updateFromVersion: number, updateToVersion: number) => {

  try {
    let dbInitFailed = false;

    let updatingToVersion = updateFromVersion + 1;

    console.log('DB upgrade from version ' + updateFromVersion + ' to version ' + updateToVersion);

    while (updatingToVersion <= updateToVersion) {
      console.log('DB upgrade to version ' + updatingToVersion);
      let dbInit = 0;

      dbInit = await initializeUsersTable(db, dbUpgradeNeeded, updatingToVersion);
      if (dbInit != 0) {
        console.error('initializeUsersTable failed with ' + dbInit);
        dbInitFailed = true;
        /*if (allowDBRecreatedOnFailure) {
          return -2;
        }*/
      }

      dbInit = await initializeClustersTable(db, dbUpgradeNeeded, updatingToVersion);
      if (dbInit != 0) {
        console.error('initializeclustersTable failed with ' + dbInit);
        dbInitFailed = true;
        /*if (allowDBRecreatedOnFailure) {
          return -2;
        }*/
      }

      dbInit = await initializeDeploymentsTable(db, dbUpgradeNeeded, updatingToVersion);
      if (dbInit != 0) {
        console.error('initializedeploymentsTable failed with ' + dbInit);
        dbInitFailed = true;
        /*if (allowDBRecreatedOnFailure) {
          return -2;
        }*/
      }

      dbInit = await initializeuser_cluster_mapTable(db, dbUpgradeNeeded, updatingToVersion);
      if (dbInit != 0) {
        console.error('initializedeploymentsTable failed with ' + dbInit);
        dbInitFailed = true;
        /*if (allowDBRecreatedOnFailure) {
          return -2;
        }*/
      }
      updatingToVersion++;
    }
  } catch (e) {

  }
}


export const initializeDatabase = async (dbtype: string) => {
  ensureLocalPath();
  await openDB(dbtype);
  // Perform initialization and upgrades.
  const dbInitUpgrade = initializeVersionTableAndCheckUpgrade(db);
  const isDBUpgradeNeeded = dbInitUpgrade.isDBUpgradeNeeded;
  const updateFromVersion: any = dbInitUpgrade.updateFromVersion;


  console.log('borororo')

  console.log('borororo')

  console.log('borororo')
  console.log(dbInitUpgrade)
  if (isDBUpgradeNeeded) {
    console.log('DB update is needed. Upgrading from version ' + updateFromVersion + ' to ' + maxDBVersion);
    //initializeUsersTable(db, isDBUpgradeNeeded, updateFromVersion);
    const initResult = await upgradeOrInitializeTables(
      db,
      isDBUpgradeNeeded,
      updateFromVersion,
      maxDBVersion
    );
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

// save database backup in bucket 
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

async function executeInsertAsync(tableName: string, query: string, data: string[]) {
  const db = getDB();
  try {
    await db.run(query, data);
    return 0;
  } catch (error: any) {
    console.error('Insert failed with ' + error.message + ' for query ' + query + ' data: [' + data + ']');
    return error;
  }
}

export const execInsertUser = async (user: string, guid: string, token: string, email: string) => {
  console.log('Inserting user: ', user, ' - with email: ', email, ' - and guid: ', guid);
  let dbResult = await executeInsertAsync(
    'users',
    'INSERT INTO users(user, guid, token, email) VALUES(?, ?, ?, ?)',
    [user, guid, token, email]
  );
  return dbResult;
}

export const getTable = async (table: string) => {
  try {
    const db = getDB();
    const query = `SELECT * FROM ${table};`;
    const res = db.exec(query);
    if (res.length > 0) {
      const rows = res[0].values.map((row: any[]) => {
        const rowObject: { [key: string]: any } = {};
        res[0].columns.forEach((colName: string, index: number) => {
          rowObject[colName] = row[index];
        });
        return rowObject;
      });
      return rows;
    } else {
      console.log('No data found.');
      return [];
    }
  } catch (err: any) {
    console.error(`Failed to get data from table '${table}':`, err.message);
    return [];
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
