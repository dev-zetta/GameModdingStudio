unit FileRip;

interface

uses
  Windows, Messages, SysUtils, Classes, 
  Graphics, Controls, Forms, Gauges, 
  StdCtrls, CheckLst, ComCtrls, Dialogs, 
  CommCtrl, ExtCtrls, 

  GlobalRefresh, 
  MultiGaugeX, 
  ProcTimer, 
  SharedFunc, 
  SharedTypes, 
  FileRipper, 
  FileRipperSections, 
  FileRipperFormats, 
  FileRipperShared;

type
  TFileRipForm = class(TForm)
    GBoxChecked: TGroupBox;
    BtnOpen: TButton;
    BtnExtract: TButton;
    BtnReplace: TButton;
    GBoxEntryInfo: TGroupBox;
    OpenDialog1: TOpenDialog;
    BtnDelete: TButton;
    BtnHEX: TButton;
    GBoxSelected: TGroupBox;
    GBoxFolder: TGroupBox;
    PnlSearchFolder: TPanel;
    Label1: TLabel;
    EdtSourceFolder: TEdit;
    EdtSourceExt: TEdit;
    BtnSourceFolder: TButton;
    PnlSearchFile: TPanel;
    EdtSourceFile: TEdit;
    BtnSourceFile: TButton;
    PnlFormats: TGroupBox;
    TreeFormat: TTreeView;
    BtnSelectAll: TButton;
    BtnSelectNone: TButton;
    PnlLogger: TPanel;
    Gauge1: TGauge;
    BtnSave: TButton;
    BtnClear: TButton;
    RichEdit1: TRichEdit;
    GBoxFound: TGroupBox;
    GBoxSelect: TGroupBox;
    GBoxCheck: TGroupBox;
    BtnCheckAll: TButton;
    BtnCheckNone: TButton;
    LblChunkOffsetSel: TLabel;
    LblChunkSizeSel: TLabel;
    EdtTargetFolder: TEdit;
    Label4: TLabel;
    BtnTargetFolder: TButton;
    RBtnSearchFile: TRadioButton;
    RBtnSearchFolder: TRadioButton;
    PnlSearch: TPanel;
    BtnSearch: TButton;
    BtnCancel: TButton;
    BtnPause: TButton;
    GBoxAll: TGroupBox;
    BtnExtractAll: TButton;
    BtnDupeAll: TButton;
    BtnDeleteAll: TButton;
    GBoxInfoAll: TGroupBox;
    GBoxInfoArchive: TGroupBox;
    LblChunkCountArch: TLabel;
    LblChunkSizeArch: TLabel;
    LblChunkCountTot: TLabel;
    LblChunkSizeTot: TLabel;
    TreeFile: TTreeView;
    procedure BtnExtractClick(Sender: TObject);
    //procedure BtnDupeAllClick(Sender: TObject);
    procedure BtnReplaceClick(Sender: TObject);
    procedure BtnOpenClick(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnSourceFileClick(Sender: TObject);
    procedure BtnSourceFolderClick(Sender: TObject);
    procedure BtnTargetFolderClick(Sender: TObject);
    procedure BtnSelectAllClick(Sender: TObject);
    procedure BtnSelectNoneClick(Sender: TObject);
    procedure BtnCheckAllClick(Sender: TObject);
    procedure BtnCheckNoneClick(Sender: TObject);
    procedure TreeFormatMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RBtnSearchFileClick(Sender: TObject);
    procedure RBtnSearchFolderClick(Sender: TObject);
    procedure TreeFileClick(Sender: TObject);
    procedure BtnHEXClick(Sender: TObject);
    procedure BtnExtractAllClick(Sender: TObject);
    procedure BtnDupeAllClick(Sender: TObject);
    procedure BtnDeleteAllClick(Sender: TObject);
    procedure TreeFileMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnPauseClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  private
    { Private declarations }
    procedure FillFileTreeView;
    procedure FillFormatTreeView;
    procedure EnableTreeControls (Enabled:boolean);
    //procedure TreeFileCheckAll(Checked:boolean);
    //procedure TreeFormatCheckAll(Checked:boolean);

    function SaveSetting:boolean;
    function LoadSetting:boolean;
    function UpdateSetting(SaveLoad:TSaveLoad):boolean;

    procedure SetPnlSearchFile;
    procedure SetPnlSearchFolder;

    procedure LogMsgRed (Msg:ShortString);
    procedure LogMsgBlue (Msg:ShortString);
  public
    { Public declarations }
  end;

var
  FileRipForm: TFileRipForm;

implementation

{$R *.dfm}

uses
  Main, TextureConverter;

var
  ProcessPaused:Boolean=false;
  ProcessCanceled:Boolean=false;
  FileRipperSettting:TFileRipperSetting;
  FileRipper:TFileRipper;
  MultiGauge: TMultiGaugeX;

  ThreadProgressCount: DWORD;

///////////////////////////////////////

procedure FileRipperCallBack(const ThreadIndex, FileIndex, Progress, MaxValue:DWORD);
begin

  if ThreadIndex >= 32 then
    Exit;

  if IsRefreshTime() then
  begin
    //RefreshTick:= Tick;

    MultiGauge.MaxValue[ThreadIndex]:= MaxValue;
    MultiGauge.Progress[ThreadIndex]:= Progress;

    MultiGauge.UpdateGauge();
    Application.ProcessMessages();
  end;
end;

procedure TFileRipForm.SetPnlSearchFile();
begin

  EnableControl(PnlSearchFolder, not RBtnSearchFile.Checked);
  EnableControl(PnlSearchFile, RBtnSearchFile.Checked);
end;

procedure TFileRipForm.SetPnlSearchFolder;
begin

  EnableControl(PnlSearchFolder, RBtnSearchFolder.Checked);
  EnableControl(PnlSearchFile, not RBtnSearchFolder.Checked);
end;

function TFileRipForm.SaveSetting:boolean;
begin

  Result:= WriteBuffer(EXEPATH + FILERIP_CONFIG, FileRipperSettting, SizeOf(TFileRipperSetting));
end;

function TFileRipForm.LoadSetting:boolean;
begin

  Result:= ReadBuffer(EXEPATH + FILERIP_CONFIG, FileRipperSettting, SizeOf(TFileRipperSetting));
end;

function TFileRipForm.UpdateSetting(SaveLoad:TSaveLoad): Boolean;
begin

  Result:= False;
  try
    if SaveLoad = slLOAD then
    begin
      EdtSourceFile.Text:= FileRipperSettting.SourceFile;
      EdtSourceFolder.Text:= FileRipperSettting.SourceFolder;
      EdtSourceExt.Text:= FileRipperSettting.SourceExt;
      EdtTargetFolder.Text:= FileRipperSettting.TargetFolder;

      //RBtnSearchFile.Checked:= SearchFile;
      //RBtnSearchFolder.Checked:= SearchFolder;

      RBtnSearchFile.Checked:= (FileRipperSettting.SearchOption = soLoadSingleFile);
      RBtnSearchFolder.Checked:= (FileRipperSettting.SearchOption = soLoadMultiFile);

      case FileRipperSettting.SearchOption of
        soLoadSingleFile: SetPnlSearchFile;
        soLoadMultiFile: SetPnlSearchFolder;
      end;
    end
      else
    if SaveLoad = slSAVE then
    begin
      if RBtnSearchFile.Checked then
      begin
        FileRipperSettting.SearchOption:= soLoadSingleFile;
        SetPnlSearchFile();
        FileRipperSettting.SourceFile:= EdtSourceFile.Text
      end
        else
      begin
        FileRipperSettting.SearchOption:= soLoadMultiFile;
        SetPnlSearchFolder();
        FileRipperSettting.SourceFolder:= EdtSourceFolder.Text;
      end;

      FileRipperSettting.SourceExt:= EdtSourceExt.Text;
      FileRipperSettting.TargetFolder:= EdtTargetFolder.Text;
    end;
  finally
    Result:= True;
  end;
end;

procedure TFileRipForm.FillFileTreeView();
var
  FileIndex, FormatIndex, EntryIndex: DWORD;
  EntryCount: DWORD;
  FileNode, FormatNode: TTreeNode;
  FormatType: PFormatType;
  //FormatEntry: TFormatEntry;
  FormatTypeSet: PFormatTypeSet;
  AddParent: Boolean;

begin

  FormatNode:= nil;
  TreeFile.Items.Clear();
  TreeFile.Items.BeginUpdate();

  for FileIndex:= 0 to FileRipper.GetTotalFileCount - 1 do
  begin
    EntryCount:= FileRipper.GetEntryCount(FileIndex);
    if EntryCount = 0 then
      Continue;

    FileNode:= TreeFile.Items.AddObject(nil, FileRipper.GetFileName(FileIndex), Pointer(FileIndex));
    //FileNode.StateIndex:= STATE_UNCHECKED;
    FormatTypeSet:= FileRipper.GetFormatTypeSet(FileIndex);
    for FormatIndex:= 0 to FormatCount - 1 do
    begin
      if FormatTypeSet^[FormatIndex] = nil then
        Continue;

      AddParent:= True;
      for EntryIndex:= 0 to EntryCount - 1 do
      begin
        FormatType:= FileRipper.GetEntryFormatType(FileIndex, EntryIndex);
        if FormatType^.Index = FormatTypeSet^[FormatIndex]^.Index then
        begin
          if AddParent then
          begin
            FormatNode:= TreeFile.Items.AddChildObject(FileNode, FormatType^.Extension, FormatType);
            AddParent:= False;
          end;
          TreeFile.Items.AddChildObject(FormatNode, FileRipper.GetEntryName(FileIndex, EntryIndex), Pointer(EntryIndex));
        end;
      end; // for J
    end; //for Ftype
  end; // for I

  TreeFile.Items.EndUpdate();
end;

procedure TFileRipForm.FillFormatTreeView;
var
  CurSec: TFormatSection;
  PrevSec: TFormatSection;
  FormatIndex: DWORD;
  FormatNode: TTreeNode;
  FormatType: PFormatType;

begin

  FormatNode:= nil;

  PrevSec:= FileRipper.GetFormatTableSection(0);  // Get first format in table to compare in loop correctly (and get formatNode)
  for FormatIndex:= 1 to FileRipper.GetFormatTableCount - 1 do
  begin
    CurSec:= FileRipper.GetFormatTableSection(FormatIndex);
    if PrevSec <> CurSec then
    begin
      FormatNode:= TreeFormat.Items.Add(nil, SectionToString(CurSec));
      PrevSec:= CurSec;
    end;
    FormatType:= FileRipper.GetFormatTableType(FormatIndex);
    TreeFormat.Items.AddChildObject(FormatNode, FormatType^.Extension, FormatType)
  end;
end;

procedure TFileRipForm.LogMsgRed (Msg:ShortString);
begin

  with RichEdit1 do
  begin
    SelAttributes.Color:= clRed;
    Lines.Add(Msg);
    SelStart:= Length(Lines.Text);
  end;
end;

procedure TFileRipForm.LogMsgBlue (Msg:ShortString);
begin

  with RichEdit1 do
  begin
    SelAttributes.Color:= clBlue;
    Lines.Add(Msg);
    SelStart:= Length(Lines.Text);
  end;
end;

procedure TFileRipForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  FileRipper.Destroy();
  UpdateSetting(slSAVE);
  SaveSetting();

  MainForm.miFileRipper.Enabled:= True;
  Action:= caFree;
end;

procedure TFileRipForm.FormCreate(Sender: TObject);
begin

  FileRipper:= TFileRipper.Create();
  FillFormatTreeView();
  LoadSetting();
  UpdateSetting(slLOAD);

  //SetWindowLong(TreeFile.Handle, GWL_STYLE, GetWindowLong(TreeFile.Handle, GWL_STYLE) or TVS_CHECKBOXES);
  SetWindowLong(TreeFile.Handle, GWL_STYLE, GetWindowLong(TreeFile.Handle, GWL_STYLE) or TVS_CHECKBOXES);
  SetWindowLong(TreeFormat.Handle, GWL_STYLE, GetWindowLong(TreeFormat.Handle, GWL_STYLE) or TVS_CHECKBOXES);
  EnableTreeControls(False);

  MultiGauge:= TMultiGaugeX.Create(Self);
  MultiGauge.Parent:= Self;
  MultiGauge.Top:= 380;
  MultiGauge.Left:= 4;
  MultiGauge.Width:= 472;
  MultiGauge.Height:= 15;
  MultiGauge.AutoResize:= True;

  ThreadProgressCount:= FileRipper.MaxThreadCount;
  MultiGauge.GaugeCount:= ThreadProgressCount;

  PnlLogger.Top:= MultiGauge.Top + MultiGauge.Height + 5;
  FileRipForm.Height:= PnlLogger.Top + PnlLogger.Height + 30;
end;

procedure TFileRipForm.RBtnSearchFileClick(Sender: TObject);
begin

  SetPnlSearchFile();
end;

procedure TFileRipForm.RBtnSearchFolderClick(Sender: TObject);
begin

  SetPnlSearchFolder();
end;

procedure TFileRipForm.TreeFileClick(Sender: TObject);
var
  FileNode, FormatNode: TTreeNode;
  FileIndex, EntryIndex: DWORD;
  I, J, K: Integer;
begin

  if TreeFile.Items.Count = 0 then
    Exit;

  for I := 0 to TreeFile.Items.Count - 1 do
  begin
    if TreeFile.Items[I].Parent <> nil then
      Continue;
    
    FileNode:= TreeFile.Items[I];
    FileIndex:= DWORD(FileNode.Data);
    if FileNode.Selected and (FileNode.Parent = nil) then
    begin
      LblChunkCountArch.Caption:= 'Chunks: ' + IntToStr(FileRipper.GetEntryCount(FileIndex));
      LblChunkSizeArch.Caption:= 'Size: ' + IntToStr(FileRipper.GetTotalEntrySize(FileIndex) div 1024) + ' KiB';
      Exit;
    end;

    for J := 0 to FileNode.Count - 1 do
    begin
      FormatNode:= FileNode[J];
      if FormatNode.Selected then
        Exit;

      for K := 0 to FormatNode.Count - 1 do
      begin
        if FormatNode[K].Selected then
        begin
          //MessageBeep (1);
          EntryIndex:= DWORD(FormatNode[K].Data);
          LblChunkOffsetSel.Caption:= 'Offset: ' + IntToStr(FileRipper.GetEntryOffset(FileIndex, EntryIndex));
          LblChunkSizeSel.Caption:= 'Size: ' + IntToStr(FileRipper.GetEntrySize(FileIndex, EntryIndex) div 1024) + ' KiB';
          Exit;
        end;
      end; // for K
    end; //for Ftype
  end; // for I
end;

procedure TFileRipForm.TreeFileMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  SelNode: TTreeNode;
begin

  SelNode:= TreeFile.GetNodeAt(X, Y);
  if SelNode=nil then
    Exit;

  SelNode.Selected:= True;
  if htOnStateIcon in TreeFile.GetHitTestInfoAt(X, Y) then
    CheckAllChildren(SelNode, IsChecked(SelNode));
end;

procedure TFileRipForm.TreeFormatMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  SelNode: TTreeNode;
  I: LongWord;
begin

  SelNode:= TreeFormat.GetNodeAt(X, Y);

  if SelNode=nil then
    Exit;

  SelNode.Selected:= true;

  if SelNode.Data <> nil then
  begin
    //TreeFormat.Hint:= 'Description: ' + PFormatEntry(SelNode.Data)^.FName;
  end;

  if SelNode.HasChildren then
  begin
    for I:= 0 to SelNode.Count-1 do
      SetChecked(SelNode.Item[I], IsChecked (SelNode));
  end;
end;

procedure TFileRipForm.BtnExtractAllClick(Sender: TObject);
var
  I, J, N:Integer;
begin

  N:= 0;
  UpdateSetting(slSAVE);
  FileRipper.SetTargetFolder(FileRipperSettting.TargetFolder);

  Gauge1.MaxValue:= FileRipper.GetTotalEntryCount();
  for I := 0 to FileRipper.GetTotalFileCount() - 1 do
  begin
    WriteText(FileRipperSettting.TargetFolder + 'FileList.txt', FileRipper.GetFilePath(I)+FileRipper.GetFileName(I));
    for J := 0 to FileRipper.GetEntryCount(I) - 1 do
    begin
      if FileRipper.ExtractEntry(I, J) then
      begin
        LogMsgBlue ('Extracted: ' + FileRipper.GetEntryName(I, J));
        Inc(N);
      end;

      Gauge1.Progress:= I + J;

      if IsRefreshTime() then
        Application.ProcessMessages();
    end;
  end;

  LogMsgRed ('Totally Extracted: ' + IntToStr(N) + ' from ' + IntToStr(FileRipper.GetTotalEntryCount()));
end;

procedure TFileRipForm.BtnDupeAllClick(Sender: TObject);
var
  I, J, N:Integer;
begin

  N:= 0;

  //Gauge1.MaxValue:= TreeFile.Items.Count-1;
  //FileRipper.SetExtractPath(FileRipperSettting.TargetFolder);
  Gauge1.MaxValue:= FileRipper.GetTotalEntryCount();
  for I := 0 to FileRipper.GetTotalFileCount() - 1 do
  begin
    for J:= 0 to FileRipper.GetEntryCount(I) - 1 do
    begin
      if FileRipper.DupeEntry(I, J) then
      begin
        LogMsgBlue ('Duped: ' + FileRipper.GetEntryName(I, J));
        Inc(N);
      end;

      Gauge1.Progress:= I + J;

      if IsRefreshTime() then
        Application.ProcessMessages();
    end;
  end; // for I

  LogMsgRed ('Totally Duped: ' + IntToStr(N) + ' from ' + IntToStr(FileRipper.GetTotalEntryCount()));
end;

procedure TFileRipForm.BtnDeleteAllClick(Sender: TObject);
var
  I, J, N:Integer;
begin

  N:= 0;

  //Gauge1.MaxValue:= TreeFile.Items.Count-1;
  Gauge1.MaxValue:= FileRipper.GetTotalEntryCount();
  for I := 0 to FileRipper.GetTotalFileCount() - 1 do
  begin
    for J:= 0 to FileRipper.GetEntryCount(I) - 1 do
    begin
      if FileRipper.DeleteEntry(I, J) then
      begin
        LogMsgBlue ('Deleted: ' + FileRipper.GetEntryName(I, J));
        Inc(N);
      end;

      Gauge1.Progress:= I + J;

      if IsRefreshTime() then
        Application.ProcessMessages();
    end;
  end; // for I

  LogMsgRed ('Totally Deleted: ' + IntToStr(N) + ' from ' + IntToStr(FileRipper.GetTotalEntryCount()));
end;

procedure TFileRipForm.BtnExtractClick(Sender: TObject);
var
  FileNode, FormatNode, EntryNode: TTreeNode;
  FileIndex, FormatIndex, EntryIndex: DWORD;
  TotalCheckedCount, TotalExtractedCount: DWORD;

begin

  UpdateSetting(slSAVE);
  FileRipper.SetTargetFolder(FileRipperSettting.TargetFolder);
  //CreateFolder(FileRipper.ExtractPath);

  TotalCheckedCount:= 0;
  TotalExtractedCount:= 0;

  Gauge1.MaxValue:= FileRipper.GetTotalFileCount();

  FileNode:= TreeFile.Items[0];
  for FileIndex := 0 to FileRipper.GetTotalFileCount() - 1 do
  begin
    //if IsChecked(FileNode)then
    //WriteText(FileRipperSettting.TargetFolder+'FileList.txt', FileRipper.GetFilePath(I)+FileRipper.GetFileName(I));
    for FormatIndex := 0 to FileNode.Count - 1 do
    begin
      FormatNode:= FileNode.Item[FormatIndex];
      for EntryIndex := 0 to  FormatNode.Count - 1 do
      begin
        EntryNode:= FormatNode.Item[EntryIndex];
        if IsChecked(EntryNode) then
        begin
          Inc(TotalCheckedCount);
          if FileRipper.ExtractEntry(FileIndex, EntryIndex) then
          begin
            LogMsgBlue ('Extracted: ' + FileRipper.GetEntryName(FileIndex, EntryIndex));
            Inc(TotalExtractedCount);
          end;
        end;
      end;
    end;

    FileNode:= FileNode.GetNextSibling();
    if IsRefreshTime() then
    begin
      Gauge1.Progress:= FileIndex;
      Application.ProcessMessages();
    end;
  end; // for I

  LogMsgRed ('Totally Extracted: ' + IntToStr(TotalExtractedCount) + ' from ' + IntToStr(TotalCheckedCount));
end;

procedure TFileRipForm.BtnDeleteClick(Sender: TObject);
var
  FileNode, FormatNode, EntryNode:TTreeNode;
  FileIndex, FormatIndex, EntryIndex: DWORD;
  TotalCheckedCount, TotalDeletedCount: DWORD;
begin

  TotalCheckedCount:= 0;
  TotalDeletedCount:= 0;

  Gauge1.MaxValue:= FileRipper.GetTotalFileCount();

  FileNode:= TreeFile.Items[0];
  for FileIndex := 0 to FileRipper.GetTotalFileCount() -1 do
  begin
    for FormatIndex := 0 to FileNode.Count - 1 do
    begin
      FormatNode:= FileNode.Item[FormatIndex];
      for EntryIndex := 0 to FormatNode.Count - 1 do
      begin
        EntryNode:= FormatNode.Item[EntryIndex];
        if IsChecked(EntryNode) then
        begin
          Inc(TotalCheckedCount);
          if FileRipper.DeleteEntry(FileIndex, EntryIndex) then
          begin
            LogMsgBlue ('Deleted: ' + FileRipper.GetEntryName(FileIndex, EntryIndex));
            Inc(TotalDeletedCount);
          end;
        end;
      end;
    end;

    FileNode:= FileNode.GetNextSibling();
    if IsRefreshTime() then
    begin
      Gauge1.Progress:= FileIndex;
      Application.ProcessMessages();
    end;
  end; // for I

  LogMsgRed ('Totally Deleted: ' + IntToStr(TotalDeletedCount) + ' from ' + IntToStr(TotalCheckedCount));
end;

procedure TFileRipForm.BtnReplaceClick(Sender: TObject);
var
  FileNode, FormatNode, EntryNode: TTreeNode;
  FileIndex, FormatIndex, EntryIndex: DWORD;
  TotalCheckedCount, TotalReplacedCount: DWORD;

begin

  if FileRipper.GetTotalFileCount() = 0 then
    Exit;

  TotalCheckedCount:= 0;
  TotalReplacedCount:= 0;

  Gauge1.MaxValue:= FileRipper.GetTotalFileCount();

  FileNode:= TreeFile.Items[0];
  for FileIndex := 0 to FileRipper.GetTotalFileCount() -1 do
  begin
    for FormatIndex := 0 to FileNode.Count - 1 do
    begin
      FormatNode:= FileNode.Item[FormatIndex];
      for EntryIndex := 0 to FormatNode.Count - 1 do
      begin
        EntryNode:= FormatNode.Item[EntryIndex];
        if IsChecked(EntryNode) then
        begin
          Inc(TotalCheckedCount);
          if FileRipper.DupeEntry(FileIndex, EntryIndex) then
          begin
            LogMsgBlue ('Replaced: ' + FileRipper.GetEntryName(FileIndex, EntryIndex));
            Inc(TotalReplacedCount);
          end;
        end;
      end;
    end;

    FileNode:= FileNode.GetNextSibling();
    if IsRefreshTime() then
    begin
      Gauge1.Progress:= FileIndex;
      Application.ProcessMessages();
    end;
  end; // for I

  LogMsgRed ('Replaced: ' + IntToStr(TotalReplacedCount) + ' from ' + IntToStr(TotalCheckedCount));
end;

procedure TFileRipForm.BtnOpenClick(Sender: TObject);
var
  FileNode, FormatNode, EntryNode: TTreeNode;
  FileIndex, EntryIndex: DWORD;
  FormatType: PFormatType;
  ExecCommand, FileName, FileExt: String;

begin

  if TreeFile.Items.Count = 0 then
    Exit;

  if TreeFile.SelectionCount = 0 then
    Exit;

  if TreeFile.Selected.Level <> 2 then
    Exit;

  EntryNode:= TreeFile.Selected;
  FormatNode:= EntryNode.Parent;
  FileNode:= FormatNode.Parent;

  //FileIndex:= DWORD(FileNode.Data);
  //EntryIndex:= DWORD(EntryNode.Data);
  FileIndex:= FileNode.Index;
  EntryIndex:= EntryNode.Index;

  FormatType:= FormatNode.Data;
  FileExt:= FormatType^.Extension;

  if (FileExt = 'BIK') then
  begin
    FileName:= FileRipper.GetFileFullName(FileIndex);
    ExecCommand:= ExePath + INTERNAL_PATH + 'BinkPlaya.exe -file "' + FileName +
      '" -offset ' + IntToStr(FileRipper.GetEntryOffset(FileIndex, EntryIndex));
    if ExecAndWait(ExecCommand, 1) <> 0 then
      ShowErrorMessage('Error happened when executing BinkPlaya!');
  end
    else
  if (FileExt = 'WAV') or (FileExt = 'OGG') or (FileExt = 'AIFF') then
  begin
    FileName:= FileRipper.GetFileFullName(FileIndex);
    ExecCommand:= ExePath + INTERNAL_PATH + 'BassPlaya.exe -file "' + FileName +
      '" -offset ' + IntToStr(FileRipper.GetEntryOffset(FileIndex, EntryIndex)) +
      ' -size ' + IntToStr(FileRipper.GetEntrySize(FileIndex, EntryIndex));

    if ExecAndWait(ExecCommand, 1) <> 0 then
      ShowErrorMessage('Error happened when executing BinkPlaya!');
  end
    else
  begin
    // No plugin found, save file to temp and try it to launch with default application
    FileName:= GetRandomFileName(ExePath + TEMP_PATH, FormatType^.Extension);
    FileRipper.ExtractEntry(FileIndex, EntryIndex, FileName);
    if not ExecuteFile(FileName) then
      ShowErrorMessage('No association for file extension found!');
  end;
end;

procedure TFileRipForm.BtnHEXClick(Sender: TObject);
var
  FileNode, FormatNode, EntryNode: TTreeNode;
  FileIndex, EntryIndex: DWORD;
  FileName: String;
  ExecCommand: String;

begin

  if TreeFile.Items.Count = 0 then
    Exit;

  if TreeFile.SelectionCount = 0 then
    Exit;

  if TreeFile.Selected.Level <> 2 then
    Exit;

  EntryNode:= TreeFile.Selected;
  FormatNode:= EntryNode.Parent;
  FileNode:= FormatNode.Parent;

  //FileIndex:= DWORD(FileNode.Data);
  //EntryIndex:= DWORD(EntryNode.Data);
  FileIndex:= FileNode.Index;
  EntryIndex:= EntryNode.Index;

  FileName:= FileRipper.GetFileFullName(FileIndex);
  ExecCommand:= ExePath + INTERNAL_PATH + 'HexViewer.exe -file "' + FileName +
    '" -offset ' + IntToStr(FileRipper.GetEntryOffset(FileIndex, EntryIndex)) +
    ' -size ' + IntToStr(FileRipper.GetEntrySize(FileIndex, EntryIndex));

  if ExecAndWait(ExecCommand, 1) <> 0 then
    ShowErrorMessage('Error happened when executing HexViewer!');
end;

procedure TFileRipForm.EnableTreeControls (Enabled:boolean);
begin

  EnableControl(GBoxCheck, Enabled);
  EnableControl(GBoxChecked, Enabled);
  //EnableControl(GBoxSelected, Enabled);
  EnableControl(GBoxAll, Enabled);
end;

procedure TFileRipForm.BtnSearchClick(Sender: TObject);
var
  I, N:LongWord;
  Timer:TProcTimer;

  procedure ResetSettings;
  begin
    if FileRipper.GetTotalFileCount > 0 then
    FileRipper.UnloadFiles;

    EnableSearchPanel (PnlSearch, true);
  end;

begin

  UpdateSetting (slSAVE);

  if FileRipper.GetTotalFileCount > 0 then
    FileRipper.UnloadFiles();

  RichEdit1.Clear();
  EnableSearchPanel (PnlSearch, false);

  LogMsgBlue ('Collecting information...');

  case FileRipperSettting.SearchOption of
    soLoadSingleFile:
    begin
      FileRipper.SetSourceFolder(ExtractFilePath(FileRipperSettting.SourceFile));
      FileRipper.LoadFile(FileRipperSettting.SourceFile);
      LogMsgBlue ('File Loaded: ' + FileRipperSettting.SourceFile);
    end;
    soLoadMultiFile:
    begin
      FileRipper.SetSourceFolder(FileRipperSettting.SourceFolder);
      FileRipper.LoadFiles(FileRipperSettting.SourceExt);
      LogMsgBlue ('Files Found: ' + IntToStr(FileRipper.GetTotalFileCount));
    end;
  end;

  if FileRipper.GetTotalFileCount = 0 then
  begin
    LogMsgRed('No files found!');
    ResetSettings();
    Exit;
  end;

  N:= 0;
  for I:= 0 to TreeFormat.Items.Count - 1 do
  begin
    if (TreeFormat.Items[I].Data <> nil) and IsChecked (TreeFormat.Items[I])then
    begin
      FileRipper.IncludeFormat(PFormatType(TreeFormat.Items[I].Data));
      Inc(N);
    end;
  end;

  if N = 0 then
  begin
    LogMsgRed('No formats to search selected!');
    ResetSettings();
    Exit;
  end;

  FileRipper.SetProgressCallback(FileRipperCallback);

  LogMsgBlue('-------------------------------------');
  LogMsgRed('Scanning files...');
  StartTimer(Timer);

  FileRipper.StartSearch();
  StopTimer(Timer);
  //LogMsgBlue ('File: ' + FileRipper.GetFileName(I));
  LogMsgBlue('Entries found: ' + IntToStr(FileRipper.GetTotalEntryCount));
  LogMsgBlue('Identified: ' + IntToStr(FileRipper.GetTotalEntrySize) + ' KiB from ' + IntToStr(FileRipper.GetTotalFileSize) + ' KiB (' + IntToStr(Round(FileRipper.GetTotalEntrySize / (FileRipper.GetTotalFileSize / 100))) + '%)');
  Application.ProcessMessages();
  LogMsgRed('Scanning finished in: ' + IntToStr(Timer.TotalTime) + ' ms');
  LogMsgBlue('-------------------------------------');

  FillFileTreeView();

  EnableSearchPanel(PnlSearch, True);
  EnableTreeControls(True);

  LblChunkCountTot.Caption:= 'Chunks: ' + IntToStr(FileRipper.GetTotalEntryCount);
  LblChunkSizeTot.Caption:= 'Size: ' + IntToStr(FileRipper.GetTotalEntrySize div 1024) + ' KiB';

  LogMsgBlue('All operations done!');
 end;

procedure TreeViewCheckAll(const TreeView:TTreeView;IsChecked:boolean);
var
  I: LongWord;
begin

  if TreeView.Items.Count = 0 then
    Exit;

  for I:= 0 to TreeView.Items.Count - 1 do
  begin
    SetChecked(TreeView.Items[I], IsChecked);
  end;
end;

procedure TFileRipForm.BtnCancelClick(Sender: TObject);
begin

  FileRipper.StopSearch();
  BtnSearch.Enabled:= True;
end;

procedure TFileRipForm.BtnPauseClick(Sender: TObject);
begin

  FileRipper.PauseSearch();
end;

procedure TFileRipForm.BtnCheckAllClick(Sender: TObject);
begin

  TreeViewCheckAll(TreeFile, True);
end;

procedure TFileRipForm.BtnCheckNoneClick(Sender: TObject);
begin

  TreeViewCheckAll(TreeFile, False);
end;

procedure TFileRipForm.BtnSelectAllClick(Sender: TObject);
begin

  TreeViewCheckAll(TreeFormat, True);
end;

procedure TFileRipForm.BtnSelectNoneClick(Sender: TObject);
begin

  TreeViewCheckAll(TreeFormat, False);
end;

procedure TFileRipForm.BtnSourceFileClick(Sender: TObject);
begin

  if ExecDialog(OpenDialog1, FileRipperSettting.SourceFile, '*.*', FileRipperSettting.SourceFile, false) then
    EdtSourceFile.Text:= FileRipperSettting.SourceFile;
end;

procedure TFileRipForm.BtnSourceFolderClick(Sender: TObject);
begin

  EdtSourceFolder.Text:= BrowseDialog('Select Folder:', FileRipperSettting.SourceFolder);
end;

procedure TFileRipForm.BtnTargetFolderClick(Sender: TObject);
begin

  EdtTargetFolder.Text:= BrowseDialog('Select Folder:', FileRipperSettting.TargetFolder);
end;

end.
