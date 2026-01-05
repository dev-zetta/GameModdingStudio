unit VastBMPImage;

interface

uses
  VastImage, VastImagePixelFormat, VastImageTypes, VastFile, VastMemory, VastUtils;

function LoadBMPImage(const FileName:PChar;var Image:PVastImage):Boolean;
function SaveBMPImage(const FileName:PChar;var Image:PVastImage):Boolean;

implementation

const
  BMPMarker = WORD(Byte('B') or (Byte('M') shl 8));

type
  TBMPHeader = Packed Record
    Marker: WORD;  { Must be 'BM' }
    FileSize: DWORD;     { Size of this file }
    Reserved: DWORD;        { ??? }
    HeaderSize: DWORD;      { Size of header }
    InfoSize: DWORD;        { Size of info that follows header }
    Width:INTEGER;
    Height: INTEGER;   { Width and Height of image }
    PlaneCount: WORD;
    PixelSize: WORD;  { Bits can be 1, 4, 8, or 24 }
    CompressionType: DWORD;
    ImageDataSize: DWORD;
    XPixelPerMeter: DWORD;
    YPixelPerMeter: DWORD;
    ColorCount: DWORD;
    ImportantColorCount: DWORD;
  end;
  
var
  bIsError:BOOLEAN;
  mErrorMessage:PCHAR;

procedure ResetErrorState;
begin
  bIsError:=False;
  //EraseMem(mErrorMessage,256);
  mErrorMessage:=nil;
end;

procedure SetErrorState(const Msg:PCHAR);
begin
  bIsError:=True;
  mErrorMessage:=MSG;
end;

function LoadBMPImage(const FileName:PChar;var Image:PVastImage):Boolean;
var
  //FFile:File of Byte;
  FFile:TVastFile;
  Header:TBMPHeader;
  AlphaSize:DWORD;
  ScanLineIndex:DWORD;
  ScanLineSize:DWORD;
  ScanLineMem:DWORD;
begin
  Result:=False;
  //if not IsFileExists(FileName) then
  //Exit;

  //AssignFile(FFile,FileName);
  //Reset(FFile);
  //BlockRead(FFile,Header,SizeOf(TBMPHeader));
  if not ffOpen(FFile,FileName) then
  begin
    SetErrorState('BMP LOADER: Cannot open input file !');
    Exit;
  end;

  ffRead(FFile,Header,SizeOf(TBMPHeader));

  if Header.Marker <> BMPMarker then
  begin
    SetErrorState('BMP LOADER: Wrong BMP identifier !');
    Exit;
  end;

  //if Header.dwImageDataSize = 0 then
  //Exit;

  if Header.CompressionType <> 0 then
  begin
    SetErrorState('BMP LOADER: Unsupported BMP type (compressed) !');
    Exit;
  end;

  if not InitImage(Image) then
  begin
    SetErrorState('BMP LOADER: Cannot init output image !');
    Exit;
  end;

  // We wont use dwImageDataSize variable,sometimes is badly counted or its zero
  //if not mAllocMem(Image^.Data,Header.dwImageDataSize) then
  //Exit;

  case Header.PixelSize of
    1:  SetPixelFormatInfo(Image,PIXEL_FORMAT_INDEX1);
    8:  SetPixelFormatInfo(Image,PIXEL_FORMAT_INDEX8);
    16: SetPixelFormatInfo(Image,PIXEL_FORMAT_X1R5G5B5);
    24: SetPixelFormatInfo(Image,PIXEL_FORMAT_R8G8B8);
    32: SetPixelFormatInfo(Image,PIXEL_FORMAT_R8G8B8X8);
    else
    begin
      SetErrorState('BMP LOADER: Unsupported pixel size !');
      Exit;
    end;
  end;

  if Header.Width > 0 then
  Image^.Width:=Header.Width else Image^.Width:= -Header.Width;

  if Header.Height > 0 then
  Image^.Height:=Header.Height else Image^.Height:= -Header.Height;

  Image^.PixelSize:=Header.PixelSize;
  if Header.HeaderSize > SizeOf(TBMPHeader) then
  ffSeek(FFile,Header.HeaderSize);

  //Image^.dwSize:=Header.dwImageDataSize;
  ScanLineSize:=(Image^.Width * Image^.PixelSize) div 8;
  Image^.Size:=ScanLineSize *  Image^.Height;

  if not mAllocMem(Image^.Data, Image^.Size) then
  begin
    SetErrorState('BMP LOADER: Cannot allocate image memory !');
    Exit;
  end;

  ScanLineMem:=DWORD(Image^.Data);
  // Check if image is upside down
  if Header.Height > 0 then
  begin
    // Read reversed
    Inc(ScanLineMem, Image^.Size);
    for ScanLineIndex:=0 to Image^.Height -1 do
    begin
      Dec(ScanLineMem, ScanLineSize);
      ffRead(FFile,POINTER(ScanLineMem)^, ScanLineSize);
      //Dec(ScanLineMem,dwScanLineSize);
    end;
  end
    else
  begin
    // Read Normally
    for ScanLineIndex:=0 to Image^.Height - 1 do
    begin
      ffRead(FFile,POINTER(ScanLineMem)^, ScanLineSize);
      Inc(ScanLineMem, ScanLineSize);
    end;
  end;
  //BlockRead(FFile,Image^.Data^,Image^.dwSize);
  ffClose(FFile);
  Result:=True;
end;

function SaveBMPImage(const FileName:PChar;var Image:PVastImage):Boolean;
var
  FFile:TVastFile;
  Header:TBMPHeader;
begin
  Result:=False;
  if (not IsImageSet(Image)) then
  begin
    SetErrorState('BMP SAVER: No image to save !');
    Exit;
  end;

  if not ffCreate(FFile,FileName) then
  begin
    SetErrorState('BMP SAVER: Cannot create output file !');
    Exit;
  end;

  EraseMem(Header,SizeOf(TBMPHeader));
  //with Header do
  Header.Marker:=BMPMarker;
  Header.FileSize:=SizeOf(TBMPHeader)+Image^.Size;
  Header.HeaderSize:=$36;
  Header.InfoSize:=$28;
  Header.Width:=Image^.Width;
  Header.Height:=-Image^.Height;
  Header.PlaneCount:=$01;
  Header.PixelSize:=Image^.PixelSize;
  Header.ImageDataSize:=Image^.Size;

  ffWrite(FFile,Header,SizeOf(TBMPHeader));

  ffWriteCached(FFile,Image^.Data^,Image^.Size);

  ffClose(FFile);
  Result:=True;
end;

end.
