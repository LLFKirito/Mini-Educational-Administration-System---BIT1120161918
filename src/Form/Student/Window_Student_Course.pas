unit Window_Student_Course;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, pngimage, Buttons, Link, DBlink, Grids, DBGrids;

type
  TStudent_Course = class(TForm)
    Label_welcome: TLabel;
    Image_bg: TImage;
    BitBtn_Menu2: TBitBtn;
    BitBtn_Menu3: TBitBtn;
    BitBtn_Menu4: TBitBtn;
    BitBtn_Menu5: TBitBtn;
    BitBtn_Menu1: TBitBtn;
    BitBtn_Logout: TBitBtn;
    DBGrid1: TDBGrid;
    procedure BitBtn_Menu2Click(Sender: TObject);
    procedure BitBtn_Menu3Click(Sender: TObject);
    procedure BitBtn_Menu4Click(Sender: TObject);
    procedure BitBtn_Menu5Click(Sender: TObject);
    procedure BitBtn_Menu1Click(Sender: TObject);
    procedure BitBtn_LogoutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Student_Course: TStudent_Course;

implementation


uses
  Window_Student_Grade,
  Window_Student_Info,
  Window_Student_Select,
  Window_Login;
{$R *.dfm}

procedure TStudent_Course.BitBtn_LogoutClick(Sender: TObject);
begin
  Login.Login_Edit_UserName.Clear;
  Login.Login_Edit_Password.Clear;
  Login.Login_ComboBox_Roles.ItemIndex := -1;
  self.Hide;
  links.Login.Show;
end;

procedure TStudent_Course.BitBtn_Menu1Click(Sender: TObject);
begin
  self.Hide;
  links.Student_Main.Show;
end;

procedure TStudent_Course.BitBtn_Menu2Click(Sender: TObject);
begin
  DataModule1.ADOQuery1.SQL.Text := 'select * from StuInfo where Ñ§ºÅ = :Us';
  DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := DBlink.ID;
  DataModule1.ADOQuery1.Open;
  Student_Info.Label1.Caption := DataModule1.ADOQuery1.fields[1].AsString;
  Student_Info.Label2.Caption := DataModule1.ADOQuery1.fields[0].AsString;
  Student_Info.Label3.Caption := DataModule1.ADOQuery1.fields[4].AsString;
  Student_Info.Label4.Caption := DataModule1.ADOQuery1.fields[7].AsString;
  Student_Info.Label5.Caption := DataModule1.ADOQuery1.fields[2].AsString;
  Student_Info.Label6.Caption := DataModule1.ADOQuery1.fields[3].AsString;
  Student_Info.Label7.Caption := DataModule1.ADOQuery1.fields[5].AsString;
  Student_Info.Label8.Caption := DataModule1.ADOQuery1.fields[6].AsString;
  Student_Info.Label9.Caption := DataModule1.ADOQuery1.fields[9].AsString;
  Student_Info.Label10.Caption := DataModule1.ADOQuery1.fields[10].AsString;
  Student_Info.Label11.Caption := DataModule1.ADOQuery1.fields[8].AsString;
  self.Hide;
  links.Student_Info.Show;
end;

procedure TStudent_Course.BitBtn_Menu3Click(Sender: TObject);
begin
  DataModule1.ADOQuery1.SQL.Text := 'execute StuCourse :Us';
  DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := DBlink.ID;
  DataModule1.ADOQuery1.Open;
  self.Hide;
  links.Student_Course.Show;
end;

procedure TStudent_Course.BitBtn_Menu4Click(Sender: TObject);
begin
  Student_Select.Edit1.Clear;
  DataModule1.ADOQuery1.SQL.Text := 'execute StuSelect :Us';
  DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := DBlink.ID;
  DataModule1.ADOQuery1.Open;
  self.Hide;
  links.Student_Select.Show;
end;

procedure TStudent_Course.BitBtn_Menu5Click(Sender: TObject);
begin
  DataModule1.ADOQuery1.SQL.Text := 'execute StuGradeStatics :Us';
  DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := DBlink.ID;
  DataModule1.ADOQuery1.Open;
  Student_Grade.Label1.Caption := DataModule1.ADOQuery1.fields[0].AsString;
  Student_Grade.Label2.Caption := DataModule1.ADOQuery1.fields[1].AsString;
  DataModule1.ADOQuery1.SQL.Text := 'execute StuGrade :Us';
  DataModule1.ADOQuery1.Parameters.ParamByName('Us').Value := DBlink.ID;
  DataModule1.ADOQuery1.Open;
  self.Hide;
  links.Student_Grade.Show;
end;

end.
