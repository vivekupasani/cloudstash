const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const userModel = require('../models/user.model');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const auth = require('../middleware/user.middleware')

// Secret key for JWT
const JWT_SECRET = process.env.JWT_SECRET || "100XCODES";

// Register Route
router.post('/register',
    body('email').trim().isEmail().withMessage('Please enter a valid email'),
    body('password').trim().isLength({ min: 5 }).withMessage('Password must be at least 5 characters long'),
    body('username').trim().isLength({ min: 3 }).withMessage('Username must be at least 3 characters long'),
    async (req, res) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ msg: 'Validation failed', errors: errors.array() });
        }

        const { username, email, password } = req.body;

        try {
            // Check if user exists
            const existingUser = await userModel.findOne({ email });

            if (existingUser) {
                return res.status(400).json({ msg: 'User already exists' });
            }

            // Hash password
            const hashedPassword = await bcrypt.hash(password, 10);
            const newUser = new userModel({ username, email, password: hashedPassword });
            const savedUser = await newUser.save();

            // Generate JWT
            const token = jwt.sign({ id: savedUser._id, email: savedUser.email }, JWT_SECRET);

            // Clean user data
            const userData = {
                id: savedUser._id,
                username: savedUser.username,
                email: savedUser.email,
                createdAt: savedUser.createdAt,
                updatedAt: savedUser.updatedAt
            };

            res.status(200).json({
                msg: 'User registered successfully',
                user: userData,
                token
            });
        } catch (error) {
            console.error('Error during registration:', error);
            res.status(500).json({ msg: 'Server error', error: error.message });
        }
    }
);



// Login Route
router.post('/login',
    // Validating input
    body('email').trim().isEmail().withMessage('Please enter a valid email'),
    body('password').trim().isLength({ min: 5 }).withMessage('Password must be at least 5 characters long'),
    async (req, res) => {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const { email, password } = req.body;

        try {
            // Check if user exists
            const user = await userModel.findOne({ email });

            if (!user) {
                return res.status(400).json({ errors: [{ msg: 'Invalid email or password' }] });
            }

            const userData = {
                id: user._id,
                username: user.username,
                email: user.email,
                createdAt: user.createdAt,
                updatedAt: user.updatedAt
            };

            // Validate password
            const isMatch = await bcrypt.compare(password, user.password);

            if (!isMatch) {
                return res.status(400).json({ errors: [{ msg: 'Invalid email or password' }] });
            }

            // Generate JWT
            const token = jwt.sign({ id: user._id, email: user.email }, JWT_SECRET, { expiresIn: '1h' });

            res.status(200).json({ msg: 'Login successful', userData, token });
        } catch (error) {
            console.error('Error during login:', error);
            res.status(500).json({ msg: 'Internal server error', error: error.message });
        }
    }
);



// Details Route (Requires Authentication)
router.get('/details', auth, async (req, res) => {
    try {
        const user = await userModel.findById(req.user);

        // Send only relevant user data and token, not the full MongoDB document
        const userData = {
            id: user._id,
            username: user.username,
            email: user.email,
            createdAt: user.createdAt,
            updatedAt: user.updatedAt,
        };

        res.json({ user: userData, token: req.token });
    } catch (error) {
        console.error('Error fetching user details:', error);
        res.status(500).json({ msg: 'Internal Server Error', error: error.message });
    }
});

module.exports = router;
