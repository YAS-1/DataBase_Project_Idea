-- Active: 1738568510712@@127.0.0.1@3306@farmersmarket

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
ALTER TABLE customers ADD CONSTRAINT c_phoneNumber UNIQUE(phoneNumber); --Constraint to make phoneNumber UNIQUE
ALTER TABLE customers ADD CONSTRAINT chk_phoneNumber CHECK(LENGTH(phoneNumber) = 10); --Constraint to check if phoneNumber has 10 digits

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
ALTER TABLE farmers ADD CONSTRAINT f_phoneNumber UNIQUE(phoneNumber); --Constraint to make phoneNumber UNIQUE
ALTER TABLE farmers ADD CONSTRAINT f_chk_phoneNumber CHECK(LENGTH(phoneNumber) = 10); --Constraint to check if phoneNumber has 10 digits

DESCRIBE farmers;


--Categories Table
CREATE TABLE categories(
    categoryid VARCHAR(20) PRIMARY KEY,
    categoryname VARCHAR(20) NOT NULL
);

-- ADDING A CONSTRAINT TO categories TABLE
ALTER TABLE categories ADD CONSTRAINT category_id CHECK(categoryid LIKE 'C%'); --Constraint on the categoryid
ALTER TABLE categories ADD CONSTRAINT category_name UNIQUE(categoryname); --Constraint to make categoryname UNIQUE
ALTER TABLE categories ADD CONSTRAINT chk_categoryname CHECK(categoryname LIKE '%[a-zA-Z]%'); --Constraint to check if categoryname contains alphabets

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
ALTER TABLE products ADD CONSTRAINT chk_productname CHECK(productname LIKE '%[a-zA-Z]%'); --Constraint to check if productname contains alphabets
ALTER TABLE products ADD CONSTRAINT chk_description CHECK(description LIKE '%[a-zA-Z]%'); --Constraint to check if description contains alphabets
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
ALTER TABLE orders ADD CONSTRAINT chk_droppoint CHECK(droppoint LIKE '%[a-zA-Z]%'); --Constraint to check if droppoint contains alphabets
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
ALTER TABLE reviews ADD CONSTRAINT chk_comment CHECK(comment LIKE '%[a-zA-Z]%');--Constraint to check if comment contains at least one letter


DESCRIBE reviews;
