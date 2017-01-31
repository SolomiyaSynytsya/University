--set @rnd = (SELECT FLOOR(RAND()*(@b-@a)+@a))\
create procedure GenerateNames 
	@RndName int output, @RndSurname int output
as
begin
	declare @NameAmmount int, @SurnameAmmount int
	select @NameAmmount=count(Name) from TempNames
	select @SurnameAmmount = count(Surname) from TempSurnames
	set @Rndname = (SELECT FLOOR(RAND()*(@NameAmmount-1)+1))
	set @RndSurname = (SELECT FLOOR(RAND()*(@SurnameAmmount-1)+1))
end
go

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
	declare  @RndSalary int, @Cnt int = 1
	declare @GeneratedName int, @GeneratedSurname int
	declare @AmmountOfteachers int, @MinSalary int = 3200, @MaxSalary int = 6000 
	select @AmmountOfteachers = count(Name) * 2 from Subject
	DBCC CHECKIDENT (Teacher, RESEED, 0)
	while @Cnt < @AmmountOfteachers
	begin
		exec GenerateNames @GeneratedName output, @GeneratedSurname output  
		set @RndSalary = (SELECT FLOOR(RAND()*(@MaxSalary-@MinSalary)+@MinSalary))
		insert into Teacher(Name, Surname, Salary, Createddate)
			select tn.Name, ts.Surname, @RndSalary, getdate()
			from TempNames tn,TempSurnames ts 			
			where ts.Id=@GeneratedSurname and tn.Id=@GeneratedName
			set @Cnt += 1
	end	
	select * From Teacher
end
exec GenerateTeachers 
go

--drop procedure AddTeachersToSubjects
create procedure AddTeachersToSubjects
as
begin
	declare @SubCnt int = 1, @AmmountOfSub int, @AmmountOfTeacher int, @RndTeacher int = 0
	declare @BusyTeacher table(Id int)
	declare @AmmountBusyTeacher int = 2, @CntAmmountBusyTeacher int
	declare @TeacherPerSub int = 2, @CntTeacherPerSub int = 0
	select @AmmountOfSub = count(Name) from Subject
	select @AmmountOfTeacher = count(Name) from Teacher
	DBCC CHECKIDENT (SubjectToTeacher, RESEED, 0)
	while @SubCnt < @AmmountOfSub
	begin
		while @CntTeacherPerSub < @TeacherPerSub
		begin
			set @RndTeacher = (SELECT FLOOR(RAND()*(@AmmountOfTeacher-1)+1))
			set @CntAmmountBusyTeacher = (select count(Id) from @BusyTeacher where Id = @RndTeacher)		
			while @CntAmmountBusyTeacher >@AmmountBusyTeacher
			begin
				set @RndTeacher = (SELECT FLOOR(RAND()*(@AmmountOfTeacher-1)+1))
				set @CntAmmountBusyTeacher = (select count(Id) from @BusyTeacher where Id = @RndTeacher)
			end
			insert into @BusyTeacher(Id) values(@RndTeacher)
			print @RndTeacher
			insert into SubjectToTeacher(SubId, TeacherId, CreatedDate) 
				select @SubCnt, @RndTeacher, getdate()
			set @CntTeacherPerSub += 1
		end
		set @CntTeacherPerSub = 0
		set @SubCnt += 1
	end
	select * from SubjectToTeacher
end
exec AddTeachersToSubjects
go

--drop procedure GenerateStudents
create procedure GenerateStudents 
as
begin
	declare @GroupsAmmount int, @CntGroups int = 1, @StudentsPerGroup int = 25, @CntStudents int = 1 
	declare @GeneratedName int, @GeneratedSurname int
	select @GroupsAmmount = count(Id) from [Group]
	DBCC CHECKIDENT (Student, RESEED, 0)
	while @CntGroups <= @GroupsAmmount
	begin
		while @CntStudents <= @StudentsPerGroup
		begin
			exec GenerateNames @GeneratedName output, @GeneratedSurname output  
			insert into Student(Name, Surname, GroupId, CreatedDate)
				select tn.Name, ts.Surname, @CntGroups, getdate() 
				from TempNames tn,TempSurnames ts
				where tn.Id = @GeneratedName and ts.Id = @GeneratedSurname	
			set @CntStudents += 1			
		end
		set @CntStudents = 1
		set @CntGroups += 1
	end 
	select * from Student
end
exec GenerateStudents
go

drop procedure GenerateMarkData
create procedure GenerateMarkData
as
begin
	declare @CntStudents int = 1, @AmmountOfStudents int, @a int = 0  
	declare @TestTable table (StId int, GrToSubId int, Mark int)
	select @AmmountOfStudents = count(Id) from Student
		insert into @TestTable(StId, GrToSubId)
			select s.Id, gts.Id
			from Student s 
			inner join GroupToSubject gts
			on s.GroupId = gts.GroupId
	select * from @TestTable
	/*while @a < @ammount
	begin
		update @TestTable 
		set Mark = FLOOR(RAND()*(100-50)+50)
		where @@rowcount = @a
		set @a += 1
	end*/
end
exec GenerateMarkData
go