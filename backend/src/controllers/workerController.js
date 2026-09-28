const Worker = require('../models/Worker');

// GET /api/workers
const getWorkers = async (req, res) => {
  try {
    const { category, immediate, weekend, q } = req.query;
    let filter = {};

    if (category) filter.category = category;
    if (immediate === 'true') filter.immediate = true;
    if (weekend === 'true') filter.weekend = true;

    let workers = await Worker.find(filter);

    if (q && q.trim().length > 0) {
      const query = q.trim().toLowerCase();
      workers = workers.filter(
        (w) =>
          w.name.toLowerCase().includes(query) ||
          w.role.toLowerCase().includes(query) ||
          w.skills.some((s) => s.toLowerCase().includes(query))
      );
    }

    res.json({ success: true, count: workers.length, data: workers });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// GET /api/workers/:id
const getWorkerById = async (req, res) => {
  try {
    const worker = await Worker.findById(req.params.id);
    if (!worker) return res.status(404).json({ success: false, message: 'Worker not found' });
    res.json({ success: true, data: worker });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// POST /api/workers/hire
const hireWorker = async (req, res) => {
  try {
    const { workerId, rate } = req.body;
    const worker = await Worker.findById(workerId);
    if (!worker) return res.status(404).json({ success: false, message: 'Worker not found' });

    res.json({
      success: true,
      message: `Hire request sent to ${worker.name} at ₹${rate || worker.hourlyRate}/hr. Escrow held.`,
    });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

module.exports = { getWorkers, getWorkerById, hireWorker };
