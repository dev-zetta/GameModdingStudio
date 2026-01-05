unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TPluginForm = class(TForm)
    Image1: TImage;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PluginForm: TPluginForm = nil;

implementation

{$R *.dfm}

var
  SourceWindow: PDWORD;  // Pointer to WindowHandle, needs to be updated

type
  PPluginInfo = ^TPluginInfo;
  TPluginInfo = Record
    Name: PChar;
    KitVersion: PChar;
    Version: PChar;
    Author: PChar;
    Description: PChar;
    ShowInMenu: Boolean;
    MenuCaption: PChar;
  end;

function PluginGetInfo (const PluginInfo: PPluginInfo): Boolean; stdcall;
begin
  with PluginInfo^ do
  begin
    Name:= 'Delphi Example';
    KitVersion:= '1.0';
    Version:= '2.0';
    Author:= 'Crypton';
    Description:= 'Description of Example plugin';
    ShowInMenu:= True;
    MenuCaption:= 'DelphiExample';
  end;
end;

function PluginCreateWindow(const WindowHandle: PDWORD): Boolean; stdcall;
begin
  PluginForm:= TPluginForm.Create(nil);
  if PluginForm <> nil then
  begin
    PluginForm.Show;
    WindowHandle^:= PluginForm.Handle;
    SourceWindow:= WindowHandle;
    Result:= True;
  end
    else
  begin
    WindowHandle^:= 0;
    SourceWindow:= nil;
    Result:= False;
  end;
end;

function PluginDestroyWindow():Boolean; stdcall;
begin
  if SourceWindow <> nil then
  SourceWindow^:= 0;

  //PluginForm.Close;
  PluginForm.Destroy;
end;

procedure TPluginForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  if SourceWindow <> nil then
  SourceWindow^:= 0;
end;

exports
  PluginGetInfo,
  PluginCreateWindow,
  PluginDestroyWindow;


end.
 