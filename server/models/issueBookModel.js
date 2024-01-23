const mongoose = require("mongoose");

const issueBookSchema = mongoose.Schema({
    _id: {
        type: String, 
        required: true
    },
    appliedDate: {
        type: String,
        trim: true,
    },
    email: {
        required: true,
        type: String,
        trim: true,
    },
    issueDate: {
        type: String,
        trim: true,
    },
    issueId: {
        type: String,
        trim: true,
    },
    name: {
        type: String,
        trim: true,
    },
    photoUrl: {
        type: String,
        trim: true,
    },
    returnedDate: {
        type: String,
        trim: true,
    },
    status: {
        type: String,
        trim: true,
    },
    studentId: {
        type: String,
        trim: true,
    },
    authorName: {
        required: true,
        type: String,
        trim: true,
    },
    bookNo: {
        required: true,
        type: String,
        trim: true,
    },
    bookName: {
        required: true,
        type: String,
        trim: true,
    },
    subjectName: {
        required: true,
        type: String,
        trim: true,
    },
    bookId: {
        required: true,
        type: String,
        trim: true,
    },
});

const IssueBookModel = mongoose.model("IssueBooks", issueBookSchema);
module.exports = IssueBookModel;