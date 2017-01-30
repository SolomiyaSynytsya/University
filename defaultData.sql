--drop procedure CreateDefaultFacultiesAndSpecialities;
create procedure CreateDefaultFacultiesAndSpecialities
as
begin
	DBCC CHECKIDENT (Faculty, RESEED, 0)
	insert into Faculty(Name, CreatedDate) values
		('Mathematics and Informatics', Getdate())
		,('History',Getdate())
		,('Philosophy',Getdate())
		,('Psychology',Getdate())
		,('Philology',Getdate())
		,('Physics',Getdate())
		,('Physical training',Getdate());
	DBCC CHECKIDENT (Speciality, RESEED, 0)
	insert into Speciality(Name, FacultyId, CreatedDate) values
		 ('Applied Mathimatics', 1, Getdate())
		,('Informational Technologies', 1, Getdate())
		,('Mathimatics', 1, Getdate())
		,('Statistics', 1, Getdate())
		,('Ukrainian History', 2, Getdate())
		,('Medieval History', 2, Getdate())
		,('Modern History', 2, Getdate())
		,('Antic Philosophy', 3, Getdate())
		,('Medieval Philosophy', 3, Getdate())
		,('Modern Philosophy', 3, Getdate())
		,('Social Psychology', 4, Getdate())
		,('Children Psychology', 4, Getdate())
		,('English', 5, Getdate())
		,('French', 5, Getdate())
		,('German', 5, Getdate())
		,('Atomic Physics', 6, Getdate())
		,('Radiophysics', 6, Getdate())
		,('Computer Engineering', 6, Getdate())
		,('Reabilitation', 7, Getdate())
		,('Couching', 7, Getdate())
end
exec CreateDefaultFacultiesAndSpecialities;
go

create procedure CreateDefaultSubjects
as
begin
	DBCC CHECKIDENT (Subject, RESEED, 0)
	insert into Subject(Name, CreatedDate) values
	 ('Math Analysys', Getdate())
	,('Algebra', Getdate())
	,('Probability', Getdate())
	,('Functional Analysys', Getdate())
	,('Programming', Getdate())
	,('Databases', Getdate())
	,('Data Analysys', Getdate())
	,('Differential Equations', Getdate())
	,('Ukrainian History', Getdate())
	,('Geometry', Getdate())
	,('Physical Trainings', Getdate())
	,('Statistical Analysys', Getdate())
	,('Modern History', Getdate())
	,('Medieval History', Getdate())
	,('Ukrainian Language', Getdate())
	,('Ukrainian Literature', Getdate())
	,('World History', Getdate())
	,('Medieval Europe', Getdate())
	,('Medieval Asia', Getdate())
	,('Modern Europe', Getdate())
	,('Modern Asia', Getdate())
	,('English Language', Getdate())
	,('Phil first', Getdate())
	,('Phil second', Getdate())
	,('Phil third', Getdate())
	,('Phil fourth', Getdate())
	,('Psychology first', Getdate())
	,('Psychology second', Getdate())
	,('Psychology third', Getdate())
	,('Psychology fourth', Getdate())
	,('English Literature', Getdate())
	,('French Language', Getdate())
	,('French Literature', Getdate())
	,('German Language', Getdate())
	,('German Literature', Getdate())
	,('General Physics', Getdate())
	,('Physics Spec First', Getdate())
	,('Physics Spec Second', Getdate())
	,('Computer Architecture', Getdate())
	,('Running', Getdate())
	,('Swimming', Getdate())
	,('General Physical Training', Getdate())

end
exec CreateDefaultSubjects
go 
create table TempNames
(Id int Identity(1,1),
 Name varchar(30)
)
create table TempSurnames
(Id int Identity(1,1),
Surname varchar(30)
)
go

create type Surname as Table
(
Id int,
Surname varchar(30)
) 
go
create type Name1 as Table
(
Id int,
Name varchar(30)
) 
go
declare  @NameTab as Name1
--DBCC CHECKIDENT (@NameTab, RESEED, 0)
insert into @NameTab(Name) values
('Aaron'),
('Aaron'),
('Abbey'),
('Abbie'),
('Abby'),
('Abdul'),
('Abe'),
('Abel'),
('Abigail'),
('Abraham'),
('Basilia'),
('Bea'),
('Beata'),
('Beatrice'),
('Beatris'),
('Beatriz'),
('Beau'),
('Beaulah'),
('Bebe'),
('Becki'),
('Beckie'),
('Camille'),
('Cammie'),
('Cammy'),
('Candace'),
('Candance'),
('Candelaria'),
('Candi'),
('Candice'),
('Candida'),
('Candie'),
('Candis'),
('Dallas'),
('Dallas'),
('Dalton'),
('Damaris'),
('Damian'),
('Damien'),
('Damion'),
('Damon'),
('Dan'),
('Dan'),
('Dana'),
('Dana'),
('Danae'),
('Dane'),
('Danelle'),
('Danette'),
('Dani'),
('Dania'),
('Danial'),
('Danica'),
('Daniel'),
('Edie'),
('Edison'),
('Edith'),
('Edmond'),
('Edmund'),
('Edmundo'),
('Edna'),
('Edra'),
('Edris'),
('Eduardo'),
('Edward'),
('Edward'),
('Edwardo'),
('Edwin'),
('Edwina'),
('Edyth'),
('Edythe'),
('Effie'),
('Efrain'),
('Efren'),
('Ehtel'),
('Flor'),
('Flora'),
('Florance'),
('Florence'),
('Florencia'),
('Florencio'),
('Florene'),
('Florentina'),
('Florentino'),
('Floretta'),
('Floria'),
('Gary'),
('Gaston'),
('Gavin'),
('Gay'),
('Gaye'),
('Gayla'),
('Gayle'),
('Gayle'),
('Gaylene'),
('Gaylord'),
('Gaynell'),
('Haydee'),
('Hayden'),
('Hayley'),
('Haywood'),
('Iluminada'),
('Ima'),
('Imelda'),
('Imogene'),
('In'),
('Ina'),
('India'),
('Indira'),
('Inell'),
('Ines'),
('Inez'),
('Inga'),
('Inge'),
('Ingeborg'),
('Inger'),
('Ingrid'),
('Inocencia'),
('Iola'),
('Iona'),
('Ione'),
('Ira'),
('Jacqualine'),
('Jacque'),
('Jacquelin'),
('Jacqueline'),
('Jacquelyn'),
('Jacquelyne'),
('Jacquelynn'),
('Jacques'),
('Jacquetta'),
('Jacqui'),
('Jacquie'),
('Jacquiline'),
('Jacquline'),
('Jacqulyn'),
('Jada'),
('Jade'),
('Jadwiga'),
('Jae'),
('Jae'),
('Jaime'),
('Jaime'),
('Joe'),
('Joe'),
('Joeann'),
('Joel'),
('Joel'),
('Joella'),
('Joelle'),
('Joellen'),
('Joesph'),
('Joetta'),
('Joette'),
('Joey'),
('Joey'),
('Johana'),
('Johanna'),
('Johanne'),
('John'),
('John'),
('Johna'),
('Johnathan'),
('Johnathon'),
('Kaleigh'),
('Kaley'),
('Kali'),
('Kallie'),
('Kalyn'),
('Kam'),
('Kamala'),
('Kami'),
('Kamilah'),
('Kandace'),
('Kandi'),
('Kandice'),
('Kandis'),
('Kandra'),
('Kandy'),
('Kanesha'),
('Kanisha'),
('Kara'),
('Karan'),
('Kareem'),
('Kareen'),
('Lachelle'),
('Laci'),
('Lacie'),
('Lacresha'),
('Lacy'),
('Lacy'),
('Ladawn'),
('Ladonna'),
('Lady'),
('Lael'),
('Lahoma'),
('Lai'),
('Laila'),
('Laine'),
('Lajuana'),
('Lakeesha')
go
declare @SurnameTab as Surname
DBCC CHECKIDENT (@SurnameTab, RESEED, 0)
insert into @SurnameTab values
('Aaberg'),
('Aaby'),
('Aadland'),
('Aagaard'),
('Aakre'),
('Aaland'),
('Aalbers'),
('Aalderink'),
('Aalund'),
('Aamodt'),
('Aamot'),
('Aanderud'),
('Aanenson'),
('Aanerud'),
('Aarant'),
('Aardema'),
('Aarestad'),
('Aarhus'),
('Aaron'),
('Aarons'),
('Aaronson'),
('Balter'),
('Baltes'),
('Balthazar'),
('Balthazor'),
('Balthrop'),
('Baltierra'),
('Baltimore'),
('Baltodano'),
('Balton'),
('Baltrip'),
('Baltruweit'),
('Baltz'),
('Baltzell'),
('Baltzer'),
('Baltzley'),
('Balvanz'),
('Balwin'),
('Balwinski'),
('Balyeat'),
('Balza'),
('Balzano'),
('Carragher'),
('Carrahan'),
('Carraher'),
('Carrales'),
('Carran'),
('Carranco'),
('Carrano'),
('Carransa'),
('Carranza'),
('Carranzo'),
('Carrao'),
('Carrara'),
('Carras'),
('Carrasco'),
('Carrasquillo'),
('Carratala'),
('Carratura'),
('Carraturo'),
('Carrauza'),
('Carraway'),
('Carrazco'),
('Carre'),
('Carrea'),
('Carrecter'),
('Carreira'),
('Carreiro'),
('Carrejo'),
('Carreker'),
('Carrel'),
('Carrell'),
('Carrelli'),
('Demarc'),
('Demarce'),
('Demarco'),
('Demarcus'),
('Demaree'),
('Demarest'),
('Demaria'),
('Demarini'),
('Demarinis'),
('Demarino'),
('Demario'),
('Demaris'),
('Demark'),
('Demarrais'),
('Demars'),
('Demarse'),
('Demarsico'),
('Demart'),
('Demartini'),
('Demartino'),
('Demary'),
('Demarzio'),
('Demas'),
('Demase'),
('Demasi'),
('Demasters'),
('Demastus'),
('Demateo'),
('Dematos'),
('Dematteis'),
('Dematteo'),
('Demattia'),
('Demattos'),
('Demauri'),
('Demauro'),
('Demay'),
('Demayo'),
('Dembek'),
('Dember'),
('Dembinski'),
('Dembitzer'),
('Dembo'),
('Dembosky'),
('Dembowski'),
('Dembroski'),
('Demby'),
('Demchak'),
('Demchok'),
('Demedeiros'),
('Demeester'),
('Demeglio'),
('Ewer'),
('Ewers'),
('Ewert'),
('Ewig'),
('Ewin'),
('Ewing'),
('Ewings'),
('Ewoldt'),
('Ewton'),
('Ewy'),
('Exantus'),
('Excell'),
('Exe'),
('Exel'),
('Exford'),
('Exilus'),
('Exler'),
('Exley'),
('Exline'),
('Exner'),
('Exon'),
('Expose'),
('Extine'),
('Exton'),
('Exum'),
('Eychaner'),
('Eye'),
('Eyer'),
('Eyerman'),
('Eyermann'),
('Eyestone'),
('Henshaw'),
('Hensle'),
('Henslee'),
('Hensler'),
('Hensley'),
('Henslin'),
('Henson'),
('Henstrom'),
('Henter'),
('Hentges'),
('Henthorn'),
('Henthorne'),
('Henton'),
('Hentrich'),
('Hentschel'),
('Hentz'),
('Mcnealy'),
('Mcnear'),
('Mcneary'),
('Mcnease'),
('Mcnee'),
('Mcneece'),
('Mcneel'),
('Mcneeley'),
('Mcneely'),
('Mcneer'),
('Mcnees'),
('Mcneese'),
('Mcneff'),
('Mcneil'),
('Pippert'),
('Pippin'),
('Pippins'),
('Pippitt'),
('Pique'),
('Piquette'),
('Piraino'),
('Pirc'),
('Pires'),
('Pirie'),
('Pirieda'),
('Pirillo'),
('Pirkey'),
('Pirkl'),
('Pirkle'),
('Pirman')
