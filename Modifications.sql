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
select * from Student where Name = 'Solomiya' go
create procedure AddStudent
	@Name varchar(30),  @Surname varchar(30)
	,@GroupId int, @CrDate date = null,@MiddleName varchar(30)=null
as
begin
	insert into Student(Name, MiddleName, Surname, GroupId, CreatedDate) values
	(@Name, @MiddleName, @Surname,@GroupId, coalesce(@CrDate, getdate()))
end
go
SET STATISTICS TIME ON
--exec AddStudentWithGroupId 'Josdfgyhjkkkkkkkkkkkkkkkkkkkwefpoqg355555etbwrhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhnwrnywrnwn5555hn', 'Dilan', 1, 'Mikhel'  
go
SET STATISTICS TIME OFF
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


create procedure AddGroupWithSpecialityId
	 @CreatedDate date, @Name varchar(10), @SpecialityId int
as
begin
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

--drop procedure AddMarkData
create procedure AddMarkData
	@StudentId int, @SubId int, @Mark int, @CreatedDate date = null
as
begin
	SET NOCOUNT OFF; 
	declare @GrId int
	set @GrId = (select GroupId from Student where Id=@StudentId)
	declare @GrToSubId int 
	set @GrToSubId = (select Id from GroupToSubject 
						where GroupId = @GrId and SubId = @SubId)
	insert into MarkData(StudentId, GroupToSubjectId, Mark, CreatedDate) values
	(@StudentId, @GrToSubId, @Mark, coalesce(@CreatedDate, getdate()))
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

create procedure AddTeacher 
	@Name varchar(30), @Surname varchar(30), @Salary float, @CreatedDate date=null
	,@MiddleName varchar(30)= null
as
	insert into Teacher(Name, MiddleName, Surname, Salary, CreatedDate) values
	(@Name, @MiddleName, @Surname, @Salary, coalesce(@CreatedDate, getdate()))
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
	delete from Markdata 
	where StudentId in 
		(select Id from Student 
		where GroupId in 
				(select Id from [Group] 
				where SpecialityId in 
					(select Id from Speciality 
					where FacultyId=@FacId)
				)
			)
	delete from Student 
	where GroupId in (select Id from [Group] 
					 where SpecialityId in (select Id from Speciality 
							where FacultyId=@FacId)
					  ) 
	delete from GroupToSubject
	where GroupId in (select Id from [Group] 
						where SpecialityId in (select Id from Speciality 
												where FacultyId=@FacId)
					 )
	delete from [Group]
	where SpecialityId in (select Id from Speciality 
							where FacultyId=@FacId)
	delete from Speciality
	where FacultyId=@FacId	
	delete from Faculty
	where Id = @FacId
go

create procedure DeleteGroup
	@GroupId int
as
	delete from MarkData
	where GroupToSubjectId in (select Id from GroupToSubject 
								where GroupId = @GroupId)
	delete from GroupToSubject
	where GroupId =@GroupId
	delete from Student 
	where GroupId = @GroupId
	delete from [Group]
	where Id = @GroupId
	 
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
	delete from MarkData 
	where StudentId in (select Id from Student
						where GroupId in (select id from [Group] 
											where SpecialityId = @Id)
						)
	delete from Student 
	where GroupId in (select id from [Group] 
						where SpecialityId = @Id)
	delete from GroupToSubject 
	where GroupId in (select Id from [Group] 
					  where SpecialityId = @Id)
	delete from [Group] 
	where SpecialityId = @Id
	delete from Speciality	
	where Id = @Id
go

create procedure DeleteStudent
	@Id int
as
	delete from MarkData
	where StudentId = @Id
	delete from Student 
	where Id = @Id
	
go
create procedure DeleteSubject
	@Id int
as	
	delete from MarkData
	where GroupToSubjectId in (select Id from GroupToSubject 
								where SubId = @Id)
	delete from GroupToSubject 
	where SubId = @Id
	delete from SubjectToTeacher
	where SubId = @Id
	delete from Subject 
	where Id = @Id
go
create procedure DeleteSubjectToTeacher
	@Id int
as
	delete from SubjectToTeacher
	where Id = @Id
go

--exec DeleteSubjectToTeacher 2
--go

create procedure DeleteTeacher
	@Id int
as
	delete from SubjectToTeacher
	where TeacherId = @Id
	delete from Teacher
	where Id = @Id
	
go
--exec DeleteTeacher 2
--go
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

--**************************************************************************************************************
create procedure AddRandomData 
as
begin
		SET NOCOUNT OFF;  
		declare @Nm varchar(30), @Srnm varchar(30), @Gr int,@StAmm int
				,@GrToS int, @MarkAm int
		declare @AmN int, @AmS int
		set @Gr = (select count(Id) from [Group])
		set @AmN= (select count(Id) from TempNames)
		set @AmS = (select count(Id) from TempSurnames)
		set @StAmm = (select count(Id) from Student )
		set @Nm = (select Name from TempNames where Id = FLOOR(RAND()*(@AmN-1)+1))
		set @Srnm = (select Surname from TempSurnames where Id = FLOOR(RAND()*(@AmS-1)+1))
		set @GrToS = (select count(Id) from GroupToSubject)
		set @MarkAm = (select count(Id) from MarkData)

	declare @Num int
	set @Num = CAST(RAND() * 10000000 AS INT)
	if @Num % 7 = 0 
	begin 
		declare @SId int, @Mrk int, @StId int

		set @StId = (SELECT FLOOR(RAND()*(@StAmm-1)+1))
		set @SId = (select top(1) SubId from GroupToSubject
								where GroupId in (select GroupId from Student 
													where Id = @StId))
		set @Mrk = FLOOR(RAND()*(100-50)+50)
		exec AddMarkData @StId, @SId, @Mrk
		print @StId 
	end
	else if @Num % 6 = 0
	begin
		
		exec AddStudent @Nm, @Srnm, @Gr
	end
	else if @Num % 5 = 0
	begin
		declare @Salary float 
		set @Salary= FLOOR(RAND()*(6000-3200)+3200)
		exec AddTeacher @Nm, @Srnm, @Salary
	end
	else if @Num % 4 = 0
	begin
		declare  @Sub int, @Group int, @Subject int, @id int
		set @Sub = (select count(Id) from Subject)
		set @Group = FLOOR(RAND()*(@Gr-1)+1)
		set @Subject = FLOOR(RAND()*(@Sub-1)+1)
		set @id = (select Id from GroupToSubject 
					where GroupId=@Group and SubId = @Subject)
		exec UpdateGroupToSubject @id, @Group, @Subject
	end
	else if @Num % 3 = 0
	begin
		--create procedure UpdateMarkData
			--@Id int,@StId int, @GrToSub int, @Mark int, @CreatedDate date = null 
		declare @MarkId int, @St int , @GrS int, @Mr int
		set @MarkId = FLOOR(RAND()*(@MarkAm-1)+1)
		set @St =  FLOOR(RAND()*(@StAmm-1)+1)
		set @GrS = FLOOR(RAND()*(@GrToS-1)+1)
		set @Mr = FLOOR(RAND()*(100-50)+50)
		exec UpdateMarkData @MarkId,@St, @GrS,@Mr
	end
end 
go

--drop procedure AddRandomData
exec AddRandomData

SELECT SERVERPROPERTY ('IsPolybaseInstalled') AS IsPolybaseInstalled;  
