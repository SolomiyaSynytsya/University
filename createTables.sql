create database University
go
create table dbo.Faculty
(
	Id int identity(1,1),
	Name varchar(50)
	primary key(Id)
) 
go
create table dbo.Speciality
(
	Id int Identity(1,1),
	Name varchar(50),
	FacultyId int,
	primary key(Id),
	foreign key(FacultyId) references Faculty
)
create table dbo.[Group] 
(
	Id int Identity(1,1),
	Name varchar(10),
	SpecialityId int,
	primary key(Id),
	foreign key(SpecialityId) references Speciality(Id)
)
create table dbo.Student
(
	Id int Identity(1,1),
	Name varchar(30),
	Surname varchar(30),
	GroupId int,
	primary key(Id),
	foreign key(GroupId) references [Group](Id)
) 
go
create table dbo.Teacher
(
	Id int Identity(1,1),
	Name varchar(30),
	Surname varchar(30),
	primary key(Id)
)
go
create table dbo.Subject
(
	Id int Identity(1,1),
	Name varchar(30),
	primary key(Id)
)
go
create table dbo.RelGroupSubject
(
	Id int Identity(1,1),
	GroupId int,
	SubId int,
	primary key(Id),
	foreign key(GroupId) references [Group](Id),
	foreign key(SubId) references Subject(Id)
)
go
create table dbo.RelSubTeacher
(
	Id int Identity(1,1),
	SubId int,
	TeacherId int,
	primary key(Id),
	foreign key(SubId) references Subject(Id),
	foreign key(TeacherId) references Teacher(Id) 	
)
go
create table dbo.MarkData
(
	Id int Identity(1,1),
	StudentId int,
	Mark tinyint,
	primary key(Id),
	foreign key(StudentId) references Student(Id)
)
GO
create procedure Filltable
as
BEGIN
	
END