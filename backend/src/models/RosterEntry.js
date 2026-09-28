const mongoose = require('mongoose');

const rosterEntrySchema = new mongoose.Schema(
  {
    shiftId: { type: mongoose.Schema.Types.ObjectId, ref: 'Shift' },
    workerId: { type: mongoose.Schema.Types.ObjectId, ref: 'Worker' },
    name: { type: String, required: true },
    role: { type: String, required: true },
    duty: { type: String, enum: ['on', 'breakTime'], default: 'on' },
    station: { type: String, default: 'Main Desk' },
    checkedIn: { type: String, default: '08:15 AM via GPS QR' },
    loggedHours: { type: String, default: '3.7 hrs active' },
    msg: { type: String, default: 'Message / Call' },
    action2: { type: String },
    action2Icon: { type: String },
    danger: { type: Boolean, default: false },
  },
  { timestamps: true }
);

module.exports = mongoose.model('RosterEntry', rosterEntrySchema);
