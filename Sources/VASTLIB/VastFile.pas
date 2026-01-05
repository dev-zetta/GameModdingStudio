unit VastFile;

interface

uses
  Windows, VastMemory, VastUtils;
(*
const
  FILE_SHARE_NONE       = $00000000;
  FILE_SHARE_READ       = $00000001;
  FILE_SHARE_WRITE      = $00000002;
  FILE_SHARE_READWRITE  = $00000003;
  FILE_SHARE_DELETE     = $00000004;
*)
type
  //TVastFileState = (FILE_OPENED, FILE_CLOSED, FILE_
  TVastFile = Packed Record
    Handle:DWORD;
    Size:DWORD;
    Pos:DWORD;
    ShareMode:DWORD;
    AccessMode:DWORD;
    //mOverlapped:POverlapped;
  end;
function VastFileCreate (var InFile:TVastFile;const InName:PChar):BOOLEAN;
function VastFileOpen (var InFile:TVastFile;const InName:PChar):BOOLEAN;
function VastFileSeek (var InFile:TVastFile;const Pos:DWORD):DWORD;
function VastFileSeekInc (var InFile:TVastFile;const Inc:INTEGER):DWORD;
function VastFileSeekEnd (var InFile:TVastFile;const Inc:INTEGER):DWORD;

function VastFileRead (var InFile:TVastFile;var Data;const Size:DWORD):DWORD;
function VastFileReadCached (var InFile:TVastFile;var Data;const Size:DWORD):DWORD;
function VastFileWrite (var InFile:TVastFile;var Data;const Size:DWORD):DWORD;
function VastFileWriteCached (var InFile:TVastFile;var Data;const Size:DWORD):DWORD;
function VastFileClose (var InFile:TVastFile):BOOLEAN;

//function ffDeleteSafe (const FileName:PChar):BOOLEAN;

implementation

const
  CACHE_SIZE = 2048 * 1024; // 2 MB

function VastFileCreate (var InFile:TVastFile;const InName:PChar):BOOLEAN;
var
  Handle:DWORD;
  Size:DWORD;
  SizeHigh:DWORD;
begin
  Result:=False;
  Handle:=CreateFile(PChar(InName), GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if Handle = INVALID_HANDLE_VALUE then
  Exit;

  Size:=GetFileSize(Handle, @SizeHigh);
  if Size = INVALID_FILE_SIZE then
  begin
    CloseHandle(Handle);
    Exit;
  end;

  InFile.Handle:=Handle;
  InFile.Size:=Size;
  InFile.Pos:=0;
  InFile.ShareMode:=0;
  InFile.AccessMode:=0;
  Result:=True;
end;

function VastFileOpen (var InFile:TVastFile;const InName:PChar):BOOLEAN;
var
  Handle:DWORD;
  Size:DWORD;
  SizeHigh:DWORD;
  //mOverlapped:POverlapped;
begin
  Result:=False;
  //if not hAllocMem(mOverlapped, SizeOf(_Overlapped)) then
  //Exit;

  Handle:=CreateFile(PChar(InName), GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  //Handle:=CreateFile('\\\\.\\c:', 0, 0, nil, 0, 0, 0);
  //FILE_FLAG_OVERLAPPED or FILE_FLAG_NO_BUFFERING
  if Handle = INVALID_HANDLE_VALUE then
  begin
    //hFreeMem(mOverlapped);
    Exit;
  end;

  Size:=GetFileSize(Handle, @SizeHigh);
  if Size = INVALID_FILE_SIZE then
  begin
    //hFreeMem(mOverlapped);
    CloseHandle(Handle);
    Exit;
  end;

  if Size = 0 then
  begin
    //hFreeMem(mOverlapped);
    CloseHandle(Handle);
    Exit;
  end;

  InFile.Handle:=Handle;
  InFile.Size:=Size;
  InFile.Pos:=0;
  InFile.ShareMode:=0;
  InFile.AccessMode:=0;
  //InFile.mOverlapped:=mOverlapped;
  Result:=True;
end;

function VastFileSeek (var InFile:TVastFile;const Pos:DWORD):DWORD;
begin
  InFile.Pos:=SetFilePointer(InFile.Handle, Pos, nil, FILE_BEGIN);

  Result:=InFile.Pos;
end;

function VastFileSeekInc (var InFile:TVastFile;const Inc:INTEGER):DWORD;
begin
  InFile.Pos:=SetFilePointer(InFile.Handle, Inc, nil, FILE_CURRENT);

  Result:=InFile.Pos;
end;

function VastFileSeekEnd (var InFile:TVastFile;const Inc:INTEGER):DWORD;
begin
  InFile.Pos:=SetFilePointer(InFile.Handle, Inc, nil, FILE_END);

  Result:=InFile.Pos;
end;

function VastFileRead (var InFile:TVastFile;var Data;const Size:DWORD):DWORD;
var
  OutSize:DWORD;
begin

  OutSize:=0;
  if ReadFile(InFile.Handle, Data, Size, OutSize, nil) then
  begin
    Inc(InFile.Pos, OutSize);
    Result:=OutSize;
    Exit;
  end;
  Result:=0;
end;

function VastFileWrite (var InFile:TVastFile;var Data;const Size:DWORD):DWORD;
var
  OutSize:DWORD;
begin
  OutSize:=0;
  if WriteFile(InFile.Handle, Data, Size, OutSize, nil) then
  begin
    Inc(InFile.Pos, OutSize);
    Result:=OutSize;
    Exit;
  end;
  Result:=0;
end;

function VastFileReadCached (var InFile:TVastFile;var Data;const Size:DWORD):DWORD;
var
  InMem:DWORD;
  InSize:DWORD;
  OutSize:DWORD;
  ChunkIndex:DWORD;
  ChunkCount:DWORD;
begin
  Result:=0;
  if Size = 0 then
  Exit;

  ChunkCount:=Size shr $15;
  if (Size and $000007FF) > 0 then
  inc (ChunkCount);

  if ChunkCount <= 1 then
  begin
    if not ReadFile(InFile.Handle, Data, Size, OutSize, nil) then
    Exit;
    Inc(InFile.Pos, OutSize);
    Result:=OutSize;
    Exit;
  end;

  InMem:=DWORD(@Data);
  InSize:=Size;
  for ChunkIndex:=0 to ChunkCount - 1 do
  begin
    OutSize:=0;
    if (InSize-CACHE_SIZE) > CACHE_SIZE then
    begin
      if not ReadFile(InFile.Handle, POINTER(InMem)^, CACHE_SIZE, OutSize, nil) then
      Break;
      Inc(InMem, OutSize);
      Dec(InSize, OutSize);
    end
      else
    begin
      if not ReadFile(InFile.Handle, POINTER(InMem)^, InSize, OutSize, nil) then
      Break;

      Dec(InSize, OutSize);
      Break;
    end;
  end; // for ChunkIndex
  Inc(InFile.Pos, Size-InSize);
  Result:=Size-InSize;
end;

function VastFileWriteCached (var InFile:TVastFile;var Data;const Size:DWORD):DWORD;
var
  InMem:DWORD;
  InSize:DWORD;
  OutSize:DWORD;
  ChunkIndex:DWORD;
  ChunkCount:DWORD;
begin
  Result:=0;
  if Size = 0 then
  Exit;

  ChunkCount:=Size shr $15;
  if (Size and $000007FF) > 0 then
  inc (ChunkCount);

  if ChunkCount <= 1 then
  begin
    if not WriteFile(InFile.Handle, Data, Size, OutSize, nil) then
    Exit;
    Inc(InFile.Pos, OutSize);
    Result:=OutSize;
    Exit;
  end;

  InMem:=DWORD(@Data);
  InSize:=Size;
  for ChunkIndex:=0 to ChunkCount - 1 do
  begin
    OutSize:=0;
    if (InSize-CACHE_SIZE) > CACHE_SIZE then
    begin
      if not WriteFile(InFile.Handle, POINTER(InMem)^, CACHE_SIZE, OutSize, nil) then
      Break;
      Inc(InMem, OutSize);
      Dec(InSize, OutSize);
    end
      else
    begin
      if not WriteFile(InFile.Handle, POINTER(InMem)^, InSize, OutSize, nil) then
      Break;

      Dec(InSize, OutSize);
      Break;
    end;
  end; // for ChunkIndex
  Inc(InFile.Pos, Size-InSize);
  Result:=Size-InSize;
end;

function VastFileClose (var InFile:TVastFile):BOOLEAN;
begin
  Result:=False;
  if InFile.Handle = 0 then
  Exit;

  if CloseHandle(InFile.Handle) = False then
  Exit;
  InFile.Handle:=0;
  InFile.Size:=0;
  InFile.Pos:=0;
  Result:=True;
end;
(*
function ffDeleteSafe (const FileName:PChar):BOOLEAN;
var
  Handle:DWORD;
  Size:DWORD;
  SizeHigh:DWORD;

  //InMem:DWORD;
  InSize:DWORD;
  OutSize:DWORD;
  ChunkIndex:DWORD;
  ChunkCount:DWORD;
  Buffer:PDWORD;
begin
  Result:=False;
  Handle:=CreateFile(PChar(FileName), GENERIC_WRITE, FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_FLAG_DELETE_ON_CLOSE, 0);

  if Handle = INVALID_HANDLE_VALUE then
  Exit;

  Size:=GetFileSize(Handle, @SizeHigh);
  if Size = INVALID_FILE_SIZE then
  begin
    CloseHandle(Handle);
    Exit;
  end;

  if Size = 0 then
  begin
    //hFreeMem(mOverlapped);
    CloseHandle(Handle);
    Exit;
  end;

  ChunkCount:=Size shr $15;
  if (Size and $000007FF) > 0 then
  inc (ChunkCount);

  if not VastHeapAlloc(POINTER(Buffer), CACHE_SIZE) then
  Exit;

  // Input size is <= buffer size
  if ChunkCount <= 1 then
  begin
    // Write zeros to file
    WriteFile(Handle, Buffer^, Size, OutSize, nil);

    // Prepare to pass 2
    SetFilePointer(Handle, 0, nil, FILE_BEGIN);
    FillDWORD(Buffer^, CACHE_SIZE, $FFFFFFFF);

    // Write 1 to file
    WriteFile(Handle, Buffer^, Size, OutSize, nil);

    // Prepare to pass 3
    SetFilePointer(Handle, 0, nil, FILE_BEGIN);
    FillDWORD(Buffer^, CACHE_SIZE, $AA995533);

    // Write random values to file
    WriteFile(Handle, Buffer^, Size, OutSize, nil);

    VastHeapFree(POINTER(Buffer));

    if CloseHandle(Handle) then
    Result:=True;
    Exit;
  end;

  // Input size is > buffer size so we need to loop
  // Pass 1
  InSize:=Size;
  for ChunkIndex:=0 to ChunkCount - 1 do
  begin
    OutSize:=0;
    if (InSize - CACHE_SIZE) > CACHE_SIZE then
    begin
      if not WriteFile(Handle, POINTER(Buffer)^, CACHE_SIZE, OutSize, nil) then
      Break;
      Dec(InSize, OutSize);
    end
      else
    begin
      if not WriteFile(Handle, POINTER(Buffer)^, InSize, OutSize, nil) then
      Break;

      Dec(InSize, OutSize);
      Break;
    end;
  end; // for ChunkIndex

  // Prepare to pass 2
  SetFilePointer(Handle, 0, nil, FILE_BEGIN);
  FillDWORD(Buffer^, CACHE_SIZE, $FFFFFFFF);

  InSize:=Size;
  for ChunkIndex:=0 to ChunkCount - 1 do
  begin
    OutSize:=0;
    if (InSize - CACHE_SIZE) > CACHE_SIZE then
    begin
      if not WriteFile(Handle, POINTER(Buffer)^, CACHE_SIZE, OutSize, nil) then
      Break;
      Dec(InSize, OutSize);
    end
      else
    begin
      if not WriteFile(Handle, POINTER(Buffer)^, InSize, OutSize, nil) then
      Break;

      Dec(InSize, OutSize);
      Break;
    end;
  end; // for ChunkIndex

  // Prepare to pass 3
  SetFilePointer(Handle, 0, nil, FILE_BEGIN);
  FillDWORD(Buffer^, CACHE_SIZE, $AA995533);

  InSize:=Size;
  for ChunkIndex:=0 to ChunkCount - 1 do
  begin
    OutSize:=0;
    if (InSize - CACHE_SIZE) > CACHE_SIZE then
    begin
      if not WriteFile(Handle, POINTER(Buffer)^, CACHE_SIZE, OutSize, nil) then
      Break;
      Dec(InSize, OutSize);
    end
      else
    begin
      if not WriteFile(Handle, POINTER(Buffer)^, InSize, OutSize, nil) then
      Break;

      Dec(InSize, OutSize);
      Break;
    end;
  end; // for ChunkIndex

  // Free allocated buffer
  VastHeapFree(POINTER(Buffer));

  if CloseHandle(Handle) then
  Result:=True;
end;
*)



end.

