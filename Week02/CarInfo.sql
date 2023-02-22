DROP DATABASE IF EXISTS CarInfo;
CREATE DATABASE CarInfo;
USE CarInfo;
-- 2.28
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Car;
DROP TABLE IF EXISTS Accident;
DROP TABLE IF EXISTS Owns;
DROP TABLE IF EXISTS Participants;

CREATE TABLE Person
	(DriverID		VARCHAR(8),
	 DriverName		VARCHAR(20) NOT NULL, 
	 Address		VARCHAR(100),
	 PRIMARY KEY(DriverID)
	);

CREATE TABLE Car
	(License		VARCHAR(7),
	 Model		    VARCHAR(50) NOT NULL, 
	 ProdYear		YEAR,
	 PRIMARY KEY(License)
	);

CREATE TABLE Accident
	(ReportNumber	VARCHAR(10),
	 AccDate		DATE, 
	 Location		VARCHAR(20),
	 PRIMARY KEY(ReportNumber)
	);

CREATE TABLE Owns
	(DriverID		VARCHAR(8),
	 License		VARCHAR(7),
	 PRIMARY KEY(DriverID,License),
     FOREIGN KEY(DriverID) REFERENCES Person(DriverID) ON DELETE CASCADE,
	 FOREIGN KEY(License) REFERENCES Car(License) ON DELETE CASCADE
	);

CREATE TABLE Participants
	(ReportNumber	VARCHAR(10),
	 License		VARCHAR(7),
     DriverID		VARCHAR(8),
     DamageAmount   DECIMAL(10,0),
	 PRIMARY KEY(ReportNumber,License),
     FOREIGN KEY(ReportNumber) REFERENCES Accident(ReportNumber) ON DELETE CASCADE,
     FOREIGN KEY(License) REFERENCES Car(License) ON DELETE CASCADE,
     FOREIGN KEY(DriverID) REFERENCES Person(DriverID) ON DELETE SET NULL
	);

-- 2.29
INSERT Person VALUES ('31262549','Hans Hansen','Jernbane Alle 74, 2720 Vanløse');
SELECT * FROM Person;

INSERT Car VALUES ('JW46898','Honda Accord Aut. 2.0','2001');
SELECT * FROM Car;

INSERT Accident VALUES ('3004000121','2015-06-18','2605 Brøndby');
SELECT * FROM Accident;

INSERT Owns VALUES ('31262549','JW46898');
SELECT * FROM Owns;

INSERT Participants VALUES ('3004000121','JW46898','31262549',6800);
SELECT * FROM Participants;