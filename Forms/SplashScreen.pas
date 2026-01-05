unit SplashScreen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,WAVPlayer, ComCtrls, StdCtrls;//,ProgressBarEx;

type
  TSplashForm = class(TForm)
    procedure FormCreate(Sender: TObject);
   //procedure DrawSplash();
    procedure FormPaint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SplashForm: TSplashForm;

implementation

{$R *.dfm}

var
  SplashImg:TBitmap;
  //ProgressBar:TProgressBarEx;

procedure TSplashForm.FormActivate(Sender: TObject);
var
  i:LongWord;
begin
(*
  ProgressBar.Parent:=SplashForm;
  ProgressBar.MaxPosition:=100;
  for i := 1 to 100 do
  begin
    ProgressBar.Refresh;
    ProgressBar.Position:=i;
    //Application.ProcessMessages;
    Sleep(15);
  end;
  *)

  for i := 1 to 100 do
  begin
    Application.ProcessMessages;
    Sleep(10);
  end;
end;

procedure TSplashForm.FormCreate(Sender: TObject);
begin
  SplashImg := TBitmap.Create;
  SplashImg.LoadFromFile('Data\splash.bmp');
  //PlayWAVFile('Data\splash.wav');
  
  DoubleBuffered:=True;
  Width:=SplashImg.Width;
  Height:=SplashImg.Height;
  (*
  ProgressBar:=TProgressBarEx.Create(SplashForm);

  ProgressBar.Top:=280;
  ProgressBar.Left:=120;

  ProgressBar.Width:=150;
  ProgressBar.Height:=15;
  *)
end;

procedure TSplashForm.FormPaint(Sender: TObject);
begin
  SplashForm.Canvas.Draw(0,0,SplashImg);
end;

end.
