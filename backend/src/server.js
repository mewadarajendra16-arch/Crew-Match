const http = require('http');
const { Server } = require('socket.io');
const createApp = require('./app');
const connectDB = require('./config/db');
const env = require('./config/env');
const setupRosterSocket = require('./sockets/rosterSocket');
const setupQueueSocket = require('./sockets/queueSocket');

const startServer = async () => {
  // Connect Database
  await connectDB();

  const app = createApp();
  const server = http.createServer(app);

  // Initialize Socket.IO
  const io = new Server(server, {
    cors: {
      origin: env.corsOrigin,
      methods: ['GET', 'POST', 'PATCH', 'DELETE'],
    },
  });

  // Attach io instance to app
  app.set('io', io);

  // Setup Namespaces
  setupRosterSocket(io);
  setupQueueSocket(io);

  server.listen(env.port, () => {
    console.log(`===============================================`);
    console.log(`🚀 CrewMatch Server running in ${env.nodeEnv} mode`);
    console.log(`📡 URL: http://localhost:${env.port}`);
    console.log(`===============================================`);
  });
};

startServer();
