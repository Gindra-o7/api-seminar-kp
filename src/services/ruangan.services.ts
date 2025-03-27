import prisma from "../configs/prisma.config";

class RuanganService {
  async getAllRuangan() {
    return await prisma.ruangan.findMany();
  }

  async createRuangan(nama: string) {
    return await prisma.ruangan.create({
      data: {
        nama: nama,
      },
    });
  }

  async deleteRuangan(nama: string) {
    return await prisma.ruangan.delete({
      where: {
        nama: nama,
      },
    });
  }
}

export default RuanganService;