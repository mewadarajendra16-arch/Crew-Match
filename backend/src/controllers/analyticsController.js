const AnalyticsSnapshot = require('../models/AnalyticsSnapshot');

// GET /api/analytics
const getAnalytics = async (req, res) => {
  try {
    const range = req.query.range || 'today';
    let snapshot = await AnalyticsSnapshot.findOne({ range });

    if (!snapshot) {
      // Default fallback snapshot
      const mockSnapshots = {
        today: {
          range: 'today',
          footfall: '348',
          delta: '+12% vs yesterday',
          wait: '6.4',
          rate: '94.2%',
          served: '328 served, 20 queued',
          uptime: '99.8%',
          loadArray: [0.18, 0.28, 0.52, 1.0, 1.0, 0.86, 0.44, 0.5, 0.88, 0.22],
          hoursArray: ['08', '09', '10', '11', '12', '13', '14', '15', '16', '17'],
        },
        week: {
          range: 'week',
          footfall: '2,184',
          delta: '+5% vs last week',
          wait: '7.1',
          rate: '92.6%',
          served: '2,022 served, 162 queued',
          uptime: '99.5%',
          loadArray: [0.3, 0.4, 0.6, 0.8, 0.9, 0.7, 0.5, 0.6, 0.7, 0.4],
          hoursArray: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        },
        month: {
          range: 'month',
          footfall: '9,420',
          delta: '+8% vs last month',
          wait: '6.8',
          rate: '93.4%',
          served: '8,798 served, 622 queued',
          uptime: '99.7%',
          loadArray: [0.5, 0.6, 0.7, 0.8, 0.9, 0.85, 0.75, 0.65],
          hoursArray: ['W1', 'W2', 'W3', 'W4'],
        },
      };
      snapshot = mockSnapshots[range] || mockSnapshots.today;
    }

    res.json({ success: true, data: snapshot });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

module.exports = { getAnalytics };
