const express = require('express');
const ResultModel = require('../models/resultModel');
const auth = require('../middlewares/auth');
const resultRouter = express.Router();

//Add Result
resultRouter.post("/api/addResult", auth, async function(req, res){
    try {
        const {branch, resultUrl, semester, resultYear, studentId} = req.body;

        const currentTimestamp = Date.now();
        const today = new Date();

        const year = today.getFullYear();
        // Months are zero-based, so we add 1 to get the correct month
        const month = (today.getMonth() + 1).toString().padStart(2, '0');
        const day = today.getDate().toString().padStart(2, '0');
        const formattedDate = `${year}-${month}-${day}`;

        let resultModel = new ResultModel({
          _id: studentId,
            branch,
            resultUrl,
            semester,
            resultYear,
            resultId: currentTimestamp,
            dateTime: formattedDate,
            
        });
        resultModel = await resultModel.save();
        res.json({"status": true, resultModel});
    } catch (error) {
        res.status(500)
        .json({"status": false, msg: error.message,});
    }
 });

 ///Get All Result
 resultRouter.get('/api/getAllResult', auth, async (req, res)=> {
    try {
        const result = await ResultModel.find();
        res.json({"status": true, result});
    } catch (error) {
        res.status(500).json({"status": false,error: error.message});
    }
});

//Delete Result
resultRouter.post("/api/deleteResult", auth, async (req, res) => {
    try {
      const { resultId } = req.body;
  
      if (!resultId) {
        return res.status(400).json({ "status": false, error: 'ResultId is required' });
      }
  
      let result = await ResultModel.findOneAndDelete({ resultId });
  
      if (!result) {
        return res.status(404).json({ "status": false, error: 'Result not found' });
      }
  
      res.json({"status": true, result});
    } catch (e) {
      res.status(500).json({ "status": false, error: e.message });
    }
  });
 

 module.exports = resultRouter;