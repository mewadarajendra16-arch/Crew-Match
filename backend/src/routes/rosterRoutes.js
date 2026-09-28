const express = require('express');
const router = express.Router();
const { getRoster, updateRosterEntry } = require('../controllers/rosterController');

router.get('/', getRoster);
router.patch('/:id', updateRosterEntry);

module.exports = router;
