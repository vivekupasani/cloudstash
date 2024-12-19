const express = require('express');
const router = express.Router();
const fileModel = require('../models/file.model');
const auth = require('../middleware/user.middleware');
const mongoose = require('mongoose');
const { body, validationResult } = require('express-validator');

router.post('/upload-files', async (req, res) => {
    const { name, uid, files } = req.body;

    try {
        const newFile = new fileModel({ name, uid, files });

        const saveFile = await newFile.save();

        res.status(200).json({ msg: 'File uploaded successfully' })
    }
    catch (e) {
        console.error('Error during uploading:', e);
        res.status(500).json({ msg: 'Server error', error: e.message });
    }
});

router.post('/get-files',
    body('uid').isMongoId().withMessage('Invalid UID'),
    async (req, res) => {
        const { uid } = req.body;
        try {

            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(400).json({ errors: errors.array() });
            }

            const getFile = await fileModel.find({ uid });

            return res.status(200).json({ files: getFile, msg: 'Files fetched successfully' })
        }
        catch (e) {
            console.error('Error during fetching:', e);
            res.status(500).json({ msg: 'Server error', error: e.message });
        }
    });

router.post('/update-file', async (req, res) => {
    try {
        const { _id, name } = req.body;

        const file = await fileModel.findOne({ _id });

        if (!file) {
            return res.status(404).json({ msg: 'File not found' });
        }

        file.name = name;

        await file.save();

        res.status(200).json({ msg: 'File updated successfully', file });
    }
    catch (e) {
        console.error('Error during fetching:', e);
        res.status(500).json({ msg: 'Server error', error: e.message });
    }
});

router.post('/delete-file', async (req, res) => {
    try {
        const { _id } = req.body;

        // Check if _id is a valid ObjectId
        if (!mongoose.Types.ObjectId.isValid(_id) || _id.trim() === '') {
            return res.status(400).json({ msg: 'Invalid file ID' });
        }

        const deleteFile = await fileModel.findOneAndDelete({ _id });

        if (!deleteFile) {
            return res.status(404).json({ msg: 'File not found' });
        }

        return res.status(200).json({ msg: 'File deleted successfully' })
    }
    catch (e) {
        console.error('Error during fetching:', e);
        res.status(500).json({ msg: 'Server error', error: e.message });
    }
});

module.exports = router;