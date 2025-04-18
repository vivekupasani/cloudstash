const fileModel = require("../models/file.model");
const mongoose = require("mongoose");
const NodeCache = require("node-cache");

const myCache = new NodeCache({ stdTTL: 43200 });

exports.uploadFiles = async (req, res) => {
  const { name, userId, file, fileType, fileSize } = req.body;

  try {
    const newFile = new fileModel({
      name,
      userId,
      file,
      fileType,
      fileSize,
    });

    const saveFile = await newFile.save();

    // Invalidate the cache for this user
    const cacheKey = `files_${userId}`;
    myCache.del(cacheKey);

    res.status(200).json({ msg: "File uploaded successfully", saveFile });
  } catch (e) {
    console.error("Error during uploading:", e);
    res.status(500).json({ msg: "Server error", error: e.message });
  }
};

exports.getFiles = async (req, res) => {
  try {
    const cacheKey = `files_${req.user}`; // Use user-specific cache key
    const getCacheFile = myCache.get(cacheKey);

    if (getCacheFile) {
      return res.status(200).json({
        files: getCacheFile,
        msg: "Files fetched from cache successfully",
      });
    }

    const getFile = await fileModel.find({ userId: req.user });

    if (getFile) {
      myCache.set(cacheKey, getFile);
    }

    return res
      .status(200)
      .json({ files: getFile, msg: "Files fetched successfully" });
  } catch (e) {
    console.error("Error during fetching:", e);
    res.status(500).json({ msg: "Server error", error: e.message });
  }
};

exports.renameFile = async (req, res) => {
  try {
    const { fileId, name } = req.body;

    if (!mongoose.Types.ObjectId.isValid(fileId)) {
      return res.status(400).json({ msg: "Invalid file ID" });
    }

    const file = await fileModel.findOne({ _id: fileId });

    if (!file) {
      return res.status(404).json({ msg: "File not found" });
    }

    file.name = name;

    await file.save();

    // Invalidate the cache for this user
    const cacheKey = `files_${req.user}`;
    myCache.del(cacheKey);

    res.status(200).json({ msg: "File updated successfully", file });
  } catch (e) {
    console.error("Error during updating:", e);
    res.status(500).json({ msg: "Server error", error: e.message });
  }
};

exports.deleteFile = async (req, res) => {
  try {
    const { _id } = req.body;

    // Check if _id is a valid ObjectId
    if (!mongoose.Types.ObjectId.isValid(_id)) {
      return res.status(400).json({ msg: "Invalid file ID" });
    }

    const deleteFile = await fileModel.findByIdAndDelete(_id);

    if (!deleteFile) {
      return res.status(404).json({ msg: "File not found" });
    }

    // Invalidate the cache for this user
    const cacheKey = `files_${req.user}`;
    myCache.del(cacheKey);

    return res.status(200).json({ msg: "File deleted successfully" });
  } catch (e) {
    console.error("Error during deleting:", e);
    res.status(500).json({ msg: "Server error", error: e.message });
  }
};
