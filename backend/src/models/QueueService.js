const mongoose = require('mongoose');

const queueServiceSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    desc: { type: String, required: true },
    prefix: { type: String, required: true },
    waitMin: { type: Number, default: 5 },
    ahead: { type: Number, default: 0 },
    active: { type: Boolean, default: true },
  },
  { timestamps: true }
);

module.exports = mongoose.model('QueueService', queueServiceSchema);
