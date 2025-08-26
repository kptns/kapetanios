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
  /*try {


   if (Globals.IsAWSEnvironment) {
      console.log(
        'Running on AWS, IsAWSEnvironment is ' +
          Globals.IsAWSEnvironment +
          ' HAL9_ENV is ' +
          process.env.HAL9_ENV +
          '.'
      );

      var settingLength = 0;
      if (process.env.AWS_KEY != null) {
        settingLength = process.env.AWS_KEY.length;
      }
      console.log('Running on AWS, environment AWS_KEY is ' + settingLength);

      if (process.env.AWS_SECRET != null) {
        settingLength = process.env.AWS_SECRET.length;
      } else {
        settingLength = 0;
      }
      console.log('Running on AWS, environment AWS_SECRET is ' + settingLength);
    } else {
      console.log(
        'Running locally, IsAWSEnvironment is ' +
          Globals.IsAWSEnvironment +
          ', HAL9_ENV is ' +
          process.env.HAL9_ENV +
          '.'
      );
    }

    console.log(
      'Using S3 storage private: ' +
        hal9S3StorageBucketNamePrivate +
        ', public: ' +
        hal9S3StorageBucketNamePublic
    );

    // AWS secrets have to be set first, before accessing anything.
    //initDatabaseAsync();
  } catch (err) {
    console.error(err);
  }*/
};
start();

export const register = (app: any) => {
  app.get('/api/sql/version', async (req: any, res: any) => { 
    const tables = await dbutils.listTables();
    console.log(tables)
    res.send('version');
  });
}