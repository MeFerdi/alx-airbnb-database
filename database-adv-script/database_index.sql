-- Database Indexing for Performance Optimization

-- Indexes for User table
-- Email is already indexed in the schema, but we can add more strategic indexes

-- Index for user role (frequently used in WHERE clauses)
CREATE INDEX idx_user_role ON User(role);

-- Index for user creation date (for time-based queries)
CREATE INDEX idx_user_created_at ON User(created_at);

-- Composite index for name searches
CREATE INDEX idx_user_name ON User(first_name, last_name);

-- Indexes for Property table
-- Host_id is already indexed, but let's add more

-- Index for location (frequently searched)
CREATE INDEX idx_property_location ON Property(location);

-- Index for price range queries
CREATE INDEX idx_property_price ON Property(pricepernight);

-- Composite index for location and price (common search criteria)
CREATE INDEX idx_property_location_price ON Property(location, pricepernight);

-- Index for property creation date
CREATE INDEX idx_property_created_at ON Property(created_at);

-- Indexes for Booking table
-- property_id and user_id are already indexed

-- Index for booking dates (very frequently queried)
CREATE INDEX idx_booking_start_date ON Booking(start_date);
CREATE INDEX idx_booking_end_date ON Booking(end_date);

-- Composite index for date range queries
CREATE INDEX idx_booking_date_range ON Booking(start_date, end_date);

-- Index for booking status
CREATE INDEX idx_booking_status ON Booking(status);

-- Index for total price (for revenue analysis)
CREATE INDEX idx_booking_total_price ON Booking(total_price);

-- Composite index for property and date (common join and filter)
CREATE INDEX idx_booking_property_date ON Booking(property_id, start_date, end_date);

-- Composite index for user and date (user booking history)
CREATE INDEX idx_booking_user_date ON Booking(user_id, start_date);

-- Index for booking creation timestamp
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- Indexes for Review table

-- Index for property reviews (already has property_id FK index)
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);

-- Index for rating (for aggregation queries)
CREATE INDEX idx_review_rating ON Review(rating);

-- Index for review creation date
CREATE INDEX idx_review_created_at ON Review(created_at);

-- Composite index for user reviews with rating
CREATE INDEX idx_review_user_rating ON Review(user_id, rating);

-- Indexes for Payment table
-- booking_id is already indexed

-- Index for payment date (for financial reporting)
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- Index for payment method (for payment analysis)
CREATE INDEX idx_payment_method ON Payment(payment_method);

-- Index for payment amount
CREATE INDEX idx_payment_amount ON Payment(amount);

-- Composite index for payment reporting
CREATE INDEX idx_payment_date_method ON Payment(payment_date, payment_method);

-- Indexes for Message table
-- sender_id and recipient_id are already indexed

-- Index for message timestamp
CREATE INDEX idx_message_sent_at ON Message(sent_at);

-- Composite index for conversation threads
CREATE INDEX idx_message_conversation ON Message(sender_id, recipient_id, sent_at);