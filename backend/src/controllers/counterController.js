const Counter = require('../models/Counter');

// GET /api/counters
const getCounters = async (req, res) => {
  try {
    const counters = await Counter.find().sort({ no: 1 });
    res.json({ success: true, count: counters.length, data: counters });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// POST /api/counters/:id/call-next
const callNext = async (req, res) => {
  try {
    const counter = await Counter.findById(req.params.id);
    if (!counter) return res.status(404).json({ success: false, message: 'Counter not found' });

    counter.serving += 1;
    if (counter.waiting > 0) counter.waiting -= 1;
    await counter.save();

    const io = req.app.get('io');
    if (io) {
      io.of('/queue').emit('counter_called_next', counter);
    }

    res.json({
      success: true,
      message: `Now serving #${counter.prefix}-${String(counter.serving).padStart(3, '0')} at desk ${counter.no}`,
      data: counter,
    });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// PATCH /api/counters/:id
const updateCounter = async (req, res) => {
  try {
    const counter = await Counter.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!counter) return res.status(404).json({ success: false, message: 'Counter not found' });

    const io = req.app.get('io');
    if (io) {
      io.of('/queue').emit('counter_updated', counter);
    }

    res.json({ success: true, data: counter });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

module.exports = { getCounters, callNext, updateCounter };
