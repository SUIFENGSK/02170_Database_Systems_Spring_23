-- Please fill out the following mandatory information:
-- Student number: s214919

-------------------------------------------------------------------------------------------------------
-- Answer to question 1: 
-------------------------------------------------------------------------------------------------------
SELECT FoodCategory.catId, catName, MAX(unitPrice)
FROM FoodCategory NATURAL LEFT OUTER JOIN FoodItem GROUP BY catId;
-- catId	catName	    max(unitPrice)
-- bev	    Beverages	NULL
-- fish	    Fish dishes	65
-- meat	    Meat dishes	100
-- start	    Starters	  45

-------------------------------------------------------------------------------------------------------
-- Answer to question 2:
-------------------------------------------------------------------------------------------------------
SELECT FoodItem.itemId, description
FROM FoodItem
LEFT OUTER JOIN OrderLine
ON FoodItem.itemId = OrderLine.itemId
WHERE OrderLine.itemId IS NULL;

-- itemId	description
-- bburg	Big Burger

-------------------------------------------------------------------------------------------------------
-- Answer to question 3:
-------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS total_cost_for_customer;
DELIMITER //
CREATE FUNCTION total_cost_for_customer(custNo INT) RETURNS INT
BEGIN
   DECLARE totalCost INT;
   SELECT SUM(quantity*unitPrice) INTO totalCost FROM FoodOrder LEFT OUTER JOIN OrderLine ON FoodOrder.custNo=custNo AND FoodOrder.orderNo=OrderLine.orderNo;
   RETURN totalCost;
END//
DELIMITER ;

-------------------------------------------------------------------------------------------------------
-- Answer to question 4:
-------------------------------------------------------------------------------------------------------
SELECT custNo, total_cost_for_customer(custNo) FROM Customer;

-- custNo	total_cost_for_customer(custNo)
-- 1	    680
-- 2	    NULL
-- 7	    225

-------------------------------------------------------------------------------------------------------
-- Answer to question 5:
-------------------------------------------------------------------------------------------------------
SELECT catId, catName, COUNT(itemId) FROM FoodCategory NATURAL LEFT OUTER JOIN FoodItem GROUP BY catId HAVING COUNT(itemId)>1;

-- catId catName       numItems
-- meat	 Meat dishes   2