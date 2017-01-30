--set @rnd = (SELECT FLOOR(RAND()*(@b-@a)+@a))
use [master]
create database University
go

use [University]

alter table Faculty 
add constraint DF_Faculty Default Getdate() for ModifiedDate;
alter table Speciality 
add constraint DF_Speciality Default Getdate() for ModifiedDate;
alter table [Group] 
add constraint DF_Group Default Getdate() for ModifiedDate;
alter table Student
add constraint DF_Student Default Getdate() for ModifiedDate;
alter table Teacher
add constraint DF_Teacher Default Getdate() for ModifiedDate;
alter table Subject
add constraint DF_Subject Default Getdate() for ModifiedDate;
alter table GroupToSubject
add constraint DF_GroupToSubject Default Getdate() for ModifiedDate;
alter table SubjectToTeacher
add constraint DF_SubjectToTeacher Default Getdate() for ModifiedDate;    
go

create table dbo.Faculty
(
	Id int identity(1,1),
	Name varchar(50),
	CreatedDate date,
	ModifiedDate date,
	constraint PK_Faculty primary key(Id)
) 
go
create table dbo.Speciality
(
	Id int Identity(1,1),
	Name varchar(50),
	FacultyId int,
	CreatedDate date,
	ModifiedDate date,
	constraint PK_Spaciality primary key(Id),
	constraint FK_SpecialityRefFaculty foreign key(FacultyId) references Faculty
)
go
create table dbo.[Group] 
(
	Id int Identity(1,1),
	Name varchar(10),
	SpecialityId int,
	CreatedDate date,
	ModifiedDate date,
	constraint PK_Group primary key(Id),
	constraint FK_GroupRefSpeciality foreign key(SpecialityId) references Speciality(Id)
)
go
create table dbo.Student
(
	Id int Identity(1,1),
	Name varchar(30),
	MiddleName varchar(30),
	Surname varchar(30),
	GroupId int,
	CreatedDate date,
	ModifiedDate date,
	constraint PK_Student primary key(Id),
	constraint FK_StudentRefGroup foreign key(GroupId) references [Group](Id)
) 
go
create table dbo.Teacher
(
	Id int Identity(1,1),
	Name varchar(30),
	MiddleName varchar(30),
	Surname varchar(30),
	Salary float,
	CreatedDate date,
	ModifiedDate date,
	constraint PK_Teacher primary key(Id)
)
go
create table dbo.Subject
(
	Id int Identity(1,1),
	Name varchar(30),
	CreatedDate date,
	ModifiedDate date,	
	constraint PK_Subject primary key(Id)
)
go
create table dbo.GroupToSubject
(
	Id int Identity(1,1),
	GroupId int,
	SubId int,
	CreatedDate date,
	ModifiedDate date,	
	constraint PK_GroupToSubject primary key(Id),
	constraint FK_GroupToSubjectRefGroup foreign key(GroupId) references [Group](Id),
	constraint FK_GroupToSubjectRefSubject foreign key(SubId) references Subject(Id)
)
go
create table dbo.SubjectToTeacher
(
	Id int Identity(1,1),
	SubId int,
	TeacherId int,
	CreatedDate date,
	ModifiedDate date,	
	constraint PK_SubjectToTeacher primary key(Id),
	constraint FK_SubjectToTeacherRefSubject foreign key(SubId) references Subject(Id),
	constraint FK_SubjectToTeacherRefTeacher foreign key(TeacherId) references Teacher(Id) 	
)
go
create table dbo.MarkData
(
	Id int Identity(1,1),
	StudentId int,
	GroupToSubjectId int,
	Mark tinyint,
	CreatedDate date,
	constraint PK_MarkData primary key(Id),
	constraint FK_MarkDataRefStudent foreign key(StudentId) references Student(Id),
	constraint FK_MarkDataRefSubject foreign key(GroupToSubjectId) references dbo.GroupToSubject(Id)
)
go
