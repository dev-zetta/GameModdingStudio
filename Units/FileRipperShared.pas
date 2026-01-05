unit FileRipperShared;

interface

uses
  Windows,
  FileRipperSections;

const
  DefArrayInc   = 128; // Default Increament for arrays
  DefExtLen     = 16; // Default length of file extension
  BufferCache   = 16;
  MaxBufferSize = (2048 * 1024) + BufferCache;  // 2 MB Buffer
  NameFormat    = '%.10d';
  MaxFormatTypeSet = 128;


type
  DWORD = Cardinal;

  PBuffer = ^TBuffer;
  PFormatType = ^TFormatType;
  PFormatTypeSet = ^TFormatTypeSet;
  PFormatScanner = ^TFormatScanner;
  PFormatEntry = ^TFormatEntry;
  PFormatEntryArray = ^TFormatEntryArray;
  PFileData = ^TFileData;
  PFileDataArray = ^TFileDataArray;

  TBuffer = Array[0..MaxBufferSize-1] of Char;

  TFormatScanner = function (const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;

  TFormatType = Record
    Enabled: BOOLEAN;
    Index: DWORD;
    Offset: INTEGER;
    Marker: DWORD;
    Scanner: TFormatScanner;
    MinSize: DWORD;
    Section:  TFormatSection;
    Extension:  String[4];
    Description:  String[255];
    //HasOpenPlugin: Boolean;
    //Plugin
  end;


  TFormatEntry = Record
    Format: PFormatType;
    Name: STRING[32];
    Offset: DWORD;
    Size: DWORD;
  end;

  TFormatEntryArray = Array of TFormatEntry;

  TFormatTypeSet = Array[0..MaxFormatTypeSet - 1] of PFormatType; // Max 128 formats supported

  TProcessState = (ProcessStarted, ProcessPaused, ProcessStopped, ProcessRunning);

  //TFileOpenFunction = function (var Handle: DWORD; const FileName: String): BOOLEAN;
  //TFileSeekFunction = function (const Handle: DWORD; const Offset: DWORD): DWORD;
  //TFileReadFunction = function (const Handle: DWORD; var Data; const Size: DWORD): DWORD;
  //TFileWriteFunction = function (const Handle: DWORD; var Data; const Size: DWORD): DWORD;
  //TFileCloseFunction = function (const Handle: DWORD): BOOLEAN;

  TFileData = Record
    IsProcessing: BOOLEAN;
    
    FileName: String;
    FilePath: String;
    FullName: String;

    //Buffer: Pointer;
    //BufferPos: DWORD;
    //BufferSize: DWORD;
    ScanFormats: TFormatTypeSet;
    ScanFormatsCount: DWORD;

    FileHandle: DWORD;
    FilePos: DWORD;
    FileSize: DWORD;

    IsFileOpened: Boolean;
    //FileOpen: TFileOpenFunction;
    //FileSeek: TFileSeekFunction;
    //FileRead: TFileReadFunction;
    //FileWrite: TFileWriteFunction;
    //FileClose: TFileCloseFunction;

    IsFileEnd: Boolean;

    State: TProcessState;
    // Entry
    EntryData: TFormatEntryArray;
    EntryDataCount: DWORD;
    EntryDataAvailable: DWORD;
    EntryDataTotalSize: DWORD;
  end;

  TFileDataArray = Array of PFileData;

  TProgressCallback = procedure (const ThreadIndex, FileIndex, Progress, MaxValue:DWORD);

function GetProcessorCount: DWORD;

function FileOpen(const FileData:PFileData):Boolean;
//function FileReOpen(const FileData:PFileData):Boolean;
function FileClose(const FileData:PFileData):Boolean;
function FileSeek(const FileData:PFileData; const Offset:DWORD):DWORD;
function FileRead(const FileData:PFileData; var Buffer; const Size:DWORD):DWORD;
function FileWrite(const FileData:PFileData; const Buffer; const Size:DWORD):DWORD;

implementation

///////////////////////////////////////
function GetProcessorCount: DWORD;
var
  ProcessorCount: DWORD;
  ProcessMask: DWORD;
  SystemMask: DWORD;
  BitIndex: DWORD;
begin
  Result:=1;
  if GetProcessAffinityMask(GetCurrentProcess(), ProcessMask, SystemMask) = False then
  Exit;

  ProcessorCount:=0;
  for BitIndex := 0 to 32 - 1 do
  begin
    if (ProcessMask and (1 shl BitIndex)) <> 0 then
    Inc(ProcessorCount)
  end;
  Result:=ProcessorCount;
end;
///////////////////////////////////////

///////////////////////////////////////
function FileOpen(const FileData:PFileData):Boolean;
var
  FileAttrib:Integer;
  //InFileRec:TFileRec;
  Handle: DWORD;
  Size: DWORD;
  SizeHigh:DWORD;
begin
  Result:=False;

  if (not FileData^.IsFileOpened) then
  begin
    try
      // Change file attributes
      FileAttrib:=GetFileAttributes(PChar(FileData^.FullName));
      if (FileAttrib and FILE_ATTRIBUTE_READONLY) > 0 then
      SetFileAttributes(PChar(FileData^.FullName), FileAttrib and (not FILE_ATTRIBUTE_READONLY));

      Handle:=CreateFile(PChar(FileData^.FullName), GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
      if Handle = INVALID_HANDLE_VALUE then
      begin
        Exit;
      end;

      Size:=GetFileSize(Handle, @SizeHigh);
      if (Size = INVALID_FILE_SIZE) or (Size = 0) then
      begin
        CloseHandle(Handle);
        Exit;
      end;

      //if SizeHigh <> 0  then
      //64bit mode !!

      FileData^.FileHandle:=Handle;
      FileData^.FileSize:=Size;
      FileData^.IsFileOpened:=True;
      FileData^.IsFileEnd:=False;
      Result:=True;
    except

    end;
  end;
end;
(*
function FileReOpen(const FileData:PFileData):Boolean;
var

  Handle: DWORD;
  Size: DWORD;
  SizeHigh:DWORD;
begin
  Result:=False;

  if (not FileData^.IsFileOpened) then
  begin
    try
      // Change file attributes
      Handle:=CreateFile(PChar(FileData^.FullName), GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
      if Handle = INVALID_HANDLE_VALUE then
      begin
        Exit;
      end;

      Size:=GetFileSize(Handle, @SizeHigh);
      if (Size = INVALID_FILE_SIZE) or (Size = 0) then
      begin
        CloseHandle(Handle);
        Exit;
      end;

      //if SizeHigh <> 0  then
      //64bit mode !!

      FileData^.FileHandle:=Handle;
      FileData^.FileSize:=Size;
      FileData^.IsFileOpened:=True;
      FileData^.IsFileEnd:=False;
      Result:=True;
    except

    end;
  end;
end;
*)
///////////////////////////////////////
function FileClose(const FileData:PFileData):Boolean;
begin
  Result:=False;

  if FileData^.IsFileOpened then
  begin
    if CloseHandle(FileData^.FileHandle) = False then
    Exit;

    FileData^.IsFileOpened:=False;
    Result:=True;
  end;
end;
///////////////////////////////////////
function FileSeek(const FileData:PFileData; const Offset:DWORD):DWORD;
begin
  Result:=FileData^.FilePos;
  if FileData^.IsFileOpened then
  begin
    if (Offset >= FileData^.FileSize) then//-FBufferCache)) of
    begin
      FileData^.IsFileEnd:=True;
      //Result:=SetFilePointer(FileData^.FileHandle, Offset, nil, FILE_BEGIN);
    end
      else
    begin
      FileData^.FilePos:=Offset;
      Result:=SetFilePointer(FileData^.FileHandle, Offset, nil, FILE_BEGIN);
    end;
  end;
end;
///////////////////////////////////////
function FileRead(const FileData:PFileData; var Buffer; const Size:DWORD):DWORD;
var
  ReadCount:DWORD;
begin
  Result:=0;

  if FileData^.IsFileOpened then
  begin
    if (FileData^.FilePos >= FileData^.FileSize) then//-FBufferCache)) of
    begin
      FileData^.IsFileEnd:=True;
    end
      else
    begin
      //BlockRead (FFile, Buffer, Size, ReadCount);
      if ReadFile(FileData^.FileHandle, Buffer, Size, ReadCount, nil) then
      begin
        Inc(FileData^.FilePos, ReadCount);
        Result:=ReadCount;
      end;
    end; //case
  end;
end;
///////////////////////////////////////
function FileWrite(const FileData:PFileData; const Buffer; const Size:DWORD):DWORD;
var
  ReadCount: DWORD;
begin
  Result:=0;

  if FileData^.IsFileOpened then
  begin
    if (FileData^.FilePos >= FileData^.FileSize) then//-FBufferCache)) of
    begin
      FileData^.IsFileEnd:=True;
    end
      else
    begin
      if WriteFile(FileData^.FileHandle, Buffer, Size, ReadCount, nil) then
      begin
        Inc(FileData^.FilePos, ReadCount);
        Result:=ReadCount;
      end;
    end; // case
  end;

end;
///////////////////////////////////////

end.
