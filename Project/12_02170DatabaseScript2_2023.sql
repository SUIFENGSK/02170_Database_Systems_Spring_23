-- 6. SQL Data Queries
-- Give at least 3 examples of typical select SQL statements with order by, group by and joins etc. 

-- order by statement
SELECT * FROM employee ORDER BY salary DESC;
SELECT * FROM product ORDER BY price DESC;

-- group by statement
SELECT job_title, count(*) FROM employee GROUP BY job_title;

-- Join statements
SELECT job_title, name FROM job_function NATURAL JOIN employee GROUP BY name;

SELECT  orderID,prodID, prod_name, customerID FROM purchase NATURAL JOIN shop_order
NATURAL JOIN product ORDER by prod_name;

-- 7. SQL Programming
-- Give examples of functions, procedures and triggers and explain what they do. Give one example of each.
Delimiter //
create function CustomerOrderCount(vCustomerID varchar(6)) returns INT
begin
    DECLARE vCustomerOrderCount INT;
    Select count(*) into vCustomerOrderCount from shop_order where customerID = vCustomerID;
    return vCustomerOrderCount;
end //
Delimiter ;

-- Example
select customerID, CustomerOrderCount(customerID) from customer;

drop procedure if exists GetOrderedProducts;

Delimiter //
create procedure GetOrderedProducts(in vCustomerID varchar(6))
begin    
    Select P.prodID, prod_name, quantity from shop_order as SO 
    join purchase as P on SO.orderID = P.orderID 
    join product as PR on PR.prodID = P.ProdID
    where customerID = vCustomerID;
end //
Delimiter ;

-- Example
call GetOrderedProducts('C00000');

drop procedure if exists AddPurchaseToOrder;

Delimiter //
create procedure AddPurchaseToOrder(in vorderID varchar(6), in vproductID varchar(6), in vquantity int)
begin
    DECLARE oldStock int DEFAULT NULL;
    DECLARE pPrice int DEFAULT NULL;
    -- find stock and price
    select stock, price into oldStock, pPrice from product where prodID = vproductID;
    -- if stock is okay update stock and add purchase
    if(oldStock >= vquantity)
    THEN 
        update product set stock = (oldStock - vquantity) where prodID = vproductID;
        if(exists (select * from purchase where orderID = vorderID and prodID = vproductID))
        then
			update purchase set quantity = quantity + vquantity where orderID = vorderID and prodID = vproductID;
        else
			insert purchase values (vorderID, vproductID, vquantity, pPrice);
        end if;
    end if;
end//
delimiter ;

-- Examples
call AddPurchaseToOrder('O00000', 'P00001', 5); -- add row
call AddPurchaseToOrder('O00000', 'P00001', 5); -- update row exists
call AddPurchaseToOrder('O00000', 'P00001', 500); -- not in stock


-- Trigger that checks that a customers password is at least 6 charectes long -
DELIMITER //
create trigger customer_before_insert
    before insert on customer
for each row
begin
    if length(new.password) < 6
    then
        signal sqlstate '70002'
            SET MESSAGE_TEXT = 'Password must be at least 6 charectes long!';
    end if;
end//
DELIMITER ;

-- Example --
INSERT customer VALUES ('C00003', 'Simon', '45', '61799900', '123', 'Oakstorm road 34'); -- Not inserted --
INSERT customer VALUES ('C00003', 'Simon', '45', '61799900', 'password', 'Oakstorm road 34'); -- Inserted --


-- Trigger that checks that before adding an employee, their salary is within the range of the job_function --
DELIMITER //
create trigger employee_before_insert
    before insert on employee
for each row
begin
	declare mins int default null;
    declare maxs int default null;
    select min_salary, max_salary into mins, maxs from job_function where job_title = new.job_title; 
    if (mins > new.salary) || (new.salary > maxs)
    then
        signal sqlstate '70002'
            SET MESSAGE_TEXT = 'Employee salary is not in the job function salary range!';
    end if;
end//
DELIMITER ;

-- Example --
INSERT employee VALUES ('E00011', 'Stocker', 'D004', 'Steve', '45', '231617645654', 40000, '2022-07-02'); -- Not inserted --
INSERT employee VALUES ('E00011', 'Stocker', 'D004', 'Steve', '45', '231617645654', 72000, '2022-07-02'); -- Not inserted --
INSERT employee VALUES ('E00011', 'Stocker', 'D004', 'Steve', '45', '231617645654', 55000, '2022-07-02'); -- Inserted --


-- 8. SQL Table Modifications
-- Give examples of a SQL table update statement and a delete statement.

-- update statement
SET SQL_SAFE_UPDATES = 0;

UPDATE employee SET salary = 100000 WHERE employeeID = 'E00000';
SELECT * FROM employee WHERE employeeID = 'E00000';

UPDATE product SET price = CASE 
						   WHEN price < 100
                           THEN price * 1.03
                           ELSE price * 1.01
                           END;
SELECT * FROM product;

-- delete statement
-- Delete customer with ID C00001, show effect on customer and shop_order tables
DELETE FROM customer WHERE customerID = 'C00001';
SELECT * FROM customer;
SELECT * FROM shop_order;
