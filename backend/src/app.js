const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const env = require('./config/env');

const authRoutes = require('./routes/authRoutes');
const workerRoutes = require('./routes/workerRoutes');
const shiftRoutes = require('./routes/shiftRoutes');
const rosterRoutes = require('./routes/rosterRoutes');
const payoutRoutes = require('./routes/payoutRoutes');
const queueRoutes = require('./routes/queueRoutes');
const counterRoutes = require('./routes/counterRoutes');
const analyticsRoutes = require('./routes/analyticsRoutes');

const createApp = () => {
  const app = express();

  // Middlewares
  app.use(cors({ origin: env.corsOrigin }));
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  if (env.nodeEnv !== 'test') {
    app.use(morgan('dev'));
  }

  // Healthcheck Route
  app.get('/api/health', (req, res) => {
    res.json({ status: 'ok', service: 'CrewMatch & SmartQueue API', timestamp: new Date() });
  });

  // Mount API Routes
  app.use('/api/auth', authRoutes);
  app.use('/api/workers', workerRoutes);
  app.use('/api/shifts', shiftRoutes);
  app.use('/api/roster', rosterRoutes);
  app.use('/api/payouts', payoutRoutes);
  app.use('/api/queue', queueRoutes);
  app.use('/api/counters', counterRoutes);
  app.use('/api/analytics', analyticsRoutes);

  // 404 Handler
  app.use((req, res) => {
    res.status(404).json({ success: false, message: 'API Route Not Found' });
  });

  // Global Error Handler
  app.use((err, req, res, next) => {
    console.error('[Error Handler]', err);
    res.status(err.status || 500).json({
      success: false,
      message: err.message || 'Internal Server Error',
    });
  });

  return app;
};

module.exports = createApp;
