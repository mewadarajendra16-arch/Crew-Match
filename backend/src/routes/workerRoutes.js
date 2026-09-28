const express = require('express');
const router = express.Router();
const { getWorkers, getWorkerById, hireWorker } = require('../controllers/workerController');

router.get('/', getWorkers);
router.get('/:id', getWorkerById);
router.post('/hire', hireWorker);

module.exports = router;
