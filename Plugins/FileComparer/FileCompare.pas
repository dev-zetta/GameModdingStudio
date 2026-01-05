unit FileCompare;

interface

uses
  Windows;

type
  TProgressCallback = procedure (const Value, MaxValue: DWORD);

  PCompareEntry = ^TCompareEntry;
  TCompareEntry = Record
    Offset: DWORD;
    Original: BYTE;
    Changed: BYTE;
  end;

  PCompareTable = ^TCompareTable;
  TCompareTable = Array of  TCompareEntry;

  PCompareInfo = ^TCompareInfo;
  TCompareInfo = Record
    IsMustSizeEqual: Boolean;
    IsSizeEqual: Boolean;
    Callback: TProgressCallback;
    CompareTable: TCompareTable;
    CompareCount: DWORD;
    CompareAvailable: DWORD;
  end;

function CompareFiles(const OriginalFile, ChangedFile: String; const CompareInfo: PCompareInfo): Boolean;
procedure InitCompareInfo(const CompareInfo: PCompareInfo);
procedure FreeCompareInfo(const CompareInfo: PCompareInfo);

implementation


procedure InitCompareInfo(const CompareInfo: PCompareInfo);
begin
  FillChar(CompareInfo^, SizeOf(TCompareInfo), 0);
end;

procedure FreeCompareInfo(const CompareInfo: PCompareInfo);
begin
  if CompareInfo = nil then
  Exit;

  SetLength(CompareInfo^.CompareTable, 0);
  FillChar(CompareInfo^, SizeOf(TCompareInfo), 0);
end;

function CompareFiles(const OriginalFile, ChangedFile: String; const CompareInfo: PCompareInfo): Boolean;
type
  TByteArray = Array[0..0] of BYTE;
  PByteArray = ^TByteArray;
var
  InFile, OutFile: File of BYTE;
  InFileSize, OutFileSize: DWORD;

  InBuffer, OutBuffer: PByteArray;
  InBufferSize, OutBufferSize, MaxBufferSize: DWORD;

  MaxFileSize: DWORD;
  InFilePos: DWORD;
  BufferIndex, BufferSize: DWORD;

  CompareEntry: PCompareEntry;
begin
  try
    Result:= False;

    if CompareInfo = nil then
    Exit;

    AssignFile(InFile, OriginalFile);
    FileMode:= 0;
    Reset(InFile);
    InFileSize:= FileSize(InFile);

    AssignFile(OutFile, ChangedFile);
    FileMode:= 0;
    Reset(OutFile);
    OutFileSize:= FileSize(OutFile);

    if InFileSize <> OutFileSize then
    begin
      CompareInfo^.IsSizeEqual:= False;
      if CompareInfo^.IsMustSizeEqual then
      begin
        CloseFile(OutFile);
        CloseFile(InFile);
        Exit;
      end;
    end;

    if InFileSize > OutFileSize then
    MaxFileSize:= OutFileSize
    else MaxFileSize:= InFileSize;

    MaxBufferSize:= 65536;
    if MaxBufferSize > MaxFileSize then
    MaxBufferSize:= MaxFileSize;

    GetMem(InBuffer, MaxBufferSize);
    GetMem(OutBuffer, MaxBufferSize);

    InFilePos:= 0;
    while InFilePos < MaxFileSize do
    begin
      BlockRead(InFile, InBuffer^, MaxBufferSize, InBufferSize);
      BlockRead(OutFile, OutBuffer^, MaxBufferSize, OutBufferSize);

      if (InBufferSize = 0) or (OutBufferSize = 0) then
      Break;

      if InBufferSize > OutBufferSize then
      BufferSize:=OutBufferSize
      else BufferSize:=InBufferSize;

      for BufferIndex:=0 to BufferSize - 1 do
      begin
        if @CompareInfo^.Callback <> nil then
        CompareInfo^.Callback(InFilePos, MaxFileSize);

        if InBuffer^[BufferIndex] = OutBuffer^[BufferIndex] then
        Continue;

        if CompareInfo^.CompareAvailable = 0 then
        begin
          SetLength(CompareInfo^.CompareTable, CompareInfo^.CompareCount + 1024);
          CompareInfo^.CompareAvailable:= 1024;
        end;

        CompareEntry:= @CompareInfo^.CompareTable[CompareInfo^.CompareCount];

        CompareEntry^.Offset:= InFilePos + BufferIndex;
        CompareEntry^.Original:= InBuffer^[BufferIndex];
        CompareEntry^.Changed:= OutBuffer^[BufferIndex];

        Inc(CompareInfo^.CompareCount);
        Dec(CompareInfo^.CompareAvailable);
      end;

      if InBufferSize <> OutBufferSize then
      Break;

      Inc(InFilePos, BufferSize);
    end;
    FreeMem(OutBuffer);
    FreeMem(InBuffer);
    CloseFile(OutFile);
    CloseFile(InFile);
    Result:= True;
  except

  end;
end;


end.
