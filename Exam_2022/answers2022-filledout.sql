-- Please fill out the following mandatory information:
-- Student number: s......

-------------------------------------------------------------------------------------------------------
-- Answer to question 1: 
-------------------------------------------------------------------------------------------------------
select catId, catName, max(unitPrice)
from FoodCategory natural left join FoodItem 
group by catId;

-- Output:

-- catId	catName	    max(unitPrice)
-- -----------------------------------
-- bev	    Beverages	null
-- fish	    Fish dishes	65
-- meat	    Meat dishes	100
-- start    Starters	45


-------------------------------------------------------------------------------------------------------
-- Answer to question 2:
-------------------------------------------------------------------------------------------------------

select itemId, description from foodItem 
where itemId not in (select itemId from orderline);

-- Output:
--	itemId	description
--  ------------------------
--	bburg	Big Burger

-------------------------------------------------------------------------------------------------------
-- Answer to question 3:
-------------------------------------------------------------------------------------------------------


CREATE FUNCTION
total_cost_for_customer(v_custNo int) RETURNS int
RETURN 
  (select sum(unitPrice * quantity) 
  from FoodOrder natural join Orderline 
  where custNo = v_custNo);



-- -----------------------------------------------------------------------------------------------------
-- Answer to question 4:
-- -----------------------------------------------------------------------------------------------------

select custNo, total_cost_for_customer(custNo) from Customer;
 
-- Output: 
 
-- 	custNo	total_cost_for_customer(custNo)
-- ------------------------------------------
--	1	    680
--	2	    null
--	7	    225


-------------------------------------------------------------------------------------------------------
-- Answer to question 5:
-------------------------------------------------------------------------------------------------------

select catId, catName, count(*)
from foodCategory natural join foodItem
group by catId
having count(*) > 1;

--	catId	catName	    count(*)
-- -----------------------------
--	meat	Meat dishes	2
