const mongoose = require("mongoose");
const {classStudentSchema} = require("./classStudentModel");

const attendenceSchema = mongoose.Schema({
    _id: {
        type: String, 
        required: true
    },
    active: {
        required: true,
        type: Boolean,
        trim: true,
    },
    date: {
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
                    student: classStudentSchema,
                },
        ],
    },  
});

const AttendenceModel = mongoose.model("Attendence", attendenceSchema);
module.exports = AttendenceModel;