unit FastDDSLoader;

interface

implementation

const
  // DDS Magic and DXT compression IDs
  ffDDSID=LongWord(Byte('D') or (Byte('D') shl 8) or (Byte('S') shl 16) or (Byte(' ') shl 24));
  ffDXT1ID=LongWord(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('1') shl 24));
  ffDXT3ID=LongWord(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('3') shl 24));
  ffDXT5ID=LongWord(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('5') shl 24));
  //http://www.koders.com/cpp/fid0641587A4DA23569ED3F21C8CE41723BEDA2251D.aspx?s=3DC+header#L66
  ffATI1ID=LongWord(Byte('A') or (Byte('T') shl 8) or (Byte('I') shl 16) or (Byte('1') shl 24));
  ffATI2ID=LongWord(Byte('A') or (Byte('T') shl 8) or (Byte('I') shl 16) or (Byte('2') shl 24));
  ffDX10ID=LongWord(Byte('D') or (Byte('X') shl 8) or (Byte('1') shl 16) or (Byte('0') shl 24));
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
    DXGI_FORMAT_B8G8R8X8_UNORM = 88);
    //DXGI_FORMAT_FORCE_UINT = 0xffffffffUL

  TD3D10_RESOURCE_DIMENSION = (
    D3D10_RESOURCE_DIMENSION_UNKNOWN = 0,
    D3D10_RESOURCE_DIMENSION_BUFFER = 1,
    D3D10_RESOURCE_DIMENSION_TEXTURE1D = 2,
    D3D10_RESOURCE_DIMENSION_TEXTURE2D = 3,
    D3D10_RESOURCE_DIMENSION_TEXTURE3D = 4);

  TD3D10_RESOURCE_MISC_FLAG = (
    D3D10_RESOURCE_MISC_GENERATE_MIPS = $01,
    D3D10_RESOURCE_MISC_SHARED = $02,
    D3D10_RESOURCE_MISC_TEXTURECUBE = $04);

  TDDS10Header = Packed Record
    DXGI_Format:TDXGI_FORMAT;
    ResDimension:TD3D10_RESOURCE_DIMENSION;
    MiscFlag:LongWord;
    ArraySize:LongWord;
    Reserved:LongWord;
  end;

  TDDS09Header = Packed Record
    ID: LongWord;
    // Surface desc
    SSize: LongWord;       // Size of the structure = 124 Bytes
    SFlags: LongWord;      // Flags to indicate valid fields
    Height: LongWord;     // Height of the main image in pixels
    Width: LongWord;      // Width of the main image in pixels
    PitchOrLinearSize: LongWord; // For uncomp formats number of bytes per // scanline. For comp it is the size in // bytes of the main image
    Depth: LongWord;      // Only for volume text depth of the volume
    MipMaps: LongWord;     // Total number of levels in the mipmap chain
    Reserved: array[0..43] of Byte; // Reserved
    //Pixel Format
    PSize: LongWord;       // Size of the structure = 32 bytes
    PFlags: LongWord;      // Flags to indicate valid fields
    FourCC: LongWord;     // Four-char code for compressed textures (DXT)
    BitCount: LongWord;   // Bits per pixel if uncomp. usually 16,24 or 32
    RedMask: LongWord;    // Bit mask for the Red component
    GreenMask: LongWord;  // Bit mask for the Green component
    BlueMask: LongWord;   // Bit mask for the Blue component
    AlphaMask: LongWord;  // Bit mask for the Alpha component
    // Caps
    Caps1: LongWord;      // Should always include DDSCAPS_TEXTURE
    Caps2: LongWord;      // For cubic environment maps
    Caps3: LongWord;
    Caps4: LongWord;
    TextureStage:LongWord;  // Reserved
  end;

end.
