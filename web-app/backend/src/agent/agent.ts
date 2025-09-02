import * as dbutils from "../database/utils";
import { userByToken } from "../auth/auth";

export const register = (app: any) => {
	app.post('/api/agent/deployment', userByToken, async (req: any, res: any) => {
		const deployments = req.body?.deployments;
		const clusterName = req.body.cluster;
		const user = req.user;
		const update = req.body.update;

		if (!user) {
			res.status(404).send('user does not exitst');
			return;
		}

		console.log(`user ${user.user} inserting deployment-hpa with data: ${JSON.stringify(deployments).substring(0, 400)}`)

		const clusters = await dbutils.getClustersByUserId(user.id);
		const foundCluster: any = clusters.find((cluster: any) => cluster.name === clusterName);

		if (!foundCluster) {
			console.log('ERROR: Cluster not found, cannot add/update deployment')
			res.status(404).send('Cluster not found, cannot add/update deployment');
			return;
		}

		const deploymentsName = deployments.map((deployment: { id: string }) => deployment.id);
		const existingdeployments = await dbutils.getClustersDeployments(deploymentsName, foundCluster.id);
		for (const deploy of deployments) {
			const { hpa, ...deployment } = deploy;
			try {
				if (existingdeployments.includes(deployment.id)) {
					if (deployment.update === "true") {
						let resDB = await dbutils.execUpdateDeployment(
							foundCluster.id,
							deployment.id,
							deployment.name,
							deployment.namespace,
							deployment.createdAt,
							deployment.updatedAt,
							deployment.status,
							JSON.stringify(deployment.labels),
							JSON.stringify(deployment.annotations),
							deployment.yaml,
							'model'
						);
						if (resDB != 0) {
							console.log('ERROR updating deployment ');
						} else {
							console.log('success updating deployment ');
						}

					}
					if (hpa.update === "true") {
						const deploymentId = await dbutils.getdeploymentIDbyguids(foundCluster.id, deployment.id);
						let resDB = await dbutils.execUpdateHPA(
							deploymentId,
							hpa.id,
							hpa.name,
							hpa.namespace,
							hpa.createdAt,
							hpa.updatedAt,
							hpa.status,
							hpa.minReplicas,
							hpa.maxReplicas,
							hpa.targetCPUUtilizationPercentage,
							hpa.yaml
						);
						if (resDB != 0) {
							console.log('ERROR updating hpa ');
						} else {
							console.log('success updating hpa ');
						}

					}
				} else /*if( !existingdeployments.includes(deployment.name) )*/ {
					let deploymentId = await dbutils.execInsertDeployment(foundCluster.id, deployment.id, deployment.name, deployment.namespace, deployment.createdAt, deployment.updatedAt,
						deployment.status, JSON.stringify(deployment.labels), JSON.stringify(deployment.annotations), deployment.yaml, 'model');
					let dbRes = await dbutils.execInsertHpa(deploymentId, hpa.id, hpa.name, hpa.namespace, hpa.createdAt, hpa.updatedAt,
						hpa.status, hpa.minReplicas, hpa.maxReplicas, hpa.targetCPUUtilizationPercentage, hpa.yaml);
				}
			} catch (e) {
				console.log('ERROR: inserting deployments: ', e);
				res.status(501).send('Error inserting deployments: ', e);
			}

		}

		res.status(201).send('deployment added correctly');

	});

	app.get('/api/agent/deployment', userByToken, async (req: any, res: any) => {
		res.status(200).send('Return JSON deploy ');
	});
}