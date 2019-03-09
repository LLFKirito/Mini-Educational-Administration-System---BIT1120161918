unit Window_Administrator_AddStu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, pngimage, Buttons, Link, DBlink,IdHashMessageDigest;

type
  TAdministrator_AddStu = class(TForm)
    Label_welcome: TLabel;
    Image_bg: TImage;
    BitBtn_Menu2: TBitBtn;
    BitBtn_Menu3: TBitBtn;
    BitBtn_Menu4: TBitBtn;
    BitBtn_Menu5: TBitBtn;
    BitBtn_Menu1: TBitBtn;
    BitBtn_Logout: TBitBtn;
    BitBtn_Change: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    DateTimePicker1: TDateTimePicker;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    DateTimePicker2: TDateTimePicker;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
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
  Administrator_AddStu: TAdministrator_AddStu;

implementation
uses
  Window_Administrator_AddTea,
  Window_Administrator_ModStu,
  Window_Administrator_ModTea,
  Window_Login;
{$R *.dfm}

function MD5(aValue: string): string;
begin
  with TIdHashMessageDigest5.Create do
  begin
    MD5:= HashStringAsHex(aValue);
    Free;
  end;
end;

procedure TAdministrator_AddStu.BitBtn_ChangeClick(Sender: TObject);
var
  Name : String;
  ID : String;
  Gen :String;
  Poli : String;
  CollNUM : integer;
  Colle : String;
  Major : String;
  Birth : String;
  Roll : String;
  Tel : String;
  Emai : String;
  Place : String;
  len : longint;
  x : longint;
  code : integer;
begin
  Name := Edit1.Text;
  ID := Edit2.Text;
  Gen := ComboBox1.items[combobox1.ItemIndex];
  Poli := ComboBox2.items[combobox1.ItemIndex];
  CollNUM := ComboBox3.ItemIndex;
  Major := Edit3.Text;
  Birth := datetimetostr(DateTimePicker1.DateTime);
  Roll := datetimetostr(DateTimePicker2.DateTime);
  Tel := Edit4.Text;
  Emai := Edit5.Text;
  Place := Edit6.Text;

  {输入控制}
  len := length(ID);
  if (len <> 10) then
  begin
    showmessage('学号必须为10位数字');
    exit;
  end;
  {
  val(ID,x,code);
  if (code <> 0) then
  begin
    showmessage('学号必须为10位数字');
    exit;
  end;
  }

  len := length(Name);
  if (len > 16) then
  begin
    showmessage('姓名长度超过限制');
    exit;
  end
  else if (len = 0) then
  begin
    showmessage('请输入姓名');
    exit;
  end;

  if(ComboBox1.ItemIndex = -1) then
  begin
    showmessage('请选择性别');
    exit;
  end;

  if(ComboBox2.ItemIndex = -1) then
  begin
    showmessage('请选择政治面貌');
    exit;
  end;

  if(ComboBox3.ItemIndex = -1) then
  begin
    showmessage('请选择学院');
    exit;
  end;

  len := length(Major);
  if (len > 30) then
  begin
    showmessage('专业长度超过限制');
    exit;
  end
  else if (len = 0) then
  begin
    showmessage('请输入专业');
    exit;
  end;

  len := length(Tel);
  if (len <> 11) then
  begin
    showmessage('电话号码必须为11位数字');
    exit;
  end;

  len := length(Emai);
  if (len > 30) then
  begin
    showmessage('邮箱长度超过限制');
    exit;
  end
  else if (len = 0) then
  begin
    showmessage('请输入邮箱');
    exit;
  end;

  len := length(Place);
  if (len > 50) then
  begin
    showmessage('籍贯长度超过限制');
    exit;
  end
  else if (len = 0) then
  begin
    showmessage('请输入籍贯');
    exit;
  end;

  DataModule1.ADOQuery2.SQL.Text := 'select * from Student where StudentNo = :ID;';
  DataModule1.ADOQuery2.Parameters.ParamByName('ID').Value := ID;
  DataModule1.ADOQuery2.Open;
  if DataModule1.ADOQuery2.IsEmpty then
  begin
  end
  else
  begin
    showmessage('该学号已经存在');
    exit;
  end;

  if (CollNUM = 0) then
  begin
    Colle := '01';
  end
  else if (CollNUM = 1) then
  begin
    Colle := '02';
  end
  else if (CollNUM = 2) then
  begin
    Colle := '03';
  end
  else if (CollNUM = 3) then
  begin
    Colle := '04';
  end
  else if (CollNUM = 4) then
  begin
    Colle := '05';
  end
  else if (CollNUM = 5) then
  begin
    Colle := '06';
  end
  else if (CollNUM = 6) then
  begin
    Colle := '07';
  end
  else if (CollNUM = 7) then
  begin
    Colle := '16';
  end
  else if (CollNUM = 8) then
  begin
    Colle := '17';
  end
  else if (CollNUM = 9) then
  begin
    Colle := '18';
  end
  else if (CollNUM = 10) then
  begin
    Colle := '19';
  end
  else if (CollNUM = 11) then
  begin
    Colle := '20';
  end
  else if (CollNUM = 12) then
  begin
    Colle := '21';
  end
  else if (CollNUM = 13) then
  begin
    Colle := '22';
  end
  else if (CollNUM = 14) then
  begin
    Colle := '23';
  end
  else if (CollNUM = 15) then
  begin
    Colle := '24';
  end
  else if (CollNUM = 16) then
  begin
    Colle := '25';
  end
  else if (CollNUM = 17) then
  begin
    Colle := '26';
  end;

  DataModule1.ADOQuery1.SQL.Text := 'insert into Student values(:No,:Na,:Co,:Ma,:Ge,:Bi,:En,:Po,:Nat,:Tel,:Mail);';
  DataModule1.ADOQuery1.Parameters.ParamByName('No').Value := ID;
  DataModule1.ADOQuery1.Parameters.ParamByName('Na').Value := Name;
  DataModule1.ADOQuery1.Parameters.ParamByName('Co').Value := Colle;
  DataModule1.ADOQuery1.Parameters.ParamByName('Ma').Value := Major;
  DataModule1.ADOQuery1.Parameters.ParamByName('Ge').Value := Gen;
  DataModule1.ADOQuery1.Parameters.ParamByName('Bi').Value := Birth;
  DataModule1.ADOQuery1.Parameters.ParamByName('En').Value := Roll;
  DataModule1.ADOQuery1.Parameters.ParamByName('Po').Value := Poli;
  DataModule1.ADOQuery1.Parameters.ParamByName('Nat').Value := Place;
  DataModule1.ADOQuery1.Parameters.ParamByName('Tel').Value := Tel;
  DataModule1.ADOQuery1.Parameters.ParamByName('Mail').Value := Emai;
  DataModule1.ADOQuery1.ExecSQL;

  DataModule1.ADOQuery1.SQL.Text := 'insert into AccountStudent values(:No,:Ci);';
  DataModule1.ADOQuery1.Parameters.ParamByName('No').Value := ID;
  DataModule1.ADOQuery1.Parameters.ParamByName('Ci').Value := MD5('123456');
  DataModule1.ADOQuery1.ExecSQL;

  showmessage('学生录入成功');

  Administrator_AddStu.Edit1.Text;
  Administrator_AddStu.Edit2.Text;
  Administrator_AddStu.ComboBox1.ItemIndex := -1;
  Administrator_AddStu.ComboBox2.ItemIndex := -1;
  Administrator_AddStu.ComboBox3.ItemIndex := -1;
  Administrator_AddStu.Edit3.Clear;
  Administrator_AddStu.Edit4.Clear;
  Administrator_AddStu.Edit5.Clear;
  Administrator_AddStu.Edit6.Clear;
end;

procedure TAdministrator_AddStu.BitBtn_LogoutClick(Sender: TObject);
begin
  Login.Login_Edit_UserName.Clear;
  Login.Login_Edit_Password.Clear;
  Login.Login_ComboBox_Roles.ItemIndex := -1;
  self.Hide;
  links.Login.Show;
end;

procedure TAdministrator_AddStu.BitBtn_Menu1Click(Sender: TObject);
begin
  self.Hide;
  links.Administrator_Main.Show;
end;

procedure TAdministrator_AddStu.BitBtn_Menu2Click(Sender: TObject);
begin
  Administrator_AddStu.Edit1.Text;
  Administrator_AddStu.Edit2.Text;
  Administrator_AddStu.ComboBox1.ItemIndex := -1;
  Administrator_AddStu.ComboBox2.ItemIndex := -1;
  Administrator_AddStu.ComboBox3.ItemIndex := -1;
  Administrator_AddStu.Edit3.Clear;
  Administrator_AddStu.Edit4.Clear;
  Administrator_AddStu.Edit5.Clear;
  Administrator_AddStu.Edit6.Clear;
  self.Hide;
  links.Administrator_AddStu.Show;
end;

procedure TAdministrator_AddStu.BitBtn_Menu3Click(Sender: TObject);
begin
  Administrator_AddTea.Edit1.Text;
  Administrator_AddTea.Edit2.Text;
  Administrator_AddTea.ComboBox1.ItemIndex := -1;
  Administrator_AddTea.ComboBox2.ItemIndex := -1;
  Administrator_AddTea.ComboBox3.ItemIndex := -1;
  Administrator_AddTea.Edit3.Clear;
  Administrator_AddTea.Edit4.Clear;
  Administrator_AddTea.Edit5.Clear;
  Administrator_AddTea.Edit6.Clear;
  Administrator_AddTea.Edit7.Clear;
  Administrator_AddTea.Edit8.Clear;
  self.Hide;
  links.Administrator_AddTea.Show;
end;

procedure TAdministrator_AddStu.BitBtn_Menu4Click(Sender: TObject);
begin
  DataModule1.ADOQuery1.SQL.Text := 'select * from AdmiStuInfo';
  DataModule1.ADOQuery1.Open;
  Administrator_ModTea.Edit1.Clear;
  self.Hide;
  links.Administrator_ModStu.Show;
end;

procedure TAdministrator_AddStu.BitBtn_Menu5Click(Sender: TObject);
begin
  DataModule1.ADOQuery1.SQL.Text := 'select * from AdmiTeaInfo';
  DataModule1.ADOQuery1.Open;
  Administrator_ModStu.Edit1.Clear;
  self.Hide;
  links.Administrator_ModTea.Show;
end;

end.

