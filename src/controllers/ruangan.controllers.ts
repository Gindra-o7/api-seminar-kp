import { Request, Response } from "express";
import RuanganService from "../services/ruangan.services";

const ruanganService = new RuanganService();

class RuanganController {

  async getRuangan(req: Request, res: Response) {
    try{
      const ruangan = await ruanganService.getAllRuangan();
      res.status(200).json(ruangan);
    } catch (error) {
      res.status(500).json({ error: (error as Error).message });
    }
  }

  async createRuangan(req: Request, res: Response) {
    try {
      const { nama } = req.body;
      const ruangan = await ruanganService.createRuangan(nama);
      res.status(201).json(ruangan);
    } catch (error) {
      res.status(500).json({ error: (error as Error).message });
    }
  }

  async deleteRuangan(req: Request, res: Response) {
    try {
      const { nama } = req.body;
      const ruangan = await ruanganService.deleteRuangan(nama);
      res.status(200).json(ruangan);
    } catch (error) {
      res.status(500).json({ error: (error as Error).message });
    }
  }
}

export default RuanganController;