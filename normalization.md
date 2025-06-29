# Database Normalization Report

## Normalization Process

### 1NF (First Normal Form)
- All tables have atomic values in each cell
- No repeating groups found
- Primary keys established for all tables

### 2NF (Second Normal Form)
- All tables are in 1NF
- No partial dependencies found
- All non-key attributes fully depend on primary keys

### 3NF (Third Normal Form)
- All tables are in 2NF
- No transitive dependencies identified
- All non-key attributes depend only on primary keys

## Validation Checks

1. **User Table**
   - No redundant data
   - All attributes depend only on user_id

2. **Property Table**
   - host_id correctly references User
   - No transitive dependencies

3. **Booking Table**
   - Depends only on booking_id
   - Proper foreign key relationships

4. **Payment Table**
   - 1:1 relationship with Booking
   - No redundant booking information

5. **Review Table**
   - Composite uniqueness (user+property) enforced
   - Rating constraint validated

## Design Decisions

1. **Denormalization Exceptions**
   - Property.location kept as single field for simplicity
   - Booking.total_price stored for performance

2. **Constraints Added**
   - Booking date overlap prevention
   - Review rating range (1-5)
   - Unique email per user

3. **Index Optimization**
   - Foreign keys indexed
   - Frequently queried fields (email, status) indexed

The database design fully complies with 3NF requirements while maintaining practical performance considerations.