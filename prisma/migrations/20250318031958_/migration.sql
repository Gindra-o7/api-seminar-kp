-- CreateEnum
CREATE TYPE "RoleType" AS ENUM ('mahasiswa', 'dosen_pembimbing', 'dosen_penguji', 'kaprodi', 'koordinator', 'pembimbing_instansi');

-- CreateEnum
CREATE TYPE "DokumenStatus" AS ENUM ('submitted', 'verified', 'rejected');

-- CreateEnum
CREATE TYPE "KategoriDokumen" AS ENUM ('PERSYARATAN', 'PENDAFTARAN', 'PASCA_SEMINAR');

-- CreateEnum
CREATE TYPE "JenisDokumen" AS ENUM ('SURAT_KETERANGAN_SELESAI_KP', 'LEMBAR_PERNYATAAN_SELESAI_KP', 'DAILY_REPORT', 'LAPORAN_TAMBAHAN_KP', 'SURAT_BIMBINGAN_DOSEN', 'SETORAN_HAFALAN', 'FORM_KEHADIRAN_SEMINAR', 'LEMBAR_FORM_BIMBINGAN', 'PENGAJUAN_PENDAFTARAN_DISEMINASI', 'SURAT_UNDANGAN_SEMINAR_HASIL', 'BERITA_ACARA_SEMINAR', 'DAFTAR_HADIR_SEMINAR', 'LEMBAR_PENGESAHAN_KP');

-- CreateEnum
CREATE TYPE "StatusSeminar" AS ENUM ('pending', 'scheduled', 'completed', 'cancelled');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "nama" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "photoPath" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Role" (
    "id" TEXT NOT NULL,
    "name" "RoleType" NOT NULL,

    CONSTRAINT "Role_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserRole" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "roleId" TEXT NOT NULL,

    CONSTRAINT "UserRole_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Mahasiswa" (
    "id" TEXT NOT NULL,
    "nim" TEXT NOT NULL,
    "noHp" TEXT,
    "semester" INTEGER,
    "userId" TEXT NOT NULL,

    CONSTRAINT "Mahasiswa_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Dosen" (
    "id" TEXT NOT NULL,
    "nip" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "isPembimbing" BOOLEAN NOT NULL DEFAULT false,
    "isPenguji" BOOLEAN NOT NULL DEFAULT false,
    "isKaprodi" BOOLEAN NOT NULL DEFAULT false,
    "isKoordinator" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Dosen_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PembimbingInstansi" (
    "id" TEXT NOT NULL,
    "instansi" TEXT NOT NULL,
    "jabatan" TEXT,
    "noTelpon" TEXT,
    "userId" TEXT NOT NULL,

    CONSTRAINT "PembimbingInstansi_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MahasiswaKp" (
    "id" TEXT NOT NULL,
    "nim" TEXT,
    "pembimbingInstansiId" TEXT,
    "dosenPembimbingId" TEXT,
    "mulaiKp" TIMESTAMP(3),
    "selesaiKp" TIMESTAMP(3),
    "judulLaporan" TEXT,
    "namaInstansi" TEXT,
    "alamatInstansi" TEXT,
    "namaPembimbingInstansi" TEXT,
    "jabatanPembimbingInstansi" TEXT,
    "noTeleponPembimbing" TEXT,
    "emailPembimbingInstansi" TEXT,

    CONSTRAINT "MahasiswaKp_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Dokumen" (
    "id" TEXT NOT NULL,
    "nim" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "jenisDokumen" "JenisDokumen" NOT NULL,
    "kategori" "KategoriDokumen" NOT NULL,
    "filePath" TEXT NOT NULL,
    "tanggalUpload" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" "DokumenStatus" NOT NULL DEFAULT 'submitted',
    "komentar" TEXT,

    CONSTRAINT "Dokumen_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DokumenHistory" (
    "id" TEXT NOT NULL,
    "dokumenId" TEXT NOT NULL,
    "nim" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "jenisDokumen" "JenisDokumen" NOT NULL,
    "kategori" "KategoriDokumen" NOT NULL,
    "filePath" TEXT NOT NULL,
    "tanggalUpload" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "version" INTEGER NOT NULL DEFAULT 1,

    CONSTRAINT "DokumenHistory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "JadwalSeminar" (
    "id" TEXT NOT NULL,
    "nim" TEXT NOT NULL,
    "tanggal" TIMESTAMP(3) NOT NULL,
    "waktuMulai" TIMESTAMP(3) NOT NULL,
    "waktuSelesai" TIMESTAMP(3) NOT NULL,
    "ruangan" TEXT NOT NULL,
    "status" "StatusSeminar" NOT NULL DEFAULT 'pending',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "dosenId" TEXT NOT NULL,

    CONSTRAINT "JadwalSeminar_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Nilai" (
    "id" TEXT NOT NULL,
    "jadwalSeminarId" TEXT,
    "nilaiPembimbing" DOUBLE PRECISION,
    "nilaiPenguji" DOUBLE PRECISION,
    "nilaiPembimbingInstansi" DOUBLE PRECISION,
    "dosenPembimbingId" TEXT,
    "dosenPengujiId" TEXT,
    "pembimbingInstansiId" TEXT,
    "nilaiAkhir" DOUBLE PRECISION,
    "isFinalized" BOOLEAN NOT NULL DEFAULT false,
    "finalizedBy" TEXT,
    "finalizedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3),
    "nim" TEXT NOT NULL,

    CONSTRAINT "Nilai_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Role_name_key" ON "Role"("name");

-- CreateIndex
CREATE UNIQUE INDEX "UserRole_userId_roleId_key" ON "UserRole"("userId", "roleId");

-- CreateIndex
CREATE UNIQUE INDEX "Mahasiswa_nim_key" ON "Mahasiswa"("nim");

-- CreateIndex
CREATE UNIQUE INDEX "Mahasiswa_noHp_key" ON "Mahasiswa"("noHp");

-- CreateIndex
CREATE UNIQUE INDEX "Mahasiswa_userId_key" ON "Mahasiswa"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Dosen_nip_key" ON "Dosen"("nip");

-- CreateIndex
CREATE UNIQUE INDEX "Dosen_userId_key" ON "Dosen"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "PembimbingInstansi_noTelpon_key" ON "PembimbingInstansi"("noTelpon");

-- CreateIndex
CREATE UNIQUE INDEX "PembimbingInstansi_userId_key" ON "PembimbingInstansi"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "MahasiswaKp_nim_key" ON "MahasiswaKp"("nim");

-- CreateIndex
CREATE INDEX "Dokumen_nim_idx" ON "Dokumen"("nim");

-- CreateIndex
CREATE INDEX "DokumenHistory_nim_dokumenId_idx" ON "DokumenHistory"("nim", "dokumenId");

-- CreateIndex
CREATE INDEX "JadwalSeminar_nim_idx" ON "JadwalSeminar"("nim");

-- CreateIndex
CREATE UNIQUE INDEX "Nilai_jadwalSeminarId_key" ON "Nilai"("jadwalSeminarId");

-- AddForeignKey
ALTER TABLE "UserRole" ADD CONSTRAINT "UserRole_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserRole" ADD CONSTRAINT "UserRole_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "Role"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Mahasiswa" ADD CONSTRAINT "Mahasiswa_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Dosen" ADD CONSTRAINT "Dosen_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PembimbingInstansi" ADD CONSTRAINT "PembimbingInstansi_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MahasiswaKp" ADD CONSTRAINT "MahasiswaKp_nim_fkey" FOREIGN KEY ("nim") REFERENCES "Mahasiswa"("nim") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MahasiswaKp" ADD CONSTRAINT "MahasiswaKp_pembimbingInstansiId_fkey" FOREIGN KEY ("pembimbingInstansiId") REFERENCES "PembimbingInstansi"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MahasiswaKp" ADD CONSTRAINT "MahasiswaKp_dosenPembimbingId_fkey" FOREIGN KEY ("dosenPembimbingId") REFERENCES "Dosen"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Dokumen" ADD CONSTRAINT "Dokumen_nim_fkey" FOREIGN KEY ("nim") REFERENCES "Mahasiswa"("nim") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Dokumen" ADD CONSTRAINT "Dokumen_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DokumenHistory" ADD CONSTRAINT "DokumenHistory_dokumenId_fkey" FOREIGN KEY ("dokumenId") REFERENCES "Dokumen"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DokumenHistory" ADD CONSTRAINT "DokumenHistory_nim_fkey" FOREIGN KEY ("nim") REFERENCES "Mahasiswa"("nim") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DokumenHistory" ADD CONSTRAINT "DokumenHistory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JadwalSeminar" ADD CONSTRAINT "JadwalSeminar_nim_fkey" FOREIGN KEY ("nim") REFERENCES "Mahasiswa"("nim") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JadwalSeminar" ADD CONSTRAINT "JadwalSeminar_dosenId_fkey" FOREIGN KEY ("dosenId") REFERENCES "Dosen"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Nilai" ADD CONSTRAINT "Nilai_jadwalSeminarId_fkey" FOREIGN KEY ("jadwalSeminarId") REFERENCES "JadwalSeminar"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Nilai" ADD CONSTRAINT "Nilai_nim_fkey" FOREIGN KEY ("nim") REFERENCES "Mahasiswa"("nim") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Nilai" ADD CONSTRAINT "Nilai_dosenPembimbingId_fkey" FOREIGN KEY ("dosenPembimbingId") REFERENCES "Dosen"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Nilai" ADD CONSTRAINT "Nilai_dosenPengujiId_fkey" FOREIGN KEY ("dosenPengujiId") REFERENCES "Dosen"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Nilai" ADD CONSTRAINT "Nilai_pembimbingInstansiId_fkey" FOREIGN KEY ("pembimbingInstansiId") REFERENCES "PembimbingInstansi"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Nilai" ADD CONSTRAINT "Nilai_finalizedBy_fkey" FOREIGN KEY ("finalizedBy") REFERENCES "Dosen"("id") ON DELETE SET NULL ON UPDATE CASCADE;
