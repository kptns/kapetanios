import { userByToken } from "../auth/auth";

export const register = (app: any) => {
	app.post('/api/agent/deployment', userByToken, async (req: any, res: any) => {
		// polling agent deployment-hap

		// check if exists 
		//save deploy tabñe
		// save hpa table

		res.status(201).send('deployment added correctly');

	});

		app.get('/api/agent/deployment', userByToken, async (req: any, res: any) => {
		res.status(200).send('Return JSON deploy ');
	});
}