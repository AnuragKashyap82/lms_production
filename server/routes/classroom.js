const express = require('express');
const auth = require('../middlewares/auth');
const {ClassroomModel} = require('../models/classroom_model');
const User = require('../models/user');
const PostMsgModel = require('../models/classPostMsgModel');
const AssignmentModel = require('../models/assignmentModel');
const SubmissionModel = require('../models/submissionModel');
const classroomRouter = express.Router();

//Create Classroom
classroomRouter.post("/api/createClass", auth, async function(req, res){
    try {
        const {subjectName, className, name, studentId} = req.body;

        const currentTimestamp = Date.now();
        const today = new Date();

        const year = today.getFullYear();
        // Months are zero-based, so we add 1 to get the correct month
        const month = (today.getMonth() + 1).toString().padStart(2, '0');
        const day = today.getDate().toString().padStart(2, '0');
        const formattedDate = `${year}-${month}-${day}`;

        let classroomModel = new ClassroomModel({
            _id: currentTimestamp,
            subjectName,
            className,
            name,
            classCode: currentTimestamp,
            studentId,
            
        });
        classroomModel = await classroomModel.save();
        res.json({"status": true, classroomModel});
    } catch (error) {
        res.status(500)
        .json({"status": false, msg: error.message});
    }
 });

 // Join classroom
classroomRouter.post("/api/joinClass", auth, async function(req, res) {
    try {
        const { classCode } = req.body;

        // Check if the classroom with the given classCode exists
        const classroomFound = await ClassroomModel.findOne({ classCode });
        if (!classroomFound) {
            return res.status(400).json({
                "status": false,
                msg: "Classroom does not exist!"
            });
        }

        // Get the user by ID
        const user = await User.findById(req.user);

        // Check if the user is found
        if (!user) {
            return res.status(400).json({
                "status": false,
                msg: "User not found"
            });
        }

        // Check if the user has already joined the classroom
       if(user.classroom.length == 0){
        user.classroom.push({
            "_id": classCode,
            "classroom": classroomFound
        });
        // Save the updated user
        await user.save();

        res.json({
            "status": true,
            msg: "Joined successfully",
            classroomFound
        });
       }else{
        let isClassroomFound = false;
      for (let i = 0; i < user.classroom.length; i++) {
        if (user.classroom[i]._id == classCode) {
            isClassroomFound = true;
        }
      }

      if (isClassroomFound) {
        res.json({
            "status": false,
            msg: "Already Joined",
        });
      } else {
        user.classroom.push({
            "_id": classCode,
            "classroom": classroomFound
        });
        // Save the updated user
        await user.save();

        res.json({
            "status": true,
            msg: "Joined successfully",
            classroomFound
        });
      }
       }
        
    } catch (error) {
        res.status(500).json({
            "status": false,
            msg: error.message
        });
    }
});

//Add to classroom Student when join
classroomRouter.post("/api/joinClassStudent", auth, async function(req, res) {
    try {
        const { classCode } = req.body;

        // Check if the classroom with the given classCode exists
        const classroomFound = await ClassroomModel.findOne({ classCode });
        if (!classroomFound) {
            return res.status(400).json({
                "status": false,
                msg: "Classroom does not exist!"
            });
        }

        // Get the user by ID
        const userFound = await User.findById(req.user);

        // Check if the user is found
        if (!userFound) {
            return res.status(400).json({
                "status": false,
                msg: "User not found"
            });
        }

    
        classroomFound.student.push({
            "_id": userFound.studentId,
            "student": {
                _id: userFound.studentId,
                "name": userFound.name,
                "email": userFound.email,
                "studentId": userFound.studentId
            }
        });
        // Save the updated user
        await classroomFound.save();

        res.json({
            "status": true,
            msg: "Joined successfully",
            "userFound": {
                _id: userFound.studentId,
                "name": userFound.name,
                "email": userFound.email,
                "studentId": userFound.studentId
            }
        });
        
        
    } catch (error) {
        res.status(500).json({
            "status": false,
            msg: error.message
        });
    }
});



 ///Get My Classroom
 classroomRouter.get("/api/getMyClassroom", auth, async (req, res) => {
    try {
        const user = await User.findById(req.user);

        // Check if user is found
        if (!user) {
            return res.status(400).json({
                "status": false,
                msg: "User not found"
            });
        }

        const classrooms = user.classroom;

        res.json({
            "status": true,
            classrooms
        });

    } catch (e) {
        res.status(500).json({
            "status": false,
            error: e.message
        });
    }
});


//Unenrol Classroom
classroomRouter.post("/api/unenrollClass", auth, async (req, res) => {
    try {
        const { classCode } = req.body;

        if (!classCode) {
            return res.status(400).json({ "status": false, error: 'ClassCode is required' });
        }

        const user = await User.findById(req.user);

        if (!user) {
            return res.status(404).json({ "status": false, error: 'User not found' });
        }

        // Find the index of the classroom with the specified classCode
        const index = user.classroom.findIndex((classroom) => classroom._id == classCode);

        if (index === -1) {
            return res.status(404).json({ "status": false, error: 'Classroom not found' });
        }

        // Remove the classroom from the user's array
        const removedClassroom = user.classroom.splice(index, 1);

        // Save the updated user
        await user.save();

        res.json({ "status": true, removedClassroom });
    } catch (e) {
        res.status(500).json({ "status": false, error: e.message });
    }
});

//Classroom Post Msg
classroomRouter.post("/api/classPostMsg", auth, async function(req, res) {
    try {
        const { classCode, attachment, classMsg, studentId, isAttachment } = req.body;

        // Check if the classroom with the given classCode exists
        const classroomFound = await ClassroomModel.findOne({ classCode });
        if (!classroomFound) {
            return res.status(400).json({
                "status": false,
                msg: "Classroom does not exist!"
            });
        }

        // Get the user by ID
        const userFound = await User.findById(req.user);

        // Check if the user is found
        if (!userFound) {
            return res.status(400).json({
                "status": false,
                msg: "User not found"
            });
        }

        const currentTimestamp = Date.now();
        const today = new Date();

        const year = today.getFullYear();
        // Months are zero-based, so we add 1 to get the correct month
        const month = (today.getMonth() + 1).toString().padStart(2, '0');
        const day = today.getDate().toString().padStart(2, '0');
        const formattedDate = `${year}-${month}-${day}`;
    
        let postMsg = new PostMsgModel({
            _id: currentTimestamp,
            classCode,
            classMsg,
            dateTime: formattedDate,
            msgId: currentTimestamp,
            attachment,
            isAttachment,
            studentId
            
        });

        classroomFound.postMsg.push({
            "_id": currentTimestamp,
            postMsg
        });
        // Save the updated user
        await classroomFound.save();

        res.json({
            "status": true,
            msg: "Msg Post successfully",
            postMsg
        });
        
        
    } catch (error) {
        res.status(500).json({
            "status": false,
            msg: error.message
        });
    }
});


///GetAll Classroom Message
classroomRouter.get("/api/getClassroomAllMessage", auth, async (req, res) => {
    try {
        const { classCode } = req.body;
        const classroom = await ClassroomModel.findById(classCode);

        // Check if user is found
        if (!classroom) {
            return res.status(400).json({
                "status": false,
                msg: "Classroom not found"
            });
        }

        const classMsg = classroom.postMsg;

        res.json({
            "status": true,
            classMsg
        });

    } catch (e) {
        res.status(500).json({
            "status": false,
            error: e.message
        });
    }
});


//Add classroom Assignment
classroomRouter.post("/api/addAssignment", auth, async function(req, res) {
    try {
        const { classCode, assignmentName, dueDate ,fullMarks, assignmentUrl } = req.body;

        // Check if the classroom with the given classCode exists
        const classroomFound = await ClassroomModel.findOne({ classCode });
        if (!classroomFound) {
            return res.status(400).json({
                "status": false,
                msg: "Classroom does not exist!"
            });
        }
    
        const currentTimestamp = Date.now();
        const today = new Date();

        const year = today.getFullYear();
        // Months are zero-based, so we add 1 to get the correct month
        const month = (today.getMonth() + 1).toString().padStart(2, '0');
        const day = today.getDate().toString().padStart(2, '0');
        const formattedDate = `${year}-${month}-${day}`;

        classroomFound.assignment.push({
            _id: currentTimestamp,
            assignmentId: currentTimestamp,
            assignmentName,
            classCode,
            dueDate,
            fullMarks,
            dateTime: formattedDate,
            assignmentUrl,
            studentId: req.user,
        });
        // Save the updated assignment
        await classroomFound.save();
        res.json({"status": true, "_id": currentTimestamp,
        assignmentId: currentTimestamp,
        assignmentName,
        classCode,
        dueDate,
        fullMarks,
        dateTime: formattedDate,
        assignmentUrl,
        studentId: req.user,});
        
        
    } catch (error) {
        res.status(500).json({
            "status": false,
            msg: error.message
        });
    }
});

///GetAll Classroom Assignment
classroomRouter.get("/api/getAllAssignment", auth, async (req, res) => {
    try {
        const { classCode } = req.body;
        const classroom = await ClassroomModel.findById(classCode);

        // Check if user is found
        if (!classroom) {
            return res.status(400).json({
                "status": false,
                msg: "Classroom not found"
            });
        }

        const assignment = classroom.assignment;

        res.json({
            "status": true,
            assignment
        });

    } catch (e) {
        res.status(500).json({
            "status": false,
            error: e.message
        });
    }
});

//Add classroom Assignment Submission
classroomRouter.post("/api/addAssignmentSubmission", auth, async function(req, res) {
    try {
        const { classCode, assignmentId, submissionUrl } = req.body;

        // Check if the classroom with the given classCode exists
        const classroomFound = await ClassroomModel.findOne({ classCode });
        if (!classroomFound) {
            return res.status(400).json({
                "status": false,
                msg: "Classroom does not exist!"
            });
        }

        // Find the assignment with the given assignmentId in the classroom
        const assignmentIndex = classroomFound.assignment.findIndex(assignment => assignment._id == assignmentId);
        if (assignmentIndex === -1) {
            return res.status(400).json({
                "status": false,
                msg: "No Assignment Found!"
            });
        }

        const assignmentFound = classroomFound.assignment[assignmentIndex];

        // Check if there's already a submission with the same studentId
        const existingSubmissionIndex = assignmentFound.submission.findIndex(sub => sub.studentId == req.user);
        if (existingSubmissionIndex !== -1) {
            return res.status(400).json({
                "status": false,
                msg: "Submission already exists for this student!"
            });
        }

        const submission = {
            _id: req.user,
            assignmentId,
            assignmentName: assignmentFound.assignmentName,
            classCode,
            dueDate: assignmentFound.dueDate,
            fullMarks: assignmentFound.fullMarks,
            dateTime: assignmentFound.dateTime,
            submissionUrl,
            studentId: req.user,
        };

        // Add the submission to the assignment's submission property
        if (!assignmentFound.submission || !Array.isArray(assignmentFound.submission)) {
            assignmentFound.submission = [];
        }

        assignmentFound.submission.push(submission);

        // Update the assignment in the classroom
        classroomFound.assignment[assignmentIndex] = assignmentFound;

        // Save the updated classroom
        await classroomFound.save();

        res.json({
            "status": true,
            submission
        });

    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            "status": false,
            msg: error.message
        });
    }
});

//Update Submitted Assignment Url
classroomRouter.put("/api/updateSubmissionUrl", auth, async function(req, res) {
    try {
        const { classCode, assignmentId, submissionUrl } = req.body;

        // Check if the classroom with the given classCode exists
        const classroomFound = await ClassroomModel.findOne({ classCode });
        if (!classroomFound) {
            return res.status(400).json({
                "status": false,
                msg: "Classroom does not exist!"
            });
        }

        // Find the assignment with the given assignmentId in the classroom
        const assignmentIndex = classroomFound.assignment.findIndex(assignment => assignment._id == assignmentId);
        if (assignmentIndex === -1) {
            return res.status(400).json({
                "status": false,
                msg: "No Assignment Found!"
            });
        }

        const assignmentFound = classroomFound.assignment[assignmentIndex];

        // Find the submission with the matching studentId (req.user)
        const submissionIndex = assignmentFound.submission.findIndex(sub => sub.studentId == req.user);
        if (submissionIndex === -1) {
            return res.status(400).json({
                "status": false,
                msg: "No Submission Found for this student!"
            });
        }

        // Update the submission URL
        assignmentFound.submission[submissionIndex].submissionUrl = submissionUrl;

        // Update the assignment in the classroom
        classroomFound.assignment[assignmentIndex] = assignmentFound;

        // Save the updated classroom
        await classroomFound.save();

        res.json({
            "status": true,
            msg: "Submission URL updated successfully",
            updatedSubmission: {
                _id: req.user,
                assignmentId,
                submissionUrl: submissionUrl
            }
        });

    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            "status": false,
            msg: error.message
        });
    }
});

///GetAll Classroom Assignment
classroomRouter.get("/api/getAllAssSubmittedName", auth, async (req, res) => {
    try {
        const { classCode, assignmentId } = req.body;
        const classroomFound = await ClassroomModel.findById(classCode);

        // Check if user is found
        if (!classroomFound) {
            return res.status(400).json({
                "status": false,
                msg: "Classroom not found"
            });
        }

        // Find the assignment with the given assignmentId in the classroom
        const assignmentIndex = classroomFound.assignment.findIndex(assignment => assignment._id == assignmentId);
        if (assignmentIndex === -1) {
            return res.status(400).json({
                "status": false,
                msg: "No Assignment Found!"
            });
        }

        const assignmentFound = classroomFound.assignment[assignmentIndex];

        const submission = assignmentFound.submission;

        res.json({
            "status": true,
            submission
        });

    } catch (e) {
        res.status(500).json({
            "status": false,
            error: e.message
        });
    }
});

//Update Submitted Assignment ObtainedMarks
classroomRouter.put("/api/updateObtainedMarks", auth, async function(req, res) {
    try {
        const { classCode, assignmentId, marksObtained } = req.body;

        // Check if the classroom with the given classCode exists
        const classroomFound = await ClassroomModel.findOne({ classCode });
        if (!classroomFound) {
            return res.status(400).json({
                "status": false,
                msg: "Classroom does not exist!"
            });
        }

        // Find the assignment with the given assignmentId in the classroom
        const assignmentIndex = classroomFound.assignment.findIndex(assignment => assignment._id == assignmentId);
        if (assignmentIndex === -1) {
            return res.status(400).json({
                "status": false,
                msg: "No Assignment Found!"
            });
        }

        const assignmentFound = classroomFound.assignment[assignmentIndex];

        // Find the submission with the matching studentId (req.user)
        const submissionIndex = assignmentFound.submission.findIndex(sub => sub.studentId == req.user);
        if (submissionIndex === -1) {
            return res.status(400).json({
                "status": false,
                msg: "No Submission Found for this student!"
            });
        }

        // Update the submission URL
        assignmentFound.submission[submissionIndex].marksObtained = marksObtained;

        // Update the assignment in the classroom
        classroomFound.assignment[assignmentIndex] = assignmentFound;

        // Save the updated classroom
        await classroomFound.save();

        res.json({
            "status": true,
            msg: "Submission URL updated successfully",
            updatedSubmission: {
                _id: req.user,
                assignmentId,
                marksObtained: marksObtained
            }
        });

    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            "status": false,
            msg: error.message
        });
    }
});
 

 module.exports = classroomRouter;