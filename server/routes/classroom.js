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
                _id: userFound.studentId,
                name: userFound.name,
                email: userFound.email,
                studentId: userFound.studentId
        });
        // Save the updated user
        await classroomFound.save();

        res.json({
            "status": true,
            msg: "Joined successfully",
           _id: userFound.studentId,
                name: userFound.name,
                email: userFound.email,
                studentId: userFound.studentId
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

///Get All Students
classroomRouter.get("/api/getAllStudents", auth, async (req, res) => {
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

        const user = await User.findById(req.user);

        // Check if user is found
        if (!user) {
            return res.status(400).json({
                "status": false,
                msg: "User not found"
            });
        }

        const students = classroomFound.student;

        res.json({
            "status": true,
            students
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


        classroomFound.postMsg.push({
            "_id": currentTimestamp,
            classCode,
            classMsg,
            dateTime: formattedDate,
            msgId: currentTimestamp,
            attachment,
            isAttachment,
            studentId
        });
        // Save the updated user
        await classroomFound.save();

        res.json({
            "status": true,
            msg: "Msg Post successfully",
            "_id": currentTimestamp,
            classCode,
            classMsg,
            dateTime: formattedDate,
            msgId: currentTimestamp,
            attachment,
            isAttachment,
            studentId
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
        const assignmentfound = classroomFound.assignment.find(assignment => assignment._id == assignmentId);
        if (!assignmentfound) {
            return res.status(400).json({
                "status": false,
                msg: "No Assignment Found!"
            });
        }

        // Check if there's already a submission array
        if (!assignmentfound.submission || !Array.isArray(assignmentfound.submission)) {
            // If there's no submission array, handle this case accordingly
            assignmentfound.submission = [];
            const submission = {
                _id: req.user,
                assignmentId,
                assignmentName: assignmentfound.assignmentName,
                classCode,
                dueDate: assignmentfound.dueDate,
                fullMarks: assignmentfound.fullMarks,
                dateTime: assignmentfound.dateTime,
                submissionUrl,
                studentId: req.user,
            };
            await assignmentfound.submission.push(submission);

            // Update the assignment in the classroom
            const index = classroomFound.assignment.findIndex(assignment => assignment._id == assignmentId);
            classroomFound.assignment[index] = assignmentfound;

            // Save the updated classroom
            await classroomFound.save();

            return res.json({
                "status": true,
                submission
            });
        }

        // Check if there's already a submission with the same studentId
        const existingSubmission = assignmentfound.submission.find(sub => sub.studentId == req.user);
        if (existingSubmission) {
            return res.status(400).json({
                "status": false,
                msg: "Submission already exists for this student!"
            });
        }

        const submission = {
            _id: req.user,
            assignmentId,
            assignmentName: assignmentfound.assignmentName,
            classCode,
            dueDate: assignmentfound.dueDate,
            fullMarks: assignmentfound.fullMarks,
            dateTime: assignmentfound.dateTime,
            submissionUrl,
            studentId: req.user,
        };

        assignmentfound.submission.push(submission);

        // Update the assignment in the classroom
        const index = classroomFound.assignment.findIndex(assignment => assignment._id == assignmentId);
        classroomFound.assignment[index] = assignmentfound;

        // Save the updated classroom
        await classroomFound.save();

        return res.json({
            "status": true,
            submission
        });

    } catch (error) {
        console.error('Error:', error);
        return res.status(500).json({
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
        const { classCode, assignmentId, marksObtained, studentId } = req.body;

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
        const submissionIndex = assignmentFound.submission.findIndex(sub => sub.studentId == studentId);
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

//Create Todays Attendence
classroomRouter.post("/api/createTodayAttendence", auth, async function(req, res) {
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

        const today = new Date();

        const year = today.getFullYear();
        const monthIndex = today.getMonth();
        const day = today.getDate();

        // Array of month names
        const monthNames = [
            'January', 'February', 'March', 'April',
            'May', 'June', 'July', 'August',
            'September', 'October', 'November', 'December'
        ];

        // Get the month name using the month index
        const month = monthNames[monthIndex];

        // Formatted date in "DD-Month-YYYY" format
        const formattedDate = `${day}-${month}-${year}`;

        // Check if attendance for today already exists
        const existingAttendance = classroomFound.attendence.find(entry => entry._id === formattedDate);

        if (existingAttendance) {
            return res.status(400).json({
                "status": false,
                msg: "Attendance for today already exists"
            });
        }

        // If attendance for today doesn't exist, add a new entry
        classroomFound.attendence.push({
            _id: formattedDate,
            date: formattedDate,
            active: true
        });

        // Save the updated classroom
        await classroomFound.save();

        res.json({
            "status": true,
            msg: "Attendance created successfully",
            _id: formattedDate,
            date: formattedDate,
            active: true
        });

    } catch (error) {
        res.status(500).json({
            "status": false,
            msg: error.message
        });
    }
});

//Add All Students in claa to Tidays Addendence as Present
classroomRouter.post("/api/addAttendenceStudent", auth, async function(req, res) {
    try {
        const { classCode, date } = req.body;

        // Check if the classroom with the given classCode exists
        const classroomFound = await ClassroomModel.findOne({ classCode });
        if (!classroomFound) {
            return res.status(400).json({
                "status": false,
                msg: "Classroom does not exist!"
            });
        }

        const studentFound = await classroomFound.student;
        const attendenceFound = await classroomFound.attendence.find(attendence => attendence._id == date);

        attendenceFound.student = [];

        // Add each student to the attendance list with the additional field
        for (const student of studentFound) {

                 // Add the attendance field to each student
                 const studentWithAttendance = { ...student, attendance: "present", date: date };
       
                 // Add the updated student to the attendance list
                 attendenceFound.student.push(studentWithAttendance);
        }

        // Update the assignment in the classroom
        const index = classroomFound.attendence.findIndex(attendence => attendence._id == date);
        classroomFound.attendence[index] = attendenceFound;

        // Save the updated classroom
        await classroomFound.save();

        return res.json({
            "status": true,
            studentFound
        });

    } catch (error) {
        res.status(500).json({
            "status": false,
            msg: error.message
        });
    }
});

///GetAll Classroom Assignment
classroomRouter.get("/api/getAttendenceByDate", auth, async (req, res) => {
    try {
        const { classCode, date } = req.body;

        if (!classCode) {
            return res.status(400).json({ "status": false, error: 'classCode is required' });
        }

        const classroomFound = await ClassroomModel.findById(classCode);

        // Check if user is found
        if (!classroomFound) {
            return res.status(400).json({
                "status": false,
                msg: "Classroom not found"
            });
        }

        if (!date) {
            return res.status(400).json({ "status": false, error: 'Date is required' });
        }

       

        // Find the assignment with the given assignmentId in the classroom
        const attendenceIndex = classroomFound.attendence.findIndex(attendence => attendence._id == date);
        if (attendenceIndex === -1) {
            return res.status(400).json({
                "status": false,
                msg: "No Attendence Found!"
            });
        }

        const attendenceFound = classroomFound.attendence[attendenceIndex];

        const student = attendenceFound.student;

        res.json({
            "status": true,
            student
        });

    } catch (e) {
        res.status(500).json({
            "status": false,
            error: e.message
        });
    }
});

 //Update Attendence Present or Absent
classroomRouter.put("/api/updateAttendence", auth, async function(req, res) {
    try {
        const { classCode, date, studentId } = req.body;

        if(!classCode){
            return res.status(400).json({ "status": false, error: 'classCode is required' });
        }

        // Check if the classroom with the given classCode exists
        const classroomFound = await ClassroomModel.findOne({ classCode });
        if (!classroomFound) {
            return res.status(400).json({
                "status": false,
                msg: "Classroom does not exist!"
            });
        }

        if(!date){
            return res.status(400).json({ "status": false, error: 'date is required' });
        }
        if(!studentId){
            return res.status(400).json({ "status": false, error: 'studentId is required' });
        }

        // Find the assignment with the given assignmentId in the classroom
        const attendenceIndex = classroomFound.attendence.findIndex(attendence => attendence._id == date);
        if (attendenceIndex === -1) {
            return res.status(400).json({
                "status": false,
                msg: "No Attendence Found!"
            });
        }

        const attendenceFound = classroomFound.attendence[attendenceIndex];

        // Find the submission with the matching studentId (req.user)
        const studentIndex = attendenceFound.student.findIndex(student => student.studentId == studentId);
        if (studentIndex === -1) {
            return res.status(400).json({
                "status": false,
                msg: "No Student with this Studentid  Found!"
            });
        }
        
            if(attendenceFound.student[studentIndex].attendance === "absent"){
                  attendenceFound.student[studentIndex].attendance = "present";
                  classroomFound.attendence[attendenceIndex] = attendenceFound

                  await classroomFound.save();
            
                res.json({
                    "status": true,
                    attendenceFound
                });
             
            }else{
                attendenceFound.student[studentIndex].attendance = "absent";
           
                classroomFound.attendence[attendenceIndex] = attendenceFound

                await classroomFound.save();
            
                res.json({
                    "status": true,
                    attendenceFound
                });
            }
        
        
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            "status": false,
            msg: error.message
        });
    }
});

 module.exports = classroomRouter;