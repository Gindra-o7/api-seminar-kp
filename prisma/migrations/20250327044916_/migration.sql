/*
  Warnings:

  - You are about to drop the column `no_telepon` on the `Dosen` table. All the data in the column will be lost.
  - You are about to drop the column `no_telepon` on the `Mahasiswa` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[chat_id]` on the table `Dosen` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `chat_id` to the `Dosen` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "Dosen_no_telepon_key";

-- DropIndex
DROP INDEX "Mahasiswa_no_telepon_key";

-- AlterTable
ALTER TABLE "Dosen" DROP COLUMN "no_telepon",
ADD COLUMN     "chat_id" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Mahasiswa" DROP COLUMN "no_telepon";

-- CreateIndex
CREATE UNIQUE INDEX "Dosen_chat_id_key" ON "Dosen"("chat_id");
