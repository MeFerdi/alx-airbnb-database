-- Subqueries Practice
-- This file contains both correlated and non-correlated subqueries

-- 1. Non-correlated subquery: Find all properties where the average rating is greater than 4.0
SELECT 
    p.property_id,
    p.name,
    p.location,
    p.pricepernight,
    ROUND(AVG(r.rating), 2) AS average_rating
FROM Property p
INNER JOIN Review r ON p.property_id = r.property_id
WHERE p.property_id IN (
    SELECT property_id
    FROM Review
    GROUP BY property_id
    HAVING AVG(rating) > 4.0
)
GROUP BY p.property_id, p.name, p.location, p.pricepernight
ORDER BY average_rating DESC;

-- Alternative approach using subquery in WHERE clause
SELECT 
    p.property_id,
    p.name,
    p.location,
    p.pricepernight
FROM Property p
WHERE (
    SELECT AVG(rating)
    FROM Review r
    WHERE r.property_id = p.property_id
) > 4.0;

-- 2. Correlated subquery: Find users who have made more than 3 bookings
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    (SELECT COUNT(*) 
     FROM Booking b 
     WHERE b.user_id = u.user_id) AS total_bookings
FROM User u
WHERE (
    SELECT COUNT(*)
    FROM Booking b
    WHERE b.user_id = u.user_id
) > 3
ORDER BY total_bookings DESC;

-- Additional subquery examples for comprehensive understanding

-- 3. Find properties that have never been booked
SELECT 
    p.property_id,
    p.name,
    p.location,
    p.pricepernight
FROM Property p
WHERE NOT EXISTS (
    SELECT 1
    FROM Booking b
    WHERE b.property_id = p.property_id
);

-- 4. Find users with above-average total spending
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    SUM(b.total_price) AS total_spent
FROM User u
INNER JOIN Booking b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name
HAVING SUM(b.total_price) > (
    SELECT AVG(user_total)
    FROM (
        SELECT SUM(total_price) AS user_total
        FROM Booking
        GROUP BY user_id
    ) AS user_spending
)
ORDER BY total_spent DESC;

-- 5. Find the most expensive property in each location
SELECT 
    p.property_id,
    p.name,
    p.location,
    p.pricepernight
FROM Property p
WHERE p.pricepernight = (
    SELECT MAX(pricepernight)
    FROM Property p2
    WHERE p2.location = p.location
)
ORDER BY p.location, p.pricepernight DESC;
