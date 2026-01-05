unit SharedHeaders;

interface

uses
  Windows; // Only for DWORD

const
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

///////////////////////////////////////
/// Format ID
  ffRIFFID=DWORD(Byte('R') or (Byte('I') shl 8) or (Byte('F') shl 16) or (Byte('F') shl 24));
  ffWAVEID=DWORD(Byte('W') or (Byte('A') shl 8) or (Byte('V') shl 16) or (Byte('E') shl 24));
  ffAVIID=DWORD(Byte('A') or (Byte('V') shl 8) or (Byte('I') shl 16) or (Byte(' ') shl 24));

  ffOGGID=DWORD(Byte('O') or (Byte('g') shl 8) or (Byte('g') shl 16) or (Byte('S') shl 24));
  ffBIKID=DWORD(Byte('B') or (Byte('I') shl 8) or (Byte('K') shl 16) or (Byte('i') shl 24));
  ffAPEID = DWORD(Byte('M') or (Byte('A') shl 8) or (Byte('C') shl 16) or (Byte(' ') shl 24));

  // Part of tga footer signature is converted to DWORD to avoid string comparing
  //ffTGAID = DWORD(Byte('-') or (Byte('X') shl 8) or (Byte('F') shl 16) or (Byte('I') shl 24));
  //http://www.root.cz/clanky/graficky-format-tga-jednoduchy-oblibeny-pouzivany/
  // TGA - Begin of Uncompressed RGB image
  ffTGAID = DWORD($00 or ($00 shl 8) or ($02 shl 16) or ($00 shl 24));

  // PNG ID and Markers
  ffPNGID=DWORD($89 or (Byte('P') shl 8) or (Byte('N') shl 16) or (Byte('G') shl 24));
  ffIHDRID = DWORD(Byte('I') or (Byte('H') shl 8) or (Byte('D') shl 16) or (Byte('R') shl 24));
  ffIDATID = DWORD(Byte('I') or (Byte('D') shl 8) or (Byte('A') shl 16) or (Byte('T') shl 24));
  ffIENDID = DWORD(Byte('I') or (Byte('E') shl 8) or (Byte('N') shl 16) or (Byte('D') shl 24));

  // DDS Magic and DXT compression IDs
  ffDDSID=DWORD(Byte('D') or (Byte('D') shl 8) or (Byte('S') shl 16) or (Byte(' ') shl 24));
  ffDXT1ID=DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('1') shl 24));
  ffDXT3ID=DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('3') shl 24));
  ffDXT5ID=DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('5') shl 24));
  //http://www.koders.com/cpp/fid0641587A4DA23569ED3F21C8CE41723BEDA2251D.aspx?s=3DC+header#L66
  ffATI1ID=DWORD(Byte('A') or (Byte('T') shl 8) or (Byte('I') shl 16) or (Byte('1') shl 24));
  ffATI2ID=DWORD(Byte('A') or (Byte('T') shl 8) or (Byte('I') shl 16) or (Byte('2') shl 24));
  ffDX10ID=DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('1') shl 16) or (Byte('0') shl 24));

  ffBMPID=WORD(Byte('B') or (Byte('M') shl 8));
  // JFIF ID and markers
  //ffJFIFID=WORD($FF or ($D8 shl 8));
  ffSOF0ID = WORD($FF or ($C0 shl 8)); // For testing usage
  ffAPP0ID = WORD($FF or ($E0 shl 8));
  ffSOIID = WORD($FF or ($D8 shl 8));
  ffSOSID = WORD($FF or ($DA shl 8));
  ffEOIID = WORD($FF or ($D9 shl 8));

  // 7z ID and Version
  ff7zID = DWORD(Byte('7') or (Byte('z') shl 8) or ($BC shl 16) or ($AF shl 24));
  ff7zVerID = DWORD($27 or ($1C shl 8) or ($00 shl 16) or ($02 shl 24));

  // ZLib
  ffZLIBID1 = WORD($78 or ($DA shl 8));
  ffZLIBID2 = WORD($78 or ($9C shl 8));

  // 3DS
  ff3DSID=WORD(Byte('M') or (Byte('M') shl 8));

  // MP3
  ffMP3IDMin = WORD($FF or ($E2 shl 8));
  ffMP3IDMax = WORD($FF or ($FF shl 8));
  ffMP3IDTable : Array[0..17] of WORD = (
    WORD($FF or ($FF shl 8)),WORD($FF or ($FE shl 8)),
    WORD($FF or ($FD shl 8)),WORD($FF or ($FC shl 8)),
    WORD($FF or ($FB shl 8)),WORD($FF or ($FA shl 8)),

    WORD($FF or ($F7 shl 8)),WORD($FF or ($F6 shl 8)),
    WORD($FF or ($F5 shl 8)),WORD($FF or ($F4 shl 8)),
    WORD($FF or ($F3 shl 8)),WORD($FF or ($F2 shl 8)),

    WORD($FF or ($E7 shl 8)),WORD($FF or ($E6 shl 8)),
    WORD($FF or ($E5 shl 8)),WORD($FF or ($E4 shl 8)),
    WORD($FF or ($E3 shl 8)),WORD($FF or ($E2 shl 8))
  );
  (*
    $FFFF,$FFFE,$FFFD,$FFFC,$FFFB,$FFFA,
    $FFF7,$FFF6,$FFF5,$FFF4,$FFF3,$FFF2,
    $FFE7,$FFE6,$FFE5,$FFE4,$FFE3,$FFE2
  *)

  // ID3
  //ffMP3ID = WORD($FF or ($FB shl 8));
  ffID3V2ID = DWORD(Byte('I') or (Byte('D') shl 8) or (Byte('3') shl 16) or ($02 shl 24));
  ffID3V3ID = DWORD(Byte('I') or (Byte('D') shl 8) or (Byte('3') shl 16) or ($03 shl 24));
  ffID3V4ID = DWORD(Byte('I') or (Byte('D') shl 8) or (Byte('3') shl 16) or ($04 shl 24));

  // M4A ID and Markers
  ffM4AID = DWORD(Byte('M') or (Byte('4') shl 8) or (Byte('A') shl 16) or (Byte(' ') shl 24));
  ffMP4ID = DWORD(Byte('m') or (Byte('p') shl 8) or (Byte('4') shl 16) or (Byte('2') shl 24));
  ff3GPID = DWORD(Byte('3') or (Byte('g') shl 8) or (Byte('p') shl 16) or (Byte('4') shl 24));
  ff3G2ID = DWORD(Byte('3') or (Byte('g') shl 8) or (Byte('2') shl 16) or (Byte('a') shl 24));

  ffFTYPID = DWORD(Byte('f') or (Byte('t') shl 8) or (Byte('y') shl 16) or (Byte('p') shl 24));
  ffMOOVID = DWORD(Byte('m') or (Byte('o') shl 8) or (Byte('o') shl 16) or (Byte('v') shl 24));
  ffFREEID = DWORD(Byte('f') or (Byte('r') shl 8) or (Byte('e') shl 16) or (Byte('e') shl 24));
  ffMDATID = DWORD(Byte('m') or (Byte('d') shl 8) or (Byte('a') shl 16) or (Byte('t') shl 24));
  ffWIDEID = DWORD(Byte('w') or (Byte('i') shl 8) or (Byte('d') shl 16) or (Byte('e') shl 24));
  ffMVHDID = DWORD(Byte('m') or (Byte('v') shl 8) or (Byte('h') shl 16) or (Byte('d') shl 24));
  ffUDTAID = DWORD(Byte('u') or (Byte('d') shl 8) or (Byte('t') shl 16) or (Byte('a') shl 24));


  //ZIP IDs
  ffZIPLocID = DWORD(Byte('P') or (Byte('K') shl 8) or ($03 shl 16) or ($04 shl 24));
  ffZIPDirID = DWORD(Byte('P') or (Byte('K') shl 8) or ($01 shl 16) or ($02 shl 24));
  ffZIPEndID = DWORD(Byte('P') or (Byte('K') shl 8) or ($05 shl 16) or ($06 shl 24));
  ffZIPExtID = DWORD(Byte('P') or (Byte('K') shl 8) or ($07 shl 16) or ($08 shl 24));

  // xIFF and so on
  // http://www.borg.com/~jglatt/tech/aboutiff.htm
  // http://www.irisa.fr/texmex/people/dufouil/ffmpegdoxy/aiff_8c-source.html
  ffFORMID = DWORD(Byte('F') or (Byte('O') shl 8) or (Byte('R') shl 16) or (Byte('M') shl 24));
  ffAIFFID = DWORD(Byte('A') or (Byte('I') shl 8) or (Byte('F') shl 16) or (Byte('F') shl 24));

  //MIDI
  // http://www.sonicspot.com/guide/midifiles.html
  ffMTHDID = DWORD(Byte('M') or (Byte('T') shl 8) or (Byte('h') shl 16) or (Byte('d') shl 24));
  ffMTRKID = DWORD(Byte('M') or (Byte('T') shl 8) or (Byte('r') shl 16) or (Byte('k') shl 24));

  //PSD
  ff8BPSID = DWORD(Byte('8') or (Byte('B') shl 8) or (Byte('P') shl 16) or (Byte('S') shl 24));
  ff8BIMID = DWORD(Byte('8') or (Byte('B') shl 8) or (Byte('I') shl 16) or (Byte('M') shl 24));

  // SWF
  ffSWFID = DWORD(Byte('F') or (Byte('W') shl 8) or (Byte('S') shl 16) or ($05 shl 24));

  // WMA - ASF
  //ffWMAID = DWORD($30 or ($26 shl 8) or ($B2 shl 16) or ($75 shl 24));

  // EXE
  ffMZID = WORD(Byte('M') or (Byte('Z') shl 8));
  ffPEID = DWORD(Byte('P') or (Byte('E') shl 8) or ($00 shl 16) or ($00 shl 24));


  //SWS
  ffCTRLID = DWORD(Byte('C') or (Byte('T') shl 8) or (Byte('R') shl 16) or (Byte('L') shl 24));
  ffFILMID = DWORD(Byte('F') or (Byte('I') shl 8) or (Byte('L') shl 16) or (Byte('M') shl 24));
  ffSNDSID = DWORD(Byte('S') or (Byte('N') shl 8) or (Byte('D') shl 16) or (Byte('S') shl 24));
  ffFILLID = DWORD(Byte('F') or (Byte('I') shl 8) or (Byte('L') shl 16) or (Byte('L') shl 24));

  //SIFF
  ffSIFFID = DWORD(Byte('S') or (Byte('I') shl 8) or (Byte('F') shl 16) or (Byte('F') shl 24));
  ffVBV1ID = DWORD(Byte('V') or (Byte('B') shl 8) or (Byte('V') shl 16) or (Byte('1') shl 24));

  //FLV
  ffFLVID = DWORD(Byte('F') or (Byte('L') shl 8) or (Byte('V') shl 16) or ($01 shl 24));

  //RMF
  ffRMFID = DWORD($2E or (Byte('R') shl 8) or (Byte('M') shl 16) or (Byte('F') shl 24));
  ffPROPID = DWORD(Byte('P') or (Byte('R') shl 8) or (Byte('O') shl 16) or (Byte('P') shl 24));
  ffMDPRID = DWORD(Byte('M') or (Byte('D') shl 8) or (Byte('P') shl 16) or (Byte('R') shl 24));
  ffCONTID = DWORD(Byte('C') or (Byte('O') shl 8) or (Byte('N') shl 16) or (Byte('T') shl 24));
  ffDATAID = DWORD(Byte('D') or (Byte('A') shl 8) or (Byte('T') shl 16) or (Byte('A') shl 24));
  ffINDXID = DWORD(Byte('I') or (Byte('N') shl 8) or (Byte('D') shl 16) or (Byte('X') shl 24));

  //ASF
  ffASFID = DWORD($30 or ($26 shl 8) or ($B2 shl 16) or ($75 shl 24));

  //SND
  ffSNDID = DWORD($2E or (Byte('s') shl 8) or (Byte('n') shl 16) or (Byte('d') shl 24));

  // WAV PACK
  ffWVPKID = DWORD(Byte('w') or (Byte('v') shl 8) or (Byte('p') shl 16) or (Byte('k') shl 24));

  // RAF
  ffRAFID = DWORD($2E or (Byte('r') shl 8) or (Byte('a') shl 16) or ($FD shl 24));

  // SMK
  ffSMKID = DWORD(Byte('S') or (Byte('M') shl 8) or (Byte('K') shl 16) or (Byte('4') shl 24));

  // XBG
  ffXBGID = DWORD(Byte('X') or (Byte('B') shl 8) or (Byte('G') shl 16) or ($02 shl 24));

  // XPR
  ffXPR0ID = DWORD(Byte('X') or (Byte('P') shl 8) or (Byte('R') shl 16) or (Byte('0') shl 24));

  // XPR2
  ffXPR2ID = DWORD(Byte('X') or (Byte('P') shl 8) or (Byte('R') shl 16) or (Byte('2') shl 24));

  // XMV - XBOX
  ffXMVID = DWORD(Byte('x') or (Byte('o') shl 8) or (Byte('b') shl 16) or (Byte('X') shl 24));

  // XWMA
  ffXWMAID = DWORD(Byte('X') or (Byte('W') shl 8) or (Byte('M') shl 16) or (Byte('A') shl 24));

  // CAB
  ffCABID = DWORD(Byte('M') or (Byte('S') shl 8) or (Byte('C') shl 16) or (Byte('F') shl 24));

  // XNB
  ffXNBID = DWORD(Byte('X') or (Byte('N') shl 8) or (Byte('B') shl 16) or (Byte('w') shl 24));

  // WAD
  ffWADID = DWORD(Byte('W') or (Byte('A') shl 8) or (Byte('D') shl 16) or (Byte('2') shl 24));

  // MDL 7
  ffMDL7ID = DWORD(Byte('M') or (Byte('D') shl 8) or (Byte('L') shl 16) or (Byte('7') shl 24));

  // 4XM
  ff4XMID = DWORD(Byte('4') or (Byte('X') shl 8) or (Byte('M') shl 16) or (Byte('V') shl 24));

  // PSMF
  ffPSMFID = DWORD(Byte('P') or (Byte('S') shl 8) or (Byte('M') shl 16) or (Byte('F') shl 24));

  // FLX
  ffFLIID = WORD($11 or ($AF shl 8));
  ffFLCID = WORD($12 or ($AF shl 8));
  ffFLXID = WORD($44 or ($AF shl 8));

  // TTA
  ffTTAID = DWORD(Byte('T') or (Byte('T') shl 8) or (Byte('A') shl 16) or (Byte('1') shl 24));

  // OFR
  ffOFRID = DWORD(Byte('O') or (Byte('F') shl 8) or (Byte('R') shl 16) or (Byte(' ') shl 24));
  ffTAILID = DWORD(Byte('T') or (Byte('A') shl 8) or (Byte('I') shl 16) or (Byte('L') shl 24));

  // LA
  ffLAID = DWORD(Byte('L') or (Byte('A') shl 8) or (Byte('0') shl 16) or (Byte('4') shl 24));

  // LPAC
  ffLPACID = DWORD(Byte('L') or (Byte('P') shl 8) or (Byte('A') shl 16) or (Byte('C') shl 24));

  // VQF
  ffTWINID = DWORD(Byte('T') or (Byte('W') shl 8) or (Byte('I') shl 16) or (Byte('N') shl 24));
  ffDSIZID = DWORD(Byte('D') or (Byte('S') shl 8) or (Byte('I') shl 16) or (Byte('Z') shl 24));

  // AVS
  ffAVSID = DWORD(Byte('w') or (Byte('W') shl 8) or ($10 shl 16) or ($00 shl 24));

  // NSV
  ffNSVID = DWORD(Byte('N') or (Byte('S') shl 8) or (Byte('V') shl 16) or (Byte('f') shl 24));

  // PVA
  ffPVAID = DWORD(Byte('A') or (Byte('V') shl 8) or ($01 shl 16) or ($00 shl 24));
  ffAVID = WORD(Byte('A') or (Byte('V') shl 8));

  // bres
  ffBRESID = DWORD(Byte('b') or (Byte('r') shl 8) or (Byte('e') shl 16) or (Byte('s') shl 24));
  ffREFTID = DWORD(Byte('R') or (Byte('E') shl 8) or (Byte('F') shl 16) or (Byte('T') shl 24));
  ffRFNAID = DWORD(Byte('R') or (Byte('F') shl 8) or (Byte('N') shl 16) or (Byte('A') shl 24));
  ffRFNTID = DWORD(Byte('R') or (Byte('F') shl 8) or (Byte('N') shl 16) or (Byte('T') shl 24));
  ffRSTMID = DWORD(Byte('R') or (Byte('S') shl 8) or (Byte('T') shl 16) or (Byte('M') shl 24));
  ffRSARID = DWORD(Byte('R') or (Byte('S') shl 8) or (Byte('A') shl 16) or (Byte('R') shl 24));

  // GR2
  ffGR2ID = DWORD($B8 or ($67 shl 8) or ($B0 shl 16) or ($CA shl 24));

  ffLWO2ID = DWORD(Byte('L') or (Byte('W') shl 8) or (Byte('O') shl 16) or (Byte('2') shl 24));

  ffSDATID =  DWORD(Byte('S') or (Byte('D') shl 8) or (Byte('A') shl 16) or (Byte('T') shl 24));
  ffSSEQID =  DWORD(Byte('S') or (Byte('S') shl 8) or (Byte('E') shl 16) or (Byte('Q') shl 24));
  ffSSARID =  DWORD(Byte('S') or (Byte('S') shl 8) or (Byte('A') shl 16) or (Byte('R') shl 24));
  ffSWARID =  DWORD(Byte('S') or (Byte('W') shl 8) or (Byte('A') shl 16) or (Byte('R') shl 24));
  ffSBNKID =  DWORD(Byte('S') or (Byte('B') shl 8) or (Byte('N') shl 16) or (Byte('K') shl 24));

  ffNCERID = DWORD(Byte('R') or (Byte('E') shl 8) or (Byte('C') shl 16) or (Byte('N') shl 24));
  ffNANRID = DWORD(Byte('R') or (Byte('N') shl 8) or (Byte('A') shl 16) or (Byte('N') shl 24));
  ffNCLRID = DWORD(Byte('R') or (Byte('L') shl 8) or (Byte('C') shl 16) or (Byte('N') shl 24));
  ffNARCID = DWORD(Byte('N') or (Byte('A') shl 8) or (Byte('R') shl 16) or (Byte('C') shl 24));

  ff8SVXID = DWORD(Byte('8') or (Byte('S') shl 8) or (Byte('V') shl 16) or (Byte('X') shl 24));

  ffDMSCID = DWORD(Byte('D') or (Byte('M') shl 8) or (Byte('S') shl 16) or (Byte('C') shl 24));
  ffDMSGID = DWORD(Byte('D') or (Byte('M') shl 8) or (Byte('S') shl 16) or (Byte('G') shl 24));

  ffTHPID = DWORD(Byte('T') or (Byte('H') shl 8) or (Byte('P') shl 16) or ($00 shl 24));

  ffSTABID = DWORD(Byte('S') or (Byte('T') shl 8) or (Byte('A') shl 16) or (Byte('B') shl 24));

  //http://flac.sourceforge.net/format.html
  //http://ff123.net/samples.html


/// File Headers ID
///////////////////////////////////////

type
///////////////////////////////////////
/// Headers
  TRIFFChunk = packed record
    Marker:DWORD;
    Size:DWORD;
  end;

  TRIFFHeader = packed record
    Marker:DWORD;
    Size:DWORD;
    Format:DWORD;
  end;

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
  //pOGGHeader=^TOGGHeader;

  TBIKHeader = Packed Record
    Marker: DWORD;
    FileSize:DWORD;
  end;
  //pBIKHeader=^TBIKHeader;

  TBMPHeader = Packed Record
    Marker: WORD;  { Must be 'BM' }
    FileSize: DWORD;     { Size of this file }
    Reserved: DWORD;        { ??? }
    HeaderSize: DWORD;      { Size of header }
    InfoSize: DWORD;        { Size of info that follows header }
    Width:DWORD;
    Height: DWORD;   { Width and Height of image }
    PlaneCount: WORD;
    PixelSize: WORD;  { Bits can be 1, 4, 8, or 24 }
    CompressionType: DWORD;
    ImageDataSize: DWORD;
    XPixelPerMeter: DWORD;
    YPixelPerMeter: DWORD;
    ColorCount: DWORD;
    ImportantColorCount: DWORD;
  end;
  //pBMPHeader=^TBMPHeader;

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
    DXGI_FORMAT_FORCE_UINT = $FFFFFFFF) ; // force to work with DWORD

  TD3D10_RESOURCE_DIMENSION = (
    D3D10_RESOURCE_DIMENSION_UNKNOWN = 0,
    D3D10_RESOURCE_DIMENSION_BUFFER = 1,
    D3D10_RESOURCE_DIMENSION_TEXTURE1D = 2,
    D3D10_RESOURCE_DIMENSION_TEXTURE2D = 3,
    D3D10_RESOURCE_DIMENSION_TEXTURE3D = 4,
    D3D10_RESOURCE_DIMENSION_FORCE_UINT = $FFFFFFFF);

  TDX09Header = Packed Record // 128 Bytes
    Marker: DWORD;
    // Surface desc
    SSize: DWORD;       // Size of the structure = 124 Bytes
    SFlags: DWORD;      // Flags to indicate valid fields
    Height: DWORD;     // Height of the main image in pixels
    Width: DWORD;      // Width of the main image in pixels
    PitchOrLinearSize: DWORD; // For uncomp formats number of bytes per // scanline. For comp it is the size in // bytes of the main image
    Depth: DWORD;      // Only for volume text depth of the volume
    MipMaps: DWORD;     // Total number of levels in the mipmap chain
    Reserved: array[0..43] of Byte; // Reserved
    //Pixel Format
    PSize: DWORD;       // Size of the structure = 32 bytes
    PFlags: DWORD;      // Flags to indicate valid fields
    FourCC: DWORD;     // Four-char code for compressed textures (DXT)
    BitCount: DWORD;   // Bits per pixel if uncomp. usually 16,24 or 32
    RedMask: DWORD;    // Bit mask for the Red component
    GreenMask: DWORD;  // Bit mask for the Green component
    BlueMask: DWORD;   // Bit mask for the Blue component
    AlphaMask: DWORD;  // Bit mask for the Alpha component
    // Caps
    Caps1: DWORD;      // Should always include DDSCAPS_TEXTURE
    Caps2: DWORD;      // For cubic environment maps
    Caps3: DWORD;
    Caps4: DWORD;
    TextureStage:DWORD;  // Reserved
  end;

  TDX10Header = Packed Record // 20 Bytes
    DXGIFormat:DWORD;//TDXGI_FORMAT;
    ResDimension:DWORD;//TD3D10_RESOURCE_DIMENSION;
    MiscFlag:DWORD;
    ArraySize:DWORD;
    Reserved:DWORD;
  end;

  TJFIFSegment = Packed Record
    Marker:WORD;
    Size:WORD
  end;

  TPNGChunk = Packed Record
    Size:DWORD;
    Marker:DWORD;
  end;

  TMP4Segment = Packed Record
    Size:DWORD;
    Marker:DWORD;
  end;

  T7ZHeader = Packed Record  //32 Bytes
    Marker:DWORD;
    Version:DWORD;
    Flags:DWORD;
    CompSize:DWORD;
    Unknown1:DWORD;
    AddSize:DWORD;
    Unknown2:DWORD;
    Unknown3:DWORD;
  end;

  TAPEHeader = Packed Record
    Makrer:DWORD;
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

  TTGAHeader = packed record
    IDLength: Byte;
    CMapType: Byte;
    ImageType: Byte;
    CMapOffset: WORD;
    CMapLength: WORD;
    CMapDepth: Byte;
    XOffset: SmallInt;
    YOffset: SmallInt;
    Width: SmallInt;
    Height: SmallInt;
    PixelDepth: Byte;
    ImageDescriptor: Byte;
  end;
  pTGAHeader = ^TTGAHeader;

  TTGAFooter = packed record
    ExtOffset: DWORD;                 // Extension Area Offset
    DevDirOffset: DWORD;              // Developer Directory Offset
    Signature: array[0..15] of Char;  // TRUEVISION-XFILE
    Delimiter: Byte;                   // ASCII period '.'
    NullChar: Byte;                   // 0
  end;

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
  //pPSDHeader =^TPSDHeader;

  TSWFHeader = Packed Record
    ID:DWORD;
    FileSize:DWORD;
  end;

  TSWSSegment = Packed Record
    Marker:DWORD;
    Size:DWORD;
  end;

  TSIFFHeader = Packed Record
    Marker:DWORD;
    Size:DWORD;
    Version:DWORD;
  end;

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
  End;

  TRMFSegment = Packed Record
    Marker:DWORD;
    Size:DWORD;
    //ChunkVersion:WORD;
    //FileVersion:DWORD;
    //HeaderCount:DWORD;
  end;

  // ASF Header ID is 128 bit lenght,so we reduce it to 32 bits to fit it...
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

  (*
  //Not needed,we need only 64 bits to get filesize
  TASFFileObject = Packed Record
    ObjectID:TASFMarker;
    ObjectSize:Int64;
    FileID:TASFMarker;
    FileSize:Int64;
    CreationDate:Int64;
    PacketsCount:Int64;
    PlayLength:Int64;
    SendLength:Int64;
    PreRoll:Int64;
    Flags:DWORD;
    MinPacketSize:DWORD;
    MaxPacketSize:DWORD;
    MaxBitrate:DWORD;
  end;
  *)
  TSNDHeader = Packed Record
    Marker:DWORD;
    DataStart:DWORD;
    DataSize:DWORD;
    SampleFormat:DWORD;
    SampleRate:DWORD;
    Channels:DWORD;
  end;

  TWVPKChunk = Packed Record
    Marker:DWORD;
    Size:DWORD;
  end;

  T3DSChunk = Packed Record
    Marker:WORD;
    Size:DWORD;
  end;

  TRAFHeader = Packed Record
    Marker:DWORD;
    Version:WORD;
  end;

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

  TXBGHeader = Packed Record
    Marker:DWORD; // A file-type identifier
    NumMeshFrames:DWORD;     // Num of frames in the file
    SysMemSize:DWORD;        // Num system memory bytes req'd
    VidMemSize:DWORD;        // Num videro memorty bytes req'd
  end;

  TXPR0Header = Packed Record
    Marker:DWORD;
    TotalSize:DWORD;
    HeaderSize:DWORD;
  end;

  TXPR2Header = Packed Record
    Marker: DWORD;
    HeaderSize: DWORD;
    DataSize: DWORD;
  end;
(*
  TXMVAudioDataHeader = Packed Record
    // The WAVE_FORMAT tag that describes how the audio data in the stream is
    // encoded.  This can be either WAVE_FORMAT_PCM or WAVE_FORMAT_ADPCM.
    //
    WaveFormat:WORD;

    // The number of channels in the audio stream.  Can be 1, 2, 4 or 6.
    ChannelCount:WORD;

    // The number of samples per second (Hz) in the audio stream.
    SamplesPerSecond:DWORD;

    // The number of bits in each sample.  
    BitsPerSample:DWORD;
  end;

  TXMVVideoDataHeader = Packed Record
    // A kinda-unique value to help verify that the decoder is actually
    // loading an XMV file.  Defined to always be XMV_MAGIC_COOKIE.
    //
    Marker:DWORD;//MagicCookie;

    // The file format version of this file to ensure that the version
    // of xmvtool that creates the XMV file matches the version of the
    // decoder.
    //
    FileVersion:DWORD;

    // The size of the very first packet.
    ThisPacketSize:DWORD;

    // The number of frames per second to display the video at.  All timing of
    // the playback is based off this value.  It can be any integer value
    // from zero to 60.  
    //
    FramesPerSecond:DWORD;

    // The number of slices that the picture is divided into.
    Slices:DWORD;

    // Various flags about how the picture is encoded.  This could be packed
    // a bit more but why bother to save a few bytes?
    //
    MixedPelMotionCompensationEnable:Boolean;
    LoopFilterEnabled:Boolean;
    VariableSizedTransformEnabled:Boolean;
    XIntra8IPictureCodingEnabled:Boolean;
    HybridMotionVectorEnabled:Boolean;
    DCTTableSwitchingEnabled:Boolean;
    
    // The width of the encoded video in pixels.  If this is zero then there
    // is no video encoded in this file.
    //
    Width:DWORD;

    // The height of the encoded video in pixels.
    Height:DWORD;

    // The buffer size required to load all of the video packets in this
    // file.
    //
    RequiredBufferSize:DWORD;

    // The number of audio streams contained in each video packet.
    AudioStreamCount:DWORD;

    // The descriptor for each audio stream.
    //XMVAudioDataHeader AudioHeaders[0];
  end;
*)
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
  End;

  TTTFOffsetTable = Packed Record
    MajorVersion:WORD;
    MinorVersion:WORD;
    NumOfTables:WORD;
    SearchRange:WORD;
    EntrySelector:WORD;
    RangeShift:WORD;
  end;

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

  TXNBHeader = Packed Record
    Marker:DWORD;
    Version:WORD;
    FileSize:DWORD;
    Unk:BYTE;
    ComSize:BYTE; // comment size
  end;

  TWADHeader = Packed Record
    Marker:DWORD;
    TextureCount:DWORD;
    DataSize:DWORD;
  end;

  TMDL7Header = Packed Record
    Marker:DWORD;
    Version:DWORD; // ?
    Unknown:DWORD;
    MeshCount:DWORD; // ?
    FileSize:DWORD;
  end;

  TPSMFHeader = Packed Record
    Marker:DWORD;
    Version:WORD; // ?
    Unknown:DWORD;
    HeaderCount:WORD; // ?
    DataSize:DWORD;
  end;

  TFLXHeader = Packed Record
    FileSize:DWORD;
    FileType:WORD;
    FrameCount:WORD; // ?
    FrameWidth:WORD;
    FrameHeight:WORD;
    FrameDepth:WORD;
  end;

  TTTAHeader = Packed Record
    Marker:DWORD;
    AudioFormat:WORD;
    ChannelCount:WORD;
    SampleSize:WORD;
    SampleRate:DWORD;
    DataSize:DWORD;
    CheckSum:DWORD;
  end;

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

  TLAStreamInfo = Packed Record  // not sure if its correct except filesize
    SampleCount:DWORD;
    StreamFlags:BYTE;
    CheckSum:DWORD;
  end;

  TLPACHeader = Packed Record
    Marker:DWORD;
    Version:BYTE;
    AudioType:BYTE;
    SampleCount:DWORD;
    AudioFlags:DWORD;
  end;

  TVQFHeader = Packed Record
    Marker:DWORD;
    Version:DWORD;
    Unknown:DWORD;
    HeaderSize:DWORD;
  end;

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

  TNSVHeader = Packed Record
    Marker:DWORD;
    Size:DWORD;
    FileSize:DWORD;
    // Header is bigger but there is many unknown bytes
  end;

  TAVPacket = Packed Record
    Marker:WORD;
    StreamID:BYTE;
    Counter:BYTE;
    Reserved:BYTE;
    Flags:BYTE;
    Size:WORD;
  end;

  TNintendoHeader = Packed Record
    Marker:DWORD;
    Format:DWORD;
    Size:DWORD;
  end;

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
  // FILM
  TSTABHeader = Packed Record
    SampleRate:DWORD;
    SeekTableLength:DWORD;
  end;

  TSTABSeekTableEntry = Packed Record
    ChunkOffset:DWORD;
    ChunkSize:DWORD;
    ChunkFlags:Array[0..1] of DWORD;
  end;

/// Headers
///////////////////////////////////////

implementation

end.
