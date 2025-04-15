const express = require("express");
const router = express.Router();
const auth = require("../middleware/user.middleware");
const { body } = require("express-validator");
const fileController = require("../controller/fileController");

router.post("/upload-file", auth, fileController.uploadFiles);

router.get("/get-file", auth, fileController.getFiles);

router.post("/rename-file", auth, fileController.renameFile);

router.post("/delete-file", auth, fileController.deleteFile);

module.exports = router;
