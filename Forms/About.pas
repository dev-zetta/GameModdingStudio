unit About;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    Label1: TLabel;
    LblVersion: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}
uses
  Main;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  LblVersion.Caption:=APP_VERSION;
end;

end.
 
