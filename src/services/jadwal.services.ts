import prisma from "../configs/prisma.config";
import { format } from "date-fns";
import { CreateJadwalInput, JadwalConflickCheck, JadwalFilters, UpdateJadwalInput } from "../types/jadwal.types";

class JadwalService {
  // cek jadwal konflik
  async checkJadwalConflict(data: JadwalConflickCheck) {
    // cek jadwal dosen yang konflik
    if (data.nip) {
      const dosenConflict = await prisma.jadwal.findFirst({
        where: {
          nip: data.nip,
          tanggal: {
            equals: data.tanggal,
          },
          OR: [
            {
              waktu_mulai: {
                lt: data.waktu_selesai,
                gte: data.waktu_mulai,
              },
            },
            {
              waktu_selesai: {
                gte: data.waktu_mulai,
                lt: data.waktu_selesai,
              },
            },
          ],
        },
      });

      if (dosenConflict) {
        throw new Error(`Jadwal dosen tersedia pada waktu yang sama pada ${format(data.tanggal, "dd-MM-yyyy")} jam ${data.waktu_mulai} - ${data.waktu_selesai}`);
      }
    }

    // cek jadwal ruangan yang sedang digunakan
    if (data.ruangan_nama) {
      const ruanganConflict = await prisma.jadwal.findFirst({
        where: {
          ruangan_nama: data.ruangan_nama,
          tanggal: {
            equals: data.tanggal,
          },
          OR: [
            {
              waktu_mulai: {
                lt: data.waktu_selesai,
                gte: data.waktu_mulai,
              },
            },
            {
              waktu_selesai: {
                gte: data.waktu_mulai,
                lt: data.waktu_selesai,
              },
            },
          ],
        },
      });

      if (ruanganConflict) {
        throw new Error(`Ruangan ${data.ruangan_nama} sudah digunakan pada ${format(data.tanggal, "dd-MM-yyyy")} jam ${data.waktu_mulai} - ${data.waktu_selesai}`);
      }
    }
  }

  // membuat jadwal baru
  async createJadwal(input: CreateJadwalInput) {
    const { nim, nip, tanggal, waktu_mulai, waktu_selesai, ruangan_nama } = input;

    await this.checkJadwalConflict({
      tanggal,
      waktu_mulai,
      waktu_selesai,
      nip,
      ruangan_nama,
    });

    return prisma.$transaction(async (tx) => {
      const jadwal = await tx.jadwal.create({
        data: {
          nim,
          nip,
          tanggal,
          waktu_mulai,
          waktu_selesai,
          ruangan_nama,
          status: "pending",
        },
      });

      await tx.logJadwal.create({
        data: {
          jadwal_seminar_id: jadwal.id,
          log_type: "created",
          nip,
          tanggal_baru: tanggal,
          ruangan_baru: ruangan_nama,
        },
      });

      return jadwal;
    });
  }

  // memperbarui jadwal
  async updateJadwal(
    jadwal_id: string, 
    updateData: UpdateJadwalInput, 
    updatedByNip: string
  ) {
    const jadwalTersedia = await prisma.jadwal.findUnique({
      where: {
        id: jadwal_id,
      },
    });

    if (!jadwalTersedia) {
      throw new Error("Jadwal tidak ditemukan");
    }

    const tanggal = updateData.tanggal || jadwalTersedia.tanggal;
    const waktu_mulai = updateData.waktu_mulai || jadwalTersedia.waktu_mulai;
    const waktu_selesai = updateData.waktu_selesai || jadwalTersedia.waktu_selesai;
    const nip = updateData.nip || jadwalTersedia.nip;
    const ruangan_nama = updateData.ruangan_nama || jadwalTersedia.ruangan_nama;

    await this.checkJadwalConflict({
      tanggal,
      waktu_mulai,
      waktu_selesai,
      nip,
      ruangan_nama,
    });

    return prisma.$transaction(async (tx) => {
      const updatedJadwal = await tx.jadwal.update({
        where: { id: jadwal_id },
        data: {
          ...updateData,
          status: updateData.status || jadwalTersedia.status,
        },
      });

      await tx.logJadwal.create({
        data: {
          jadwal_seminar_id: jadwal_id,
          log_type: "updated",
          nip: updatedByNip,
          tanggal_lama: jadwalTersedia.tanggal,
          tanggal_baru: updatedJadwal.tanggal,
          ruangan_lama: jadwalTersedia.ruangan_nama,
          ruangan_baru: updatedJadwal.ruangan_nama,
        },
      });

      return updatedJadwal;
    });
  }

  // mendapatkan semua jadwal
  async getAllJadwal(filters?: JadwalFilters) {
    return prisma.jadwal.findMany({
      where: filters,
      include: {
        mahasiswa: true,
        dosen: true,
        ruangan: true,
      },
    });
  }

  // mendapatkan jadwal berdasarkan nim mahasiswa
  async getJadwalByNim(nim: string) {
    return prisma.jadwal.findMany({
      where: {
        nim,
      },
      include: {
        mahasiswa: true,
        dosen: true,
        ruangan: true,
        nilai: true,
      },
      orderBy: {
        tanggal: "desc",
      },
    });
  }

  async getJadwalByNip(nip: string) {
    return prisma.jadwal.findMany({
      where: {
        nip,
      },
      include: {
        mahasiswa: true,
        dosen: true,
        ruangan: true,
        nilai: true,
      },
      orderBy: {
        tanggal: "desc",
      },
    })
  }
}


export default JadwalService;