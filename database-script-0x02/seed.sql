-- AirBnB Sample Data

-- Clear existing data (optional)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Message;
TRUNCATE TABLE Review;
TRUNCATE TABLE Payment;
TRUNCATE TABLE Booking;
TRUNCATE TABLE Property;
TRUNCATE TABLE User;
SET FOREIGN_KEY_CHECKS = 1;

-- Users
INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
-- Hosts
('a1b2c3d4-1234-5678-9101-abcdef123456', 'Wanjiku', 'Mwangi', 'wanjiku@kenya.com', '$2a$10$hash1', '+254712345678', 'host', '2022-01-15 09:30:00'),
('b2c3d4e5-2345-6789-1011-bcdef123456a', 'Omondi', 'Otieno', 'omondi@kenya.com', '$2a$10$hash2', '+254723456789', 'host', '2022-02-20 14:15:00'),
-- Guests
('d4e5f6g7-4567-8910-1111-def123456abc', 'Amina', 'Mohamed', 'amina@example.com', '$2a$10$hash4', '+254734567890', 'guest', '2022-04-05 16:45:00'),
('e5f6g7h8-5678-9101-1111-ef123456abcd', 'James', 'Kamau', 'james@example.com', '$2a$10$hash5', '+254745678901', 'guest', '2022-05-12 10:20:00'),
-- Admin
('f6g7h8i9-6789-1011-1111-f123456abcde', 'Admin', 'Kenya', 'admin@airbnb.co.ke', '$2a$10$hash6', '+254700000000', 'admin', '2022-01-01 00:00:00');

-- Properties
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at) VALUES
-- Nairobi Properties
('p1a2b3c4-1111-2222-3333-444455556666', 'a1b2c3d4-1234-5678-9101-abcdef123456', 'Karen Luxury Villa', 'Beautiful 4-bedroom villa in Karen with swimming pool', 'Karen, Nairobi', 8500.00, '2022-01-20 10:00:00', '2022-06-01 09:15:00'),
('p2b3c4d5-2222-3333-4444-555566667777', 'a1b2c3d4-1234-5678-9101-abcdef123456', 'Westlands Apartment', 'Modern 2-bed apartment near Westgate Mall', 'Westlands, Nairobi', 4500.00, '2022-02-01 14:30:00', '2022-05-15 16:20:00'),
('p3c4d5e6-3333-4444-5555-666677778888', 'b2c3d4e5-2345-6789-1011-bcdef123456a', 'CBD Executive Suite', 'Luxury serviced apartment in Nairobi CBD', 'Nairobi CBD', 6000.00, '2022-02-25 11:45:00', '2022-06-10 08:30:00'),

-- Kisumu Properties
('p4d5e6f7-4444-5555-6666-777788889999', 'b2c3d4e5-2345-6789-1011-bcdef123456a', 'Lakeview Kisumu Home', '3-bedroom home with panoramic lake views', 'Kisumu City', 5500.00, '2022-03-15 09:00:00', '2022-05-20 14:00:00'),
('p5e6f7g8-5555-6666-7777-888899990000', 'a1b2c3d4-1234-5678-9101-abcdef123456', 'Dunga Beach Cottage', 'Charming cottage near Dunga Beach', 'Dunga, Kisumu', 3500.00, '2022-03-20 16:20:00', '2022-06-05 11:45:00');

-- Bookings
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at) VALUES
-- Past Nairobi bookings
('b1a2b3c4-1111-2222-3333-444455556666', 'p1a2b3c4-1111-2222-3333-444455556666', 'd4e5f6g7-4567-8910-1111-def123456abc', '2022-06-01', '2022-06-05', 34000.00, 'confirmed', '2022-05-15 08:30:00'),
-- Current Kisumu booking
('b2b3c4d5-2222-3333-4444-555566667777', 'p4d5e6f7-4444-5555-6666-777788889999', 'e5f6g7h8-5678-9101-1111-ef123456abcd', '2022-07-10', '2022-07-15', 27500.00, 'confirmed', '2022-06-20 14:45:00'),
-- Future Nairobi booking
('b3c4d5e6-3333-4444-5555-666677778888', 'p3c4d5e6-3333-4444-5555-666677778888', 'd4e5f6g7-4567-8910-1111-def123456abc', '2022-08-20', '2022-08-25', 30000.00, 'confirmed', '2022-07-01 10:15:00'),
-- Future Kisumu booking
('b4d5e6f7-4444-5555-6666-777788889999', 'p5e6f7g8-5555-6666-7777-888899990000', 'e5f6g7h8-5678-9101-1111-ef123456abcd', '2022-09-01', '2022-09-03', 7000.00, 'pending', '2022-07-10 16:30:00');

-- Payments (for confirmed bookings)
INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method) VALUES
('pay1a2b3c4-1111-2222-3333-444455556666', 'b1a2b3c4-1111-2222-3333-444455556666', 34000.00, '2022-05-15 09:00:00', 'mpesa'),
('pay2b3c4d5-2222-3333-4444-555566667777', 'b2b3c4d5-2222-3333-4444-555566667777', 27500.00, '2022-06-20 15:30:00', 'mpesa'),
('pay3c4d5e6-3333-4444-5555-666677778888', 'b3c4d5e6-3333-4444-5555-666677778888', 30000.00, '2022-07-01 11:00:00', 'credit_card');

-- Reviews (for completed stays)
INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at) VALUES
('r1a2b3c4-1111-2222-3333-444455556666', 'p1a2b3c4-1111-2222-3333-444455556666', 'd4e5f6g7-4567-8910-1111-def123456abc', 5, 'Stunning property with excellent staff. The pool was amazing!', '2022-06-06 10:30:00'),
('r2b3c4d5-2222-3333-4444-555566667777', 'p4d5e6f7-4444-5555-6666-777788889999', 'e5f6g7h8-5678-9101-1111-ef123456abcd', 4, 'Beautiful lake views and very peaceful. The WiFi could be better.', '2022-07-16 14:45:00');

-- Messages (conversations between users)
INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
-- Guest to Nairobi host
('m1a2b3c4-1111-2222-3333-444455556666', 'd4e5f6g7-4567-8910-1111-def123456abc', 'a1b2c3d4-1234-5678-9101-abcdef123456', 'Habari Wanjiku, is there secure parking at the Karen villa?', '2022-05-10 08:15:00'),
('m2b3c4d5-2222-3333-4444-555566667777', 'a1b2c3d4-1234-5678-9101-abcdef123456', 'd4e5f6g7-4567-8910-1111-def123456abc', 'Yes Amina, we have gated parking with 24/7 security', '2022-05-10 10:30:00'),
-- Guest to Kisumu host
('m3c4d5e6-3333-4444-5555-666677778888', 'e5f6g7h8-5678-9101-1111-ef123456abcd', 'b2c3d4e5-2345-6789-1011-bcdef123456a', 'Hello Omondi, is your Kisumu home near any supermarkets?', '2022-06-15 14:20:00'),
('m4d5e6f7-4444-5555-6666-777788889999', 'b2c3d4e5-2345-6789-1011-bcdef123456a', 'e5f6g7h8-5678-9101-1111-ef123456abcd', 'Yes James, there\'s a Nakumatt 5 minutes walk away', '2022-06-15 15:45:00');