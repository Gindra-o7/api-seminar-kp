import { Request, Response } from "express";
import MahasiswaService from "../services/mahasiswa.services";

const mahasiswaService = new MahasiswaService();

class MahasiswaController {
  // get all mahasiswa
  async getAllMahasiswa(req: Request, res: Response) {
    try {
      const { page = 1, limit = 10, search } = req.query;

      const skip = (Number(page) - 1) * Number(limit);

      const where = mahasiswaService.createMahasiswaFilter(String(search));

      const mahasiswa = await mahasiswaService.getAllMahasiswa({
        skip,
        take: Number(limit),
        where,
      });

      const total = await mahasiswaService.getMahasiswaCount(where);

      res.status(200).json({
        data: mahasiswa,
        meta: {
          page: Number(page),
          limit: Number(limit),
          total,
          totalPages: Math.ceil(total / Number(limit)),
        },
      });
    } catch (error) {
      res.status(500).json({ error: (error as Error).message });
    }
  }

  // get mahasiswa by nim
  async getMahasiswaByNim(req: Request, res: Response) {
    try {
      const { nim } = req.params
      const mahasiswa = await mahasiswaService.getMahasiswaByNim(nim)

      if (!mahasiswa) {
        return res.status(404).json({ message: 'Mahasiswa not found' })
      }

      res.json(mahasiswa)
    } catch (error) {
      res.status(500).json({ 
        message: 'Error fetching mahasiswa', 
        error: error instanceof Error ? error.message : 'Unknown error' 
      })
    }
  }
}


export default MahasiswaController;