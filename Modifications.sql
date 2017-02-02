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

--************  Updating data  ***************
create procedure UpdateFaculty
	@Id int,@Name varchar(50), @CreatedDate date = null
as	
	update Faculty
	set Name = @Name 
	,CreatedDate = coalesce(@CreatedDate, CreatedDate)
	where Id = @Id
go
create procedure UpdateGroup
	@Id int, @Name varchar(10), @SpId int= null, @CreatedDate date = null 
as
	update [Group] 
	set Name = @Name
	   ,SpecialityId = coalesce(@SpId,SpecialityId)
	   ,CreatedDate = coalesce(@CreatedDate, CreatedDate)
	where Id = @Id
go

create procedure UpdateGroupToSubject
	@Id int,@GrId int= null , @SubId int= null , @CreatedDate date = null 
as
	update GroupToSubject
	set GroupId = coalesce(@GrId,GroupId)
		,SubId = coalesce(@SubId, SubId)
		,CreatedDate = coalesce(@CreatedDate, CreatedDate)
	where Id = @Id
go

create procedure UpdateMarkData
	@Id int,@StId int, @GrToSub int, @Mark int, @CreatedDate date = null 
as
	update Markdata 
	set StudentId = @StId
		,GroupToSubjectId = @GrToSub
		,Mark = @Mark
		,CreatedDate = coalesce(@CreatedDate, CreatedDate)
	where Id = @Id
go

create procedure UpdateSpeciality
	@Id int, @Name varchar(50), @FacultyId int = null, @CreatedDate date = null 
as
	update Speciality
	set Name = @Name
		,FacultyId = coalesce(@FacultyId, FacultyId)
		,CreatedDate = coalesce(@CreatedDate, CreatedDate)
	where Id = @Id
go 

create procedure UpdateStudent
	@Id int, @Name varchar(30), @Surname varchar(50)= null, @GrId int= null
	,@MidName varchar(30)= null, @CreatedDate date = null
as
	update Student
	set Name = @Name
		,MiddleName = coalesce(@MidName, MiddleName)
		,Surname = coalesce(@Surname, Surname)
		,GroupId = coalesce(@GrId, GroupId) 
		,CreatedDate = coalesce(@CreatedDate, CreatedDate)
	where Id = @Id
go

create procedure UpdateSubject
	@Id int, @Name varchar(30), @CreatedDate date = null
as
	update Subject
	set Name = @Name
	,CreatedDate = coalesce(@CreatedDate, CreatedDate)
go

create procedure UpdateTeacher 
	@Id int, @Name varchar(30)= null, @Surname varchar(50)= null
	,@MidName varchar(30) = null, @CreatedDate date = null, @Salary float = null  
as
	update Teacher 
	set Name = coalesce(@Name, Name)
		,Surname = coalesce(@Surname, Surname)
		,MiddleName = coalesce(@MidName, MiddleName)
		,Salary = coalesce(@Salary, Salary)
		,CreatedDate = coalesce(@CreatedDate, CreatedDate)
	where Id = @Id
go

--************  Deleting data   ***************

create procedure DeleteFaculty 
	@FacId int
as
	delete from Faculty
	where Id = @FacId
	declare @SpecId int, @GroupId int
	set @SpecId = (select Id from Speciality where FacultyId=@FacId)
	set @GroupId = (select Id from [Group] where SpecialityId = @SpecId)
	delete from Speciality
	where FacultyId=@FacId
	delete from [Group]
	where SpecialityId = @SpecId
	delete from GroupToSubject
	where GroupId =@GroupId 
go

create procedure DeleteGroup
	@GroupId int
as
	delete from [Group]
	where Id = @GroupId
	delete from GroupToSubject
	where GroupId =@GroupId 
go	

create procedure DeleteGroupToSubject
	@Id int
as	
	delete from GroupToSubject
	where Id = @Id
go

create procedure DeleteMarkData
	@Id int
as
	delete from MarkData
	where Id = @Id
go
create procedure DeleteSpeciality
	@Id int
as
	delete from Speciality	
	where Id = @Id
	delete from [Group] 
	where SpecialityId = @Id
go
create procedure DeleteStudent
	@Id int
as
	delete from Student 
	where Id = @Id
	delete from MarkData
	where StudentId = @Id
go
create procedure DeleteSubject
	@Id int
as
	delete from Subject 
	where Id = @Id
	delete from GroupToSubject 
	where SubId = @Id
	delete from SubjectToTeacher
	where SubId = @Id
go
create procedure DeleteSubjectToTeacher
	@Id int
as
	delete from SubjectToTeacher
	where Id = @Id
go
create procedure DeleteTeacher
	@Id int
as
	delete from Teacher
	where Id = @Id
	delete from SubjectToTeacher
	where TeacherId = @Id
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

create procedure GetFaculties 
as
	select Name, CreatedDate, ModifiedDate
	from Faculty
go

create procedure GetFacultyWithId
	@FacId int = null, @FacName varchar(30)= null
as
	select Name, CreatedDate, ModifiedDate
	from Faculty f
	where (f.Id = @FacId and ) or (f.Name = @FacName)
go

create procedure GetFacultiesWithTeachers 
as
	