// @ts-decheck
import { getDB, db } from './init';
// you can use the db directly in the folder like 
//sqlite3 Kapetanios.db. -> .tables -> SELECT * FROM <table>;

function transformDbResult(data: any): object | object[] {
  if (!Array.isArray(data) || data.length === 0 || !data[0].columns || !data[0].values) {
    return [];
  }

  const columns = data[0].columns;
  const values = data[0].values;

  if (values.length === 0) {
    return [];
  }

  const result = values.map((rowValues: any[]) => {
    const rowObject: { [key: string]: any } = {};
    columns.forEach((colName: string, index: number) => {
      rowObject[colName] = rowValues[index];
    });
    return rowObject;
  });


  // plural returns an array       getDeploys => [] 
  // singular returns the json     getDeploy => {}
  return result.length === 1 ? result[0] : result;
}

async function executeInsertAsync(tableName: string, query: string, data: string[]) {
  const db = getDB();
  try {
    await db.run(query, data);
    return 0;
  } catch (error: any) {
    console.log('ERROR: Insert failed with ' + error.message + ' for query ' + query + ' data: [' + data + ']');
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

export const execInsertCluster = async (clusterguid: string, name: string, provider: string, user: string) => {
  console.log('Inserting cluster: ', name, ' - for user : ', user, ' - and provider: ', provider);
  let dbResult = await executeInsertAsync(
    'clusters',
    'INSERT INTO clusters(cluster_guid, name, provider, user) VALUES(?, ?, ?, ?)',
    [clusterguid, name, provider, user]
  );
  return dbResult;
}

export const execInsertDeployment = async (clusterId: string, id: string, name: string, namespace: string, createdAt: string, updatedAt: string,
  status: string, labels: string, annotations: string, yaml: string, model: string
) => {
  console.log('Inserting deployments: ', name, ' - for namespace: ', namespace, ' - in cluster: ', clusterId);
  let dbResult = await executeInsertAsync(
    'deployments',
    'INSERT INTO deployments(cluster_id, guid, name, namespace, createdAt, updatedAt, status, labels, annotations, yaml, model) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
    [clusterId, id, name, namespace, createdAt, updatedAt, status, labels, annotations, yaml, model]
  );

  const queryResult = await db.exec(
    'SELECT id FROM deployments WHERE cluster_id = ? AND guid = ?',
    [clusterId, id]
  );
  return queryResult[0].values[0][0]; // fix this to simplify expression
}

export const execInsertHpa = async (deploymentId: string, id: string, name: string, namespace: string, createdAt: string, updatedAt: string,
  status: string, minReplicas: string, maxReplicas: string, targetCPUUtilizationPercentage: string, yaml: string
) => {
  console.log('Inserting hpa: ', name, ' - for namespace: ', namespace, ' - in deployment: ', deploymentId);
  let dbResult = await executeInsertAsync(
    'hpa',
    'INSERT INTO hpa(deployment_id, guid, name, namespace, createdAt, updatedAt, status, minReplicas, maxReplicas, targetCPUUtilizationPercentage, yaml) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
    [deploymentId, id, name, namespace, createdAt, updatedAt, status, minReplicas, maxReplicas, targetCPUUtilizationPercentage, yaml]
  );
  return dbResult;
}

export const execUpdateDeployment = async (
  clusterId: string,
  guid: string,
  name: string,
  namespace: string,
  createdAt: string,
  updatedAt: string,
  status: string,
  labels: string,
  annotations: string,
  yaml: string,
  model: string
) => {
  console.log('Updating deployment with GUID:', guid, ' - in cluster:', clusterId);
  let dbResult = await executeInsertAsync(
    'deployments',
    'UPDATE deployments SET name =?, namespace = ?, createdAt = ?, updatedAt = ?, status = ?, labels = ?, annotations = ?, yaml = ?, model = ? WHERE cluster_id = ? AND guid = ?',
    [name, namespace, createdAt, updatedAt, status, labels, annotations, yaml, model, clusterId, guid]
  );
  return dbResult;
};

export const execUpdateHPA = async (
  deploymentId: string, guid: string, name: string, namespace: string, createdAt: string, updatedAt: string,
  status: string, minReplicas: string, maxReplicas: string, targetCPUUtilizationPercentage: string, yaml: string
) => {
  console.log('Updating HPA with GUID:', guid, ' - in deployment:', deploymentId);
  let dbResult = await executeInsertAsync(
    'deployments',
    'UPDATE hpa SET name =?, namespace = ?, createdAt = ?, updatedAt = ?, status = ?, minReplicas = ?, maxReplicas = ?, yaml = ?, targetCPUUtilizationPercentage = ? WHERE deployment_id = ? AND guid = ?',
    [name, namespace, createdAt, updatedAt, status, minReplicas, maxReplicas, yaml, targetCPUUtilizationPercentage, deploymentId, guid]
  );
  return dbResult;
};

export const getUser = async (name: string, email: string) => {
  const query = `SELECT * FROM users WHERE user = ? AND email = ? ;`;
  let data = db.exec(query, [name, email]);
  data = transformDbResult(data);
  return data;
}

export const getdeploymentIDbyguids = async (clusterId: string, deploymentGuid: string) => {
  const query = `SELECT * FROM deployments WHERE cluster_id = ? AND guid = ? ;`;
  let data = db.exec(query, [clusterId, deploymentGuid]);
  data = transformDbResult(data);
  return data.id ?? null;
}

export const getUserByToken = async (token: string) => {
  const user = await db.exec('SELECT * FROM users WHERE token == ?', [token]);
  const jsonUser = transformDbResult(user);
  return jsonUser;
}

export const getClustersByUserId = async (id: string) => {
  const clusters = await db.exec('SELECT * FROM clusters WHERE user == ?', [id]);
  const jsonClusters = transformDbResult(clusters);
  return [jsonClusters].flat(Infinity);
}

export const getClustersDeployments = async (deploymentsName: string[], clusterId: string) => {
  const placeholders = deploymentsName.map(() => '?').join(', ');

  const query = `
      SELECT guid
      FROM deployments
      WHERE cluster_id = ? AND guid IN (${placeholders});
    `;

  const params = [clusterId, ...deploymentsName];
  const foundDeployments = await db.exec(query, params);

  if (foundDeployments?.length > 0) {
    return foundDeployments[0].values[0];
  } else { return [] };
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
    console.error(`ERROR: failed to get data from table '${table}':`, err.message);
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
    console.log('ERROR: Failed to list tables:', err);
    return [];
  }
};
