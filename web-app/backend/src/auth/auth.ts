import { getUserByToken } from "../database/utils";

export function generateToken(guid: string) {
	const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

	const guidArr = guid.split('-');

	let result = '';
	for (let i = 0; i < 32; i++) {
		result += characters.charAt(Math.floor(Math.random() * characters.length));
	}
	return guidArr[0] + result;
}

export const userByToken = async (req: any, res: any, next: any) => {
	const token = req.headers?.token;
	const user = await getUserByToken(token);
	req.user = user;
	next();
}