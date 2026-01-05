unit OGG_Unit;


interface

uses Windows,Classes,SysUtils,FastFileStream,BlankFiles,FileTypes;

function OggSearch (Filename:ShortString):Word;
function OggExtract (FileName,Folder:ShortString):boolean;
function OggDupe (FileName:ShortString):boolean;
procedure OggClean;

implementation

//
// BIK Functions starts here
//

type
  OGGHeader = packed record
    ID: array[0..3] of char;
    Revision: byte;
    BitFlags: byte;
    AbsoluteGranulePos: int64;
    StreamSerialNumber: integer;
    PageSeqNum: integer;
    PageChecksum: integer;
    NumPageSegments: byte;
end;
//
// OGG Functions starts here
//

const
  BufferSize = 2048;


function OggSearch (Filename:ShortString):Word;
var
  OGGH: OGGHeader;
  OGGFile: TFastFileStream;
  OGGPageLen: Longword;
  i,x,j,cOffset:LongWord;

  BytesReaded:Word;
  tbyte:Byte;
  Buf:array[0..2047] of Char; // Buffer 2MB
  mustBeStart:boolean;
  CurrentItem:Word;
  Found:boolean;
begin
  OGGFile:=TFastFileStream.Create(FileName);
  pOGGFiles:=@OGGFiles;
  i:=0;
  Found:=False;
while i<OGGFile.Size-2048 do
begin
  If not Found then
  OGGFile.Seek(i,soFromBeginning);

  OGGFile.ReadBuffer(Buf,2048);
  inc (i,2048);

  for j:=0 to Length(Buf)-1 do
  begin
    if (Buf[j]='O') and (Buf[j+1]='g') and (Buf[j+2]='g') and (Buf[j+3]='S') then
    begin
      dec (i,2048-j);
      Found:=True;
      Break;
    end;
  end;

    if Found=True then
    begin
        SetLength (OGGFiles,Length (OGGFiles)+1);
        CurrentItem:=Length (OggFiles)-1;
        OGGFile.Seek(i,soFromBeginning); // seek of beginning of OggS
        OGGFiles[CurrentItem].Offset:=i; // save offset

        mustBeStart:=true;
        repeat
            OGGFile.ReadBuffer(OggH,SizeOf(OggH));
            if (mustBeStart and ((OggH.BitFlags and 2) = 2)) or (not(MustBeStart) and ((OggH.BitFlags and 2) = 0)) then
            begin
              OGGPageLen := 0;

              for x := 1 to OggH.NumPageSegments do
              begin
                OGGFile.ReadBuffer(tbyte,1);
                inc(OGGPageLen,tbyte);
              end;

              inc(OGGFiles[CurrentItem].FileSize,OGGPageLen+sizeof(OggH)+OggH.NumPageSegments);

              if ((OggH.BitFlags and 4) = 4) then
              begin
                OGGFiles[CurrentItem].FileName:=Format('OGGFile%.5d.ogg', [CurrentItem]);
                inc (i,OGGFiles[CurrentItem].FileSize);
                Found:=False;
                break;
              end;

              cOffset := OGGPageLen;
              OGGFile.Seek(cOffset,soFromCurrent);
              mustBeStart := false;
              end // Ogg Flags
                else
                    break;
        until (false); // repeat
    end; // if buf
  end; // for i
  Buf:='';
OGGFile.Destroy;
Result:=Length(OggFiles)-1;
end;

function OggExtract (FileName,Folder:ShortString):boolean;
var
i:LongWord;
OggFile:TFastFileStream;
OutFile:File of Byte;
Buf:Array of Byte;
begin
Result:=false;
if Length (OGGFiles)>0 then
begin
  OggFile:=TFastFileStream.Create(Filename);

  for i:=0 to Length (OGGFiles)-1 do
  begin
    OggFile.Seek(OggFiles[i].Offset,soFromBeginning);
    SetLength (Buf,OggFiles[i].FileSize);
    OggFile.Read(Buf[0],OggFiles[i].FileSize);

    AssignFile (OutFile,Folder + OggFiles[i].FileName);
    Rewrite (OutFile);
    BlockWrite (OutFile,Buf[0],Length(Buf)-1);
    CloseFile (OutFile);
  end;
  OGGFile.Destroy;
  Buf:=nil;
  Result:=true;
  end;
end;

function OggDupe (FileName:ShortString):boolean;
var
i,j:LongWord;
InputFile:File of Byte;
Buf:Array of Byte;
begin
Result:=false;
if Length (OGGFiles)>0 then
  begin
  AssignFile (InputFile,FileName);
  Reset (InputFile);
  for i:=0 to Length (OGGFiles)-1 do
  begin
    Seek(InputFile,OggFiles[i].Offset);
    SetLength (Buf,OggFiles[i].FileSize);
    FillChar (Pointer(Buf)^,OggFiles[i].FileSize,$00);

    BlockWrite (InputFile,Buf[0],Length(Buf));
    Seek (InputFile,OggFiles[i].Offset);
    BlockWrite (InputFile,BlankOgg[0],Length(BlankOgg));
  end;
  Buf:=nil;
  CloseFile (InputFile);
  end;
  Result:=true;
end;

procedure OggClean;
begin
OGGFiles:=nil;
end;

//
// OGG Functions ends here
//

end.
