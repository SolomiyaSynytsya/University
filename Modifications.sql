--Inserting data
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

create procedure AddStudentWithGroupId
	@Name varchar(30), @MiddleName varchar(30), @Surname varchar(30)
	,@GroupId int
as
begin
	begin try
		insert into Student(name, MiddleName, Surname, GroupId) values
		(@Name, @MiddleName, @Surname,@GroupId)
	end try
	begin catch
		exec usp_GetErrorInfo;
	end catch;
end
go

create procedure AddStudentWithGroupName
	@Name varchar(30), @MiddleName varchar(30), @Surname varchar(30)
	,@GroupName varchar(30)
as
begin
	declare @GroupId int
	begin try		
		set @GroupId = (select Id from [Group] g where g.Name = @GroupName)
		insert into Student(Name, MiddleName, Surname, GroupId) values
		(@Name, @MiddleName, @Surname,@GroupId)
	end try
	begin catch
		exec usp_GetErrorInfo;
	end catch;
end
go

create procedure AddFaculty 
	@Name varchar(50), @CreatedDate date
as
begin
	begin try 
		insert into Faculty(Name, CreatedDate) values
		(@Name, @CreatedDate)
	end try 
	begin catch
		exec usp_GetErrorInfo;
	end catch;
end
go

create procedure AddSpeciality
	@Createddate date, @Name varchar(50), @FacultyName varchar(50) = null, @FacultyId int = null
as
begin
	begin try
		if @FacultyId is null
		begin
			if @Name is not null
				set @FacultyId = (select Id from Faculty f where f.Name = @Name)
			else RAISERROR (50000, -1, -1, 'AddSpeciality')
		end
		insert into Speciality(Name, FacultyId, CreatedDate) values
		(@Name, @FacultyId, @Createddate)
	end try 
	begin catch
		exec usp_GetErrorInfo;
	end catch;
end
go

create procedure AddGroup 
	 @CreatedDate date, @Name varchar(10), @SpecialityId int = null, @SpecialityName varchar(50)
as
begin
	begin try
		if @SpecialityId is null
		begin 
			if @SpecialityName is not null
				set @SpecialityId = (select Id from Speciality s where s.Name = @SpecialityName )
			else RAISERROR (50000, -1, -1, 'AddGroup')
		end
		insert into [Group](Name, SpecialityId, CreatedDate) values
		(@Name, @SpecialityId, @CreatedDate)
	end try
	begin catch
		exec usp_GetErrorInfo;
	end catch
end
go

create procedure AddRelationGroupToSubject
	@CreatedDate date , @GroupId int = null, @GroupName varchar(10) = null,  @SubId int = null
    ,@SubName varchar(30) = null
as
begin
	begin try 
		if @GroupId is null 
		begin
			if @GroupName is not null 
				set @GroupId = (select Id from [Group] g where g.Name = @GroupName)
			else RAISERROR (50000, -1, -1, 'AddRelationGroupToSubject')
		end
		if @SubId is null 
		begin
			if  @SubName is not null 
				set @SubId = (select Id from Subject s where s.Name = @SubName)
			else RAISERROR (50000, -1, -1, 'AddRelationGroupToSubject')
		end
		insert into GroupToSubject(GroupId, SubId, CreatedDate) values
		(@GroupId, @SubId, @CreatedDate)
	end try
	begin catch
		exec usp_GetErrorInfo;
	end catch
end
go
--Selecting data 
create procedure GetStudentsFromGroup
	@GroupId int = null, @GroupName varchar(10) = null
as
	if @GroupId is null 
	begin 
		if @GroupName is not null 
			set @GroupId = (select Id from [Group] g where g.Name = @GroupName)
		else RAISERROR (50000, -1, -1, 'GetStudentsFromGroup')
	end
	select s.Name, s.MiddleName, s.Surname, g.Name 
	from Student s 
	inner join [Group] g 
	on  s.GroupId = g.Id
	where g.Id=@GroupId

--drop procedure GetStudentsFromGroup
exec GetStudentsFromGroup @GroupName='A M-1'