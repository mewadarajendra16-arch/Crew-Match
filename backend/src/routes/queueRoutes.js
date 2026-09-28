const express = require('express');
const router = express.Router();
const { getServices, generateToken, getTokenById, leaveQueue } = require('../controllers/queueController');

router.get('/services', getServices);
router.post('/tokens', generateToken);
router.get('/tokens/:tokenId', getTokenById);
router.delete('/tokens/:tokenId', leaveQueue);

module.exports = router;
