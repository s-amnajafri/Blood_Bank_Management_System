# Blood Bank Management System

A comprehensive Database Management System (DBMS) project built using MySQL and Python (Streamlit).

## Project Overview

This system manages blood bank operations including donor registration, blood unit storage, blood requests, and reporting.

## Tech Stack

- **Database:** MySQL
- **Frontend:** Python, Streamlit
- **Tools:** MySQL Workbench, VS Code

## Database Structure

The system contains 12 tables:
- Person, Donor, Patient, Staff, ClinicalAnalyst
- BloodBank, StorageLocation, BloodUnit
- Donation, BloodRequest, Hospital, DiscardUnit

## Features

- Donor registration and management
- Blood unit tracking with expiry management
- Blood request handling and approval
- Automated triggers for blood unit creation and expiry
- Views for quick data access
- Stored procedures for generating reports

## SQL Files

Run in this order in MySQL Workbench:

1. schema.sql - Creates all 12 tables with constraints
2. sample_data.sql - Inserts sample data
3. triggers.sql - Creates 3 triggers
4. views.sql - Creates 4 views
5. procedures.sql - Creates 4 stored procedures
6. queries.sql - Join and aggregation queries

## How to Run

Step 1 - Setup Database

Open MySQL Workbench and run:

    CREATE DATABASE bloodbank;
    USE bloodbank;

Then run the SQL files in the order listed above.

Step 2 - Configure Connection

In db.py, update your MySQL password:

    password="your_mysql_password"

Step 3 - Install Dependencies

Open Command Prompt and run:

    py -m pip install streamlit mysql-connector-python pandas

Step 4 - Run the App

    py -m streamlit run app.py


## Streamlit App Pages

- Dashboard - metrics and charts overview
- Donors - view, add, and search donors
- Blood Units - available stock, expired units, availability check
- Blood Requests - view all requests, approve pending ones
- Reports - donor summary, monthly report, discard report