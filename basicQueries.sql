-- 1. Top 10 Most Rated Books
SELECT TOP 10 b.title, COUNT(r.rating) AS total_ratings
FROM Books b
JOIN Ratings r ON b.isbn = r.isbn
GROUP BY b.title
ORDER BY total_ratings DESC;


-- 2. Average Rating per Author
SELECT TOP 5 b.author, AVG(r.rating) AS avg_rating
FROM Books b
JOIN Ratings r ON b.isbn = r.isbn
GROUP BY b.author
ORDER BY avg_rating DESC;

-- 3. Top 5 Books by Average Rating
SELECT TOP 5 b.title, AVG(r.rating) AS avg_rating
FROM Books b
JOIN Ratings r ON b.isbn = r.isbn
GROUP BY b.title
ORDER BY avg_rating DESC;

-- 4. Users Who Rated Books Above 8
SELECT u.user_id, u.user_location, COUNT(*) AS high_ratings
FROM Users u
JOIN Ratings r ON u.user_id = r.user_id
WHERE r.rating > 8
GROUP BY u.user_id, u.user_location
ORDER BY high_ratings DESC;

