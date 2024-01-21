const jwt = require('jsonwebtoken');

const auth = async (req, res, next)=> {
    try {
        const token = req.header('x-auth-token');
        if(!token)
        return res.status(401).json({"status": false, msg: "No auth token,  access denied"});

        const verified = jwt.verify(token, "passwordKey");
        if(!verified) return res.status(401).json({"status": false, msg: "Token Verification failed, authorization denied."});

      req.user = verified.id;
      req.token = token;
      next();
    } catch (error) {
        res.status(500).json({"status": false, error: error.message});
    }
};

module.exports = auth;