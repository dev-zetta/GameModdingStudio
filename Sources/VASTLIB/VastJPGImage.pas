unit VastJPGImage;

interface

uses
  Windows, VastImage, VastImageTypes, VastMemory, VastFile, VastUtils;

function LoadJPGImage(const FileName:String;var mImage:PVastImage):Boolean;
implementation

const
  // Swapped markers...
  // Source: http://wooyaggo.tistory.com/tag/JPEG
  M_SOF0  = $C0FF; // Baseline DCT
  M_SOF1  = $C1FF; // Extended Sequential DCT
  M_SOF2  = $C2FF; // Progressive DCT
  M_SOF3  = $C3FF; // Lossless (sequential)
  M_DHT   = $C4FF; // Define Huffman Table
  M_SOF5  = $C5FF; // Differential sequential DCT
  M_SOF6  = $C6FF; // Differential progressive DCT
  M_SOF7  = $C7FF; // Differential lossless (sequential)

  M_JPG   = $C8FF; // JPEG Extensions
  M_SOF9  = $C9FF; // Extended sequential DCTFF; Arithmetic coding
  M_SOF10 = $CAFF; // Progressive DCTFF; Arithmetic coding
  M_SOF11 = $CBFF; // Lossless (sequential)FF; Arithmetic coding
  M_DAC   = $CCFF; // Define Arithmetic Coding
  M_SOF13 = $CDFF; // Differential sequential DCTFF; Arithmetic coding
  M_SOF14 = $CEFF; // Differential progressive DCTFF; Arithmetic coding
  M_SOF15 = $CFFF; // Differential lossless (sequential)FF; Arithmetic coding

  M_RST0  = $D0FF; // Restart Marker 0
  M_RST1  = $D1FF;
  M_RST2  = $D2FF;
  M_RST3  = $D3FF;
  M_RST4  = $D4FF;
  M_RST5  = $D5FF;
  M_RST6  = $D6FF;
  M_RST7  = $D7FF; // Restart Marker 7

  M_SOI   = $D8FF; // Start of Image
  M_EOI   = $D9FF; // End of Image
  M_SOS   = $DAFF; // Start of Scan
  M_DQT   = $DBFF; // Define Quantization Table
  M_DNL   = $DCFF; // Define Number of Lines
  M_DRI   = $DDFF; // Define Restart Interval
  M_DHP   = $DEFF; // Define Hierarchical Progression
  M_EXP   = $DFFF; // Expand Reference Component

  M_APP0  = $E0FF;
  M_APP1  = $E1FF; // Exif
  M_APP2  = $E2FF; // ICC color profile
  M_APP3  = $E3FF; // JPS Tag for Stereoscopic JPEG images
  M_APP4  = $E4FF;
  M_APP5  = $E5FF;
  M_APP6  = $E6FF; // NITF Lossles profile
  M_APP7  = $E7FF;
  M_APP8  = $E8FF;
  M_APP9  = $E9FF;
  M_APP10 = $EAFF; // ActiveObject (multimedia messages / captions)
  M_APP11 = $EBFF; // HELIOS JPEG Resources (OPI Postscript)
  M_APP12 = $ECFF; // Picture Info (older digicams)FF;Photoshop Save for Web: Ducky
  M_APP13 = $EDFF; // Photoshop Save As: IRBFF; 8BIMFF; IPTC
  M_APP14 = $EEFF; // Photoshop
  M_APP15 = $EFFF;

  M_JPG0  = $F0FF;
  M_JPG1  = $F1FF;
  M_JPG2  = $F2FF;
  M_JPG3  = $F3FF;
  M_JPG4  = $F4FF;
  M_JPG5  = $F5FF;
  M_JPG6  = $F6FF;
  M_JPG7  = $F7FF; // Lossless JPEG
  M_JPG8  = $F8FF; // Lossless JPEG Extension Parameters
  M_JPG9  = $F9FF;
  M_JPG10 = $FAFF;
  M_JPG11 = $FBFF;
  M_JPG12 = $FCFF;
  M_JPG13 = $FDFF;
  M_COM   = $FEFF; // Comment

  M_TEM   = $01FF;

  JFIFMarker = DWORD(Byte('J') or (Byte('F') shl $08) or (Byte('I') shl $10) or (Byte('F') shl $18));

const
  ZigZagTable : Array[0..63] of BYTE = (
    0,  1,  8, 16,  9,  2,  3,  10,
    17, 24, 32, 25, 18, 11,  4,  5,
    12, 19, 26, 33, 40, 48, 41, 34,
    27, 20, 13,  6,  7, 14, 21, 28,
    35, 42, 49, 56, 57, 50, 43, 36,
    29, 22, 15, 23, 30, 37, 44, 51,
    58, 59, 52, 45, 38, 31, 39, 46,
    53, 60, 61, 54, 47, 55, 62, 63
  );

type
  TJFIFSegment = Packed Record
    wMarker:WORD;
    wSize:WORD
  end;

  TAPP0Segment = Packed Record
		dwMarker:DWORD; // = "JFIF",'\0'
    bMajorVersion:BYTE;
    bMinorVersion:BYTE;
		bXYUnits:BYTE;
		wXDensity:WORD;
		wYDensity:WORD;
		bThumbWidth:BYTE;
		bThumbHeight:BYTE;
  end;

  TSOF0Segment = Packed Record
		bSampleSize:BYTE;
		wHeight:WORD;
		wWidth:WORD;
		bChannelCount:BYTE;
    ChannelInfo:Array[0..3] of Packed Record Index:Byte end;
  end;

  TDQTSegment = Packed Record
    TableFlags:Byte;
    Table:Array[0..63] of BYTE;
  end;

  TSOSMarker = Packed Record
    //WORD marker;  // = 0xFFDA
    //Size:Word; // = 12
    Channels:Byte; // Should be 3: truecolor JPG
    IdY:Byte; //1
    HTY:Byte; //0 // bits 0..3: AC table (0..3)
				   // bits 4..7: DC table (0..3)
    IdCb:Byte; //2
    HTCb:Byte; //0x11
    IdCr:Byte; //3
    HTCr:Byte; //0x11
     // not interesting, they should be 0,63,0
    SS:Byte;
    SE:Byte;
    BF:Byte;
  end;

var
  bIsError:BOOLEAN;
  ErrorMessage:Array[0..255] of Char;

procedure ResetErrorState;
begin
  bIsError:=False;
  EraseMem(ErrorMessage,256);
end;

function IsJPGHeader(const lpMemory:POINTER):BOOLEAN;assembler;
asm
  test eax,eax
  jz @EXIT
  mov dx,WORD[eax+$00]
  cmp dx,$D8FF // FFD8 = SOI
  jne @EXIT
  mov edx,DWORD[eax+$02]
  cmp edx,$1000E0FF // FFE0 = APP0
  jne @EXIT
  xor eax,eax
  inc eax
  ret
  @EXIT:
  xor eax,eax
  ret
end;


function LoadJPGImage(const FileName:String;var mImage:PVastImage):Boolean;
label
  lblExit;
var
  //FFile:File of Byte;
  FFile:TVastFile;

  //dwFilePos:DWORD;
  //dwFileSize:DWORD;

  //Header:TPNGHeader;
  //Chunk:TPNGChunkHeader;

  //APP0Header:TAPP0Segment;
  //SOF0Segment:TSOF0Segment;

  mInData:POINTER;
  dwInDataMem:DWORD;
  dwInDataSize:DWORD;

  mOutData:POINTER;
  dwOutDataMem:DWORD;
  dwOutDataSize:DWORD;

  dwInDataMemMax:DWORD;

  bIsCompressed:BOOLEAN;
  bIsPaletteUsed:BOOLEAN;

  dwPaletteMem:DWORD;
  dwPaletteSize:DWORD;

  dwAlphaChannelSize:DWORD;
  // byte position and size of pixel
  dwPixelPos:DWORD;
  dwPixelSize:DWORD;
  dwPixelMem:DWORD;
  // RLE Packet index and size
  dwIndex:DWORD;
  dwPacketSize:DWORD;

  dwChannelIndex,dwChannelCount:DWORD;
  //ChannelInfo:Array[0..3] of Packed Record Index:Byte end;

  dwWidth:DWORD;
  dwHeight:DWORD;

  dwQTYIndex:DWORD;
  dwQTCIndex:DWORD;

  dwHTDCIndex:DWORD;
  dwHTACIndex:DWORD;

  //HTDC81:Array[0..63] of BYTE;
  //HTDC82:Array[0..63] of BYTE;
  //HTDC81:Array[0..63] of BYTE;

  // Pointers to quantization tables in memory
  QT:Array[0..3] of DWORD;
  // Pointers to huffman tables in memory
  HTDC:Array[0..3] of DWORD;
  HTAC:Array[0..3] of DWORD;

  //dwMarker:DWORD;
  dwSegmentSize:DWORD;
begin
  Result:=False;

  ResetErrorState;

  if not EraseMem(FFile,SizeOf(TVastFile)) then
  Exit;  // Fatal Error

  if not ffOpen(FFile,FileName) then
  begin
    ErrorMessage:='JPG LOADER: Cannot open input file !';
    Exit;
  end;

  dwInDataSize:=FFile.dwSize;
  if dwInDataSize < 300 then // Minimum PNG size is cca 67 B
  begin
    ErrorMessage:='JPG LOADER: Input file is too small !';
    goto lblExit;
  end;

  if not mAllocMem(mInData,dwInDataSize) then
  begin
    ErrorMessage:='JPG LOADER: Cannot allocate input memory !';
    goto lblExit;
  end;

  // Read whole image to memory
  if ffRead(FFile,mInData^,dwInDataSize) < dwInDataSize then
  begin
    ErrorMessage:='JPG LOADER: Cannot read JPG file into memory !';
    goto lblExit;
  end;

  dwInDataMem:=DWORD(mInData);
  if PWORD(dwInDataMem+$00)^ <> M_SOI then
  begin
    ErrorMessage:='JPG LOADER: Bad SOI segment !';
    goto lblExit;
  end;
  Inc(dwInDataMem,$02);
  (*
  if (PWORD(mInDataMem+$02)^ <> M_APP0) or (PWORD(mInDataMem+$04)^ < $0010) then
  begin
    bIsError:=True;
    ErrorMessage:='JPG LOADER: Expected APP0 segment !';
    goto lblExit;
  end;
  *)
  //dwOutDataSize:=


  if not InitImage(mImage) then
  begin
    ErrorMessage:='JPG LOADER: Cannot init output image !';
    goto lblExit;
  end;
  
  // Get maximum position where we can seek
  dwInDataMemMax:=dwInDataMem + dwInDataSize;
  while dwInDataMem < dwInDataMemMax - 1 do
  begin
    //dwSegmentMarker:=PWORD(dwInDataMem)^;
    //dwSegmentSize:=SwapEndian(PWORD(dwInDataMem+$02)^);
    case PWORD(dwInDataMem)^ of
      (*
      M_APP0:
      begin
        if PWORD(dwInDataMem+$02)^ < $0010 then
        begin
          bIsError:=True;
          ErrorMessage:='PNG LOADER: Bad APP0 segment size !';
          goto lblExit;
        end;

        if PDWORD(dwInDataMem+$06)^ <> JFIFMarker then
        begin
          bIsError:=True;
          ErrorMessage:='PNG LOADER: Bad APP0 segment signature !';
          goto lblExit;
        end;




        if not mAllocMem(mOutData,dwOutDataSize) then
        begin
          bIsError:=True;
          ErrorMessage:='PNG LOADER: Cannot allocate output memory !';
          goto lblExit;
        end;

        dwOutDataMem:=DWORD(mOutData);
      end;
      *)
      M_SOF0:
      begin
        dwSegmentSize:=SwapEndian(PWORD(dwInDataMem+$02)^)+$02;
        if dwSegmentSize < 18 then
        begin
          ErrorMessage:='JPG LOADER: Wrong SOF0 segment size !';
          goto lblExit;
        end;

        //bSampleSize:BYTE;
        dwHeight:=SwapEndian(PWORD(dwInDataMem+$05)^);
		    dwWidth:=SwapEndian(PWORD(dwInDataMem+$07)^);
		    dwChannelCount:=PBYTE(dwInDataMem+$09)^;
        dwOutDataSize:=dwWidth * dwHeight * dwChannelCount; // 8 bit per channel expected

        if not mAllocMem(mOutData,dwOutDataSize) then
        begin
          ErrorMessage:='JPG LOADER: Cannot allocate output memory !';
          goto lblExit;
        end;

        if (dwChannelCount < 1) or (dwChannelCount > 4) then
        begin
          ErrorMessage:='JPG LOADER: Wrong channel count !';
          goto lblExit;
        end;

        for dwChannelIndex:=0 to dwChannelCount - 1 do
        begin

        end;

        //Inc(dwInDataMem,SwapEndian(PWORD(dwInDataMem+$02)^));
        Inc(dwInDataMem,dwSegmentSize+$02);
      end;
      M_DQT:
      begin
        dwSegmentSize:=SwapEndian(PWORD(dwInDataMem+$02)^)+$02;
        if dwSegmentSize < 69 then
        begin
          ErrorMessage:='JPG LOADER: Wrong DQT segment size !';
          goto lblExit;
        end;

        // Set quantization table pointer to proper pointer table index
        QT[PBYTE(dwInDataMem+$04)^ and $0F]:=dwInDataMem + $05;

        Inc(dwInDataMem,dwSegmentSize);
      end;
      M_DHT:
      begin
        dwSegmentSize:=SwapEndian(PWORD(dwInDataMem+$02)^)+$02;
        if dwSegmentSize < 69 then
        begin
          ErrorMessage:='JPG LOADER: Wrong DQT segment size !';
          goto lblExit;
        end;

        // Set quantization table pointer to proper pointer table index

        QT[PBYTE(dwInDataMem+$04)^ and $0F]:=dwInDataMem + $05;

        Inc(dwInDataMem,dwSegmentSize);
      end;
      M_EOI:
      begin
        Break;
      end;
        else
      begin
        // We found a marker we dont need to process or we found a error so we skip some bytes
        if (PWORD(dwInDataMem)^ > $00FF) and (PWORD(dwInDataMem)^ < $FFFF) then
        Inc(dwInDataMem,SwapEndian(PWORD(dwInDataMem+$02)^)+$02) else Inc(dwInDataMem);
      end;
    end; // case end
  end;

  //GetMem(mOutData,dwOutDataSize);
  if not mAllocMem(mOutData,dwOutDataSize) then
  Exit;
 (*
  mImage^.mData:=mOutData;
  mImage^.dwSize:=dwOutDataSize;
  mImage^.dwWidth:=Header.wWidth;
  mImage^.dwHeight:=Header.wHeight;
  mImage^.dwPixelSize:=Header.bPixelSize;
*)
  lblExit:
  begin
    bIsError:=True;
    if FFile.dwHandle <> 0 then
    ffClose(FFile);

    if mImage <> nil then
    FreeImage(mImage);

    if mInData <> nil then
    mFreeMem(mInData);

    if mOutData <> nil then
    mFreeMem(mOutData);
  end;
end;


end.
