const express = require('express');
const StudentIdModel = require('../models/student_id_model');
const auth = require('../middlewares/auth');
const studentIdRouter = express.Router();

//Add Student Id
studentIdRouter.post("/api/addStudentId", auth, async function(req, res){
    try {
        const {studentId, email, userType} = req.body;

        const existingStudentId = await StudentIdModel.findOne({studentId});
        if(existingStudentId){
            return res
            .status(400)
            .json({"status": false, msg: "StudentId already exists!"});
        }

        let studentIdModel = new StudentIdModel({
            studentId,
            email,
            userType,
        });
        studentIdModel = await studentIdModel.save();
        res.json({"status": true, studentIdModel});
    } catch (error) {
        res.status(500)
        .json({"status": false, msg: error.message});
    }
 });

 ///Verify StydentId
 studentIdRouter.get("/api/verifyStudentId/:studentId", async function(req, res) {
    try {
        const studentIdParam = req.params.studentId;

        const existingStudentId = await StudentIdModel.findOne({ studentId: studentIdParam });
        if (!existingStudentId) {
            return res
                .status(400)
                .json({ "status": false, msg: "StudentId not found" });
        }

        res.json({ "status": true, existingStudentId});
    } catch (error) {
        res.status(500)
            .json({"status": false, msg: error.message });
    }
});


module.exports = studentIdRouter;