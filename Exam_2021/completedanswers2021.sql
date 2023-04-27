-- Please fill out the following mandatory information:
-- Student name: Lucky Luck
-- Student id: s850876

-------------------------------------------------------------------------------------------------------
-- Answer to question 1: 
-------------------------------------------------------------------------------------------------------

select diseaseName from disease 
where diseaseType = 'infectious';

-- +-------------+
-- | diseaseName |
-- +-------------+
-- | Covid19     |
-- | influenza   |
-- +-------------+

-------------------------------------------------------------------------------------------------------
-- Answer to question 2:
-------------------------------------------------------------------------------------------------------

select diseasename, count(doctorId) 
from disease left join doctor 
on doctor.specialty = disease.diseaseName
group by diseaseName;

-- +-------------+-----------------+
-- | diseaseName | count(doctorId) |
-- +-------------+-----------------+
-- | cancer      |               1 |
-- | Covid19     |               2 |
-- | influenza   |               0 |
-- | stroke      |               1 |
-- +-------------+-----------------+

-------------------------------------------------------------------------------------------------------
-- Answer to question 3:
-------------------------------------------------------------------------------------------------------

create function numberOfPatientsInRoom(vroomNo smallint) returns int
   return (select count(patientId) from patient where roomNo = vroomNo); 


-------------------------------------------------------------------------------------------------------
-- Answer to question 4:
-------------------------------------------------------------------------------------------------------

select roomNo, numberOfPatientsInRoom(roomNo) from room; 

-- +---------+--------------------------------+
-- |  roomNo | numberOfPatientsInRoom(roomNo) |
-- +---------+--------------------------------+
-- |      11 |                              1 |
-- |      12 |                              2 |
-- |      13 |                              0 |
-- +---------+--------------------------------+


-------------------------------------------------------------------------------------------------------
-- Answer to question 5:
-------------------------------------------------------------------------------------------------------

(select * from suffers) EXCEPT (select patientId, specialty from doctor natural join treats);

-- +-----------+-------------+
-- | patientId | diseaseName |
-- +-----------+-------------+
-- | p1        | cancer      |
-- | p2        | stroke      |
-- +-----------+-------------+ 
