const mongoose = require('mongoose');


function connectDB() {
    mongoose.connect('mongodb+srv://vivek:vivek123@cluster0.gkhpl.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0').then(() => {
        console.log('connected to DB')
    });
}


module.exports = connectDB;