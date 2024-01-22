const express = require('express');
const NoticeModel = require('../models/noticeModel');
const auth = require('../middlewares/auth');
const noticeRouter = express.Router();

//Add Notice Id
noticeRouter.post("/api/addNotice", auth, async function(req, res){
    try {
        const {noticeNo, noticeTitle, noticeUrl, studentId} = req.body;

        const currentTimestamp = Date.now();
        const today = new Date();

        const year = today.getFullYear();
        // Months are zero-based, so we add 1 to get the correct month
        const month = (today.getMonth() + 1).toString().padStart(2, '0');
        const day = today.getDate().toString().padStart(2, '0');
        const formattedDate = `${year}-${month}-${day}`;

        let noticeModel = new NoticeModel({
            _id: studentId,
            noticeNo,
            noticeTitle,
            noticeUrl,
            noticeId: currentTimestamp,
            dateTime: formattedDate,
            
        });
        noticeModel = await noticeModel.save();
        res.json({"status": true, noticeModel});
    } catch (error) {
        res.status(500)
        .json({"status": false, msg: error.message});
    }
 });

 ///Get All Notice
 noticeRouter.get('/api/getAllNotice', auth, async (req, res)=> {
    try {
        const notice = await NoticeModel.find();
        res.json({"status": true, notice});
    } catch (error) {
        res.status(500).json({"status": false,error: error.message});
    }
});

//Delete Notice
noticeRouter.post("/api/deleteNotice", auth, async (req, res) => {
    try {
      const { noticeId } = req.body;
  
      if (!noticeId) {
        return res.status(400).json({ "status": false, error: 'NoticeId is required' });
      }
  
      let notice = await NoticeModel.findOneAndDelete({ noticeId });
  
      if (!notice) {
        return res.status(404).json({ "status": false, error: 'Notice not found' });
      }
  
      res.json({"status": true, notice});
    } catch (e) {
      res.status(500).json({ "status": false, error: e.message });
    }
  });
 

 module.exports = noticeRouter;