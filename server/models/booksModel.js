const mongoose = require("mongoose");

const booksSchema = mongoose.Schema({
    _id: {
        type: String, 
        required: true
    },
    authorName: {
        required: true,
        type: String,
        trim: true,
    },
    bookNo: {
        required: true,
        type: String,
        trim: true,
    },
    bookName: {
        required: true,
        type: String,
        trim: true,
    },
    bookQty: {
        required: true,
        type: Number,
        trim: true,
    },
    subjectName: {
        required: true,
        type: String,
        trim: true,
    },
    bookId: {
        required: true,
        type: String,
        trim: true,
    },
});

const BooksModel = mongoose.model("Books", booksSchema);
module.exports = BooksModel;