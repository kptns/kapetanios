//import { ensureDatabase } from "./initialize";
import packageJson from '../../package.json';
import * as dbutils from './utils'
import * as config from '../utils/config';
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
  app.get('/api/sql/tables', async (req: any, res: any) => {
    const tables = await dbutils.listTables();
    console.log(tables)
    res.send('version');
  });

  app.post('/api/sql/insert/user', async (req: any, res: any) => {
    const user = req.body?.user;

    //generate guid 
    const tables = await dbutils.execInsertUser();
    res.send('version');
  });
}