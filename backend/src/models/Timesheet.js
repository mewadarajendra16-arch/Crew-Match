const mongoose = require('mongoose');

const timesheetSchema = new mongoose.Schema(
  {
    shiftId: { type: mongoose.Schema.Types.ObjectId, ref: 'Shift' },
    workerId: { type: mongoose.Schema.Types.ObjectId, ref: 'Worker' },
    name: { type: String, required: true },
    role: { type: String, required: true },
    amount: { type: Number, required: true },
    sub: { type: String, default: '8.0 hrs @ ₹750/hr' },
    gps: { type: String, default: 'GPS Verified: 08:15 AM – 05:30 PM' },
    footer: { type: String, default: 'Shift Manager Signed Off' },
    chip: { type: String },
    chipIcon: { type: String },
    rating: { type: Number, default: 5.0 },
    flawless: { type: Boolean, default: false },
    status: { type: String, enum: ['ready', 'discrepancy', 'released'], default: 'ready' },
    overtime: {
      hasDiscrepancy: { type: Boolean, default: false },
      reason: { type: String },
      claimedAmount: { type: Number, default: 0 },
      resolution: { type: String, enum: ['pending', 'standard', 'full'], default: 'pending' },
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Timesheet', timesheetSchema);
