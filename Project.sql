-- Active: 1740883715704@@127.0.0.1@3306@farmersmarket
CREATE DATABASE farmersmarket;
USE farmersmarket;





CREATE TABLE customers(
    cid INT PRIMARY KEY AUTO_INCREMENT,
    cname VARCHAR(20) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    email VARCHAR(20) NOT NULL,
    phoneNumber INT NOT NULL
);

-- ADDING A CONSTRAINT TO customers TABLE
ALTER TABLE customers ADD CONSTRAINT c_gender CHECK(gender = 'M' or gender = 'F'); --Constraint on the gender
ALTER TABLE customers ADD CONSTRAINT c_email UNIQUE(email); --Constraint to make email UNIQUE
ALTER TABLE customers ADD CONSTRAINT chk_email CHECK(email LIKE '%@%'); --Constraint to check if email contains '@'
ALTER TABLE customers ADD CONSTRAINT chk_phoneNumber CHECK((LENGTH(phoneNumber) = 10) AND (phoneNumber LIKE '07%')); --Constraint to check if phoneNumber has 10 digits and starts with 07
ALTER TABLE customers ADD CONSTRAINT c_phoneNumber UNIQUE(phoneNumber); --Constraint to make phoneNumber UNIQUE

DESCRIBE customers;






--Farmers Table
CREATE TABLE farmers(
    farmerid INT PRIMARY KEY AUTO_INCREMENT,
    farmername VARCHAR(20) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    email VARCHAR(20) NOT NULL,
    phoneNumber INT NOT NULL,
    farmname VARCHAR(20) NOT NULL
);

-- ADDING A CONSTRAINT TO farmers TABLE
ALTER TABLE farmers ADD CONSTRAINT f_gender CHECK(gender = 'M' or gender = 'F'); --Constraint on the gender
ALTER TABLE farmers ADD CONSTRAINT f_email UNIQUE(email); --Constraint to make email UNIQUE
ALTER TABLE farmers ADD CONSTRAINT f_chk_email CHECK(email LIKE '%@%'); --Constraint to check if email contains '@'
ALTER TABLE farmers ADD CONSTRAINT f_chk_phoneNumber CHECK((LENGTH(phoneNumber) = 10) AND (phoneNumber LIKE '07%')); --Constraint to check if phoneNumber has 10 digits
ALTER TABLE farmers ADD CONSTRAINT f_phoneNumber UNIQUE(phoneNumber);

DESCRIBE farmers;






--Categories Table
CREATE TABLE categories(
    categoryid VARCHAR(20) PRIMARY KEY,
    categoryname VARCHAR(20) NOT NULL
);

-- ADDING A CONSTRAINT TO categories TABLE
ALTER TABLE categories ADD CONSTRAINT category_id CHECK(categoryid LIKE 'C%'); --Constraint on the categoryid
ALTER TABLE categories ADD CONSTRAINT category_name UNIQUE(categoryname); --Constraint to make categoryname UNIQUE
DESCRIBE categories;






--Products Table
CREATE TABLE products(
    productid VARCHAR(20) PRIMARY KEY,
    farmerid INT NOT NULL,
    categoryid VARCHAR(20) NOT NULL,
    productname VARCHAR(20) NOT NULL,
    description VARCHAR(100) NOT NULL,
    price INT NOT NULL,
    FOREIGN KEY (farmerid) REFERENCES farmers(farmerid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (categoryid) REFERENCES categories(categoryid) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ADDING A CONSTRAINT TO Products TABLE
ALTER TABLE products ADD CONSTRAINT product_id CHECK(productid LIKE 'P%'); --Constraint on the productid
ALTER TABLE products ADD CONSTRAINT chk_price CHECK(price > 0); --Constraint to check if price is greater than 0

DESCRIBE products;





--Orders Table
CREATE TABLE orders(
    orderid VARCHAR(20) PRIMARY KEY,
    cid INT NOT NULL,
    deliveryid VARCHAR(20) NOT NULL,
    orderdate DATE DEFAULT (CURRENT_DATE),
    orderstatus VARCHAR(20) DEFAULT 'Pending',
    totalamount INT NOT NULL,
    paymentstatus VARCHAR(20) DEFAULT 'Pending',
    droppoint VARCHAR(20) NOT NULL,
    FOREIGN KEY (cid) REFERENCES customers(cid) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ADDING A CONSTRAINT TO Orders TABLE
ALTER TABLE orders ADD CONSTRAINT order_id CHECK(orderid LIKE 'O%'); --Constraint on the orderid
ALTER TABLE orders ADD CONSTRAINT chk_orderstatus CHECK(orderstatus IN ('Pending', 'Delivered', 'Cancelled')); --Constraint to check if orderstatus is one of the given values
ALTER TABLE orders ADD CONSTRAINT chk_paymentstatus CHECK(paymentstatus IN ('Pending', 'Paid')); --Constraint to check if paymentstatus is one of the given values
ALTER TABLE orders ADD CONSTRAINT chk_totalamount CHECK(totalamount > 0); --Constraint to check if totalamount is greater than 0

DESCRIBE orders;






--OrderItems Table
CREATE TABLE orderitems(
    PRIMARY KEY(orderid, productid),
    orderid VARCHAR(20) NOT NULL,
    productid VARCHAR(20) NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (orderid) REFERENCES orders(orderid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (productid) REFERENCES products(productid) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ADDING A CONSTRAINT TO OrderItems TABLE
ALTER TABLE orderitems ADD CONSTRAINT chk_quantity CHECK(quantity > 0); --Constraint to check if quantity is greater than 0

DESCRIBE orderitems;





--Payment Table
CREATE TABLE payment(
    paymentid VARCHAR(20) PRIMARY KEY,
    cid INT NOT NULL,
    orderid VARCHAR(20) NOT NULL,
    paymentdate DATE DEFAULT (CURRENT_DATE),
    paymentmethod VARCHAR(20) NOT NULL,
    amount INT NOT NULL,
    FOREIGN KEY (cid) REFERENCES customers(cid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (orderid) REFERENCES orders(orderid) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ADDING A CONSTRAINT TO Orders TABLE
ALTER TABLE payment ADD CONSTRAINT chk_paymentid CHECK(paymentid LIKE 'PA%'); --Constraint on the paymentid
ALTER TABLE payment ADD CONSTRAINT chk_paymentmethod CHECK(paymentmethod IN ('Cash', 'Card', 'MobileMoney')); --Constraint to check if paymentmethod is one of the given values
ALTER TABLE payment ADD CONSTRAINT chk_amount CHECK(amount > 0); --Constraint to check that amount is greater than 0

DESCRIBE payment;





--Deliveries Table
CREATE TABLE deliveries(
    deliveryid VARCHAR(20) PRIMARY KEY,
    vehicletype VARCHAR (20) NOT NULL,
    drivername VARCHAR(20) NOT NULL,
    carrierNo VARCHAR(20) NOT NULL,
    deliverydate DATE DEFAULT (CURRENT_DATE)
);

--Creating Referential Integrity 
ALTER TABLE orders ADD FOREIGN KEY (deliveryid) REFERENCES deliveries(deliveryid) ON DELETE CASCADE ON UPDATE CASCADE;

--ADDING A CONSTRAINT TO deliveries TABLE
ALTER TABLE deliveries ADD CONSTRAINT chk_deliveryid CHECK(deliveryid LIKE 'D%');--Constraint to check if deliveryid starts with 'D'
ALTER TABLE deliveries ADD CONSTRAINT chk_vehicletype CHECK(vehicletype IN('Truck','Van','Motorcycle'));--Constraint to check if vehicletype is one of the given values

DESCRIBE deliveries;




--ReviewsTable
CREATE TABLE reviews(
    reviewid VARCHAR(20) PRIMARY KEY,
    cid INT NOT NULL,
    productid VARCHAR(20) NOT NULL,
    rating INT NOT NULL,
    comment VARCHAR(200),
    reviewdate DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (cid) REFERENCES customers(cid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (productid) REFERENCES products(productid) ON DELETE CASCADE ON UPDATE CASCADE
);


--ADDING A CONSTRAINT TO reviews TABLE
ALTER TABLE reviews ADD CONSTRAINT chk_rating CHECK(rating BETWEEN 1 AND 5);--Constraint to check if rating is between 1 and 5
ALTER TABLE reviews ADD CONSTRAINT chk_reviewid CHECK(reviewid LIKE 'R%');--Constraint to check if reviewid starts with 'R'

DESCRIBE reviews;




--Entering data into the tables

--Customers Table
ALTER TABLE customers MODIFY COLUMN phoneNumber VARCHAR(10);

INSERT INTO customers (cname, gender, email, phoneNumber) VALUES
('Kyobe Arron', 'M', 'kyobe@gmail.com', '0772456787'),
('Kakooza Sarah', 'F', 'sarah@gmail.com', '0776543211'),
('Kiggundu John', 'M', 'john@gmail.com', '0772345673'),
('Karungin Betty', 'F', 'betty@gmail.com', '0776432101'),
('Mugisha Peter', 'M', 'peter@gmail.com', '0776789014'),
('Lule Christine', 'F', 'christine@gmail.com', '0772423459');

SELECT * FROM customers;


--Farmers Table
ALTER TABLE farmers MODIFY COLUMN phoneNumber VARCHAR(10);
INSERT INTO farmers (farmername, gender, email, phoneNumber, farmname) VALUES
('Tamale Pascal', 'M', 'pascal@gmail.com', '0778484848', 'Tamale Farm'),
('Nabasa Nicole', 'F', 'nicole@gmail.com', '0772244473', 'Nabasa Poultry Farm'),
('Musinguzi Richard', 'M', 'richard@gmail.com', '0778980808', 'Musinguzi Ranch'),
('Kasima Denise', 'F', 'denise@gmail.com', '0774554433', 'Kasima Farm'),
('Sempala Simon', 'M', 'simon@gmail.com', '0778880909', 'Sempala Family Farm'),
('Kimbugwe Lawerence', 'M', 'lawrence@gmail.com', '0754679071', 'Kimbugwe Plantation');

SELECT * FROM farmers;

--Categories Table
INSERT INTO categories (categoryid, categoryname) VALUES
('C1', 'Fruits'),
('C2', 'Vegetables'),
('C3', 'Dairy Products'),
('C4', 'Meat Products'),
('C5', 'Poultry Products'),
('C6', 'Fish Products'),
('C7', 'Grains');

SELECT * FROM categories;

--Products Table
INSERT INTO products (productid, farmerid, categoryid, productname, description, price) VALUES
('P1', 2, 'C5', 'Eggs', 'A tray of eggs', 13000),
('P2', 3, 'C3', 'Ghee', 'A jar of ghee', 15000),
('P3', 5, 'C3', 'Milk', 'A litre of milk', 10000),
('P4', 2, 'C4', 'Beef', 'A kg of beef', 15000),
('P5', 1, 'C1', 'Apples', '20 apples in a bag', 10000),
('P6', 4, 'C2', 'Carrots', '20 carrots in a bag', 5000),
('P7', 6, 'C7', 'Rice', '1kg of rice', 3500),
('P8', 6, 'C7', 'Maize', '1kg of maize', 2500),
('P9', 6, 'C7', 'Wheat', '1kg of wheat', 3000),
('P10', 6, 'C7', 'Barley', '1kg of barley', 2000);

SELECT * FROM products;

--Orders Table
INSERT INTO orders (orderid, cid, deliveryid, orderdate, orderstatus, totalamount, paymentstatus, droppoint) VALUES
('O1', 1, 'D1', '2025-03-01', 'Delivered', 39000, 'Paid', 'Mukono Mall'),
('O2', 2, 'D2', '2025-03-02', 'Delivered', 50000, 'Paid', 'Freedom City'),
('O3', 3, 'D3', '2025-03-03', 'Delivered', 6000, 'Paid', 'Kamwokya Park'),
('O4', 4, 'D4', '2025-03-04', 'Pending', 40000, 'Pending', 'Kampala City'),
('O5', 1, 'D5', '2025-03-05', 'Pending', 18500, 'Pending', 'Rubaga Church'),
('O6', 6, 'D5', '2025-03-05', 'Pending', 10000, 'Pending', 'Namasuba Stage');

SELECT * FROM orders;


--OrderItems Table
INSERT INTO orderitems (orderid, productid, quantity) VALUES
('O1', 'P1', 2),
('O2', 'P5', 5),
('O3', 'P9', 2),
('O4', 'P3', 2),
('O4', 'P7', 2),
('O4', 'P1', 2),
('O5', 'P4', 1),
('O5', 'P7', 1),
('O6', 'P3', 1);

SELECT * FROM orderitems;

--Payment Table
INSERT INTO payment (paymentid, cid, orderid, paymentdate, paymentmethod, amount) VALUES
('PA1', 1, 'O1', '2025-03-01', 'Cash', 44000),
('PA2', 2, 'O2', '2025-03-02', 'Card', 55000),
('PA3', 3, 'O3', '2025-03-03', 'MobileMoney', 11000);

SELECT * FROM payment;

--Deliveries Table
INSERT INTO deliveries (deliveryid, vehicletype, drivername, carrierNo, deliverydate) VALUES
('D1', 'Truck', 'John Paul', 'UA 0090', '2025-03-01'),
('D2', 'Van', 'Kabakumba Joseph', 'UA 0100', '2025-03-02'),
('D3', 'Motorcycle', 'Kabito Moses', 'UA 1066', '2025-03-03'),
('D4', 'Van', 'Kabakumba Joseph', 'UA 0100', '2025-03-04'),
('D5', 'Truck', 'Yusuf Ssebuwufu', 'UA 0130', '2025-03-06');

--Reviews Table
INSERT INTO reviews (reviewid, cid, productid, rating, comment, reviewdate) VALUES
('R1', 1, 'P1', 5, 'Excellent product!', '2024-11-01'),
('R2', 2, 'P2', 4, 'Good quality', '2024-12-02'),
('R3', 3, 'P3', 2, 'Fair quality', '2024-12-03'),
('R4', 4, 'P2', 2, 'Poor quality', '2025-01-04'),
('R5', 5, 'P5', 1, 'Very bad product', '2025-01-30'),
('R6', 3, 'P9', 5, 'Excellent product!', '2025-03-03'),
('R7', 2, 'P10', 3, '', '2025-03-02');

SELECT * FROM reviews;





--1. INNER JOINING ORDERS AND CUSTOMERS
--Shows the order details and the details of the customer who made the order
CREATE VIEW orders_with_customer AS
SELECT o.orderid, o.orderdate, o.orderstatus, o.totalamount, c.cname, c.email, c.phoneNumber
FROM orders o
JOIN customers c ON o.cid = c.cid;

--2. RIGHT JOINING PRODUCTS AND CATEGORIES
--Shows the product details and the category the product belongs to
CREATE VIEW products_with_categories AS
SELECT p.productid, p.productname, p.description, p.price, c.categoryname
FROM products p
RIGHT JOIN categories c ON p.categoryid = c.categoryid;

--3. FULL JOINING ORDERS AND DELIVERIES (MERGES LEFT AND RIGHT JOIN)
--Shows the order details and the details of the delivery
CREATE VIEW orders_with_deliveries AS
SELECT o.orderid, o.orderdate, o.orderstatus, o.totalamount, d.deliveryid, d.drivername, d.carrierNo, d.deliverydate
FROM orders o
LEFT JOIN deliveries d ON o.deliveryid = d.deliveryid
UNION
SELECT o.orderid, o.orderdate, o.orderstatus, o.totalamount, d.deliveryid, d.drivername, d.carrierNo, d.deliverydate
FROM orders o
RIGHT JOIN deliveries d ON o.deliveryid = d.deliveryid
WHERE o.deliveryid IS NULL;

--FULL JOINING ORDERS AND PAYMENTS(MERGES LEFT AND RIGHT JOIN)
--Shows the order details and the details of the payment
CREATE VIEW orders_with_payments AS
SELECT o.orderid, o.orderdate, o.orderstatus, o.totalamount, o.droppoint, p.paymentid, p.paymentdate, p.paymentmethod, p.amount
FROM orders o
LEFT JOIN payment p ON o.orderid = p.orderid
UNION
SELECT o.orderid, o.orderdate, o.orderstatus, o.totalamount, o.droppoint, p.paymentid, p.paymentdate, p.paymentmethod, p.amount
FROM orders o
RIGHT JOIN payment p ON o.orderid = p.orderid
WHERE o.orderid IS NULL;

--LEFT JOINING CUSTOMERS AND REVIEWS
--Shows customer details and the review each customer made
CREATE VIEW customers_with_reviews AS
SELECT c.cname, c.email, c.phoneNumber, r.reviewid, r.rating, r.comment, r.reviewdate
FROM customers c
LEFT JOIN reviews r ON c.cid = r.cid;

--LEFT JOINING PRODUCTS AND REVIEWS
--Shows the product and the review each product got
CREATE VIEW products_with_reviews AS
SELECT p.productid, p.productname, p.description, p.price, r.reviewid, r.rating, r.comment, r.reviewdate
FROM products p
LEFT JOIN reviews r ON p.productid = r.productid;


--VIEW FOR FARMER THAT SUPPLIES THE MOST PRODUCTS
--View that shows the count of products each farmer supplied
CREATE VIEW products_per_farmer AS
SELECT f.farmername, COUNT(p.productid) AS total_products
FROM farmers f
JOIN products p ON f.farmerid = p.farmerid
GROUP BY f.farmerid
ORDER BY total_products DESC;

--VIEW FOR WHO MADE THE MOST DELIVERIES
--View that shows which delivery person made the most deliveries
CREATE VIEW deliveries_per_driver AS
SELECT d.drivername, COUNT(o.orderid) AS total_deliveries
FROM deliveries d
JOIN orders o ON d.deliveryid = o.deliveryid
GROUP BY d.drivername
ORDER BY total_deliveries DESC;

--SELECTING ORDERS WHOSE PAYMENT STATUS IS PENDING
SELECT * FROM orders WHERE paymentstatus = 'Pending';

--SELECTING REVIEWS WITH RATING GREATER THAN 3
SELECT * FROM reviews WHERE rating > 3;

--SELECTING ORDERS WITH TOTAL AMOUNT GREATER THAN 50000
SELECT * FROM orders WHERE totalamount > 50000;

--SELECTING PRODUCTS WITH PRICE GREATER THAN 5000
SELECT * FROM products WHERE price > 5000;




--UPDATING ORDER 'O4'
UPDATE orders SET orderstatus = 'Delivered', paymentstatus = 'Paid' WHERE orderid = 'O4';

--STARTING A TRANSACTION
START TRANSACTION;

--INSERTING A NEW PAYMENT
INSERT INTO payment VALUES('PA4', 4, 'O4', '2025-03-04', 'Cash', 45000);

--UPDATING PRODUCT 'P4'
UPDATE products SET productname = 'Chicken', description = 'A kg of chicken', price = 20000 WHERE productid = 'P4';

--DELETING PRODUCT 'P10'
DELETE FROM products WHERE productid = 'P10';

SELECT * FROM products;

--DELETING ORDER 'O3'
DELETE FROM orders WHERE orderid = 'O3';

SELECT * FROM orders;

SELECT * FROM orderitems;

--ROLLING BACK THE TRANSACTION
ROLLBACK;


















