import { userByToken } from "../auth/auth";
import * as dbutils from "../database/utils";

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

		const clusters = await dbutils.getClusterByUserId(user.id);
		const foundCluster = clusters.find((cluster: any) => cluster.name === clusterName);

		if (!foundCluster) {
			res.status(404).send('Cluster not found, cannot add/update deployment');
			return;
		}

		const deploymentsName = deployments.map((deployment: { id: string }) => deployment.id);
		const existingdeployments = await dbutils.getClusterDeployments(deploymentsName, foundCluster.id);
		for (const deploy of deployments) {
			const { hpa, ...deployment } = deploy;
			try {
				if (existingdeployments.includes(deployment.id)) {
					if (deployment.update) {
						console.log('updating deployment ', deployment.id);
						let resDB = await dbutils.execUpdateDeployment(
							foundCluster.id,
							deployment.id,
							deployment.namespace,
							deployment.createdAt,
							deployment.updatedAt,
							deployment.status,
							JSON.stringify(deployment.labels),
							JSON.stringify(deployment.annotations),
							deployment.yaml,
							'model'
						);
					}
				} else /*if( !existingdeployments.includes(deployment.name) )*/ {
					let deploymentId = await dbutils.execInsertDeployment(foundCluster.id, deployment.id, deployment.name, deployment.namespace, deployment.createdAt, deployment.updatedAt,
						deployment.status, JSON.stringify(deployment.labels), JSON.stringify(deployment.annotations), deployment.yaml, 'model');
					let dbRes = await dbutils.execInsertHpa(deploymentId, hpa.id, hpa.name, hpa.namespace, hpa.createdAt, hpa.updatedAt,
						hpa.status, hpa.minReplicas, hpa.maxReplicas, hpa.targetCPUUtilizationPercentage, hpa.yaml);
				}
			} catch (e) {
				console.error('Error inserting deployments', e);
			}
			//console.log(deployment);
			console.log('---')
			//console.log(hpa)

		}



		console.log(existingdeployments)


		res.status(201).send('deployment added correctly');

	});

	app.get('/api/agent/deployment', userByToken, async (req: any, res: any) => {
		res.status(200).send('Return JSON deploy ');
	});
}