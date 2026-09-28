const Shift = require('../models/Shift');

// POST /api/shifts
const createShift = async (req, res) => {
  try {
    const { eventName, category, venue, roleNeeded, staffRequired, hourlyWage, criteria } = req.body;
    if (!eventName || !hourlyWage) {
      return res.status(400).json({ success: false, message: 'Event name and hourly wage are required' });
    }

    const staff = staffRequired || 4;
    const rate = hourlyWage || 750;
    const basePay = staff * 8 * rate;
    const platformFee = Math.round(basePay * 0.05);
    const totalLocked = basePay + platformFee;

    const shift = await Shift.create({
      organiserId: req.user ? req.user._id : null,
      eventName,
      category: category || 'Corporate Conference / Exhibition',
      venue: venue || 'Jio World Convention Centre, BKC, Mumbai',
      roleNeeded: roleNeeded || 'Registration & Guest Escort Specialist',
      staffRequired: staff,
      hourlyWage: rate,
      criteria: criteria || {},
      escrow: {
        basePay,
        platformFee,
        totalLocked,
        status: 'locked',
      },
    });

    res.status(201).json({
      success: true,
      message: `Shift broadcasted successfully! ₹${totalLocked} locked in escrow.`,
      data: shift,
    });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// GET /api/shifts
const getShifts = async (req, res) => {
  try {
    const shifts = await Shift.find().sort({ createdAt: -1 });
    res.json({ success: true, count: shifts.length, data: shifts });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

module.exports = { createShift, getShifts };
