-- Please fill out the following mandatory information:
-- Student name: Shuokai Ma
-- Student id: s214919

-------------------------------------------------------------------------------------------------------
-- Answer to question 1: 
-------------------------------------------------------------------------------------------------------
SELECT * FROM disease WHERE disease.diseaseType='infectious';
-- diseaseName
-- Covid 19
-- influenza 

-------------------------------------------------------------------------------------------------------
-- Answer to question 2:
-------------------------------------------------------------------------------------------------------
-- SELECT diseaseName, COUNT(specialty) AS doctorNum FROM disease, doctor WHERE disease.diseaseName=doctor.specialty GROUP BY diseaseName;
SELECT disease.diseaseName, COUNT(doctor.specialty) AS doctorNum 
FROM disease 
LEFT JOIN doctor ON disease.diseaseName = doctor.specialty 
GROUP BY disease.diseaseName;
-- diseaseName | doctorNum
-- cancer      | 1
-- Covid 19    | 2
-- influenza   | 0
-- stroke      | 1

-------------------------------------------------------------------------------------------------------
-- Answer to question 3:
-------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS NumberOfPatientsInRoom;
DELIMITER //
CREATE FUNCTION NumberOfPatientsInRoom(roomNum SMALLINT) RETURNS INT
BEGIN
   DECLARE patientNumCount INT;
   SELECT COUNT(roomNo) INTO patientNumCount FROM patient WHERE roomNum=patient.roomNo;
   RETURN patientNumCount;
END//
DELIMITER ;

-------------------------------------------------------------------------------------------------------
-- Answer to question 4:
-------------------------------------------------------------------------------------------------------
SELECT roomNO, NumberOfPatientsInRoom(roomNO) AS patientNum FROM room;
-- roomNO | patientNum
-- 11     | 1
-- 12     | 2
-- 13     | 0

-------------------------------------------------------------------------------------------------------
-- Answer to question 5:
-------------------------------------------------------------------------------------------------------

(select * from suffers) EXCEPT (select patientId, specialty from doctor natural join treats);
-- patientID | diseaseName
-- p1        | cancer
-- p2        | stroke