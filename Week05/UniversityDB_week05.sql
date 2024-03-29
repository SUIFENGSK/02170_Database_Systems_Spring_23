/* The University Database from the textbook "Database System Concepts" by 
A. Silberschatz, H.F. Korth and S. Sudarshan, McGraw-Hill International Edition, 
Sixth Edition, 2011.*/

/* UniversityDB.sql is a script for creating tables for the University database of the book 
   and populating them with data */

# Names of tables and attributes are changed slightly to improve the naming standard!

# If the tables already exists, then they are deleted!

DROP DATABASE IF EXISTS University;
CREATE DATABASE University;
USE University; 
DROP TABLE IF EXISTS PreReq;
DROP TABLE IF EXISTS TimeSlot;
DROP TABLE IF EXISTS Advisor;
DROP TABLE IF EXISTS Takes;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Teaches;
DROP TABLE IF EXISTS Section;
DROP TABLE IF EXISTS Instructor;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Classroom;

# Table creation! Create Tables with Foreign Keys after the referenced tables are created!

CREATE TABLE Classroom
	(Building		VARCHAR(15),
	 Room			VARCHAR(7),
	 Capacity		DECIMAL(4,0),
	 PRIMARY KEY(Building, Room)
	);

CREATE TABLE Department
	(DeptName		VARCHAR(20), 
	 Building		VARCHAR(15), 
	 Budget		    DECIMAL(12,2),
	 PRIMARY KEY(DeptName)
	);

CREATE TABLE Course
	(CourseID		VARCHAR(8), 
	 Title			VARCHAR(50), 
	 DeptName		VARCHAR(20),
	 Credits		DECIMAL(2,0),
	 PRIMARY KEY(CourseID),
	  FOREIGN KEY(DeptName) REFERENCES Department(DeptName) ON DELETE SET NULL
	);

CREATE TABLE Instructor
	(InstID			VARCHAR(5), 
	 InstName		VARCHAR(20) NOT NULL, 
	 DeptName		VARCHAR(20), 
	 Salary			DECIMAL(8,2),
	 PRIMARY KEY (InstID),
	 FOREIGN KEY(DeptName) REFERENCES Department(DeptName) ON DELETE SET NULL
	);

CREATE TABLE Section
	(CourseID		VARCHAR(8), 
     SectionID		VARCHAR(8),
	 Semester		ENUM('Fall','Winter','Spring','Summer'), 
	 StudyYear		YEAR, 
	 Building		VARCHAR(15),
	 Room			VARCHAR(7),
	 TimeSlotID		VARCHAR(4),
	 PRIMARY KEY(CourseID, SectionID, Semester, StudyYear),
	 FOREIGN KEY(CourseID) REFERENCES Course(CourseID)
		ON DELETE CASCADE,
	 FOREIGN KEY(Building, Room) REFERENCES Classroom(Building, Room) ON DELETE SET NULL
	);

CREATE TABLE Teaches
	(InstID			VARCHAR(5), 
	 CourseID		VARCHAR(8),
	 SectionID		VARCHAR(8), 
	 Semester		ENUM('Fall','Winter','Spring','Summer'),
	 StudyYear		YEAR,
	 PRIMARY KEY(InstID, CourseID, SectionID, Semester, StudyYear),
	 FOREIGN KEY(CourseID, SectionID, Semester, StudyYear) REFERENCES Section(CourseID, SectionID, Semester, StudyYear) 
     ON DELETE CASCADE,
	 FOREIGN KEY(InstID) REFERENCES Instructor(InstID) ON DELETE CASCADE
	);

CREATE TABLE Student
	(StudID			VARCHAR(5), 
	 StudName		VARCHAR(20) NOT NULL, 
	 Birth 			DATE,
	 DeptName		VARCHAR(20),
     TotCredits		DECIMAL(3,0),
	 PRIMARY KEY(StudID),
	 FOREIGN KEY(DeptName) REFERENCES Department(DeptName) ON DELETE SET NULL
	);

CREATE TABLE Takes
	(StudID			VARCHAR(5), 
	 CourseID		VARCHAR(8),
	 SectionID		VARCHAR(8), 
	 Semester		ENUM('Fall','Winter','Spring','Summer'),
	 StudyYear		YEAR,
	 Grade		    VARCHAR(2),
	 PRIMARY KEY(StudID, CourseID, SectionID, Semester, StudyYear),
	 FOREIGN KEY(CourseID, SectionID, Semester, StudyYear) REFERENCES Section(CourseID, SectionID, Semester, StudyYear) 
		ON DELETE CASCADE,
	 FOREIGN KEY(StudID) REFERENCES Student(StudID) ON DELETE CASCADE
	);

CREATE TABLE Advisor
	(StudID			VARCHAR(5),
	 InstID			VARCHAR(5),
	 PRIMARY KEY(StudID),
	 FOREIGN KEY(InstID) REFERENCES Instructor(InstID) ON DELETE SET NULL,
	 FOREIGN KEY(StudID) REFERENCES Student(StudID) ON DELETE CASCADE
	);

CREATE TABLE TimeSlot
	(TimeSlotID 	VARCHAR(4),
	 DayCode		ENUM('M','T','W','R','F','S','U'),
	 StartTime		TIME,
	 EndTime		TIME,
	 PRIMARY KEY(TimeSlotID, DayCode, StartTime)
	);

CREATE TABLE PreReq
	(CourseID		VARCHAR(8), 
	 PreReqID		VARCHAR(8),
	 PRIMARY KEY(CourseID, PreReqID),
	 FOREIGN KEY(CourseID) REFERENCES Course(CourseID) ON DELETE CASCADE,
	 FOREIGN KEY(PreReqID) REFERENCES Course(CourseID)
);


# Insertion of table rows one by one!

INSERT Classroom VALUES('Packard','101','500');
INSERT Classroom VALUES('Painter','514','10');
INSERT Classroom VALUES('Taylor','3128','70');
INSERT Classroom VALUES('Watson','100','30');
INSERT Classroom VALUES('Watson','120','50');

# Insertion of multiple table rows in one go!

INSERT Department VALUES
('Biology','Watson','90000'),
('Comp. Sci.','Taylor','100000'),
('Elec. Eng.','Taylor','85000'),
('Finance','Painter','120000'),
('History','Painter','50000'),
('Music','Packard','80000'),
('Physics','Watson','70000');

INSERT Course VALUES
('BIO-101','Intro. to Biology','Biology','4'),
('BIO-301','Genetics','Biology','4'),
('BIO-399','Computational Biology','Biology','3'),
('CS-101','Intro. to Computer Science','Comp. Sci.','4'),
('CS-190','Game Design','Comp. Sci.','4'),
('CS-315','Robotics','Comp. Sci.','3'),
('CS-319','Image Processing','Comp. Sci.','3'),
('CS-347','Database System Concepts','Comp. Sci.','3'),
('EE-181','Intro. to Digital Systems','Elec. Eng.','3'),
('FIN-201','Investment Banking','Finance','3'),
('HIS-351','World History','History','3'),
('MU-199','Music Video Production','Music','3'),
('PHY-101','Physical Principles','Physics','4');

INSERT Instructor VALUES
('10101','Srinivasan','Comp. Sci.','65000'),
('12121','Wu','Finance','90000'),
('15151','Mozart','Music','40000'),
('22222','Einstein','Physics','95000'),
('32343','El Said','History','60000'),
('33456','Gold','Physics','87000'),
('45565','Katz','Comp. Sci.','75000'),
('58583','Califieri','History','62000'),
('76543','Singh','Finance','80000'),
('76766','Crick','Biology','72000'),
('83821','Brandt','Comp. Sci.','92000'),
('98345','Kim','Elec. Eng.','80000');

INSERT Section VALUES
('BIO-101','1','Summer','2009','Painter','514','B'),
('BIO-301','1','Summer','2010','Painter','514','A'),
('CS-101','1','Fall','2009','Packard','101','H'),
('CS-101','1','Spring','2010','Packard','101','F'),
('CS-190','1','Spring','2009','Taylor','3128','E'),
('CS-190','2','Spring','2009','Taylor','3128','A'),
('CS-315','1','Spring','2010','Watson','120','D'),
('CS-319','1','Spring','2010','Watson','100','B'),
('CS-319','2','Spring','2010','Taylor','3128','C'),
('CS-347','1','Fall','2009','Taylor','3128','A'),
('EE-181','1','Spring','2009','Taylor','3128','C'),
('FIN-201','1','Spring','2010','Packard','101','B'),
('HIS-351','1','Spring','2010','Painter','514','C'),
('MU-199','1','Spring','2010','Packard','101','D'),
('PHY-101','1','Fall','2009','Watson','100','A');

INSERT Teaches VALUES
('10101','CS-101','1','Fall','2009'),
('10101','CS-315','1','Spring','2010'),
('10101','CS-347','1','Fall','2009'),
('12121','FIN-201','1','Spring','2010'),
('15151','MU-199','1','Spring','2010'),
('22222','PHY-101','1','Fall','2009'),
('32343','HIS-351','1','Spring','2010'),
('45565','CS-101','1','Spring','2010'),
('45565','CS-319','1','Spring','2010'),
('76766','BIO-101','1','Summer','2009'),
('76766','BIO-301','1','Summer','2010'),
('83821','CS-190','1','Spring','2009'),
('83821','CS-190','2','Spring','2009'),
('83821','CS-319','2','Spring','2010'),
('98345','EE-181','1','Spring','2009');

INSERT Student VALUES
('00128','Zhang','1992-04-18','Comp. Sci.','102'),
('12345','Shankar','1995-12-06','Comp. Sci.','32'),
('19991','Brandt','1993-05-24','History','80'),
('23121','Chavez','1992-04-18','Finance','110'),
('44553','Peltier','1995-10-18','Physics','56'),
('45678','Levy','1995-08-01','Physics','46'),
('54321','Williams','1995-02-28','Comp. Sci.','54'),
('55739','Sanchez','1995-06-04','Music','38'),
('70557','Snow','1995-11-22','Physics','0'),
('76543','Brown','1994-03-05','Comp. Sci.','58'),
('76653','Aoi','1993-09-18','Elec. Eng.','60'),
('98765','Bourikas','1992-09-23','Elec. Eng.','98'),
('98988','Tanaka','1992-06-02','Biology','120');

INSERT Takes VALUES
('00128','CS-101','1','Fall','2009','A'),
('00128','CS-347','1','Fall','2009','A-'),
('12345','CS-101','1','Fall','2009','C'),
('12345','CS-190','2','Spring','2009','A'),
('12345','CS-315','1','Spring','2010','A'),
('12345','CS-347','1','Fall','2009','A'),
('19991','HIS-351','1','Spring','2010','B'),
('23121','FIN-201','1','Spring','2010','C+'),
('44553','PHY-101','1','Fall','2009','B-'),
('45678','CS-101','1','Fall','2009','F'),
('45678','CS-101','1','Spring','2010','B+'),
('45678','CS-319','1','Spring','2010','B'),
('54321','CS-101','1','Fall','2009','A-'),
('54321','CS-190','2','Spring','2009','B+'),
('55739','MU-199','1','Spring','2010','A-'),
('76543','CS-101','1','Fall','2009','A'),
('76543','CS-319','2','Spring','2010','A'),
('76653','EE-181','1','Spring','2009','C'),
('98765','CS-101','1','Fall','2009','C-'),
('98765','CS-315','1','Spring','2010','B'),
('98988','BIO-101','1','Summer','2009','A'),
('98988','BIO-301','1','Summer','2010', NULL);

INSERT Advisor VALUES
('00128','45565'),
('12345','10101'),
('23121','76543'),
('44553','22222'),
('45678','22222'),
('76543','45565'),
('76653','98345'),
('98765','98345'),
('98988','76766');

INSERT TimeSlot VALUES
('A','M','8:00','8:50'),
('A','W','8:00','8:50'),
('A','F','8:00','8:50'),
('B','M','9:00','9:50'),
('B','W','9:00','9:50'),
('B','F','9:00','9:50'),
('C','M','11:00','11:50'),
('C','W','11:00','11:50'),
('C','F','11:00','11:50'),
('D','M','13:00','13:50'),
('D','W','13:00','13:50'),
('D','F','13:00','13:50'),
('E','T','10:30','11:45'),
('E','R','10:30','11:45'),
('F','T','14:30','15:45'),
('F','R','14:30','15:45'),
('G','M','16:00','16:50'),
('G','W','16:00','16:50'),
('G','F','16:00','16:50'),
('H','W','10:00','12:30');

INSERT PreReq VALUES
('BIO-301','BIO-101'),
('BIO-399','BIO-101'),
('CS-190','CS-101'),
('CS-315','CS-101'),
('CS-319','CS-101'),
('CS-347','CS-101'),
('EE-181','PHY-101');

-- Exercise
-- 5.1.1
CREATE FUNCTION LeapYear ( vYear YEAR ) RETURNS BOOLEAN
RETURN (vYear % 4 = 0) AND ((vYear % 100 <> 0) OR (vYear % 400 =0));
SELECT LeapYear(1964);

CREATE FUNCTION Age (vDate DATE) RETURNS INTEGER
RETURN TIMESTAMPDIFF(YEAR, vDate , CURDATE());

SELECT StudID, StudName, Birth, Age(Birth) AS Age, LeapYear(YEAR(Birth)) AS LeapYear FROM Student;
-- 5.1.2
CREATE TABLE InstLog LIKE Instructor;
ALTER TABLE InstLog ADD LogTime TIMESTAMP(6);
DELIMITER //
CREATE TRIGGER Instructor_After_Insert
AFTER INSERT ON Instructor FOR EACH ROW
BEGIN INSERT InstLog VALUES (New.InstID,
                             New.InstName,
                             New.DeptName,
                             New.Salary,
                             NOW(6));
END//
DELIMITER ;
SELECT * FROM Instructor;
SELECT * FROM InstLog;
INSERT Instructor VALUES
('11001', 'Valdez', 'Comp. Sci.', 36000),
('11002', 'Koerver', 'Comp. Sci.', 36000);
SELECT * FROM Instructor;
SELECT * FROM InstLog;
-- 5.1.3
CREATE TABLE InstOld LIKE Instructor;
DELIMITER //
CREATE PROCEDURE InstBackup()
BEGIN
  DELETE FROM InstOld ; # see remark in left column
  INSERT INTO InstOld SELECT * FROM Instructor;
  DELETE FROM InstLog;
END //
DELIMITER ;
SELECT * FROM Instructor;
SELECT * FROM InstOld;
SELECT * FROM InstLog;
SET SQL_SAFE_UPDATES = 0;
CALL InstBackup;
SET SQL_SAFE_UPDATES = 1;
SELECT * FROM Instructor;
SELECT * FROM InstOld ;# contains the Instructor rows
SELECT * FROM InstLog ;# no rows
-- 5.1.4
DROP TABLE IF EXISTS InstOld; DROP TABLE IF EXISTS InstLog;
CREATE TABLE InstOld LIKE Instructor; CREATE TABLE InstLog LIKE Instructor;
ALTER TABLE InstLog ADD LogTime TIMESTAMP(6);
DELIMITER //
CREATE PROCEDURE InstBackup1()
BEGIN
  DECLARE vSQLSTATE CHAR(5) DEFAULT '00000 ';
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	# this handler statement below ensures that
	# if an exception is raised by SQL during the transaction
	# then vSQLSTATE will be assigned a value <> '00000‘
	# and continue
    BEGIN
      GET DIAGNOSTICS CONDITION 1
      vSQLSTATE = RETURNED_SQLSTATE;
	END;
   START TRANSACTION ;
   DELETE FROM InstOld ;
   INSERT INTO InstOld SELECT * FROM Instructor ;
   DELETE FROM InstLog ;
   -- SELECT vSQLSTATE ;
   IF vSQLSTATE = '00000' THEN COMMIT ;
     ELSE ROLLBACK ;
   END IF ;
END //
DELIMITER ;
# Test the procedure before and after “DROP TABLE InstLog
INSERT Instructor VALUES ('10000', 'Hansen', 'Comp. Sci.', 50000);
SELECT * FROM InstLog ;# contains the new row
SET SQL_SAFE_UPDATES = 0;
CALL InstBackup1; # SELECT vSQLSTATE returns 00000 and the transaction is committed
SELECT * FROM Instructor;
SELECT * FROM InstOld; #same as Instructor
SELECT * FROM InstLog ; #no rows
DROP TABLE InstLog ;
CALL InstBackup1;
-- 5.1.5
CREATE TABLE InstLog LIKE Instructor;
ALTER TABLE InstLog ADD LogTime TIMESTAMP(6);
CREATE
EVENT InstEvent
ON SCHEDULE EVERY 1 WEEK
STARTS '2016-02-21 00:00:01'
DO CALL InstBackup;
SET GLOBAL event_scheduler = 1;
SHOW VARIABLES LIKE 'event_scheduler';
-- 5.1.6
SET GLOBAL event_scheduler = 1;
CREATE TABLE DiceRolls (
RollNo INTEGER AUTO_INCREMENT PRIMARY KEY,
DiceEyes INTEGER);
CREATE EVENT RollDice
ON SCHEDULE EVERY 5 SECOND
DO
INSERT DiceRolls (DiceEyes) VALUES
(1+FLOOR(6*RAND()));
SELECT DISTINCT DiceEyes, Count(DiceEyes) FROM DiceRolls WHERE RollNo <= 10 GROUP BY DiceEyes;
#stop event after use
SET GLOBAL event_scheduler = 0;
-- 5.2.1
DELIMITER //
CREATE FUNCTION BuildingCapacityFct(buildingName VARCHAR(20)) RETURNS INT
BEGIN
  DECLARE sumCapacity INT;
  SELECT SUM(Capacity) INTO sumCapacity FROM Classroom WHERE Building = buildingName;
  RETURN sumCapacity;
END //
DELIMITER ;
SELECT DISTINCT Building, BuildingCapacityFct(Building) AS SumCapacity FROM Classroom;
DROP FUNCTION IF EXISTS BuildingCapacityFct;
-- 5.2.2
DROP PROCEDURE IF EXISTS InsertTimeSlot
DELIMITER //
CREATE PROCEDURE InsertTimeSlot (IN timeSlotID VARCHAR(10), IN dayCode VARCHAR(10), IN startTime TIME, IN endTime TIME, OUT vStatus VARCHAR(45))
BEGIN
  DECLARE timeSlotIDValid, dayCodeValid, timeValid Boolean DEFAULT TRUE;
  START TRANSACTION;
  SET SQL_SAFE_UPDATES = 0;
  
  IF LENGTH(timeSlotID) > 4 THEN 
    SET timeSlotIDValid = FALSE;
  END IF;
  
  IF dayCode NOT IN ('M', 'T', 'W', 'R', 'F', 'S', 'U') THEN 
    SET dayCodeValid = FALSE;
  END IF;
  
  IF startTime > endTime THEN 
    SET timeValid = FALSE;
  END IF;
   
  INSERT TimeSlot VALUES (timeSlotID,dayCode,startTime,endTime);
  
  IF timeSlotIDValid AND dayCodeValid AND timeValid THEN 
    SET vStatus = 'Transaction Transfer Committed!'; 
    COMMIT;
  ELSE 
    SET vStatus = 'Transaction Transfer Rollback!'; 
    ROLLBACK;
  END IF;
  
END //
DELIMITER ;
#Test
SELECT * FROM TimeSlot;
CALL InsertTimeSlot('A','T','8:00','8:50',@TStatus);
SELECT @TStatus;
SELECT * FROM TimeSlot;
-- 5.2.3
DELIMITER //
CREATE TRIGGER TimeSlot_Before_Insert BEFORE INSERT ON Timeslot FOR EACH ROW
BEGIN
 DECLARE timeSlotIDValid, dayCodeValid, timeValid Boolean DEFAULT TRUE;
  IF LENGTH(NEW.TimeSlotID) > 4 THEN 
    SET timeSlotIDValid = FALSE;
  END IF;
  
  IF NEW.DayCode NOT IN ('M', 'T', 'W', 'R', 'F', 'S', 'U') THEN 
    SET dayCodeValid = FALSE;
  END IF;
  
  IF NEW.StartTime > NEW.EndTime THEN 
    SET timeValid = FALSE;
  END IF;
  
  IF NOT timeSlotIDValid 
  THEN SIGNAL SQLSTATE 'HY000' 
  SET MYSQL_ERRNO = 1525, MESSAGE_TEXT = 'Invalid timeSlotID; No more than 4 characters';
  END IF;
  
  IF NOT dayCodeValid 
  THEN SIGNAL SQLSTATE 'HY000' 
  SET MYSQL_ERRNO = 1525, MESSAGE_TEXT = 'Invalid dayCodeValid; Only from {M,T,W,R,F,S,U}';
  END IF;
  
  IF NOT timeValid 
  THEN SIGNAL SQLSTATE 'HY000' 
  SET MYSQL_ERRNO = 1525, MESSAGE_TEXT = 'Invalid timeValid; startTime should be earlier than endTime';
  END IF;  
END //
DELIMITER ;
# Test
INSERT TimeSlot VALUES ('A','T','9:00','8:50');
SHOW WARNINGS;
-- 5.2.4
SET GLOBAL event_scheduler = 1;
CREATE TABLE
BallRolls (
RollNo INTEGER AUTO_INCREMENT PRIMARY KEY,
LuckyNo INTEGER);

CREATE EVENT RollBall
ON SCHEDULE EVERY 10 SECOND
DO
INSERT BallRolls (LuckyNo) VALUES (FLOOR(37*RAND()));
SELECT * FROM BallRolls;
SET GLOBAL event_scheduler = 0;