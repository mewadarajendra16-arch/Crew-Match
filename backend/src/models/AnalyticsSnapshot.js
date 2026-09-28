const mongoose = require('mongoose');

const analyticsSnapshotSchema = new mongoose.Schema(
  {
    range: { type: String, enum: ['today', 'week', 'month'], required: true },
    footfall: { type: String, required: true },
    delta: { type: String, required: true },
    wait: { type: String, required: true },
    rate: { type: String, required: true },
    served: { type: String, required: true },
    uptime: { type: String, required: true },
    loadArray: [{ type: Number }],
    hoursArray: [{ type: String }],
  },
  { timestamps: true }
);

module.exports = mongoose.model('AnalyticsSnapshot', analyticsSnapshotSchema);
