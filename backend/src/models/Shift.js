const mongoose = require('mongoose');

const shiftSchema = new mongoose.Schema(
  {
    organiserId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    eventName: { type: String, required: true },
    category: { type: String, default: 'Corporate Conference / Exhibition' },
    venue: { type: String, required: true },
    shiftWindow: {
      dateText: { type: String, default: 'Sat, 22 Nov 2025 • 08:30 AM - 05:30 PM' },
      detailText: { type: String, default: '9 hrs total duration (8 billable hrs + 1 hr lunch break)' },
      billableHours: { type: Number, default: 8 },
    },
    roleNeeded: { type: String, required: true },
    staffRequired: { type: Number, default: 4 },
    hourlyWage: { type: Number, required: true },
    criteria: { type: Map, of: Boolean },
    status: { type: String, enum: ['draft', 'broadcast', 'active', 'completed'], default: 'broadcast' },
    escrow: {
      basePay: { type: Number },
      platformFee: { type: Number },
      totalLocked: { type: Number },
      status: { type: String, enum: ['locked', 'partial_released', 'released'], default: 'locked' },
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Shift', shiftSchema);
