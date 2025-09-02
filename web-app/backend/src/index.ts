import express from 'express';
import * as db from './database/database';
import * as agent from './agent/agent';

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
db.register(app);
agent.register(app);

// Define a simple root route
app.get('/', (req, res) => {
  res.send('Hello from your Bun + Express backend!');
});

// A simple API route
app.get('/api/greeting', (req, res) => {
  res.json({ message: 'Greetings from the API!' });
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
  console.log(`Open http://localhost:${port} in your browser to see the greeting.`);
});
