# BookStore_SQL

## Description
This project features a fully normalized relational database designed for an online e-commerce bookstore. Built using SQL Server (T-SQL), the database is structured to manage customer accounts, track book inventory, and process multi-item orders. 

The schema is specifically engineered to ensure data integrity and enforce strict business rules. It prevents invalid data entries (such as negative stock or duplicate emails) and securely logs historical transaction data, ensuring that past order receipts retain their original purchase prices even if a book's current catalog price changes later.

## Included Features
The central `Bookstore_Tasks.sql` script contains the complete implementation for 14 specific business tasks, including:
* **Schema Design:** DDL statements creating a fully normalized (1NF-3NF) database.
* **Data Seeding:** `INSERT` statements with diverse sample data to test all relationships.
* **Business Queries:** Complex queries utilizing `JOIN`s, aggregations, and subqueries to extract insights (e.g., top-selling books, highest customer concentration, revenue analysis).
* **Views & Procedures:** Implementation of a compiled `VIEW` for clean data extraction and a `STORED PROCEDURE` to dynamically retrieve a specific customer's purchase history.
