-- CreateEnum
CREATE TYPE "DokumenStatus" AS ENUM ('submitted', 'verified', 'rejected');

-- CreateEnum
CREATE TYPE "JenisDokumen" AS ENUM ('SURAT_KETERANGAN_SELESAI_KP', 'LAPORAN_TAMBAHAN_KP', 'ID_SURAT_UNDANGAN', 'FORM_KEHADIRAN_SEMINAR', 'SURAT_UNDANGAN_SEMINAR_HASIL', 'BERITA_ACARA_SEMINAR', 'DAFTAR_HADIR_SEMINAR', 'LEMBAR_PENGESAHAN_KP', 'REVISI_DAILY_REPORT', 'REVISI_LAPORAN_TAMBAHAN', 'SISTEM_KP_FINAL');

-- CreateEnum
CREATE TYPE "StatusSeminar" AS ENUM ('pending', 'scheduled', 'completed', 'cancelled');

-- CreateEnum
CREATE TYPE "LogType" AS ENUM ('created', 'updated', 'cancelled', 'rescheduled');

-- CreateTable
CREATE TABLE "Mahasiswa" (
    "nim" TEXT NOT NULL,
    "nama" TEXT NOT NULL,
    "no_telepon" TEXT NOT NULL,

    CONSTRAINT "Mahasiswa_pkey" PRIMARY KEY ("nim")
);

-- CreateTable
CREATE TABLE "Dosen" (
    "nip" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "nama" TEXT NOT NULL,
    "no_telepon" TEXT NOT NULL,

    CONSTRAINT "Dosen_pkey" PRIMARY KEY ("nip")
);

-- CreateTable
CREATE TABLE "Dokumen" (
    "id" TEXT NOT NULL,
    "nim" TEXT NOT NULL,
    "jenis_dokumen" "JenisDokumen" NOT NULL,
    "file_path" TEXT NOT NULL,
    "tanggal_upload" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" "DokumenStatus" NOT NULL DEFAULT 'submitted',
    "komentar" TEXT,

    CONSTRAINT "Dokumen_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Jadwal" (
    "id" TEXT NOT NULL,
    "nim" TEXT NOT NULL,
    "nip" TEXT NOT NULL,
    "tanggal" TIMESTAMP(3) NOT NULL,
    "waktu_mulai" TIMESTAMP(3) NOT NULL,
    "waktu_selesai" TIMESTAMP(3) NOT NULL,
    "ruangan_nama" TEXT NOT NULL,
    "status" "StatusSeminar" NOT NULL DEFAULT 'pending',

    CONSTRAINT "Jadwal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ruangan" (
    "nama" TEXT NOT NULL,

    CONSTRAINT "Ruangan_pkey" PRIMARY KEY ("nama")
);

-- CreateTable
CREATE TABLE "LogJadwal" (
    "id" TEXT NOT NULL,
    "jadwal_seminar_id" TEXT NOT NULL,
    "log_type" "LogType" NOT NULL,
    "nip" TEXT NOT NULL,
    "tanggal_lama" TIMESTAMP(3),
    "tanggal_baru" TIMESTAMP(3),
    "ruangan_lama" TEXT,
    "ruangan_baru" TEXT,
    "keterangan" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LogJadwal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Nilai" (
    "id" TEXT NOT NULL,
    "nim" TEXT NOT NULL,
    "jadwal_seminar_id" TEXT NOT NULL,
    "nip_penguji" TEXT NOT NULL,
    "nip_pembimbing" TEXT NOT NULL,
    "nilai_pembimbing" DOUBLE PRECISION NOT NULL,
    "nilai_penguji" DOUBLE PRECISION NOT NULL,
    "note_pembimbing" TEXT,
    "note_penguji" TEXT,

    CONSTRAINT "Nilai_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_MahasiswaToNilai" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,

    CONSTRAINT "_MahasiswaToNilai_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE UNIQUE INDEX "Mahasiswa_nim_key" ON "Mahasiswa"("nim");

-- CreateIndex
CREATE UNIQUE INDEX "Mahasiswa_no_telepon_key" ON "Mahasiswa"("no_telepon");

-- CreateIndex
CREATE UNIQUE INDEX "Dosen_nip_key" ON "Dosen"("nip");

-- CreateIndex
CREATE UNIQUE INDEX "Dosen_email_key" ON "Dosen"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Dosen_no_telepon_key" ON "Dosen"("no_telepon");

-- CreateIndex
CREATE INDEX "Dokumen_nim_idx" ON "Dokumen"("nim");

-- CreateIndex
CREATE INDEX "Jadwal_nim_idx" ON "Jadwal"("nim");

-- CreateIndex
CREATE INDEX "Jadwal_nip_idx" ON "Jadwal"("nip");

-- CreateIndex
CREATE INDEX "Jadwal_ruangan_nama_idx" ON "Jadwal"("ruangan_nama");

-- CreateIndex
CREATE UNIQUE INDEX "Ruangan_nama_key" ON "Ruangan"("nama");

-- CreateIndex
CREATE INDEX "LogJadwal_jadwal_seminar_id_idx" ON "LogJadwal"("jadwal_seminar_id");

-- CreateIndex
CREATE INDEX "Nilai_jadwal_seminar_id_idx" ON "Nilai"("jadwal_seminar_id");

-- CreateIndex
CREATE UNIQUE INDEX "Nilai_jadwal_seminar_id_key" ON "Nilai"("jadwal_seminar_id");

-- CreateIndex
CREATE INDEX "_MahasiswaToNilai_B_index" ON "_MahasiswaToNilai"("B");

-- AddForeignKey
ALTER TABLE "Dokumen" ADD CONSTRAINT "Dokumen_nim_fkey" FOREIGN KEY ("nim") REFERENCES "Mahasiswa"("nim") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Jadwal" ADD CONSTRAINT "Jadwal_nim_fkey" FOREIGN KEY ("nim") REFERENCES "Mahasiswa"("nim") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Jadwal" ADD CONSTRAINT "Jadwal_nip_fkey" FOREIGN KEY ("nip") REFERENCES "Dosen"("nip") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Jadwal" ADD CONSTRAINT "Jadwal_ruangan_nama_fkey" FOREIGN KEY ("ruangan_nama") REFERENCES "Ruangan"("nama") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Nilai" ADD CONSTRAINT "Nilai_jadwal_seminar_id_fkey" FOREIGN KEY ("jadwal_seminar_id") REFERENCES "Jadwal"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Nilai" ADD CONSTRAINT "Nilai_nip_penguji_fkey" FOREIGN KEY ("nip_penguji") REFERENCES "Dosen"("nip") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Nilai" ADD CONSTRAINT "Nilai_nip_pembimbing_fkey" FOREIGN KEY ("nip_pembimbing") REFERENCES "Dosen"("nip") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_MahasiswaToNilai" ADD CONSTRAINT "_MahasiswaToNilai_A_fkey" FOREIGN KEY ("A") REFERENCES "Mahasiswa"("nim") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_MahasiswaToNilai" ADD CONSTRAINT "_MahasiswaToNilai_B_fkey" FOREIGN KEY ("B") REFERENCES "Nilai"("id") ON DELETE CASCADE ON UPDATE CASCADE;
