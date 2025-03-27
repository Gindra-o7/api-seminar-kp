import { Request, Response } from "express";
import JadwalService from "../services/jadwal.services";

const jadwalService = new JadwalService();

class JadwalController {
  async createJadwal(req: Request, res: Response) {
    try {
      const jadwal = await jadwalService.createJadwal(req.body);
      res.status(201).json({message: "Jadwal Berhasil dibuat", jadwal});
    } catch (error) {
      res.status(500).json({ error: (error as Error).message });
    }
  }

  async updateJadwal(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const updatedByNip = req.body.updatedByNip;
      const updateJadwal = await jadwalService.updateJadwal(id, req.body, updatedByNip);
      res.status(200).json({message: "Jadwal Berhasil diperbarui", updateJadwal});
    } catch (error) {
      res.status(500).json({ error: (error as Error).message });
    }
  }

  async getAllJadwal(req: Request, res: Response) {
    try {
      const filters = req.query;
      const jadwal = await jadwalService.getAllJadwal(filters);
      res.status(200).json(jadwal);
    } catch (error) {
      res.status(500).json({ error: (error as Error).message });
    }
  }

  async getJadwalByNim(req: Request, res: Response) {
    try {
      const { nim } = req.params;
      const jadwal = await jadwalService.getJadwalByNim(nim);
      res.status(200).json(jadwal);
    } catch (error) {
      res.status(500).json({ error: (error as Error).message });
    }
  }

  async getJadwalByNip(req: Request, res: Response) {
    try {
      const { nip } = req.params;
      const jadwal = await jadwalService.getJadwalByNip(nip);
      res.status(200).json(jadwal);
    } catch (error) {
      res.status(500).json({ error: (error as Error).message });
    }
  }
}


export default JadwalController;