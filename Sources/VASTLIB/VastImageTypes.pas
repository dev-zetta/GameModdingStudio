unit VastImageTypes;

interface

type
  DWORD = Cardinal;
  PDWORD = ^DWORD;  

  QWORD = Int64;
  PQWORD = ^QWORD;

  TRGB24Pixel = Packed Record
    R:BYTE;
    G:BYTE;
    B:BYTE;
  end;
  PRGB24Pixel = ^TRGB24Pixel;

  TRGB24PixelArray = Array of TRGB24Pixel;
  PRGB24PixelArray = ^TRGB24PixelArray;

  TRGBA32Pixel = Packed Record
    R:BYTE;
    G:BYTE;
    B:BYTE;
    A:BYTE;
  end;
  PRGBA32Pixel = ^TRGBA32Pixel;

  TRGBA32PixelArray = Array of TRGBA32Pixel;
  PRGBA32PixelArray = ^TRGBA32PixelArray;
////////////////////////////////////////////////////////////////
  TBGR24Pixel = Packed Record
    B:BYTE;
    G:BYTE;
    R:BYTE;
  end;
  PBGR24Pixel = ^TBGR24Pixel;

  TBGR24PixelArray = Array of TBGR24Pixel;
  PBGR24PixelArray = ^TBGR24PixelArray;

  TBGRA32Pixel = Packed Record
    B:BYTE;
    G:BYTE;
    R:BYTE;
    A:BYTE;
  end;
  PBGRA32Pixel = ^TBGRA32Pixel;

  TBGRA32PixelArray = Array of TBGRA32Pixel;
  PBGRA32PixelArray = ^TBGRA32PixelArray;

  TPIXEL_FORMAT = (
    PIXEL_FORMAT_UNKNOWN        = 0,
    // Formats with 1 or 2 channels only
    PIXEL_FORMAT_INDEX1         = 10,
    PIXEL_FORMAT_INDEX8         = 11,

    PIXEL_FORMAT_A1             = 20,
    PIXEL_FORMAT_A2             = 21,
    PIXEL_FORMAT_A4             = 22,
    PIXEL_FORMAT_A8             = 23,
    PIXEL_FORMAT_A10            = 24,
    PIXEL_FORMAT_A16            = 25,
    PIXEL_FORMAT_A32            = 26,

    // 3 and 4 channel formats

    PIXEL_FORMAT_B5G6R5         = 30,
    PIXEL_FORMAT_R5G6B5         = 31,

    PIXEL_FORMAT_A4R4G4B4       = 32,
    PIXEL_FORMAT_X4R4G4B4       = 33,
    PIXEL_FORMAT_A4B4G4R4       = 34,
    PIXEL_FORMAT_X4B4G4R4       = 35,

    PIXEL_FORMAT_R4G4B4A4       = 36,
    PIXEL_FORMAT_R4G4B4X4       = 37,
    PIXEL_FORMAT_B4G4R4A4       = 38,
    PIXEL_FORMAT_B4G4R4X4       = 39,

    PIXEL_FORMAT_A1R5G5B5       = 40,
    PIXEL_FORMAT_X1R5G5B5       = 41,
    PIXEL_FORMAT_A1B5G5R5       = 42,
    PIXEL_FORMAT_X1B5G5R5       = 43,

    PIXEL_FORMAT_R5G5B5A1       = 44,
    PIXEL_FORMAT_R5G5B5X1       = 45,
    PIXEL_FORMAT_B5G5R5A1       = 46,
    PIXEL_FORMAT_B5G5R5X1       = 47,

    // 8 bits per channel
    PIXEL_FORMAT_R8             = 60,
    PIXEL_FORMAT_R8F            = 61,

    PIXEL_FORMAT_R8G8           = 62,
    PIXEL_FORMAT_R8G8F          = 63,

    PIXEL_FORMAT_R8G8B8         = 64,
    PIXEL_FORMAT_B8G8R8         = 65,

    PIXEL_FORMAT_R8G8B8A8       = 66,
    PIXEL_FORMAT_R8G8B8X8       = 67,

    PIXEL_FORMAT_B8G8R8A8       = 68,
    PIXEL_FORMAT_B8G8R8X8       = 69,

    PIXEL_FORMAT_A8R8G8B8       = 70,
    PIXEL_FORMAT_X8R8G8B8       = 71,

    PIXEL_FORMAT_A8B8G8R8       = 72,
    PIXEL_FORMAT_X8B8G8R8       = 73,

    // 16 bits per channel
    PIXEL_FORMAT_R16            = 90,
    PIXEL_FORMAT_R16F           = 91,

    PIXEL_FORMAT_R16G16         = 92,
    PIXEL_FORMAT_R16G16F        = 93,

    PIXEL_FORMAT_R16G16B16      = 94,
    PIXEL_FORMAT_R16G16B16F     = 95,
    PIXEL_FORMAT_B16G16R16      = 96,
    PIXEL_FORMAT_B16G16R16F     = 97,

    PIXEL_FORMAT_R16G16B16A16   = 98,
    PIXEL_FORMAT_R16G16B16A16F  = 99,
    PIXEL_FORMAT_R16G16B16X16   = 100,
    PIXEL_FORMAT_R16G16B16X16F  = 101,

    PIXEL_FORMAT_B16G16R16A16   = 102,
    PIXEL_FORMAT_B16G16R16A16F  = 103,
    PIXEL_FORMAT_B16G16R16X16   = 104,
    PIXEL_FORMAT_B16G16R16X16F  = 105,

    PIXEL_FORMAT_A16R16G16B16   = 106,
    PIXEL_FORMAT_A16R16G16B16F  = 107,
    PIXEL_FORMAT_X16R16G16B16   = 108,
    PIXEL_FORMAT_X16R16G16B16F  = 109,

    PIXEL_FORMAT_A16B16G16R16   = 110,
    PIXEL_FORMAT_A16B16G16R16F  = 111,
    PIXEL_FORMAT_X16B16G16R16   = 112,
    PIXEL_FORMAT_X16B16G16R16F  = 113,

    // 32 bits per channel
    PIXEL_FORMAT_R32            = 120,
    PIXEL_FORMAT_R32F           = 121,
    PIXEL_FORMAT_R32G32         = 122,
    PIXEL_FORMAT_R32G32F        = 123,

    PIXEL_FORMAT_R32G32B32      = 124,
    PIXEL_FORMAT_R32G32B32F     = 125,
    PIXEL_FORMAT_B32G32R32      = 126,
    PIXEL_FORMAT_B32G32R32F     = 127,

    PIXEL_FORMAT_R32G32B32A32   = 128,
    PIXEL_FORMAT_R32G32B32A32F  = 129,
    PIXEL_FORMAT_R32G32B32X32   = 130,
    PIXEL_FORMAT_R32G32B32X32F  = 131,

    PIXEL_FORMAT_B32G32R32A32   = 132,
    PIXEL_FORMAT_B32G32R32A32F  = 133,
    PIXEL_FORMAT_B32G32R32X32   = 134,
    PIXEL_FORMAT_B32G32R32X32F  = 135,

    PIXEL_FORMAT_A32R32G32B32   = 136,
    PIXEL_FORMAT_A32R32G32B32F  = 137,
    PIXEL_FORMAT_X32R32G32B32   = 138,
    PIXEL_FORMAT_X32R32G32B32F  = 139,

    PIXEL_FORMAT_A32B32G32R32   = 140,
    PIXEL_FORMAT_A32B32G32R32F  = 141,
    PIXEL_FORMAT_X32B32G32R32   = 142,
    PIXEL_FORMAT_X32B32G32R32F  = 143,

    // Block Compression
    PIXEL_FORMAT_BC1            = 240,
    PIXEL_FORMAT_BC2            = 241,
    PIXEL_FORMAT_BC3            = 242,
    PIXEL_FORMAT_BC4            = 243,
    PIXEL_FORMAT_BC5            = 244,

    // Special
    PIXEL_FORMAT_R6A2G6A2B6A2   = 270
  );

  TAlphaPixelTable = Array[0..255] of DWORD;
  PAlphaPixelTable = ^TAlphaPixelTable;

  TVastImage = Packed Record
    PixelFormat:TPIXEL_FORMAT;
    Data:Pointer;
    Size:DWORD;
    Width:DWORD;
    Height:DWORD;
    PixelSize:DWORD; // In bits
    PixelCount:DWORD;
    ScanLineSize:DWORD;
    ChannelCount:DWORD;

    IsAlphaFormat:Boolean;
    IsFloatFormat:Boolean;
    IsPixelAligned:Boolean;
    RedPos:DWORD;
    GreenPos:DWORD;
    BluePos:DWORD;
    AlphaPos:DWORD;

    IsAlphaTested:Boolean; // If image was already tested if has any alpha information
    IsAlphaIncluded:Boolean; // If image has any alpha information
    //mAlphaPixelTable:PAlphaPixelTable; // Number of pixels that has a alpha information $FF
    AlphaPixelCount:DWORD; // Number of pixels that has a alpha information $FF
  end;
  PVastImage = ^TVastImage;

  TMultiVastImage = Packed Record
    Image:PVastImage;
    ImageCount:DWORD;
    TotalSize:DWORD;
  end;
  PMultiVastImage = ^TMultiVastImage;

(*
  TImgComHeader = Packed Record
    dwMarker:DWORD;
    dwSize:DWORD;
    dwType:DWORD;
    dwWidth:DWORD;
    dwHeight:DWORD;
    dwPixelSize:DWORD;
  end;
  PImgComHeader = ^TImgComHeader;

  TImgComExHeader = Packed Record
    dwMarker:DWORD;
    dwSize:DWORD;
    dwBlockCount:DWORD;
    dwIndexSize:DWORD;
  end;
  PImgComExHeader = ^TImgComExHeader;

  TImageBlockInfo = Packed Record
    dwIndex:DWORD;
    dwType:DWORD;
    dwCheckSum:DWORD;
    dwRepeatCount:DWORD;
    dwData:DWORD;
  end;
  PImageBlockInfo = ^TImageBlockInfo;

  TImageBlockInfoArray = Array[0..0] of TImageBlockInfo;
  PImageBlockInfoArray = ^TImageBlockInfoArray;
*)
implementation

end.
