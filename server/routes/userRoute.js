const express = require("express");
const router = express.Router();
const { body, validationResult } = require("express-validator");
const userController = require("../controller/userController");
const auth = require("../middleware/user.middleware");

// Register Route
router.post(
  "/register",
  body("email").trim().isEmail().withMessage("Please enter a valid email"),
  body("password")
    .trim()
    .isLength({ min: 5 })
    .withMessage("Password must be at least 5 characters long"),
  body("username")
    .trim()
    .isLength({ min: 3 })
    .withMessage("Username must be at least 3 characters long"),
  userController.register
);

// Login Route
router.post(
  "/login",
  // Validating input
  body("email").trim().isEmail().withMessage("Please enter a valid email"),
  body("password")
    .trim()
    .isLength({ min: 5 })
    .withMessage("Password must be at least 5 characters long"),
  userController.login
);

// Details Route (Requires Authentication)
router.get("/profile", auth, userController.profile);

router.post("/update-profile", auth, userController.updateProfile);

router.post("/change-password", auth, userController.changePassword);
module.exports = router;
