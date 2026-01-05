unit PluginInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PluginLoader, ComCtrls;

type
  TPluginInfoForm = class(TForm)
    gbActionPanel: TGroupBox;
    edtKitVersion: TEdit;
    mmPluginDescription: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    edtPluginVersion: TEdit;
    Label3: TLabel;
    edtPluginAuthor: TEdit;
    Label4: TLabel;
    lvPluginList: TListView;
    edtPluginPath: TEdit;
    Label5: TLabel;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure lvPluginListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PluginInfoForm: TPluginInfoForm;

implementation

{$R *.dfm}

uses
  Main;

procedure TPluginInfoForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.miPluginInfo.Enabled:= True;
  Action:= caFree;
end;

procedure TPluginInfoForm.FormCreate(Sender: TObject);
var
  PluginIndex: DWORD;
  PluginEntry: PPluginEntry;
  ListItem: TListItem;
begin
  if MainPlugins.PluginCount = 0 then
  Exit;

  StatusBar.Panels[0].Text:= 'Current plugin kit version: '  + KIT_VERSION;

  for PluginIndex := 0 to MainPlugins.PluginCount - 1 do
  begin
    PluginEntry:= @MainPlugins.PluginTable[PluginIndex];
    ListItem:= lvPluginList.Items.Add();
    ListItem.Caption:= ' ' + PluginEntry^.PluginInfo.Name;
    ListItem.Data:= PluginEntry;

    if PluginEntry^.IsEnabled then
    ListItem.SubItems.Add('Yes')
    else ListItem.SubItems.Add('No');
  end;
  lvPluginList.Refresh;
end;

procedure TPluginInfoForm.lvPluginListSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  PluginEntry: PPluginEntry;
begin
  PluginEntry:= Item.Data;
  edtKitVersion.Text:= PluginEntry^.PluginInfo.KitVersion;
  edtPluginVersion.Text:= PluginEntry^.PluginInfo.Version;
  edtPluginAuthor.Text:= PluginEntry^.PluginInfo.Author;
  edtPluginPath.Text:= PluginEntry^.PluginPath;
  mmPluginDescription.Text:= PluginEntry^.PluginInfo.Description;

end;

end.
