unit FileRipper;


interface

uses
  Windows,
  Classes,
  SysUtils,
  SharedFunc,
  FileRipperSections,
  FileRipperFormats,
  FileRipperShared,
  FileRipperExtensions,
  FileRipperHeaders,
  FileRipperMarkers,
  FileRipperScanner,
  AsmFun,
  BlankFiles;

type
  TFileRipper = Class (TObject)
   private
    FProcessState: TProcessState;
    FIsMultiThreading: BOOLEAN;
    FMaxThreadCount: DWORD;

    FSourceFolder: String;
    FTargetFolder: String;
    FFileData: TFileDataArray;
    FFileDataCount: DWORD;
    FFileDataAvailable: DWORD;
    FProgressCallback: TProgressCallback;

    FEntryTotalSize: DWORD;
    FEntryTotalCount: DWORD;

    FFileTotalSize: DWORD;

    //function GetFormatType (const FileData:PFileData; var Format:TFormatType; var Offset:DWORD; var Size:DWORD):Boolean;
    //procedure AddEntryData (const FileData:PFileData; const EntryFormat:TFormatType; const EntryOffset:DWORD; const EntrySize:DWORD);
    procedure LoadFilesInt(const SourceFolder, SourceExt:String);
    procedure ResetRipper;

   public
    property IsMultiThreading: BOOLEAN read FIsMultiThreading;
    property MaxThreadCount: DWORD read FMaxThreadCount;

    constructor Create; 
    destructor Destroy; 

    //procedure ReportError(const FileData:PFileData; const Offset:DWORD; const Size:DWORD);

    function GetTotalFileCount:DWORD;
    function GetTotalFileSize:DWORD;

    function GetTotalEntrySize:DWORD; overload; 
    function GetTotalEntryCount:DWORD; overload; 
    function GetTotalEntrySize(const FileIndex:DWORD):DWORD; overload; 

    procedure LoadFiles(const SourceExt:String); 
    procedure LoadFile(const FileName:String);
    procedure UnloadFile(const FileIndex:DWORD);
    procedure UnloadFiles;

    procedure SetSourceFolder(const SourceFolder:String); 
    procedure SetTargetFolder(const TargetFolder:String); 
    procedure SetProgressCallback (const Proc:TProgressCallback);

    function GetFileName(const FileIndex:DWORD):String; 
    function GetFileFullName(const FileIndex:DWORD):String;
    function GetFilePath(const FileIndex:DWORD):String;
    function GetFileSize(const FileIndex:DWORD):DWORD; 
    function GetFormatTypeSet(const FileIndex:DWORD):PFormatTypeSet;

    function GetEntryName(const FileIndex, EntryIndex:DWORD):String;
    function GetEntrySize(const FileIndex, EntryIndex:DWORD):DWORD;
    function GetEntryOffset(const FileIndex, EntryIndex:DWORD):DWORD;
    function GetEntryFormatType(const FileIndex, EntryIndex:DWORD):PFormatType;
    function GetEntryCount(const FileIndex:DWORD):DWORD; 

    function GetEntryTotalSize(const FileIndex:DWORD):DWORD;

    //procedure IncludeFormat(const FileIndex:DWORD; const Format:TFormatType); overload;
    //procedure ExcludeFormat(const FileIndex:DWORD; const Format:TFormatType); overload;

    procedure IncludeFormat(const Format:PFormatType);
    procedure ExcludeFormat(const Format:PFormatType);

    function GetFormatTableSectionCount:DWORD; 
    function GetFormatTableCount:DWORD;

    function GetFormatTableSection(const TableIndex:DWORD):TFormatSection;
    function GetFormatTableType(const TableIndex:DWORD):PFormatType;
    function GetFormatTableDescription(const TableIndex:DWORD):String;
    function GetFormatTableExtension(const TableIndex:DWORD):String;
    //function GetFormatTableData(const TableIndex:DWORD):PFormatEntry;

    procedure StartSearch();
    procedure PauseSearch();
    procedure StopSearch();

    function ExtractEntry(const FileIndex, EntryIndex:DWORD):Boolean; overload;
    function ExtractEntry(const FileIndex: DWORD; const EntryIndex: DWORD; const FileName:String):Boolean; overload;
    function DupeEntry(const FileIndex, EntryIndex:DWORD):boolean;
    function DeleteEntry(const FileIndex, EntryIndex:DWORD):boolean;

 end;

const
  MAXIMUM_PROCESSORS = 32;

//function SetThreadIdealProcessor(hThread: THandle; dwIdealProcessor: DWORD): DWORD; stdcall; external 'kernel32.dll' name 'SetThreadIdealProcessor';

implementation

///////////////////////////////////////
constructor TFileRipper.Create;
begin
  inherited Create;
  FProcessState:=ProcessStopped;
  SetLength(FFileData, 0);
  FFileDataCount:=0;
  FSourceFolder:='';
  FTargetFolder:='';
  FEntryTotalSize:=0;
  FEntryTotalCount:=0;
  FFileDataAvailable:=0;

  FMaxThreadCount:=GetProcessorCount;

  if FMaxThreadCount > 1 then
  FIsMultiThreading:= True
  else FIsMultiThreading:= False;
end; 
///////////////////////////////////////
destructor TFileRipper.Destroy; 
begin
  ResetRipper;
  inherited Destroy;
end; 
///////////////////////////////////////
procedure TFileRipper.ResetRipper; 
begin
  SetLength(FFileData, 0);
  FFileDataAvailable:=0;
  FFileDataCount:=0;
  FSourceFolder:='';
  FTargetFolder:='';
  FEntryTotalSize:=0;
  FEntryTotalCount:=0;
  //FProgressCallback:=nil;
  //FIsMultiThreading:=False;
  //FMaxThreadCount:=1;
end;
///////////////////////////////////////
function TFileRipper.GetTotalFileCount:DWORD;
begin
  Result:=FFileDataCount;
end;
///////////////////////////////////////
function TFileRipper.GetTotalFileSize:DWORD;
begin
  Result:=FFileTotalSize;
end;
///////////////////////////////////////
function TFileRipper.GetTotalEntryCount:DWORD;
begin
  Result:=FEntryTotalCount;
end;
///////////////////////////////////////
function TFileRipper.GetTotalEntrySize:DWORD;
begin
  Result:=FEntryTotalSize;
end;
///////////////////////////////////////
function TFileRipper.GetTotalEntrySize(const FileIndex:DWORD):DWORD;
begin
  Result:=FFileData[FileIndex]^.EntryDataTotalSize;
end;
///////////////////////////////////////
function TFileRipper.GetFileName(const FileIndex:DWORD):String;
begin
  Result:=FFileData[FileIndex]^.FileName;
end;
///////////////////////////////////////
function TFileRipper.GetFileFullName(const FileIndex:DWORD):String;
begin
  Result:=FFileData[FileIndex]^.FullName;
end; 
///////////////////////////////////////
function TFileRipper.GetFilePath(const FileIndex:DWORD):String;
begin
  Result:=FFileData[FileIndex]^.FilePath;
end;
///////////////////////////////////////
function TFileRipper.GetFileSize(const FileIndex:DWORD):DWORD;
begin
  Result:=FFileData[FileIndex]^.FileSize;
end; 
///////////////////////////////////////
function TFileRipper.GetFormatTypeSet(const FileIndex:DWORD):PFormatTypeSet;
begin
  Result:=@FFileData[FileIndex]^.ScanFormats;
end;
///////////////////////////////////////
function TFileRipper.GetEntryName(const FileIndex: DWORD; const EntryIndex: DWORD):String;
begin
  Result:=FFileData[FileIndex]^.EntryData[EntryIndex].Name;
end;
///////////////////////////////////////
function TFileRipper.GetEntrySize(const FileIndex: DWORD; const EntryIndex: DWORD):DWORD;
begin
  Result:=FFileData[FileIndex]^.EntryData[EntryIndex].Size;
end;
///////////////////////////////////////
function TFileRipper.GetEntryOffset(const FileIndex: DWORD; const EntryIndex: DWORD):DWORD;
begin
  Result:=FFileData[FileIndex]^.EntryData[EntryIndex].Offset;
end;
///////////////////////////////////////
function TFileRipper.GetEntryFormatType(const FileIndex: DWORD; const EntryIndex: DWORD):PFormatType;
begin
  Result:=FFileData[FileIndex]^.EntryData[EntryIndex].Format;
end;
///////////////////////////////////////
function TFileRipper.GetEntryCount(const FileIndex:DWORD):DWORD;
begin
  Result:=FFileData[FileIndex]^.EntryDataCount;
end;
///////////////////////////////////////
function TFileRipper.GetEntryTotalSize(const FileIndex:DWORD):DWORD;
begin
  Result:=FFileData[FileIndex]^.EntryDataTotalSize;
end;
///////////////////////////////////////
procedure TFileRipper.SetTargetFolder(const TargetFolder:String);
begin
  FTargetFolder:=TargetFolder;
end; 
///////////////////////////////////////
procedure TFileRipper.SetSourceFolder(const SourceFolder:String);
begin
  FSourceFolder:=SourceFolder; 
end;
///////////////////////////////////////
procedure TFileRipper.SetProgressCallback (const Proc:TProgressCallback);
begin
  FProgressCallback:=Proc;
end;
///////////////////////////////////////
function TFileRipper.GetFormatTableSectionCount:DWORD;
begin
  Result:=SectionCount;
end;
///////////////////////////////////////
function TFileRipper.GetFormatTableCount:DWORD;
begin
  Result:=FormatCount;
end;
///////////////////////////////////////
function TFileRipper.GetFormatTableSection(const TableIndex:DWORD):TFormatSection;
begin
  Result:=FormatTable[TableIndex].Section;
end;
///////////////////////////////////////
function TFileRipper.GetFormatTableType(const TableIndex:DWORD):PFormatType;
begin
  Result:=FormatTable[TableIndex];
end;
///////////////////////////////////////
function TFileRipper.GetFormatTableDescription(const TableIndex:DWORD):String;
begin
  Result:=FormatTable[TableIndex]^.Description;
end;
///////////////////////////////////////
function TFileRipper.GetFormatTableExtension(const TableIndex:DWORD):String;
begin
  Result:=FormatTable[TableIndex]^.Extension;
end;
///////////////////////////////////////
procedure TFileRipper.IncludeFormat(const Format:PFormatType);
var
  i:DWORD;
begin
  for i := 0 to FFileDataCount - 1 do
  begin
    FileRipperFormats.IncludeFormat(@FFileData[i]^.ScanFormats, Format);
  end;
end;
///////////////////////////////////////
procedure TFileRipper.ExcludeFormat(const Format:PFormatType);
var
  i:DWORD;
begin
  for i := 0 to FFileDataCount - 1 do
  begin
    FileRipperFormats.ExcludeFormat(@FFileData[i]^.ScanFormats, Format);
  end;
end;
///////////////////////////////////////
procedure TFileRipper.LoadFilesInt(const SourceFolder, SourceExt:String);
var
  CheckExt: Boolean;
  TargetExt: String;
  Found: DWORD;
  SRec: TSearchRec; 
begin
  try
    CheckExt:= SourceExt <> '*.*';
    Found:=FindFirst(SourceFolder + '*.*', faAnyFile, SRec);
    while Found=0 do
    begin
      if (SRec.Attr and faDirectory = faDirectory) and (SRec.Name <> '..') and (SRec.Name <> '.')  then
      LoadFilesInt(SourceFolder + SRec.Name + '\', SourceExt)
        else
      begin
        if (SRec.Name <> '.') and (SRec.Name <> '..') then
        begin
          if CheckExt then
          begin
            TargetExt:=LowerCase(ExtractFileExt(SRec.Name));
            if TargetExt = SourceExt then
            begin
              if SRec.Size > 64 then
              LoadFile(SourceFolder + SRec.Name);
            //LogMsgBlue ('File Loaded: ' + sDir+SRec.Name);
            end;
          end
            else
          begin
            TargetExt:= ExtractFileExt(SRec.Name);
            // Check if its real extension
            if (Length(TargetExt) > 1) and (TargetExt[1] = '.') then
            begin
              if SRec.Size > 64 then
              LoadFile(SourceFolder + SRec.Name);
            end;
          end;
        end;
      end;
    Found:=FindNext(SRec);
    end; 
  finally
    FindClose(SRec)
  end; 
end; 
///////////////////////////////////////
procedure TFileRipper.LoadFiles(const SourceExt:String);
begin
  FFileDataCount:= 0;
  FFileDataAvailable:= 0;
  LoadFilesInt(FSourceFolder, SourceExt);
end;
///////////////////////////////////////
procedure TFileRipper.LoadFile(const FileName: String); 
var
  Index:DWORD;
  FileData: PFileData;
begin
  if not FileExists (FileName) then
  Exit;

  Inc (FFileDataCount);
  if FFileDataAvailable = 0 then
  begin
    SetLength(FFileData, FFileDataCount + 128);
    FFileDataAvailable:=128;
  end;

  Index:= FFileDataCount - 1;
  //FileData:=nil;
  GetMem(FileData, SizeOf(TFileData));
  //if FileData = nil then
  //Exit;

  FillChar(FileData^, SizeOf(TFileData), $00);
  FFileData[Index]:=FileData;

  FileData.FullName:=FileName;
  FileData.FileName:=ExtractFileName(FileName);
  FileData.FilePath:=Copy(ExtractFilePath(FileName), Length(FSourceFolder)+1, Length(FileName)- Length(FSourceFolder)- Length(FileData^.FileName));
  SetLength(FileData^.EntryData, 1);
  Dec(FFileDataAvailable);
end;
///////////////////////////////////////
procedure TFileRipper.UnloadFile(const FileIndex:DWORD);
var
  FileData: PFileData;
begin
  if FFileDataCount = 0 then
  Exit;

  FileData:=FFileData[FileIndex];
  if FileData.IsFileOpened then
  FileClose(FileData);

end;
///////////////////////////////////////
procedure TFileRipper.UnloadFiles; 
var
  FileIndex:DWORD;
begin
  for FileIndex := 0 to FFileDataCount - 1 do
  UnloadFile(FileIndex);
  
  ResetRipper;
end; 

function TFileRipper.DeleteEntry(const FileIndex: DWORD; const EntryIndex: DWORD):boolean;
var
  InBuffer:Pointer;
  FileData:PFileData;
  EntryData: PFormatEntry;
  ChunkIndex, ChunkCount, ChunkSize: DWORD;
  DataNeed: DWORD;
begin


  try
    if (FileIndex + 1) > FFileDataCount then
    begin
      Result:= False;
      Exit;
    end;

    FileData:=FFileData[FileIndex];
    if (EntryIndex + 1) > FileData^.EntryDataCount then
    begin
      Result:= False;
      Exit;
    end;

    EntryData:= @FileData^.EntryData[EntryIndex];
    if EntryData^.Size = 0 then
    begin
      Result:= True;
      Exit;
    end;


    DataNeed:= EntryData^.Size;
    ChunkCount:= EntryData^.Size div 4096;
    if (ChunkCount = 0) or ((EntryData^.Size mod 4096) > 0)  then
    Inc(ChunkCount);

    GetMem (InBuffer, 4096);
    FillChar(InBuffer^, 4096, $00);

    FileOpen(FileData);
    FileSeek(FileData, EntryData^.Offset);
    for ChunkIndex := 0 to ChunkCount - 1 do
    begin
      if DataNeed < 4096 then
      ChunkSize:= DataNeed
      else ChunkSize:= 4096;

      if ChunkSize = 0 then
      Break;

      FileWrite(FileData, InBuffer^, ChunkSize);

      Dec(DataNeed, ChunkSize);
    end;
    FileClose(FileData);
    FreeMem (InBuffer);
    Result:=True;
  except
    Result:=False;
    if FileData^.IsFileOpened then
    FileClose(FileData);

    if (InBuffer = nil) then
    FreeMem(InBuffer);

    //MessageBoxLg('ERROR:' + FName + ' Offset: ' + IntToStr(FSize), 'Shitty error', 0);
  end;
end;
///////////////////////////////////////
function TFileRipper.ExtractEntry(const FileIndex: DWORD; const EntryIndex: DWORD):Boolean;
var
  FileData:PFileData;
  EntryData: PFormatEntry;
  ExtractPath:String;
begin
  try
    if (FileIndex + 1) > FFileDataCount then
    begin
      Result:= False;
      Exit;
    end;

    FileData:=FFileData[FileIndex];
    if (EntryIndex + 1) > FileData^.EntryDataCount then
    begin
      Result:= False;
      Exit;
    end;

    EntryData:= @FileData^.EntryData[EntryIndex];
    if EntryData^.Size = 0 then
    begin
      Result:= True;
      Exit;
    end;

    ExtractPath:=FTargetFolder;
    if Length(FileData^.FilePath) > 0 then
    ExtractPath:= ExtractPath + '\' + FileData^.FilePath + '\';

    CreateFolder(ExtractPath);
    ExtractEntry(FileIndex, EntryIndex, ExtractPath + EntryData^.Name);
    Result:=True;
  except
    Result:=False;
    //MessageBoxLg('ERROR:' + FName + ' Offset: ' + IntToStr(FSize), 'Shitty error', 0);
  end;
end;
///////////////////////////////////////
function TFileRipper.ExtractEntry(const FileIndex: DWORD; const EntryIndex: DWORD;const FileName:String):Boolean;
var
  OutFile: File of BYTE;
  InBuffer:Pointer;
  FileData:PFileData;
  EntryData: PFormatEntry;
  ChunkIndex, ChunkCount, ChunkSize: DWORD;
  DataNeed, DataRead: DWORD;
  //ExtractPath:String;
begin
  try
    if (FileIndex + 1) > FFileDataCount then
    begin
      Result:= False;
      Exit;
    end;

    FileData:=FFileData[FileIndex];
    if (EntryIndex + 1) > FileData^.EntryDataCount then
    begin
      Result:= False;
      Exit;
    end;

    EntryData:= @FileData^.EntryData[EntryIndex];
    if EntryData^.Size = 0 then
    begin
      Result:= True;
      Exit;
    end;

    DataNeed:= EntryData^.Size;
    ChunkCount:= EntryData^.Size div 4096;
    if (ChunkCount = 0) or ((EntryData^.Size mod 4096) > 0)  then
    Inc(ChunkCount);

    GetMem (InBuffer, 4096);
    //FillChar(InBuffer^, 4096, $00);

    AssignFile(OutFile, FileName);
    Rewrite(OutFile);

    FileOpen(FileData);
    FileSeek(FileData, EntryData^.Offset);
    for ChunkIndex := 0 to ChunkCount - 1 do
    begin
      if DataNeed < 4096 then
      ChunkSize:= DataNeed
      else ChunkSize:= 4096;

      if ChunkSize = 0 then
      Break;

      DataRead:=FileRead(FileData, InBuffer^, ChunkSize);
      if DataRead = 0 then
      Break;

      BlockWrite(OutFile, InBuffer^, DataRead);

      Dec(DataNeed, DataRead);
    end;
    FileClose(FileData);
    CloseFile(OutFile);
    FreeMem (InBuffer);
    Result:=True;
  except
    Result:=False;
    if FileData^.IsFileOpened then
    FileClose(FileData);

    if (InBuffer = nil) then
    FreeMem(InBuffer);

    //MessageBoxLg('ERROR:' + FName + ' Offset: ' + IntToStr(FSize), 'Shitty error', 0);
  end;
end;
///////////////////////////////////////
function TFileRipper.DupeEntry(const FileIndex: DWORD; const EntryIndex: DWORD):boolean; 
var
  FileData:PFileData; 
begin
  Result:=False;
  (*
  FileData:=FFileData[FileIndex]; 
  with FileData^.EData[EntryIndex]^ do
  begin
    try
      if not DeleteEntry(FileIndex, EntryIndex) then
      exit; 

      FSeek (FileData, EOffset);
      case EFormat of
        FORMAT_TYPE_WAV0: FWrite (FileData, BlankWAV[0], Length(BlankWAV));
        FORMAT_TYPE_OGG0: FWrite (FileData, BlankOGG[0], Length(BlankOGG));
        FORMAT_TYPE_BIK0: FWrite (FileData, BlankBIK[0], Length(BlankBIK));
      end;
      Result:=True;
    except
      Result:=False;
    end;
  end;
  *)
end;
///////////////////////////////////////
procedure TFileRipper.StartSearch();
(*
type
  TThreadDataEntry = Record
    FileData: PFileData;
    ThreadHandle: DWORD;
    ThreadID: DWORD;
  end;
*)
var
  //FileData: PFileData;
  FileDataIndex, FileDataCount: DWORD;
  FileDataAvailable:DWORD;
  ThreadIndex, ThreadCount: DWORD;

  ThreadDataTable: Array[0..MAXIMUM_PROCESSORS - 1] of PFileData;
  ThreadHandleTable: Array[0..MAXIMUM_PROCESSORS - 1] of DWORD;
  ThreadMask: DWORD;

  ThreadHandle: DWORD;
  ThreadData: PFileData;
  ThreadState: DWORD;
  IsThreadRunning: BOOLEAN;
begin
  (*
  // Only for intel
  FMaxThreadCount:= 1;
  if IsIntelProcessor then
  begin
    if IntelIsHyperThreading then
    FMaxThreadCount:= IntelGetCoreCount * 2
    else FMaxThreadCount:=IntelGetCoreCount;
  end;
  *)

  if FFileDataCount = 0 then
  Exit;

  FFileTotalSize:= 0;
  FEntryTotalSize:= 0;
  FEntryTotalCount:= 0;

  // We check if we load only single file, if yes then we execute simple searching
  // without thread managment
  FProcessState:= ProcessRunning;
  if FFileDataCount = 1 then
  begin
    ThreadData:=FFileData[0];
    ThreadHandle:=CreateThread(nil, 0, @ExecuteGlobalScanner, ThreadData, 0, ThreadHandle);

    //while FileData.IsProcessing do
    while True do
    begin
      FProgressCallback(0, 0, ThreadData^.FilePos, ThreadData^.FileSize);

      ThreadState:=WaitForSingleObject(ThreadHandle, 100);
      if ThreadState <> WAIT_TIMEOUT then
      begin
        CloseHandle(ThreadHandle);
        Break;
      end;
    end;
    
    Inc(FFileTotalSize, ThreadData^.FileSize div 1024);

    Inc(FEntryTotalCount, ThreadData^.EntryDataCount);
    Inc(FEntryTotalSize, ThreadData^.EntryDataTotalSize div 1024);

    FProcessState:= ProcessStopped;

    Exit;
  end;

  // Check if we have more threads than files loaded
  if FMaxThreadCount > FFileDataCount then
  ThreadCount:=FFileDataCount
  else ThreadCount:=FMaxThreadCount;

  FillChar(ThreadHandleTable, MAXIMUM_PROCESSORS * SizeOf(DWORD), 0);

  FileDataIndex:=0;
  FileDataCount:=FFileDataCount;
  FileDataAvailable:=FFileDataCount;
  IsThreadRunning:=False;

  // We check if any thread is running and if yes then we continue looping
  // Also when we did not processed all files yet, then we continue too
  while IsThreadRunning or (FileDataAvailable > 0) do
  begin
    if FProcessState <> ProcessRunning then
    begin
      if FProcessState = ProcessPaused then
      begin
        repeat
          FProgressCallback(0, 0, 0, 0);
          Sleep(50);
        until FProcessState <> ProcessPaused;
      end;

      if FProcessState = ProcessStopped then
      begin
        for ThreadIndex := 0 to ThreadCount - 1 do
        begin
          ThreadHandle:=ThreadHandleTable[ThreadIndex];
          if (ThreadHandle <> 0) then
          SuspendThread(ThreadHandle);
        end;
        // We exit from loop here, we stopped searching process manually
        Break;
      end;
    end;

    IsThreadRunning:=False;
    for ThreadIndex := 0 to ThreadCount - 1 do
    begin
      ThreadHandle:=ThreadHandleTable[ThreadIndex];
      if (ThreadHandle = 0) and (FileDataAvailable > 0) then
      begin
        //if FileDataIndex = 49 then
        //BreakPoint;

        //FProgressCallback(ThreadIndex, FileDataIndex, $FFFFFFFF, $FFFFFFFF);

        ThreadData:=FFileData[FileDataIndex];
        //if ThreadData^.IsProcessing then
        //Halt(0);
        //if ThreadData^.FileName = 'Samurai.lot' then
        //BreakPoint;

        ThreadHandle:=CreateThread(nil, 0, @ExecuteGlobalScanner, ThreadData, CREATE_SUSPENDED, ThreadHandle);

        // Set processor for current thread
        ThreadMask:= 1 shl ThreadIndex;
        //ThreadMask:=SetThreadIdealProcessor(ThreadHandle, ThreadMask);

        if SetThreadAffinityMask(ThreadHandle, ThreadMask) = 0 then
        Exit;

        // Resume thread
        if FAILED(ResumeThread(ThreadHandle)) then
        Exit;

        FProgressCallback(ThreadIndex, FileDataIndex, $FFFFFFFF, ThreadData^.FileSize);

        IsThreadRunning:= True;
        ThreadHandleTable[ThreadIndex]:=ThreadHandle;
        ThreadDataTable[ThreadIndex]:=ThreadData;

        Inc(FileDataIndex);
        Dec(FileDataAvailable);
      end;

      if ThreadHandle <> 0 then
      begin
        ThreadData:=ThreadDataTable[ThreadIndex];
        FProgressCallback(ThreadIndex, FileDataIndex, ThreadData^.FilePos, ThreadData^.FileSize);

        ThreadState:=WaitForSingleObject(ThreadHandle, 100);
        if ThreadState <> WAIT_TIMEOUT then
        begin
          //GetExitCodeThread

          Inc(FFileTotalSize, ThreadData^.FileSize div 1024);

          Inc(FEntryTotalCount, ThreadData^.EntryDataCount);
          Inc(FEntryTotalSize, ThreadData^.EntryDataTotalSize div 1024);

          CloseHandle(ThreadHandle);
          ThreadHandleTable[ThreadIndex]:=0;
          ThreadDataTable[ThreadIndex]:=0;
        end;
      end;

    end;
    // Check if any thread is running
    for ThreadIndex := 0 to ThreadCount - 1 do
    begin
      if ThreadHandleTable[ThreadIndex] <> 0 then
      begin
        IsThreadRunning:= True;
        Break;
      end;
    end;
  end;

  FProcessState:= ProcessStopped;
end;

///////////////////////////////////////
procedure TFileRipper.PauseSearch();
begin
  if FProcessState = ProcessPaused then
  FProcessState:=ProcessRunning
  else FProcessState:=ProcessPaused;
end;
///////////////////////////////////////
procedure TFileRipper.StopSearch();
begin
  FProcessState:=ProcessStopped;
end;
///////////////////////////////////////

end.
