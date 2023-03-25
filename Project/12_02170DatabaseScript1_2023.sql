-- 4. Implementation (Use SQL statements CREATE DATABASE, CREATE TABLE and CREATE VIEW.)
DROP DATABASE IF EXISTS CMSDB;
CREATE DATABASE CMSDB;
USE CMSDB;

DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS shop_order;
DROP TABLE IF EXISTS purchase;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS job_function;
DROP TABLE IF EXISTS department;

CREATE TABLE customer
    (
        customerID      VARCHAR(6) NOT NULL,
        name            VARCHAR(50) NOT NULL,
        area_code       VARCHAR(3),
        phone_number    VARCHAR(15),
        password        VARCHAR(20) NOT NULL,
        address         VARCHAR(50),
        PRIMARY KEY (customerID) 
    );
   
CREATE TABLE department
    (
        departID            VARCHAR(4) NOT NULL,
        depart_name         VARCHAR(20) NOT NULL,
        PRIMARY KEY(departID)
    );

CREATE TABLE job_function 
    (
        job_title           VARCHAR(20) NOT NULL,  
        departID            VARCHAR(4) NOT NULL,
        min_salary          DECIMAL(8, 2) NOT NULL,
        max_salary          DECIMAL(8, 2) NOT NULL,
        PRIMARY KEY(job_title, departID),
        FOREIGN KEY(departID) REFERENCES department(departID) ON DELETE CASCADE
    );

CREATE TABLE employee 
    (
        employeeID              VARCHAR(6) NOT NULL,
        job_title               VARCHAR(15) NOT NULL,
        departID                VARCHAR(4) NOT NULL,
        name                    VARCHAR(20) NOT NULL,
        area_code               VARCHAR(3),
        phone_number            VARCHAR(15),
        salary                  DECIMAL(8, 2) NOT NULL, 
        start_date              DATE NOT NULL,
        PRIMARY KEY(employeeID),
        FOREIGN KEY(job_title) REFERENCES job_function(job_title) ON DELETE CASCADE,
        FOREIGN KEY(departID) REFERENCES job_function(departID) ON DELETE CASCADE
    );

CREATE TABLE shop_order 
    (
        orderID         VARCHAR(6) NOT NULL,
        customerID      VARCHAR(6) NOT NULL,
        status          VARCHAR(12) NOT NULL,
        employeeID      VARCHAR(6) NOT NULL,
        PRIMARY KEY (orderID),
        FOREIGN KEY (customerID) REFERENCES customer(customerID) ON DELETE CASCADE,
        FOREIGN KEY (employeeID) REFERENCES employee(employeeID)
    );
    
CREATE TABLE product 
    (
        prodID              VARCHAR(6)     NOT NULL,
        prod_name           VARCHAR(20)     NOT NULL,
        price               DECIMAL(8,2)    NOT NULL,
        stock               INT             NOT NULL,
        PRIMARY KEY(prodID)
    );

CREATE TABLE purchase 
    (   
        orderID         VARCHAR(6) NOT NULL,
        prodID          VARCHAR(6) NOT NULL,
        quantity        INT NOT NULL,
        purchase_price  DECIMAL(8,2) NOT NULL,
        PRIMARY KEY (orderID, prodID),
        FOREIGN KEY (orderID) REFERENCES shop_order(orderID) ON DELETE CASCADE,
        FOREIGN KEY (prodID) REFERENCES product(prodID) ON DELETE CASCADE
    );

-- Database views
CREATE VIEW customer_view AS
    SELECT customerID, name, area_code, phone_number, address
    FROM customer;

CREATE VIEW employee_view AS
    SELECT employeeID, name, job_title, departID , area_code, phone_number, salary, start_date
    FROM employee;

CREATE VIEW shop_order_view AS
    SELECT orderID, customerID, status, employeeID
    FROM shop_order;

CREATE VIEW stockers as (
    SELECT * FROM employee WHERE job_title = "Stocker");
 

-- 5. Database Instance
-- 5.1 Use SQL INSERT to populate the tables.
INSERT customer VALUES
('C00000', 'Alice', '45', '12345678', 'Alice123', 'Future Road 324'),
('C00001', 'Bob', '43', '13344688', 'Bob123', 'Future Road 325'),
('C00002', 'Carl', '143', '1222212688', 'Carl123', 'Future Road 325');


INSERT department VALUES
  ('D001', 'Sales'),
  ('D002', 'Marketing'),
  ('D003', 'HR'),
  ('D004', 'Stock'),
  ('D005', 'Cleaning');

INSERT job_function VALUES
('Store assistant', 'D001', 40000, 60000),
('Manager', 'D001', 100000, 120000),
('Marketing Director', 'D002', 120000, 140000),
('Stocker', 'D004', 50000, 70000),
('Cleaner', 'D005', 40000, 50000);

INSERT employee VALUES
('E00000', 'Stocker', 'D004', 'Adam', '42', '121312345678', 50000, '2020-01-01'),
('E00001', 'Store assistant', 'D001', 'Ben', '41', '13123344688', 40000, '2021-01-01'),
('E00002', 'Store assistant', 'D001', 'Peter', NULL, NULL, 40000, '2022-01-01');

INSERT shop_order VALUES
('O00000', 'C00000', 'In progress', 'E00000'),
('O00001', 'C00001', 'In progress', 'E00001'),
('O00002', 'C00002', 'In progress', 'E00002'),
('O00003', 'C00000', 'In progress', 'E00000');

INSERT product VALUES
('P00000', 'Apple', 10, 100),
('P00001', 'Banana', 20, 200),
('P00002', 'Orange', 30, 300);

INSERT purchase VALUES
('O00000', 'P00000', 10, 100),
('O00001', 'P00001', 20, 400),
('O00002', 'P00002', 30, 900),
('O00003', 'P00002', 30, 900);

-- 5.2 Use SQL SELECT * FROM table to list instances of all tables and views.
SELECT * FROM customer;
SELECT * FROM department;
SELECT * FROM job_function;
SELECT * FROM employee;
SELECT * FROM shop_order;

SELECT * FROM product;
SELECT * FROM purchase;

SELECT * FROM customer_view;
SELECT * FROM employee_view;
SELECT * FROM shop_order_view;
SELECT * FROM stockers;