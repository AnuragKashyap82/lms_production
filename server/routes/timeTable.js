const express = require('express');
const TimeTableModel = require('../models/timeTableModel');
const auth = require('../middlewares/auth');
const timeTableRouter = express.Router();

//Add TimeTable
timeTableRouter.post("/api/addTimeTable", auth, async function(req, res){
    try {
        const {semester, branch, dayName,  subName, subCode, facultyName, startTime, endTime, studentId } = req.body;

        const currentTimestamp = Date.now();

        let timeTableModel = new TimeTableModel({
           _id: studentId,
            branch,
            semester,
            dayName,
            subName,
            subCode,
            facultyName,
            startTime,
            endTime,
            timeTableId: currentTimestamp,            
        });
        timeTableModel = await timeTableModel.save();
        res.json({"status": true, timeTableModel});
    } catch (error) {
        res.status(500)
        .json({"status": false, msg: error.message,});
    }
 });

 ///Get All TimeTable
 timeTableRouter.get('/api/getAllTimeTable', auth, async (req, res)=> {
    try {
        const timeTable = await TimeTableModel.find();
        res.json({"status": true, timeTable});
    } catch (error) {
        res.status(500).json({"status": false,error: error.message});
    }
});

//Delete TimeTable
timeTableRouter.post("/api/deleteTimeTable", auth, async (req, res) => {
    try {
      const { timeTableId } = req.body;
  
      if (!timeTableId) {
        return res.status(400).json({ "status": false, error: 'TimeTableId is required' });
      }
  
      let timeTable = await TimeTableModel.findOneAndDelete({ timeTableId });
  
      if (!timeTable) {
        return res.status(404).json({ "status": false, error: 'TimeTable not found' });
      }
  
      res.json({"status": true, timeTable});
    } catch (e) {
      res.status(500).json({ "status": false, error: e.message });
      
    }
  });
 

 module.exports = timeTableRouter;