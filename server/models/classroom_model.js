const mongoose = require("mongoose");
const userSchema = require('./user');

const classroomSchema = mongoose.Schema({
    _id: {
        type: String, 
        required: true
    },
    classCode: {
        required: true,
        type: String,
        trim: true,
    },
    className: {
        required: true,
        type: String,
        trim: true,
    },
    name: {
        required: true,
        type: String,
        trim: true,
    },
    subjectName: {
        required: true,
        type: String,
        trim: true,
    },
    studentId: {
        required: true,
        type: String,
        trim: true,
    },
    student: [
        {
        _id: {
                type: String, 
                required: true
            },
          student: userSchema,
        },
      ],
});

const ClassroomModel = mongoose.model("Classroom", classroomSchema);
module.exports = {ClassroomModel, classroomSchema};