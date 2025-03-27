import prisma from "../src/configs/prisma.config";

async function main() {
  await prisma.ruangan
    .createMany({
      data: [
        { nama: "FST-301" }, 
        { nama: "FST-302" }, 
        { nama: "FST-303" }, 
        { nama: "FST-304" }, 
        { nama: "FST-305" },
        { nama: "FST-306" },
        { nama: "FST-307" },
        { nama: "FST-308" },
      ],
    })
    .then(() => {
      console.log("[INFO] Ruangan berhasil dibuat");
    })
    .catch((err) => {
      console.error("Error: ", err);
    });
}

main()
    .catch(e => {
        return console.error(`[ERROR] ${e.message}`);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
