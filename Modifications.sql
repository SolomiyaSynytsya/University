create procedure usp_GetErrorInfo
as
    select 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() as ErrorState,
        ERROR_PROCEDURE() as ErrorProcedure,
        ERROR_LINE() as ErrorLine,
        ERROR_MESSAGE() as ErrorMessage;
go

--*****************  Inserting data  ******************************

--drop procedure AddStudentWithGroupId
create procedure AddStudentWithGroupId
	@Name varchar(30),  @Surname varchar(30)
	,@GroupId int, @MiddleName varchar(30)=null
as
begin
	insert into Student(name, MiddleName, Surname, GroupId) values
	(@Name, @MiddleName, @Surname,@GroupId)
end
go
SET STATISTICS TIME ON
--exec AddStudentWithGroupId 'Josdfgyhjkkkkkkkkkkkkkkkkkkkwefpoqg355555etbwrhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhnwrnywrnwn5555hn', 'Dilan', 1, 'Mikhel'  
go
SET STATISTICS TIME OFF
go

create procedure AddStudentWithGroupName
	@Name varchar(30),  @Surname varchar(30)
	,@GroupName varchar(30),@MiddleName varchar(30) = null
as
begin
	declare @GroupId int	
	set @GroupId = (select Id from [Group] g where g.Name = @GroupName)
	insert into Student(Name, MiddleName, Surname, GroupId) values
	(@Name, @MiddleName, @Surname,@GroupId)
end
go

create procedure AddFaculty 
	@Name varchar(50), @CreatedDate date
as
begin
	if not exists (select Name from Faculty where Name = @Name)
	insert into Faculty(Name, CreatedDate) values
	(@Name, @CreatedDate)
end
go

create procedure AddSpecialityWithFacultyId 
	@CreatedDate date, @Name varchar(50),  @FacultyId int 
as
begin
	insert into Speciality(Name, FacultyId, CreatedDate) values
	(@Name, @FacultyId, @CreatedDate)
end
go

create procedure AddSpecialityWithFacultyName
	@CreatedDate date, @Name varchar(50), @Facultyname varchar(50)
as
begin
	declare @FacultyId int
	set @FacultyId = (select Id from Faculty f where f.Name = @Name)
	insert into Speciality(Name, FacultyId, CreatedDate) values
	(@Name, @FacultyId, @Createddate)
end
go

create procedure AddGroupWithSpecialityId
	 @CreatedDate date, @Name varchar(10), @SpecialityId int
as
begin
	insert into [Group](Name, SpecialityId, CreatedDate) values
		(@Name, @SpecialityId, @CreatedDate)
end 
go

create procedure AddGroupWithSpecialityName
	 @CreatedDate date, @Name varchar(10),@SpecialityName varchar(50)
as
begin
	declare @SpecialityId int
	set @SpecialityId = (select Id from Speciality s where s.Name = @SpecialityName )
	insert into [Group](Name, SpecialityId, CreatedDate) values
		(@Name, @SpecialityId, @CreatedDate)
end
go

create procedure AddRelationGroupToSubjectWithId
	@CreatedDate date , @GroupId int, @SubId int
as
begin
	insert into GroupToSubject(GroupId, SubId, CreatedDate) values
		(@GroupId, @SubId, @CreatedDate)
end
go

create procedure AddRelationGroupToSubjectWithNames
	@CreatedDate date, @GroupName varchar(10), @SubName varchar(30)
as
begin
	declare @GroupId int, @SubId int
	set @GroupId = (select Id from [Group] g where g.Name = @GroupName)
	set @SubId = (select Id from Subject s where s.Name = @SubName)
	insert into GroupToSubject(GroupId, SubId, CreatedDate) values
		(@GroupId, @SubId, @CreatedDate)
end
go

create procedure AddMarkDataWithGroupToSubjectId
	@StudentId int, @GroupToSubjectId int, @Mark int, @CreatedDate date
as
begin
	insert into MarkData(StudentId, GroupToSubjectId, Mark, CreatedDate) values
	(@StudentId, @GroupToSubjectId, @Mark, @CreatedDate)
end
go

create procedure AddMarkDataWithGroupAndSubIds
	@StudentId int, @GroupId int, @SubId int, @Mark int, @CreatedDate date
as
begin
	declare @GrToSubId int 
	set @GrToSubId = (select Id from GroupToSubject 
						where GroupId = @GroupId and SubId = @SubId)
	insert into MarkData(StudentId, GroupToSubjectId, Mark, CreatedDate) values
	(@StudentId, @GrToSubId, @Mark, @CreatedDate)
end
go

create procedure AddMarkDataWithGroupAndSubNames
	@StudentId int, @GroupName varchar(10), @SubName varchar(30)
	,@Mark int, @CreatedDate date
as
begin
	declare @GrToSubId int, @GrId int, @SubId int 
	set  @GrId = (select Id from [Group] g 
					where g.Name=@GroupName)
	set @SubId = (select Id from Subject s 
					where s.Name = @SubName)
	set @GrToSubId = (select Id from GroupToSubject 
						where GroupId = @GrId and SubId = @SubId )
	insert into MarkData(StudentId, GroupToSubjectId, Mark, CreatedDate) values
	(@StudentId, @GrToSubId, @Mark, @CreatedDate)
end
go

create procedure AddSubject 
	@Subname varchar(30), @CreatedDate date
as
	insert into Subject(Name, CreatedDate) values
	(@Subname, @CreatedDate)
go

create procedure AddSubjectToTeacherRelWithIds
	@SubId int, @TeachId int, @CreatedDate date
as
	insert into SubjectToTeacher(SubId, TeacherId, CreatedDate) values
	(@SubId, @TeachId, @CreatedDate) 
go

create procedure AddSubjectToTeacherRelWithNames
	@SubName varchar(30), @TeachName varchar(30), @CreatedDate date
as
begin
	declare @SubId int, @TeachId int
	set @SubId = (select Id from Subject s
					where  s.Name = @SubName) 
	set @TeachId = (select Id from Teacher t
						where t.Name = @TeachName)
	insert into SubjectToTeacher(SubId, TeacherId, CreatedDate) values
	(@SubId, @TeachId, @CreatedDate) 
end	
go
create procedure AddTeacher 
	@Name varchar(30), @Surname varchar(30), @Salary float, @CreatedDate date
	,@MiddleName varchar(30)= null
as
	insert into Teacher(Name, MiddleName, Surname, Salary, CreatedDate) values
	(@Name, @MiddleName, @Surname, @Salary, @CreatedDate)
go

--************  Selecting data  *************** 
create procedure GetStudentsFromGroupWithId
	@GroupId int
as
	select s.Id, s.Name, isnull(s.MiddleName, '--')MiddleName, s.Surname, g.Name 
	from Student s 
	inner join [Group] g 
	on  s.GroupId = g.Id
	where g.Id=@GroupId
--drop procedure GetStudentsFromGroup
--exec GetStudentsFromGroup @GroupName='A M-1'
go

--drop procedure GetStudentsFromGroupWithName
create procedure GetStudentsFromGroupWithName
	@GroupName varchar(10)
as 
	select  s.Name, isnull(s.MiddleName, '--')MiddleName , s.Surname, g.Name 
	from Student s 
	inner join [Group] g 
	on  s.GroupId = g.Id
	where g.Name=@GroupName
go

create procedure GetStudentFromGroupWithAvgMark
	@GroupId int, @AvgMark int
as
	declare @StWithGr table(StId int, Name varchar(30), MiddleName varchar(30), Surname varchar(30)
							,GroupName varchar(10))
	insert into @StWithGr 
		exec GetStudentsFromGroupWithId @GroupId
	select distinct s.StId, s.Name, isnull(s.MiddleName, '--')MiddleName, s.Surname
	,s.GroupName, AvgMark.Mark
		from @StWithGr s 
		inner join MarkData m 
		on s.StId = m.StudentId
		inner join (select avg(Mark)Mark, StudentId 
					from MarkData 
					group by StudentId) AvgMark 
		on m.StudentId = AvgMark.StudentId
		where AvgMark.Mark >= @AvgMark 
		order by Mark
go
--exec GetStudentFromGroupWithAvgMark 1, 90

