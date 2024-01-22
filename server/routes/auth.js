const express = require("express");
const bcryptjs = require("bcryptjs");
const jwt  = require("jsonwebtoken");
const auth = require('../middlewares/auth');
const User = require('../models/user');
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
        const existingUserStudentId = await User.findOne({studentId});
        if(existingUserStudentId){
            return res
            .status(400)
            .json({"status": false, msg: "User With same StudentId already exists!"});l
        }

        const hasedPassword = await bcryptjs.hash(password, 8);

        let user = new User({
            _id: studentId,
            email,
            password: hasedPassword,
            name,
            userType,
            studentId,
            isVerified: false
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

///Get My Profile Data
authRouter.get("/api/getMyProfile", auth, async (req, res) => {
    try {
        const user = await User.findById(req.user);

        // Check if user is found
        if (!user) {
            return res.status(400).json({
                "status": false,
                msg: "User not found"
            });
        }

        res.json({
            "status": true,
            user
        });

    } catch (e) {
        res.status(500).json({
            "status": false,
            error: e.message
        });
    }
});

//Update Profile
authRouter.put("/api/updateProfile",auth, async (req, res) => {
    try {
    
        const { name, branch, completeAddress, dob, photoUrl, regNo, seatType, semester, session, token } = req.body;

        // Check if the user exists
        const user = await User.findById(req.user);
        if (!user) {
            return res.status(404).json({ "status": false, error: 'User not found' });
        }
        // Update user fields
        user.name = name || user.name;
        user.branch = branch || user.branch;
        user.completeAddress = completeAddress || user.completeAddress;
        user.dob = dob || user.dob;
        user.photoUrl = photoUrl || user.photoUrl;
        user.regNo = regNo || user.regNo;
        user.seatType = seatType || user.seatType;
        user.semester = semester || user.semester;
        user.session = session || user.session;
        user.token = token || user.token;

        // Save the updated user
        await user.save();

        res.json({ "status": true, msg: "User profile updated successfully", user });
    } catch (error) {
        res.status(500).json({ "status": false, msg: error.message });
    }
});


module.exports = authRouter;