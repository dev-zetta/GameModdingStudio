unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, FileCompare;

type
  TPluginForm = class(TForm)
    lvCompare: TListView;
    GroupBox1: TGroupBox;
    btnOriginalFile: TButton;
    edtOriginalFile: TEdit;
    Label1: TLabel;
    edtChangedFile: TEdit;
    Label2: TLabel;
    btnChangedFile: TButton;
    OpenDialog1: TOpenDialog;
    btnStart: TButton;
    cbEqual: TCheckBox;
    StatusBar1: TStatusBar;
    Label3: TLabel;
    lblDifferentCount: TLabel;
    ProgressBar1: TProgressBar;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOriginalFileClick(Sender: TObject);
    procedure btnChangedFileClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PluginForm: TPluginForm = nil;

implementation

{$R *.dfm}

const
  APP_NAME = 'FileComparer';
  APP_VERSION = 'v1.0';
  APP_AUTHOR = 'Crypton';
  APP_TITLE = APP_NAME + ' ' + APP_VERSION + ' Created by ' + APP_AUTHOR;

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
    Name:= APP_NAME;
    KitVersion:= '1.0';
    Version:= APP_VERSION;
    Author:= APP_AUTHOR;
    Description:= 'This tool is able to find differences between two files';
    ShowInMenu:= True;
    MenuCaption:= APP_NAME;
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

procedure TPluginForm.btnOriginalFileClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  edtOriginalFile.Text:= OpenDialog1.FileName;
end;

procedure TPluginForm.btnChangedFileClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  edtChangedFile.Text:= OpenDialog1.FileName;
end;

procedure ProgressCallback(const Value, MaxValue: DWORD);
begin
  if (Value mod 32) = 0 then
  begin
    PluginForm.ProgressBar1.Max:= MaxValue;
    PluginForm.ProgressBar1.Position:= Value;
    Application.ProcessMessages;
  end;
end;

procedure TPluginForm.btnStartClick(Sender: TObject);
var
  CompareInfo: TCompareInfo;
  CompareEntry: PCompareEntry;
  OriginalFileName, ChangedFileName: String;

  EntryIndex, EntryCount: DWORD;
  Item: TListItem;
begin
  lvCompare.Clear;
  OriginalFileName:= edtOriginalFile.Text;
  ChangedFileName:= edtChangedFile.Text;

  if (Length(OriginalFileName) = 0) then
  begin
    StatusBar1.Panels[1].Text:= 'Original file not selected!';
    Exit;
  end;

  if (Length(ChangedFileName) = 0) then
  begin
    StatusBar1.Panels[1].Text:= 'Changed file not selected!';
    Exit;
  end;

  if not FileExists(OriginalFileName) then
  begin
    StatusBar1.Panels[1].Text:= 'Original file not exists!';
    Exit;
  end;

  if not FileExists(ChangedFileName) then
  begin
    StatusBar1.Panels[1].Text:= 'Changed file not exists!';
    Exit;
  end;

  StatusBar1.Panels[1].Text:= 'Comparing files started...';

  InitCompareInfo(@CompareInfo);
  CompareInfo.IsMustSizeEqual:= cbEqual.Checked;
  CompareInfo.Callback:= @ProgressCallback;
  if not CompareFiles(OriginalFileName, ChangedFileName, @CompareInfo) then
  begin
    StatusBar1.Panels[1].Text:= 'Error happened when comparing files!';
    Exit;
  end;

  if CompareInfo.CompareCount = 0 then
  begin
    StatusBar1.Panels[1].Text:= 'No differences between files found!';
    Exit;
  end;

  StatusBar1.Panels[1].Text:= 'Filling value list... please wait';
  lblDifferentCount.Caption:= IntToStr(CompareInfo.CompareCount);

  lvCompare.Items.BeginUpdate;

  if CompareInfo.CompareCount < 1024 then
  EntryCount:=CompareInfo.CompareCount
  else EntryCount:= 1024;

  //for EntryIndex:= 0 to CompareInfo.CompareCount - 1 do
  for EntryIndex:= 0 to EntryCount - 1 do
  begin
    ProgressCallback(EntryIndex, CompareInfo.CompareCount);

    CompareEntry:= @CompareInfo.CompareTable[EntryIndex];
    Item:= lvCompare.Items.Add;
    Item.Caption:= IntToStr(CompareEntry^.Offset);
    Item.SubItems.Add('$' + IntToHex(CompareEntry^.Original, 2));
    Item.SubItems.Add('$' + IntToHex(CompareEntry^.Changed, 2));
  end;
  lvCompare.Items.EndUpdate;

  FreeCompareInfo(@CompareInfo);

  if CompareInfo.IsSizeEqual then
  StatusBar1.Panels[1].Text:= 'Comparing files finished... filesize equals!'
  else StatusBar1.Panels[1].Text:= 'Comparing files finished... filesize NOT equals!'
end;

exports
  PluginGetInfo,
  PluginCreateWindow,
  PluginDestroyWindow;

end.
 