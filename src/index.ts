import express from 'express';
import cors from 'cors';
import {createExpressMiddleware} from "@trpc/server/adapters/express"
import {appRouter} from './trpc';

const app = express();
app.use(cors());
app.use(express.json());

app.use("/trpc", createExpressMiddleware({router: appRouter}));

app.listen(3000, () => {
  console.log("Server started on http://localhost:3000");
});