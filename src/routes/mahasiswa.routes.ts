import { Router } from "express";
import MahasiswaController from "../controllers/mahasiswa.controllers";

const router = Router();
const mahasiswaController = new MahasiswaController();

router.get("/mahasiswa", mahasiswaController.getAllMahasiswa);
// router.get("/mahasiswa/:nim", mahasiswaController.getMahasiswaByNim);

export default router;