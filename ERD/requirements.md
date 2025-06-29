# AirBnB ERD Requirements


## Entities Present

1. **User**
   - Attributes: user_id (PK), first_name, last_name, email, password_hash, phone_number, role, created_at

2. **Property**
   - Attributes: property_id (PK), host_id (FK), name, description, location, pricepernight, created_at, updated_at

3. **Booking**
   - Attributes: booking_id (PK), property_id (FK), user_id (FK), start_date, end_date, total_price, status, created_at

4. **Payment**
   - Attributes: payment_id (PK), booking_id (FK), amount, payment_date, payment_method

5. **Review**
   - Attributes: review_id (PK), property_id (FK), user_id (FK), rating, comment, created_at

6. **Message**
   - Attributes: message_id (PK), sender_id (FK), recipient_id (FK), message_body, sent_at

## Relationships

1. User (1) → (N) Property (host relationship)
2. User (1) → (N) Booking (guest relationship)
3. Property (1) → (N) Booking
4. Booking (1) → (1) Payment
5. User (1) → (N) Review
6. Property (1) → (N) Review
7. User (1) → (N) Message (as sender)
8. User (N) ← (1) Message (as recipient)
