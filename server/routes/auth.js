const express = require("express");
const bcryptjs = require("bcryptjs");
const User = require("../models/user");
const jwt  = require("jsonwebtoken");
const authRouter = express.Router();


//Sign Up
authRouter.post("/api/signup", async(req, res)=>{
    try {
        const {name, email, password, userType, studentId} = req.body;

        const existingUser = await User.findOne({email});
        if(existingUser){
            return res
            .status(400)
            .json({"status": false, msg: "User With same email already exists!"});l
        }

        const hasedPassword = await bcryptjs.hash(password, 8);

        let user = new User({
            email,
            password: hasedPassword,
            name,
            userType,
            studentId
        });
        user = await user.save();
        res.json({"status": true, user});
    } catch (error) {
        res.status(500)
        .json({"status": false, msg: error.message});
    }
});

//Sign In'
authRouter.post("/api/signin", async (req, res)=>{
try {
    const {email, password} = req.body;

    const user = await User.findOne({ email });
    if(!user){
        return res.status(400)
        .json({"status": false, msg: 'User with this email does not exit'});
    }
    const isMatch = await bcryptjs.compare(password, user.password);
    if(!isMatch){
        return res.status(400).json({msg: "Incorrect Password."});
    }
    const token = jwt.sign({id: user._id}, "passwordKey");
    res.json({"status": true, token, ...user._doc});
} catch (error) {
    res.status(500).json({"status": false,error :error.message});
}
});

module.exports = authRouter;