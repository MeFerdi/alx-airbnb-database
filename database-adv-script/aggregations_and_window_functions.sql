-- Aggregations and Window Functions

-- 1. Aggregation: Find the total number of bookings made by each user using COUNT and GROUP BY
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_spent,
    AVG(b.total_price) AS average_booking_value,
    MIN(b.start_date) AS first_booking_date,
    MAX(b.start_date) AS last_booking_date
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name, u.email
ORDER BY total_bookings DESC, total_spent DESC;

-- 2. Window Functions: Rank properties based on the total number of bookings they have received
SELECT 
    p.property_id,
    p.name,
    p.location,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    -- ROW_NUMBER: Assigns unique sequential integers
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_number,
    -- RANK: Assigns same rank to ties, with gaps
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank_with_gaps,
    -- DENSE_RANK: Assigns same rank to ties, without gaps
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS dense_rank
FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name, p.location, p.pricepernight
ORDER BY total_bookings DESC;

-- Other Examples

-- 3. Rank properties by total bookings within each location
SELECT 
    p.property_id,
    p.name,
    p.location,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (PARTITION BY p.location ORDER BY COUNT(b.booking_id) DESC) AS location_rank,
    -- Calculate percentage of total bookings in location
    ROUND(
        COUNT(b.booking_id) * 100.0 / 
        SUM(COUNT(b.booking_id)) OVER (PARTITION BY p.location), 
        2
    ) AS percentage_of_location_bookings
FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name, p.location, p.pricepernight
ORDER BY p.location, total_bookings DESC;

-- 4. Running totals and moving averages for user bookings
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    b.booking_id,
    b.start_date,
    b.total_price,
    -- Running total of user's spending
    SUM(b.total_price) OVER (
        PARTITION BY u.user_id 
        ORDER BY b.start_date 
        ROWS UNBOUNDED PRECEDING
    ) AS running_total_spent,
    -- Moving average of last 3 bookings
    AVG(b.total_price) OVER (
        PARTITION BY u.user_id 
        ORDER BY b.start_date 
        ROWS 2 PRECEDING
    ) AS moving_avg_last_3_bookings,
    -- Lag function to compare with previous booking
    LAG(b.total_price, 1) OVER (
        PARTITION BY u.user_id 
        ORDER BY b.start_date
    ) AS previous_booking_price,
    -- Lead function to compare with next booking
    LEAD(b.total_price, 1) OVER (
        PARTITION BY u.user_id 
        ORDER BY b.start_date
    ) AS next_booking_price
FROM User u
INNER JOIN Booking b ON u.user_id = b.user_id
ORDER BY u.user_id, b.start_date;

-- 5. Advanced aggregations: Monthly booking statistics
SELECT 
    YEAR(b.start_date) AS booking_year,
    MONTH(b.start_date) AS booking_month,
    COUNT(*) AS total_bookings,
    SUM(b.total_price) AS total_revenue,
    AVG(b.total_price) AS average_booking_value,
    MIN(b.total_price) AS min_booking_value,
    MAX(b.total_price) AS max_booking_value,
    -- Compare with previous month
    LAG(COUNT(*), 1) OVER (ORDER BY YEAR(b.start_date), MONTH(b.start_date)) AS prev_month_bookings,
    -- Calculate month-over-month growth
    ROUND(
        (COUNT(*) - LAG(COUNT(*), 1) OVER (ORDER BY YEAR(b.start_date), MONTH(b.start_date))) * 100.0 /
        NULLIF(LAG(COUNT(*), 1) OVER (ORDER BY YEAR(b.start_date), MONTH(b.start_date)), 0),
        2
    ) AS mom_growth_percentage
FROM Booking b
GROUP BY YEAR(b.start_date), MONTH(b.start_date)
ORDER BY booking_year, booking_month;

-- 6. Property performance analytics with window functions
SELECT 
    p.property_id,
    p.name,
    p.location,
    COUNT(b.booking_id) AS total_bookings,
    AVG(r.rating) AS average_rating,
    SUM(b.total_price) AS total_revenue,
    -- Percentile rankings
    PERCENT_RANK() OVER (ORDER BY COUNT(b.booking_id)) AS booking_percentile,
    PERCENT_RANK() OVER (ORDER BY AVG(r.rating)) AS rating_percentile,
    PERCENT_RANK() OVER (ORDER BY SUM(b.total_price)) AS revenue_percentile,
    -- Quartiles
    NTILE(4) OVER (ORDER BY COUNT(b.booking_id)) AS booking_quartile,
    NTILE(4) OVER (ORDER BY SUM(b.total_price)) AS revenue_quartile
FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id
LEFT JOIN Review r ON p.property_id = r.property_id
GROUP BY p.property_id, p.name, p.location
HAVING COUNT(b.booking_id) > 0  -- Only include properties with bookings
ORDER BY total_revenue DESC;
