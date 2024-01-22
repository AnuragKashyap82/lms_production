const mongoose = require("mongoose");

const resultSchema = mongoose.Schema({
    _id: {
        type: String, 
        required: true
    },
    resultId: {
        required: true,
        type: String,
        trim: true,
    },
    branch: {
        required: true,
        type: String,
        trim: true,
    },
    dateTime: {
        required: true,
        type: String,
        trim: true,
    },
    resultUrl: {
        required: true,
        type: String,
        trim: true,
    },
    resultYear: {
        required: true,
        type: String,
        trim: true,
    },
});

const ResultModel = mongoose.model("Results", resultSchema);
module.exports = ResultModel;