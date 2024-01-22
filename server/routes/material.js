const express = require('express');
const MaterialModel = require('../models/materialModel');
const auth = require('../middlewares/auth');
const materialRouter = express.Router();

//Add Material
materialRouter.post("/api/addMaterial", auth, async function(req, res){
    try {
        const {branch, materialUrl, semester, subName, subTopic, studentId} = req.body;

        const currentTimestamp = Date.now();
        const today = new Date();

        const year = today.getFullYear();
        // Months are zero-based, so we add 1 to get the correct month
        const month = (today.getMonth() + 1).toString().padStart(2, '0');
        const day = today.getDate().toString().padStart(2, '0');
        const formattedDate = `${year}-${month}-${day}`;

        let materialModel = new MaterialModel({
            _id: studentId,
            branch,
            materialUrl,
            semester,
            subName,
            subTopic,
            materialId: currentTimestamp,
            dateTime: formattedDate,
            
        });
        materialModel = await materialModel.save();
        res.json({"status": true, materialModel});
    } catch (error) {
        res.status(500)
        .json({"status": false, msg: error.message,});
    }
 });

 ///Get All Material
 materialRouter.get('/api/getAllMaterial',auth, async (req, res)=> {
    try {
        const material = await MaterialModel.find();
        res.json({"status": true, material});
    } catch (error) {
        res.status(500).json({"status": false,error: error.message});
    }
});

//Delete Material
materialRouter.post("/api/deleteMaterial",auth, async (req, res) => {
    try {
      const { materialId } = req.body;
  
      if (!materialId) {
        return res.status(400).json({ "status": false, error: 'MaterialId is required' });
      }
  
      let material = await MaterialModel.findOneAndDelete({ materialId });
  
      if (!material) {
        return res.status(404).json({ "status": false, error: 'Material not found' });
      }
  
      res.json({"status": true, material});
    } catch (e) {
      res.status(500).json({ "status": false, error: e.message });
    }
  });
 

 module.exports = materialRouter;