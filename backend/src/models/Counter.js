const mongoose = require('mongoose');

const counterSchema = new mongoose.Schema(
  {
    no: { type: String, required: true },
    name: { type: String, required: true },
    staff: { type: String, required: true },
    device: { type: String, required: true },
    prefix: { type: String, required: true },
    serving: { type: Number, default: 1 },
    waiting: { type: Number, default: 0 },
    status: { type: String, enum: ['active', 'session', 'onBreak'], default: 'active' },
    hwLabel: { type: String, default: '' },
    hwValue: { type: String, default: '' },
    secLabel: { type: String },
    secIcon: { type: String },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Counter', counterSchema);
