const mongoose = require("mongoose");

const timeTableSchema = mongoose.Schema({
    _id: {
        type: String, 
        required: true
    },
    timeTableId: {
        required: true,
        type: String,
        trim: true,
    },
    branch: {
        required: true,
        type: String,
        trim: true,
    },
    dayName: {
        required: true,
        type: String,
        trim: true,
    },
    endTime: {
        required: true,
        type: String,
        trim: true,
    },
    startTime: {
        required: true,
        type: String,
        trim: true,
    },
    facultyName: {
        required: true,
        type: String,
        trim: true,
    },
    semester: {
        required: true,
        type: String,
        trim: true,
    },
    subCode: {
        required: true,
        type: String,
        trim: true,
    },
    subName: {
        required: true,
        type: String,
        trim: true,
    },
});

const TimeTableModel = mongoose.model("TimeTable", timeTableSchema);
module.exports = TimeTableModel;