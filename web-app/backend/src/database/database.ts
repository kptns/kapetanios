//import { ensureDatabase } from "./initialize";
import { userByToken } from '../auth/auth';
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

  //cehck versions table to jump all steps when no needed! 

  app.get('/api/sql/tables/all', async (req: any, res: any) => {
    const tables = await dbutils.listTables();
    console.log(tables)
    res.send('version');
  });

  app.get('/api/sql/tables/:table', async (req: any, res: any) => {
    const table = req.params.table;
    const jsonData = await dbutils.getTable(table);

    console.log('erase this ')
    console.log(jsonData)
    console.log('erase this ')
    res.send(`${table} with length ${jsonData?.length}`);
  });

  app.post('/api/sql/insert/user', async (req: any, res: any) => {
    const user = req.body?.user;
    const guid = crypto.randomUUID();
    const token = generateToken(guid);
    const email = req.body.email;
    const dbexec = await dbutils.execInsertUser(user, guid, token, email);
    if (dbexec !== 0) {
      res.status(404).send('error'); // fix codes to return based on db errs
    } else {
      res.status(200).send(`Success inserting ${user}`);
    }
  });

  app.post('/api/sql/insert/cluster', userByToken, async (req: any, res: any) => {
    const user = req.user;
    const clusterName = req.body.cluster;
    const provider = req.body.provider;
    if (!clusterName || !provider || !user) {
      console.error('cluster || provider || user -> not exists')
      res.status(404).send('cluster || provider || user -> not exists')
      return;
    }
    const guid = crypto.randomUUID();
    const clusters = await dbutils.getClusterByUserId(user.id);
    const clusterExists = clusters.some((cluster: any) => cluster.name === clusterName);

    if (clusterExists) {
      res.status(200).send('cluster already exists');
      return;
    }
    const dbRes = await dbutils.execInsertCluster(guid, clusterName, provider, user.id)
    if (dbRes == 0) {
      res.status(200).send('cluster inserted correcty');
      return
    }
    else {
      res.status(404).send('cluster inserted correcty'); // need to handle right db errors
      return;
    }
  });
}