create database MiniEduSystem;
use MiniEduSystem;


/*  ѧԺ  */
create table College
(
	CollegeCode         char(2)      NOT NULL,
	CollegeName         varchar(30)  NOT NULL,
	Flag				int          NOT NULL,

	primary key (CollegeCode)
);


/*  ��ʦ  */
create table Teacher
(
	TeacherNo           char(10)     NOT NULL,
	TeacherName         varchar(16)  NOT NULL,
	CollegeCode         char(2)      NOT NULL,
	Gender              char(2)      NOT NULL,
	Title               char(8)      NOT NULL,
	Degree              varchar(20)  NOT NULL,
	Major               varchar(30),
	PoliticsStatus      char(10),
	NativePlace         varchar(50),
	Tel                 char(11),
	Mail                varchar(30),

	primary key (TeacherNo),
	foreign key (CollegeCode) references College(CollegeCode)
);


/*  ѧ��  */
create table Student
(
	StudentNo           char(10)     NOT NULL,
	StudentName         varchar(16)  NOT NULL,
	CollegeCode         char(2)      NOT NULL,
	Major               varchar(30)  NOT NULL,
	Gender              char(2)      NOT NULL,
	Birthday            datetime     NOT NULL,
	EnrollmentDate      datetime     NOT NULL,
	PoliticsStatus      char(10),
	NativePlace         varchar(50),
	Tel                 char(11),
	Mail                varchar(30),

	primary key (StudentNo),
	foreign key (CollegeCode) references College(CollegeCode)
);


/*  �γ�  */
create table Course
(
	CourseCode          char(9)      NOT NULL,
	CourseName          varchar(30)  NOT NULL,
	CourseType          varchar(12)  NOT NULL,
	TeacherNo           char(10)     NOT NULL,
	CreditHour          decimal(6,2) NOT NULL,
	AvailableMark       int          NOT NULL,

	primary key (CourseCode),
	foreign key (TeacherNo) references Teacher(TeacherNo)
);


/*  ѡ�α�  */
create table CourseSelection
(
	StudentNo           char(10)     NOT NULL,
	CourseCode          char(9)      NOT NULL, 
	Grade               decimal(5,1),

	primary key (StudentNo,CourseCode),
	foreign key (StudentNo) references Student(StudentNo),
	foreign key (CourseCode) references Course(CourseCode)
);


/*  ����Ա�˻�  */
create table AccountAdministrator
(
	UserName            char(10)     NOT NULL,
	Cipher              char(32)     NOT NULL,
	AdministratorName   varchar(16)  NOT NULL,
	Gender              char(2)      NOT NULL,
	Birthday            datetime     NOT NULL,
	Tel                 char(11),
	Mail                varchar(30),

	primary key (UserName)
);


/*  ��ʦ�˻�  */
create table AccountTecher
(
	UserName            char(10)     NOT NULL,
	Cipher              char(32)     NOT NULL,

	primary key (UserName),
	foreign key (UserName) references Teacher(TeacherNo)
);


/*  ѧ���˻�  */
create table AccountStudent
(
	UserName            char(10)     NOT NULL,
	Cipher              char(32)     NOT NULL,

	primary key (UserName),
	foreign key (UserName) references Student(StudentNo)
);




/*  ������  */
go
create trigger �Ա����� on Student
after insert
as
begin
	declare @Gender char(2);
	select @Gender = Gender from inserted;
	if (@Gender <> '��' and @Gender <> 'Ů')
	begin
		rollback transaction;
		raiserror ('�Ա�ֻ��Ϊ�л�Ů', 14, 1);
	end
end
go



/*  ѧ������  */

-- ѧ����Ϣ
go
create view StuInfo
as
select
	StudentNo as ѧ��,
	StudentName as ����,
	CollegeName as ѧԺ,
	Major as רҵ,
	Gender as �Ա�,
	Birthday as ��������,
	EnrollmentDate as ��ѧ����,
	PoliticsStatus as ������ò,
	NativePlace as ����,
	Tel as �绰,
	Mail as ����
from Student
inner join College
on Student.CollegeCode = College.CollegeCode;
go


-- ѧ���γ̱�
go
create procedure StuCourse
	@ID char(10)
as
begin
	select
		Course.CourseCode as �γ̱��,
		Course.CourseName as �γ�����,
		Course.CourseType as �γ�����,
		Teacher.TeacherName as �ον�ʦ,
		Course.CreditHour as �γ�ѧ��
	from CourseSelection
	inner join Course
	on CourseSelection.CourseCode = Course.CourseCode
	inner join Teacher
	on Teacher.TeacherNo = Course.TeacherNo
	where Grade is NULL
	      and StudentNo = @ID;
end
go


-- ѧ��ѡ�α�
go
create procedure StuSelect
	@ID char(10)
as
begin
	select
		Course.CourseCode as �γ̱��,
		Course.CourseName as �γ�����,
		Course.CourseType as �γ�����,
		Teacher.TeacherName as �ον�ʦ,
		Course.CreditHour as �γ�ѧ��
	from Course
	inner join Teacher
	on Teacher.TeacherNo = Course.TeacherNo
	where Course.AvailableMark = 1
		and Course.CourseCode not in
			(select CourseCode from CourseSelection where StudentNo = @ID)
end
go


-- �γ̼��
go
create procedure StuSelectCheck
	@ID char(10), @Code char(9)
as
begin
	select
		Course.CourseCode as �γ̱��,
		Course.CourseName as �γ�����,
		Course.CourseType as �γ�����,
		Teacher.TeacherName as �ον�ʦ,
		Course.CreditHour as �γ�ѧ��
	from Course
	inner join Teacher
	on Teacher.TeacherNo = Course.TeacherNo
	where Course.AvailableMark = 1
		and Course.CourseCode not in
			(select CourseCode from CourseSelection where StudentNo = @ID)
		and Course.CourseCode = @Code;
end
go


-- ѧ���ɼ���
go
create procedure StuGrade
	@ID char(10)
as
begin
	select
		Course.CourseCode as �γ̱��,
		Course.CourseName as �γ�����,
		Course.CourseType as �γ�����,
		Course.CreditHour as �γ�ѧ��,
		CourseSelection.Grade as �ɼ�
	from CourseSelection
	inner join Course
	on Course.CourseCode = CourseSelection.CourseCode
	where Grade is not NULL
		and StudentNo = @ID;
end
go


-- ����ѧ�ֺ���
go
create function CalCredit
(
	@ID char(10)
)
returns decimal(6,2)
as
begin
	declare @Credit decimal(6,2);
	select
		@Credit = sum(CreditHour)
	from CourseSelection
	inner join Course
		on Course.CourseCode = CourseSelection.CourseCode
	where StudentNo = @ID
		and CourseSelection.Grade is not NULL;
	if (@Credit is NULL)
		return 0;
	return @Credit;
end
go


-- ����ƽ��ѧ�ּ�����
go
create function CalAvgGrade
(
	@ID char(10)
)
returns decimal(6,2)
as
begin
	declare @Credit decimal(6,2);
	declare @AvgScore decimal(6,2);
	select @Credit = [dbo].[CalCredit](@ID);
	if(@Credit = 0)
	begin
		return NULL;
	end
	select 
		@AvgScore = sum(Grade * CreditHour)/@Credit
	from CourseSelection
	inner join Course
	on Course.CourseCode = CourseSelection.CourseCode
	where StudentNo = @ID;
	return @AvgScore;
end
go


-- ѧ���ɼ�ͳ����Ϣ
go
create procedure StuGradeStatics
	@ID char(10)
as
begin
	select
		[dbo].[CalCredit](@ID) as ��ѧ��,
		[dbo].[CalAvgGrade](@ID) as ƽ��ѧ�ּ�;
end
go




/*  ��ʦ����  */

-- ��ʦ��Ϣ
go
create view TeacherInfo
as
select
	TeacherNo as ��ʦ���,
	TeacherName as ��ʦ����,
	CollegeName as ѧԺ,
	Major as רҵ,
	Gender as �Ա�,
	Title as ְ��,
	Degree as ѧλ,
	PoliticsStatus as ������ò,
	NativePlace as ����,
	Tel as �绰,
	Mail as ����
from Teacher
inner join College
on Teacher.CollegeCode = College.CollegeCode;
go


-- �γ���Ϣ
go
create procedure TeacherCour
	@ID char(10)
as
begin
	select
		CourseCode as �γ̴���,
		CourseName as �γ�����,
		CourseType as �γ�����,
		CreditHour as ѧ��,
		case AvailableMark when 0 then '����ѡ' else '��ѡ' end as ��ǰ�Ƿ��ѡ
	from Course
	where TeacherNo = @ID;
end
go


-- �γ���Ϣ���
go
create procedure TeacherCourCheck
	@ID char(10), @Code char(9)
as
begin
	select
		CourseCode as �γ̴���,
		CourseName as �γ�����,
		CourseType as �γ�����,
		CreditHour as ѧ��,
		case AvailableMark when 0 then '����ѡ' else '��ѡ' end as ��ǰ�Ƿ��ѡ
	from Course
	where TeacherNo = @ID and CourseCode = @Code;
end
go


-- ��ʦ�ɼ�¼��
go
create procedure TeacherGrade
	@ID char(10)
as
begin
	select
		Course.CourseCode as �γ̴���,
		CourseName as �γ�����,
		CourseSelection.StudentNo as ѧ��ѧ��,
		StudentName as ѧ������
	from CourseSelection
	inner join Course
		on CourseSelection.CourseCode = Course.CourseCode
	inner join Student
		on Student.StudentNo = CourseSelection.StudentNo
	where TeacherNo = @ID and Grade is NULL;
end
go


-- ��ʦ�ɼ�¼����
go
create procedure TeacherGradeCheck
	@ID char(10) , @No char(10), @code char(9)
as
begin
	select
		Course.CourseCode as �γ̴���,
		CourseName as �γ�����,
		CourseSelection.StudentNo as ѧ��ѧ��,
		StudentName as ѧ������
	from CourseSelection
	inner join Course
		on CourseSelection.CourseCode = Course.CourseCode
	inner join Student
		on Student.StudentNo = CourseSelection.StudentNo
	where TeacherNo = @ID and Grade is NULL
		and Student.StudentNo = @No
		and Course.CourseCode = @code;
end
go



/*  ����Ա����  */

-- ѧ����Ϣ
go
create view AdmiStuInfo
as
select
	StudentNo as ѧ��,
	StudentName as ����,
	CollegeName as ѧԺ,
	Gender as �Ա�,
	PoliticsStatus as ������ò
from Student
inner join College
on Student.CollegeCode = College.CollegeCode;
go


-- ��ʦ��Ϣ
go
create view AdmiTeaInfo
as
select
	TeacherNo as ��ʦ���,
	TeacherName as ��ʦ����,
	CollegeName as ѧԺ,
	Gender as �Ա�,
	Title as ְ��,
	Degree as ѧλ
from Teacher
inner join College
on Teacher.CollegeCode = College.CollegeCode;
go






/*  ������������  */

-- ѧԺ
insert into College values ('01','�ѧԺ',1);
insert into College values ('02','����ѧԺ',1);
insert into College values ('03','��е�복��ѧԺ',1);
insert into College values ('04','���ѧԺ',1);
insert into College values ('05','��Ϣ�����ѧԺ',1);
insert into College values ('06','�Զ���ѧԺ',1);
insert into College values ('07','�����ѧԺ',1);
insert into College values ('16','����ѧԺ',1);
insert into College values ('17','��ѧ��ͳ��ѧԺ',1);
insert into College values ('18','����ѧԺ',1);
insert into College values ('19','��ѧ�뻯��ѧԺ',1);
insert into College values ('20','����ѧԺ',1);
insert into College values ('21','�����뾭��ѧԺ',1);
insert into College values ('22','����������ѧѧԺ',1);
insert into College values ('23','���˼����ѧԺ',1);
insert into College values ('24','��ѧԺ',1);
insert into College values ('25','�����ѧԺ',1);
insert into College values ('26','���������ѧԺ',1);


-- ����Ա�˻�����

insert into AccountAdministrator values
	('ZXL','6D3A20FFEAF0CCD173E257BDA19EC772','��С��','��','1971-07-02','01068914907','zhaoxl@bit.edu.cn');
-- ��¼����ZXL
-- ���룺ZXL197107





/*  Ԥ�Ʋ�������  */

insert into Student values
	('1120161918','���ַ�','07','�������','��','1998-02-28','2016-08-25','������Ա','�Ĵ��ɶ�','13980141583','290034733@qq.com');
insert into AccountStudent values('1120161918','E10ADC3949BA59ABBE56E057F20F883E');


insert into Teacher values
	('6220052324','����','17','��','��ʦ','��ѧ��ʿ','Ӧ����ѧ','�й���Ա','����','15882393456','shenl@bit.edu.cn');
insert into AccountTecher values('6220052324','E10ADC3949BA59ABBE56E057F20F883E');


insert into Course values
	('100172103','������ѧ������','��������','6220052324',6,0);

insert into Course values
	('100081022','������ѧ������','��������','6220052324',6,1);

insert into Course values
	('100172105','���Դ���A','��������','6220052324',3.5,1);


insert into CourseSelection values('1120161918','100172103',93);
insert into CourseSelection values('1120161918','100081022',NULL);




