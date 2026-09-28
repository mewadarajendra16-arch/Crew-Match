const mongoose = require('mongoose');

const queueTokenSchema = new mongoose.Schema(
  {
    tokenId: { type: String, required: true, unique: true },
    serviceName: { type: String, required: true },
    visitorName: { type: String, required: true },
    phone: { type: String, required: true },
    ahead: { type: Number, default: 0 },
    waitMin: { type: Number, default: 5 },
    status: { type: String, enum: ['waiting', 'called', 'completed', 'cancelled'], default: 'waiting' },
    alertSms: { type: Boolean, default: true },
    alertWhatsapp: { type: Boolean, default: false },
    alertPush: { type: Boolean, default: true },
    issuedAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

module.exports = mongoose.model('QueueToken', queueTokenSchema);
