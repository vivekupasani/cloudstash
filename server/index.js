const express = require("express");
require("dotenv").config();
const cors = require("cors");
const connectDB = require("./config/db");
const userRouter = require("./routes/userRoute");
const filesRouter = require("./routes/fileRoute");
const PORT = process.env.PORT;

const app = express();

connectDB();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/user", userRouter);
app.use("/files", filesRouter);

app.listen(PORT, () => {
  console.log(`Server is running on the PORT ${PORT}`);
});
