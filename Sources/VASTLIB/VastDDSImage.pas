unit VastDDSImage;

interface
// Variations example of DDS
//http://msdn.microsoft.com/en-us/library/bb205577(VS.85).aspx
// Header
//http://msdn.microsoft.com/en-us/library/bb943982(VS.85).aspx
// Patent
//http://www.freepatentsonline.com/7385611.html
// Textures with Alpha Channels
//http://msdn.microsoft.com/en-us/library/bb206238(VS.85).aspx
// Opaque and 1-Bit Alpha Textures
//http://msdn.microsoft.com/en-us/library/bb147243(VS.85).aspx
// Block Compression
//http://msdn.microsoft.com/en-us/library/bb694531(VS.85).aspx
// Volume Texture Resources
//http://msdn.microsoft.com/en-us/library/bb206344(VS.85).aspx
// Programming Guide for DDS
//http://msdn.microsoft.com/en-us/library/bb943991(VS.85).aspx
uses
  VastImage, VastImagePixelFormat, VastImageTypes, ProcTimer, VastFile, VastMemory, VastUtils;

const
  // Surface types for internal usage
  DDSF_SURFACE_NONE   = $00000000;
  DDSF_SURFACE_SIMPLE = $00000001;
  DDSF_SURFACE_CUBE   = $00000002;
  DDSF_SURFACE_VOLUME = $00000003;
  DDSF_FOURCC         = $00000004;
  DDSF_BCFORMAT       = $00000008;
  DDSF_DX10FORMAT     = $00000010;

type
  TDDSMultiVastImage = Packed Record
    Image:PVastImage;
    ImageCount:DWORD;
    TotalSize:DWORD;
    SurfaceFlags:DWORD;
    ElementCount:DWORD;
    MipMapCount:DWORD;
    FaceFlags:DWORD;
    FaceCount:DWORD;
    SliceCount:DWORD;
  end;
  PDDSMultiVastImage = ^TDDSMultiVastImage;

function InitDDSMultiImage (var DDSMultiImage:PDDSMultiVastImage;ImageCount:DWORD):Boolean;
function FreeDDSMultiImage (var DDSMultiImage:PDDSMultiVastImage):Boolean;

function LoadDDSImage(const FileName:PChar;var Image:PVastImage):Boolean;
function LoadDDSMultiImage(const FileName:PChar;var DDSMultiImage:PDDSMultiVastImage):Boolean;
function SaveDDSMultiImage(const FileName:PChar;var DDSMultiImage:PDDSMultiVastImage):Boolean;

function GenerateMipMap(var InImage:PVastImage;var OutImage:PVastImage;const Width:DWORD;const Height:DWORD):Boolean;

implementation

const
  DDSMarker   = DWORD(Byte('D') or (Byte('D') shl 8) or (Byte('S') shl 16) or (Byte(' ') shl 24));

  BC1Marker   = DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('1') shl 24));
  BC2Marker   = DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('3') shl 24));
  BC3Marker   = DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('5') shl 24));
  BC4Marker   = DWORD(Byte('A') or (Byte('T') shl 8) or (Byte('I') shl 16) or (Byte('1') shl 24));
  BC5Marker   = DWORD(Byte('A') or (Byte('T') shl 8) or (Byte('I') shl 16) or (Byte('2') shl 24));
  // New Direct X 10 FOURCC
  DX10Marker  = DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('1') shl 16) or (Byte('0') shl 24));

  // Used in DDSHeader.Flags
  DDSD_CAPS         = $00000001;
  DDSD_HEIGHT       = $00000002;
  DDSD_WIDTH        = $00000004;
  DDSD_PITCH        = $00000008;
  DDSD_PIXELFORMAT  = $00001000;
  DDSD_MIPMAPCOUNT  = $00020000;
  DDSD_LINEARSIZE   = $00080000;
  DDSD_DEPTH        = $00800000;

  // Used in DDSHeader.PixelFormat.Flags
	DDPF_ALPHAPIXELS      = $00000001;  // The surface has alpha channel information in the pixel format.
	DDPF_ALPHA            = $00000002;  // The pixel format describes an alpha-only surface.
	DDPF_FOURCC           = $00000004;  // The FOURCC code is valid.
	DDPF_RGB              = $00000040;  // The RGB data in the pixel format structure is valid.
	DDPF_PALETTEINDEXED1  = $00000800;  // The surface is 1-bit color indexed.
	DDPF_PALETTEINDEXED2  = $00001000;  // The surface is 2-bit color indexed.
	DDPF_PALETTEINDEXED4  = $00000008;  // The surface is 4-bit color indexed.
	DDPF_PALETTEINDEXED8  = $00000020;  // The surface is 8-bit color indexed.
	DDPF_LUMINANCE        = $00020000;  // Luminance data in the pixel format is valid. Use this flag for luminance-only or luminance-plus-alpha surfaces
	DDPF_ALPHAPREMULT     = $00008000;  // The color components in the pixel are premultiplied by the alpha value in the pixel
	DDPF_NORMAL           = $80000000;	// @@ Custom nv flag.

  // Used in DDSHeader.CapFlags[0]
  DDSC_COMPLEX = $00000008;
  DDSC_TEXTURE = $00001000;
  DDSC_MIPMAP  = $00400000;

  // Used in DDSHeader.CapFlags[1]
  DDSC_CUBEMAP   = $00000200;
  DDSC_POSITIVEX = $00000400;
  DDSC_NEGATIVEX = $00000800;
  DDSC_POSITIVEY = $00001000;
  DDSC_NEGATIVEY = $00002000;
  DDSC_POSITIVEZ = $00004000;
  DDSC_NEGATIVEZ = $00008000;
  DDSC_VOLUME    = $00200000;

  // Used in DDSHeaderEx.MiscFlag
  DDSR_GENERATE_MIPS = $00000001;
  DDSR_SHARED        = $00000002;
  DDSR_TEXTURECUBE   = $00000004;

  // Converted enumeration to constants,why ? Because there is prefix DXGI_FORMAT
  //so enumeration is not needed in this case
  DXGI_FORMAT_UNKNOWN = 0;
  DXGI_FORMAT_R32G32B32A32_TYPELESS = 1;
  DXGI_FORMAT_R32G32B32A32_FLOAT = 2;
  DXGI_FORMAT_R32G32B32A32_UINT = 3;
  DXGI_FORMAT_R32G32B32A32_SINT = 4;
  DXGI_FORMAT_R32G32B32_TYPELESS = 5;
  DXGI_FORMAT_R32G32B32_FLOAT = 6;
  DXGI_FORMAT_R32G32B32_UINT = 7;
  DXGI_FORMAT_R32G32B32_SINT = 8;
  DXGI_FORMAT_R16G16B16A16_TYPELESS = 9;
  DXGI_FORMAT_R16G16B16A16_FLOAT = 10;
  DXGI_FORMAT_R16G16B16A16_UNORM = 11;
  DXGI_FORMAT_R16G16B16A16_UINT = 12;
  DXGI_FORMAT_R16G16B16A16_SNORM = 13;
  DXGI_FORMAT_R16G16B16A16_SINT = 14;
  DXGI_FORMAT_R32G32_TYPELESS = 15;
  DXGI_FORMAT_R32G32_FLOAT = 16;
  DXGI_FORMAT_R32G32_UINT = 17;
  DXGI_FORMAT_R32G32_SINT = 18;
  DXGI_FORMAT_R32G8X24_TYPELESS = 19;
  DXGI_FORMAT_D32_FLOAT_S8X24_UINT = 20;
  DXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS = 21;
  DXGI_FORMAT_X32_TYPELESS_G8X24_UINT = 22;
  DXGI_FORMAT_R10G10B10A2_TYPELESS = 23;
  DXGI_FORMAT_R10G10B10A2_UNORM = 24;
  DXGI_FORMAT_R10G10B10A2_UINT = 25;
  DXGI_FORMAT_R11G11B10_FLOAT = 26;
  DXGI_FORMAT_R8G8B8A8_TYPELESS = 27;
  DXGI_FORMAT_R8G8B8A8_UNORM = 28;
  DXGI_FORMAT_R8G8B8A8_UNORM_SRGB = 29;
  DXGI_FORMAT_R8G8B8A8_UINT = 30;
  DXGI_FORMAT_R8G8B8A8_SNORM = 31;
  DXGI_FORMAT_R8G8B8A8_SINT = 32;
  DXGI_FORMAT_R16G16_TYPELESS = 33;
  DXGI_FORMAT_R16G16_FLOAT = 34;
  DXGI_FORMAT_R16G16_UNORM = 35;
  DXGI_FORMAT_R16G16_UINT = 36;
  DXGI_FORMAT_R16G16_SNORM = 37;
  DXGI_FORMAT_R16G16_SINT = 38;
  DXGI_FORMAT_R32_TYPELESS = 39;
  DXGI_FORMAT_D32_FLOAT = 40;
  DXGI_FORMAT_R32_FLOAT = 41;
  DXGI_FORMAT_R32_UINT = 42;
  DXGI_FORMAT_R32_SINT = 43;
  DXGI_FORMAT_R24G8_TYPELESS = 44;
  DXGI_FORMAT_D24_UNORM_S8_UINT = 45;
  DXGI_FORMAT_R24_UNORM_X8_TYPELESS = 46;
  DXGI_FORMAT_X24_TYPELESS_G8_UINT = 47;
  DXGI_FORMAT_R8G8_TYPELESS = 48;
  DXGI_FORMAT_R8G8_UNORM = 49;
  DXGI_FORMAT_R8G8_UINT = 50;
  DXGI_FORMAT_R8G8_SNORM = 51;
  DXGI_FORMAT_R8G8_SINT = 52;
  DXGI_FORMAT_R16_TYPELESS = 53;
  DXGI_FORMAT_R16_FLOAT = 54;
  DXGI_FORMAT_D16_UNORM = 55;
  DXGI_FORMAT_R16_UNORM = 56;
  DXGI_FORMAT_R16_UINT = 57;
  DXGI_FORMAT_R16_SNORM = 58;
  DXGI_FORMAT_R16_SINT = 59;
  DXGI_FORMAT_R8_TYPELESS = 60;
  DXGI_FORMAT_R8_UNORM = 61;
  DXGI_FORMAT_R8_UINT = 62;
  DXGI_FORMAT_R8_SNORM = 63;
  DXGI_FORMAT_R8_SINT = 64;
  DXGI_FORMAT_A8_UNORM = 65;
  DXGI_FORMAT_R1_UNORM = 66;
  DXGI_FORMAT_R9G9B9E5_SHAREDEXP = 67;
  DXGI_FORMAT_R8G8_B8G8_UNORM = 68;
  DXGI_FORMAT_G8R8_G8B8_UNORM = 69;
  DXGI_FORMAT_BC1_TYPELESS = 70;
  DXGI_FORMAT_BC1_UNORM = 71;
  DXGI_FORMAT_BC1_UNORM_SRGB = 72;
  DXGI_FORMAT_BC2_TYPELESS = 73;
  DXGI_FORMAT_BC2_UNORM = 74;
  DXGI_FORMAT_BC2_UNORM_SRGB = 75;
  DXGI_FORMAT_BC3_TYPELESS = 76;
  DXGI_FORMAT_BC3_UNORM = 77;
  DXGI_FORMAT_BC3_UNORM_SRGB = 78;
  DXGI_FORMAT_BC4_TYPELESS = 79;
  DXGI_FORMAT_BC4_UNORM = 80;
  DXGI_FORMAT_BC4_SNORM = 81;
  DXGI_FORMAT_BC5_TYPELESS = 82;
  DXGI_FORMAT_BC5_UNORM = 83;
  DXGI_FORMAT_BC5_SNORM = 84;
  DXGI_FORMAT_B5G6R5_UNORM = 85;
  DXGI_FORMAT_B5G5R5A1_UNORM = 86;
  DXGI_FORMAT_B8G8R8A8_UNORM = 87;
  DXGI_FORMAT_B8G8R8X8_UNORM = 88;
type
  // Direct Draw Surface pixel format.
  // http://msdn.microsoft.com/en-us/library/bb943979(VS.85).aspx
  TDDPixelFormat = Packed Record
    Size:DWORD;
    Flags:DWORD;
    FourCC:DWORD;
    PixelSize:DWORD; // Modified name to meanful one
    RBitMask:DWORD;
    GBitMask:DWORD;
    BBitMask:DWORD;
    ABitMask:DWORD; // Modified name to because it has same usage as R G B variables above
  end;

  // Direct Draw Surface header for dx9
  // http://msdn.microsoft.com/en-us/library/bb943982(VS.85).aspx
  TDDSHeader = Packed Record
    Marker:DWORD;
    Size:DWORD;
    Flags:DWORD;
    Height:DWORD;
    Width:DWORD;
    LinearSize:DWORD;
    Depth:DWORD;
    MipMapCount:DWORD;
    Reserved:Array[0..10] of DWORD; // Modified name
    PixelFormat:TDDPixelFormat;
    CapFlags:Array[0..3] of DWORD; // Modified name -> surface capatibility flags aka Caps
    ReservedX:DWORD;
  end;

  // Identifies the type of resource being used.
  // http://msdn.microsoft.com/en-us/library/bb172411(VS.85).aspx
  TD3D10_RESOURCE_DIMENSION = (
    D3D10_RESOURCE_DIMENSION_UNKNOWN   = 0,
    D3D10_RESOURCE_DIMENSION_BUFFER    = 1,
    D3D10_RESOURCE_DIMENSION_TEXTURE1D = 2,
    D3D10_RESOURCE_DIMENSION_TEXTURE2D = 3,
    D3D10_RESOURCE_DIMENSION_TEXTURE3D = 4
  );
(*
  // List of resource data formats which includes fully-typed and typeless formats...
  // http://msdn.microsoft.com/en-us/library/bb173059(VS.85).aspx
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
    DXGI_FORMAT_FORCE_UINT = $FFFFFFFF
  );
*)

  // Direct Draw Surface extended header for dx10 (to handle resource arrays)
  // http://msdn.microsoft.com/en-us/library/bb943983(VS.85).aspx
  TDDSHeaderEx = Packed Record
    //enDXGIFormat:TDXGI_FORMAT;
    //enResDimension:TD3D10_RESOURCE_DIMENSION; // Modified name to shorter
    DXGIFormat:DWORD;
    ResDimension:DWORD; // Modified name to shorter
    MiscFlag:DWORD;
    ArraySize:DWORD;
    Reserved:DWORD;
  end;

var
  Timer:TProcTimer;

function InitDDSMultiImage (var DDSMultiImage:PDDSMultiVastImage;ImageCount:DWORD):Boolean;
begin
  Result:=False;
  //if IsMultiImageSet(mMultiImage) then
  //Exit;
  if DDSMultiImage <> nil then
  Exit;

  //DDSMultiImage:=nil;
  if not hAllocMem(Pointer(DDSMultiImage),SizeOf(TDDSMultiVastImage)) then
  Exit;

  //EraseMem(DWORD(DDSMultiImage),SizeOf(TDDSMultiVastImage));
  if ImageCount > 0 then
  begin
    hAllocMem(POINTER(DDSMultiImage^.Image),ImageCount * SizeOf(TVastImage));
    //EraseMem(DWORD(DDSMultiImage^.Image),ImageCount * SizeOf(TVastImage));
    DDSMultiImage^.ImageCount:=ImageCount;
  end;

  Result:=True;
end;

function FreeDDSMultiImage (var DDSMultiImage:PDDSMultiVastImage):Boolean;
var
  ImageIndex:DWORD;
  Image:PVastImage;
begin
  Result:=False;
  if DDSMultiImage = nil then
  Exit;

  if DDSMultiImage^.ImageCount > 0 then
  begin
    // We freed image data of all images in array
    Image:=DDSMultiImage^.Image;
    for ImageIndex:=0 to DDSMultiImage^.ImageCount do
    begin
      if Image^.Data <> nil then
      mFreeMem(Image^.Data);
      Inc(Image);
    end;
    // This will freed all images in array
    hFreeMem(POINTER(DDSMultiImage^.Image));
  end;
  // Now we finally freed whole DDS image
  if hFreeMem(POINTER(DDSMultiImage)) then
  Result:=True;
end;

// Resizing image from 8192 x 8192 to 4096 x 4096 takes only 344 ms
// Resizing image from 8192 x 8192 to 2048 x 2048 takes only 92 ms
// Resizing image from 8192 x 8192 to 1024 x 1024 takes only 27 ms
// Resizing image from 8192 x 8192 to 515 x 512 takes only 5 ms
// Resizing image from 8192 x 8192 to 256 x 256 takes only 3 ms
// Resizing image from 8192 x 8192 to 128 x 128 takes only 1 ms

// Requires: Width and Height should be same,smaller than Width and Height in input image, and dividable by 16
function GenerateMipMap(var InImage:PVastImage;var OutImage:PVastImage;const Width:DWORD;const Height:DWORD):Boolean;
var
  InDataMem:DWORD;
  OutDataMem:DWORD;

  XPos:DWORD;
  YPos:DWORD;
  XSkip:DWORD;
  YSkip:DWORD;
  PixelPos:DWORD;
  PixelSize:DWORD;
begin
  Result:=False;
  if not IsImageSet(InImage) then
  Exit;

  if (Width = 0) or (Height = 0) then
  Exit;
  // Check if pixel format is diveable by 8 bit
  PixelSize:=InImage^.PixelSize div 8;
  if PixelSize = 0 then
  Exit;
  // Create new Image
  if not InitImage(OutImage) then
  Exit;

  // Copy image input image information to output image
  OutImage^.PixelFormat:=InImage^.PixelFormat;
  OutImage^.Size:=Width * Height * PixelSize;
  OutImage^.Width:=Width;
  OutImage^.Height:=Height;
  OutImage^.PixelSize:=InImage^.PixelSize;
  // Alocate target image data memory
  if not mAllocMem(OutImage^.Data,OutImage^.Size) then
  Exit;
  //if not InitImageData(OutImage,OutImage^.Size

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);
  // Get increment for XY coors,by doing this we increase a input memory pointer without using later multiplications
  // HINT: Whole function using only 3 multiplications and 3 divisions...
  XSkip:=((InImage^.Width div Width) - 1) * PixelSize; // Rounded X scale factor * PixelSize
  YSkip:=((InImage^.Height div Height) - 1) * (InImage^.Width * PixelSize); // Rounded Y scale factor * BytesPerLine

  //StartTimer(Timer);
  for YPos:=0 to Height - 1 do
  begin
    for XPos:=0 to Width - 1 do
    begin
      for PixelPos:=0 to PixelSize - 1 do
      begin
        PBYTE(OutDataMem)^:=PBYTE(InDataMem)^;
        inc(InDataMem);
        inc(OutDataMem);
      end;
      inc(InDataMem,XSkip);
    end; // for XPos
    inc(InDataMem,YSkip);
  end; // for YPos
  //StopTimer(Timer);
  //ShowTimer(Timer);
  Result:=True;
  Exit;
end;

// Simplified function of DDS loader for loading first image only
function LoadDDSImage(const FileName:PChar;var Image:PVastImage):Boolean;
var
  FFile:TVastFile;
  Header:TDDSHeader;
  HeaderEx:TDDSHeaderEx;

  MipMapSize:DWORD;
  PixelFormat:TPIXEL_FORMAT;
  PixelSize:DWORD;

  IsAlphaFormat:BOOLEAN;
begin
  Result:=False;

  if not ffOpen(FFile,FileName) then
  Exit;

  if ffRead(FFile,Header,SizeOf(TDDSHeader)) <> SizeOf(TDDSHeader) then
  Exit;

  if Header.Marker <> DDSMarker then
  Exit;
(*
  // Required flags in every dds file
  if (Header.Flags and DDSD_CAPS) = 0 then
  Exit;

  if (Header.Flags and DDSD_HEIGHT) = 0 then
  Exit;

  if (Header.Flags and DDSD_WIDTH) = 0 then
  Exit;

  if (Header.Flags and DDSD_PIXELFORMAT) = 0 then
  Exit;
*)

  IsAlphaFormat:=(Header.PixelFormat.Flags and DDPF_ALPHAPIXELS) = DDPF_ALPHAPIXELS;

  PixelFormat:=PIXEL_FORMAT_UNKNOWN;
  case(Header.PixelFormat.Flags and DDPF_FOURCC) = DDPF_FOURCC of
    True:
    begin
      case Header.PixelFormat.FourCC of
        BC1Marker:
        begin
          PixelFormat:=PIXEL_FORMAT_BC1;
          MipMapSize:=AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4) div 2;
        end;
        BC2Marker:
        begin
          PixelFormat:=PIXEL_FORMAT_BC2;
          MipMapSize:=AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4);
        end;
        BC3Marker:
        begin
          PixelFormat:=PIXEL_FORMAT_BC3;
          MipMapSize:=AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4);
        end;
        BC4Marker:  // ATI1
        begin
          PixelFormat:=PIXEL_FORMAT_BC4;
          MipMapSize:=(AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4)) div 2;
        end;
        BC5Marker: // ATI2
        begin
          PixelFormat:=PIXEL_FORMAT_BC5;
          MipMapSize:=AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4)
        end;
        DX10Marker:
        begin
          case HeaderEx.DXGIFormat of
            DXGI_FORMAT_R32G32B32A32_FLOAT:
            begin
              PixelFormat:=PIXEL_FORMAT_R32G32B32A32F;
              MipMapSize:=(Header.Height * Header.Width) * 16;
            end;
            DXGI_FORMAT_R32G32B32A32_UINT:
            begin
              PixelFormat:=PIXEL_FORMAT_R32G32B32A32;
              MipMapSize:=(Header.Height * Header.Width) * 16;
            end;
            //=============================================
            DXGI_FORMAT_R32G32B32_FLOAT:
            begin
              PixelFormat:=PIXEL_FORMAT_R32G32B32F;
              MipMapSize:=(Header.Height * Header.Width) * 12;
            end;
            DXGI_FORMAT_R32G32B32_UINT:
            begin
              PixelFormat:=PIXEL_FORMAT_R32G32B32;
              MipMapSize:=(Header.Height * Header.Width) * 12;
            end;
            //=============================================
            DXGI_FORMAT_R16G16B16A16_FLOAT:
            begin
              PixelFormat:=PIXEL_FORMAT_R16G16B16F;
              MipMapSize:=(Header.Height * Header.Width) * 8;
            end;
            DXGI_FORMAT_R16G16B16A16_UNORM:
            begin
              PixelFormat:=PIXEL_FORMAT_R16G16B16;
              MipMapSize:=(Header.Height * Header.Width) * 8;
            end;
            //=============================================
            DXGI_FORMAT_R32G32_FLOAT:
            begin
              //PixelFormat:=PIXEL_FORMAT_R16G16B16;
              MipMapSize:=(Header.Height * Header.Width) * 8;
            end;
            DXGI_FORMAT_R32G32_UINT:
            begin
              //PixelFormat:=PIXEL_FORMAT_R16G16B16;
              MipMapSize:=(Header.Height * Header.Width) * 8;
            end;
            //=============================================
            DXGI_FORMAT_R8G8B8A8_UINT:
            begin
              PixelFormat:=PIXEL_FORMAT_R8G8B8A8;
              MipMapSize:=(Header.Height * Header.Width) * 4;
            end;
            //=============================================
            DXGI_FORMAT_R32_FLOAT:
            begin
              PixelFormat:=PIXEL_FORMAT_R32F;
              MipMapSize:=(Header.Height * Header.Width) * 4;
            end;
            DXGI_FORMAT_R32_UINT:
            begin
              PixelFormat:=PIXEL_FORMAT_R32;
              MipMapSize:=(Header.Height * Header.Width) * 4;
            end;
            //=============================================
            DXGI_FORMAT_BC1_UNORM:
            begin
              PixelFormat:=PIXEL_FORMAT_BC1;
              MipMapSize:=(AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4)) div 2;
            end;
            DXGI_FORMAT_BC2_UNORM:
            begin
              PixelFormat:=PIXEL_FORMAT_BC2;
              MipMapSize:=AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4);
            end;
            DXGI_FORMAT_BC3_UNORM:
            begin
              PixelFormat:=PIXEL_FORMAT_BC3;
              MipMapSize:=AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4);
            end;
            DXGI_FORMAT_BC4_UNORM:
            begin
              PixelFormat:=PIXEL_FORMAT_BC4;
              MipMapSize:=(AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4)) div 2;
            end;
            DXGI_FORMAT_BC5_UNORM:
            begin
              PixelFormat:=PIXEL_FORMAT_BC5;
              MipMapSize:=AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4);
            end;
          end; // case end
        end;
          else Exit;
      end; // case end
    end; // case true
    False:
    begin
      //bIsBCUsed:=False;
      case Header.PixelFormat.PixelSize of
        8:
        begin
          PixelFormat:=PIXEL_FORMAT_INDEX8;
          MipMapSize:=Header.Height * Header.Width;
        end;
        16:
        begin
          case Header.PixelFormat.RBitMask of
            $00000F00: // x R4 x x
            begin
              if Header.PixelFormat.GBitMask = $000000F0 then // x R4 G4 x
              begin
                if Header.PixelFormat.BBitMask = $0000000F then  // x R4 G4 B4
                begin
                  if IsAlphaFormat and (Header.PixelFormat.ABitMask = $0000F000) then
                  PixelFormat:=PIXEL_FORMAT_A4R4G4B4 else PixelFormat:=PIXEL_FORMAT_X4R4G4B4;
                end; // if BBitMask
              end; // if GBitMask
            end; // case

            $00007C00: // x R5 x x
            begin
              if Header.PixelFormat.GBitMask = $000003E0 then  // x R5 G5 x
              begin
                if Header.PixelFormat.BBitMask = $0000001F then  // x R5 G5 B5
                begin
                  if IsAlphaFormat and (Header.PixelFormat.ABitMask = $00008000) then
                  PixelFormat:=PIXEL_FORMAT_A1R5G5B5 else PixelFormat:=PIXEL_FORMAT_X1R5G5B5;
                end; // if BBitMask
              end; // if GBitMask
            end; // case

            $0000F800: // x R5 x x
            begin
              if Header.PixelFormat.GBitMask = $000007E0 then  // x R5 G6 x
              begin
                if Header.PixelFormat.BBitMask = $0000001F then  // x R5 G6 B5
                PixelFormat:=PIXEL_FORMAT_R5G6B5;
              end; // if GBitMask
            end; // case
          end; // case end

          MipMapSize:=(Header.Height * Header.Width) * 2;
        end;
        24:
        begin
          //PixelFormat:=PIXEL_FORMAT_R8G8B8;
          case Header.PixelFormat.RBitMask of
            $00FF0000: // x R8 x x
            begin
              if Header.PixelFormat.GBitMask  = $0000FF00 then    // x R8 G8 x
              begin
                if Header.PixelFormat.BBitMask = $000000FF then  // x R8 G8 B8
                PixelFormat:=PIXEL_FORMAT_R8G8B8;
              end; // if
            end; // case
            $000000FF: // x x x R8
            begin
              if Header.PixelFormat.GBitMask  = $0000FF00 then    // x x G8 R8
              begin
                if Header.PixelFormat.BBitMask = $00FF0000 then  // x B8 G8 R8
                PixelFormat:=PIXEL_FORMAT_B8G8R8;
              end; // if
            end; // case
          end; // case end
          MipMapSize:=(Header.Height * Header.Width) * 3;
        end;
        32:
        begin
          case Header.PixelFormat.RBitMask of
        //RGBA
            $FF000000: // R8 x x x
            begin
              if Header.PixelFormat.GBitMask  = $00FF0000 then    // R8 G8 x x
              begin
                if Header.PixelFormat.BBitMask = $0000FF00 then  // R8 G8 B8 x
                begin
                  if IsAlphaFormat and (Header.PixelFormat.ABitMask = $000000FF) then
                  PixelFormat:=PIXEL_FORMAT_R8G8B8A8 else PixelFormat:=PIXEL_FORMAT_R8G8B8X8;
                end; // if BBitMask
              end; // if
            end; // case
        //BGRA
            $0000FF00: // x x R8 x
            begin
              if Header.PixelFormat.GBitMask  = $00FF0000 then    // x G8 R8 x
              begin
                if Header.PixelFormat.BBitMask = $FF000000 then  // B8 G8 R8 x
                begin
                  if IsAlphaFormat and (Header.PixelFormat.ABitMask = $000000FF) then
                  PixelFormat:=PIXEL_FORMAT_B8G8R8A8 else PixelFormat:=PIXEL_FORMAT_B8G8R8X8;
                end; // if BBitMask
              end; // if
            end; // case
        //ARGB
            $00FF0000: // x R8 x x
            begin
              if Header.PixelFormat.GBitMask  = $0000FF00 then    // x R8 G8 x
              begin
                if Header.PixelFormat.BBitMask = $000000FF then  // x R8 G8 B8
                begin
                  if IsAlphaFormat and (Header.PixelFormat.ABitMask = $FF000000) then
                  PixelFormat:=PIXEL_FORMAT_A8R8G8B8 else PixelFormat:=PIXEL_FORMAT_X8R8G8B8;
                end; // if BBitMask
              end; // if
            end; // case
        //ABGR
            $000000FF: // x x x R8
            begin
              if Header.PixelFormat.GBitMask  = $0000FF00 then    // x x G8 R8
              begin
                if Header.PixelFormat.BBitMask = $00FF0000 then  // x B8 G8 R8
                begin
                  if IsAlphaFormat and (Header.PixelFormat.ABitMask = $FF000000) then
                  PixelFormat:=PIXEL_FORMAT_A8B8G8R8 else PixelFormat:=PIXEL_FORMAT_X8B8G8R8;
                end; // if BBitMask
              end; // if
            end; // case
          end; // case end
          MipMapSize:=(Header.Height * Header.Width) * 4;
        end;
          else Exit;
      end; // case end
    end; // case false
  end; // case end
  if PixelFormat = PIXEL_FORMAT_UNKNOWN then
  Exit;

  if MipMapSize = 0 then
  Exit;

  // Single DDS Texture
  if not InitImage(Image) then
  Exit;

  SetPixelFormatInfo(Image,PixelFormat);
  //Image^.PixelFormat:=PixelFormat;
  //Image^.Size:=MipMapSize;
  Image^.Width:=Header.Width;
  Image^.Height:=Header.Height;
  Image^.PixelSize:=Header.PixelFormat.PixelSize;

  //GetMem(Image^.Data,MipMapSize);
  if not InitImageData(Image,MipMapSize) then
  Exit;

  ffRead(FFile,Image^.Data^,MipMapSize);

  ffClose(FFile);
  Result:=True;
end;

// Function for complex DDS loading,output is modified TMultiVastImage type which can handle more important information about DDS images
function LoadDDSMultiImage(const FileName:PChar;var DDSMultiImage:PDDSMultiVastImage):Boolean;
var
  FFile:TVastFile;
  Header:TDDSHeader;
  HeaderEx:TDDSHeaderEx;

  Image:PVastImage;
  MipMapImage:PVastImage;

  bIsBCUsed:BOOLEAN;
  MinBCBlockSize:DWORD;

  MipMapSize:DWORD;
  PixelFormat:TPIXEL_FORMAT;
  PixelSize:DWORD;

  MipMapIndex:DWORD;
  MipMapCount:DWORD;

  MipMapWidth:DWORD;
  MipMapHeight:DWORD;

  ElementIndex:DWORD;
  ElementCount:DWORD;

  CubeFaceIndex:DWORD;
  CubeFaceCount:DWORD;

  DepthSliceIndex:DWORD;
  DepthSliceCount:DWORD;
  SurfaceFlags:DWORD;

  ImageCount:DWORD;
  IsAlphaFormat:BOOLEAN;
begin
  Result:=False;
  //if not IsFileExists(FileName) then
  //Exit;

  //AssignFile(FFile,FileName);
  //Reset(FFile);
  //BlockRead(FFile,Header,SizeOf(TDDSHeader));
  if not ffOpen(FFile,FileName) then
  Exit;

  if ffRead(FFile,Header,SizeOf(TDDSHeader)) <> SizeOf(TDDSHeader) then
  Exit;

  if Header.Marker <> DDSMarker then
  Exit;
(*
  // Required flags in every dds file
  if (Header.Flags and DDSD_CAPS) = 0 then
  Exit;

  if (Header.Flags and DDSD_HEIGHT) = 0 then
  Exit;

  if (Header.Flags and DDSD_WIDTH) = 0 then
  Exit;

  if (Header.Flags and DDSD_PIXELFORMAT) = 0 then
  Exit;
*)

  //MinBCBlockSize:=0;
  ElementCount:=1;

  if Header.MipMapCount > 1 then
  MipMapCount:=Header.MipMapCount else MipMapCount:=1;

  IsAlphaFormat:=(Header.PixelFormat.Flags and DDPF_ALPHAPIXELS) = DDPF_ALPHAPIXELS;

  SurfaceFlags:=0;
  PixelFormat:=PIXEL_FORMAT_UNKNOWN;
  case (Header.PixelFormat.Flags and DDPF_FOURCC) = DDPF_FOURCC of
    True:
    begin
      case Header.PixelFormat.FourCC of
        BC1Marker:
        begin
          bIsBCUsed:=True;
          SurfaceFlags:=DDSF_FOURCC or DDSF_BCFORMAT;
          MinBCBlockSize:=8;
          PixelFormat:=PIXEL_FORMAT_BC1;
          MipMapSize:=AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4) div 2;
        end;
        BC2Marker:
        begin
          bIsBCUsed:=True;
          SurfaceFlags:=DDSF_FOURCC or DDSF_BCFORMAT;
          MinBCBlockSize:=16;
          PixelFormat:=PIXEL_FORMAT_BC2;
          MipMapSize:=AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4);
        end;
        BC3Marker:
        begin
          bIsBCUsed:=True;
          SurfaceFlags:=DDSF_FOURCC or DDSF_BCFORMAT;
          MinBCBlockSize:=16;
          PixelFormat:=PIXEL_FORMAT_BC3;
          MipMapSize:=AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4);
        end;
        BC4Marker:  // ATI1
        begin
          bIsBCUsed:=True;
          SurfaceFlags:=DDSF_FOURCC or DDSF_BCFORMAT;
          MinBCBlockSize:=8;
          PixelFormat:=PIXEL_FORMAT_BC4;
          MipMapSize:=(AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4)) div 2;
        end;
        BC5Marker: // ATI2
        begin
          bIsBCUsed:=True;
          SurfaceFlags:=DDSF_FOURCC or DDSF_BCFORMAT;
          MinBCBlockSize:=16;
          PixelFormat:=PIXEL_FORMAT_BC5;
          MipMapSize:=AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4)
        end;
        DX10Marker:
        begin
          //BlockRead(FFile,HeaderEx,SizeOf(TDDSHeaderEx));
          ffRead(FFile,HeaderEx,SizeOf(TDDSHeaderEx));
          if HeaderEx.ArraySize > 1 then
          ElementCount:=HeaderEx.ArraySize;
          case HeaderEx.DXGIFormat of
            DXGI_FORMAT_R32G32B32A32_FLOAT:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_R32G32B32A32F;
              MipMapSize:=(Header.Height * Header.Width) * 16;
            end;
            DXGI_FORMAT_R32G32B32A32_UINT:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_R32G32B32A32;
              MipMapSize:=(Header.Height * Header.Width) * 16;
            end;
            //=============================================
            DXGI_FORMAT_R32G32B32_FLOAT:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_R32G32B32F;
              MipMapSize:=(Header.Height * Header.Width) * 12;
            end;
            DXGI_FORMAT_R32G32B32_UINT:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_R32G32B32;
              MipMapSize:=(Header.Height * Header.Width) * 12;
            end;
            //=============================================
            DXGI_FORMAT_R16G16B16A16_FLOAT:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_R16G16B16A16F;
              MipMapSize:=(Header.Height * Header.Width) * 8;
            end;
            DXGI_FORMAT_R16G16B16A16_UINT:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_R16G16B16A16;
              MipMapSize:=(Header.Height * Header.Width) * 8;
            end;
            //=============================================
            DXGI_FORMAT_R32G32_FLOAT:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_R32G32F;
              MipMapSize:=(Header.Height * Header.Width) * 8;
            end;
            DXGI_FORMAT_R32G32_UINT:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_R32G32;
              MipMapSize:=(Header.Height * Header.Width) * 8;
            end;
            //=============================================
            DXGI_FORMAT_R8G8B8A8_UINT:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_R8G8B8A8;
              MipMapSize:=(Header.Height * Header.Width) * 4;
            end;
            //=============================================
            DXGI_FORMAT_R16G16_FLOAT:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_R16G16F;
              MipMapSize:=(Header.Height * Header.Width) * 4;
            end;
            //=============================================
            DXGI_FORMAT_R16G16_UINT:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_R16G16F;
              MipMapSize:=(Header.Height * Header.Width) * 4;
            end;
            //=============================================
            DXGI_FORMAT_R32_FLOAT:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_R32F;
              MipMapSize:=(Header.Height * Header.Width) * 4;
            end;
            //=============================================
            DXGI_FORMAT_R32_UINT:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_R32;
              MipMapSize:=(Header.Height * Header.Width) * 4;
            end;
            //=============================================
            DXGI_FORMAT_R8G8_UINT:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_R8G8;
              MipMapSize:=(Header.Height * Header.Width) * 2;
            end;
            //=============================================
            DXGI_FORMAT_R16_FLOAT:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_R16F;
              MipMapSize:=(Header.Height * Header.Width) * 2;
            end;
            //=============================================
            DXGI_FORMAT_R16_UINT:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_R16;
              MipMapSize:=(Header.Height * Header.Width) * 2;
            end;
            //=============================================
            DXGI_FORMAT_R8_UINT:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_R8;
              MipMapSize:=(Header.Height * Header.Width);
            end;
            //=============================================
            DXGI_FORMAT_BC1_UNORM:
            begin
              bIsBCUsed:=True;
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT or DDSF_BCFORMAT;
              MinBCBlockSize:=8;
              PixelFormat:=PIXEL_FORMAT_BC1;
              MipMapSize:=(AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4)) div 2;
            end;
            //=============================================
            DXGI_FORMAT_BC2_UNORM:
            begin
              bIsBCUsed:=True;
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT or DDSF_BCFORMAT;
              MinBCBlockSize:=16;
              PixelFormat:=PIXEL_FORMAT_BC2;
              MipMapSize:=AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4);
            end;
            //=============================================
            DXGI_FORMAT_BC3_UNORM:
            begin
              bIsBCUsed:=True;
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT or DDSF_BCFORMAT;
              MinBCBlockSize:=16;
              PixelFormat:=PIXEL_FORMAT_BC3;
              MipMapSize:=AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4);
            end;
            //=============================================
            DXGI_FORMAT_BC4_UNORM:
            begin
              bIsBCUsed:=True;
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT or DDSF_BCFORMAT;
              MinBCBlockSize:=8;
              PixelFormat:=PIXEL_FORMAT_BC4;
              MipMapSize:=(AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4)) div 2;
            end;
            //=============================================
            DXGI_FORMAT_BC5_UNORM:
            begin
              bIsBCUsed:=True;
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT or DDSF_BCFORMAT;
              MinBCBlockSize:=16;
              PixelFormat:=PIXEL_FORMAT_BC5;
              MipMapSize:=AlignImageDim(Header.Height,4) * AlignImageDim(Header.Width,4);
            end;
            //=============================================
            DXGI_FORMAT_B5G6R5_UNORM:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_B5G6R5;
              MipMapSize:=(Header.Height * Header.Width) * 2;
            end;
            //=============================================
            DXGI_FORMAT_B5G5R5A1_UNORM:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_B5G5R5A1;
              MipMapSize:=(Header.Height * Header.Width) * 2;
            end;
            //=============================================
            DXGI_FORMAT_B8G8R8A8_UNORM:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_B8G8R8A8;
              MipMapSize:=(Header.Height * Header.Width) * 4;
            end;
            //=============================================
            DXGI_FORMAT_B8G8R8X8_UNORM:
            begin
              SurfaceFlags:=DDSF_FOURCC or DDSF_DX10FORMAT;
              PixelFormat:=PIXEL_FORMAT_B8G8R8X8;
              MipMapSize:=(Header.Height * Header.Width) * 4;
            end;
          end; // case end
        end;
          else Exit;
      end; // case end
    end; // case true
    False:
    begin
      bIsBCUsed:=False;
      case Header.PixelFormat.PixelSize of
        8:
        begin
          PixelFormat:=PIXEL_FORMAT_INDEX8;
          MipMapSize:=Header.Height * Header.Width;
        end;
        16:
        begin
          case Header.PixelFormat.RBitMask of
            $00000F00: // x R4 x x
            begin
              if Header.PixelFormat.GBitMask = $000000F0 then // x R4 G4 x
              begin
                if Header.PixelFormat.BBitMask = $0000000F then  // x R4 G4 B4
                begin
                  if IsAlphaFormat and (Header.PixelFormat.ABitMask = $0000F000) then
                  PixelFormat:=PIXEL_FORMAT_A4R4G4B4 else PixelFormat:=PIXEL_FORMAT_X4R4G4B4;
                end; // if BBitMask
              end; // if GBitMask
            end; // case

            $00007C00: // x R5 x x
            begin
              if Header.PixelFormat.GBitMask = $000003E0 then  // x R5 G5 x
              begin
                if Header.PixelFormat.BBitMask = $0000001F then  // x R5 G5 B5
                begin
                  if IsAlphaFormat and (Header.PixelFormat.ABitMask = $00008000) then
                  PixelFormat:=PIXEL_FORMAT_A1R5G5B5 else PixelFormat:=PIXEL_FORMAT_X1R5G5B5;
                end; // if BBitMask
              end; // if GBitMask
            end; // case

            $0000F800: // x R5 x x
            begin
              if Header.PixelFormat.GBitMask = $000007E0 then  // x R5 G6 x
              begin
                if Header.PixelFormat.BBitMask = $0000001F then  // x R5 G6 B5
                PixelFormat:=PIXEL_FORMAT_R5G6B5;
              end; // if GBitMask
            end; // case
          end; // case end

          MipMapSize:=(Header.Height * Header.Width) * 2;
        end;
        24:
        begin
          //PixelFormat:=PIXEL_FORMAT_R8G8B8;
          case Header.PixelFormat.RBitMask of
            $00FF0000: // x R8 x x
            begin
              if Header.PixelFormat.GBitMask  = $0000FF00 then    // x R8 G8 x
              begin
                if Header.PixelFormat.BBitMask = $000000FF then  // x R8 G8 B8
                PixelFormat:=PIXEL_FORMAT_R8G8B8;
              end; // if
            end; // case
            $000000FF: // x x x R8
            begin
              if Header.PixelFormat.GBitMask  = $0000FF00 then    // x x G8 R8
              begin
                if Header.PixelFormat.BBitMask = $00FF0000 then  // x B8 G8 R8
                PixelFormat:=PIXEL_FORMAT_B8G8R8;
              end; // if
            end; // case
          end; // case end
          MipMapSize:=(Header.Height * Header.Width) * 3;
        end;
        32:
        begin
          case Header.PixelFormat.RBitMask of
        //RGBA
            $FF000000: // R8 x x x
            begin
              if Header.PixelFormat.GBitMask  = $00FF0000 then    // R8 G8 x x
              begin
                if Header.PixelFormat.BBitMask = $0000FF00 then  // R8 G8 B8 x
                begin
                  if IsAlphaFormat and (Header.PixelFormat.ABitMask = $000000FF) then
                  PixelFormat:=PIXEL_FORMAT_R8G8B8A8 else PixelFormat:=PIXEL_FORMAT_R8G8B8X8;
                end; // if BBitMask
              end; // if
            end; // case
        //BGRA
            $0000FF00: // x x R8 x
            begin
              if Header.PixelFormat.GBitMask  = $00FF0000 then    // x G8 R8 x
              begin
                if Header.PixelFormat.BBitMask = $FF000000 then  // B8 G8 R8 x
                begin
                  if IsAlphaFormat and (Header.PixelFormat.ABitMask = $000000FF) then
                  PixelFormat:=PIXEL_FORMAT_B8G8R8A8 else PixelFormat:=PIXEL_FORMAT_B8G8R8X8;
                end; // if BBitMask
              end; // if
            end; // case
        //ARGB
            $00FF0000: // x R8 x x
            begin
              if Header.PixelFormat.GBitMask  = $0000FF00 then    // x R8 G8 x
              begin
                if Header.PixelFormat.BBitMask = $000000FF then  // x R8 G8 B8
                begin
                  if IsAlphaFormat and (Header.PixelFormat.ABitMask = $FF000000) then
                  PixelFormat:=PIXEL_FORMAT_A8R8G8B8 else PixelFormat:=PIXEL_FORMAT_X8R8G8B8;
                end; // if BBitMask
              end; // if
            end; // case
        //ABGR
            $000000FF: // x x x R8
            begin
              if Header.PixelFormat.GBitMask  = $0000FF00 then    // x x G8 R8
              begin
                if Header.PixelFormat.BBitMask = $00FF0000 then  // x B8 G8 R8
                begin
                  if IsAlphaFormat and (Header.PixelFormat.ABitMask = $FF000000) then
                  PixelFormat:=PIXEL_FORMAT_A8B8G8R8 else PixelFormat:=PIXEL_FORMAT_X8B8G8R8;
                end; // if BBitMask
              end; // if
            end; // case
          end; // case end
          MipMapSize:=(Header.Height * Header.Width) * 4;
        end;
          else Exit;
      end; // case end
    end; // case false
  end; // case end

  if PixelFormat = PIXEL_FORMAT_UNKNOWN then
  Exit;

  if MipMapSize = 0 then
  Exit;

  if (Header.CapFlags[1] and DDSC_VOLUME) = DDSC_VOLUME then
  begin
    // Volume DDS Texture

    if (Header.Flags and DDSD_DEPTH) = 0 then
    Exit;

    if Header.Depth = 0 then
    Exit;

    // Get number of images per whole dds texture (slices and mipmaps)
    ImageCount:=0;
    DepthSliceCount:=Header.Depth;
    for MipMapIndex:=0 to MipMapCount - 1 do
    begin
      inc(ImageCount,DepthSliceCount);

      if DepthSliceCount > 1 then
      DepthSliceCount:= DepthSliceCount shr 1;
    end;

    if not InitDDSMultiImage(DDSMultiImage,ElementCount * ImageCount) then
    Exit;

    DDSMultiImage^.SurfaceFlags:=SurfaceFlags or DDSF_SURFACE_VOLUME;
    DDSMultiImage^.ElementCount:=ElementCount;
    DDSMultiImage^.MipMapCount:=MipMapCount;
    DDSMultiImage^.SliceCount:=Header.Depth;

    Image:=DDSMultiImage^.Image;
    //Image^.PixelFormat:=PixelFormat;
    SetPixelFormatInfo(Image,PixelFormat);
    Image^.Size:=MipMapSize;
    Image^.Width:=Header.Width;
    Image^.Height:=Header.Height;
    //Image^.PixelSize:=Header.PixelFormat.PixelSize;
    // Finally start of loading images
    MipMapImage:=Image;
    for ElementIndex:=0 to ElementCount - 1 do
    begin
      MipMapSize:=Image^.Size;
      MipMapWidth:=Image^.Width;
      MipMapHeight:=Image^.Height;
      DepthSliceCount:=Header.Depth;
      for MipMapIndex:=0 to MipMapCount - 1 do
      begin
        // Read number of slices defined in DepthSliceCount
        for DepthSliceIndex:=0 to DepthSliceCount - 1 do
        begin
          //MipMapImage^.PixelFormat:=Image^.PixelFormat;
          SetPixelFormatInfo(MipMapImage,PixelFormat);
          MipMapImage^.Size:=MipMapSize;
          MipMapImage^.Width:=MipMapWidth;
          MipMapImage^.Height:=MipMapHeight;
          //MipMapImage^.PixelSize:=Image^.PixelSize;

          //GetMem(MipMapImage^.Data,MipMapSize);
          //BlockRead(FFile,MipMapImage^.Data^,MipMapSize);
          if mAllocMem(MipMapImage^.Data,MipMapSize) then
          ffRead(FFile,MipMapImage^.Data^,MipMapSize);

          inc(MipMapImage);
        end; // for DepthSliceCount

        // This condition avoid next counting for nonexist mipmap
        if MipMapIndex < MipMapCount - 1 then
        begin
          // Update number of slices for next mipmap if exists
          if DepthSliceCount > 1 then
          DepthSliceCount:=DepthSliceCount shr 1;

          if bIsBCUsed then
          begin
            if MipMapSize > MinBCBlockSize then
            begin
              MipMapSize:=MipMapSize shr 2;
              MipMapWidth:=MipMapWidth shr 1;
              MipMapHeight:=MipMapHeight shr 1;
            end;
          end // case
            else
          begin
            MipMapSize:=MipMapSize shr 2;
            MipMapWidth:=MipMapWidth shr 1;
            MipMapHeight:=MipMapHeight shr 1;
          end; // case end
        end; // if
      end; // for MipMapCount
    end; // for ElementCount
  end
    else
  if (Header.CapFlags[1] and DDSC_CUBEMAP) = DDSC_CUBEMAP then
  begin
    // Cube DDS Texture

    // Check if any face is present
    if (Header.CapFlags[1] and $0000FC00) = 0 then
    Exit;

    // Get number of faces used in cube texture
    CubeFaceCount:=0;
    if (Header.CapFlags[1] and DDSC_POSITIVEX) > 0 then
    inc(CubeFaceCount);

    if (Header.CapFlags[1] and DDSC_NEGATIVEX) > 0 then
    inc(CubeFaceCount);

    if (Header.CapFlags[1] and DDSC_POSITIVEY) > 0 then
    inc(CubeFaceCount);

    if (Header.CapFlags[1] and DDSC_NEGATIVEY) > 0 then
    inc(CubeFaceCount);

    if (Header.CapFlags[1] and DDSC_POSITIVEZ) > 0 then
    inc(CubeFaceCount);

    if (Header.CapFlags[1] and DDSC_NEGATIVEZ) > 0 then
    inc(CubeFaceCount);
    // CubeFaceCount should be min 1 and max 6
    //if CubeFaceCount = 0 then
    //Exit;

    if not InitDDSMultiImage(DDSMultiImage,ElementCount * (CubeFaceCount * MipMapCount)) then
    Exit;

    DDSMultiImage^.SurfaceFlags:=SurfaceFlags or DDSF_SURFACE_CUBE;
    DDSMultiImage^.ElementCount:=ElementCount;
    DDSMultiImage^.MipMapCount:=MipMapCount;
    DDSMultiImage^.FaceFlags:=Header.CapFlags[1] and $0000FC00;
    DDSMultiImage^.FaceCount:=CubeFaceCount;

    Image:=DDSMultiImage^.Image;
    //Image^.PixelFormat:=PixelFormat;
    SetPixelFormatInfo(Image,PixelFormat);
    Image^.Size:=MipMapSize;
    Image^.Width:=Header.Width;
    Image^.Height:=Header.Height;
    //Image^.PixelSize:=Header.PixelFormat.PixelSize;

    MipMapImage:=Image;
    for ElementIndex:=0 to ElementCount - 1 do
    begin
      for CubeFaceIndex:=0 to CubeFaceCount - 1 do
      begin
        MipMapSize:=Image^.Size;
        MipMapWidth:=Image^.Width;
        MipMapHeight:=Image^.Height;
        for MipMapIndex:=0 to MipMapCount - 1 do
        begin
         // MipMapImage^.PixelFormat:=Image^.PixelFormat;
          SetPixelFormatInfo(MipMapImage,PixelFormat);
          MipMapImage^.Size:=MipMapSize;
          MipMapImage^.Width:=MipMapWidth;
          MipMapImage^.Height:=MipMapHeight;
          //MipMapImage^.PixelSize:=Image^.PixelSize;

          //GetMem(MipMapImage^.Data,MipMapSize);
          //BlockRead(FFile,MipMapImage^.Data^,MipMapSize);
          if mAllocMem(MipMapImage^.Data,MipMapSize) then
          ffRead(FFile,MipMapImage^.Data^,MipMapSize);
          // This condition avoid next counting for nonexist mipmap
          if MipMapIndex < MipMapCount - 1 then
          begin
            if bIsBCUsed then
            begin
              if MipMapSize > MinBCBlockSize then
              begin
                MipMapSize:=MipMapSize shr 2;
                MipMapWidth:=MipMapWidth shr 1;
                MipMapHeight:=MipMapHeight shr 1;
              end;
            end
              else
            begin
              MipMapSize:=MipMapSize shr 2;
              MipMapWidth:=MipMapWidth shr 1;
              MipMapHeight:=MipMapHeight shr 1;
            end; // case end
          end; // if
          inc(MipMapImage);
        end; // for MipMapCount
      end; // for CubeFaceCount
    end; // for ElementCount
  end
    else
  begin
    // Single DDS Texture

    if not InitDDSMultiImage(DDSMultiImage,ElementCount * MipMapCount) then
    Exit;

    DDSMultiImage^.SurfaceFlags:=SurfaceFlags or DDSF_SURFACE_SIMPLE;
    DDSMultiImage^.ElementCount:=ElementCount;
    DDSMultiImage^.MipMapCount:=MipMapCount;

    Image:=DDSMultiImage^.Image;
    //Image^.PixelFormat:=PixelFormat;
    SetPixelFormatInfo(Image,PixelFormat);
    Image^.Size:=MipMapSize;
    Image^.Width:=Header.Width;
    Image^.Height:=Header.Height;
    //Image^.PixelSize:=Header.PixelFormat.PixelSize;

    MipMapImage:=Image;
    //inc(MipMapImage); // Seek to next mipmap,so we skip image that we already
    for ElementIndex:=0 to ElementCount - 1 do
    begin
      MipMapSize:=Image^.Size;
      MipMapWidth:=Image^.Width;
      MipMapHeight:=Image^.Height;

      for MipMapIndex:=0 to MipMapCount - 1 do
      begin
        //CloneImageStruct(Image,MipMapImage);
        //MipMapImage^.PixelFormat:=Image^.PixelFormat;
        MipMapImage^.Size:=MipMapSize;
        MipMapImage^.Width:=MipMapWidth;
        MipMapImage^.Height:=MipMapHeight;
        //MipMapImage^.PixelSize:=Image^.PixelSize;

        //GetMem(MipMapImage^.Data,MipMapSize);
        //BlockRead(FFile,MipMapImage^.Data^,MipMapSize);
        if mAllocMem(MipMapImage^.Data,MipMapSize) then
        ffRead(FFile,MipMapImage^.Data^,MipMapSize);
        // This condition avoid next counting for nonexist mipmap
        if MipMapIndex < MipMapCount - 1 then
        begin
          if bIsBCUsed then
          begin
            if MipMapSize > MinBCBlockSize then
            begin
              MipMapSize:=MipMapSize shr 2;
              MipMapWidth:=MipMapWidth shr 1;
              MipMapHeight:=MipMapHeight shr 1;
            end;
          end
            else
          begin
            MipMapSize:=MipMapSize shr 2;
            MipMapWidth:=MipMapWidth shr 1;
            MipMapHeight:=MipMapHeight shr 1;
          end; // case end
        end; // if
        inc(MipMapImage);
      end; // for
    end; // for
  end; // else

  //CloseFile(FFile);
  ffClose(FFile);
  Result:=True;
end;


// Function for complex DDS loading,output is modified TMultiVastImage type which can handle more important information about DDS images
function SaveDDSMultiImage(const FileName:PChar;var DDSMultiImage:PDDSMultiVastImage):Boolean;
var
  FFile:TVastFile;
  Header:TDDSHeader;
  HeaderEx:TDDSHeaderEx;

  Image:PVastImage;
  MipMapImage:PVastImage;

  bIsBCUsed:BOOLEAN;
  MinBCBlockSize:DWORD;

  MipMapSize:DWORD;
  PixelFormat:TPIXEL_FORMAT;
  PixelSize:DWORD;

  MipMapIndex:DWORD;
  MipMapCount:DWORD;

  MipMapWidth:DWORD;
  MipMapHeight:DWORD;

  ElementIndex:DWORD;
  ElementCount:DWORD;

  CubeFaceIndex:DWORD;
  CubeFaceCount:DWORD;

  DepthSliceIndex:DWORD;
  DepthSliceCount:DWORD;

  //MipMapCount:DWORD;
  //ImageType:DWORD;
  ImageCount:DWORD;
  IsAlphaFormat:BOOLEAN;
begin
  Result:=False;

  if not IsMultiImageSet(PMultiVastImage(DDSMultiImage)) then
  Exit;

  if not ffCreate(FFile,FileName) then
  Exit;

  Image:=DDSMultiImage^.Image;
  EraseMem(Header,SizeOf(TDDSHeader));
  Header.Marker:=DDSMarker;
  Header.Size:=SizeOf(TDDSHeader) - $04; // Marker size

  // Required flags in every dds file
  Header.Flags:=DDSD_CAPS or DDSD_WIDTH or DDSD_HEIGHT or DDSD_PIXELFORMAT;
  // Now we get type of surface and set flags to dds image
  case (DDSMultiImage^.SurfaceFlags and $00000003) of
    DDSF_SURFACE_NONE: Exit;
    DDSF_SURFACE_SIMPLE:
    begin
      if DDSMultiImage^.MipMapCount > 1 then
      Header.CapFlags[0]:=DDSC_TEXTURE or DDSC_COMPLEX else Header.CapFlags[0]:=DDSC_TEXTURE;
    end;
    DDSF_SURFACE_CUBE:
    begin
      Header.CapFlags[0]:=DDSC_TEXTURE or DDSC_COMPLEX;
      Header.CapFlags[1]:=DDSC_CUBEMAP or DDSMultiImage^.FaceFlags;
    end;
    DDSF_SURFACE_VOLUME:
    begin
      Header.Flags:=Header.Flags or DDSD_DEPTH;
      Header.CapFlags[0]:=DDSC_TEXTURE or DDSC_COMPLEX;
      Header.CapFlags[1]:=DDSC_VOLUME;
    end;
  end; // case end

  if (DDSMultiImage^.SurfaceFlags and DDSF_BCFORMAT) > 0 then
  Header.Flags:= Header.Flags or DDSD_LINEARSIZE
  else Header.Flags:= Header.Flags or DDSD_PITCH;

  Header.Height:=Image^.Height;
  Header.Width:=Image^.Width;
  Header.LinearSize:=Image^.Size;
  Header.MipMapCount:=DDSMultiImage^.MipMapCount;
  if DDSMultiImage^.MipMapCount > 1 then
  begin
    Header.Flags:=Header.Flags or DDSD_MIPMAPCOUNT;
    Header.CapFlags[0]:= Header.CapFlags[0] or DDSC_MIPMAP;
  end;

  Header.PixelFormat.Size:=SizeOf(TDDPixelFormat);
  if (DDSMultiImage^.SurfaceFlags and DDSF_DX10FORMAT) > 0 then
  begin
    Header.PixelFormat.Flags:=DDPF_FOURCC;
    Header.PixelFormat.FourCC:=DX10Marker;
    //FillMem(DWORD(@HeaderEx),SizeOf(TDDSHeaderEx),$00);
    case Image^.PixelFormat of
      PIXEL_FORMAT_R32G32B32A32: HeaderEx.DXGIFormat:=DXGI_FORMAT_R32G32B32A32_UINT;
      PIXEL_FORMAT_R32G32B32A32F: HeaderEx.DXGIFormat:=DXGI_FORMAT_R32G32B32A32_FLOAT;
      PIXEL_FORMAT_R32G32B32F: HeaderEx.DXGIFormat:=DXGI_FORMAT_R32G32B32_FLOAT;
      PIXEL_FORMAT_R32G32B32: HeaderEx.DXGIFormat:=DXGI_FORMAT_R32G32B32_UINT;
      PIXEL_FORMAT_R16G16B16A16F: HeaderEx.DXGIFormat:=DXGI_FORMAT_R16G16B16A16_FLOAT;
      PIXEL_FORMAT_R16G16B16A16: HeaderEx.DXGIFormat:=DXGI_FORMAT_R16G16B16A16_UINT;
      PIXEL_FORMAT_R32G32F: HeaderEx.DXGIFormat:=DXGI_FORMAT_R32G32_FLOAT;
      PIXEL_FORMAT_R32G32: HeaderEx.DXGIFormat:=DXGI_FORMAT_R32G32_UINT;
      PIXEL_FORMAT_R8G8B8A8: HeaderEx.DXGIFormat:=DXGI_FORMAT_R8G8B8A8_UINT;
      PIXEL_FORMAT_R16G16F: HeaderEx.DXGIFormat:=DXGI_FORMAT_R16G16_FLOAT;
      PIXEL_FORMAT_R16G16: HeaderEx.DXGIFormat:=DXGI_FORMAT_R16G16_UINT;
      PIXEL_FORMAT_R32F:  HeaderEx.DXGIFormat:=DXGI_FORMAT_R32_FLOAT;
      PIXEL_FORMAT_R32: HeaderEx.DXGIFormat:=DXGI_FORMAT_R32_UINT;
      PIXEL_FORMAT_R8G8: HeaderEx.DXGIFormat:=DXGI_FORMAT_R8G8_UINT;
      PIXEL_FORMAT_R16F: HeaderEx.DXGIFormat:=DXGI_FORMAT_R16_FLOAT;
      PIXEL_FORMAT_R16: HeaderEx.DXGIFormat:=DXGI_FORMAT_R16_UINT;
      PIXEL_FORMAT_R8: HeaderEx.DXGIFormat:=DXGI_FORMAT_R8_UINT;
      PIXEL_FORMAT_BC1: HeaderEx.DXGIFormat:=DXGI_FORMAT_BC1_UNORM;
      PIXEL_FORMAT_BC2: HeaderEx.DXGIFormat:=DXGI_FORMAT_BC2_UNORM;
      PIXEL_FORMAT_BC3: HeaderEx.DXGIFormat:=DXGI_FORMAT_BC3_UNORM;
      PIXEL_FORMAT_BC4: HeaderEx.DXGIFormat:=DXGI_FORMAT_BC4_UNORM;
      PIXEL_FORMAT_BC5: HeaderEx.DXGIFormat:=DXGI_FORMAT_BC5_UNORM;
      PIXEL_FORMAT_B5G6R5: HeaderEx.DXGIFormat:=DXGI_FORMAT_B5G6R5_UNORM;
      PIXEL_FORMAT_B5G5R5A1: HeaderEx.DXGIFormat:=DXGI_FORMAT_B5G5R5A1_UNORM;
      PIXEL_FORMAT_B8G8R8A8: HeaderEx.DXGIFormat:=DXGI_FORMAT_B8G8R8A8_UNORM;
      PIXEL_FORMAT_B8G8R8X8: HeaderEx.DXGIFormat:=DXGI_FORMAT_B8G8R8X8_UNORM;
    end; // case end
    HeaderEx.ResDimension:=$00;
    HeaderEx.MiscFlag:=$00;
    HeaderEx.ArraySize:= DDSMultiImage^.ElementCount;
    HeaderEx.Reserved:=$00;
    // Write headers to file
    ffWrite(FFile,Header,SizeOf(TDDSHeader));
    ffWrite(FFile,HeaderEx,SizeOf(TDDSHeaderEx));
  end
    else
  begin
    if (DDSMultiImage^.SurfaceFlags and DDSF_BCFORMAT) > 0 then
    begin
      Header.PixelFormat.Flags:=DDPF_FOURCC;
      case Image^.PixelFormat of
        PIXEL_FORMAT_BC1: Header.PixelFormat.FourCC:= BC1Marker;
        PIXEL_FORMAT_BC2: Header.PixelFormat.FourCC:= BC2Marker;
        PIXEL_FORMAT_BC3: Header.PixelFormat.FourCC:= BC3Marker;
        PIXEL_FORMAT_BC4: Header.PixelFormat.FourCC:= BC4Marker;
        PIXEL_FORMAT_BC5: Header.PixelFormat.FourCC:= BC5Marker;
      end; // case end
    end
      else
    begin
      Header.PixelFormat.PixelSize:=Image^.PixelSize;
      case Image^.PixelFormat of
        //PIXEL_FORMAT_GRAY8:
        PIXEL_FORMAT_A4R4G4B4:
        begin
          Header.PixelFormat.Flags:= DDPF_RGB or DDPF_ALPHAPIXELS;
          Header.PixelFormat.RBitMask:=$00000F00;
          Header.PixelFormat.GBitMask:=$000000F0;
          Header.PixelFormat.BBitMask:=$0000000F;
          Header.PixelFormat.ABitMask:=$0000F000;
        end;
        PIXEL_FORMAT_X4R4G4B4:
        begin
          Header.PixelFormat.Flags:= DDPF_RGB;
          Header.PixelFormat.RBitMask:=$00000F00;
          Header.PixelFormat.GBitMask:=$000000F0;
          Header.PixelFormat.BBitMask:=$0000000F;
        end;
        PIXEL_FORMAT_A1R5G5B5:
        begin
          Header.PixelFormat.Flags:= DDPF_RGB or DDPF_ALPHAPIXELS;
          Header.PixelFormat.RBitMask:=$00007C00;
          Header.PixelFormat.GBitMask:=$000003E0;
          Header.PixelFormat.BBitMask:=$0000001F;
          Header.PixelFormat.ABitMask:=$00008000;
        end;
        PIXEL_FORMAT_X1R5G5B5:
        begin
          Header.PixelFormat.Flags:= DDPF_RGB;
          Header.PixelFormat.RBitMask:=$00007C00;
          Header.PixelFormat.GBitMask:=$000003E0;
          Header.PixelFormat.BBitMask:=$0000001F;
        end;
        PIXEL_FORMAT_R8G8B8:
        begin
          Header.PixelFormat.Flags:= DDPF_RGB;
          Header.PixelFormat.RBitMask:=$00FF0000;
          Header.PixelFormat.GBitMask:=$0000FF00;
          Header.PixelFormat.BBitMask:=$000000FF;
        end;
        PIXEL_FORMAT_B8G8R8:
        begin
          Header.PixelFormat.Flags:= DDPF_RGB;
          Header.PixelFormat.RBitMask:=$000000FF;
          Header.PixelFormat.GBitMask:=$0000FF00;
          Header.PixelFormat.BBitMask:=$00FF0000;
        end;
        PIXEL_FORMAT_R8G8B8A8:
        begin
          Header.PixelFormat.Flags:= DDPF_RGB or DDPF_ALPHAPIXELS;
          Header.PixelFormat.RBitMask:=$FF000000;
          Header.PixelFormat.GBitMask:=$00FF0000;
          Header.PixelFormat.BBitMask:=$0000FF00;
          Header.PixelFormat.ABitMask:=$000000FF;
        end;
        PIXEL_FORMAT_R8G8B8X8:
        begin
          Header.PixelFormat.Flags:= DDPF_RGB;
          Header.PixelFormat.RBitMask:=$FF000000;
          Header.PixelFormat.GBitMask:=$00FF0000;
          Header.PixelFormat.BBitMask:=$0000FF00;
        end;
        PIXEL_FORMAT_B8G8R8A8:
        begin
          Header.PixelFormat.Flags:= DDPF_RGB or DDPF_ALPHAPIXELS;
          Header.PixelFormat.RBitMask:=$0000FF00;
          Header.PixelFormat.GBitMask:=$00FF0000;
          Header.PixelFormat.BBitMask:=$FF000000;
          Header.PixelFormat.ABitMask:=$000000FF;
        end;
        PIXEL_FORMAT_B8G8R8X8:
        begin
          Header.PixelFormat.Flags:= DDPF_RGB;
          Header.PixelFormat.RBitMask:=$0000FF00;
          Header.PixelFormat.GBitMask:=$00FF0000;
          Header.PixelFormat.BBitMask:=$FF000000;
        end;
        PIXEL_FORMAT_A8R8G8B8:
        begin
          Header.PixelFormat.Flags:= DDPF_RGB or DDPF_ALPHAPIXELS;
          Header.PixelFormat.RBitMask:=$00FF0000;
          Header.PixelFormat.GBitMask:=$0000FF00;
          Header.PixelFormat.BBitMask:=$000000FF;
          Header.PixelFormat.ABitMask:=$FF000000;
        end;
        PIXEL_FORMAT_X8R8G8B8:
        begin
          Header.PixelFormat.Flags:= DDPF_RGB;
          Header.PixelFormat.RBitMask:=$00FF0000;
          Header.PixelFormat.GBitMask:=$0000FF00;
          Header.PixelFormat.BBitMask:=$000000FF;
        end;
        PIXEL_FORMAT_A8B8G8R8:
        begin
          Header.PixelFormat.Flags:= DDPF_RGB or DDPF_ALPHAPIXELS;
          Header.PixelFormat.RBitMask:=$000000FF;
          Header.PixelFormat.GBitMask:=$0000FF00;
          Header.PixelFormat.BBitMask:=$00FF0000;
          Header.PixelFormat.ABitMask:=$FF000000;
        end;
        PIXEL_FORMAT_X8B8G8R8:
        begin
          Header.PixelFormat.Flags:= DDPF_RGB;
          Header.PixelFormat.RBitMask:=$000000FF;
          Header.PixelFormat.GBitMask:=$0000FF00;
          Header.PixelFormat.BBitMask:=$00FF0000;
        end;
      end // case end
    end; // if
    // Write header to file
    ffWrite(FFile,Header,SizeOf(TDDSHeader));
  end;

  if DDSMultiImage^.ImageCount <> 0 then
  begin
    for ElementIndex:=0 to DDSMultiImage^.ImageCount - 1 do
    begin
      ffWriteCached(FFile,Image^.Data^,Image^.Size);
      Inc(Image);
    end;
    ffClose(FFile);
    Result:=True;
    Exit;
  end;

  case (DDSMultiImage^.SurfaceFlags and $00000003) of
    DDSF_SURFACE_SIMPLE:
    begin
      for ElementIndex:=0 to DDSMultiImage^.ElementCount - 1 do
      begin
        for MipMapIndex:=0 to DDSMultiImage^.MipMapCount - 1 do
        begin
          ffWriteCached(FFile,Image^.Data^,Image^.Size);
          Inc(Image);
        end;
      end;
    end;
    DDSF_SURFACE_CUBE:
    begin
      for ElementIndex:=0 to DDSMultiImage^.ElementCount - 1 do
      begin
        for CubeFaceIndex:=0 to DDSMultiImage^.FaceCount - 1 do
        begin
          for MipMapIndex:=0 to DDSMultiImage^.MipMapCount - 1 do
          begin
            ffWriteCached(FFile,Image^.Data^,Image^.Size);
            Inc(Image);
          end; // for MipMapIndex
        end; // for CubeFaceIndex
      end; // for ElementIndex
    end;
    DDSF_SURFACE_VOLUME:
    begin
      for ElementIndex:=0 to DDSMultiImage^.ElementCount - 1 do
      begin
        for MipMapIndex:=0 to DDSMultiImage^.MipMapCount - 1 do
        begin
          for DepthSliceIndex:=0 to DDSMultiImage^.SliceCount - 1 do
          begin
            ffWriteCached(FFile,Image^.Data^,Image^.Size);
            Inc(Image);
          end; // for DepthSliceIndex
        end; // for MipMapIndex
      end; // for ElementIndex
    end;   // case
  end; // case end
  ffClose(FFile);
  Result:=True;
end;


end.
