const mongoose = require("mongoose");

const noticeSchema = mongoose.Schema({
    _id: {
        type: String, 
        required: true
    },
    noticeId: {
        required: true,
        type: String,
        trim: true,
    },
    dateTime: {
        required: true,
        type: String,
        trim: true,
    },
    noticeNo: {
        required: true,
        type: String,
        trim: true,
    },
    noticeTitle: {
        required: true,
        type: String,
        trim: true,
    },
    noticeUrl: {
        required: true,
        type: String,
        trim: true,
    },
});

const NoticeModel = mongoose.model("Notice", noticeSchema);
module.exports = NoticeModel;