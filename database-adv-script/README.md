# Complex Queries with Joins

## Overview
This task demonstrates mastery of SQL joins by implementing three different types of join operations on the Airbnb database.

## Queries Implemented

### 1. INNER JOIN - Bookings with Users
**Purpose**: Retrieve all bookings along with the user information who made those bookings.

**Query Details**:
- Joins `Booking` and `User` tables
- Returns only records where both booking and user exist
- Includes booking details (ID, dates, price, status) and user details (name, email)
- Ordered by booking creation date

### 2. LEFT JOIN - Properties with Reviews
**Purpose**: Retrieve all properties and their reviews, including properties that have no reviews.

**Query Details**:
- Joins `Property`, `Review`, and `User` tables
- Returns all properties, even those without reviews
- Includes property details and review information when available
- Shows reviewer name for existing reviews

### 3. FULL OUTER JOIN - Users and Bookings
**Purpose**: Retrieve all users and all bookings, showing the complete picture of the relationship.

**Implementation Note**:
- MySQL doesn't support FULL OUTER JOIN directly
- Implemented using UNION of LEFT JOIN and RIGHT JOIN
- Shows all users (with or without bookings) and all bookings (with or without valid users)

## Key Learning Points

1. **INNER JOIN**: Only returns matching records from both tables
2. **LEFT JOIN**: Returns all records from the left table and matching records from the right table
3. **FULL OUTER JOIN**: Returns all records from both tables, with NULL values where no match exists
