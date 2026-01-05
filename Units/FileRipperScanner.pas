unit FileRipperScanner;

interface

uses
  Windows,
  SysUtils,
  SharedFunc,
  FileRipperMarkers,
  //FileRipperHeaders,

  FileRipperShared;

function SearchRIFF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchOGG(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchBIK(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchPNG(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchJFIF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchDDS(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchAPE(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchMP4(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function Search7ZIP(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchZIP(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchMOV(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchIFF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchMIDI(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchPSD(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchSWF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchSMK(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchSWS(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchSIFF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchFLV(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchRMF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchASF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchSND(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchWVPK(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchRAF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchXBG2(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchXPR0(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchXPR2(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchXMV(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchCAB(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchXNB(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchWAD2(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchMDL7(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchPSMF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchTTA(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchOFR(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchLPAC(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchVQF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchAVS(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchNSV(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchPVA(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchBRES(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchREFT(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchRFNA(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchRFNT(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchRSAR(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchRSTM(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchGR2(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchNCER(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchNANR(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchNCLR(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchNARC(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchSDAT(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchSSEQ(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchSSAR(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchSWAR(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchSBNK(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchTHP(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchFILM(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;

function SearchRAS(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchDPX1(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchDPX4(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
function SearchR3D(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;

function ExecuteGlobalScanner(const FileData:PFileData):Integer stdcall;

implementation

uses
  FileRipperFormats;

///////////////////////////////////////
procedure ReportError(const FileData:PFileData; const Offset:DWORD; const Size:DWORD);
begin
  MessageBoxLg('ERROR REPORTED:' +#10+#13+
    'FILE:' + FileData^.FullName +#10+#13+
    'OFFSET:' + IntToStr(Offset) +#10+#13+
    'SIZE:' + IntToStr(Size), 'ERROR MESSAGE:', 0);
end;


function IsRealFileSize(const FileData:PFileData; const Offset:DWORD; const Size:DWORD):Boolean;
begin
  Result:= False;
  if Offset > FileData^.FileSize then
  Exit;

  if Size > FileData^.FileSize then
  Exit;

  if (Offset + Size) > FileData^.FileSize then
  Exit;
  
  Result:= True;
end;

function IsASCII(const Memory: Pointer; const Size: DWORD): BOOLEAN;
var
  Index: DWORD;
  InChar: PBYTE;
  InMem: PBYTE;
begin
  if (Memory = nil) or (Size = 0) then
  begin
    Result:=False;
    Exit;
  end;

  InChar:=Memory;
  for Index := 0 to Size - 1 do
  begin
    if (InChar^ < 32) or (InChar^ > 126) then
    begin
      Result:=False;
      Exit;
    end;
    Inc(InChar);
  end;
  Result:= True;
end;

(*
function FileReadBuffer(const FileData:PFileData):DWORD;
begin
  Result:=FileData^.FilePos;
  if FileData^.IsFileOpened then
  begin
    if (FileData^.FilePos >= (FileData^.FileSize-BufferCache)) then
    begin
      FileData^.IsFileEnd:=True;
    end
      else
    begin
      //BlockRead (FFile, FileData^.Buffer, MaxBufferSize, FileData^.BufferSize);
      if ReadFile(FileData^.FileHandle, Data, Size, OutSize, nil) then
      begin
        if FileData^.BufferSize > BufferCache then
        Dec(FileData^.BufferSize, BufferCache);

        Inc (FileData^.FilePos, FileData^.BufferSize);
      end;
    end;
  end;
end;
*)
///////////////////////////////////////
function SearchRIFF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_RIFF = DWORD(Byte('R') or (Byte('I') shl 8) or (Byte('F') shl 16) or (Byte('F') shl 24));
  MARKER_WAVE = DWORD(Byte('W') or (Byte('A') shl 8) or (Byte('V') shl 16) or (Byte('E') shl 24));
  MARKER_AVI  = DWORD(Byte('A') or (Byte('V') shl 8) or (Byte('I') shl 16) or (Byte(' ') shl 24));
  MARKER_XWMA = DWORD(Byte('X') or (Byte('W') shl 8) or (Byte('M') shl 16) or (Byte('A') shl 24));
  MARKER_4XM  = DWORD(Byte('4') or (Byte('X') shl 8) or (Byte('M') shl 16) or (Byte('V') shl 24));
  MARKER_DMSC = DWORD(Byte('D') or (Byte('M') shl 8) or (Byte('S') shl 16) or (Byte('C') shl 24));
  MARKER_DMSG = DWORD(Byte('D') or (Byte('M') shl 8) or (Byte('S') shl 16) or (Byte('G') shl 24));

type
  TRIFFHeader = packed record
    Marker:DWORD;
    Size:DWORD;
    Format:DWORD;
  end;

  TRIFFChunk = packed record
    Marker:DWORD;
    Size:DWORD;
  end;
var
  Header:TRIFFHeader;

begin
  Result:=nil;
  Size:=0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TRIFFHeader));

    if not IsRealFileSize(FileData, Offset, Header.Size) then
    Exit;
    
    if (Header.Marker = MARKER_RIFF) and (Header.Size > 32) then // 32 should be minimum
    begin
      case Header.Format of
        MARKER_WAVE:  Result:=@FORMAT_TYPE_WAV;
        MARKER_AVI:   Result:=@FORMAT_TYPE_AVI;
        MARKER_XWMA:  Result:=@FORMAT_TYPE_XWMA;
        MARKER_4XM:   Result:=@FORMAT_TYPE_4XM;
        MARKER_DMSC:  Result:=@FORMAT_TYPE_DMSC;
        MARKER_DMSG:  Result:=@FORMAT_TYPE_DMSG;
        else Exit;
      end;
      Size:=Header.Size + SizeOf(TRIFFChunk);
    end; //if
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchOGG(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  SegTableMax = 255;
  MARKER_OGG = DWORD(Byte('O') or (Byte('g') shl 8) or (Byte('g') shl 16) or (Byte('S') shl 24));

type
  TOGGHeader = packed record  // 27 bytes
    Marker: DWORD;
    Version: Byte;
    TypeBits: Byte;
    GranulePos: Int64;
    Serial: Integer;
    SeqNum: Integer;
    Checksum: Integer;
    SegNum: Byte;
  end;

var
  SegIndex: BYTE;
  Header:TOGGHeader;
  SegTable: Array[0..SegTableMax-1] of Byte;
  PageSize:DWORD;

begin
  Result:=nil;
  Size:=0;
  try
    repeat
      FileSeek (FileData, Offset + Size);
      FileRead (FileData, Header, SizeOf(TOGGHeader));

      if Header.Marker <> MARKER_OGG then
      Break;

      FileRead (FileData, SegTable[0], Header.SegNum);
      PageSize:= 0;
      if Header.SegNum > 0 then
      begin
        for SegIndex:= 0 to Header.SegNum-1 do
        Inc (PageSize, SegTable[SegIndex]);
      end;

      Inc(Size, PageSize + Header.SegNum + SizeOf(TOGGHeader));

      if ((Header.TypeBits and 4) = 4) then
      begin
        if not IsRealFileSize(FileData, Offset, Size) then
        Exit;

        Result:=@FORMAT_TYPE_OGG;
        Exit;
      end; //if
    until FileData^.IsFileEnd;
  except
    ReportError(FileData, Offset, Size);
  end; //try
end;
///////////////////////////////////////
function SearchBIK(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_BIKI = DWORD(Byte('B') or (Byte('I') shl 8) or (Byte('K') shl 16) or (Byte('i') shl 24));

type
  TBIKHeader = Packed Record
    Marker: DWORD;
    FileSize:DWORD;
  end;

var
  Header:TBikHeader;

begin
  Result:=nil;
  Size:=0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TBikHeader));
    if Header.Marker = MARKER_BIKI then
    begin
      if not IsRealFileSize(FileData, Offset, Header.FileSize) then
      Exit;

      Size:=Header.FileSize;
      Result:=@FORMAT_TYPE_BIK;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchPNG(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
//http://wiki.multimedia.cx/index.php?title=Portable_Network_Graphics
const
  MARKER_IEND  = DWORD(Byte('I') or (Byte('E') shl 8) or (Byte('N') shl 16) or (Byte('D') shl 24));

type
  TPNGChunk = Packed Record
    Size:DWORD;
    Marker:DWORD;
  end;

var
  Chunk:TPNGChunk;

begin
  Result:=nil;
  try
    Size:=8;
    while (not FileData^.IsFileEnd) do
    begin
      FileSeek (FileData, Offset + Size);
      FileRead(FileData, Chunk, SizeOf(TPNGChunk));

      Inc(Size, SwapLong(Chunk.Size)+ SizeOf(TPNGChunk) + 4);

      if not IsRealFileSize(FileData, Offset, Size) then
      Exit;

      if Chunk.Marker = MARKER_IEND then
      begin
        Result:=@FORMAT_TYPE_PNG;
        Exit;
      end;
    end; //while
  except
    ReportError(FileData, Offset, Size);
  end; //with
end;

///////////////////////////////////////
function SearchJFIF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_SOF0  = WORD($FF or ($C0 shl 8)); // For testing usage
  MARKER_APP0  = WORD($FF or ($E0 shl 8));
  MARKER_SOI   = WORD($FF or ($D8 shl 8));
  MARKER_SOS   = WORD($FF or ($DA shl 8));
  MARKER_EOI   = WORD($FF or ($D9 shl 8));

type
  TJFIFSegment = Packed Record
    Marker:WORD;
    Size:WORD
  end;

var
  Buffer: Pointer;
  BufferSize: DWORD;
  Index:DWORD;
  Segment:TJFIFSegment;
  IsAPP0:Boolean;
  IsProper:Boolean;

begin
  Result:=nil;
  try
    Size:=2;

    IsAPP0:=False;
    IsProper:=True;
    while(not FileData^.IsFileEnd) do
    begin
      FileSeek(FileData, Offset + Size);
      FileRead(FileData, Segment, SizeOf(TJFIFSegment));
      Inc(Size, SwapShort(Segment.Size) + 2);

      if not IsRealFileSize(FileData, Offset, Size) then
      Exit;

      if Segment.Marker < MARKER_SOF0 then
      begin
        // is required for jpeg
        IsProper:=False;
        Break;
      end;

      if Segment.Marker = MARKER_APP0 then
      IsAPP0:=True;

      // Start of Scan marker doesnt have size, so we need to search
      // for a End of Image marker
      if Segment.Marker = MARKER_SOS then
      begin
        if not IsAPP0 then
        begin
          IsProper:=False;
          Break;
        end;

        GetMem(Buffer, MaxBufferSize);
        while (not FileData^.IsFileEnd) do
        begin
          FileSeek(FileData, Offset + Size);
          BufferSize:=FileRead(FileData, Buffer^, MaxBufferSize);
          Inc(Size, BufferSize);

          for Index := 0 to BufferSize - 1 do
          begin
            if (PWORD(DWORD(Buffer) + Index)^ = MARKER_EOI) then
            begin
              Size:=(Size - (BufferSize - Index)) + 2;
              Result:=@FORMAT_TYPE_JFIF;
              FreeMem(Buffer);
              Exit;
            end;  // if
          end; // for
        end; // while
        // No end marker was found - fatal error
        FreeMem(Buffer);
        IsProper:=False;
        Break;
      end; // if

      if not IsProper then
      Break;
    end;  //while
  except
    ReportError(FileData, Offset, Size);
  end;
end;

(*
///////////////////////////////////////
function SearchBMP(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):boolean;
var
  //i:DWORD;
  //BuffPos:DWORD;
  Header:TBMPHeader;
begin
  Result:=False;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TBMPHeader));
    // TODO: Probably more tests will be needed
    if (Header.Reserved = $00) and (Header.HeaderSize = $36) and (Header.InfoSize = $28) and (Header.PixelSize <= 32) then
    begin
      Size:=Header.FileSize;
      Result:=Size > 0;
      Exit;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
*)
///////////////////////////////////////
function SearchDDS(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  TexelDim = 4*4;

  MARKER_DXT1  = DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('1') shl 24));
  MARKER_DXT3  = DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('3') shl 24));
  MARKER_DXT5  = DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('5') shl 24));
  //http://www.koders.com/cpp/fid0641587A4DA23569ED3F21C8CE41723BEDA2251D.aspx?s=3DC+header#L66
  MARKER_ATI1  = DWORD(Byte('A') or (Byte('T') shl 8) or (Byte('I') shl 16) or (Byte('1') shl 24));
  MARKER_ATI2  = DWORD(Byte('A') or (Byte('T') shl 8) or (Byte('I') shl 16) or (Byte('2') shl 24));
  MARKER_DX10  = DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('1') shl 16) or (Byte('0') shl 24));

  // Constants for DDS loader
  { Constans used by TDDSurfaceDesc2.Flags.}
  DDSD_CAPS            = $00000001;
  DDSD_HEIGHT          = $00000002;
  DDSD_WIDTH           = $00000004;
  DDSD_PITCH           = $00000008;
  DDSD_PIXELFORMAT     = $00001000;
  DDSD_MIPMAPCOUNT     = $00020000;
  DDSD_LINEARSIZE      = $00080000;
  DDSD_DEPTH           = $00800000;

  { Constans used by TDDSPixelFormat.Flags.}
  DDPF_ALPHAPIXELS     = $00000001;    // used by formats which contain alpha
  DDPF_FOURCC          = $00000004;    // used by DXT and large ARGB formats
  DDPF_RGB             = $00000040;    // used by RGB formats
  DDPF_LUMINANCE       = $00020000;    // used by formats like D3DFMT_L16
  DDPF_BUMPLUMINANCE   = $00040000;    // used by mixed signed-unsigned formats
  DDPF_BUMPDUDV        = $00080000;    // used by signed formats

  { Constans used by TDDSCaps.Caps1.}
  DDSCAPS1_COMPLEX      = $00000008;
  DDSCAPS1_TEXTURE      = $00001000;
  DDSCAPS1_MIPMAP       = $00400000;

  { Constans used by TDDSCaps.Caps2.}
  DDSCAPS2_CUBEMAP     = $00000200;
  DDSCAPS2_POSITIVEX   = $00000400;
  DDSCAPS2_NEGATIVEX   = $00000800;
  DDSCAPS2_POSITIVEY   = $00001000;
  DDSCAPS2_NEGATIVEY   = $00002000;
  DDSCAPS2_POSITIVEZ   = $00004000;
  DDSCAPS2_NEGATIVEZ   = $00008000;
  DDSCAPS2_VOLUME      = $00200000;

type
///////////////////////////////////////
/// Headers

  TDXGI_FORMAT = (
    DXGI_FORMAT_UNKNOWN = 0,
    DXGI_FORMAT_R32G32B32A32_TYPELESS = 1,
    DXGI_FORMAT_R32G32B32A32_FLOAT = 2,
    DXGI_FORMAT_R32G32B32A32_UINT = 3,
    DXGI_FORMAT_R32G32B32A32_SINT = 4,
    DXGI_FORMAT_R32G32B32_TYPELESS = 5,
    DXGI_FORMAT_R32G32B32_FLOAT = 6,
    DXGI_FORMAT_R32G32B32_UINT = 7,
    DXGI_FORMAT_R32G32B32_SINT = 8,
    DXGI_FORMAT_R16G16B16A16_TYPELESS = 9,
    DXGI_FORMAT_R16G16B16A16_FLOAT = 10,
    DXGI_FORMAT_R16G16B16A16_UNORM = 11,
    DXGI_FORMAT_R16G16B16A16_UINT = 12,
    DXGI_FORMAT_R16G16B16A16_SNORM = 13,
    DXGI_FORMAT_R16G16B16A16_SINT = 14,
    DXGI_FORMAT_R32G32_TYPELESS = 15,
    DXGI_FORMAT_R32G32_FLOAT = 16,
    DXGI_FORMAT_R32G32_UINT = 17,
    DXGI_FORMAT_R32G32_SINT = 18,
    DXGI_FORMAT_R32G8X24_TYPELESS = 19,
    DXGI_FORMAT_D32_FLOAT_S8X24_UINT = 20,
    DXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS = 21,
    DXGI_FORMAT_X32_TYPELESS_G8X24_UINT = 22,
    DXGI_FORMAT_R10G10B10A2_TYPELESS = 23,
    DXGI_FORMAT_R10G10B10A2_UNORM = 24,
    DXGI_FORMAT_R10G10B10A2_UINT = 25,
    DXGI_FORMAT_R11G11B10_FLOAT = 26,
    DXGI_FORMAT_R8G8B8A8_TYPELESS = 27,
    DXGI_FORMAT_R8G8B8A8_UNORM = 28,
    DXGI_FORMAT_R8G8B8A8_UNORM_SRGB = 29,
    DXGI_FORMAT_R8G8B8A8_UINT = 30,
    DXGI_FORMAT_R8G8B8A8_SNORM = 31,
    DXGI_FORMAT_R8G8B8A8_SINT = 32,
    DXGI_FORMAT_R16G16_TYPELESS = 33,
    DXGI_FORMAT_R16G16_FLOAT = 34,
    DXGI_FORMAT_R16G16_UNORM = 35,
    DXGI_FORMAT_R16G16_UINT = 36,
    DXGI_FORMAT_R16G16_SNORM = 37,
    DXGI_FORMAT_R16G16_SINT = 38,
    DXGI_FORMAT_R32_TYPELESS = 39,
    DXGI_FORMAT_D32_FLOAT = 40,
    DXGI_FORMAT_R32_FLOAT = 41,
    DXGI_FORMAT_R32_UINT = 42,
    DXGI_FORMAT_R32_SINT = 43,
    DXGI_FORMAT_R24G8_TYPELESS = 44,
    DXGI_FORMAT_D24_UNORM_S8_UINT = 45,
    DXGI_FORMAT_R24_UNORM_X8_TYPELESS = 46,
    DXGI_FORMAT_X24_TYPELESS_G8_UINT = 47,
    DXGI_FORMAT_R8G8_TYPELESS = 48,
    DXGI_FORMAT_R8G8_UNORM = 49,
    DXGI_FORMAT_R8G8_UINT = 50,
    DXGI_FORMAT_R8G8_SNORM = 51,
    DXGI_FORMAT_R8G8_SINT = 52,
    DXGI_FORMAT_R16_TYPELESS = 53,
    DXGI_FORMAT_R16_FLOAT = 54,
    DXGI_FORMAT_D16_UNORM = 55,
    DXGI_FORMAT_R16_UNORM = 56,
    DXGI_FORMAT_R16_UINT = 57,
    DXGI_FORMAT_R16_SNORM = 58,
    DXGI_FORMAT_R16_SINT = 59,
    DXGI_FORMAT_R8_TYPELESS = 60,
    DXGI_FORMAT_R8_UNORM = 61,
    DXGI_FORMAT_R8_UINT = 62,
    DXGI_FORMAT_R8_SNORM = 63,
    DXGI_FORMAT_R8_SINT = 64,
    DXGI_FORMAT_A8_UNORM = 65,
    DXGI_FORMAT_R1_UNORM = 66,
    DXGI_FORMAT_R9G9B9E5_SHAREDEXP = 67,
    DXGI_FORMAT_R8G8_B8G8_UNORM = 68,
    DXGI_FORMAT_G8R8_G8B8_UNORM = 69,
    DXGI_FORMAT_BC1_TYPELESS = 70,
    DXGI_FORMAT_BC1_UNORM = 71,
    DXGI_FORMAT_BC1_UNORM_SRGB = 72,
    DXGI_FORMAT_BC2_TYPELESS = 73,
    DXGI_FORMAT_BC2_UNORM = 74,
    DXGI_FORMAT_BC2_UNORM_SRGB = 75,
    DXGI_FORMAT_BC3_TYPELESS = 76,
    DXGI_FORMAT_BC3_UNORM = 77,
    DXGI_FORMAT_BC3_UNORM_SRGB = 78,
    DXGI_FORMAT_BC4_TYPELESS = 79,
    DXGI_FORMAT_BC4_UNORM = 80,
    DXGI_FORMAT_BC4_SNORM = 81,
    DXGI_FORMAT_BC5_TYPELESS = 82,
    DXGI_FORMAT_BC5_UNORM = 83,
    DXGI_FORMAT_BC5_SNORM = 84,
    DXGI_FORMAT_B5G6R5_UNORM = 85,
    DXGI_FORMAT_B5G5R5A1_UNORM = 86,
    DXGI_FORMAT_B8G8R8A8_UNORM = 87,
    DXGI_FORMAT_B8G8R8X8_UNORM = 88,
    DXGI_FORMAT_FORCE_UINT = $FFFFFFFF // force to work with DWORD
  ) ;

  TD3D10_RESOURCE_DIMENSION = (
    D3D10_RESOURCE_DIMENSION_UNKNOWN = 0,
    D3D10_RESOURCE_DIMENSION_BUFFER = 1,
    D3D10_RESOURCE_DIMENSION_TEXTURE1D = 2,
    D3D10_RESOURCE_DIMENSION_TEXTURE2D = 3,
    D3D10_RESOURCE_DIMENSION_TEXTURE3D = 4,
    D3D10_RESOURCE_DIMENSION_FORCE_UINT = $FFFFFFFF
  );

  TDDSPixelFormat = packed record
    Size: DWORD;       // Size of the structure = 32 bytes
    Flags: DWORD;      // Flags to indicate valid fields
    FourCC: DWORD;     // Four-char code for compressed textures (DXT)
    BitCount: DWORD;   // Bits per pixel if uncomp. usually 16,24 or 32
    RedMask: DWORD;    // Bit mask for the Red component
    GreenMask: DWORD;  // Bit mask for the Green component
    BlueMask: DWORD;   // Bit mask for the Blue component
    AlphaMask: DWORD;  // Bit mask for the Alpha component
  end;

  { Record describing DDS file contents.}
  TDDSHeader = packed record
    Marker: DWORD;
    Size: DWORD;       // Size of the structure = 124 Bytes
    Flags: DWORD;      // Flags to indicate valid fields
    Height: DWORD;     // Height of the main image in pixels
    Width: DWORD;      // Width of the main image in pixels
    LinearSize: DWORD; // For uncomp formats number of bytes per
                          // scanline. For comp it is the size in
                          // bytes of the main image
    Depth: DWORD;      // Only for volume text depth of the volume
    MipMapCount: DWORD;     // Total number of levels in the mipmap chain
    Reserved1: array[0..10] of DWORD; // Reserved
    PixelFormat: TDDSPixelFormat; // Format of the pixel data
    Caps: DWORD;
    Caps2: DWORD;
    Caps3: DWORD;
    Caps4: DWORD;
    Reserved2: DWORD;  // Reserved
  end;

  TDDSHeaderDXT10 = Packed Record
    DXGIFormat: DWORD;
    ResourceDimension: DWORD;
    MiscFlag: DWORD;
    ArraySize: DWORD;
    Reserved: DWORD;
  end;

var
  Header: TDDSHeader;
  HeaderDXT10: TDDSHeaderDXT10;

  FaceTag:DWORD;
  FaceIndex:DWORD;
  FaceCount:DWORD;
  SliceCount:DWORD;

  TexelSize:DWORD;
  MipMapSize:DWORD;
  MipMapIndex:DWORD;
  MipMapCount:DWORD;

  ElementSize:DWORD;
  ElementCount:DWORD;
  // helpers for conditional jumps
  IsDXT10Format,
  IsDXTCompression,
  IsVolumeTexture,
  IsCubeTexture:Boolean;
  AlignSize: DWORD;
begin
  Result:=nil;
  Size:=0;

  IsDXT10Format:= False;
  IsDXTCompression:= False;
  IsVolumeTexture:= False;
  IsCubeTexture:= False;
  ElementCount:=1;

  FileSeek(FileData, Offset);
  FileRead(FileData, Header, SizeOf(TDDSHeader));

  if (Header.PixelFormat.Flags and DDPF_FOURCC) = DDPF_FOURCC then
  begin
    case Header.PixelFormat.FourCC of
      MARKER_DXT1, MARKER_ATI1:
      begin
        TexelSize:= 8;      // 8 bytes per texel
        IsDXTCompression:=True;
      end;
      MARKER_DXT3, MARKER_DXT5, MARKER_ATI2:
      begin
        TexelSize:= 16;
        IsDXTCompression:=True;
      end;
      MARKER_DX10:
      begin
        // Added direct X10 support, not tested on many files
        // Tested only on textures without arrays, but support for arrays is added
        // ATM it works only for compressed textures
        IsDXT10Format:= True;
        FileRead(FileData, HeaderDXT10, SizeOf(TDDSHeaderDXT10));
        case TDXGI_FORMAT(HeaderDXT10.DXGIFormat) of
          DXGI_FORMAT_BC1_UNORM, DXGI_FORMAT_BC4_UNORM:
          begin
            TexelSize:= 8;
            IsDXTCompression:=True;
          end;
          DXGI_FORMAT_BC2_UNORM, DXGI_FORMAT_BC3_UNORM,
          DXGI_FORMAT_BC5_UNORM:
          begin
            TexelSize:= 16;
            IsDXTCompression:=True;
          end;
        end; //case
        if HeaderDXT10.ArraySize>1 then
        ElementCount:=HeaderDXT10.ArraySize;
      end;
    end;
  end
    else
  //if (Header.PixelFormat.Flags and DDPF_RGB) = DDPF_RGB then
  begin
    case Header.PixelFormat.BitCount of
      8: TexelSize:= 16; // 16 bytes
      16: TexelSize:=32; // 32
      24: TexelSize:=48; // 48
      32: TexelSize:=64; // 64
      // or TexelSize:=(TexelDim * BitCount) div 8;
    end;
  end;

  IsVolumeTexture:= ((Header.Caps2 and DDSCAPS2_VOLUME) = DDSCAPS2_VOLUME) and ((Header.Flags and DDSD_DEPTH) = DDSD_DEPTH);
  IsCubeTexture:= (Header.Caps2 and DDSCAPS2_CUBEMAP) = DDSCAPS2_CUBEMAP;

  // found in some image library, adding a 3 to width and height will round size correctly if its not div 4
  MipMapSize:= (((Header.Width + 3) div 4) * ((Header.Height + 3) div 4)) * TexelSize;

  MipMapCount:=1;
  if Header.MipMapCount > 1 then
  MipMapCount:= Header.MipMapCount;

  ElementSize:=0;
  // for non cube and non volume texture
  if (not IsVolumeTexture) and (not IsCubeTexture) then
  begin
    for MipMapIndex := 0 to MipMapCount - 1 do
    begin
      Inc(ElementSize, MipMapSize);
      MipMapSize:=MipMapSize shr 2;

      if (not IsDXTCompression) then
      begin
        if (MipMapSize < 4) then
        MipMapSize:= 4;
      end
      else
      begin
        if (MipMapSize < TexelSize) then
        MipMapSize:= TexelSize;
      end;
    end;
  end
    else
  if IsVolumeTexture then
  begin
    SliceCount:=Header.Depth;

    for MipMapIndex := 0 to MipMapCount - 1 do
    begin
      Inc (ElementSize, MipMapSize * SliceCount);
      if SliceCount > 1 then
      SliceCount:=SliceCount shr 1; // div 2

      //if MipMapSize > TexelSize then // volume tex cannot be compressed
      MipMapSize:=MipMapSize shr 2; // div 4
      if (MipMapSize < 4) then
      MipMapSize:= 4;
    end; // for j
  end // if
    else
  if IsCubeTexture then
  begin
    FaceCount:=0;

    FaceTag:=1024;
    for FaceIndex := 1 to 6 do
    begin
      if (Header.Caps2 and FaceTag) = FaceTag then
      inc(FaceCount);
      FaceTag:=FaceTag shl 1;
    end;

    for MipMapIndex := 0 to MipMapCount - 1 do
    begin
      Inc(ElementSize, MipMapSize * FaceCount);

      if (not IsDXTCompression) then
      begin
        if (MipMapSize < 4) then
        MipMapSize:= 4;
      end
      else
      begin
        if (MipMapSize < TexelSize) then
        MipMapSize:= TexelSize;
      end;
    end;
  end; // If isCube

  // We are done here, so we'll exit
  Size:=SizeOf(TDDSHeader) + (ElementCount*ElementSize); //+(WidthInc+HeightInc);
  if IsDXT10Format then // DX10
  Inc(Size, SizeOf(TDDSHeaderDXT10));

  if not IsRealFileSize(FileData, Offset, Size) then
  Exit;

  Result:= @FORMAT_TYPE_DDS;
end;
(*
///////////////////////////////////////
function SearchZlib(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):boolean;
var
  StreamInfo:TZlibStreamInfo;
begin
  Result:=False;
  try
    StreamInfo.Offset:=Offset;
    if GetZlibStreamInfo(FileData^.FFile, StreamInfo) then
    begin
      //AddEntryData(FileIndex, FORMAT_TYPE_ZLIB, Offset, StreamInfo.ComSize);
      Size:=StreamInfo.ComSize;
      Result:=True;
      Exit;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
*)
///////////////////////////////////////
function SearchAPE(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_MAC = DWORD(Byte('M') or (Byte('A') shl 8) or (Byte('C') shl 16) or (Byte(' ') shl 24));
  MARKER_RIFF = DWORD(Byte('R') or (Byte('I') shl 8) or (Byte('F') shl 16) or (Byte('F') shl 24));

type
  TAPEHeader = Packed Record
    Marker:DWORD;
    Version:WORD;
    PaddingLen:WORD;
    DescriptorLen:DWORD;
    HeaderLen:DWORD;

    SeekTableLen:DWORD;
    WavHeaderLen:DWORD;
    AudioDataLen:DWORD;
    AudioDataLenHigh:DWORD;
    WavTailLen:DWORD;
    CheckSum:Array[0..15] of Byte;
  end;

var
  Header:TAPEHeader;
  Marker:DWORD;

begin
  Result:= nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TAPEHeader));

    if Header.Marker <> MARKER_MAC then
    Exit;

    Size:=Header.DescriptorLen + Header.HeaderLen + Header.SeekTableLen;

    if not IsRealFileSize(FileData, Offset, Size) then
    Exit;

    FileSeek(FileData, Offset+Size);
    FileRead(FileData, Marker, SizeOf(DWORD));

    if Marker = MARKER_RIFF then
    begin
      Inc(Size, Header.WavHeaderLen + Header.AudioDataLen + Header.WavTailLen);
      Result:=@FORMAT_TYPE_APE;
      Exit;
    end;
  except
    ReportError(FileData, Offset, Size);
  end; // try
end;
///////////////////////////////////////
function SearchMP4(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_M4A = DWORD(Byte('M') or (Byte('4') shl 8) or (Byte('A') shl 16) or (Byte(' ') shl 24));
  MARKER_MP4 = DWORD(Byte('m') or (Byte('p') shl 8) or (Byte('4') shl 16) or (Byte('2') shl 24));
  MARKER_3GP = DWORD(Byte('3') or (Byte('g') shl 8) or (Byte('p') shl 16) or (Byte('4') shl 24));
  MARKER_3G2 = DWORD(Byte('3') or (Byte('g') shl 8) or (Byte('2') shl 16) or (Byte('a') shl 24));

  MARKER_FTYP = DWORD(Byte('f') or (Byte('t') shl 8) or (Byte('y') shl 16) or (Byte('p') shl 24));
  MARKER_MOOV = DWORD(Byte('m') or (Byte('o') shl 8) or (Byte('o') shl 16) or (Byte('v') shl 24));
  MARKER_FREE = DWORD(Byte('f') or (Byte('r') shl 8) or (Byte('e') shl 16) or (Byte('e') shl 24));
  MARKER_MDAT = DWORD(Byte('m') or (Byte('d') shl 8) or (Byte('a') shl 16) or (Byte('t') shl 24));
  MARKER_WIDE = DWORD(Byte('w') or (Byte('i') shl 8) or (Byte('d') shl 16) or (Byte('e') shl 24));
  MARKER_MVHD = DWORD(Byte('m') or (Byte('v') shl 8) or (Byte('h') shl 16) or (Byte('d') shl 24));
  MARKER_UDTA = DWORD(Byte('u') or (Byte('d') shl 8) or (Byte('t') shl 16) or (Byte('a') shl 24));

  MarkerCount = 7;
  MarkerTable:Array[0..MarkerCount-1] of DWORD = (
    MARKER_FTYP, MARKER_MOOV, MARKER_FREE, MARKER_MDAT,
    MARKER_WIDE, MARKER_MVHD, MARKER_UDTA
  );

type
  TMP4Segment = Packed Record
    Size:DWORD;
    Marker:DWORD;
  end;

var
  IDType:DWORD;
  Segment:TMP4Segment;
  IsProper:Boolean;
  n:longWord;

begin
  Result:=nil;
  try
    Offset:=Offset - 4;
    Size:=0;

    FileSeek(FileData, Offset + 16);
    FileRead(FileData, IDType, SizeOf(DWORD));
    case IDType of
      MARKER_MP4: Result:=@FORMAT_TYPE_MP4;
      MARKER_M4A: Result:=@FORMAT_TYPE_M4A;
      MARKER_3GP: Result:=@FORMAT_TYPE_3GP;
      MARKER_3G2: Result:=@FORMAT_TYPE_3G2;
    end;

    if Result = nil then
    Exit;

    FileSeek(FileData, Offset+Size);
    while (not FileData^.IsFileEnd) do
    begin
      FileSeek(FileData, Offset + Size);
      FileRead(FileData, Segment, SizeOf(TMP4Segment));

      if not IsRealFileSize(FileData, Offset, Size) then
      Exit;

      IsProper:=False;
      for n := 0 to MarkerCount - 1 do
      begin
        if MarkerTable[n] = Segment.Marker then
        begin
          Inc(Size, SwapLong(Segment.Size));
          IsProper:=True;
          Break;
        end;
      end; // for
      if (not IsProper) then
      Break;
    end; //while

    if not IsRealFileSize(FileData, Offset, Size) then
    Result:=nil;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function Search7ZIP(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_7ZIP    = DWORD(Byte('7') or (Byte('z') shl 8) or ($BC shl 16) or ($AF shl 24));
  MARKER_7ZIPVER = DWORD($27 or ($1C shl 8) or ($00 shl 16) or ($02 shl 24));
type
  T7ZIPHeader = Packed Record  //32 Bytes
    Marker:DWORD;
    Version:DWORD;
    Flags:DWORD;
    CompSize:DWORD;
    Unknown1:DWORD;
    AddSize:DWORD;
    Unknown2:DWORD;
    Unknown3:DWORD;
  end;

var
  Header:T7ZIPHeader;

begin
  Result:=nil;
  Size:=0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(T7ZIPHeader));

    if (Header.Marker = MARKER_7ZIP) and (Header.Version = MARKER_7ZIPVER) then
    begin
      Size:= Header.CompSize + Header.AddSize + SizeOf(T7ZIPHeader);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_7ZIP;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
(*
///////////////////////////////////////
function SearchTGA(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):boolean;
//http://www.ludorg.net/amnesia/TGA_File_Format_Spec.html
//http://www.FormatType.info/format/tga/egff.htm
//
const
  ffTGASign = 'TRUEVISION-XFILE';
var
  Header:TTGAHeader;
  Footer:TTGAFooter;
begin
  Result:=False;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TTGAHeader));

    // Uncompressed RGB image without palette only
    if (Header.IDLength <> $00) or (Header.CMapType <> $00) or
    (Header.ImageType <> $02) or (Header.CMapOffset <> $00) or
    (Header.CMapLength <> $00) or (Header.CMapDepth <> $00) or
    // No height and width > 32768
    (Header.Width < $00) or (Header.Height < $00) or
    // Minimum of 8bpp to Maximum of 32 bpp
    (Header.PixelDepth < $08) or (Header.PixelDepth > $20) or
    // Only even bpp
    ((Header.PixelDepth mod 2) > 0) or
     // Bit 4 is always set to 0 (reserved)
    ((Header.ImageDescriptor and $10) > $00) then
    Exit;

    Size:=SizeOf(TTGAHeader);
    inc(Size, Header.Width * Header.Height * (Header.PixelDepth div 8));

    FileSeek(FileData, Offset+Size);
    FileRead(FileData, Footer, SizeOf(TTGAFooter));

    // We check if we loaded footer correctly
    if (Footer.ExtOffset <> $00) or (Footer.DevDirOffset <> $00) or
    // Cehck for footer signature and null bytes
    (Footer.Signature <> ffTGASign) or (Footer.Delimiter <> $2E) or
    (Footer.NullChar <> $00) then
    Exit;

    inc(Size, SizeOf(TTGAFooter));
    Result:=True;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
*)
///////////////////////////////////////
function SearchZIP(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_LOC = DWORD(Byte('P') or (Byte('K') shl 8) or ($03 shl 16) or ($04 shl 24));
  MARKER_DIR = DWORD(Byte('P') or (Byte('K') shl 8) or ($01 shl 16) or ($02 shl 24));
  MARKER_END = DWORD(Byte('P') or (Byte('K') shl 8) or ($05 shl 16) or ($06 shl 24));
  MARKER_EXT = DWORD(Byte('P') or (Byte('K') shl 8) or ($07 shl 16) or ($08 shl 24));

type
  //http://www.onicos.com/staff/iz/formats/zip.html
  TZIPLocHeader = Packed Record // Local Header
    //ID:DWORD;
    ReqVersion:WORD;
    Flags:WORD;
    ComMethod:WORD;
    FileTime:WORD;
    FileDate:WORD;
    CheckSum:DWORD;
    ComSize:DWORD;
    DecSize:DWORD;
    NameLen:WORD;
    ExFieldLen:WORD;
  end;

  TZIPExtLocHeader = Packed Record // Extended Local Header
    //ID:DWORD;
    CheckSum:DWORD;
    ComSize:DWORD;
    DecSize:DWORD;
  end;

  TZIPCenDirHeader = Packed Record // Central Directory
    //ID:DWORD;
    Version:WORD;
    ReqVersion:WORD;
    Flags:WORD;
    ComMethod:WORD;
    FileTime:WORD;
    FileDate:WORD;
    CRC32:DWORD;
    ComSize:DWORD;
    DecSize:DWORD;
    NameLen:WORD;
    ExFieldLen:WORD;
    CommentLen:WORD;
    DiskNumStart:WORD;
    IntFileAtt:WORD;
    ExtFileAtt:DWORD;
    LocOffset:DWORD;
  end;

  TZIPCenDirHeaderEnd = Packed Record  // End of Central Directory
    //ID:DWORD;
    DiskNum:WORD;
    DiskNumStart:WORD;
    EntryDiskNum:WORD;
    EntryNum:WORD;
    CenDirSize:DWORD;
    CenDirOffset:DWORD;
    ComLen:WORD;
  end;

var
  LocHeader:TZIPLocHeader;
  ExtLocHeader:TZIPExtLocHeader;
  CenDirHeader:TZIPCenDirHeader;
  CenDirHeaderEnd:TZIPCenDirHeaderEnd;
  Marker:DWORD;

begin
  Result:=nil;
  Size:=0;
  try
    //while FileData^.FPos<FileData^.FSize do
    while (not FileData^.IsFileEnd) do
    begin
      FileSeek(FileData, Offset + Size);
      FileRead(FileData, Marker, SizeOf(DWORD));
      Inc(Size, SizeOf(DWORD));

      if not IsRealFileSize(FileData, Offset, Size) then
      Exit;

      case Marker of
        MARKER_LOC:
        begin
          FileRead(FileData, LocHeader, SizeOf(TZIPLocHeader));
          Inc(Size, LocHeader.ComSize);
          Inc(Size, LocHeader.NameLen);
          Inc(Size, LocHeader.ExFieldLen);
          Inc(Size, SizeOf(TZIPLocHeader));
        end;
        MARKER_DIR:
        begin
          FileRead(FileData, CenDirHeader, SizeOf(TZIPCenDirHeader));
          Inc(Size, CenDirHeader.NameLen);
          Inc(Size, CenDirHeader.ExFieldLen);
          Inc(Size, CenDirHeader.CommentLen);
          Inc(Size, SizeOf(TZIPCenDirHeader));
        end;
        MARKER_END:
        begin
          FileRead(FileData, CenDirHeaderEnd, SizeOf(TZIPCenDirHeaderEnd));
          Inc(Size, CenDirHeaderEnd.ComLen);
          Inc(Size, SizeOf(TZIPCenDirHeaderEnd));

          Result:= @FORMAT_TYPE_ZIP;
          Exit;
        end;
        MARKER_EXT:
        begin // Not probably used anymore
          FileRead(FileData, ExtLocHeader, SizeOf(TZIPExtLocHeader));
          Inc(Size, ExtLocHeader.ComSize);
          Inc(Size, SizeOf(TZIPExtLocHeader));
        end;
      end;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchMOV(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_FTYP = DWORD(Byte('f') or (Byte('t') shl 8) or (Byte('y') shl 16) or (Byte('p') shl 24));
  MARKER_MOOV = DWORD(Byte('m') or (Byte('o') shl 8) or (Byte('o') shl 16) or (Byte('v') shl 24));
  MARKER_FREE = DWORD(Byte('f') or (Byte('r') shl 8) or (Byte('e') shl 16) or (Byte('e') shl 24));
  MARKER_MDAT = DWORD(Byte('m') or (Byte('d') shl 8) or (Byte('a') shl 16) or (Byte('t') shl 24));
  MARKER_WIDE = DWORD(Byte('w') or (Byte('i') shl 8) or (Byte('d') shl 16) or (Byte('e') shl 24));
  MARKER_MVHD = DWORD(Byte('m') or (Byte('v') shl 8) or (Byte('h') shl 16) or (Byte('d') shl 24));
  MARKER_UDTA = DWORD(Byte('u') or (Byte('d') shl 8) or (Byte('t') shl 16) or (Byte('a') shl 24));

  MarkerCount = 4;
  MarkerTable : Array[0..MarkerCount-1] of DWORD = (
    MARKER_MOOV, MARKER_FREE, MARKER_WIDE, MARKER_MDAT
  );

type
  TMP4Segment = Packed Record
    Size:DWORD;
    Marker:DWORD;
  end;

var
  Segment:TMP4Segment;
  IsProper:Boolean;
  n:DWORD;

begin
  Result:= nil;
  Size:= 0;
  try
    Offset:=Offset-4;
    Size:=0;
    while (not FileData^.IsFileEnd) do
    begin
      if not IsRealFileSize(FileData, Offset, Size) then
      Exit;

      FileSeek(FileData, Offset+Size);
      FileRead(FileData, Segment, SizeOf(TMP4Segment));

      IsProper:=False;
      for n := 0 to MarkerCount - 1 do
      begin
        if MarkerTable[n]=Segment.Marker then
        begin
          inc(Size, SwapLong(Segment.Size));
          IsProper:=True;
          Break;
        end;
      end; // for
      if not IsProper then
      Break;
    end; //while
    Result:=@FORMAT_TYPE_MOV
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchIFF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_FORM = DWORD(Byte('F') or (Byte('O') shl 8) or (Byte('R') shl 16) or (Byte('M') shl 24));
  MARKER_AIFF = DWORD(Byte('A') or (Byte('I') shl 8) or (Byte('F') shl 16) or (Byte('F') shl 24));
  MARKER_LWO2 = DWORD(Byte('L') or (Byte('W') shl 8) or (Byte('O') shl 16) or (Byte('2') shl 24));
  MARKER_8SVX = DWORD(Byte('8') or (Byte('S') shl 8) or (Byte('V') shl 16) or (Byte('X') shl 24));

type
  TRIFFHeader = packed record
    Marker:DWORD;
    Size:DWORD;
    Format:DWORD;
  end;

  TRIFFChunk = packed record
    Marker:DWORD;
    Size:DWORD;
  end;

var
  Header:TRIFFHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TRIFFHeader));
    // TODO: Set minimum size to higher value ?
    if (Header.Marker = MARKER_FORM) and (Header.Size > 32) then
    begin
      case Header.Format of
        MARKER_AIFF: Result:= @FORMAT_TYPE_AIFF;
        MARKER_LWO2: Result:= @FORMAT_TYPE_LWO2;
        MARKER_8SVX: Result:= @FORMAT_TYPE_8SVX;
        else Exit;
      end;
      Size:=SwapLong(Header.Size) + SizeOf(TRIFFChunk);
      if not IsRealFileSize(FileData, Offset, Size) then
      Result:= nil;
    end; //for i
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchMIDI(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_MTHD = DWORD(Byte('M') or (Byte('T') shl 8) or (Byte('h') shl 16) or (Byte('d') shl 24));
  MARKER_MTRK = DWORD(Byte('M') or (Byte('T') shl 8) or (Byte('r') shl 16) or (Byte('k') shl 24));

type
  TMIDIHeader = Packed Record
    Marker:DWORD;
    Size:DWORD;
    FormatType:WORD;
    TrackCount:WORD;
    TimeDiv:WORD; // division
  end;

  TMIDIChunk = Packed Record
    Marker:DWORD;
    Size:DWORD;
  end;

var
  TrackIndex:DWORD;
  Header:TMIDIHeader;
  //HeaderSize:DWORD;
  Chunk:TMIDIChunk;
  //ChunkSize:DWORD;

begin
  Result:=nil;
  Size:=0;
  try
    //HeaderSize:=SizeOf(TMIDIHeader);
    //ChunkSize:=SizeOf(TMIDIChunk);
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TMIDIHeader));

    Size:=SizeOf(TMIDIHeader);
    for TrackIndex := 0 to SwapShort(Header.TrackCount) - 1 do
    begin
      FileRead(FileData, Chunk, SizeOf(TMIDIChunk));
      Inc(Size, SizeOf(TMIDIChunk));
      // All chunks are not added
      if Chunk.Marker <> MARKER_MTRK then
      Exit;

      Inc(Size, SwapLong(Chunk.Size));
    end;
    if IsRealFileSize(FileData, Offset, Size) then
    Result:=@FORMAT_TYPE_MIDI;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchPSD(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_8BPS = DWORD(Byte('8') or (Byte('B') shl 8) or (Byte('P') shl 16) or (Byte('S') shl 24));
type
  TPSDHeader = Packed Record
    Marker:DWORD;
    Version:WORD;
    Reserved:Array[0..5] of Byte;
    ChannelCount:WORD;
    Height:DWORD;
    Width:DWORD;
    Depth:WORD;
    ColorMode:WORD;
  end;

var
  Header:TPSDHeader;
  IsCompressed:Boolean;
  LineData:Array of Word;
  LineDataIndex:DWORD;
  LineDataCount:DWORD;
  LineSize:DWORD;

  procedure SkipBlock();
  var
    BlockSize:DWORD;
  begin
    FileSeek(FileData, Offset + Size);
    FileRead(FileData, BlockSize, SizeOf(DWORD));
    Inc(Size, SizeOf(DWORD) + SwapLong(BlockSize));
  end;

begin
  Result:=nil;
  Size:= 0;
  try
    //HeaderSize:=SizeOf(TPSDHeader);
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TPSDHeader));

    if (Header.Marker <> MARKER_8BPS) or (SwapShort(Header.Version) <> 1) then
    Exit;

    // Skip header size
    Inc(Size, SizeOf(TPSDHeader));

    // Skip "Color Mode Data Block" (palette)
    SkipBlock;

    // Skip Image Resources Block
    SkipBlock;

    // Skip Layer and Mask Information Block
    SkipBlock;

    if not IsRealFileSize(FileData, Offset, Size) then
    Exit;

    FileSeek(FileData, Offset + Size + 1);
    FileRead(FileData, IsCompressed, SizeOf(Byte));
    Inc(Size, 2);
    if IsCompressed then
    begin
      LineDataCount:=SwapShort(Header.ChannelCount) * SwapLong(Header.Height);
      SetLength(LineData, LineDataCount);
      FileSeek(FileData, Offset + Size);
      FileRead(FileData, LineData[0], LineDataCount * SizeOf(Word));
      Inc(Size, LineDataCount * SizeOf(Word));

      for LineDataIndex := 0 to LineDataCount - 1 do
      Inc(Size, SwapShort(LineData[LineDataIndex]));

      SetLength(LineData, 0);
    end
      else
    begin
      LineSize:=SwapLong(Header.Width) * (SwapShort(Header.Depth) div SwapShort(Header.ChannelCount));
      Inc(Size, LineSize * SwapLong(Header.Height));
    end;

    if IsRealFileSize(FileData, Offset, Size) then
    Result:=@FORMAT_TYPE_PSD;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
(*
///////////////////////////////////////
function SearchMP3(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):boolean;
//MP3Links
//http://www.codeproject.com/KB/audio-video/mp3info-by-shoonya.aspx
//http://www.devhood.com/tutorials/tutorial_details.aspx?tutorial_id=79
//http://mpgedit.org/mpgedit/mpeg_format/mpeghdr.htm#MPEGTAG
//http://www.mp3-converter.com/mp3codec/mp3_anatomy.htm
//ID3 Links
//http://id3lib.sourceforge.net/id3/id3v2.4.0-structure.txt
//http://tebl.homelinux.com/files/project_9/_doc/id3v2_8c-source.html
//http://id3lib.sourceforge.net/id3/id3v2.3.0.html
//http://en.wikipedia.org/wiki/ID3
//http://www.id3.org/id3v2-00
//http://www.id3.org/id3v2.4.0-structure
///http://www.id3.org/d3v2.3.0
const
// MPEG 2 & 2.5
  MPEGV20BitTable : Array[0..2] of Array [0..15] of Word = (
    (0,  8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, 0), // Layer III
    (0,  8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, 0), // Layer II
    (0, 32, 48, 56, 64, 80, 96, 112, 128, 144, 160, 176, 192, 224, 256, 0)  // Layer I
  );

// MPEG 1
  MPEGV10BitTable : Array[0..2] of Array [0..15] of Word = (
    (0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 0), // Layer III
    (0, 32, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 384, 0), // Layer II
    (0, 32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 0) // Layer I
  );

var
  Header:Array[0..15] of Byte;
  ID3FrameLength:DWORD;
  MP3FrameCount, MP3FrameLength, MP3SampleRate, MP3BitRate:DWORD;
begin
  Result:=False;
  try
    Size:=0;

    //if ((Header[0] and $FF) <> $FF) or ((Header[1] and $E0) <> $E0) then
    //Exit;
    FileSeek(FileData, Offset);
    FileData^.FIsFileEnd:=False;
    MP3FrameCount:=0;
    while (not FileData^.FIsFileEnd) do
    begin
      FileSeek(FileData, Offset+Size);
      if FileData^.FIsFileEnd then
      Break;

      FileRead(FileData, Header[0], 16);

      // ID3V1
      if (Header[0] = $54) and (Header[1] = $41) and (Header[2] = $47) then
      begin
        case Header[3]=$2B of  // Check for extended version of tag
          True: inc(Size, $E3); //227
          False: inc(Size, $80); //128
        end;
        Continue;
      end;


      // ID3V2, ID3V3, ID3V4 loading
      if (Header[0] = $49) and (Header[1] = $44) and (Header[2] = $33) then
      begin
        case Header[3] of
          $02:;   // TODO
          $03:;
          $04:;
          else Break;
        end;
        ID3FrameLength:=
        ((Header[6] and 127) shl 21) or
        ((Header[7] and 127) shl 14) or
        ((Header[8] and 127) shl  7) or
        (Header[9] and 127);
        inc(Size, ID3FrameLength+10);

        //footer_present
        if (Header[5] and (1 shl 4)) = 1 then
        inc(Size, 10);

        //extended_header
        if (Header[5] and (1 shl 6)) = 1 then
        begin
          FileSeek(FileData, Offset+Size);
          FileRead(FileData, Header[0], 16);
          // Header Size
          inc(Size, DWORD(Header[0]));
          // Padding Size
          inc(Size, DWORD(Header[6]));
          // CRC Check in Flag
          if (Header[4] and (1 shl 7)) = 1 then
          inc(Size, 4);
        end;

        // Check for next ID3 Frames ?
        Continue;
      end;

      //Check for proper frame header
      if ((Header[0] and $FF) <> $FF) or ((Header[1] and $E0) <> $E0) then
      Break;

      MP3FrameLength:=0;
      case (Header[1] and $18) of
        $08: Break; // Reserved
        $00, $10: // MPEG Version 2.5, MPEG Version 2.0
        begin
          case (Header[1] and $18) of
            $00: // MPEG Version 2.5
            begin
              case (Header[2] and $0C) of
                0: MP3SampleRate := 11025;
                4: MP3SampleRate := 12000;
                8: MP3SampleRate := 8000;
                else Break;
              end;
            end;
            $10: // MPEG Version 2.0
            begin
              case (Header[2] and $0C) of
                0: MP3SampleRate := 22050;
                4: MP3SampleRate := 24000;
                8: MP3SampleRate := 16000;
                else Break;
              end;
            end;
          end;

          case (Header[1] and $06) of
            $00: Exit; // Reserved
            $02, $04: // Layer III // Layer II
            begin
              MP3BitRate:=MPEGV20BitTable[0][((Header[2] and $F0) shr 4)];
              case (Header[1] and $02) of
                $00: MP3FrameLength := (72000 * MP3BitRate) div MP3SampleRate;
                $02: MP3FrameLength := (72000 * MP3BitRate) div MP3SampleRate + 1;
                else Break;
              end; // End of Case Padding
            end;
            $06: // Layer I
            begin
              MP3BitRate:=MPEGV20BitTable[2][((Header[2] and $F0) shr 4)];
              case (Header[0] and $02) of
                $00: MP3FrameLength := ((12000 * MP3BitRate) div MP3SampleRate)*4;
                $02: MP3FrameLength := ((12000 * MP3BitRate) div MP3SampleRate + 1)*4;
                else Break;
              end; // End of Case Padding
            end;
          end;
        end;
        $18: //MPEG Version 1.0
        begin
          case (Header[2] and $0C) of
            0: MP3SampleRate := 44100;
            4: MP3SampleRate := 48000;
            8: MP3SampleRate := 32000;
            else Break;
          end;

          case (Header[1] and $06) of
            $00: Exit; // Reserved
            $02: // Layer III
            begin
              //MP3BitRate:=MPEGV10BitTable[0][((DWORD(Header) shr $0C) and  $0F)];
              MP3BitRate:=MPEGV10BitTable[0][((Header[2] and $F0) shr 4)];
              case (Header[2] and $02) of
                $00: MP3FrameLength := (144000 * MP3BitRate) div MP3SampleRate;
                $02: MP3FrameLength := (144000 * MP3BitRate) div MP3SampleRate + 1;
                else Break;
              end; // End of Case Padding
            end;
            $04: // Layer II
            begin
              MP3BitRate:=MPEGV10BitTable[1][((Header[2] and $F0) shr 4)];
              case (Header[2] and $02) of
                $00: MP3FrameLength := (144000 * MP3BitRate) div MP3SampleRate;
                $02: MP3FrameLength := (144000 * MP3BitRate) div MP3SampleRate + 1;
                else Break;
              end; // End of Case Padding
            end;
            $06: // Layer I
            begin
              MP3BitRate:=MPEGV10BitTable[2][((Header[2] and $F0) shr 4)];
              case (Header[2] and $02) of
                $00: MP3FrameLength := ((12000 * MP3BitRate) div MP3SampleRate)*4;
                $02: MP3FrameLength := ((12000 * MP3BitRate) div MP3SampleRate + 1)*4;
                else Break;
              end; // End of Case Padding
            end;
          end;
        end;
      end;

      case MP3FrameLength <> 0 of
        True:
        begin
          if (Header[2] and 1)=1 then
          inc(Size, 4);

          inc(MP3FrameCount);
          inc(Size, MP3FrameLength); // 4 = Header size
        end;
        False: Break;
      end;
    end;  // while not end of file

    if MP3FrameCount > 0 then
    begin
      Result:=True;
      //dec(Size, MP3FrameCount*4);
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
*)
function SearchSWF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
//http://www.half-serious.com/swf/format/index.html#header
const
  MARKER_SWF = DWORD(Byte('F') or (Byte('W') shl 8) or (Byte('S') shl 16) or ($05 shl 24));

type
  TSWFHeader = Packed Record
    Marker:DWORD;
    FileSize:DWORD;
  end;

var
  Header:TSWFHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TSWFHeader));

    if Header.Marker = MARKER_SWF then
    begin
      if not IsRealFileSize(FileData, Offset, Header.FileSize) then
      Exit;

      Size:=Header.FileSize;
      Result:=@FORMAT_TYPE_SWF;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchSMK(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
//http://wiki.multimedia.cx/index.php?title=SMK
const
  MARKER_SMK = DWORD(Byte('S') or (Byte('M') shl 8) or (Byte('K') shl 16) or (Byte('4') shl 24));
type
  TSMKHeader = Packed Record
    Marker:DWORD;
    Width:DWORD;
    Height:DWORD;
    Frames:DWORD;
    FrameRate:DWORD;
    Flags:DWORD;
    AudioSize:Array[0..6] of DWORD;
    TreesSize:DWORD;
    MMap_Size:DWORD;
    MClr_Size:DWORD;
    Full_Size:DWORD;
    Type_Size:DWORD;
    AudioRate:Array[0..6] of DWORD;
    Dummy:DWORD;
  end;

var
  Header:TSMKHeader;
  FrameIndex:DWORD;
  FrameSize:DWORD;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TSMKHeader));

    if Header.Marker = MARKER_SMK then
    begin
      //Size:=0;
      //for n := 0 to 7 - 1 do // 7 = length of AudioSize
      //inc(Size, Header.AudioSize[n]);
      //Size:=SizeOf(TSMKHeader);
      //TODO : Test on more files, add version 2 support
      Size:=Header.Frames shl 2;
      Inc(Size, SizeOf(TSMKHeader));
      Inc(Size, Header.Frames - 1); // TODO: Why -1 ? Because size was always +1 than original
      Inc(Size, Header.TreesSize);

      if not IsRealFileSize(FileData, Offset, Size) then
      Exit;

      FileSeek(FileData, Offset + SizeOf(TSMKHeader));
      for FrameIndex := 0 to Header.Frames - 1 do
      begin
        FileRead(FileData, FrameSize, SizeOf(DWORD));
        Inc(Size, FrameSize and $FCFFFFFF); //$FFFFFFFC);
      end;
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_SMK;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
(*
///////////////////////////////////////
function SearchPE(const FileData:PFileData; var Offset:DWORD; var Size:DWORD; var Format:TFormatType):boolean;
//http://bbs.pediy.com/upload/bbs/unpackfaq/ARTeam%20PE_appendix1_offsets.htm#imchar
var
  DOSHeader:IMAGE_DOS_HEADER; // dos header
  PEHeader:IMAGE_NT_HEADERS; // pe header

  SecHeader:IMAGE_SECTION_HEADER; // section tables
  n:Word;
begin
  Result:=False;
  try

    FileSeek(FileData, Offset);
    FileRead(FileData, DOSHeader, SizeOf(IMAGE_DOS_HEADER));

    if DOSHeader.e_magic <> ffMZID then
    Exit;

    FileSeek(FileData, Offset+DosHeader.e_lfanew);
    FileRead(FileData, PEHeader, SizeOf(IMAGE_NT_HEADERS));
    if PEHeader.Signature<> ffPEID then
    Exit;

    if (PEHeader.FileHeader.Characteristics and $0002) > 0 then
    Format:=FORMAT_TYPE_EXE
      else
    if (PEHeader.FileHeader.Characteristics and $2000) > 0 then
    Format:=FORMAT_TYPE_DLL
      else
    Exit;

    Size:=PEHeader.OptionalHeader.SizeOfHeaders;
    //for n := 0 to PEHeader.OptionalHeader.NumberOfRvaAndSizes - 1 do
    //Inc(Size, PEHeader.OptionalHeader.DataDirectory[n].Size);

    // Security Table saved at end of file
    inc(Size, PEHeader.OptionalHeader.DataDirectory[4].Size);

    for n := 0 to PEHeader.FileHeader.NumberOfSections - 1 do
    begin
      FileRead(FileData, SecHeader, SizeOf(IMAGE_SECTION_HEADER));
      inc(Size, SecHeader.SizeOfRawData);
      //Inc(Size, PEHeader.OptionalHeader.DataDirectory[n].Size);

    end;
    Result:=True;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
*)
///////////////////////////////////////
function SearchSWS(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_CTRL = DWORD(Byte('C') or (Byte('T') shl 8) or (Byte('R') shl 16) or (Byte('L') shl 24));
  MARKER_FILM = DWORD(Byte('F') or (Byte('I') shl 8) or (Byte('L') shl 16) or (Byte('M') shl 24));
  MARKER_SNDS = DWORD(Byte('S') or (Byte('N') shl 8) or (Byte('D') shl 16) or (Byte('S') shl 24));
  MARKER_FILL = DWORD(Byte('F') or (Byte('I') shl 8) or (Byte('L') shl 16) or (Byte('L') shl 24));

  MarkerCount = 4;
  MarkerTable : Array[0..MarkerCount-1] of DWORD = (
    MARKER_CTRL, MARKER_FILM, MARKER_SNDS, MARKER_FILL
  );

type
  TSWSSegment = Packed Record
    Marker:DWORD;
    Size:DWORD;
  end;

var
  Segment:TSWSSegment;
  IsProper:Boolean;
  MarkerIndex:DWORD;
begin
  Result:=nil;
  Size:=0;
  try
    while (not FileData^.IsFileEnd) do
    begin
      if not IsRealFileSize(FileData, Offset, Size) then
      Exit;
      
      FileSeek(FileData, Offset + Size);
      FileRead(FileData, Segment, SizeOf(TSWSSegment));

      if Segment.Size = 0 then
      Exit;

      IsProper:=False;
      for MarkerIndex := 0 to MarkerCount - 1 do
      begin
        if MarkerTable[MarkerIndex] = Segment.Marker then
        begin
          Inc(Size, SwapLong(Segment.Size));
          IsProper:=True;
          Break;
        end;
      end;
      if (not IsProper) then
      Break;
    end; //while
    if IsRealFileSize(FileData, Offset, Size) then
    Result:=@FORMAT_TYPE_SWS;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchSIFF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_SIFF = DWORD(Byte('S') or (Byte('I') shl 8) or (Byte('F') shl 16) or (Byte('F') shl 24));
  MARKER_VBV1 = DWORD(Byte('V') or (Byte('B') shl 8) or (Byte('V') shl 16) or (Byte('1') shl 24));

type
  TSIFFHeader = Packed Record
    Marker:DWORD;
    Size:DWORD;
    Version:DWORD;
  end;

var
  Header:TSIFFHeader;

begin
  Result:=nil;
  Size:=0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TSIFFHeader));

    if (Header.Marker = MARKER_SIFF) and (Header.Version = MARKER_VBV1) then
    begin
      Size:=SwapLong(Header.Size) + 8;
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_SIFF;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchFLV(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_FLV = DWORD(Byte('F') or (Byte('L') shl 8) or (Byte('V') shl 16) or ($01 shl 24));
  FLV_TAG_TYPE_AUDIO = $08;
  FLV_TAG_TYPE_VIDEO = $09;
  FLV_TAG_TYPE_META =  $12;

type
  TFLVHeader = Packed Record
    Marker:DWORD;
    Flags:Byte;
    DataOffset:DWORD;
    //dwReserved:DWORD;
  end;

  TFLVFrame = Packed REcord
    FrameType:Byte;
    DataSize:Array[0..2] of BYTE; // dumbass unsigned integer 24 bit
    TimeStamp:DWORD;
    StreamID:Array[0..2] of BYTE; // Always 0
    //wReserved:WORD;
  end;

var
  Header:TFLVHeader;
  Frame:TFLVFrame;
  FrameSize:DWORD;

begin
  Result:=nil;
  Size:=0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TFLVHeader));

    Size:=SwapLong(Header.DataOffset) + 4;  // Skip previous frame size
    if not IsRealFileSize(FileData, Offset, Size) then
    Exit;


    while (not FileData^.IsFileEnd) do
    begin
      FileSeek(FileData, Offset + Size);
      //TODO : Fix FLV filesize determination
      FileRead(FileData, Frame, SizeOf(TFLVFrame));
      if (Frame.FrameType < FLV_TAG_TYPE_AUDIO) or (Frame.FrameType > FLV_TAG_TYPE_META) then
      Break;
      Inc(Size, SizeOf(TFLVFrame));
      // Convert 24 bit integer to 32 bit and convert value to little endian
      FrameSize:=DWORD((Frame.DataSize[0] shl 16) or (Frame.DataSize[1] shl 8) or (Frame.DataSize[2]));
      // Skip previous frame size
      Inc(Size, FrameSize + 4);
    end;
    if IsRealFileSize(FileData, Offset, Size) then
    Result:=@FORMAT_TYPE_FLV;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchRMF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
//http://wiki.multimedia.cx/index.php?title=RealMedia
const
  MARKER_RMF = DWORD($2E or (Byte('R') shl 8) or (Byte('M') shl 16) or (Byte('F') shl 24));
  MARKER_PROP = DWORD(Byte('P') or (Byte('R') shl 8) or (Byte('O') shl 16) or (Byte('P') shl 24));
  MARKER_MDPR = DWORD(Byte('M') or (Byte('D') shl 8) or (Byte('P') shl 16) or (Byte('R') shl 24));
  MARKER_CONT = DWORD(Byte('C') or (Byte('O') shl 8) or (Byte('N') shl 16) or (Byte('T') shl 24));
  MARKER_DATA = DWORD(Byte('D') or (Byte('A') shl 8) or (Byte('T') shl 16) or (Byte('A') shl 24));
  MARKER_INDX = DWORD(Byte('I') or (Byte('N') shl 8) or (Byte('D') shl 16) or (Byte('X') shl 24));

  MarkerCount = 6;
  MarkerTable : Array[0..MarkerCount-1] of DWORD = (
    MARKER_RMF, MARKER_PROP, MARKER_MDPR, MARKER_CONT,
    MARKER_DATA, MARKER_INDX
  );

type
  TRMFSegment = Packed Record
    Marker:DWORD;
    Size:DWORD;
    //ChunkVersion:WORD;
    //FileVersion:DWORD;
    //HeaderCount:DWORD;
  end;

var
  Segment:TRMFSegment;
  IsProper:Boolean;
  MarkerIndex:DWORD;

begin
  Result:=nil;
  Size:= 0;
  try
    while (not FileData^.IsFileEnd) do
    begin
      if not IsRealFileSize(FileData, Offset, Size) then
      Exit;

      FileSeek(FileData, Offset + Size);
      FileRead(FileData, Segment, SizeOf(TRMFSegment));

      IsProper:=False;
      for MarkerIndex := 0 to MarkerCount - 1 do
      begin
        if MarkerTable[MarkerIndex] = Segment.Marker then
        begin
          Inc(Size, SwapLong(Segment.Size));
          IsProper:=True;
          Break;
        end;
      end;
      if (not IsProper) then
      Break;
    end; //while
    if IsRealFileSize(FileData, Offset, Size) then
    Result:=@FORMAT_TYPE_RMF;
  except
    ReportError(FileData, Offset, Size);
  end;
end;

///////////////////////////////////////
function SearchASF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_ASF = DWORD($30 or ($26 shl 8) or ($B2 shl 16) or ($75 shl 24));
type
  TASFHeader = Packed Record
    Marker:DWORD;
    HeaderID:Array[0..11] of Byte;
    Size:Int64;
    ObjectCount:DWORD;
    Reserved:Array[0..1] of Byte;
  end;

  TASFMarker = Array[0..15] of Byte;

  TASFObject = Packed Record
    ObjectID:TASFMarker;
    ObjectSize:Int64;
  end;

const
  // File properties Object
  ASFFilePropID : TASFMarker = ($A1, $DC, $AB, $8C, $47, $A9, $CF, $11, $8E, $E4, $00, $C0, $0C, $20, $53, $65);
var
  ASFHeader:TASFHeader;
  ASFObject:TASFObject;
  ObjectIndex, Index:DWORD;
begin
  Result:= nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, ASFHeader, SizeOf(TASFHeader));
    // Check reserved value for sure (always set to 1)...
    if (ASFHeader.Marker = MARKER_ASF) and (ASFHeader.Reserved[0] = $01) then
    begin
      Size:=SizeOf(TASFHeader);
      for ObjectIndex := 0 to ASFHeader.ObjectCount - 1 do
      begin
        if not IsRealFileSize(FileData, Offset, Size) then
        Exit;
        
        FileSeek(FileData, Offset + Size);
        FileRead(FileData, ASFObject, SizeOf(TASFObject));
        for Index := 0 to SizeOf(TASFMarker) - 1 do
        begin
          if ASFObject.ObjectID[Index] <> ASFFilePropID[Index] then
          Break;
          if Index = SizeOf(TASFMarker) - 1 then
          begin
            FileSeek(FileData, Offset + Size + SizeOf(TASFObject) + SizeOf(TASFMarker));
            FileRead(FileData, Size, SizeOf(DWORD));
            if IsRealFileSize(FileData, Offset, Size) then
            Result:=@FORMAT_TYPE_ASF;
            Exit;
          end;
        end;
        Inc(Size, ASFObject.ObjectSize);
      end; // for
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
//http://wiki.multimedia.cx/index.php?title=Au
function SearchSND(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_SND = DWORD($2E or (Byte('s') shl 8) or (Byte('n') shl 16) or (Byte('d') shl 24));

type
  TSNDHeader = Packed Record
    Marker:DWORD;
    DataStart:DWORD;
    DataSize:DWORD;
    SampleFormat:DWORD;
    SampleRate:DWORD;
    Channels:DWORD;
  end;

var
  Header:TSNDHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TSNDHeader));

    if (Header.Marker <> MARKER_SND) and (Header.DataSize = 0) then
    Exit;

    if (Header.SampleFormat = 0) or (Header.SampleFormat > 27) then
    Exit;

    Size:=SwapLong(Header.DataStart) + SwapLong(Header.DataSize);

    if IsRealFileSize(FileData, Offset, Size) then
    Result:=@FORMAT_TYPE_SND;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
(*
function Search3DS(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
var
  Chunk:T3DSChunk;
begin
  Result:=False;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Chunk, SizeOf(T3DSChunk));
     //TODO : Test on more files
    if (Chunk.Marker = ff3DSID) and (Chunk.Size > 0) then
    begin
      Size:=Chunk.Size;
      FileRead(FileData, Chunk, SizeOf(T3DSChunk));
      Result:=(Chunk.Marker = $02) and (Chunk.Size = $0A);
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
*)
///////////////////////////////////////
function SearchWVPK(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_WVPK = DWORD(Byte('w') or (Byte('v') shl 8) or (Byte('p') shl 16) or (Byte('k') shl 24));

type
  TWVPKChunk = Packed Record
    Marker:DWORD;
    Size:DWORD;
  end;

var
  Chunk:TWVPKChunk;

begin
  Result:=nil;
  Size:= 0;
  try
    while (not FileData^.IsFileEnd) do
    begin
      if not IsRealFileSize(FileData, Offset, Size) then
      Exit;

      FileSeek(FileData, Offset + Size);
      FileRead(FileData, Chunk, SizeOf(TWVPKChunk));
      if Chunk.Marker <> MARKER_WVPK then
      Break;
      Inc(Size, SizeOf(TWVPKChunk) + Chunk.Size);
    end;
    if IsRealFileSize(FileData, Offset, Size) then
    Result:=@FORMAT_TYPE_WVPK;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchRAF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_RAF = DWORD($2E or (Byte('r') shl 8) or (Byte('a') shl 16) or ($FD shl 24));

type
  TRAFHeader = Packed Record
    Marker:DWORD;
    Version:WORD;
  end;

var
  Header:TRAFHeader;
  HeaderSize:Word;
  DataSize:DWORD;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset + Size);
    FileRead(FileData, Header, SizeOf(TRAFHeader));
    if Header.Marker <> MARKER_RAF then
    Exit;

    Header.Version:=SwapShort(Header.Version);
    if (Header.Version < $03) or (Header.Version > $04) then
    Exit;
    case Header.Version of
      $03:
      begin
        FileSeek(FileData, Offset + 6);
        FileRead(FileData, HeaderSize, SizeOf(Word));
        HeaderSize:=SwapShort(HeaderSize) + 8;
      end;
      $04:HeaderSize:=40; // TODO: how to get header size for version 4 ?
    end;

    case Header.Version of
      $03:FileSeek(FileData, Offset + 18);
      $04:FileSeek(FileData, Offset + 12);
    end;
    FileRead(FileData, DataSize, SizeOf(DWORD));
    //DataSize:=SwapLong(DataSize);
    Size:=SwapLong(DataSize)+HeaderSize;
    if IsRealFileSize(FileData, Offset, Size) then
    Result:=@FORMAT_TYPE_RAF;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchXBG2(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_XBG2 = DWORD(Byte('X') or (Byte('B') shl 8) or (Byte('G') shl 16) or ($02 shl 24));
type
  TXBGHeader = Packed Record
    Marker:DWORD; // A file-type identifier
    SysMemSize:DWORD;        // Num system memory bytes req'd
    VidMemSize:DWORD;        // Num videro memorty bytes req'd
    FrameCount:DWORD;     // Num of frames in the file
  end;

var
  Header:TXBGHeader;

begin
  Result:=nil;
  Size:=0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TXBGHeader));
     //TODO : Header.NumMeshFrames might have more than 16 frames ?
    if (Header.Marker = MARKER_XBG2) and (Header.FrameCount > 0) then
    begin
      Size:=SizeOf(TXBGHeader) + Header.SysMemSize+Header.VidMemSize;
      if IsRealFileSize(FileData, Offset, Size) then
      Result:= @FORMAT_TYPE_XBG2;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchXPR0(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_XPR0 = DWORD(Byte('X') or (Byte('P') shl 8) or (Byte('R') shl 16) or (Byte('0') shl 24));

type
  TXPR0Header = Packed Record
    Marker:DWORD;
    TotalSize:DWORD;
    HeaderSize:DWORD;
  end;

var
  Header:TXPR0Header;

begin
  Result:= nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset); // Real offset of file is not on Marker found pos
    FileRead(FileData, Header, SizeOf(TXPR0Header));
     //TODO : Is Header size always mul 2048 ?
    if (Header.Marker = MARKER_XPR0) and ((Header.HeaderSize mod 2048) = 0) then
    begin
      Size:=Header.TotalSize;
      if IsRealFileSize(FileData, Offset, Size) then
      Result:= @FORMAT_TYPE_XPR0;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchXPR2(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_XPR2 = DWORD(Byte('X') or (Byte('P') shl 8) or (Byte('R') shl 16) or (Byte('2') shl 24));

type
  TXPR2Header = Packed Record
    Marker: DWORD;
    HeaderSize: DWORD;
    DataSize: DWORD;
  end;

var
  Header:TXPR2Header;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TXPR2Header));
    //TODO : Is Header size always mul 2048 ?
    if (Header.Marker = MARKER_XPR2) and ((SwapLong(Header.HeaderSize) mod 2048) = 0) then
    begin
      Size:=SizeOf(TXPR2Header) + SwapLong(Header.HeaderSize) + SwapLong(Header.DataSize);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:= @FORMAT_TYPE_XPR2;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchXMV(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_XMV = DWORD(Byte('x') or (Byte('o') shl 8) or (Byte('b') shl 16) or (Byte('X') shl 24));

type
  TXMVVideoHeader = Packed Record
    Marker:DWORD;
    FileType:DWORD; // 0 = ASF ; 1 = XMV ; 2 = WAV ; 3 = AVI
    Width:DWORD;
    Height:DWORD;
    Duration:DWORD;
    AudioStreamCount:DWORD;
  end;

  TXMVAudioHeader = Packed Record
    WaveFormat:WORD; // ???
    ChannelCount:WORD;
    SamplesPerSec:DWORD;
    BitsPerSample:WORD;
    Flags:WORD; // 1 = "5.1 ADPCM front left-right channels"
                // 2 = "5.1 ADPCM center and low frequency channels"
                // 4 = "5.1 ADPCM rear left-right channels"
  end;

  TXMVFrameHeader = Packed Record
    Unknown1:WORD;
    Unknown2:WORD;
    FrameSize:WORD; // (FrameSize * 4) + 4
    Unknown:WORD;
  end;

var
  VideoHeader:TXMVVideoHeader;
  AudioHeader:TXMVAudioHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    //TODO: Not finished ?
    //FileSeek(FileData, Offset-12); // Real offset of file is not on Marker found pos
    FileSeek(FileData, Offset);
    FileRead(FileData, VideoHeader, SizeOf(TXMVVideoHeader));

    if (VideoHeader.Marker = MARKER_XMV) and (VideoHeader.FileType < 4) then
    begin
      Size:=SizeOf(TXMVVideoHeader);
      if VideoHeader.AudioStreamCount > 0 then
      Inc(Size, VideoHeader.AudioStreamCount * SizeOf(TXMVAudioHeader));
      //FileSeek(FileData, Offset + Size);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_XMV;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchCAB(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_MSCF = DWORD(Byte('M') or (Byte('S') shl 8) or (Byte('C') shl 16) or (Byte('F') shl 24));

type
  TCABHeader = Packed Record
    Marker:DWORD;              // file signature 'MSCF' (CAB_SIGNATURE)
    HeaderCRC:DWORD;       // header checksum (0 if not used)
    CabinetSize:DWORD;        // cabinet file size
    FolderCRC:DWORD;      // folders checksum (0 if not used)
    EntryOffset:DWORD;        // offset of first CAB_ENTRY
    FileCRC:DWORD;        // files checksum (0 if not used)
    Version:WORD;         // cabinet version (CAB_VERSION)
    FolderCount:WORD;         // number of folders
    FileCount:WORD;           // number of files
    Flags:WORD;            // cabinet flags (CAB_FLAG_*)
    CabSetID:WORD;           // cabinet set id
    Reserved:WORD;         // zero-based cabinet number
  end;

var
  Header:TCABHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TCABHeader));

    if (Header.Marker = MARKER_MSCF) and (Header.FileCount > 0) then
    begin
      Size:=Header.CabinetSize;
      if IsRealFileSize(FileData, Offset, Size) then
      Result:= @FORMAT_TYPE_CAB;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchXNB(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_XNB = DWORD(Byte('X') or (Byte('N') shl 8) or (Byte('B') shl 16) or (Byte('w') shl 24));

type
  TXNBHeader = Packed Record
    Marker:DWORD;
    Version:WORD;
    FileSize:DWORD;
    Unk:BYTE;
    ComSize:BYTE; // comment size
  end;

var
  Header:TXNBHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TXNBHeader));
     //TODO : Found more info about available versions
    if (Header.Marker = MARKER_XNB) and (Header.Version <= 6) then
    begin
      Size:=Header.FileSize;
      if IsRealFileSize(FileData, Offset, Size) then
      Result:= @FORMAT_TYPE_XNB;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchWAD2(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_WAD2 = DWORD(Byte('W') or (Byte('A') shl 8) or (Byte('D') shl 16) or (Byte('2') shl 24));

type
  TWAD2Header = Packed Record
    Marker:DWORD;
    TextureCount:DWORD;
    DataSize:DWORD;
  end;

var
  Header:TWAD2Header;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TWAD2Header));

    if (Header.Marker = MARKER_WAD2) and (Header.TextureCount > 0) then
    begin
      Size:=(Header.TextureCount * 32) + Header.DataSize;
      if IsRealFileSize(FileData, Offset, Size) then
      Result:= @FORMAT_TYPE_WAD2;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchMDL7(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_MDL7 = DWORD(Byte('M') or (Byte('D') shl 8) or (Byte('L') shl 16) or (Byte('7') shl 24));

type
  TMDL7Header = Packed Record
    Marker:DWORD;
    Version:DWORD; // ?
    Unknown:DWORD;
    MeshCount:DWORD; // ?
    FileSize:DWORD;
  end;

var
  Header:TMDL7Header;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TMDL7Header));

    if (Header.Marker = MARKER_MDL7) and (Header.Version <= 1) then // Actually "version" which I found was always 0
    begin
      Size:=Header.FileSize;
      if IsRealFileSize(FileData, Offset, Size) then
      Result:= @FORMAT_TYPE_MDL7;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchPSMF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_PSMF = DWORD(Byte('P') or (Byte('S') shl 8) or (Byte('M') shl 16) or (Byte('F') shl 24));

type
  TPSMFHeader = Packed Record
    Marker:DWORD;
    Version:WORD; // ?
    Unknown:DWORD;
    HeaderCount:WORD; // ?
    DataSize:DWORD;
  end;

var
  Header:TPSMFHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TPSMFHeader));

    if (Header.Marker = MARKER_PSMF) and (Header.Version > 0) then // Actually "version" which I found was always 0
    begin
      Size:=Header.HeaderCount * 256;
      Inc(Size, SwapLong(Header.DataSize));
      if IsRealFileSize(FileData, Offset, Size) then
      Result:= @FORMAT_TYPE_PSMF;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
(*
function SearchFLX(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
var
  Header:TFLXHeader;
begin
  Result:=False;
  try
    Offset:=Offset-4;
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TFLXHeader));
     //TODO :

    case Header.FileType of
      ffFLIID: Format:=FORMAT_TYPE_FLI;
      ffFLCID: Format:=FORMAT_TYPE_FLC;
      ffFLXID: Format:=FORMAT_TYPE_FLX;
      else Exit;
    end;

    if (Header.FileSize = 0) or (Header.FrameCount = 0) then
    Exit;

    if (Header.FrameWidth = 0) or (Header.FrameWidth > High(Smallint)) then
    Exit;

    if (Header.FrameHeight = 0) or (Header.FrameHeight > High(Smallint)) then
    Exit;

    if (Header.FrameDepth < 8) or (Header.FrameDepth > 32) then
    Exit;

    Size:=Header.FileSize;
    Result:=True;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
*)
///////////////////////////////////////
function SearchTTA(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_TTA = DWORD(Byte('T') or (Byte('T') shl 8) or (Byte('A') shl 16) or (Byte('1') shl 24));

type
  TTTAHeader = Packed Record
    Marker:DWORD;
    AudioFormat:WORD;
    ChannelCount:WORD;
    SampleSize:WORD;
    SampleRate:DWORD;
    DataSize:DWORD;
    CheckSum:DWORD;
  end;

var
  Header:TTTAHeader;
  FrameSize:DWORD;
  FrameCount:DWORD;
  FrameIndex:DWORD;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TTTAHeader));

    if (Header.Marker = MARKER_TTA) and (Header.ChannelCount <= 6) then // Actually "version" which I found was always 0
    begin
      FrameSize:=Round(Header.SampleRate * 1.04489795918367346939);
      FrameCount:= Header.DataSize div FrameSize;
      if (Header.DataSize mod FrameSize) > 0 then
      Inc(FrameCount);

      Size:=SizeOf(TTTAHeader) + (FrameCount * SizeOf(DWORD)) + SizeOf(DWORD); // Header size + Seek table size + Checksum size placed after seek sample
      for FrameIndex:=0 to FrameCount - 1 do
      begin
        FileRead(FileData, FrameSize, SizeOf(DWORD));
        Inc(Size, FrameSize);
      end;
      if IsRealFileSize(FileData, Offset, Size) then
      Result:= @FORMAT_TYPE_TTA;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchOFR(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_OFR = DWORD(Byte('O') or (Byte('F') shl 8) or (Byte('R') shl 16) or (Byte(' ') shl 24));
  MARKER_TAIL = DWORD(Byte('T') or (Byte('A') shl 8) or (Byte('I') shl 16) or (Byte('L') shl 24));
type
  TOFRHeader = Packed Record
    Marker:DWORD;
    HeaderSize:DWORD;
    SampleCount:Array[0..5] of BYTE;
    SampleType:BYTE;
    ChannelCount:BYTE;
    SampleRate:DWORD;
    EncoderID:WORD;
    CompressType:BYTE;
  end;

  TRIFFChunk = Packed Record
    Marker:DWORD;
    Size:DWORD;
  end;

var
  Header:TOFRHeader;
  Chunk:TRIFFChunk;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TOFRHeader));

    if (Header.Marker = MARKER_OFR) and (Header.HeaderSize >= 15) then // Actually "version" which I found was always 0
    begin
      Size:=SizeOf(TRIFFChunk) + Header.HeaderSize; // Skip any extra bytes

      while (not FileData^.IsFileEnd) do
      begin
        if not IsRealFileSize(FileData, Offset, Size) then
        Exit;

        FileSeek(FileData, Offset + Size);
        FileRead(FileData, Chunk, SizeOf(TRIFFChunk));
        //TODO: Maybe use marker checking ?
        Inc(Size, Chunk.Size + SizeOf(TRIFFChunk));
        if Chunk.Marker = MARKER_TAIL then
        begin
          if IsRealFileSize(FileData, Offset, Size) then
          Result:= @FORMAT_TYPE_OFR;
          Exit;
        end;
      end;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
(*
function SearchLA(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  LABlockSize = 1167360; // 61440 * 19 (BlockSize * SeekEvery)
var
  Chunk:TRIFFChunk;
  StreamInfo:TLAStreamInfo;
  ChunkIndex:DWORD;
  ChunkCount:DWORD;  // aka Seek Points
  ChunkSize:DWORD;
begin
  Result:=False;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Chunk, SizeOf(TRIFFChunk));
    // TODO: Find unknown values in header ?  Add high compression support
    if (Chunk.Marker = ffLAID) and (Chunk.Size > 0) then
    begin
      Size:=SizeOf(TRIFFChunk);
      FileRead(FileData, Chunk, SizeOf(TRIFFChunk)); // WAVE
      if Chunk.Marker = FORMAT_TYPE_WAV0EID then
      inc(Size, Chunk.Size+SizeOf(TRIFFChunk));

      FileSeek(FileData, Offset+Size);
      FileRead(FileData, StreamInfo, SizeOf(TLAStreamInfo));
      if StreamInfo.StreamFlags <> 1 then
      Exit; // Only "normal" files supported

      inc(Size, SizeOf(TLAStreamInfo));

      ChunkCount:=StreamInfo.SampleCount div LABlockSize;
      if (StreamInfo.SampleCount mod LABlockSize) > 0 then
      inc(ChunkCount);

      inc(Size, (ChunkCount-1)*SizeOf(DWORD));
      FileSeek(FileData, Offset+Size);

      // Last seek point is always pointing to end of file
      FileRead(FileData, ChunkSize, SizeOf(DWORD));
      Size:=ChunkSize;

      Result:= Size > 0;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
*)
///////////////////////////////////////
function SearchLPAC(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_LPAC = DWORD(Byte('L') or (Byte('P') shl 8) or (Byte('A') shl 16) or (Byte('C') shl 24));

type
  TLPACHeader = Packed Record
    Marker:DWORD;
    Version:BYTE;
    AudioType:BYTE;
    SampleCount:DWORD;
    AudioFlags:DWORD;
  end;

var
  Header:TLPACHeader;
  BlockSize:DWORD;
  Exponent:DWORD;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TLPACHeader));
    // TODO: Tested only version 6, test all version if its working
    if (Header.Marker = MARKER_LPAC) and (Header.Version <= 12) then // Actually "version" which I found was always 0
    begin
      Exponent:=(Header.AudioFlags and $07000000) shr 24;
      // power (2, dwExponent)
      BlockSize:=1;
      while Exponent > 0 do
      begin
        BlockSize:=BlockSize * 2;
        Dec(Exponent);
      end;
      BlockSize:=BlockSize * 256;
      Size:=Header.SampleCount div BlockSize;
      if IsRealFileSize(FileData, Offset, Size) then
      Result:= @FORMAT_TYPE_LPAC;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchVQF(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_TWIN = DWORD(Byte('T') or (Byte('W') shl 8) or (Byte('I') shl 16) or (Byte('N') shl 24));
  MARKER_DSIZ = DWORD(Byte('D') or (Byte('S') shl 8) or (Byte('I') shl 16) or (Byte('Z') shl 24));

type
  TVQFHeader = Packed Record
    Marker:DWORD;
    Version:DWORD;
    Unknown:DWORD;
    HeaderSize:DWORD;
  end;

  TRIFFChunk = Packed Record
    Marker:DWORD;
    Size:DWORD;
  end;

var
  Header:TVQFHeader;
  Chunk:TRIFFChunk;
  SizeIn:DWORD;
  OffsetIn:DWORD;
  DataSize:DWORD;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(Filedata, Header, SizeOf(TVQFHeader));
    if (Header.Marker = MARKER_TWIN) and (Header.HeaderSize > 0) then
    begin
      Size:=SwapLong(Header.HeaderSize);  // Size is now maximum size to read where to search DSIZ marker
      SizeIn:=0;
      OffsetIn:=Offset + SizeOf(TVQFHeader);
      while SizeIn < Size do
      begin
        if not IsRealFileSize(FileData, Offset, SizeIn) then
        Exit;

        FileSeek(FileData, OffsetIn+SizeIn);
        FileRead(FileData, Chunk, SizeOf(TRIFFChunk));
        if Chunk.Marker = MARKER_DSIZ then
        begin
          //TODO: Chunk on more files
          FileRead(FileData, DataSize, SizeOf(DWORD));  // Read size of DATA marker
          Inc(Size, SizeOf(TVQFHeader));
          Inc(Size, SwapLong(DataSize));
          if IsRealFileSize(FileData, Offset, Size) then
          Result:= @FORMAT_TYPE_VQF;
          Exit;
        end;
        Inc(SizeIn, SizeOf(TRIFFChunk) + SwapLong(Chunk.Size));
      end;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchAVS(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_AVS = DWORD(Byte('w') or (Byte('W') shl 8) or ($10 shl 16) or ($00 shl 24));

type
  TAVSHeader = Packed Record
    Marker:DWORD;
    FrameWidth:WORD;
    FrameHeight:WORD;
    FrameDepth:WORD;
    FrameRate:WORD;
    FrameCount:DWORD;
  end;

  TAVSBlock = Packed Record
    BlockType:WORD;
    BlockSize:WORD;
  end;

var
  Header:TAVSHeader;
  Block:TAVSBlock;
  FrameIndex:DWORD;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TAVSHeader));

    if (Header.Marker = MARKER_AVS) and (Header.FrameCount > 0) then // Actually "version" which I found was always 0
    begin
      Size:=SizeOf(TAVSHeader);
      for FrameIndex := 0 to Header.FrameCount - 1 do
      begin
        if not IsRealFileSize(FileData, Offset, Size) then
        Exit;

        FileSeek(FileData, Offset+Size);
        FileRead(FileData, Block, SizeOf(TAVSBlock));
        if Block.BlockType = 0 then
        Break;

        Inc(Size, Block.BlockSize);
      end;
      Inc(Size, SizeOf(TAVSBlock)); // Empty frame at end (00000000)
      if IsRealFileSize(FileData, Offset, Size) then
      Result:= @FORMAT_TYPE_AVS;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchNSV(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_NSV = DWORD(Byte('N') or (Byte('S') shl 8) or (Byte('V') shl 16) or (Byte('f') shl 24));

type
  TNSVHeader = Packed Record
    Marker:DWORD;
    Size:DWORD;
    FileSize:DWORD;
    // Header is bigger but there is many unknown bytes
  end;

var
  Header:TNSVHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TNSVHeader));

    if (Header.Marker = MARKER_NSV) then // Actually "version" which I found was always 0
    begin
      Size:=Header.FileSize;
      if IsRealFileSize(FileData, Offset, Size) then
      Result:= @FORMAT_TYPE_NSV;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchPVA(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_PVA = DWORD(Byte('A') or (Byte('V') shl 8) or ($01 shl 16) or ($00 shl 24));
  MARKER_AV = WORD(Byte('A') or (Byte('V') shl 8));

type
  TAVPacket = Packed Record
    Marker:WORD;
    StreamID:BYTE;
    Counter:BYTE;
    Reserved:BYTE;
    Flags:BYTE;
    Size:WORD;
  end;

var
  Packet:TAVPacket;

begin
  Result:=nil;
  Size:= 0;
  try
    while (not FileData^.IsFileEnd) do
    begin
      if not IsRealFileSize(FileData, Offset, Size) then
      Exit;

      FileSeek(FileData, Offset + Size);
      FileRead(FileData, Packet, SizeOf(TAVPacket));
      if Packet.Marker <> MARKER_AV then
      Break;

      Inc(Size, SizeOf(TAVPacket) + SwapShort(Packet.Size));
    end;
    if IsRealFileSize(FileData, Offset, Size) then
    Result:=@FORMAT_TYPE_PVA;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchBRES(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_BRES = DWORD(Byte('b') or (Byte('r') shl 8) or (Byte('e') shl 16) or (Byte('s') shl 24));

type
  TBRESHeader = Packed Record
    Marker:DWORD;
    Format:DWORD;
    Size:DWORD;
  end;

var
  Header:TBRESHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TBRESHeader));
    if (Header.Marker = MARKER_BRES) and (Header.Size > 0) then
    begin
      Size:=SwapLong(Header.Size);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_BRES;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchREFT(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_REFT = DWORD(Byte('R') or (Byte('E') shl 8) or (Byte('F') shl 16) or (Byte('T') shl 24));

type
  TREFTHeader = Packed Record
    Marker:DWORD;
    Format:DWORD;
    Size:DWORD;
  end;

var
  Header:TREFTHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TREFTHeader));
    if (Header.Marker = MARKER_REFT) and (Header.Size > 0) then
    begin
      Size:=SwapLong(Header.Size);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_REFT;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchRFNA(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_RFNA = DWORD(Byte('R') or (Byte('F') shl 8) or (Byte('N') shl 16) or (Byte('A') shl 24));

type
  TRFNAHeader = Packed Record
    Marker:DWORD;
    Format:DWORD;
    Size:DWORD;
  end;

var
  Header:TRFNAHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TRFNAHeader));
    if (Header.Marker = MARKER_RFNA) and (Header.Size > 0) then
    begin
      Size:=SwapLong(Header.Size);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_RFNA;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchRFNT(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_RFNT = DWORD(Byte('R') or (Byte('F') shl 8) or (Byte('N') shl 16) or (Byte('T') shl 24));

type
  TRFNTHeader = Packed Record
    Marker:DWORD;
    Format:DWORD;
    Size:DWORD;
  end;

var
  Header:TRFNTHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TRFNTHeader));
    if (Header.Marker = MARKER_RFNT) and (Header.Size > 0) then
    begin
      Size:=SwapLong(Header.Size);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_RFNT;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchRSAR(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_RSAR = DWORD(Byte('R') or (Byte('S') shl 8) or (Byte('A') shl 16) or (Byte('R') shl 24));

type
  TRSARHeader = Packed Record
    Marker:DWORD;
    Format:DWORD;
    Size:DWORD;
  end;

var
  Header:TRSARHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TRSARHeader));
    if (Header.Marker = MARKER_RSAR) and (Header.Size > 0) then
    begin
      Size:=SwapLong(Header.Size);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_RSAR;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchRSTM(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_RSTM = DWORD(Byte('R') or (Byte('S') shl 8) or (Byte('T') shl 16) or (Byte('M') shl 24));

type
  TRSTMHeader = Packed Record
    Marker:DWORD;
    Format:DWORD;
    Size:DWORD;
  end;

var
  Header:TRSTMHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TRSTMHeader));
    if (Header.Marker = MARKER_RSTM) and (Header.Size > 0) then
    begin
      Size:=SwapLong(Header.Size);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_RSTM;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchGR2(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_GR2 = DWORD($B8 or ($67 shl 8) or ($B0 shl 16) or ($CA shl 24));

type
  TGR2Header = Packed Record
    Marker:DWORD;
    MarkerEx:Array[0..11] of Byte;
    HeaderSize:DWORD;
    Reserved:Array[0..11] of Byte;
  end;

  TGR2InfoHeader = Packed Record
    HeaderType:DWORD;
    FileSize:DWORD;
    CheckSum:DWORD;
    HeaderSize:DWORD;
    SectionCount:DWORD;
    FileRevision:DWORD;
    Unknown4:DWORD;
    Unknown5:DWORD;
    Unknown6:DWORD;
    FileTag:DWORD;
    Reserved:Array[0..15] of Byte;
  end;

var
  Header:TGR2Header;
  InfoHeader:TGR2InfoHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TGR2Header));
    if (Header.Marker = MARKER_GR2) and (Header.HeaderSize > 0) then
    begin
      FileRead(FileData, InfoHeader, SizeOf(TGR2InfoHeader));
      if InfoHeader.HeaderType = $06 then
      begin
        Size:=InfoHeader.FileSize;
        if IsRealFileSize(FileData, Offset, Size) then
        Result:= @FORMAT_TYPE_GR2;
      end;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchNCER(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_NCER = DWORD(Byte('R') or (Byte('E') shl 8) or (Byte('C') shl 16) or (Byte('N') shl 24));

type
  TNCERHeader = Packed Record
    Marker:DWORD;
    Format:DWORD;
    Size:DWORD;
  end;

var
  Header:TNCERHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TNCERHeader));
    if (Header.Marker = MARKER_NCER) and (Header.Size > 0) then
    begin
      Size:=SwapLong(Header.Size);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_NCER;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchNANR(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_NANR = DWORD(Byte('R') or (Byte('N') shl 8) or (Byte('A') shl 16) or (Byte('N') shl 24));

type
  TNANRHeader = Packed Record
    Marker:DWORD;
    Format:DWORD;
    Size:DWORD;
  end;

var
  Header:TNANRHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TNANRHeader));
    if (Header.Marker = MARKER_NANR) and (Header.Size > 0) then
    begin
      Size:=SwapLong(Header.Size);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_NANR;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchNCLR(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_NCLR = DWORD(Byte('R') or (Byte('L') shl 8) or (Byte('C') shl 16) or (Byte('N') shl 24));

type
  TNCLRHeader = Packed Record
    Marker:DWORD;
    Format:DWORD;
    Size:DWORD;
  end;

var
  Header:TNCLRHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TNCLRHeader));
    if (Header.Marker = MARKER_NCLR) and (Header.Size > 0) then
    begin
      Size:=SwapLong(Header.Size);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_NCLR;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchNARC(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_NARC = DWORD(Byte('N') or (Byte('A') shl 8) or (Byte('R') shl 16) or (Byte('C') shl 24));

type
  TNARCHeader = Packed Record
    Marker:DWORD;
    Format:DWORD;
    Size:DWORD;
  end;

var
  Header:TNARCHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TNARCHeader));
    if (Header.Marker = MARKER_NARC) and (Header.Size > 0) then
    begin
      Size:=SwapLong(Header.Size);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_NARC;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchSDAT(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_SDAT =  DWORD(Byte('S') or (Byte('D') shl 8) or (Byte('A') shl 16) or (Byte('T') shl 24));

type
  TSDATHeader = Packed Record
    Marker:DWORD;
    Format:DWORD;
    Size:DWORD;
  end;

var
  Header:TSDATHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TSDATHeader));
    if (Header.Marker = MARKER_SDAT) and (Header.Size > 0) then
    begin
      Size:=SwapLong(Header.Size);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_SDAT;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchSSEQ(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_SSEQ =  DWORD(Byte('S') or (Byte('S') shl 8) or (Byte('E') shl 16) or (Byte('Q') shl 24));

type
  TSSEQHeader = Packed Record
    Marker:DWORD;
    Format:DWORD;
    Size:DWORD;
  end;

var
  Header:TSSEQHeader;
begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TSSEQHeader));
    if (Header.Marker = MARKER_SSEQ) and (Header.Size > 0) then
    begin
      Size:=SwapLong(Header.Size);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_SSEQ;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchSSAR(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_SSAR =  DWORD(Byte('S') or (Byte('S') shl 8) or (Byte('A') shl 16) or (Byte('R') shl 24));

type
  TSSARHeader = Packed Record
    Marker:DWORD;
    Format:DWORD;
    Size:DWORD;
  end;

var
  Header:TSSARHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TSSARHeader));
    if (Header.Marker = MARKER_SSAR) and (Header.Size > 0) then
    begin
      Size:=SwapLong(Header.Size);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_SSAR;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchSWAR(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_SWAR =  DWORD(Byte('S') or (Byte('W') shl 8) or (Byte('A') shl 16) or (Byte('R') shl 24));

type
  TSWARHeader = Packed Record
    Marker:DWORD;
    Format:DWORD;
    Size:DWORD;
  end;

var
  Header:TSWARHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TSWARHeader));
    if (Header.Marker = MARKER_SWAR) and (Header.Size > 0) then
    begin
      Size:=SwapLong(Header.Size);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_SWAR;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchSBNK(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_SBNK =  DWORD(Byte('S') or (Byte('B') shl 8) or (Byte('N') shl 16) or (Byte('K') shl 24));

type
  TSBNKHeader = Packed Record
    Marker:DWORD;
    Format:DWORD;
    Size:DWORD;
  end;

var
  Header:TSBNKHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TSBNKHeader));
    if (Header.Marker = MARKER_SBNK) and (Header.Size > 0) then
    begin
      Size:=SwapLong(Header.Size);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_SBNK;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchTHP(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_THP = DWORD(Byte('T') or (Byte('H') shl 8) or (Byte('P') shl 16) or ($00 shl 24));

type
  TTHPHeader = Packed Record
    Marker:DWORD;
    Version:DWORD;
    MaxBufferSize:DWORD;
    AudioFrameRate:DWORD;
    VideoFrameRate:DWORD;
    FrameCount:DWORD;
    FirstFrameSize:DWORD;
    AllFrameSize:DWORD;
    ComponentTableOffset:DWORD;
    SeekTableOffset:DWORD;
    FirstFrameOffset:DWORD;
    LastFrameOffset:DWORD;
  end;

var
  Header:TTHPHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TTHPHeader));
    if (Header.Marker = MARKER_THP) and (Header.Version > 0) then
    begin
      Size:=SwapLong(Header.FirstFrameOffset) + SwapLong(Header.AllFrameSize);
      if IsRealFileSize(FileData, Offset, Size) then
      Result:=@FORMAT_TYPE_THP;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchFILM(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_FILM = DWORD(Byte('F') or (Byte('I') shl 8) or (Byte('L') shl 16) or (Byte('M') shl 24));
  MARKER_STAB = DWORD(Byte('S') or (Byte('T') shl 8) or (Byte('A') shl 16) or (Byte('B') shl 24));

type
  TRIFFChunk = packed record
    Marker:DWORD;
    Size:DWORD;
  end;

  TSTABHeader = Packed Record
    SampleRate:DWORD;
    SeekTableLength:DWORD;
  end;

  TSTABSeekTableEntry = Packed Record
    ChunkOffset:DWORD;
    ChunkSize:DWORD;
    ChunkFlags:Array[0..1] of DWORD;
  end;

var
  Chunk:TRIFFChunk;
  Header:TSTABHeader;
  ChunkOffset:DWORD;
  SeekTableIndex:DWORD;
  SeekTableEntry:TSTABSeekTableEntry;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Chunk, SizeOf(TRIFFChunk));
    if (Chunk.Marker = MARKER_FILM) and (Chunk.Size > 0) then
    begin
      // Header Size
      Size:=SwapLong(Chunk.Size);
      // Offset of next chunk (skipped version chunk)
      ChunkOffset:=Offset + (SizeOf(TRIFFChunk)*2);
      while (not FileData^.IsFileEnd) do
      begin
        if not IsRealFileSize(FileData, ChunkOffset, Size) then
        Exit;

        FileSeek(FileData, ChunkOffset);
        FileRead(FileData, Chunk, SizeOf(TRIFFChunk));

        if Chunk.Marker = MARKER_STAB then
        begin
          // Read STAB Header
          FileRead(FileData, Header, SizeOf(TSTABHeader));
          for SeekTableIndex := 0 to SwapLong(Header.SeekTableLength) - 1 do
          begin
            FileRead(FileData, SeekTableEntry, SizeOf(TSTABSeekTableEntry));
            Inc(Size, SwapLong(SeekTableEntry.ChunkSize));
          end;
          if IsRealFileSize(FileData, Offset, Size) then
          Result:=@FORMAT_TYPE_FILM;
          Exit;
        end;
        Inc(ChunkOffset, SwapLong(Chunk.Size));
      end;
    end;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
function SearchRAS(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_RAS = $956AA659;

type
  TRASHeader = Packed Record
    Marker: DWORD;
    Width: DWORD;
    Height: DWORD;
    PixelSize: DWORD;
    ImageSize: DWORD;
    ImageType: DWORD;
    MapType: DWORD;
    MapSize: DWORD;
  end;

var
  Header:TRASHeader;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TRASHeader));

    if (Header.Marker <> MARKER_RAS) then
    Exit;

    Header.ImageType:=SwapLong(Header.ImageType);
    Header.ImageSize:=SwapLong(Header.ImageSize);

    // Image type is in range 1-8
    if (Header.ImageType = 0) or (Header.ImageType > 8) then
    Exit;

    Header.MapType:=SwapLong(Header.MapType);
    Header.MapSize:=SwapLong(Header.MapSize);

    // When maptype = 0, mapsize must be 0 or file is invalid
    if (Header.MapType = 0) and (Header.MapSize <> 0) then
    Exit;

    // Only 2 maptypes defined
    if (Header.MapType > 2) then
    Exit;

    Size:=Header.ImageSize + Header.MapSize;
    if IsRealFileSize(FileData, Offset, Size) then
    Result:=@FORMAT_TYPE_RAS;
  except
    ReportError(FileData, Offset, Size);
  end;
end;
///////////////////////////////////////
//http://cinepaint.cvs.sourceforge.net/viewvc/cinepaint/cinepaint-project/cinepaint/plug-ins/cineon/dpxfile.h?view=markup
function SearchDPX1(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_DPX1 = DWORD(Byte('S') or (Byte('D') shl 8) or (Byte('P') shl 16) or (Byte('X') shl 24));
  MARKER_VERSION10 = DWORD(Byte('V') or (Byte('1') shl 8) or (Byte('.') shl 16) or (Byte('0') shl 24));
type
  TDPX1Header = Packed Record
    Marker: DWORD;
    DataOffset: DWORD;
    Version: Array[0..1] of DWORD;
    FileSize: DWORD;
    DittoKey: DWORD; // I dont know what it means, but I found this in sources
    GenericHeaderSize: DWORD;
    IndustryHeaderSize: DWORD;
    UserDataSize: DWORD;
    FileName: Array[0..99] of CHAR;
    CreateDate: Array[0..23] of CHAR;
    Creator: Array[0..99] of CHAR;
    Project: Array[0..199] of CHAR;
    Copyright: Array[0..199] of CHAR;
    EncryptKey: DWORD;
    Reserved: Array[0..103] of CHAR;
  end;

var
  Header: TDPX1Header;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TDPX1Header));
    if (Header.Marker <> MARKER_DPX1) then
    Exit;

    if (Header.Version[0] <> MARKER_VERSION10) then
    Exit;

    Size:=SwapLong(Header.FileSize);
    if IsRealFileSize(FileData, Offset, Size) then
    Result:=@FORMAT_TYPE_DPX1;
  except
    ReportError(FileData, Offset, Size);
  end;
end;

///////////////////////////////////////
//http://www.cineon.com/ff_draft.php#data
function SearchDPX4(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_DPX4 = $D75F2A80;
  MARKER_VERSION45 = DWORD(Byte('V') or (Byte('4') shl 8) or (Byte('.') shl 16) or (Byte('5') shl 24));

type
  TDPX4Header = Packed Record
    Marker: DWORD;
    DataOffset: DWORD;
    GenericHeaderSize: DWORD;
    IndustryHeaderSize: DWORD;
    UserDataSize: DWORD;
    FileSize: DWORD;
    Version: Array[0..1] of DWORD;
    FileName: Array[0..99] of CHAR;
    CreateDate: Array[0..11] of CHAR;
    CreateTime: Array[0..11] of CHAR;
    Reserved: Array[0..35] of CHAR;
  end;

var
  Header: TDPX4Header;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Header, SizeOf(TDPX4Header));
    if (Header.Marker <> MARKER_DPX4) then
    Exit;

    if (Header.Version[0] <> MARKER_VERSION45) then
    Exit;

    Size:=SwapLong(Header.FileSize);
    if IsRealFileSize(FileData, Offset, Size) then
    Result:=@FORMAT_TYPE_DPX4;
  except
    ReportError(FileData, Offset, Size);
  end;
end;

///////////////////////////////////////
//http://cekirdek.pardus.org.tr/~ismail/ffmpeg-docs/r3d_8c-source.html
function SearchR3D(const FileData:PFileData; var Offset:DWORD; var Size:DWORD):PFormatType;
const
  MARKER_RED1 = DWORD(Byte('R') or (Byte('E') shl 8) or (Byte('D') shl 16) or (Byte('1') shl 24));
  MARKER_REOB = DWORD(Byte('R') or (Byte('E') shl 8) or (Byte('O') shl 16) or (Byte('B') shl 24));

type
  TR3DChunk = Packed Record
    Size: DWORD;
    Marker: DWORD;
  end;

var
  Chunk: TR3DChunk;

begin
  Result:=nil;
  Size:= 0;
  try
    FileSeek(FileData, Offset);
    FileRead(FileData, Chunk, SizeOf(TR3DChunk));
    if (Chunk.Marker <> MARKER_RED1) then
    Exit;

    Size:=SwapLong(Chunk.Size);
    while (not FileData^.IsFileEnd) do
    begin
      if not IsRealFileSize(FileData, Offset, Size) then
      Exit;

      FileSeek(FileData, Offset + Size);
      FileRead(FileData, Chunk, SizeOf(TR3DChunk));

      Inc(Size, SwapLong(Chunk.Size));
      if Chunk.Marker = MARKER_REOB then
      begin
        if IsRealFileSize(FileData, Offset, Size) then
        Result:=@FORMAT_TYPE_R3D;
        Exit;
      end;
    end;

  except
    ReportError(FileData, Offset, Size);
  end;
end;



//#############################################
//
//#############################################

// Lazy implementation of original scanner, where I used switch instead of loop
function ExecuteGlobalScanner(const FileData:PFileData):Integer stdcall;
label
  LOOP_START;
var
  Buffer: Pointer;
  BufferMem: DWORD;

  BufferPos: DWORD;
  BufferSize: DWORD;

  OriginPos: DWORD;
  FileSize: DWORD;

  FormatIndex: DWORD;
  Marker: DWORD;
  IsFormatFound: BOOLEAN;

  Offset: DWORD;
  Size: DWORD;
  Format:PFormatType;
  FormatEntry:PFormatEntry;
  //CriticalSection: TRTLCriticalSection;
begin
  Result:=0;
  //InitializeCriticalSection(CriticalSection);

  //EnterCriticalSection(CriticalSection);

  if (FileData = nil) or FileData^.IsProcessing then
  Exit;

  FileOpen(FileData);
  if not FileData^.IsFileOpened then
  Exit;

  FileData^.IsProcessing:= True;
  FileData^.State:=ProcessStarted;

  Buffer:=nil;
  GetMem(Buffer, MaxBufferSize + BufferCache);
  if (Buffer = nil) then
  Exit;

  OriginPos:=0;
  FileSize:=FileData^.FileSize;

  while OriginPos < FileSize do
  begin
    LOOP_START:
    if FileData^.State <> ProcessStarted then
    begin
      while FileData^.State = ProcessPaused do
      begin
        // Maybe add something like Application.ProcessMessages
        // or Wait for single object ?
        Sleep(50);
      end;

      if FileData^.State = ProcessStopped then
      Break
    end;

    IsFormatFound:=False;
    BufferMem:= DWORD(Buffer);
    FileSeek(FileData, OriginPos);
    BufferSize:=FileRead(FileData, Buffer^, MaxBufferSize + BufferCache);

    if (BufferSize = 0) or (BufferSize < (BufferCache * 2)) then
    Break;

    //if BufferSize > BufferCache then
    Dec(BufferSize, BufferCache);


    //BufferSize:= BufferSize - (BufferSize mod 4);
    for BufferPos := 0 to BufferSize - 1 do
    begin
      Marker:=PDWORD(BufferMem)^;
      FormatIndex:=0;
      for FormatIndex := 0 to FormatCount - 1 do
      //while FormatIndex < FormatCount do
      begin
        Format:=FormatTable[FormatIndex];
        if Format.Enabled and (Format.Marker = Marker) then
        begin
          if IsFormatIncluded(@FileData^.ScanFormats[0], Format) then
          begin
            //if @Format.Scanner = nil then
            //Continue;

            Offset:=OriginPos + BufferPos;
            Inc(Offset, Format^.Offset); // Get real file pos, not marker pos

            //DebugWrite('debug.txt', Format^.Extension);
            Format:=Format^.Scanner(FileData, Offset, Size);
            if (Format <> nil) and (Size <> 0) then
            begin
              if FileData^.EntryDataAvailable = 0 then
              begin
                SetLength(FileData^.EntryData, FileData^.EntryDataCount + 128);
                FileData^.EntryDataAvailable:= 128;
              end;

              FormatEntry:=@FileData^.EntryData[FileData^.EntryDataCount];

              FormatEntry^.Format:= Format;
              FormatEntry^.Offset:= Offset;
              FormatEntry^.Size:= Size;

              FormatEntry^.Name:=IntToHex(Offset, 8) + '_' + IntToHex(Size, 8) + '.' + Format^.Extension;

              Inc(FileData^.EntryDataTotalSize, Size);

              Inc(FileData^.EntryDataCount);
              Dec(FileData^.EntryDataAvailable);

              IsFormatFound:=True;
              //Inc(OriginPos, Size);
              OriginPos:= Offset + Size;
              //Break;
              GOTO LOOP_START;
            end; // if
          end; // if
        end; // if
        //Inc(FormatIndex);
      end; // for

      Inc(BufferMem);
      (*
      if IsFormatFound then
      begin
        // Stop searching in buffer if we found a new format in file
        Break;
      end;
      *)
    end;  // For bufferpos

    //if not IsFormatFound then
    //begin
      // No format found in buffer, seek to next buffer pos
      Inc(OriginPos, BufferSize);
    //end;
  end;

  if Buffer <> nil then
  FreeMem(Buffer);

  FileClose(FileData);
  FileData^.IsProcessing:= False;
  Result:=1;
  //LeaveCriticalSection(CriticalSection);
end;

(*
function ExecuteGlobalScanner(const FileData:PFileData):Boolean;
var
  Buffer: Pointer;
  BufferMem: DWORD;

  BufferPos: DWORD;
  BufferSize: DWORD;

  OriginPos: DWORD;
begin
  Result:=False;

  FileOpen(FileData);
  if not FileData^.IsFileOpened then
  Exit;

  while (not FileData^.IsFileEnd) do
  begin
    BufferMem:= DWORD(Buffer);
    OriginPos:= FileData^.FilePos;

    BufferSize:=FileRead(FileData, Buffer, MaxBufferSize);
    for BufferPos := 0 to BufferSize - 1 do
    begin
      case PDWORD(BufferMem)^ of
        //////////////////
        ///  RIFF
        FORMAT_MARKER_RIFF:
        begin
          Offset:=OriginPos + BufferPos;
          if SearchRIFF(FileData, Offset, Size, Format) then
          begin
            if (Format in FFormats) then
            begin
              Result:=True;
              Exit;
            end; // if
          end;
        end;
        ///  RIFF
        //////////////////

        //////////////////
        ///  PNG
        FORMAT_MARKER_PNG:
        begin
          if FORMAT_TYPE_PNG in FFormats then
          begin
            if PDWORD(@FBuffer[FBufferPos+12])^= FORMAT_MARKER_PNG_IHDR then
            begin
              Offset:=OriginPos + BufferPos;
              if SearchPNG(FileData, Offset, Size) then
              begin
                Format:=FORMAT_TYPE_PNG;
                Result:=True; 
                Exit; 
              end; // if
            end; // if
          end; // if
        end; 
        ///  PNG
        //////////////////

        //////////////////
        ///  7Zip
        FORMAT_MARKER_7Z:
        begin
          if FORMAT_TYPE_7Z in FFormats then
          begin
            if PDWORD(@FBuffer[FBufferPos+4])^=FORMAT_MARKER_7Z_VER then
            begin
              Offset:=OriginPos + BufferPos;
              if Search7z(FileData, Offset, Size) then
              begin
                Format:=FORMAT_TYPE_7Z; 
                Result:=True; 
                Exit; 
              end; // if
            end; // if
          end; // if
        end; 
        ///  7Zip
        //////////////////

        //////////////////
        ///  M4A, MP4, 3GP
        FORMAT_MARKER_MPEG4_FTYP:
        begin
          if (FORMAT_TYPE_M4A in FFormats) or (FORMAT_TYPE_MP4 in FFormats)
          or (FORMAT_TYPE_3GP in FFormats) or (FORMAT_TYPE_3G2 in FFormats)then
          begin
            Offset:=OriginPos + BufferPos;
            if SearchMP4(FileData, Offset, Size, Format) then
            begin
              if (Format in FFormats) then
              begin
                Result:=True; 
                Exit; 
              end; 
            end; // if
          end; // if
        end; // case
        ///  M4A, MP4
        //////////////////

        //////////////////
        ///  MOV
        FORMAT_MARKER_MPEG4_MOOV:
        begin
          if FORMAT_TYPE_MOV in FFormats then
          begin
            if PDWORD(@FBuffer[FBufferPos+8])^= FORMAT_MARKER_MPEG4_MVHD then
            begin
              Offset:=OriginPos + BufferPos;
              if SearchMOV(FileData, Offset, Size) then
              begin
                Format:=FORMAT_TYPE_MOV; 
                Result:=True; 
                Exit; 
              end; // if
            end; 
          end; 
        end; 
        ///  MOV
        //////////////////

        //////////////////
        ///  AIFF
        FORMAT_MARKER_FORM:
        begin
          Offset:=OriginPos + BufferPos;
          if SearchFORM(FileData, Offset, Size, Format) then
          begin
            if Format in FFormats then
            begin
              Result:=True;
              Exit;
            end;
          end;
        end; 
        ///  AIFF
        //////////////////

        //////////////////
        ///  OGG
        FORMAT_MARKER_OGG:
        begin
          if FORMAT_TYPE_OGG in FFormats then
          begin
            Offset:=OriginPos + BufferPos;
            if SearchOGG(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_OGG;
              Result:=True; 
              Exit; 
            end; 
          end; 
        end; 
        //////////////////
        ///  OGG

        //////////////////
        ///  BIK
        FORMAT_MARKER_BIK:
        begin
          if FORMAT_TYPE_BIK in FFormats then
          begin
            Offset:=OriginPos + BufferPos;
            if SearchBIK(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_BIK;
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  BIK
        //////////////////

        //////////////////
        ///  APE
        FORMAT_MARKER_APE:
        begin
          if FORMAT_TYPE_APE in FFormats then
          begin
            Offset:=OriginPos + BufferPos;
            if SearchAPE(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_APE;
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  APE
        //////////////////

        //////////////////
        ///  DDS
        FORMAT_MARKER_DDS:
        begin
          if FORMAT_TYPE_DDS in FFormats then
          begin
            Offset:=OriginPos + BufferPos;
            if SearchDDS(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_DDS; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  DDS
        //////////////////

        //////////////////
        ///  TGA
        FORMAT_MARKER_TGA:
        begin
          if FORMAT_TYPE_TGA in FFormats then
          begin
            Offset:=OriginPos + BufferPos;
            if SearchTGA(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_TGA; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  TGA
        //////////////////

        //////////////////
        ///  ZIP
        FORMAT_MARKER_ZIP_LOC:
        begin
          if FORMAT_TYPE_ZIP in FFormats then
          begin
            Offset:=OriginPos + BufferPos;
            if SearchZIP(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_ZIP; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  ZIP
        //////////////////

        //////////////////
        ///  MIDI
        FORMAT_MARKER_MIDI_MTHD:
        begin
          if FORMAT_TYPE_MIDI in FFormats then
          begin
            Offset:=OriginPos + BufferPos;
            if SearchMIDI(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_MIDI;
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  MIDI
        //////////////////

        //////////////////
        ///  PSD
        FORMAT_MARKER_PSD_8BPS:
        begin
          if FORMAT_TYPE_PSD in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchPSD(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_PSD; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  PSD
        //////////////////

        //////////////////
        ///  MP3 (ID 1, 2, 3, 4)
        FORMAT_MARKER_ID3V2,
        FORMAT_MARKER_ID3V3,
        FORMAT_MARKER_ID3V4:// Todo : check other formats
        begin
          if FORMAT_TYPE_MP3 in FFormats then
          begin
            Offset:=FLastPos+FBufferPos;
            if SearchMP3(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_MP3;
              Result:=True; 
              Exit; 
            end; // if
          end; // if
        end; // case
        ///  MP3 (ID 1, 2, 3, 4
        //////////////////

        //////////////////
        ///  SWF
        FORMAT_MARKER_SWF:
        begin
          if FORMAT_TYPE_SWF in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchSWF(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_SWF; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  SWF
        //////////////////

        //////////////////
        ///  SWS - ShockWave Stream
        FORMAT_MARKER_SWS_CTRL:
        begin
          if FORMAT_TYPE_SWS in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchSWS(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_SWS; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  SWS
        //////////////////

        //////////////////
        ///  SIFF
        FORMAT_MARKER_SIFF:
        begin
          if FORMAT_TYPE_SIFF in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchSIFF(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_SIFF; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  SIFF
        //////////////////

        //////////////////
        ///  FLV
        FORMAT_MARKER_FLV:
        begin
          if FORMAT_TYPE_FLV in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchFLV(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_FLV; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  FLV
        //////////////////

        //////////////////
        ///  RMF
        FORMAT_MARKER_RMF:
        begin
          if FORMAT_TYPE_RMF in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchRMF(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_RMF; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  RMF
        //////////////////

        //////////////////
        ///  ASF
        FORMAT_MARKER_ASF:
        begin
          if FORMAT_TYPE_ASF in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchASF(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_ASF; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  ASF
        //////////////////

        //////////////////
        ///  SND
        FORMAT_MARKER_SND:
        begin
          if FORMAT_TYPE_SND in FFormats then
          begin
            Offset:=FLastPos+FBufferPos;
            if SearchSND(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_SND;
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  SND
        //////////////////

        //////////////////
        ///  WVPK
        FORMAT_MARKER_WVPK:
        begin
          if FORMAT_TYPE_WVPK in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchWVPK(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_WVPK;
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  WVPK
        //////////////////

        //////////////////
        ///  RAF
        FORMAT_MARKER_RAF:
        begin
          if FORMAT_TYPE_RAF in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchRAF(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_RAF;
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  RAF
        //////////////////

        //////////////////
        ///  SMK
        FORMAT_MARKER_SMK:
        begin
          if FORMAT_TYPE_SMK in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchSMK(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_SMK; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  SMK
        //////////////////

        //////////////////
        ///  XBG
        FORMAT_MARKER_XBG:
        begin
          if FORMAT_TYPE_XBG in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchXBG(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_XBG; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  XBG
        //////////////////

        //////////////////
        ///  XPR
        FORMAT_MARKER_XPR:
        begin
          if FORMAT_TYPE_XPR in FFormats then
          begin
            Offset:=FLastPos+FBufferPos;
            if SearchXPR0(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_XPR; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  XPR
        //////////////////

        //////////////////
        ///  XPR2
        FORMAT_MARKER_XPR_2:
        begin
          if FORMAT_TYPE_XPR_2 in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchXPR2(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_XPR_2; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  XPR2
        //////////////////

        //////////////////
        ///  XMV
        FORMAT_MARKER_XMV:
        begin
          if FORMAT_TYPE_XMV in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchXMV(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_XMV; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  XMV
        //////////////////

        //////////////////
        ///  CAB
        FORMAT_MARKER_CAB:
        begin
          if FORMAT_TYPE_CAB in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchCAB(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_CAB; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  CAB
        //////////////////

        //////////////////
        ///  XNB
        FORMAT_MARKER_XNB:
        begin
          if FORMAT_TYPE_XNB in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchXNB(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_XNB; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  XNB
        //////////////////

        //////////////////
        ///  WAD
        FORMAT_MARKER_WAD:
        begin
          if FORMAT_TYPE_WAD in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchWAD(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_WAD; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  WAD
        //////////////////

        //////////////////
        ///  MDL
        FORMAT_MARKER_MDL7:
        begin
          if FORMAT_TYPE_MDL_7 in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchMDL7(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_MDL_7; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  MDL
        //////////////////

        //////////////////
        ///  PSMF
        FORMAT_MARKER_PSMF:
        begin
          if FORMAT_TYPE_PSMF in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchPSMF(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_PSMF; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  PSMF
        //////////////////

        //////////////////
        ///  TTA
        FORMAT_MARKER_TTA:
        begin
          if FORMAT_TYPE_TTA in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchTTA(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_TTA;
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  TTA
        //////////////////

        //////////////////
        ///  OFR
        FORMAT_MARKER_OFR:
        begin
          if FORMAT_TYPE_OFR in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchOFR(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_OFR;
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  OFR
        //////////////////

        //////////////////
        ///  LA
        FORMAT_MARKER_LA:
        begin
          if FORMAT_TYPE_LA in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchLA(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_LA;
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  LA
        //////////////////

        //////////////////
        ///  LPAC
        FORMAT_MARKER_LPAC:
        begin
          if FORMAT_TYPE_LPAC in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchLPAC(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_LPAC;
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  PAC
        //////////////////

        //////////////////
        ///  VQF
        FORMAT_MARKER_VQF_TWIN:
        begin
          if FORMAT_TYPE_VQF in FFormats then
          begin
            Offset:=FLastPos+FBufferPos;
            if SearchVQF(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_VQF;
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  VQF
        //////////////////

        //////////////////
        ///  AVS
        FORMAT_MARKER_AVS:
        begin
          if FORMAT_TYPE_AVS in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchAVS(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_AVS; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  AVS
        //////////////////

        //////////////////
        ///  NSV
        FORMAT_MARKER_NSV:
        begin
          if FORMAT_TYPE_NSV in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchNSV(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_NSV; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  NSV
        //////////////////

        //////////////////
        ///  PVA
        FORMAT_MARKER_PVA:
        begin
          if FORMAT_TYPE_PVA in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchPVA(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_PVA; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  PVA
        //////////////////

        //////////////////
        ///  BRES
        FORMAT_MARKER_BRES:
        begin
          if FORMAT_TYPE_BRES in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchBRES(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_BRES; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  BRES
        //////////////////

        //////////////////
        ///  RFNA
        FORMAT_MARKER_RFNA:
        begin
          if FORMAT_TYPE_RFNA in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchRFNA(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_RFNA; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  RFNA
        //////////////////

        //////////////////
        ///  REFT
        FORMAT_MARKER_REFT:
        begin
          if FORMAT_TYPE_REFT in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchREFT(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_REFT; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  REFT
        //////////////////

        //////////////////
        ///  RFNT
        ffRFNTID:
        begin
          if FORMAT_TYPE_RFNT in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchRFNT(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_RFNT; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  RFNT
        //////////////////

        //////////////////
        ///  RSAR
        ffRSARID:
        begin
          if FORMAT_TYPE_RSAR in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchRSAR(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_RSAR; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  RSAR
        //////////////////

        //////////////////
        ///  RSTM
        ffRSTMID:
        begin
          if FORMAT_TYPE_RSTM in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchRSTM(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_RSTM; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  RSTM
        //////////////////

        //////////////////
        ///  GR2
        ffGR2ID:
        begin
          if FORMAT_TYPE_GR2 in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchGR2(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_GR2; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  GR2
        //////////////////

        //////////////////
        ///  NCER
        ffNCERID:
        begin
          if FORMAT_TYPE_NCER in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchNCER(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_NCER; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  NCER
        //////////////////

        //////////////////
        ///  NANR
        ffNANRID:
        begin
          if FORMAT_TYPE_NANR in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchNANR(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_NANR; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  NANR
        //////////////////

        //////////////////
        ///  NCLR
        ffNCLRID:
        begin
          if FORMAT_TYPE_NCLR in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchNCLR(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_NCLR; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  NCLR
        //////////////////

        //////////////////
        ///  NARC
        ffNARCID:
        begin
          if FORMAT_TYPE_NARC in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchNARC(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_NARC; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  NARC
        //////////////////

        //////////////////
        ///  SDAT
        ffSDATID:
        begin
          if FORMAT_TYPE_SDAT in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchSDAT(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_SDAT; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  SDAT
        //////////////////

        //////////////////
        ///  SSEQ
        ffSSEQID:
        begin
          if FORMAT_TYPE_SSEQ in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchSSEQ(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_SSEQ; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  SSEQ
        //////////////////

        //////////////////
        ///  SSAR
        ffSSARID:
        begin
          if FORMAT_TYPE_SSAR in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchSSAR(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_SSAR; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  SSAR
        //////////////////

        //////////////////
        ///  SWAR
        ffSWARID:
        begin
          if FORMAT_TYPE_SWAR in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchSWAR(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_SWAR; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  SWAR
        //////////////////

        //////////////////
        ///  SBNK
        ffSBNKID:
        begin
          if FORMAT_TYPE_SBNK in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchSBNK(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_SBNK; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  SBNK
        //////////////////

        //////////////////
        ///  THP
        ffTHPID:
        begin
          if FORMAT_TYPE_THP in FFormats then
          begin
            Offset:=FLastPos+FBufferPos; 
            if SearchTHP(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_THP; 
              Result:=True; 
              Exit; 
            end; // if
          end; 
        end; 
        ///  THP
        //////////////////

        //////////////////
        ///  FILM
        ffFILMID:
        begin
          if FORMAT_TYPE_FILM in FFormats then
          begin
            Offset:=FLastPos+FBufferPos;
            if SearchFILM(FileData, Offset, Size) then
            begin
              Format:=FORMAT_TYPE_FILM;
              Result:=True;
              Exit; 
            end; // if
          end;
        end; 
        ///  THP
        //////////////////
      end;  //case end
(*
//------------------------------
// COMPARE WORD
//------------------------------
      // Check for Short ID
      if Format=FORMAT_TYPE_NONE then
      begin
        case pWord(@FBuffer[FBufferPos])^ of

          ffZLIBID1, ffZLIBID2:
          begin
            if FORMAT_TYPE_ZLIB in FFormats then
            begin
              Offset:=FLastPos+FBufferPos; 
              if SearchZLIB(FileData, Offset, Size) then
              begin
                Format:=FORMAT_TYPE_ZLIB; 
                Result:=True; 
                Exit; 
              end;  // if
            end; 
          end; 

          ffBMPID:
          begin
            if FORMAT_TYPE_BMP in FFormats then
            begin
              Offset:=FLastPos+FBufferPos;
              if SearchBMP(FileData, Offset, Size) then
              begin
                Format:=FORMAT_TYPE_BMP; 
                Result:=True;
                Exit; 
              end; // if
            end; 
          end;

          ffSOIID:
          begin
            if FORMAT_TYPE_JFIF in FFormats then
            begin
              Offset:=FLastPos+FBufferPos; 
              if SearchJFIF(FileData, Offset, Size) then
              begin
                Format:=FORMAT_TYPE_JFIF; 
                Result:=True; 
                Exit; 
              end; // if
            end; // if
          end; //case

          FORMAT_TYPE_MP30IDMin..FORMAT_TYPE_MP30IDMax:
          begin
            if FORMAT_TYPE_MP30 in FFormats then
            begin
              Offset:=FLastPos+FBufferPos;
              if SearchMP3(FileData, Offset, Size) then
              begin
                Format:=FORMAT_TYPE_MP30; 
                Result:=True;
                Exit; 
              end; // if
            end; // if
          end;

          ffMZID:
          begin
            if (FORMAT_TYPE_EXE in FFormats) or (FORMAT_TYPE_DLL in FFormats)then
            begin
              Offset:=FLastPos+FBufferPos; 
              if SearchPE(FileData, Offset, Size, Format) then
              begin
                if (Format in FFormats) then
                begin
                  Result:=True; 
                  Exit;
                end; 
              end; // if
            end; // if
          end;

          ff3DSID:
          begin
            if FORMAT_TYPE_3DS in FFormats then
            begin
              Offset:=FLastPos+FBufferPos; 
              if Search3DS(FileData, Offset, Size) then
              begin
                Format:=FORMAT_TYPE_3DS; 
                Result:=True; 
                Exit;
              end; // if
            end; // if
          end;

          //////////////////
          ///  FLI
          ffFLIID, ffFLCID, ffFLXID:
          begin
            if (FORMAT_TYPE_FLI in FFormats) or (FORMAT_TYPE_FLC in FFormats) or (FORMAT_TYPE_FLX in FFormats) then
            begin
              Offset:=FLastPos+FBufferPos;
              if SearchFLX(FileData, Offset, Size, Format) then
              begin
                if (Format in FFormats) then
                begin
                  Result:=True;
                  Exit;
                end;
              end; // if
            end;
          end;
          ///  FLI
          //////////////////

        end; // case end
      end; // if format unk
*)
//    end;  // for
//  end; // with
//end;


end.
