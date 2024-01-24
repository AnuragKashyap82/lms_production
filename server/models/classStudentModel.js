const mongoose = require("mongoose");

const classStudentSchema = mongoose.Schema({
    _id: {
        type: String, 
        required: true
    },
    name: {
        required: true,
        type: String,
        trim: true,
    },
    attendence: {
        type: String,
        trim: true,
    },
    email: {
        required: true,
        type: String,
        trim: true,
    },
    studentId: {
        required: true,
        type: String,
        trim: true,
    },
});

const ClassStudentModel = mongoose.model("Student", classStudentSchema);
module.exports = ClassStudentModel;