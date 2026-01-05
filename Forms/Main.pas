unit MAIN;

interface

uses
  Windows, SysUtils, Classes, Graphics,
  Forms, Controls, Menus, StdCtrls, Dialogs,
  Buttons, Messages, ExtCtrls, ComCtrls,
  StdActns, ActnList, ToolWin, ImgList,
  SharedFunc, WAVPlayer, SystemInfo, Gauges,
  GlobalRefresh, PluginLoader, ExternalLoader;

procedure EnableControl (Control:TWinControl;Enabled:Boolean);
procedure EnableSearchPanel (Panel:TPanel;const Enabled:Boolean);

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    FileExitItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    Features1: TMenuItem;
    miFileRipper: TMenuItem;
    miTextureConverter: TMenuItem;
    Minimize1: TMenuItem;
    Setting1: TMenuItem;
    miDupeChecker: TMenuItem;
    Readme1: TMenuItem;
    miDataEraser: TMenuItem;
    miAsciiEditor: TMenuItem;
    StatusBar1: TStatusBar;
    gProcessorUsage: TGauge;
    ImageList1: TImageList;
    Label1: TLabel;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    Setting2: TMenuItem;
    SystemInfo1: TMenuItem;
    Label2: TLabel;
    gFreeMemory: TGauge;
    miMPEGTool: TMenuItem;
    Plugins1: TMenuItem;
    External1: TMenuItem;
    miPluginInfo: TMenuItem;
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure miFileRipperClick(Sender: TObject);
    procedure miTextureConverterClick(Sender: TObject);

    procedure MainMenuPluginOnClick(Sender: TObject);
    procedure MainMenuExternalOnClick(Sender: TObject);

    procedure MainMenuOnMeasureItem(Sender: TObject; ACanvas: TCanvas; var Width,
    Height: Integer);
    procedure MainMenuOnDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
      Selected: Boolean);


    procedure Minimize1Click(Sender: TObject);
    procedure miDupeCheckerClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure miMPEGToolClick(Sender: TObject);
    procedure miAsciiEditorClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miPluginInfoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  APP_NAME = 'Game Modding Studio';
  APP_SUBNAME = 'Boosted Edition';
  APP_VERSION = 'v0.1.4';
  APP_TITLE = APP_NAME + ': ' + APP_SUBNAME + ' ' + APP_VERSION;
  DATA_PATH = 'Data\';
  TEMP_PATH = 'Temp\';

  MAIN_PLUGIN_PATH = 'Plugin\';

  INTERNAL_PATH = 'Internal\';
  EXTERNAL_PATH = 'External\';


  TEXCONV_CONFIG = DATA_PATH + 'TextureConverter.cfg';
  FILERIP_CONFIG = DATA_PATH + 'FileRipper.cfg';
  DUPECHECK_CONFIG = DATA_PATH + 'DupeChecker.cfg';

var
  MainForm: TMainForm;
  ExePath:ShortString;
  ThreadSystemInfo: DWORD;
  MainPlugins: TPluginCollection;
  MainExternals: TExternalCollection;

implementation

{$R *.dfm}

uses
  FileRip,
  TextureConverter,
  DupeCheck,
  MPEGTool,
  About,
  AsciiEditor,
  PluginInfo;

///////////////////////////////////////

procedure PlayMenuClickSound();
begin

  PlayWAVFile('Data\menu_click.wav');
end;

procedure TMainForm.MainMenuPluginOnClick(Sender: TObject);
var
  MenuItem: TMenuItem;
  PluginEntry: PPluginEntry;
begin

  MenuItem:= Sender as TMenuItem;

  PluginEntry:= @MainPlugins.PluginTable[MenuItem.MenuIndex];
  if PluginEntry^.WindowHandle <> 0 then
    Exit;

  PlayMenuClickSound();

  if PluginEntry^.IsLoaded and (PluginEntry^.WindowHandle = 0) then
    PluginEntry^.PluginCreateWindow(@PluginEntry^.WindowHandle);
end;

procedure TMainForm.MainMenuExternalOnClick(Sender: TObject);
var
  MenuItem: TMenuItem;
  ExternalInfo: PExternalInfo;
begin

  MenuItem:= Sender as TMenuItem;
  if not MenuItem.Enabled then
    Exit;

  PlayMenuClickSound();

  ExternalInfo:= @MainExternals.ExternalTable[MenuItem.MenuIndex];
  ExecuteFile(ExternalInfo^.ShellCommand);
end;

procedure LoadMainPlugins();
var
  PluginIndex: DWORD;
  PluginEntry: PPluginEntry;
  MainPluginMenuItem, PluginMenuItem: TMenuItem;

begin

  LoadPluginCollection(ExePath + MAIN_PLUGIN_PATH, @MainPlugins);

  if MainPlugins.PluginCount = 0 then
    Exit;

  MainPluginMenuItem:= MainForm.MainMenu.Items.Find('Plugins');

  for PluginIndex := 0 to MainPlugins.PluginCount - 1 do
  begin
    PluginEntry:= @MainPlugins.PluginTable[PluginIndex];

    if PluginEntry^.PluginInfo.ShowInMenu then
    begin
      PluginMenuItem:= TMenuItem.Create(MainForm.MainMenu);

      PluginMenuItem.Caption:= PluginEntry^.PluginInfo.MenuCaption; //Copy(PluginEntry^.PluginInfo.MenuCaption, 1, Length(PluginEntry^.PluginInfo.MenuCaption)) ;

      PluginMenuItem.OnDrawItem:= MainForm.MainMenuOnDrawItem;
      PluginMenuItem.OnMeasureItem:= MainForm.MainMenuOnMeasureItem;

      if PluginEntry^.IsEnabled then
        PluginMenuItem.OnClick:= MainForm.MainMenuPluginOnClick;

      MainPluginMenuItem.Add(PluginMenuItem);
    end;
  end;
end;

procedure LoadMainExternals();
var
  ExternalIndex: DWORD;
  ExternalInfo: PExternalInfo;
  MainExternalMenuItem, ExternalMenuItem: TMenuItem;
begin

  LoadExternalCollection(ExePath + EXTERNAL_PATH, @MainExternals);

  if MainExternals.ExternalCount = 0 then
    Exit;

  MainExternalMenuItem:= MainForm.MainMenu.Items.Find('External');

  for ExternalIndex := 0 to MainExternals.ExternalCount - 1 do
  begin
    ExternalInfo:= @MainExternals.ExternalTable[ExternalIndex];

    ExternalMenuItem:= TMenuItem.Create(MainForm.MainMenu);

    ExternalMenuItem.Caption:= ExternalInfo^.MenuCaption;

    ExternalMenuItem.OnDrawItem:= MainForm.MainMenuOnDrawItem;
    ExternalMenuItem.OnMeasureItem:= MainForm.MainMenuOnMeasureItem;
    ExternalMenuItem.OnClick:= MainForm.MainMenuExternalOnClick;

    MainExternalMenuItem.Add(ExternalMenuItem);
  end;
end;

///////////////////////////////////////
procedure EnableSearchPanel (Panel:TPanel;const Enabled:Boolean);
var
  I:LongWord;
begin

  for i := 0 to Panel.ControlCount - 1 do
  begin
    if Panel.Controls[I].Name = 'BtnSearch' then
      Panel.Controls[I].Enabled:= Enabled
    else Panel.Controls[I].Enabled:= not Enabled;
  end;
end;

procedure EnableControl (Control:TWinControl;Enabled:Boolean);
var
  I:LongWord;
begin

  for I := 0 to Control.ControlCount - 1 do
  begin
    if (TWinControl(Control.Controls[I]).ControlCount > 0) then
      EnableControl(TWinControl(Control.Controls[I]), Enabled)
    else Control.Controls[I].Enabled:= Enabled;
  end;
end;

procedure EnableGroupBox (GroupBox:TGroupBox;Enabled:Boolean);
var
  I,J:LongWord;
begin

  for I := 0 to GroupBox.ControlCount - 1 do
  begin
    if GroupBox.Controls[I] is TGroupBox then
    begin
      for J := 0 to TGroupBox(GroupBox.Controls[I]).ControlCount - 1 do
        TGroupBox(GroupBox.Controls[I]).Controls[J].Enabled:= Enabled;
    end else GroupBox.Controls[I].Enabled:=Enabled;
  end;
end;

procedure TMainForm.miDupeCheckerClick(Sender: TObject);
begin

  PlayMenuClickSound();
  miDupeChecker.Enabled:= False;
  Application.CreateForm(TDupeCheckForm, DupeCheckForm);
end;

procedure TMainForm.miFileRipperClick(Sender: TObject);
begin

  PlayMenuClickSound();
  miFileRipper.Enabled:= False;
  Application.CreateForm(TFileRipForm, FileRipForm);
end;

procedure TMainForm.miTextureConverterClick(Sender: TObject);
begin

  PlayMenuClickSound();
  miTextureConverter.Enabled:= False;
  Application.CreateForm(TTextureConverterForm, TextureConverterForm);
end;

procedure TMainForm.Minimize1Click(Sender: TObject);
begin

  Application.Minimize;
end;

procedure TMainForm.miMPEGToolClick(Sender: TObject);
begin

  PlayMenuClickSound();
  miMPEGTool.Enabled:= False;
  Application.CreateForm(TMPEGToolForm, MPEGToolForm);
end;

procedure TMainForm.miAsciiEditorClick(Sender: TObject);
begin

  PlayMenuClickSound();
  miAsciiEditor.Enabled:= False;
  Application.CreateForm(TAsciiEditorForm, AsciiEditorForm);
end;

procedure TMainForm.miPluginInfoClick(Sender: TObject);
begin

  PlayMenuClickSound();
  miPluginInfo.Enabled:= False;
  Application.CreateForm(TPluginInfoForm, PluginInfoForm);
end;

procedure TMainForm.MainMenuOnMeasureItem(Sender: TObject; ACanvas: TCanvas;
  var Width, Height: Integer);
begin

  Height:=18;
end;

procedure TMainForm.MainMenuOnDrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
var
  Item: TMenuItem;
begin

  Item:= TMenuItem(Sender);
  ACanvas.Brush.Color:= clBtnFace;
  ACanvas.FillRect(ARect);

  if Selected then
  begin
    ACanvas.Brush.Color:= clSilver;
    ACanvas.FillRect(ARect);
    ACanvas.Brush.Color:= clBlack;
    ACanvas.FrameRect(ARect);
    ACanvas.Brush.Color:= clSilver;
    ACanvas.TextOut(ARect.Left + 5,ARect.Top + 2,Item.Caption);
    PlayWAVFile('Data\menu_select.wav');
  end
    else
  begin
    if Item.Caption = '-' then
    begin
      InflateRect(ARect, -2, -4);
      ACanvas.Brush.Color:= clSilver;
      ACanvas.FrameRect(ARect);
    end else ACanvas.TextOut(ARect.Left + 5,ARect.Top + 2, Item.Caption);
  end;

end;

procedure TMainForm.FormResize(Sender: TObject);
begin

  Panel1.Top:= 0;
  Panel1.Left:= (MainForm.Width - Panel1.Width) - 10;
  //Panel1.BringToFront;
end;

procedure TMainForm.HelpAbout1Execute(Sender: TObject);
begin

  AboutBox.ShowModal;
end;

procedure TMainForm.FileExit1Execute(Sender: TObject);
begin

  SuspendThread(ThreadSystemInfo);
  Application.Terminate;
end;

procedure ReportSystemInfo(const SystemInfo: PSystemInfo);
begin

  if IsRefreshTime then
  begin
    MainForm.gProcessorUsage.Progress:= SystemInfo^.ProcessorUsage;
    MainForm.gFreeMemory.Progress:= 100 - SystemInfo^.MemoryLoad;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  I:LongWord;

  procedure ModifyItem(const Item:TMenuItem);
  var
    I:LongWord;
  begin

    if Item.Count > 0 then
    begin
      for I := 0 to Item.Count - 1 do
        ModifyItem(Item[I]);
    end;

    Item.OnMeasureItem:= MainMenuOnMeasureItem;
    Item.OnDrawItem:= MainMenuOnDrawItem;
  end;

begin

  Randomize();

  if IsWrongHandle then
    Halt(0);

  MainForm.Caption:= APP_TITLE;
  MainMenu.OwnerDraw:= True;
  for I := 0 to MainMenu.Items.Count - 1 do
  begin
    ModifyItem(MainMenu.Items[I]);
  end;

  ExePath:= ExtractFilePath(Application.ExeName);
  LoadMainPlugins();
  LoadMainExternals();

  //if not DirectoryExists (ExePath + DATAPATH) then
  ForceDirectories(ExePath + DATA_PATH);
  ForceDirectories(ExePath + TEMP_PATH);

  ThreadSystemInfo:= CreateThread(nil, 0, @StartReportingSystemInfo, Pointer(@ReportSystemInfo), 0, ThreadSystemInfo);

  EmptyFolder(ExePath + TEMP_PATH);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin

  UnloadPluginCollection(@MainPlugins);
end;

end.
