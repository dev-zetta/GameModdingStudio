unit MPEGTool;

interface

uses
  Windows, Messages, SysUtils, Variants,
  Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Gauges,
  ExtCtrls,

  GlobalRefresh, MPEGScanner, SharedFunc;

type
  TMPEGToolForm = class(TForm)
    GBoxFolder: TGroupBox;
    Label1: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    edtSourceFile: TEdit;
    btnSourceFile: TButton;
    EdtTargetFolder: TEdit;
    BtnTargetFolder: TButton;
    PnlLogger: TPanel;
    Gauge1: TGauge;
    BtnSave: TButton;
    BtnClear: TButton;
    RichEdit1: TRichEdit;
    PnlSearch: TPanel;
    BtnSearch: TButton;
    BtnCancel: TButton;
    BtnPause: TButton;
    gbActionBox: TGroupBox;
    OpenDialog1: TOpenDialog;
    rbExtractToFolder: TRadioButton;
    rbExtractToFile: TRadioButton;
    btnPerform: TButton;
    udMinFrameCount: TUpDown;
    lblMinFrameCount: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblFramesFound: TLabel;
    lblClustersFound: TLabel;
    lblMinClusterSize: TLabel;
    lblMaxClusterSize: TLabel;
    edtSecretMessage: TEdit;
    Label8: TLabel;
    rbReadSecretMessage: TRadioButton;
    rbSaveSecretMessage: TRadioButton;
    Label10: TLabel;
    lblSecretMessageLength: TLabel;
    rbDumpToFile: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSourceFileClick(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
    procedure btnPerformClick(Sender: TObject);
    procedure BtnTargetFolderClick(Sender: TObject);
    procedure udMinFrameCountClick(Sender: TObject; Button: TUDBtnType);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateSettings();
    procedure LogMsgRed (const Msg:String);
    procedure LogMsgBlue (const Msg:String);
  end;

var
  MPEGToolForm: TMPEGToolForm;

implementation

uses Main;

{$R *.dfm}

type
  TMPEGActionType = (
    maUnknown, maDumpToFile, maExtractToFile, maExtractToFolder,
    maReadMessage, maSaveMessage
  );

var
  StreamInfo :TMPEGStreamInfo;
  SourceFile, TargetFolder: String;
  MinFrameCount: DWORD = 2;
  ActionType: TMPEGActionType = maDumpToFile;

///////////////////////////////////////
procedure TMPEGToolForm.LogMsgRed (const Msg:String);
begin
  RichEdit1.SelAttributes.Color:=clRED;
  RichEdit1.Lines.Add(Msg);
  RichEdit1.SelStart:=Length(RichEdit1.Lines.Text);
end;
procedure TMPEGToolForm.udMinFrameCountClick(Sender: TObject;
  Button: TUDBtnType);
begin
  lblMinFrameCount.Caption:= IntToStr(udMinFrameCount.Position);
end;

///////////////////////////////////////
procedure TMPEGToolForm.LogMsgBlue (const Msg:String);
begin
  RichEdit1.SelAttributes.Color:=clBLUE;
  RichEdit1.Lines.Add(Msg);
  RichEdit1.SelStart:=Length(RichEdit1.Lines.Text);
end;
///////////////////////////////////////
procedure TMPEGToolForm.UpdateSettings();
begin
  SourceFile:= edtSourceFile.Text;
  TargetFolder:= edtTargetFolder.Text;
  MinFrameCount:= udMinFrameCount.Position;

  if rbDumpToFile.Checked then
  ActionType:= maDumpToFile
    else
  if rbExtractToFile.Checked then
  ActionType:= maExtractToFile
    else
  if rbExtractToFolder.Checked then
  ActionType:= maExtractToFolder
    else
  if rbReadSecretMessage.Checked then
  ActionType:= maReadMessage
    else
  if rbSaveSecretMessage.Checked then
  ActionType:= maSaveMessage;
end;

procedure ProgressCallback(const Value, MaxValue: DWORD);
begin
  if IsRefreshTime then
  begin
    MPEGToolForm.Gauge1.Progress:=Value;
    MPEGToolForm.Gauge1.MaxValue:= MaxValue;
    Application.ProcessMessages;
  end;
end;

procedure TMPEGToolForm.btnPerformClick(Sender: TObject);
var
  TargetFile: String;
  SecretMessage: String;
begin
  UpdateSettings();
  case ActionType of
    maDumpToFile:
    begin
      TargetFile:= TargetFolder + ExtractFileName(SourceFile);
      TargetFile:=ChangeFileExt(TargetFile, '.txt');
      MPEGDumpInfoToFile(@StreamInfo, TargetFile);
      ExecuteFile(TargetFile);
    end;
    maExtractToFile:
    begin
      TargetFile:= TargetFolder + ExtractFileName(SourceFile);
      TargetFile:=ChangeFileExt(TargetFile, '.mp3');
      MPEGSaveStreamToFile(@StreamInfo, TargetFile);
      ExecuteFile(TargetFile);
    end;
    maExtractToFolder:
    begin
      MPEGExtractFrameClusters(@StreamInfo, TargetFolder);
    end;
    maReadMessage:
    begin
      MPEGReadMessageFromStream(@StreamInfo, SecretMessage);
      edtSecretMessage.Text:= SecretMessage;
      lblSecretMessageLength.Caption:= IntToStr(Length(SecretMessage));
    end;
    maSaveMessage:
    begin
      SecretMessage:= edtSecretMessage.Text;
      if Length(SecretMessage) = 0 then
      Exit;

      MPEGWriteMessageToStream(@StreamInfo, SecretMessage);

      TargetFile:= TargetFolder + ExtractFileName(SourceFile);
      TargetFile:=ChangeFileExt(TargetFile, '.mp3');

      MPEGSaveStreamToFile(@StreamInfo, TargetFile);
    end;

  end;
end;

procedure TMPEGToolForm.BtnSearchClick(Sender: TObject);
begin
  UpdateSettings();

  RichEdit1.Clear;

  if Length(SourceFile) = 0 then
  Exit;
  
  if MinFrameCount = 0 then
  MinFrameCount:= 1;

  if StreamInfo.IsLoaded then
  FreeStreamInfo(@StreamInfo);

  LogMsgBlue('Scanning mpeg frames...');
  if MPEGProcessFile(@StreamInfo, SourceFile, @ProgressCallback, MinFrameCount) then
  LogMsgBlue('Scanning finished successfully...')
  else LogMsgRed('Scanning finished unsuccessfully!');

  lblFramesFound.Caption:= IntToStr(StreamInfo.TotalFrameCount);
  lblClustersFound.Caption:= IntToStr(StreamInfo.FrameClusterCount);
  lblMinClusterSize.Caption:= IntToStr(StreamInfo.MinClusterSize);
  lblMaxClusterSize.Caption:= IntToStr(StreamInfo.MaxClusterSize);

  LogMsgBlue ('Identified: ' + IntToStr(StreamInfo.TotalFrameSize div 1024) + ' KiB from ' + IntToStr(StreamInfo.FileSize div 1024) + ' KiB (' + IntToStr(StreamInfo.TotalFrameSize div (StreamInfo.FileSize div 100))+ '%)');

  //if StreamInfo.FrameClusterCount > 0 then


end;

procedure TMPEGToolForm.btnSourceFileClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  edtSourceFile.Text:= OpenDialog1.FileName;
end;

procedure TMPEGToolForm.BtnTargetFolderClick(Sender: TObject);
begin
  edtTargetFolder.Text:=BrowseDialog ('Select Folder:', TargetFolder);
end;

procedure TMPEGToolForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.miMPEGTool.Enabled:=True;
  Action := caFree;
end;

procedure TMPEGToolForm.FormCreate(Sender: TObject);
//var
  //HiddenMsg, HiddenMsg2: String;
  //i: DWORD;
begin
  StreamInfo.IsLoaded:= False;
  //MPEGToolForm.Parent:= MainForm;
  //EnableControl(gbActionBox, False);
  //MPEGProcessFile(@StreamInfo,'E:\Documents and Settings\Administrator\Desktop\Daft Punk-Harder Better Faster Stronger.mp3', @ProgressCallback);

 // HiddenMsg:='sdfsdgfsdfsd';
  //MPEGWriteMessageToStream(@StreamInfo, HiddenMsg);

  //MPEGReadMessageFromStream(@StreamInfo, HiddenMsg2);

  //i:=Length(HiddenMsg);
  //if i > 0 then
  //LogMsgBlue(HiddenMsg);
  //MPEGSaveStreamToFile(@StreamInfo, 'G:\#DOWNLOAD\#MOVIE\Vesmirna Prda CZ.mp3');

  //MPEGExtractFrameClusters(@StreamInfo, 'G:\#DOWNLOAD\#MOVIE\Clusters\');
end;

end.
