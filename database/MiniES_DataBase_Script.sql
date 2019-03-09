create database MiniEduSystem;
use MiniEduSystem;


/*  学院  */
create table College
(
	CollegeCode         char(2)      NOT NULL,
	CollegeName         varchar(30)  NOT NULL,
	Flag				int          NOT NULL,

	primary key (CollegeCode)
);


/*  教师  */
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


/*  学生  */
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


/*  课程  */
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


/*  选课表  */
create table CourseSelection
(
	StudentNo           char(10)     NOT NULL,
	CourseCode          char(9)      NOT NULL, 
	Grade               decimal(5,1),

	primary key (StudentNo,CourseCode),
	foreign key (StudentNo) references Student(StudentNo),
	foreign key (CourseCode) references Course(CourseCode)
);


/*  管理员账户  */
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


/*  教师账户  */
create table AccountTecher
(
	UserName            char(10)     NOT NULL,
	Cipher              char(32)     NOT NULL,

	primary key (UserName),
	foreign key (UserName) references Teacher(TeacherNo)
);


/*  学生账户  */
create table AccountStudent
(
	UserName            char(10)     NOT NULL,
	Cipher              char(32)     NOT NULL,

	primary key (UserName),
	foreign key (UserName) references Student(StudentNo)
);




/*  触发器  */
go
create trigger 性别限制 on Student
after insert
as
begin
	declare @Gender char(2);
	select @Gender = Gender from inserted;
	if (@Gender <> '男' and @Gender <> '女')
	begin
		rollback transaction;
		raiserror ('性别只能为男或女', 14, 1);
	end
end
go



/*  学生窗口  */

-- 学生信息
go
create view StuInfo
as
select
	StudentNo as 学号,
	StudentName as 姓名,
	CollegeName as 学院,
	Major as 专业,
	Gender as 性别,
	Birthday as 出生日期,
	EnrollmentDate as 入学日期,
	PoliticsStatus as 政治面貌,
	NativePlace as 籍贯,
	Tel as 电话,
	Mail as 邮箱
from Student
inner join College
on Student.CollegeCode = College.CollegeCode;
go


-- 学生课程表
go
create procedure StuCourse
	@ID char(10)
as
begin
	select
		Course.CourseCode as 课程编号,
		Course.CourseName as 课程名称,
		Course.CourseType as 课程类型,
		Teacher.TeacherName as 任课教师,
		Course.CreditHour as 课程学分
	from CourseSelection
	inner join Course
	on CourseSelection.CourseCode = Course.CourseCode
	inner join Teacher
	on Teacher.TeacherNo = Course.TeacherNo
	where Grade is NULL
	      and StudentNo = @ID;
end
go


-- 学生选课表
go
create procedure StuSelect
	@ID char(10)
as
begin
	select
		Course.CourseCode as 课程编号,
		Course.CourseName as 课程名称,
		Course.CourseType as 课程类型,
		Teacher.TeacherName as 任课教师,
		Course.CreditHour as 课程学分
	from Course
	inner join Teacher
	on Teacher.TeacherNo = Course.TeacherNo
	where Course.AvailableMark = 1
		and Course.CourseCode not in
			(select CourseCode from CourseSelection where StudentNo = @ID)
end
go


-- 课程检查
go
create procedure StuSelectCheck
	@ID char(10), @Code char(9)
as
begin
	select
		Course.CourseCode as 课程编号,
		Course.CourseName as 课程名称,
		Course.CourseType as 课程类型,
		Teacher.TeacherName as 任课教师,
		Course.CreditHour as 课程学分
	from Course
	inner join Teacher
	on Teacher.TeacherNo = Course.TeacherNo
	where Course.AvailableMark = 1
		and Course.CourseCode not in
			(select CourseCode from CourseSelection where StudentNo = @ID)
		and Course.CourseCode = @Code;
end
go


-- 学生成绩单
go
create procedure StuGrade
	@ID char(10)
as
begin
	select
		Course.CourseCode as 课程编号,
		Course.CourseName as 课程名称,
		Course.CourseType as 课程类型,
		Course.CreditHour as 课程学分,
		CourseSelection.Grade as 成绩
	from CourseSelection
	inner join Course
	on Course.CourseCode = CourseSelection.CourseCode
	where Grade is not NULL
		and StudentNo = @ID;
end
go


-- 计算学分函数
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


-- 计算平均学分绩函数
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


-- 学生成绩统计信息
go
create procedure StuGradeStatics
	@ID char(10)
as
begin
	select
		[dbo].[CalCredit](@ID) as 总学分,
		[dbo].[CalAvgGrade](@ID) as 平均学分绩;
end
go




/*  教师窗口  */

-- 教师信息
go
create view TeacherInfo
as
select
	TeacherNo as 教师编号,
	TeacherName as 教师姓名,
	CollegeName as 学院,
	Major as 专业,
	Gender as 性别,
	Title as 职称,
	Degree as 学位,
	PoliticsStatus as 政治面貌,
	NativePlace as 籍贯,
	Tel as 电话,
	Mail as 邮箱
from Teacher
inner join College
on Teacher.CollegeCode = College.CollegeCode;
go


-- 课程信息
go
create procedure TeacherCour
	@ID char(10)
as
begin
	select
		CourseCode as 课程代码,
		CourseName as 课程名称,
		CourseType as 课程类型,
		CreditHour as 学分,
		case AvailableMark when 0 then '不可选' else '可选' end as 当前是否可选
	from Course
	where TeacherNo = @ID;
end
go


-- 课程信息检查
go
create procedure TeacherCourCheck
	@ID char(10), @Code char(9)
as
begin
	select
		CourseCode as 课程代码,
		CourseName as 课程名称,
		CourseType as 课程类型,
		CreditHour as 学分,
		case AvailableMark when 0 then '不可选' else '可选' end as 当前是否可选
	from Course
	where TeacherNo = @ID and CourseCode = @Code;
end
go


-- 教师成绩录入
go
create procedure TeacherGrade
	@ID char(10)
as
begin
	select
		Course.CourseCode as 课程代码,
		CourseName as 课程名称,
		CourseSelection.StudentNo as 学生学号,
		StudentName as 学生姓名
	from CourseSelection
	inner join Course
		on CourseSelection.CourseCode = Course.CourseCode
	inner join Student
		on Student.StudentNo = CourseSelection.StudentNo
	where TeacherNo = @ID and Grade is NULL;
end
go


-- 教师成绩录入检查
go
create procedure TeacherGradeCheck
	@ID char(10) , @No char(10), @code char(9)
as
begin
	select
		Course.CourseCode as 课程代码,
		CourseName as 课程名称,
		CourseSelection.StudentNo as 学生学号,
		StudentName as 学生姓名
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



/*  管理员窗口  */

-- 学生信息
go
create view AdmiStuInfo
as
select
	StudentNo as 学号,
	StudentName as 姓名,
	CollegeName as 学院,
	Gender as 性别,
	PoliticsStatus as 政治面貌
from Student
inner join College
on Student.CollegeCode = College.CollegeCode;
go


-- 教师信息
go
create view AdmiTeaInfo
as
select
	TeacherNo as 教师编号,
	TeacherName as 教师姓名,
	CollegeName as 学院,
	Gender as 性别,
	Title as 职称,
	Degree as 学位
from Teacher
inner join College
on Teacher.CollegeCode = College.CollegeCode;
go






/*  必须插入的数据  */

-- 学院
insert into College values ('01','宇航学院',1);
insert into College values ('02','机电学院',1);
insert into College values ('03','机械与车辆学院',1);
insert into College values ('04','光电学院',1);
insert into College values ('05','信息与电子学院',1);
insert into College values ('06','自动化学院',1);
insert into College values ('07','计算机学院',1);
insert into College values ('16','材料学院',1);
insert into College values ('17','数学与统计学院',1);
insert into College values ('18','物理学院',1);
insert into College values ('19','化学与化工学院',1);
insert into College values ('20','生命学院',1);
insert into College values ('21','管理与经济学院',1);
insert into College values ('22','人文与社会科学学院',1);
insert into College values ('23','马克思主义学院',1);
insert into College values ('24','法学院',1);
insert into College values ('25','外国语学院',1);
insert into College values ('26','设计与艺术学院',1);


-- 管理员账户密码

insert into AccountAdministrator values
	('ZXL','6D3A20FFEAF0CCD173E257BDA19EC772','赵小林','男','1971-07-02','01068914907','zhaoxl@bit.edu.cn');
-- 登录名：ZXL
-- 密码：ZXL197107





/*  预制测试数据  */

insert into Student values
	('1120161918','李林峰','07','软件工程','男','1998-02-28','2016-08-25','共青团员','四川成都','13980141583','290034733@qq.com');
insert into AccountStudent values('1120161918','E10ADC3949BA59ABBE56E057F20F883E');


insert into Teacher values
	('6220052324','沈良','17','男','讲师','理学博士','应用数学','中共党员','北京','15882393456','shenl@bit.edu.cn');
insert into AccountTecher values('6220052324','E10ADC3949BA59ABBE56E057F20F883E');


insert into Course values
	('100172103','工科数学分析Ⅰ','基础必修','6220052324',6,0);

insert into Course values
	('100081022','工科数学分析Ⅱ','基础必修','6220052324',6,1);

insert into Course values
	('100172105','线性代数A','基础必修','6220052324',3.5,1);


insert into CourseSelection values('1120161918','100172103',93);
insert into CourseSelection values('1120161918','100081022',NULL);




