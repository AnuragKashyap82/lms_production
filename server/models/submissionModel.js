const mongoose = require("mongoose");

const submissionSchema = mongoose.Schema({
    _id: {
        type: String, 
        required: true
    },
    assignmentId: {
        required: true,
        type: String,
        trim: true,
    },
    assignmentName: {
        required: true,
        type: String,
        trim: true,
    },
    classCode: {
        required: true,
        type: String,
        trim: true,
    },
    dateTime: {
        required: true,
        type: String,
        trim: true,
    },
    dueDate: {
        required: true,
        type: String,
        trim: true,
    },
    fullMarks: {
        required: true,
        type: String,
        trim: true,
    },
    submissionUrl: {
        required: true,
        type: String,
        trim: true,
    },
    marksObtained: {
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

const SubmissionModel = mongoose.model("Submission", submissionSchema);
module.exports = SubmissionModel;