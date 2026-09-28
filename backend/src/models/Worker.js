const mongoose = require('mongoose');

const workerSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    name: { type: String, required: true },
    role: { type: String, required: true },
    category: { type: String, required: true },
    hourlyRate: { type: Number, required: true },
    rating: { type: Number, default: 4.9 },
    stat: { type: String, default: '(0 events)' },
    meta: { type: String, default: 'Available Today' },
    metaKind: { type: String, enum: ['clock', 'pin', 'check'], default: 'clock' },
    badges: [{ type: String }],
    skills: [{ type: String }],
    immediate: { type: Boolean, default: false },
    weekend: { type: Boolean, default: false },
    isVerified: { type: Boolean, default: true },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Worker', workerSchema);
