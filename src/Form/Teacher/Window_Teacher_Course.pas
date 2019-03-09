unit Window_Teacher_Course;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, pngimage, Buttons, Link, DBlink, Grids,
  DBGrids;

type
  TTeacher_Course = class(TForm)
    Label_welcome: TLabel;
    Image_bg: TImage;
    BitBtn_Menu2: TBitBtn;
    BitBtn_Menu3: TBitBtn;
    BitBtn_Menu4: TBitBtn;
    BitBtn_Menu5: TBitBtn;
    BitBtn_Menu1: TBitBtn;
    BitBtn_Logout: TBitBtn;
    BitBtn_Change: TBitBtn;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    procedure BitBtn_LogoutClick(Sender: TObject);
    procedure BitBtn_Menu1Click(Sender: TObject);
    procedure BitBtn_Menu2Click(Sender: TObject);
    procedure BitBtn_Menu3Click(Sender: TObject);
    procedure BitBtn_Menu4Click(Sender: TObject);
    procedure BitBtn_Menu5Click(Sender: TObject);
    procedure BitBtn_ChangeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Teacher_Course: TTeacher_Course;

implementation
uses
  Window_Teacher_AddC,
  Window_Teacher_Grade,
  Window_Teacher_Info,
  Window_Login;
{$R *.dfm}

procedure TTeacher_Course.BitBtn_ChangeClick(Sender: TObject);
var course : String;
begin
  course := Edit1.Text;

  {输入控制}
  DataModule1.ADOQuery2.SQL.Text := 'execute TeacherCourCheck :Us , :Co';
  DataModule1.ADOQuery2.Parameters.ParamByName('Us').Value := DBlink.ID;
  DataModule1.ADOQuery2.Parameters.ParamByName('Co').Value := course;
  DataModule1.ADOQuery2.Open;
  if DataModule1.ADOQuery2.IsEmpty then
  begin
    showmessage('非法课程代码');
    exit;
  end;

  DataModule1.ADOQuery2.SQL.Text := 'update Course set AvailableMark = 0 where CourseCode = :Co;';
  DataModule1.ADOQuery2.Parameters.ParamByName('Co').Value := course;
  DataModule1.ADOQuery2.ExecSQL;
  showmessage('关闭选课成功');

  Edit1.Clear;
  DataModule1.ADOQuery1.SQL.Text := 'execute TeacherCour :Us';
  DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := DBlink.ID;
  DataModule1.ADOQuery1.Open;
end;

procedure TTeacher_Course.BitBtn_LogoutClick(Sender: TObject);
begin
  Login.Login_Edit_UserName.Clear;
  Login.Login_Edit_Password.Clear;
  Login.Login_ComboBox_Roles.ItemIndex := -1;
  self.Hide;
  links.Login.Show;
end;

procedure TTeacher_Course.BitBtn_Menu1Click(Sender: TObject);
begin
  self.Hide;
  links.Teacher_Main.Show;
end;

procedure TTeacher_Course.BitBtn_Menu2Click(Sender: TObject);
begin
  DataModule1.ADOQuery1.SQL.Text := 'select * from TeacherInfo where 教师编号 = :Us';
  DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := DBlink.ID;
  DataModule1.ADOQuery1.Open;
  Teacher_Info.Label1.Caption := DataModule1.ADOQuery1.fields[1].AsString;
  Teacher_Info.Label2.Caption := DataModule1.ADOQuery1.fields[0].AsString;
  Teacher_Info.Label3.Caption := DataModule1.ADOQuery1.fields[4].AsString;
  Teacher_Info.Label4.Caption := DataModule1.ADOQuery1.fields[7].AsString;
  Teacher_Info.Label5.Caption := DataModule1.ADOQuery1.fields[2].AsString;
  Teacher_Info.Label6.Caption := DataModule1.ADOQuery1.fields[5].AsString;
  Teacher_Info.Label7.Caption := DataModule1.ADOQuery1.fields[6].AsString;
  Teacher_Info.Label8.Caption := DataModule1.ADOQuery1.fields[3].AsString;
  Teacher_Info.Label9.Caption := DataModule1.ADOQuery1.fields[9].AsString;
  Teacher_Info.Label10.Caption := DataModule1.ADOQuery1.fields[10].AsString;
  Teacher_Info.Label11.Caption := DataModule1.ADOQuery1.fields[8].AsString;
  self.Hide;
  links.Teacher_Info.Show;
end;

procedure TTeacher_Course.BitBtn_Menu3Click(Sender: TObject);
begin
  Teacher_AddC.Edit1.Clear;
  Teacher_AddC.Edit2.Clear;
  Teacher_AddC.ComboBox1.ItemIndex := -1;
  Teacher_AddC.Edit4.Clear;
  self.Hide;
  links.Teacher_AddC.Show;
end;

procedure TTeacher_Course.BitBtn_Menu4Click(Sender: TObject);
begin
  Teacher_Course.Edit1.Clear;
  DataModule1.ADOQuery1.SQL.Text := 'execute TeacherCour :Us';
  DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := DBlink.ID;
  DataModule1.ADOQuery1.Open;
  self.Hide;
  links.Teacher_Course.Show;
end;

procedure TTeacher_Course.BitBtn_Menu5Click(Sender: TObject);
begin
  Teacher_Grade.Edit1.Clear;
  Teacher_Grade.Edit2.Clear;
  Teacher_Grade.Edit3.Clear;
  DataModule1.ADOQuery1.SQL.Text := 'execute TeacherGrade :Us';
  DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := DBlink.ID;
  DataModule1.ADOQuery1.Open;
  self.Hide;
  links.Teacher_Grade.Show;
end;

end.
