unit ZlibLoader;

interface

uses
  SysUtils,SharedTypes;

type
  TZlibStreamInfo = Packed Record
    Offset:LongWord;
    ComSize:LongWord;
    DecSize:LongWord;
    Msg:String[255];
  end;

//function IsZlibStreamId (const Id:Word):Boolean;
function GetZlibStreamInfo (const InFile:TByteFile;var ZlibStreamInfo:TZlibStreamInfo):Boolean;

implementation

{$L Zlib\inflate.obj}
{$L Zlib\inftrees.obj}
{$L Zlib\inffast.obj}
{$L Zlib\trees.obj}
{$L Zlib\adler32.obj}
{$L Zlib\crc32.obj}

const
  BufferSize = 65535;
  ZLIB_VERSION   = '1.2.3';

type
  TZAlloc = function (opaque: Pointer; items, size: Integer): Pointer;
  TZFree  = procedure (opaque, block: Pointer);

  TZStreamRec = packed record
    next_in  : PChar;     // next input byte
    avail_in : Longint;   // number of bytes available at next_in
    total_in : Longint;   // total nb of input bytes read so far

    next_out : PChar;     // next output byte should be put here
    avail_out: Longint;   // remaining free space at next_out
    total_out: Longint;   // total nb of bytes output so far

    msg      : PChar;     // last error message, NULL if no error
    state    : Pointer;   // not visible by applications

    zalloc   : TZAlloc;   // used to allocate the internal state
    zfree    : TZFree;    // used to free the internal state
    opaque   : Pointer;   // private data object passed to zalloc and zfree

    data_type: Integer;   // best guess about the data type: ascii or binary
    adler    : Longint;   // adler32 value of the uncompressed data
    reserved : Longint;   // reserved for future use
  end;

{** zlib function implementations *******************************************}

function zcalloc(opaque: Pointer; items, size: Integer): Pointer;
begin
  GetMem(result,items * size);
end;

procedure zcfree(opaque, block: Pointer);
begin
  FreeMem(block);
end;

{** c function implementations **********************************************}

procedure _memset(p: Pointer; b: Byte; count: Integer); cdecl;
begin
  FillChar(p^,count,b);
end;

procedure _memcpy(dest, source: Pointer; count: Integer); cdecl;
begin
  Move(source^,dest^,count);
end;

function inflateInit_(var strm: TZStreamRec; version: PChar;recsize: Integer): Integer;external;
function inflate(var strm: TZStreamRec; flush: Integer): Integer;external;
function inflateEnd(var strm: TZStreamRec): Integer;external;

function InflateInit(var stream: TZStreamRec): Integer;
begin
  result := inflateInit_(stream,ZLIB_VERSION,SizeOf(TZStreamRec));
end;
(*
function IsZlibStreamId (const Id:Word):Boolean;

begin
  Result:= (Id=55928) or (Id=40056);
end;
*)
function GetZlibStreamInfo (const InFile:TByteFile;var ZlibStreamInfo:TZlibStreamInfo):Boolean;
var
  InBuffer:Pointer;
  OutBuffer:Pointer;

  zresult: ShortInt;
  outSize  : Integer;
  zstream: TZStreamRec;
begin
  Result:=False;

  FillChar(zstream,SizeOf(TZStreamRec),0);
  //FillChar(ZlibStreamInfo,SizeOf(TZlibStreamInfo),$0);
  zResult:=InflateInit(zstream);
  if zResult <> 0 then
  begin
    ZlibStreamInfo.msg:=String(zstream.msg);
    Exit;
  end;

  GetMem (InBuffer,BufferSize);
  GetMem (OutBuffer,BufferSize);
  //AssignFile(InFile,FileName);
  //Reset(InFile);
  Seek(InFile,ZlibStreamInfo.Offset); //84354
  BlockRead (InFile,InBuffer^,BufferSize,zstream.avail_in);
  outSize:=BufferSize;

  while zstream.avail_in > 0 do
  begin
    zstream.next_in := inBuffer;

    repeat
      zstream.next_out := PChar(Integer(outBuffer) + zstream.total_out);
      zstream.avail_out := bufferSize;

      zresult := inflate(zstream,0);
      if zResult < 0 then
      begin
        ZlibStreamInfo.msg:=zstream.msg;
        FreeMem (InBuffer);
        FreeMem (OutBuffer);
        Exit;
      end;

      Inc(outSize,bufferSize - zstream.avail_out);
      ReallocMem(outBuffer,outSize);
    until (zresult = 1) or (zstream.avail_in = 0);

    if zresult <> 1 then
    begin
      BlockRead (InFile,InBuffer^,BufferSize,zstream.avail_in);
    end
      else
    if zstream.avail_in > 0 then
    begin
      zstream.avail_in := 0;
    end;
  end; // while

  ReallocMem(outBuffer,zstream.total_out);

  zResult:=inflateEnd(zstream);
  if zResult=0 then
  begin
    with ZlibStreamInfo do
    begin
      //Offset:LongWord;
      ComSize:=zstream.total_in;
      DecSize:=zstream.total_out;
      Msg:=String(zstream.msg);
    end;
    Result:=True;
  end;
  FreeMem (InBuffer);
  FreeMem (OutBuffer);
end;


end.






