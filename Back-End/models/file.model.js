const mongoose = require('mongoose');


const fileSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },

    uid: {
        type: String,
        required: true,
        trim: true
    },

    files: {
        type: String,
        required: true,
    }
}, {
    timestamps: true
});


const file = mongoose.model('files', fileSchema);

module.exports = file;