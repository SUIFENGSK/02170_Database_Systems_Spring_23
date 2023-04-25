-- foreign key constraints have intentionally been omitted here - they must be added 
create database if not exists Hospital;
USE Hospital;


drop table if exists suffers;
drop table if exists treats;
drop table if exists patient;
drop table if exists room;
drop table if exists doctor;
drop table if exists disease;

create table disease (
   diseaseName varchar(30) primary key,
   diseaseType enum('infectious','non-infectious') 
);

create table doctor (
   doctorId varchar(5) primary key,
   doctorName varchar(30) not null,
   specialty varchar(30) -- a diseaseName
);

create table room (
   roomNo smallint primary key,
   capacity smallint
);

create table patient (
   patientId varchar(5) primary key,
   patientName varchar(30) not null,
   roomNo smallint
);

create table suffers(
   patientId varchar(5),
   diseaseName varchar(30) not null,
   primary key(patientId, diseaseName) 
);
  
create table treats(
   doctorId varchar(5),
   patientId varchar(5),
   primary key(doctorId, patientId)
);  
 
insert into disease(diseaseName, diseaseType) 
values ('Covid19', 'infectious'), ('influenza','infectious'), ('cancer','non-infectious'), ('stroke', 'non-infectious');

insert into doctor(doctorId, doctorName, specialty)
values ('d1','Anne Pedersen', 'Covid19'), ('d2', 'Van Andersen', 'Covid19'), ('d3', 'Per Schmidt', 'stroke'), ('d4', 'Flemming Taylor', 'cancer');

insert into room(roomNo, capacity)
values (11, 2), (12, 2), (13, 3);   

insert into patient(patientId, patientName, roomNo)
values ('p1','Peter Lund', 11), ('p2','Helen Brown', 12), ('p3', 'Mary Jones', 12), ('p4', 'Simon Johnson', null);

insert into suffers(patientId, diseaseName)
values ('p1', 'Covid19'), ('p1', 'cancer'), ('p2', 'stroke'), ('p3', 'Covid19'), ('p3', 'cancer');

insert into treats(doctorId, patientId)
values ('d1', 'p1'), ('d1','p3'), ('d4', 'p3');

select * from disease;
select * from doctor;
select * from room;
select * from patient;
select * from suffers;
select * from treats;