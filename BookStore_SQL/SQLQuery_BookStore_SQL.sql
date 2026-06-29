
-- Task 1 =>

CREATE TABLE Author (
    Id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL
);

CREATE TABLE Category (
    Id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL
);


CREATE TABLE Customer (
    Id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    email NVARCHAR(255) NOT NULL UNIQUE, 
    password NVARCHAR(255) NOT NULL,     
    city NVARCHAR(100) NOT NULL
);


CREATE TABLE Book (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255) NOT NULL,
    author_id INT,
    category_id INT,
    current_price DECIMAL(10, 2) NOT NULL CHECK (current_price > 0), 
    stock_count INT NOT NULL CHECK (stock_count >= 0),               
    is_bestseller BIT DEFAULT 0,
    CONSTRAINT FK_Book_Author FOREIGN KEY (author_id) REFERENCES Author(Id) ON DELETE SET NULL,
    CONSTRAINT FK_Book_Category FOREIGN KEY (category_id) REFERENCES Category(Id) ON DELETE SET NULL
);


CREATE TABLE [Order] (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Customer_id INT NOT NULL,
    order_date DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    total_price DECIMAL(10, 2),
    CONSTRAINT FK_Order_Customer FOREIGN KEY (Customer_id) REFERENCES Customer(Id) ON DELETE CASCADE
);


CREATE TABLE OrderItem (
    order_id INT,
    book_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_purchase DECIMAL(10, 2) NOT NULL, 
    PRIMARY KEY (order_id, book_id),           
    CONSTRAINT FK_OrderItem_Order FOREIGN KEY (order_id) REFERENCES [Order](Id) ON DELETE CASCADE,
    CONSTRAINT FK_OrderItem_Book FOREIGN KEY (book_id) REFERENCES Book(Id) ON DELETE NO ACTION 
    
);


-----------------------------------


-- TASK 2 =>


INSERT INTO Author (name) VALUES 
('Ahmed Ali'), 
('Ahmed khaled tofik'), 
('Mahmoud Sadek'), 
('Waled mohamed');


INSERT INTO Category (name) VALUES 
('Science Fiction'), 
('Fantasy'), 
('Mystery');


INSERT INTO Customer (name, email, password, city) VALUES 
('Ahmed Hassan', 'ahmed@email.com', 'hashed_pass_1', 'Cairo'),
('Sara Ali', 'sara@email.com', 'hashed_pass_2', 'Alexandria'),
('Omar Sayed', 'omar@email.com', 'hashed_pass_3', 'Cairo'),
('Mona Zaki', 'mona@email.com', 'hashed_pass_4', 'Giza');


INSERT INTO Book (Title, author_id, category_id, current_price, stock_count, is_bestseller) VALUES 
('Foundation', 1, 1, 15.99, 50, 1),
('Foundation and Empire', 1, 1, 14.99, 45, 0),
('Second Foundation', 1, 1, 14.99, 40, 0),
('I, Robot', 1, 1, 12.99, 60, 1),
('2001: A Space Odyssey', 4, 1, 18.50, 30, 1),
('Rendezvous with Rama', 4, 1, 16.00, 25, 0),
('Harry Potter and the Sorcerers Stone', 2, 2, 25.00, 100, 1),
('Harry Potter and the Chamber of Secrets', 2, 2, 26.00, 80, 1),
('Murder on the Orient Express', 3, 3, 10.99, 20, 0);


INSERT INTO [Order] (Customer_id, order_date, total_price) VALUES 
(1, '2023-10-15 10:00:00', 41.98),
(2, '2023-10-20 14:30:00', 25.00),
(1, '2023-11-05 09:15:00', 10.99),
(3, '2023-11-12 16:45:00', 31.49);


INSERT INTO OrderItem (order_id, book_id, quantity, price_at_purchase) VALUES 
(1, 1, 1, 15.99), -- Ahmed buys Foundation
(1, 8, 1, 25.99), -- Ahmed buys Chamber of Secrets (Pretend price was slightly different)
(2, 7, 1, 25.00), -- Sara buys Sorcerer's Stone
(3, 9, 1, 10.99), -- Ahmed buys Murder on the Orient Express
(4, 4, 1, 12.99), -- Omar buys I, Robot
(4, 5, 1, 18.50); -- Omar buys 2001: A Space Odyssey


----------------------------------


-- TASK 3 =>

SELECT Title, current_price 
FROM Book 
ORDER BY current_price DESC;


----------------------------------


-- TASK 4 =>

SELECT UPPER(b.Title) AS BookTitle, LOWER(a.name) AS AuthorName
FROM Book b
JOIN Author a ON b.author_id = a.Id;


----------------------------------


-- TASK 5 =>


SELECT b.Title AS BookTitle, c.name AS Category, a.name AS Author
FROM Book b
JOIN Category c ON b.category_id = c.Id
JOIN Author a ON b.author_id = a.Id;



-- TASK 6 =>

SELECT c.name AS CustomerName, COUNT(o.Id) AS NumberOfPurchases
FROM Customer c
LEFT JOIN [Order] o ON c.Id = o.Customer_id
GROUP BY c.Id, c.name;


----------------------------------

-- TASK 7 =>

SELECT TOP 5 b.Title, SUM(oi.quantity) AS TotalCopiesSold
FROM Book b
JOIN OrderItem oi ON b.Id = oi.book_id
GROUP BY b.Id, b.Title
ORDER BY TotalCopiesSold DESC;


----------------------------------


-- TASK 8 =>


SELECT TOP 1 city, COUNT(Id) AS NumberOfCustomers
FROM Customer
GROUP BY city
ORDER BY NumberOfCustomers DESC;


----------------------------------


-- TASK 9 =>


SELECT c.name AS CategoryName, COUNT(b.Id) AS TotalBooks
FROM Category c
JOIN Book b ON c.Id = b.category_id
GROUP BY c.Id, c.name
HAVING COUNT(b.Id) > 5;


----------------------------------


-- TASK 10 =>


SELECT Title, current_price
FROM Book
WHERE current_price > (SELECT AVG(current_price) FROM Book);


----------------------------------

-- TASK 11 =>


SELECT name, email 
FROM Customer 
WHERE Id NOT IN (SELECT Customer_id FROM [Order]);

----------------------------------

-- TASK 12 =>

SELECT FORMAT(order_date, 'yyyy-MM') AS RevenueMonth, SUM(total_price) AS TotalRevenue
FROM [Order]
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY RevenueMonth;


----------------------------------

-- TASK 13 =>
GO 
CREATE VIEW vw_BookDetails AS
SELECT b.Title, c.name AS Category, a.name AS Author, b.current_price AS Price
FROM Book b
JOIN Category c ON b.category_id = c.Id
JOIN Author a ON b.author_id = a.Id;
GO


----------------------------------

-- TASK 14 =>

GO
CREATE PROCEDURE GetCustomerPurchases 
    @CustomerId INT
AS
BEGIN
    
    SELECT 
        o.Id AS OrderID, 
        o.order_date AS OrderDate, 
        b.Title AS BookPurchased, 
        oi.quantity AS Quantity, 
        oi.price_at_purchase AS PricePaid,
        o.total_price AS OrderTotal
    FROM [Order] o
    JOIN OrderItem oi ON o.Id = oi.order_id
    JOIN Book b ON oi.book_id = b.Id
    WHERE o.Customer_id = @CustomerId
    ORDER BY o.order_date DESC;
END;
GO












