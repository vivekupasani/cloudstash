const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || "acernity";

const auth = async (req, res, next) => {
    try {
        const token = req.header('x-auth-token');

        if (!token) {
            return res.status(401).json({ msg: 'No auth token, access denied.' });
        }

        const verified = jwt.verify(token, JWT_SECRET);

        if (!verified) {
            return res.status(401).json({ msg: 'Token verification failed, authorization denied.' });
        }

        req.user = verified.id;   
        req.token = token;       
        next();
    } catch (e) {
  
        if (e.name === 'TokenExpiredError') {
            console.warn('Token expired for request:', req.headers);
            return res.status(401).json({ msg: 'Token has expired, please log in again or refresh your token.' });
        } else if (e.name === 'JsonWebTokenError') {
            return res.status(401).json({ msg: 'Invalid token format or signature, access denied.' });
        }
        // Log any unexpected errors
        console.error('Authentication Error:', e);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
};

module.exports = auth;
