program FFEduSystem;

uses
  Forms,
  Link in 'Link.pas',
  Window_Login in 'Form\Window_Login.pas' {Login},
  Windows_PasswordCg in 'Form\Windows_PasswordCg.pas' {PasswordCg},
  Window_Teacher_Course in 'Form\Teacher\Window_Teacher_Course.pas' {Teacher_Course},
  Window_Teacher_Main in 'Form\Teacher\Window_Teacher_Main.pas' {Teacher_Main},
  Window_Teacher_AddC in 'Form\Teacher\Window_Teacher_AddC.pas' {Teacher_AddC},
  Window_Teacher_Info in 'Form\Teacher\Window_Teacher_Info.pas' {Teacher_Info},
  Window_Teacher_Grade in 'Form\Teacher\Window_Teacher_Grade.pas' {Teacher_Grade},
  Window_Student_Course in 'Form\Student\Window_Student_Course.pas' {Student_Course},
  Window_Student_Grade in 'Form\Student\Window_Student_Grade.pas' {Student_Grade},
  Window_Student_Info in 'Form\Student\Window_Student_Info.pas' {Student_Info},
  Window_Student_Main in 'Form\Student\Window_Student_Main.pas' {Student_Main},
  Window_Student_Select in 'Form\Student\Window_Student_Select.pas' {Student_Select},
  Window_Administrator_Main in 'Form\Administrator\Window_Administrator_Main.pas' {Administrator_Main},
  Window_Administrator_ModStu in 'Form\Administrator\Window_Administrator_ModStu.pas' {Administrator_ModStu},
  Window_Administrator_ModTea in 'Form\Administrator\Window_Administrator_ModTea.pas' {Administrator_ModTea},
  Window_Administrator_AddStu in 'Form\Administrator\Window_Administrator_AddStu.pas' {Administrator_AddStu},
  Window_Administrator_AddTea in 'Form\Administrator\Window_Administrator_AddTea.pas' {Administrator_AddTea},
  DBlink in 'DBlink.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TLogin, Login);
  Application.CreateForm(TPasswordCg, PasswordCg);
  Application.CreateForm(TTeacher_AddC, Teacher_AddC);
  Application.CreateForm(TTeacher_Main, Teacher_Main);
  Application.CreateForm(TTeacher_Course, Teacher_Course);
  Application.CreateForm(TTeacher_Info, Teacher_Info);
  Application.CreateForm(TTeacher_Grade, Teacher_Grade);
  Application.CreateForm(TStudent_Course, Student_Course);
  Application.CreateForm(TStudent_Grade, Student_Grade);
  Application.CreateForm(TStudent_Info, Student_Info);
  Application.CreateForm(TStudent_Main, Student_Main);
  Application.CreateForm(TStudent_Select, Student_Select);
  Application.CreateForm(TAdministrator_Main, Administrator_Main);
  Application.CreateForm(TAdministrator_ModStu, Administrator_ModStu);
  Application.CreateForm(TAdministrator_ModTea, Administrator_ModTea);
  Application.CreateForm(TAdministrator_AddStu, Administrator_AddStu);
  Application.CreateForm(TAdministrator_AddTea, Administrator_AddTea);
  Application.CreateForm(TDataModule1, DataModule1);
  links := TLink.Create;
  links.Login := @Login;
  links.PasswordCg := @PasswordCg;
  links.Student_Main := @Student_Main;
  links.Student_Info := @Student_Info;
  links.Student_Course := @Student_Course;
  links.Student_Select := @Student_Select;
  links.Student_Grade := @Student_Grade;
  links.Teacher_Main := @Teacher_Main;
  links.Teacher_Info := @Teacher_Info;
  links.Teacher_AddC := @Teacher_AddC;
  links.Teacher_Course := @Teacher_Course;
  links.Teacher_Grade := @Teacher_Grade;
  links.Administrator_Main := @Administrator_Main;
  links.Administrator_AddStu := @Administrator_AddStu;
  links.Administrator_AddTea := @Administrator_AddTea;
  links.Administrator_ModStu := @Administrator_ModStu;
  links.Administrator_ModTea := @Administrator_ModTea;

  Application.Run;
end.
