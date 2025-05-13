DROP TABLE IF EXISTS Ratings;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Books;


CREATE TABLE Books (
    isbn VARCHAR(20) PRIMARY KEY,
    title VARCHAR(300),
    author VARCHAR(100),
    year_of_publication INT,
    publisher VARCHAR(100)
);

CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    user_location VARCHAR(100),
    age INT
);

CREATE TABLE Ratings (
    user_id INT,
    isbn VARCHAR(20),
    rating INT, 
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (isbn) REFERENCES Books(isbn)
);

