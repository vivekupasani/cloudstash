const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    username: {
        type: String,
        required: [true, 'Username is required'], // Makes this field mandatory
        trim: true,
        minlength: [3, 'Username must be at least 3 characters long'], // Minimum length
        maxlength: [50, 'Username cannot exceed 50 characters'], // Maximum length
    },

    email: {
        type: String,
        required: [true, 'Email is required'], // Makes this field mandatory
        trim: true,
        unique: true, // Ensures email is unique
        match: [/.+\@.+\..+/, 'Please enter a valid email address'], // Validates email format
    },

    password: {
        type: String,
        required: [true, 'Password is required'], // Makes this field mandatory
        trim: true,
        minlength: [5, 'Password must be at least 5 characters long'], // Minimum length
    },
}, {
    timestamps: true
});

// Model
const User = mongoose.model('User', userSchema);

module.exports = User;
