unit Window_Teacher_AddC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, pngimage, Buttons, Link, DBlink;

type
  TTeacher_AddC = class(TForm)
    Label_welcome: TLabel;
    Image_bg: TImage;
    BitBtn_Menu2: TBitBtn;
    BitBtn_Menu3: TBitBtn;
    BitBtn_Menu4: TBitBtn;
    BitBtn_Menu5: TBitBtn;
    BitBtn_Menu1: TBitBtn;
    BitBtn_Logout: TBitBtn;
    BitBtn_Change: TBitBtn;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit4: TEdit;
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
  Teacher_AddC: TTeacher_AddC;

implementation
uses
  Window_Teacher_Course,
  Window_Teacher_Grade,
  Window_Teacher_Info,
  Window_Login;

{$R *.dfm}


procedure TTeacher_AddC.BitBtn_ChangeClick(Sender: TObject);
var
  courseID : String;
  courseNa : String;
  courseType :String;
  Credit : String;
  len : longint;
  f : Real;
  x : integer;
  code : integer;
begin
  courseID := Edit1.Text;
  courseNa := Edit2.Text;
  courseType := ComboBox1.items[combobox1.ItemIndex];
  Credit := Edit4.Text;

  {输入控制}
  len := length(courseID);
  if (len <> 9) then
  begin
    showmessage('课程编号必须为9位数字');
    exit;
  end;
  val(courseID,x,code);
  if (code <> 0) then
  begin
    showmessage('课程编号必须为9位数字');
    exit;
  end;

  DataModule1.ADOQuery2.SQL.Text := 'select * from Course where CourseCode = :ID;';
  DataModule1.ADOQuery2.Parameters.ParamByName('ID').Value := courseID;
  DataModule1.ADOQuery2.Open;
  if DataModule1.ADOQuery2.IsEmpty then
  begin
  end
  else
  begin
    showmessage('该课程代码已经存在');
    exit;
  end;

  len := length(courseNa);
  if (len = 0) then
  begin
    showmessage('请输入课程名称');
    exit;
  end
  else if (len > 30) then
  begin
    showmessage('课程名称必须在30字节以内');
    exit;
  end;

  if (ComboBox1.ItemIndex = -1) then
  begin
    showmessage('请选择课程类型');
    exit;
  end;

  f := StrToFloat(Credit);
  if (f>100) or (f<=0) then
  begin
    showmessage('学分输入非法');
    exit;
  end;

  DataModule1.ADOQuery1.SQL.Text := 'insert into Course values(:ID,:Na,:Ty,:Tno,:Cr,1);';
  DataModule1.ADOQuery1.Parameters.ParamByName('ID').Value := courseID;
  DataModule1.ADOQuery1.Parameters.ParamByName('Na').Value := courseNa;
  DataModule1.ADOQuery1.Parameters.ParamByName('Ty').Value := courseType;
  DataModule1.ADOQuery1.Parameters.ParamByName('Tno').Value := DBlink.ID;
  DataModule1.ADOQuery1.Parameters.ParamByName('Cr').Value := Credit;
  DataModule1.ADOQuery1.ExecSQL;
  showmessage('课程录入成功');
  Edit1.Clear;
  Edit2.Clear;
  ComboBox1.ItemIndex := -1;
  Edit4.Clear;
end;

procedure TTeacher_AddC.BitBtn_LogoutClick(Sender: TObject);
begin
  Login.Login_Edit_UserName.Clear;
  Login.Login_Edit_Password.Clear;
  Login.Login_ComboBox_Roles.ItemIndex := -1;
  self.Hide;
  links.Login.Show;
end;

procedure TTeacher_AddC.BitBtn_Menu1Click(Sender: TObject);
begin
  self.Hide;
  links.Teacher_Main.Show;
end;

procedure TTeacher_AddC.BitBtn_Menu2Click(Sender: TObject);
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

procedure TTeacher_AddC.BitBtn_Menu3Click(Sender: TObject);
begin
  Teacher_AddC.Edit1.Clear;
  Teacher_AddC.Edit2.Clear;
  Teacher_AddC.ComboBox1.ItemIndex := -1;
  Teacher_AddC.Edit4.Clear;
  self.Hide;
  links.Teacher_AddC.Show;
end;

procedure TTeacher_AddC.BitBtn_Menu4Click(Sender: TObject);
begin
  Teacher_Course.Edit1.Clear;
  DataModule1.ADOQuery1.SQL.Text := 'execute TeacherCour :Us';
  DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := DBlink.ID;
  DataModule1.ADOQuery1.Open;
  self.Hide;
  links.Teacher_Course.Show;
end;

procedure TTeacher_AddC.BitBtn_Menu5Click(Sender: TObject);
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

