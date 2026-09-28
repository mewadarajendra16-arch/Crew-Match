const Timesheet = require('../models/Timesheet');

// GET /api/payouts
const getPayouts = async (req, res) => {
  try {
    const sheets = await Timesheet.find();
    res.json({ success: true, count: sheets.length, data: sheets });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// PATCH /api/payouts/:id/overtime
const resolveOvertime = async (req, res) => {
  try {
    const { resolution } = req.body; // 'standard' or 'full' or 'pending'
    const sheet = await Timesheet.findById(req.params.id);
    if (!sheet) return res.status(404).json({ success: false, message: 'Timesheet not found' });

    if (resolution === 'standard') {
      sheet.amount = 6000;
      sheet.status = 'ready';
      sheet.overtime.resolution = 'standard';
    } else if (resolution === 'full') {
      sheet.amount = 6750;
      sheet.status = 'ready';
      sheet.overtime.resolution = 'full';
    } else {
      sheet.amount = 6750;
      sheet.status = 'discrepancy';
      sheet.overtime.resolution = 'pending';
    }

    await sheet.save();
    res.json({ success: true, data: sheet });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// POST /api/payouts/release
const releasePayouts = async (req, res) => {
  try {
    await Timesheet.updateMany({ status: 'ready' }, { status: 'released' });
    res.json({ success: true, message: 'Approved payments released successfully.' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

module.exports = { getPayouts, resolveOvertime, releasePayouts };
