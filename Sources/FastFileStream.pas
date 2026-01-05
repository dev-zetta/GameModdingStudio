{-----------------------------------------------------------------------------
 Unit Name: FastFileStream
 Author:    tony  (tonyki@citiz.net)
 Purpose:   an filestream which open the file use MapViewOfFile(), more faster then original one.
 History:   2004.12.09    create
-----------------------------------------------------------------------------}

unit FastFileStream;

interface

uses
  Classes, SysUtils, Windows;

type
  TFastFileStream = class(TStream)
  private
    FFileHandle:LongWord;
    FMappingHandle:LongWord;
    FMemory:Pointer;
    FPosition:LongInt;
    FSize:Int64;
    FUseableStartPos:Int64;
  protected
    function GetSize():Int64;override;
  public
    constructor Create(const AFileName:String);
    destructor Destroy();override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
    procedure SetUseableMemory(const StartPos:Int64;const Size:Int64);
    property Memory:Pointer read FMemory;
  end;

implementation

type
  FastFileStreamException = Exception;

{ TFastFileStream }

function TFastFileStream.GetSize():Int64;
begin
  result:=FSize;
end;

constructor TFastFileStream.Create(const AFileName:String);
var
  FileSizeHigh:LongWord;
begin
  FFileHandle:=CreateFile(PChar(AFileName),GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  if FFileHandle=INVALID_HANDLE_VALUE then begin
    raise FastFileStreamException.Create('Error when open file');
  end;
  FSize:=GetFileSize(FFileHandle,@FileSizeHigh);
  if FSize=INVALID_FILE_SIZE then begin
    raise FastFileStreamException.Create('Error when get file size');
  end;
  FMappingHandle:=CreateFileMapping(FFileHandle,nil,PAGE_READONLY,0,0,nil);
  if FMappingHandle=0 then begin
    raise FastFileStreamException.Create('Error when mapping file');
  end;
  FMemory:=MapViewOfFile(FMappingHandle,FILE_MAP_READ,0,0,0);
  if FMemory=nil then begin
    raise FastFileStreamException.Create('Error when map view of file');
  end;

  FUseableStartPos:=0;
end;

destructor TFastFileStream.Destroy();
begin
  if FMemory<>nil then begin
    UnmapViewOfFile(FMemory);
  end;
  if FMappingHandle<>0 then begin
    CloseHandle(FMappingHandle);
  end;
  if FFileHandle<>INVALID_HANDLE_VALUE then begin
    CloseHandle(FFileHandle);
  end;
end;

function TFastFileStream.Read(var Buffer;Count:LongInt):LongInt;
begin
  if (FPosition >= 0) and (Count >= 0) then
  begin
    Result := FSize - FPosition;
    if Result > 0 then
    begin
      if Result > Count then Result := Count;
      //Move(Pointer(Longint(FMemory) + FPosition)^, Buffer, Result);
      CopyMemory(Pointer(@Buffer),Pointer(LongInt(FMemory)+FUseableStartPos+FPosition),Result);
      Inc(FPosition, Result);
      Exit;
    end;
  end;
  Result := 0;
end;

function TFastFileStream.Write(const Buffer; Count: Longint): Longint;
begin
  raise FastFileStreamException.Create('Not support this method');
end;

function TFastFileStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  case Ord(Origin) of
    soFromBeginning: FPosition := Offset;
    soFromCurrent: Inc(FPosition, Offset);
    soFromEnd: FPosition := FSize + Offset;
  end;
  Result := FPosition;
end;

procedure TFastFileStream.SetUseableMemory(const StartPos:Int64;const Size:Int64);
begin
  FUseableStartPos:=StartPos;
  FSize:=Size;
end;

end.
