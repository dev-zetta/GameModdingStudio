unit VastTGAImage;

interface

uses
  VastImage, VastImagePixelFormat, VastImageTypes, VastFile, VastMemory, VastUtils;

function LoadTGAImage(const FileName:PChar;var Image:PVastImage):Boolean;
function SaveTGAImage(const FileName:PChar;var Image:PVastImage):Boolean;

implementation

const
  TGAXMarker = DWORD(Byte('T') or (Byte('G') shl 8) or (Byte('A') shl 16) or (Byte('X') shl 24));

  TGAX_FOOTER = $00000001;
  TGAX_MIPMAP = $00000002;

type
  TTGAHeader = Packed Record
    IDLength: BYTE;
    CMapType: BYTE;
    ImageType: BYTE;
    CMapOffset: WORD;
    CMapLength: WORD;
    CMapDepth: BYTE;
    XOffset: SmallInt;
    YOffset: SmallInt;
    Width: SmallInt;
    Height: SmallInt;
    PixelSize: BYTE;
    ImageDescriptor: BYTE;
  end;

  TTGAFooter = Packed Record
    ExtOffset: DWORD;                 // Extension Area Offset
    DevDirOffset: DWORD;              // Developer Directory Offset
    Signature: Array[0..15] of Char;  // TRUEVISION-XFILE
    Delimiter: BYTE;                   // ASCII period '.'
    NullChar: BYTE;                   // 0
  end;

  TTGAXHeader = Packed Record
    Marker:DWORD;
    Flags:DWORD;
    FileSize:DWORD;
    DataSize:DWORD;
    ImageCount:DWORD;
    ImageSize:DWORD;
    CheckSum:DWORD;
  end;

var
  bIsError:BOOLEAN;
  ErrorMessage:PCHAR;

procedure ResetErrorState;
begin
  bIsError:=False;
  //EraseMem(ErrorMessage,256);
  ErrorMessage:=nil;
end;

procedure SetErrorState(const Msg:PCHAR);
begin
  bIsError:=True;
  ErrorMessage:=MSG;
end;

function LoadTGAImage(const FileName:PChar;var Image:PVastImage):Boolean;
var
  //FFile:File of Byte;
  FFile:TVastFile;
  FileSize:DWORD;

  Header:TTGAHeader;
  HeaderEx:TTGAXHeader;
  Footer:TTGAFooter;

  InData:POINTER;
  InDataMem:DWORD;
  InDataSize:DWORD;

  InDataMemEnd:DWORD;

  OutData:POINTER;
  OutDataMem:DWORD;
  OutDataSize:DWORD;

  IsCompressed:BOOLEAN;
  IsPaletteUsed:BOOLEAN;

  PaletteMem:DWORD;
  PaletteSize:DWORD;

  AlphaChannelSize:DWORD;
  // byte position and size of pixel
  PixelPos:DWORD;
  PixelSize:DWORD;
  PixelMem:DWORD;
  // RLE Packet index and size
  Index:DWORD;
  PacketSize:DWORD;
  IsExtended:BOOLEAN;
begin
  Result:=False;

  ResetErrorState;
  if not ffOpen(FFile,FileName) then
  begin
    SetErrorState('TGA LOADER: Cannot open input file !');
    Exit;
  end;

  IsExtended:=False;
  FileSize:=FFile.Size;
  // Read TGA Header
  ffRead(FFile,Header,SizeOf(TTGAHeader));

  // Skip ID Length
  if Header.IDLength <> SizeOf(TTGAXHeader) then
  begin
    // Read TGA Footer
    ffSeekEnd(FFile,-SizeOf(TTGAFooter));
    ffRead(FFile,Footer,SizeOf(TTGAFooter));
    if Footer.Signature <> 'TRUEVISION-XFILE' then
    begin
      SetErrorState('TGA LOADER: No TGA footer !');
      Exit;
    end;

    // Get back to original position
    ffSeek(FFile,SizeOf(TTGAHeader)+Header.IDLength);
    OutDataSize:=Header.Width * Header.Height * (Header.PixelSize div 8);
  end
    else
  begin
    ffRead(FFile,HeaderEx,SizeOf(TTGAXHeader));
    if HeaderEx.Marker <> TGAXMarker then
    Exit;

    OutDataSize:=HeaderEx.DataSize;
    IsExtended:=True;
  end;

  if not InitImage(Image) then
  Exit;

  //GetMem(mOutData,OutDataSize);
  if not mAllocMem(OutData, OutDataSize) then
  begin
    SetErrorState('TGA LOADER: No enought memory to load input file !');
    Exit;
  end;

  Image^.Data:=OutData;
  Image^.Size:=OutDataSize;
  Image^.Width:=Header.Width;
  Image^.Height:=Header.Height;
  Image^.PixelSize:=Header.PixelSize;

  AlphaChannelSize:=(Header.ImageDescriptor and $0F); // internal usage only
  case Header.ImageType of
    0:
    begin
      SetErrorState('TGA LOADER: Bad TGA header (ImageType) !');
      Exit;
    end;
    1,2,9,10: // True color , RLE compressed or Palette
    begin
      IsPaletteUsed:= (Header.ImageType = 1) or (Header.ImageType = 9);
      IsCompressed:= (Header.ImageType = 9) or (Header.ImageType = 10);
      case Header.PixelSize of
        1,8: Exit; // 1 and 8 bit images should be bImageType = 3
        16: // 16 bit per pixel
        begin
          case AlphaChannelSize of
            0: SetPixelFormatInfo(Image,PIXEL_FORMAT_X1R5G5B5);
            1: SetPixelFormatInfo(Image,PIXEL_FORMAT_A1R5G5B5);
            else Exit;
          end;
        end;
        24: // 24 bit per pixel
        begin
          if AlphaChannelSize <> 0 then
          Exit; // RGB24 should not have a alpha channel
          SetPixelFormatInfo(Image,PIXEL_FORMAT_R8G8B8);
        end;
        32: // 32 bit per pixel
        begin
          case AlphaChannelSize of
            0: SetPixelFormatInfo(Image,PIXEL_FORMAT_R8G8B8X8);
            8: SetPixelFormatInfo(Image,PIXEL_FORMAT_R8G8B8A8);
            1: SetPixelFormatInfo(Image,PIXEL_FORMAT_R8G8B8X8); // BUG! FIX IT
            //else Exit;
          end; // case end
        end; // case
        else Exit;
      end; // case end
    end; // case
    3,11: // Black and White
    begin
      IsPaletteUsed:= False;
      IsCompressed:= (Header.ImageType = 11);
      case Header.PixelSize of
        1: SetPixelFormatInfo(Image,PIXEL_FORMAT_INDEX1);
        8: SetPixelFormatInfo(Image,PIXEL_FORMAT_INDEX8);
        else Exit;
      end; // case end
    end; // case
    else Exit;
  end; // case end;

  PixelSize:=Header.PixelSize div 8; // in Bytes
  if IsCompressed then
  begin
    // Image is RLE compressed

    if IsExtended then
    InDataSize:=HeaderEx.DataSize
      else
    // Get size of compressed data,TGA doesnt save this value (pretty lame format)
    InDataSize:= (FileSize - Footer.DevDirOffset) - (SizeOf(TTGAHeader) + SizeOf(TTGAFooter));

    if not mAllocMem(InData,InDataSize) then
    begin
      SetErrorState('TGA LOADER: Cannot allocate input memory (RLE) !');
      Exit;
    end;

    ffReadCached(FFile,InData^,InDataSize);

    InDataMem:=DWORD(InData);
    OutDataMem:=DWORD(OutData);

    InDataMemEnd:= InDataMem + InDataSize;
    while InDataMem < InDataMemEnd do
    begin
      PacketSize:=PBYTE(InDataMem)^ and $7F;
      if (PBYTE(InDataMem)^ and $80) > 0 then
      begin
        inc(InDataMem); // Skip rle packet header
        for Index:=0 to PacketSize do
        begin
          for PixelPos:=0 to PixelSize - 1 do
          begin
            PBYTE(OutDataMem)^:=PBYTE(InDataMem+PixelPos)^;
            inc(OutDataMem);
          end;
          inc(InDataMem,PixelSize);
        end; // case
      end // if
        else
      begin
        inc(InDataMem); // Skip rle packet header
        for Index:=0 to PacketSize do
        begin
          for PixelPos:=0 to PixelSize - 1 do
          begin
            PBYTE(OutDataMem)^:=PBYTE(InDataMem)^;
            inc(InDataMem);
            inc(OutDataMem);
          end; // for
        end; // case
      end; // case end
    end; // while

    mFreeMem(InData);
    ffClose(FFile);
    Result:=True;
    Exit;
  end // case
    else// Image is in raw or using palette
  begin
    if IsPaletteUsed then
    begin
      PaletteSize:=(Header.CMapLength * Header.CMapDepth) div 8;
      if not hAllocMem(POINTER(PaletteMem),PaletteSize) then
      begin
        SetErrorState('TGA LOADER: Cannot allocate palette memory !');
        Exit;
      end;

      ffRead(FFile,POINTER(PaletteMem)^,PaletteSize);

      InDataSize:=Header.Width * Header.Height;

      if not mAllocMem(InData,InDataSize) then
      begin
        SetErrorState('TGA LOADER: Cannot allocate input memory (PLT) !');
        Exit;
      end;

      ffReadCached(FFile,InData^,InDataSize);

      InDataMem:=DWORD(InData);
      OutDataMem:=DWORD(OutData);
      for Index:=0 to InDataSize - 1 do
      begin
        PixelMem:=PaletteMem + (PBYTE(InDataMem)^ * PixelSize); // TODO: shl intead mul ?
        for PixelPos:=0 to PixelSize - 1 do
        begin
          PBYTE(OutDataMem)^:=PBYTE(PixelMem+PixelPos)^;
          inc(OutDataMem);
        end;
        inc(InDataMem);
      end;
      mFreeMem(InData);
      hFreeMem(POINTER(PaletteMem));
    end // bIsPaletteUsed
      else
    begin
      // Raw image data
      ffReadCached(FFile,Image^.Data^,Image^.Size);
    end;

    ffClose(FFile);
    Result:=True;
    Exit;
  end; // case end
end;

function SaveTGAImage(const FileName:PChar;var Image:PVastImage):Boolean;
var
  //FFile:File of Byte;
  FFile:TVastFile;
  FileSize:DWORD;

  Header:TTGAHeader;
  //Footer:TTGAFooter;
  HeaderEx:TTGAXHeader;

  InData:POINTER;
  InDataMem:DWORD;
  InDataSize:DWORD;

  InDataMemEnd:DWORD;

  OutData:POINTER;
  OutDataMem:DWORD;
  OutDataSize:DWORD;

  IsCompressed:BOOLEAN;
  IsPaletteUsed:BOOLEAN;

  PaletteMem:DWORD;
  PaletteSize:DWORD;

  AlphaChannelSize:DWORD;
  // byte position and size of pixel
  PixelPos:DWORD;
  PixelSize:DWORD;
  PixelMem:DWORD;
  // RLE Packet index and size
  Index:DWORD;
  PacketSize:DWORD;
begin
  Result:=False;
  ResetErrorState;

  if not IsImageSet(Image) then
  begin
    SetErrorState('TGA SAVER: No image to save !');
    Exit;
  end;

  //FillChar(Header,SizeOf(TTGAHeader),$00);  // Using fillchar is not Vaster
  Header.IDLength:=SizeOf(TTGAXHeader);
  Header.CMapType:=$00;
  if Image^.PixelSize = $08 then
  Header.ImageType:=$03 else Header.ImageType:=$02; // If Greyscale els
  Header.CMapOffset:=$00;
  Header.CMapLength:=$00;
  Header.CMapDepth:=$00;
  Header.XOffset:=$00;
  Header.YOffset:=$00;
  Header.Width:=Image^.Width;
  Header.Height:=Image^.Height;
  Header.PixelSize:=Image^.PixelSize;
  // Set number of bits per alpha channel

  //case Image^.PixelFormat of
  //  PIXEL_FORMAT_A1R5G5B5: Header.bImageDescriptor:=$01;
  //  PIXEL_FORMAT_R8G8B8A8: Header.bImageDescriptor:=$08;
  //end;

  // TODO : Fix and add
  if Image^.IsAlphaFormat then
  begin
    case Image^.PixelFormat of
      PIXEL_FORMAT_A1R5G5B5: Header.ImageDescriptor:=$01;
      PIXEL_FORMAT_R8G8B8A8: Header.ImageDescriptor:=$08;
    end;
  end;

  EraseMem(HeaderEx,SizeOf(TTGAXHeader));
  HeaderEx.Marker:=TGAXMarker;
  HeaderEx.FileSize:=SizeOf(TTGAHeader)+SizeOf(TTGAXHeader);
  inc(HeaderEx.FileSize,Image^.Size);
  HeaderEx.DataSize:=Image^.Size;
  HeaderEx.CheckSum:=$00;

  if not ffCreate(FFile,FileName) then
  begin
    SetErrorState('TGA SAVER: Cannot create output file !');
    Exit;
  end;

  ffWrite(FFile,Header,SizeOf(TTGAHeader));
  ffWrite(FFile,HeaderEx,SizeOf(TTGAXHeader));
  //ffWrite(FFile,Image^.mData^,Image^.Size);
  ffWriteCached(FFile,Image^.Data^,Image^.Size);
  ffClose(FFile);
  Result:=True;
end;

end.
