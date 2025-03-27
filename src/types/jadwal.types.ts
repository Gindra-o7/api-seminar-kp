import { Mahasiswa, Dosen, Ruangan, Nilai, StatusSeminar, LogType } from "@prisma/client";

export interface Jadwal {
  id: String;
  nim: String;
  nip: String;
  tanggal: String;
  waktu_mulai: String;
  waktu_selesai: String;
  ruangan_nama: String;
  status: StatusSeminar;
}

export interface JadwalLog {
  id: string;
  jadwal_seminar_id: string;
  log_type: LogType;
  nip: string;
  tanggal_lama?: Date | null;
  tanggal_baru?: Date | null;
  ruangan_lama?: string | null;
  ruangan_baru?: string | null;
  keterangan?: string | null;
  created_at: Date;
}

export interface JadwalConflickCheck {
  tanggal: Date;
  waktu_mulai: Date;
  waktu_selesai: Date;
  nip: string;
  ruangan_nama?: string;
}

export interface CreateJadwalInput {
  nim: string;
  nip: string;
  tanggal: Date;
  waktu_mulai: Date;
  waktu_selesai: Date;
  ruangan_nama: string;
}

export interface UpdateJadwalInput {
  tanggal?: Date;
  waktu_mulai?: Date;
  waktu_selesai?: Date;
  nip?: string;
  ruangan_nama?: string;
  status?: StatusSeminar;
}

export interface JadwalFilters {
  nim?: string;
  nip?: string;
  status?: StatusSeminar;
}

export interface LogJadwalEntry {
  jadwal_seminar_id: string;
  log_type: LogType;
  nip: string;
  tanggal_lama?: Date;
  tanggal_baru?: Date;
  ruangan_lama?: string;
  ruangan_baru?: string;
}
