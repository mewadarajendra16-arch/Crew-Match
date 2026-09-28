const express = require('express');
const router = express.Router();
const { createShift, getShifts } = require('../controllers/shiftController');
const { protect } = require('../middleware/auth');

router.post('/', protect, createShift);
router.get('/', getShifts);

module.exports = router;
