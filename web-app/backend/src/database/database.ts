//import { ensureDatabase } from "./initialize";
import * as config from '../utils/config';
import crypto from 'crypto';
import * as dbutils from './utils'
import { generateToken } from '../auth/auth';
import packageJson from '../../package.json';


// Get the version from the imported object
const serverVersion = packageJson.version;


const start = async function () {
  console.log('Server starting with version ', serverVersion);
  try {
    const dbType = config.get('KAPETANIOS_STORAGE_TYPE');
    console.log('db type ', dbType);
    if (dbType == 'local') {
    }
    else {
      // sdk process.env.alibabaKey. donwload keys ?
    }

    await dbutils.initializeDatabase(dbType);
  } catch (e) {
    console.error('ERROR -  Trying to intialize DB', e);
  }
};
start();


export const register = (app: any) => {
  app.get('/api/sql/tables/all', async (req: any, res: any) => {
    const tables = await dbutils.listTables();
    console.log(tables)
    res.send('version');
  });

  app.get('/api/sql/tables/:table', async (req: any, res: any) => {
    const table = req.params.table;
    const jsonData = await dbutils.getTable(table);
    res.send(`${table} with length ${jsonData?.length}`);
  });

  app.post('/api/sql/insert/user', async (req: any, res: any) => {
    const user = req.body?.user;
    const guid = crypto.randomUUID();
    const token = generateToken(guid);
    const email = req.body.email;
    const dbexec = await dbutils.execInsertUser(user, guid, token, email);
    if (dbexec !== 0) {
      res.status(404).send('error'); // fix codes to return
    } else {
      res.status(200).send(`Success inserting ${user}`);
    }
  });
}