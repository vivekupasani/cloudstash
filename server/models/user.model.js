const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    username: {
      type: String,
      required: [true, "Username is required"],
      trim: true,
      minlength: [3, "Username must be at least 3 characters long"],
      maxlength: [50, "Username cannot exceed 50 characters"],
    },

    email: {
      type: String,
      trim: true,
      unique: true,
      match: [/.+\@.+\..+/, "Please enter a valid email address"],
    },

    password: {
      type: String,
      trim: true,
      minlength: [5, "Password must be at least 5 characters long"],
    },
    proffession: {
      type: String,
      required: [true, "Proffession is required"],
      trim: true,
      minlength: [3, "Proffession must be at least 3 characters long"],
    },
    about: {
      type: String,
      required: [true, "About is required"],
      trim: true,
      minlength: [3, "About must be at least 3 characters long"],
    },
  },
  {
    timestamps: true,
  }
);

const User = mongoose.model("User", userSchema);

module.exports = User;
