
import * as agent from './agent/agent';
import * as db from './database/database';
import express from 'express';

// Create a new Express application instance
const app = express();
const port = 3000;

app.use(express.json());
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Headers', '*');
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, PUT, PATCH, POST, DELETE');
  next();
});

agent.register(app);
db.register(app);

// Start the server
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
  console.log(`Open http://localhost:${port} in your browser to see the greeting.`);
});
