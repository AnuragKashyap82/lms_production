const mongoose = require("mongoose");

const materialSchema = mongoose.Schema({
    materialId: {
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
    materialUrl: {
        required: true,
        type: String,
        trim: true,
    },
    semester: {
        required: true,
        type: String,
        trim: true,
    },
    subName: {
        required: true,
        type: String,
        trim: true,
    },
    subTopic: {
        required: true,
        type: String,
        trim: true,
    },
});

const MaterialModel = mongoose.model("Materials", materialSchema);
module.exports = MaterialModel;