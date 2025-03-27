import express from 'express';
import RuanganController from '../controllers/ruangan.controllers';

const router = express.Router();
const ruanganController = new RuanganController();

router.get('/ruangan', ruanganController.getRuangan)
router.post('/ruangan', ruanganController.createRuangan)
router.delete('/ruangan/:nama', ruanganController.deleteRuangan)

export default router;
