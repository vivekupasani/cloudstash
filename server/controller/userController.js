const userModel = require("../models/user.model");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { validationResult } = require("express-validator");

const JWT_SECRET = process.env.JWT_SECRET || "default_jwt_secret";
const SALT = parseInt(process.env.SALT, 10) || 10;

// Register
exports.register = async (req, res) => {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    return res
      .status(400)
      .json({ msg: "Validation failed", errors: errors.array() });
  }

  const { username, email, password, proffession, about } = req.body;

  try {
    // Check if user exists
    const existingUser = await userModel.findOne({ email });

    if (existingUser) {
      return res.status(400).json({ msg: "User already exists" });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, SALT);
    const newUser = new userModel({
      username,
      email,
      password: hashedPassword,
      proffession,
      about,
    });
    const savedUser = await newUser.save();

    // Generate JWT
    const token = jwt.sign(
      { id: savedUser._id, email: savedUser.email },
      JWT_SECRET
    );

    res.status(200).json({
      msg: "User registered successfully",
      user: savedUser,
      token,
    });
  } catch (error) {
    console.error("Error during registration:", error);
    res.status(500).json({ msg: "Server error", error: error.message });
  }
};

// Login
exports.login = async (req, res) => {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { email, password } = req.body;

  try {
    // Check if user exists
    const user = await userModel.findOne({ email });

    if (!user) {
      return res
        .status(400)
        .json({ errors: [{ msg: "Invalid email or password" }] });
    }

    // Validate password
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res
        .status(400)
        .json({ errors: [{ msg: "Invalid email or password" }] });
    }

    // Generate JWT
    const token = jwt.sign({ id: user._id, email: user.email }, JWT_SECRET);

    res.status(200).json({ msg: "Login successful", user, token });
  } catch (error) {
    console.error("Error during login:", error);
    res
      .status(500)
      .json({ msg: "Internal server error", error: error.message });
  }
};

// Profile
exports.profile = async (req, res) => {
  try {
    // Fetch user details from the database
    const user = await userModel.findById(req.user);

    if (!user) {
      return res.status(404).json({ msg: "User not found" });
    }

    res.status(200).json({ msg: "Profile fetched successfully", user });
  } catch (error) {
    console.error("Error fetching user details:", error);
    res
      .status(500)
      .json({ msg: "Internal Server Error", error: error.message });
  }
};

// Update Profile
exports.updateProfile = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { username, proffession, about } = req.body;

  try {
    const user = await userModel.findById(req.user);
    if (!user) {
      return res.status(404).json({ msg: "User not found" });
    }

    // Update only the allowed fields
    if (username) user.username = username;
    if (proffession) user.proffession = proffession;
    if (about) user.about = about;

    const updatedUser = await user.save();

    res
      .status(200)
      .json({ msg: "Profile updated successfully", user: updatedUser });
  } catch (error) {
    console.error("Error updating profile:", error);
    res.status(500).json({ msg: "Server error", error: error.message });
  }
};

// Change Password
exports.changePassword = async (req, res) => {
  const { oldPassword, newPassword } = req.body;
  try {
    const user = await userModel.findById(req.user);
    if (!user) {
      return res.status(404).json({ msg: "User not found" });
    }

    // Validate old password
    const isMatch = await bcrypt.compare(oldPassword, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Invalid old password" });
    }

    // Hash new password
    const hashedPassword = await bcrypt.hash(newPassword, SALT);

    user.password = hashedPassword;
    const updatedUser = await user.save();

    res
      .status(200)
      .json({ msg: "Password changed successfully", user: updatedUser });
  } catch (error) {
    console.error("Error during password change:", error);
    res.status(500).json({ msg: "Server error", error: error.message });
  }
};