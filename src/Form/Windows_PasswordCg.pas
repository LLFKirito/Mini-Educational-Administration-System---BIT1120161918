unit Windows_PasswordCg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls, Buttons, IdHashMessageDigest, Link, DBlink;

type
  TPasswordCg = class(TForm)
    Login_Lable_UserName: TLabel;
    Login_Label_Password: TLabel;
    Login_Label_Role: TLabel;
    Edit4: TEdit;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Login_ComboBox_Roles: TComboBox;
    BitBtn1: TBitBtn;
    Label3: TLabel;
    Image1: TImage;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PasswordCg: TPasswordCg;

implementation
uses
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


procedure TPasswordCg.BitBtn1Click(Sender: TObject);
var
  Username : String;
  mode : integer;
  Old_Password : String;
  New_Password1 : String;
  New_Password2 : String;
begin
  Username := Edit2.Text;
  mode := Login_ComboBox_Roles.ItemIndex;
  Old_Password := Edit3.Text;
  New_Password1 := Edit1.Text;
  New_Password2 := Edit4.Text;

  if (length(New_Password1) < 6) then
  begin
    showmessage('密码长度不得小于6位');
    exit;
  end;

  if (New_Password1 <> New_Password2) then
  begin
    showmessage('两次新密码不一致');
    exit;
  end;

  Old_Password := MD5(Old_Password);
  New_Password1 := MD5(New_Password1);
  New_Password2 := MD5(New_Password2);

  if (mode = 0) then
  begin
        DataModule1.ADOQuery1.SQL.Text := 'select * from AccountStudent where UserName = :Us and Cipher = :Ch';
        DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := Username;
		    DataModule1.ADOQuery1.Parameters.ParamByName('Ch').Value := Old_Password;
        DataModule1.ADOQuery1.Open;
        if DataModule1.ADOQuery1.IsEmpty then
        begin
          showmessage('无该用户或密码错误');
        end
        else
        begin
          DataModule1.ADOQuery1.SQL.Text := 'update AccountStudent set Cipher = :Ci where UserName = :Us';
          DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := Username;
          DataModule1.ADOQuery1.Parameters.ParamByName('Ci').Value := New_Password1;
          DataModule1.ADOQuery1.ExecSQL;
          showmessage('更改成功');

          Login.Login_Edit_Password.Clear;

          links.Student_Main.Hide;
          links.Student_Info.Hide;
          links.Student_Course.Hide;
          links.Student_Select.Hide;
          links.Student_Grade.Hide;
          links.Teacher_Main.Hide;
          links.Teacher_Info.Hide;
          links.Teacher_AddC.Hide;
          links.Teacher_Course.Hide;
          links.Teacher_Grade.Hide;
          links.Administrator_Main.Hide;
          links.Administrator_AddStu.Hide;
          links.Administrator_AddTea.Hide;
          links.Administrator_ModStu.Hide;
          links.Administrator_ModTea.Hide;
          self.Hide;
          links.Login.Show;
        end;
  end
  else if (mode = 1) then
  begin
        DataModule1.ADOQuery1.SQL.Text := 'select * from AccountTecher where UserName = :Us and Cipher = :Ch';
        DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := Username;
		    DataModule1.ADOQuery1.Parameters.ParamByName('Ch').Value := Old_Password;
        DataModule1.ADOQuery1.Open;
        if DataModule1.ADOQuery1.IsEmpty then
        begin
          showmessage('无该用户或密码错误');
        end
        else
        begin
          DataModule1.ADOQuery1.SQL.Text := 'update AccountTecher set Cipher = :Ci where UserName = :Us';
          DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := Username;
          DataModule1.ADOQuery1.Parameters.ParamByName('Ci').Value := New_Password1;
          DataModule1.ADOQuery1.ExecSQL;
          showmessage('更改成功');

          Login.Login_Edit_Password.Clear;

          links.Student_Main.Hide;
          links.Student_Info.Hide;
          links.Student_Course.Hide;
          links.Student_Select.Hide;
          links.Student_Grade.Hide;
          links.Teacher_Main.Hide;
          links.Teacher_Info.Hide;
          links.Teacher_AddC.Hide;
          links.Teacher_Course.Hide;
          links.Teacher_Grade.Hide;
          links.Administrator_Main.Hide;
          links.Administrator_AddStu.Hide;
          links.Administrator_AddTea.Hide;
          links.Administrator_ModStu.Hide;
          links.Administrator_ModTea.Hide;
          self.Hide;
          links.Login.Show;
        end;
  end
  else
  begin
    showmessage('请选择用户角色');
  end;

end;

end.
