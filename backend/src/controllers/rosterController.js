const RosterEntry = require('../models/RosterEntry');

// GET /api/roster
const getRoster = async (req, res) => {
  try {
    const entries = await RosterEntry.find();
    res.json({ success: true, count: entries.length, data: entries });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// PATCH /api/roster/:id
const updateRosterEntry = async (req, res) => {
  try {
    const entry = await RosterEntry.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!entry) return res.status(404).json({ success: false, message: 'Roster entry not found' });

    // Emit Socket.IO event if io instance is attached
    if (req.app.get('io')) {
      req.app.get('io').of('/roster').emit('roster_updated', entry);
    }

    res.json({ success: true, data: entry });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

module.exports = { getRoster, updateRosterEntry };
