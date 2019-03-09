unit Window_Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls, Grids, DBGrids, DB, ADODB;

type
  TLogin = class(TForm)
    Login_Edit_UserName: TEdit;
    Login_Lable_UserName: TLabel;
    Login_ComboBox_Roles: TComboBox;
    Login_Label_Password: TLabel;
    Login_Edit_Password: TEdit;
    Login_Button_Log: TButton;
    Login_bg: TImage;
    Login_Label_Role: TLabel;
    procedure Login_Button_LogClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Login: TLogin;



implementation

uses
  IdHashMessageDigest,
  Link,
  DBlink,
  Window_Student_Course,
  Window_Student_Grade,
  Window_Student_Info,
  Window_Student_Main,
  Window_Student_Select,
  Window_Teacher_AddC,
  Window_Teacher_Course,
  Window_Teacher_Grade,
  Window_Teacher_Info,
  Window_Teacher_Main,
  Window_Administrator_AddStu,
  Window_Administrator_AddTea,
  Window_Administrator_Main,
  Window_Administrator_ModStu,
  Window_Administrator_ModTea;

{$R *.dfm}


function MD5(aValue: string): string;
begin
  with TIdHashMessageDigest5.Create do
  begin
    MD5:= HashStringAsHex(aValue);
    Free;
  end;
end;


{点击登录按钮的操作}
procedure TLogin.Login_Button_LogClick(Sender: TObject);
var
  Username : String;
  mode : integer;
  Password_t : String;
  Password : String;

begin
    Username := Login_Edit_UserName.Text;
    mode := Login_ComboBox_Roles.ItemIndex;
    Password_t := Login_Edit_Password.Text;
    Password := MD5(Password_t);

    if (mode = 0) then
    begin
        DataModule1.ADOQuery1.SQL.Text := 'select * from AccountStudent where UserName = :Us and Cipher = :Ch';
        DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := Username;
		    DataModule1.ADOQuery1.Parameters.ParamByName('Ch').Value := Password;
        DataModule1.ADOQuery1.Open;
        if DataModule1.ADOQuery1.IsEmpty then
        begin
          showmessage('无该用户或密码错误');
        end
        else
        begin
          DataModule1.ADOQuery1.SQL.Text := 'select StudentName from Student where StudentNo = :Us';
          DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := Username;
          DataModule1.ADOQuery1.Open;
          DBlink.Name := DataModule1.ADOQuery1.fields[0].AsString;
          DBlink.ID := Username;
          Student_Course.Label_welcome.Caption := DBlink.Name + ',欢迎回来!';
          Student_Grade.Label_welcome.Caption := DBlink.Name + ',欢迎回来!';
          Student_Info.Label_welcome.Caption := DBlink.Name + ',欢迎回来!';
          Student_Main.Label_welcome.Caption := DBlink.Name + ',欢迎回来!';
          Student_Select.Label_welcome.Caption := DBlink.Name + ',欢迎回来!';
          self.Hide;
          links.Student_Main.Show;
        end;
    end
    else if (mode = 1) then
    begin
        DataModule1.ADOQuery1.SQL.Text := 'select * from AccountTecher where UserName = :Us and Cipher = :Ch';
        DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := Username;
		    DataModule1.ADOQuery1.Parameters.ParamByName('Ch').Value := Password;
        DataModule1.ADOQuery1.Open;
        if DataModule1.ADOQuery1.IsEmpty then
        begin
          showmessage('无该用户或密码错误');
        end
        else
        begin
          DataModule1.ADOQuery1.SQL.Text := 'select TeacherName from Teacher where TeacherNo = :Us';
          DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := Username;
          DataModule1.ADOQuery1.Open;
          DBlink.Name := DataModule1.ADOQuery1.fields[0].AsString;
          DBlink.ID := Username;
          Teacher_AddC.Label_welcome.Caption := DBlink.Name + ',欢迎回来!';
          Teacher_Course.Label_welcome.Caption := DBlink.Name + ',欢迎回来!';
          Teacher_Grade.Label_welcome.Caption := DBlink.Name + ',欢迎回来!';
          Teacher_Info.Label_welcome.Caption := DBlink.Name + ',欢迎回来!';
          Teacher_Main.Label_welcome.Caption := DBlink.Name + ',欢迎回来!';
          self.Hide;
          links.Teacher_Main.Show;
        end;
    end
    else if (mode = 2) then
    begin
        DataModule1.ADOQuery1.SQL.Text := 'select * from AccountAdministrator where UserName = :Us and Cipher = :Ch';
        DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := Username;
		    DataModule1.ADOQuery1.Parameters.ParamByName('Ch').Value := Password;
        DataModule1.ADOQuery1.Open;
        if DataModule1.ADOQuery1.IsEmpty then
        begin
          showmessage('无该用户或密码错误');
        end
        else
        begin
          DataModule1.ADOQuery1.SQL.Text := 'select AdministratorName from AccountAdministrator where UserName = :Us';
          DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := Username;
          DataModule1.ADOQuery1.Open;
          DBlink.Name := DataModule1.ADOQuery1.fields[0].AsString;
          DBlink.ID := Username;
          Administrator_AddStu.Label_welcome.Caption := DBlink.Name + ',欢迎回来!';
          Administrator_AddTea.Label_welcome.Caption := DBlink.Name + ',欢迎回来!';
          Administrator_Main.Label_welcome.Caption := DBlink.Name + ',欢迎回来!';
          Administrator_ModStu.Label_welcome.Caption := DBlink.Name + ',欢迎回来!';
          Administrator_ModTea.Label_welcome.Caption := DBlink.Name + ',欢迎回来!';
          self.Hide;
          links.Administrator_Main.Show;
        end;
    end
    else
    begin
      showmessage('请选择角色');
    end;

end;





end.
