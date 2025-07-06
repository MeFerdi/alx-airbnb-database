-- Complex Queries with Joins
-- This file contains various JOIN operations to retrieve data from multiple tables

-- 1. INNER JOIN: Retrieve all bookings and the respective users who made those bookings
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
ORDER BY b.created_at DESC;

-- 2. LEFT JOIN: Retrieve all properties and their reviews, including properties that have no reviews
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_date,
    CONCAT(u.first_name, ' ', u.last_name) AS reviewer_name
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
LEFT JOIN User u ON r.user_id = u.user_id
ORDER BY p.property_id, r.created_at DESC;

-- 3. FULL OUTER JOIN: Retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user
-- Note: MySQL doesn't support FULL OUTER JOIN directly, so we'll use UNION of LEFT JOIN and RIGHT JOIN
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id

UNION

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM User u
RIGHT JOIN Booking b ON u.user_id = b.user_id
WHERE u.user_id IS NULL;
