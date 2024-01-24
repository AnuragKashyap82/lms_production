const mongoose = require("mongoose");
const userSchema = require('./user');
const postMsgSchema = require('./classPostMsgModel');
const assignmentSchema = require('./assignmentModel');
const attendenceSchema = require('./attendenceModel');

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
      student: {
        type: [mongoose.Schema.Types.Mixed],
        default: [
            {
                _id: {
                        type: String, 
                        required: true
                    },
                    student: userSchema,
                },
        ],
    },  
      postMsg: {
        type: [mongoose.Schema.Types.Mixed],
        default: [
            {
                _id: {
                        type: String, 
                        required: true
                    },
                  student: postMsgSchema,
                },
        ],
    },
    assignment: {
        type: [mongoose.Schema.Types.Mixed],
        default: [
            {
                _id: {
                        type: String, 
                        required: true
                    },
                    assignment: assignmentSchema,
                },
        ],
    },
    attendence: {
        type: [mongoose.Schema.Types.Mixed],
        default: [
            {
                _id: {
                        type: String, 
                        required: true
                    },
                    attendence: attendenceSchema,
                },
        ],
    },
});

const ClassroomModel = mongoose.model("Classroom", classroomSchema);
module.exports = {ClassroomModel, classroomSchema};