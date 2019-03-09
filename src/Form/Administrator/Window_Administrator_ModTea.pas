unit Window_Administrator_ModTea;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, pngimage, Buttons, Link, DBlink, Grids,
  DBGrids, IdHashMessageDigest;

type
  TAdministrator_ModTea = class(TForm)
    Label_welcome: TLabel;
    Image_bg: TImage;
    BitBtn_Menu2: TBitBtn;
    BitBtn_Menu3: TBitBtn;
    BitBtn_Menu4: TBitBtn;
    BitBtn_Menu5: TBitBtn;
    BitBtn_Menu1: TBitBtn;
    BitBtn_Logout: TBitBtn;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    procedure BitBtn_LogoutClick(Sender: TObject);
    procedure BitBtn_Menu1Click(Sender: TObject);
    procedure BitBtn_Menu2Click(Sender: TObject);
    procedure BitBtn_Menu3Click(Sender: TObject);
    procedure BitBtn_Menu4Click(Sender: TObject);
    procedure BitBtn_Menu5Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Administrator_ModTea: TAdministrator_ModTea;

implementation
uses
  Window_Administrator_AddStu,
  Window_Administrator_ModStu,
  Window_Administrator_AddTea,
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


procedure TAdministrator_ModTea.BitBtn1Click(Sender: TObject);
begin
  DataModule1.ADOQuery2.SQL.Text := 'select * from AccountTecher where UserName = :ID;';
  DataModule1.ADOQuery2.Parameters.ParamByName('ID').Value := Edit1.Text;
  DataModule1.ADOQuery2.Open;
  if DataModule1.ADOQuery2.IsEmpty then
  begin
    showmessage('教师编号错误');
    exit;
  end;
  DataModule1.ADOQuery2.SQL.Text := 'update AccountTecher set Cipher = :Ci where UserName = :ID;';
  DataModule1.ADOQuery2.Parameters.ParamByName('ID').Value := Edit1.Text;
  DataModule1.ADOQuery2.Parameters.ParamByName('Ci').Value := MD5('123456');
  DataModule1.ADOQuery2.ExecSQL;
  showmessage('重置成功');
end;

procedure TAdministrator_ModTea.BitBtn_LogoutClick(Sender: TObject);
begin
  Login.Login_Edit_UserName.Clear;
  Login.Login_Edit_Password.Clear;
  Login.Login_ComboBox_Roles.ItemIndex := -1;
  self.Hide;
  links.Login.Show;
end;

procedure TAdministrator_ModTea.BitBtn_Menu1Click(Sender: TObject);
begin
  self.Hide;
  links.Administrator_Main.Show;
end;

procedure TAdministrator_ModTea.BitBtn_Menu2Click(Sender: TObject);
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

procedure TAdministrator_ModTea.BitBtn_Menu3Click(Sender: TObject);
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

procedure TAdministrator_ModTea.BitBtn_Menu4Click(Sender: TObject);
begin
  DataModule1.ADOQuery1.SQL.Text := 'select * from AdmiStuInfo';
  DataModule1.ADOQuery1.Open;
  Administrator_ModTea.Edit1.Clear;
  self.Hide;
  links.Administrator_ModStu.Show;
end;

procedure TAdministrator_ModTea.BitBtn_Menu5Click(Sender: TObject);
begin
  DataModule1.ADOQuery1.SQL.Text := 'select * from AdmiTeaInfo';
  DataModule1.ADOQuery1.Open;
  Administrator_ModStu.Edit1.Clear;
  self.Hide;
  links.Administrator_ModTea.Show;
end;

end.

