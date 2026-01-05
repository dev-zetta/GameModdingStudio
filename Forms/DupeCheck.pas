unit DupeCheck;

interface

uses
  Windows, Messages, SysUtils, Variants, 
  Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ComCtrls, Gauges, 
  ExtCtrls, 

  DupeChecker, ProcTimer, SharedFunc, SharedTypes;

type
  TDupeCheckForm = class(TForm)
    GBoxFolder: TGroupBox;
    Label1: TLabel;
    Label5: TLabel;
    EdtSourceFolder: TEdit;
    BtnSourceFolder: TButton;
    EdtTargetFolder: TEdit;
    BtnTargetFolder: TButton;
    PnlLogger: TPanel;
    Gauge1: TGauge;
    BtnSave: TButton;
    BtnClear: TButton;
    RichEdit1: TRichEdit;
    GBoxTodo: TGroupBox;
    RBtnNone: TRadioButton;
    RBtnCopy: TRadioButton;
    RBtnDelete: TRadioButton;
    RBtnErase: TRadioButton;
    GBoxComp: TGroupBox;
    ChBoxName: TCheckBox;
    ChBoxData: TCheckBox;
    ChBoxSize: TCheckBox;
    ChBoxPath: TCheckBox;
    GBoxFeat: TGroupBox;
    ChBoxBatch: TCheckBox;
    ChBoxList: TCheckBox;
    EdtSourceExt: TEdit;
    Label3: TLabel;
    PnlSearch: TPanel;
    BtnSearch: TButton;
    BtnCancel: TButton;
    BtnPause: TButton;
    EdtPrefix: TEdit;
    Label2: TLabel;
    RBtnMove: TRadioButton;
    RBtnReport: TRadioButton;
    ChBoxExt: TCheckBox;
    EdtBatch: TEdit;
    EdtList: TEdit;
    Label4: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
    procedure BtnSourceFolderClick(Sender: TObject);
    procedure BtnTargetFolderClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    function UpdateSetting(const SaveLoad:TSaveLoad):boolean;
    function SaveSetting:boolean;
    function LoadSetting:boolean;
  public
    { Public declarations }
  end;

var
  DupeCheckForm: TDupeCheckForm;
  DupeChecker:TDupeChecker;
  DupeCheckerSetting:TDupeCheckerSetting;

implementation

uses
  Main;

{$R *.dfm}


procedure SendMsgRed (const Msg:ShortString);
begin

  with DupeCheckForm.RichEdit1 do
  begin
    SelAttributes.Color:= clRed;
    Lines.Add(Msg);
    SelStart:= Length(Lines.Text);
  end;
end;

function TDupeCheckForm.SaveSetting:boolean;
begin

  Result:= WriteBuffer(EXEPATH+DUPECHECK_CONFIG, DupeCheckerSetting, SizeOf(TDupeCheckerSetting));
end;

function TDupeCheckForm.LoadSetting:boolean;
begin

  Result:= ReadBuffer(EXEPATH+DUPECHECK_CONFIG, DupeCheckerSetting, SizeOf(TDupeCheckerSetting));
end;

function TDupeCheckForm.UpdateSetting(const SaveLoad:TSaveLoad): Boolean;
begin

  Result:= True;
  try
    if SaveLoad=slLOAD then
    begin
      EdtSourceFolder.Text:= DupeCheckerSetting.SourceFolder;
      EdtTargetFolder.Text:= DupeCheckerSetting.TargetFolder;

      EdtSourceExt.Text:= DupeCheckerSetting.SourceExt;
      EdtPrefix.Text:= DupeCheckerSetting.Prefix;
      EdtBatch.Text:= DupeCheckerSetting.BatchName;
      EdtList.Text:= DupeCheckerSetting.FileListName;

      case DupeCheckerSetting.Option of
        doNone: RBtnNone.Checked:= True;
        doReport: RBtnReport.Checked:= True;
        doMove: RBtnMove.Checked:= True;
        doCopy: RBtnCopy.Checked:= True;
        doDelete: RBtnDelete.Checked:= True;
        doErase: RBtnErase.Checked:= True;
      end;

      ChBoxName.Checked:= DupeCheckerSetting.IsCMNameSet;
      ChBoxSize.Checked:= DupeCheckerSetting.IsCMSizeSet;
      ChBoxExt.Checked:= DupeCheckerSetting.IsCMExtSet;
      ChBoxPath.Checked:= DupeCheckerSetting.IsCMPathSet;
      ChBoxData.Checked:= DupeCheckerSetting.IsCMDataSet;

      ChBoxBatch.Checked:= DupeCheckerSetting.CreateBatch;
      ChBoxList.Checked:= DupeCheckerSetting.CreateFileList;
    end
      else
    if SaveLoad = slSAVE then
    begin
      DupeCheckerSetting.SourceFolder:= EdtSourceFolder.Text;
      DupeCheckerSetting.TargetFolder:= EdtTargetFolder.Text;
      DupeCheckerSetting.SourceExt:= EdtSourceExt.Text;
      DupeCheckerSetting.Prefix:= EdtPrefix.Text;
      DupeCheckerSetting.BatchName:= EdtBatch.Text;
      DupeCheckerSetting.FileListName:= EdtList.Text;

      // Compare method
      DupeCheckerSetting.IsCMNameSet:= ChBoxName.Checked;
      DupeCheckerSetting.IsCMSizeSet:= ChBoxSize.Checked;
      DupeCheckerSetting.IsCMExtSet:= ChBoxExt.Checked;
      DupeCheckerSetting.IsCMPathSet:= ChBoxPath.Checked;
      DupeCheckerSetting.IsCMDataSet:= ChBoxData.Checked;

      if RBtnNone.Checked then
        DupeCheckerSetting.Option:= doNone;

      if RBtnReport.Checked then
        DupeCheckerSetting.Option:= doReport;

      if RBtnMove.Checked then
        DupeCheckerSetting.Option:= doMove;

      if RBtnCopy.Checked then
        DupeCheckerSetting.Option:= doCopy;

      if RBtnDelete.Checked then
        DupeCheckerSetting.Option:= doDelete;

      if RBtnErase.Checked then
        DupeCheckerSetting.Option:= doErase;

      DupeCheckerSetting.CreateBatch:= ChBoxBatch.Checked;
      DupeCheckerSetting.CreateFileList:= ChBoxList.Checked;

      DupeChecker.ResetChecker();

      // Orded must be same or comparing dupes will be slower
      if DupeCheckerSetting.IsCMSizeSet then
        DupeChecker.SetMethod(dmSize);

      if DupeCheckerSetting.IsCMNameSet then
        DupeChecker.SetMethod(dmName);

      if DupeCheckerSetting.IsCMExtSet then
        DupeChecker.SetMethod(dmExt);

      if DupeCheckerSetting.IsCMPathSet then
        DupeChecker.SetMethod(dmPath);

      if DupeCheckerSetting.IsCMDataSet then
        DupeChecker.SetMethod(dmData);
    end;
  except
    Result:= False;
  end;
end;

procedure TDupeCheckForm.BtnSearchClick(Sender: TObject);
var
  I, J: LongWord;
  BatchFile: TextFile;
  ListFile: TextFile;
  Timer: TProcTimer;
begin

  UpdateSetting(slSave);
  StartTimer(Timer);

  SendMsgRed('Searching files...');
  DupeChecker.SearchFiles(DupeCheckerSetting.SourceFolder, DupeCheckerSetting.SourceExt);
  SendMsgRed(IntToStr(DupeChecker.FilesCount) + ' files found...');

  if DupeChecker.FilesCount = 0 then
    Exit;

  SendMsgRed('Searching dupes...');
  DupeChecker.SearchDupes();
  SendMsgRed(IntToStr(DupeChecker.DupesCount) + ' dupes found...');

  if DupeChecker.DupesCount = 0 then
    Exit;

  if DupeCheckerSetting.CreateBatch then
  begin
    AssignFile(BatchFile, DupeCheckerSetting.TargetFolder+DupeCheckerSetting.BatchName);
    Rewrite(BatchFile);
  end;

  if DupeCheckerSetting.CreateFileList then
  begin
    AssignFile(ListFile, DupeCheckerSetting.TargetFolder+DupeCheckerSetting.FileListName);
    Rewrite(ListFile);
  end;

  for I := 0 to DupeChecker.FilesCount - 1 do
  begin
    if DupeChecker.IsInitial(I) then
    begin
      for J := 0 to DupeChecker.GetDupeCount(I) - 1 do
      begin
        case DupeCheckerSetting.Option of
          doReport: SendMsgRed('Dupe found: ' + DupeChecker.GetDupeName(I, J));
          doMove: DupeChecker.MoveDupe(DupeChecker.GetDupeIndex(I, J), DupeCheckerSetting.TargetFolder);
          doCopy: DupeChecker.CopyDupe(DupeChecker.GetDupeIndex(I, J), DupeCheckerSetting.TargetFolder);
          doDelete: DupeChecker.DeleteDupe(DupeChecker.GetDupeIndex(I, J));
          doErase: DupeChecker.EraseDupe(DupeChecker.GetDupeIndex(I, J));
        end;

        if DupeCheckerSetting.CreateBatch then
          WriteLn (BatchFile, 'COPY ".\' + DupeChecker.GetRelFileName(I) + '" ".\' + DupeChecker.GetRelDupeName(I, J) + '" > NUL');

        if DupeCheckerSetting.CreateFileList then
          WriteLn(ListFile, DupeChecker.GetDupeName(I, J));
      end;
    end;
  end;

  if DupeCheckerSetting.CreateBatch then
    CloseFile(BatchFile);

  if DupeCheckerSetting.CreateFileList then
    CloseFile(ListFile);

  StopTimer(Timer);
  SendMsgRed('Total time: ' + IntToStr(Timer.TotalTime div 1000) + ' s')
end;

procedure TDupeCheckForm.BtnSourceFolderClick(Sender: TObject);
begin

  EdtSourceFolder.Text:= BrowseDialog('Select Directory', DupeCheckerSetting.SourceFolder);
end;

procedure TDupeCheckForm.BtnTargetFolderClick(Sender: TObject);
begin

  EdtTargetFolder.Text:= BrowseDialog('Select Directory', DupeCheckerSetting.TargetFolder);
end;

procedure TDupeCheckForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  DupeChecker.Destroy;
  UpdateSetting(slSave);
  SaveSetting();
  MainForm.miDupeChecker.Enabled:= True;
  Action := caFree;
end;

procedure TDupeCheckForm.FormCreate(Sender: TObject);
begin

  DupeChecker:= TDupeChecker.Create;
  LoadSetting();
  UpdateSetting(slLoad);
end;

end.
