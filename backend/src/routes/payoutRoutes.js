const express = require('express');
const router = express.Router();
const { getPayouts, resolveOvertime, releasePayouts } = require('../controllers/payoutController');

router.get('/', getPayouts);
router.patch('/:id/overtime', resolveOvertime);
router.post('/release', releasePayouts);

module.exports = router;
