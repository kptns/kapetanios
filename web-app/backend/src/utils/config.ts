import { existsSync, readFileSync } from 'fs';
import * as yaml from 'js-yaml';
import path from 'path';

let rawconfig = '';
let config: any;
let flatconfig: any = {};
const configpath = path.join(__dirname, '../config.yaml');

const enhanceConfigEnvs = (config: any, category: string) => {
  if (typeof config != 'object' || !config) return;

  for (let key of Object.keys(config)) {
    const id = ((category ? category + '_' : '') + key).toUpperCase();
    if (typeof config[key] != 'object') {
      flatconfig[id] = config[key];
    }

    if (process.env[id]) {
      config[key] = process.env[id];
    } else {
      enhanceConfigEnvs(config[key], id);
    }
  }
};

const yamlConfig = (rawconfig: string) => {
  try {
    config = yaml.load(rawconfig);
    enhanceConfigEnvs(config, '');
  } catch (e: any) {
    console.log('ERROR: Error loading config.yaml: ' + e.toString());
  }
};

export const configInit = () => {
  if (config !== undefined) return;
  flatconfig = {};

  if (!existsSync(configpath)) {
    console.log('Could not find config.yaml');
    return;
  }

  rawconfig = readFileSync(configpath, 'utf8');
  yamlConfig(rawconfig);
};
configInit();

export const get = (key:string) => {
  configInit();
  return flatconfig[key];
};