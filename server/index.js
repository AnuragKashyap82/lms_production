const express  = require("express");
const mongoose  = require("mongoose");
const authRouter = require("./routes/auth");
const studentIdRouter = require("./routes/studentId");
const noticeRouter = require("./routes/notice");
const materialRouter = require("./routes/material");
const resultRouter = require("./routes/result");
const timeTableRouter = require("./routes/timeTable");
const classroomRouter = require("./routes/classroom");
const booksRouter = require("./routes/books");

const PORT = process.env.PORT || 3000;
const app = express();

app.use(express.json());
app.use(authRouter);
app.use(studentIdRouter);
app.use(noticeRouter);
app.use(materialRouter);
app.use(resultRouter);
app.use(timeTableRouter);
app.use(classroomRouter);
app.use(booksRouter);

const DB = "mongodb+srv://lmsramgarhengineering:Anurag6022@cluster0.oa029sm.mongodb.net/eduventuredb";

mongoose.connect(DB).then(() => {
    console.log("MongoDB Connection Successfull");
}).catch((err) => {
    console.log(err);
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at port ${PORT}`);

});