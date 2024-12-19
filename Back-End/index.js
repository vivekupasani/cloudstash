const express = require('express');
const app = express();
const connectDB = require('./config/db')

const cors = require('cors');
app.use(cors());

const userRouter = require('./routes/user.route')
const filesRouter = require('./routes/files.route')

connectDB();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.set('view engine', 'ejs')
app.use('/user', userRouter)
app.use('/files', filesRouter);


app.listen(3000, () => {
    console.log('Server is running on the PORT 3000')
});