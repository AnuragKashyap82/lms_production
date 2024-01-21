const mongoose = require("mongoose");

const studentIdSchema = mongoose.Schema({
    studentId: {
        required: true,
        type: Number,
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
    userType: {
        required: true,
        type: String,
        trim: true,
        enum: ["user", "teacher", "admin"],
    },
});

const StudentIdModel = mongoose.model("StudentId", studentIdSchema);
module.exports = StudentIdModel;