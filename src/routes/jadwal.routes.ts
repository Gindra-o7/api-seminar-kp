import { Router } from "express";
import JadwalController from "../controllers/jadwal.controllers";

const router = Router();
const jadwalController = new JadwalController();

router.post("/jadwal", jadwalController.createJadwal);
router.put("/jadwal/:id", jadwalController.updateJadwal);
router.get("/jadwal", jadwalController.getAllJadwal);
router.get("/jadwal/:nim", jadwalController.getJadwalByNim);
router.get("/jadwal/:nip", jadwalController.getJadwalByNip);

export default router;