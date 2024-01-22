const mongoose = require("mongoose");
const { classroomSchema } = require('./classroom_model');

const userSchema = mongoose.Schema({
    _id: {
        type: String, 
        required: true
    },
    name: {
        required: true,
        type: String,
        trim: true,
    },
    email: {
        required: true,
        type: String,
        trim: true,
        validate: {
            validator: (value) => {
                const re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|.(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                return value.match(re);
            },
            message: "Please enter a valid email address",
        }
    },
    password: {
        required: true,
        type: String,
        trim: true,
    },
    studentId: {
        required: true,
        type: String,
        trim: true,
    },
    isVerified: {
        required: true,
        type: Boolean,
        trim: true,
    },
    userType: {
        required: true,
        type: String,
        trim: true,
    },
    branch: {
        type: String,
        trim: true,
    },
    semester: {
        
        type: String,
        trim: true,
    },
    completeAddress: {
        
        type: String,
        trim: true,
    },
    dob: {
       
        type: String,
        trim: true,
    },
    photoUrl: {
        
        type: String,
        trim: true,
    },
    regNo: {
        
        type: String,
        trim: true,
    },
    seatType: {
      
        type: String,
        trim: true,
    },
    session: {
      
        type: String,
        trim: true,
    },
    token: {
        
        type: String,
        trim: true,
    },
    classroom: [
        {
        _id: {
                type: String, 
                required: true
            },
          classroom: classroomSchema,
        },
      ],
});

const User = mongoose.model("User", userSchema);
module.exports = User;