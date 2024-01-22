const mongoose = require("mongoose");


const postMsgSchema = mongoose.Schema({
    _id: {
        type: String, 
        required: true
    },
    classCode: {
        required: true,
        type: String,
        trim: true,
    },
    classMsg: {
        required: true,
        type: String,
        trim: true,
    },
    dateTime: {
        required: true,
        type: String,
        trim: true,
    },
    msgId: {
        required: true,
        type: String,
        trim: true,
    },
    attachment: {
        type: String,
        trim: true,
    },
    isAttachment: {
        required: true,
        type: Boolean,
        trim: true,
    },
    studentId: {
        required: true,
        type: String,
        trim: true,
    },
});

const PostMsgModel = mongoose.model("PostMsg", postMsgSchema);
module.exports = PostMsgModel;