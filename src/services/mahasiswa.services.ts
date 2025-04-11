import prisma from "../configs/prisma.config";
import { Mahasiswa, Prisma } from "@prisma/client";

class MahasiswaService {
  // mendapatkan data semua mahasiswa dengan filter dan pagination
  async getAllMahasiswa(
    params: {
      skip?: number;
      take?: number;
      cursor?: Prisma.MahasiswaWhereUniqueInput;
      where?: Prisma.MahasiswaWhereInput;
      orderBy?: Prisma.MahasiswaOrderByWithRelationInput;
    } = {}
  ): Promise<Mahasiswa[]> {
    const {
      skip,
      take,
      cursor,
      where,
      orderBy,
    } = params;

    return prisma.mahasiswa.findMany({
      skip,
      take,
      cursor,
      where,
      orderBy,
      include: {
        dokumen: true,
        jadwal_seminar: true,
        nilai: true,
      },
    })
  }

  createMahasiswaFilter(search?: string): Prisma.MahasiswaWhereInput {
    if (!search) return {}

    return {
      OR: [
        { 
          nama: { 
            contains: search,
            mode: 'insensitive' 
          } 
        },
        { 
          nim: { 
            contains: search,
            mode: 'insensitive' 
          } 
        }
      ]
    }
  }

  // get mahasiswa by nim
  async getMahasiswaByNim(nim: string): Promise<Mahasiswa | null> {
    return prisma.mahasiswa.findUnique({
      where: {
        nim,
      },
      include: {
        dokumen: true,
        jadwal_seminar: true,
        nilai: true,
      },
    });
  }

  // get jumlah mahasiswa
  async getMahasiswaCount(where?: Prisma.MahasiswaWhereInput): Promise<number> {
    return prisma.mahasiswa.count({ where })
  }
}


export default MahasiswaService;