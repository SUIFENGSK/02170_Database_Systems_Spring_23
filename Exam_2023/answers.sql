-- Please fill out the following mandatory information:
-- Student number: s214919

-------------------------------------------------------------------------------------------------------
-- Answer to question 1: 
-------------------------------------------------------------------------------------------------------
SELECT flightID FROM Flight JOIN Airport ON toAirport = airportID WHERE city = 'Milano';
-- flightID
-- AirDK322
-- AirDK700
-- AirDK820

-------------------------------------------------------------------------------------------------------
-- Answer to question 2:
-------------------------------------------------------------------------------------------------------
SELECT flightID FROM FlightPassengers GROUP BY flightID HAVING MAX(price)<1200;
-- flightID
-- AirDK450
-- AirDK700

-------------------------------------------------------------------------------------------------------
-- Answer to question 3:
-------------------------------------------------------------------------------------------------------
(SELECT DISTINCT CNO FROM Customer NATURAL JOIN FlightPassengers NATURAL JOIN Flight WHERE toAirport<>'CPH') EXCEPT
(SELECT CNO FROM Customer NATURAL JOIN FlightPassengers NATURAL JOIN Flight WHERE toAirport='CPH');
-- CNO
-- C2
-- C3

-------------------------------------------------------------------------------------------------------
-- Answer to question 4:
-------------------------------------------------------------------------------------------------------
DROP VIEW IF EXISTS A;
CREATE VIEW A AS
SELECT flightID, capacity FROM Flight NATURAL JOIN Plane WHERE fromAirport='CPH';

DROP VIEW IF EXISTS B;
CREATE VIEW B AS
SELECT flightID, Count(*) AS NUM FROM FlightPassengers GROUP BY flightID;

SELECT A.flightID, A.Capacity-B.NUM AS freeSeats FROM A NATURAL LEFT OUTER JOIN B WHERE A.Capacity-B.NUM is NOT NULL 
UNION
SELECT flightID, capacity FROM Flight NATURAL JOIN Plane WHERE fromAirport='CPH' AND flightID 
IN (SELECT A.flightID FROM A NATURAL LEFT OUTER JOIN B WHERE A.Capacity-B.NUM is NULL);

-- flightID	freeSeats
-- AirDK500	-1
-- AirDK322	248
-- AirDK820	250

-- Comments: I hope it is ok that I first created two views, and then made a query on these two views.
-- VIEW A includes the planes go from the CPH airport and have got a plane allocated
-- and VIEW B includes the total passengers for each plane. 
-- The following shows the output for these two views:

-- [VIEW A] SELECT * FROM A;
-- flightID	capacity
-- AirDK322	250
-- AirDK500	2
-- AirDK820	250

-- [VIEW B] SELECT * FROM B;
-- flightID	NUM
-- AirDK322	2
-- AirDK450	1
-- AirDK500	3
-- AirDK700	1

-------------------------------------------------------------------------------------------------------
-- Answer to question 5:
-------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS Flight_Before_Insert;
DELIMITER //
CREATE TRIGGER Flight_Before_Insert
BEFORE INSERT ON Flight FOR EACH ROW
BEGIN
 IF NEW.fromAirport = NEW.toAirport
 THEN SIGNAL SQLSTATE 'HY000'
 SET MYSQL_ERRNO=1525, MESSAGE_TEXT='Invalid fromAirport and toAirport.';
 END IF;
END //
DELIMITER ;

INSERT Flight VALUES ('AirDK999', '2023-05-01', '10:30:00', '02:00:00', 'CPH', 'CPH', 2);
-- Error Code: 1525. Invalid fromAirport and toAirport

INSERT Flight VALUES ('AirDK998', '2023-05-01', '10:30:00', '02:00:00', 'CPH', 'LIN', 2);
-- Inserted OK