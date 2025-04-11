import express from 'express';
import cors from 'cors';
import RuanganRoutes from './routes/ruangan.routes';
import JadwalRoutes from './routes/jadwal.routes';
import MahasiswaRoutes from './routes/mahasiswa.routes';

const app = express();
app.use(cors());
app.use(express.json());

app.use('/semkp', RuanganRoutes);
app.use('/semkp', JadwalRoutes);
app.use('/semkp', MahasiswaRoutes);

app.listen(3000, () => {
  console.log("Server started on http://localhost:3000");
});