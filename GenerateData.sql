--set @rnd = (SELECT FLOOR(RAND()*(@b-@a)+@a))\
--drop procedure CreateGroups
create procedure CreateGroups
as
begin
	declare @Grnames table(Name varchar(10), SpecId int)
	declare @CoursCnt int = 1, @SpecAmmount int
	declare @cnt int = 1;
	insert into @Grnames
		select case when CharIndex(' ', Name)>0  
			then Left(Name,1)+Substring(Name,CharIndex(' ', Name), 2) 
				else  Left(Name,1)
			end, Id 			
		 from Speciality
	set @SpecAmmount= (select top 1 Id from Speciality
						order by Id desc)		
	select * from @Grnames
	print @SpecAmmount
	while @cnt <= @SpecAmmount
	begin 
		while @CoursCnt < 6
		begin
			insert into [Group](Name, SpecialityId, CreatedDate ) 
				select Concat(Name,'-',@CoursCnt), SpecId, Getdate()
				from @Grnames
				where SpecId = @cnt;
				print @cnt;
			Set @CoursCnt += 1;
		end
		Set @CoursCnt = 1;
		Set @cnt +=1;	 
	end
end
exec CreateGroups
go

--drop procedure AddSubjectsToGroups
create procedure AddSubjectsToGroups
as
begin 
	declare @SubAmmount int, @GroupAmmount int, @RndSub int;
	declare @GroupCnt int = 1, @SubPerGroup int = 5, @SubPerGroupCount int = 1;
	declare @TestGr table (GroupId int, SubId int, CreatedDate date)

	select @SubAmmount = count(Name) from Subject;
	select @GroupAmmount = count(Name) from [Group];
	
	DBCC CHECKIDENT (GroupToSubject, RESEED, 0)
	while @GroupCnt <= @GroupAmmount
	begin
		while @SubPerGroupCount <= @SubPerGroup
		begin
			set @RndSub = (SELECT FLOOR(RAND()*(@SubAmmount-1)+1))
			insert into GroupToSubject(GroupId, SubId, CreatedDate)
				select Id, @RndSub, GETDATE()  
				from [Group]
				where Id = @GroupCnt
			set @SubPerGroupCount += 1
		end
		set @SubPerGroupCount = 1
		set @GroupCnt +=1
	end
	select * from GroupToSubject
end
exec AddSubjectsToGroups
go

--drop procedure GenerateTeachers
create procedure GenerateTeachers
as 
begin
	declare @Rndname int, @RndSurname int, @RndSalary int, @Cnt int = 1
	declare @NameAmmount int, @SurnameAmmount int
	declare @AmmountOfteachers int, @MinSalary int = 3200, @MaxSalary int = 6000 
	select @AmmountOfteachers = count(Name) * 2 from Subject
	select @NameAmmount=count(Name) from TempNames
	select @SurnameAmmount = count(Surname) from TempSurnames
	DBCC CHECKIDENT (Teacher, RESEED, 0)
	while @Cnt < @AmmountOfteachers
	begin
		set @Rndname = (SELECT FLOOR(RAND()*(@NameAmmount-1)+1))
		set @RndSurname = (SELECT FLOOR(RAND()*(@SurnameAmmount-1)+1))
		set @RndSalary = (SELECT FLOOR(RAND()*(@MaxSalary-@MinSalary)+@MinSalary))
		insert into Teacher(Name, Surname, Salary, Createddate)
			select f.Name, l.Surname, @RndSalary, getdate()
			from TempNames f
			inner join TempSurnames l 
			on 1=1
			where l.Id=@RndSurname and f.Id=@Rndname
			set @Cnt += 1
	end	
	select * From Teacher
end
exec GenerateTeachers 
go

create procedure AddTeachersToSubjects
as
begin
	declare @SubCnt int = 1, @AmmountOfSub int, @AmmountOfTeacher int, @RndTeacher int = 0
	declare @BusyTeacher table(Id int)
	declare @AmmountBusyTeacher int
	select @AmmountOfSub = count(Name) from Subject
	while @SubCnt < @AmmountOfSub
	begin
		set @RndTeacher = (SELECT FLOOR(RAND()*(@AmmountOfTeacher-1)+1))
		set @AmmountBusyTeacher = (select count(Id) from @BusyTeacher where Id = @RndTeacher)
		
		while @AmmountBusyTeacher >2
		begin
			set @RndTeacher = (SELECT FLOOR(RAND()*(@AmmountOfTeacher-1)+1))
			set @AmmountBusyTeacher = (select count(Id) from @BusyTeacher where Id = @RndTeacher)
		end
		insert into @BusyTeacher(Id) values(@RndTeacher)
		insert into SubjectToTeacher(SubId, TeacherId, CreatedDate) 
			select s.Id, 
	end
end


