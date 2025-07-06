-- Complex Query Performance Analysis
-- This file contains the initial complex query and its optimized version

-- INITIAL QUERY: Retrieve all bookings with user details, property details, and payment details
-- This query demonstrates a common but potentially inefficient approach

SELECT 
    -- Booking information
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price AS booking_amount,
    b.status AS booking_status,
    b.created_at AS booking_created,
    
    -- User information
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role AS user_role,
    u.created_at AS user_created,
    
    -- Property information
    p.property_id,
    p.name AS property_name,
    p.description AS property_description,
    p.location,
    p.pricepernight,
    p.created_at AS property_created,
    
    -- Host information
    h.user_id AS host_id,
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    h.email AS host_email,
    
    -- Payment information
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_date,
    pay.payment_method,
    
    -- Additional calculated fields
    DATEDIFF(b.end_date, b.start_date) AS booking_duration,
    (b.total_price / DATEDIFF(b.end_date, b.start_date)) AS daily_rate,
    
    -- Property rating information
    (SELECT AVG(rating) FROM Review r WHERE r.property_id = p.property_id) AS avg_property_rating,
    (SELECT COUNT(*) FROM Review r WHERE r.property_id = p.property_id) AS total_reviews

FROM Booking b
-- Join with user (guest)
INNER JOIN User u ON b.user_id = u.user_id
-- Join with property
INNER JOIN Property p ON b.property_id = p.property_id
-- Join with host (property owner)
INNER JOIN User h ON p.host_id = h.user_id
-- Left join with payment (some bookings might not have payments yet)
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id

ORDER BY b.created_at DESC, b.booking_id;

-- PERFORMANCE ANALYSIS OF INITIAL QUERY:
-- Issues identified:
-- 1. Subqueries for rating calculations executed for each row
-- 2. Unnecessary columns selected (full descriptions, etc.)
-- 3. Complex calculations in SELECT clause
-- 4. No filtering, returns all data
-- 5. Potential Cartesian product if multiple payments per booking

-- ============================================================================
-- OPTIMIZED QUERY VERSION 1: Basic optimization with strategic improvements
-- ============================================================================

SELECT 
    -- Essential booking information only
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    -- Essential user information
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email AS guest_email,
    
    -- Essential property information
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    -- Essential host information
    CONCAT(h.first_name, ' ', h.last_name) AS host_name,
    
    -- Payment information (aggregated to handle multiple payments)
    GROUP_CONCAT(DISTINCT pay.payment_method) AS payment_methods,
    SUM(pay.amount) AS total_paid,
    
    -- Pre-calculated rating information using joins instead of subqueries
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(DISTINCT r.review_id) AS review_count

FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
LEFT JOIN Review r ON p.property_id = r.property_id

-- Add useful filters to reduce dataset
WHERE b.created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)  -- Last year only
AND b.status IN ('confirmed', 'completed')  -- Only relevant bookings

GROUP BY 
    b.booking_id, b.start_date, b.end_date, b.total_price, b.status,
    u.first_name, u.last_name, u.email,
    p.name, p.location, p.pricepernight,
    h.first_name, h.last_name

ORDER BY b.start_date DESC
LIMIT 1000;  -- Limit results for better performance

-- ============================================================================
-- OPTIMIZED QUERY VERSION 2: Advanced optimization with materialized calculations
-- ============================================================================

-- Create a more efficient query using WITH clause (Common Table Expression)
WITH BookingDetails AS (
    SELECT 
        b.booking_id,
        b.start_date,
        b.end_date,
        b.total_price,
        b.status,
        b.user_id,
        b.property_id
    FROM Booking b
    WHERE b.created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
    AND b.status IN ('confirmed', 'completed')
),
PropertyRatings AS (
    SELECT 
        property_id,
        ROUND(AVG(rating), 2) AS avg_rating,
        COUNT(*) AS review_count
    FROM Review
    GROUP BY property_id
),
PaymentSummary AS (
    SELECT 
        booking_id,
        SUM(amount) AS total_paid,
        GROUP_CONCAT(DISTINCT payment_method) AS payment_methods,
        COUNT(*) AS payment_count
    FROM Payment
    GROUP BY booking_id
)

SELECT 
    bd.booking_id,
    bd.start_date,
    bd.end_date,
    bd.total_price,
    bd.status,
    
    -- User information
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email AS guest_email,
    
    -- Property information
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    -- Host information
    CONCAT(h.first_name, ' ', h.last_name) AS host_name,
    h.email AS host_email,
    
    -- Pre-calculated ratings
    COALESCE(pr.avg_rating, 0) AS avg_rating,
    COALESCE(pr.review_count, 0) AS review_count,
    
    -- Payment summary
    COALESCE(ps.total_paid, 0) AS total_paid,
    COALESCE(ps.payment_methods, 'None') AS payment_methods,
    
    -- Calculated fields
    DATEDIFF(bd.end_date, bd.start_date) AS booking_duration

FROM BookingDetails bd
INNER JOIN User u ON bd.user_id = u.user_id
INNER JOIN Property p ON bd.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN PropertyRatings pr ON bd.property_id = pr.property_id
LEFT JOIN PaymentSummary ps ON bd.booking_id = ps.booking_id

ORDER BY bd.start_date DESC
LIMIT 1000;

-- ============================================================================
-- OPTIMIZED QUERY VERSION 3: Highly optimized with specific use case focus
-- ============================================================================

-- For dashboard/reporting purposes - focusing on essential metrics only
SELECT 
    b.booking_id,
    DATE_FORMAT(b.start_date, '%Y-%m-%d') AS check_in_date,
    DATEDIFF(b.end_date, b.start_date) AS nights,
    b.total_price,
    b.status,
    
    -- Concatenated names for display
    CONCAT(u.first_name, ' ', u.last_name) AS guest,
    p.name AS property,
    p.location,
    CONCAT(h.first_name, ' ', h.last_name) AS host,
    
    -- Essential metrics only
    COALESCE(pr.avg_rating, 0) AS rating,
    COALESCE(ps.total_paid, 0) AS paid

FROM Booking b
FORCE INDEX (idx_booking_start_date)  -- Force use of date index
INNER JOIN User u FORCE INDEX (PRIMARY) ON b.user_id = u.user_id
INNER JOIN Property p FORCE INDEX (PRIMARY) ON b.property_id = p.property_id
INNER JOIN User h FORCE INDEX (PRIMARY) ON p.host_id = h.user_id
LEFT JOIN (
    SELECT property_id, AVG(rating) AS avg_rating
    FROM Review
    GROUP BY property_id
) pr ON p.property_id = pr.property_id
LEFT JOIN (
    SELECT booking_id, SUM(amount) AS total_paid
    FROM Payment
    GROUP BY booking_id
) ps ON b.booking_id = ps.booking_id

WHERE b.start_date >= CURDATE() - INTERVAL 6 MONTH  -- Last 6 months only
AND b.status = 'confirmed'

ORDER BY b.start_date DESC
LIMIT 500;
