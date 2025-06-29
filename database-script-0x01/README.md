# AirBnB Database Schema

## Schema Definition

The schema consists of 6 main tables:

1. `User` - Stores all user accounts
2. `Property` - Contains property listings
3. `Booking` - Manages reservation records
4. `Payment` - Tracks payment transactions
5. `Review` - Stores guest reviews
6. `Message` - Handles user messaging

## Implementation Details

### Key Features
- UUID primary keys for all tables
- Appropriate data types for each field
- Comprehensive foreign key relationships
- Constraints for data integrity:
  - CHECK constraints
  - UNIQUE constraints
  - NOT NULL constraints
- Optimized indexes for performance

### Usage

1. To create the database:
   ```bash
   mysql -u username -p < schema.sql