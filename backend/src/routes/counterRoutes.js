const express = require('express');
const router = express.Router();
const { getCounters, callNext, updateCounter } = require('../controllers/counterController');

router.get('/', getCounters);
router.post('/:id/call-next', callNext);
router.patch('/:id', updateCounter);

module.exports = router;
