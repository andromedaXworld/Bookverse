-- Creating View: Average rating per author
CREATE VIEW AvgRatingPerAuthor AS
SELECT author, AVG(r.rating) AS avg_rating
FROM Books b
JOIN Ratings r ON b.isbn = r.isbn
GROUP BY author
ORDER BY avg_rating DESC;
GO  -- end of this batch


-- Creating View: Find users who rated books above 8
CREATE VIEW UsersRatedAbove8 AS
SELECT u.user_id, u.location, COUNT(r.rating) AS high_ratings
FROM Users u
JOIN Ratings r ON u.user_id = r.user_id
WHERE r.rating > 8
GROUP BY u.user_id, u.location
ORDER BY high_ratings DESC;
GO  --end of this batch

-- Creating Stored Procedure: Get Books by Author
CREATE PROCEDURE GetBooksByAuthor @AuthorName VARCHAR(100)
AS
BEGIN
    SELECT b.title, b.year_of_publication
    FROM Books b
    WHERE b.author = @AuthorName;
END;
GO  -- end of this batch

-- Creating Stored Procedure: Get Users by Rating
CREATE PROCEDURE GetUsersByRating @MinRating INT
AS
BEGIN
    SELECT u.user_id, u.location, COUNT(r.rating) AS total_ratings
    FROM Users u
    JOIN Ratings r ON u.user_id = r.user_id
    WHERE r.rating >= @MinRating
    GROUP BY u.user_id, u.location
    ORDER BY total_ratings DESC;
END;
GO  -- end of this batch

-- Creating Trigger: Log new ratings
CREATE TRIGGER LogNewRatings
ON Ratings
AFTER INSERT
AS
BEGIN
    DECLARE @UserId INT, @BookIsbn VARCHAR(20), @Rating INT;
    SELECT @UserId = user_id, @BookIsbn = isbn, @Rating = rating FROM INSERTED;

    INSERT INTO RatingAudit (user_id, isbn, rating, action_time)
    VALUES (@UserId, @BookIsbn, @Rating, GETDATE());
END;
GO  -- end of this batch

-- Creating Trigger: Prevent low ratings
CREATE TRIGGER PreventLowRatings
ON Ratings
AFTER INSERT
AS
BEGIN
    DECLARE @Rating INT;
    SELECT @Rating = rating FROM INSERTED;

    IF @Rating < 3
    BEGIN
        RAISERROR('Ratings below 3 are not allowed!', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO  -- end of this batch
