const QueueService = require('../models/QueueService');
const QueueToken = require('../models/QueueToken');

// GET /api/queue/services
const getServices = async (req, res) => {
  try {
    const services = await QueueService.find({ active: true });
    res.json({ success: true, count: services.length, data: services });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

let seq = 110;

// POST /api/queue/tokens
const generateToken = async (req, res) => {
  try {
    const { servicePrefix, serviceName, visitorName, phone, ahead, waitMin, alertSms, alertWhatsapp, alertPush } = req.body;
    if (!visitorName || !phone) {
      return res.status(400).json({ success: false, message: 'Visitor name and phone are required' });
    }

    const prefix = servicePrefix || 'G';
    const tokenId = `#${prefix}-${seq++}`;

    const token = await QueueToken.create({
      tokenId,
      serviceName: serviceName || 'General Inquiries & Verification',
      visitorName,
      phone,
      ahead: ahead !== undefined ? ahead : 3,
      waitMin: waitMin !== undefined ? waitMin : 6,
      alertSms: alertSms !== undefined ? alertSms : true,
      alertWhatsapp: alertWhatsapp || false,
      alertPush: alertPush !== undefined ? alertPush : true,
      issuedAt: new Date(),
    });

    if (req.app.get('io')) {
      req.app.get('io').of('/queue').emit('token_created', token);
    }

    res.status(201).json({ success: true, data: token });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// GET /api/queue/token/:tokenId
const getTokenById = async (req, res) => {
  try {
    const token = await QueueToken.findOne({ tokenId: req.params.tokenId });
    if (!token) return res.status(404).json({ success: false, message: 'Token not found' });
    res.json({ success: true, data: token });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// DELETE /api/queue/token/:tokenId
const leaveQueue = async (req, res) => {
  try {
    await QueueToken.deleteOne({ tokenId: req.params.tokenId });
    res.json({ success: true, message: 'Left queue' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

module.exports = { getServices, generateToken, getTokenById, leaveQueue };
