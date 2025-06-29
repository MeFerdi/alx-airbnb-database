# AirBnB Kenya Sample Data Documentation

## Purpose
This directory contains scripts to populate the AirBnB database with sample data

## Files

1. `seed.sql` - Main script containing all sample data
2. `README.md` - This documentation file

## Kenyan Data Highlights

### User Accounts
- 2 Hosts
- 2 Guests
- 1 Admin

### Properties
**Nairobi:**
1. Karen Luxury Villa
2. Westlands Apartment
3. CBD Executive Suite

**Kisumu:**
1. Lakeview Kisumu Home
2. Dunga Beach Cottage

### Bookings
- 4 total bookings
- Mix of past, current, and future dates
- Prices in Kenyan Shillings

### Kenyan Features
- M-Pesa payment method included
- Local phone numbers (+254 format)
- Swahili greetings in messages
- References to local amenities (Nakumatt supermarket)
- Realistic Kenyan names and locations

## Usage Instructions

1. First ensure the database schema is created using the scripts in `database-script-0x01`
2. Run the seed script:
   ```bash
   mysql -u username -p airbnb_db < seed.sql