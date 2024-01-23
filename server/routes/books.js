const express = require('express');
const auth = require('../middlewares/auth');
const User = require('../models/user');
const BooksModel = require('../models/booksModel');
const IssueBookModel = require('../models/issueBookModel');
const booksRouter = express.Router();

//Add Books In Library
booksRouter.post("/api/addBooks", auth, async function(req, res) {
    try {
        const { subjectName, bookName, authorName, bookNo, bookQty } = req.body;

        // Check if a book with the same bookNo already exists
        const existingBook = await BooksModel.findOne({ bookNo: bookNo });
        if (existingBook) {
            return res.status(400).json({ "status": false, msg: "Book with the same bookNo already exists." });
        }

        const bookId = Date.now();

        let booksModel = new BooksModel({
            _id: bookId,
            subjectName,
            bookName,
            authorName,
            bookQty,
            bookId,
            bookNo
        });

        booksModel = await booksModel.save();
        res.json({ "status": true, booksModel });
    } catch (error) {
        res.status(500).json({ "status": false, msg: error.message });
    }
});


 ///Get All Books
 booksRouter.get('/api/getAllBooks', auth, async (req, res)=> {
    try {
        const books = await BooksModel.find();
        res.json({"status": true, books});
    } catch (error) {
        res.status(500).json({"status": false,error: error.message});
    }
});

//Delete Book
booksRouter.post("/api/deleteBook", auth, async (req, res) => {
    try {
      const { bookId } = req.body;
  
      if (!bookId) {
        return res.status(400).json({ "status": false, error: 'BookId is required' });
      }
  
      let book = await BooksModel.findOneAndDelete({ bookId });
  
      if (!book) {
        return res.status(404).json({ "status": false, error: 'Book not found' });
      }
  
      res.json({"status": true, book});
    } catch (e) {
      res.status(500).json({ "status": false, error: e.message });
    }
  });

  //Increment BookQty
  booksRouter.put("/api/incrementBookQty", auth, async function(req, res) {
    try {
        const { bookId } = req.body;
        if (!bookId) {
            return res.status(400).json({ "status": false, error: 'BookId is required' });
          }

        // Check if the book exists
        const existingBook = await BooksModel.findById(bookId);
        if (!existingBook) {
            return res.status(404).json({ "status": false, msg: "Book not found." });
        }

        // Increment the book quantity by 1
        existingBook.bookQty += 1;
        const updatedBook = await existingBook.save();

        res.json({ "status": true, updatedBook });
    } catch (error) {
        res.status(500).json({ "status": false, msg: error.message });
    }
});

//Decrement BookQty
booksRouter.put("/api/decrementBookQty", auth, async function(req, res) {
    try {
        const { bookId } = req.body;
        if (!bookId) {
            return res.status(400).json({ "status": false, error: 'BookId is required' });
          }

        // Check if the book exists
        const existingBook = await BooksModel.findById(bookId);
        if (!existingBook) {
            return res.status(404).json({ "status": false, msg: "Book not found." });
        }

        // Increment the book quantity by 1
        existingBook.bookQty = 1;
        const updatedBook = await existingBook.save();

        res.json({ "status": true, updatedBook });
    } catch (error) {
        res.status(500).json({ "status": false, msg: error.message });
    }
});

//Issue Books
booksRouter.post("/api/issueBook", auth, async function(req, res) {
    try {
        const { bookId } = req.body;

        // Get the user by ID
        const userFound = await User.findById(req.user);
        if (!userFound) {
            return res.status(400).json({
                "status": false,
                msg: "User not found"
            });
        }
        const bookFound = await BooksModel.findById(bookId);
        if (!bookFound) {
            return res.status(400).json({
                "status": false,
                msg: "Book not found"
            });
        }

        // Check if the book is already issued to the user
        const existingIssue = await IssueBookModel.findOne({
            studentId: userFound.studentId,
            bookId: bookId,
        });

        if (existingIssue) {
            return res.status(400).json({
                "status": false,
                msg: "Book already issued to the user"
            });
        }
        
        const issueId = Date.now();
        const today = new Date();

        const year = today.getFullYear();
        // Months are zero-based, so we add 1 to get the correct month
        month = (today.getMonth() + 1).toString().padStart(2, '0');
        const day = today.getDate().toString().padStart(2, '0');
        const hours = today.getHours().toString().padStart(2, '0');
        const minutes = today.getMinutes().toString().padStart(2, '0');

        const appliedDate = `${year}-${month}-${day} ${hours}:${minutes}`;

        let issueBookModel = new IssueBookModel({
            _id: issueId,
            name: userFound.name,
            photoUrl: userFound.photoUrl,
            email: userFound.email,
            studentId: userFound.studentId,
            subjectName: bookFound.subjectName,
            bookName: bookFound.bookName,
            authorName: bookFound.authorName,
            bookId,
            bookNo: bookFound.bookNo,
            status: "applied",
            issueId,
            appliedDate: appliedDate
        });

        issueBookModel = await issueBookModel.save();
        res.json({ "status": true, issueBookModel });
    } catch (error) {
        res.status(500).json({ "status": false, msg: error.message });
    }
});

 ///Get All IssuedBooks
 booksRouter.get('/api/getAllIssuedBooks', auth, async (req, res)=> {
    try {
        const issueBooks = await IssueBookModel.find();
        res.json({"status": true, issueBooks});
    } catch (error) {
        res.status(500).json({"status": false,error: error.message});
    }
});

//Update status to Issued
booksRouter.put("/api/updateToIssued", auth, async function(req, res) {
    try {
        const { issueId } = req.body;
        if (!issueId) {
            return res.status(400).json({ "status": false, error: 'IssueId is required' });
          }

        // Check if the book exists
        const existingIssue = await IssueBookModel.findById(issueId);
        if (!existingIssue) {
            return res.status(404).json({ "status": false, msg: "Issue not found." });
        }

        const today = new Date();

        const year = today.getFullYear();
        // Months are zero-based, so we add 1 to get the correct month
        month = (today.getMonth() + 1).toString().padStart(2, '0');
        const day = today.getDate().toString().padStart(2, '0');
        const hours = today.getHours().toString().padStart(2, '0');
        const minutes = today.getMinutes().toString().padStart(2, '0');

        const issuedDate = `${year}-${month}-${day} ${hours}:${minutes}`;
        
        existingIssue.status = "issued";
        existingIssue.issueDate = issuedDate;
        const updatedIssue = await existingIssue.save();

        res.json({ "status": true, updatedIssue });
    } catch (error) {
        res.status(500).json({ "status": false, msg: error.message });
    }
});

//Update status to Returned
booksRouter.put("/api/updateToReturned", auth, async function(req, res) {
    try {
        const { issueId } = req.body;
        if (!issueId) {
            return res.status(400).json({ "status": false, error: 'IssueId is required' });
          }

        // Check if the book exists
        const existingIssue = await IssueBookModel.findById(issueId);
        if (!existingIssue) {
            return res.status(404).json({ "status": false, msg: "Issue not found." });
        }

        const today = new Date();

        const year = today.getFullYear();
        // Months are zero-based, so we add 1 to get the correct month
        month = (today.getMonth() + 1).toString().padStart(2, '0');
        const day = today.getDate().toString().padStart(2, '0');
        const hours = today.getHours().toString().padStart(2, '0');
        const minutes = today.getMinutes().toString().padStart(2, '0');

        const returnedDate = `${year}-${month}-${day} ${hours}:${minutes}`;
        
        existingIssue.status = "returned";
        existingIssue.returnedDate = returnedDate;
        const updatedReturned = await existingIssue.save();

        res.json({ "status": true, updatedReturned });
    } catch (error) {
        res.status(500).json({ "status": false, msg: error.message });
    }
});

 

 module.exports = booksRouter;