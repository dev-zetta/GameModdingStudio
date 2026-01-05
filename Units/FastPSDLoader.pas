unit FastPSDLoader;

interface

uses
  SharedFunc;
implementation

type
  TPSDHeader = Packed Record
    ID:LongWord;
    Version:Word;
    Reserved:Array[0..5] of Byte;
    ChannelCount:Word;
    Height:LongWord;
    Width:LongWord;
    Depth:Word;
    ColorMode:Word;
  end;
  pPSDHeader =^TPSDHeader;

  TPSDImage = Packed Record
    Data:Pointer;
    Size:LongWord;
    Width:LongWord;
    Height:LongWord;
    PixelSize:LongWord;
  end;

  TPSDImageArray = Array of TPSDImage;

const
  //PSD
  ff8BPSID = LongWord(Byte('8') or (Byte('B') shl 8) or (Byte('P') shl 16) or (Byte('S') shl 24));
  ff8BIMID = LongWord(Byte('8') or (Byte('B') shl 8) or (Byte('I') shl 16) or (Byte('M') shl 24));

function DecodeRLE (const InData:Pointer;InSize:LongWord;var OutData:Pointer;var OutSize:LongWord):Boolean;
var
  InDataMem,OutDataMem:LongWord;
  InDataPos:LongWord;
  InByte,InByteCount:SmallInt;
begin
  // Maximum size of output buffer
  OutSize:=InSize * 255;
  GetMem(OutData,OutSize);
  InDataMem:=LongWord(InData);
  OutDataMem:=LongWord(OutData);
  InDataPos:=InDataMem+InSize;
  while InDataMem < InDataPos do
  begin
    InByteCount:=pSmallInt(InDataMem)^;

    if (InByteCount >= -127) and (InByte <= +127) then
    begin
      case InByteCount > 0 of
        True:
        begin
          Move(Pointer(InDataMem+1)^,Pointer(OutDataMem)^,InByteCount+1);
          inc(InDataMem,InByteCount);
          inc(OutDataMem,InByteCount+1);
        end;
        False:
        begin
          FillChar(Pointer(OutDataMem)^,+InByteCount+1,pSmallInt(InDataMem+1)^);
          inc(OutDataMem,+InByteCount+1);
        end;
      end; // case
    end; // if
    inc(InDataMem,2);
  end; // while

end;

function LoadPSD (const InData:Pointer;InSize:LongWord;var OutData:TPSDImageArray;var OutSize:LongWord):Boolean;
var
  Header:pPSDHeader;
  HeaderSize:LongWord;
  InDataMem,OutDataMem:LongWord;
  InDataPos:LongWord;
  InByte,InByteCount:SmallInt;
begin
  Result:=False;
  HeaderSize:=SizeOf(TPSDHeader);
  if (InData=nil) or (InSize<=HeaderSize) then
  Exit;

  InDataMem:=LongWord(InData);
  OutDataMem:=LongWord(OutData);
  InDataPos:=InDataMem+InSize;

  Header:=pPSDHeader(InDataMem);
  if Header^.ID <> ff8BPSID then
  Exit;
  // Skip header size
  inc(InDataMem,HeaderSize);
  // Skip "Color Mode Data Block" (palette)
  inc(InDataMem,SwapLong(pLongWord(InDataMem)^));
  // Skip Image Resources Block
  inc(InDataMem,SwapLong(pLongWord(InDataMem)^));

  case SwapShort(pWord(InDataMem)^)=1 of
    True:;
    False:;
  end;

end;

end.
