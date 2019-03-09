unit Link;

interface

uses
  Classes, Forms;

type
  TLink = class(TObject)
  public
    Login: ^TForm;
    PasswordCg : ^TForm;

    Student_Main: ^TForm;
    Student_Info: ^TForm;
    Student_Course: ^TForm;
    Student_Select: ^TForm;
    Student_Grade: ^TForm;

    Teacher_Main: ^TForm;
    Teacher_Info: ^TForm;
    Teacher_AddC: ^TForm;
    Teacher_Course: ^TForm;
    Teacher_Grade: ^TForm;

    Administrator_Main: ^TForm;
    Administrator_AddStu: ^TForm;
    Administrator_AddTea: ^TForm;
    Administrator_ModStu: ^TForm;
    Administrator_ModTea: ^TForm;
  end;

var
  links: TLink;


implementation

end.
