unit FileRipperMarkers;

interface

uses
  Windows; // only for DWORD

const
///////////////////////////////////////
/// Format ID
  FORMAT_MARKER_RIFF  = DWORD(Byte('R') or (Byte('I') shl 8) or (Byte('F') shl 16) or (Byte('F') shl 24));
  FORMAT_MARKER_WAVE  = DWORD(Byte('W') or (Byte('A') shl 8) or (Byte('V') shl 16) or (Byte('E') shl 24));
  FORMAT_MARKER_AVI   = DWORD(Byte('A') or (Byte('V') shl 8) or (Byte('I') shl 16) or (Byte(' ') shl 24));

  FORMAT_MARKER_OGG = DWORD(Byte('O') or (Byte('g') shl 8) or (Byte('g') shl 16) or (Byte('S') shl 24));
  FORMAT_MARKER_BIK = DWORD(Byte('B') or (Byte('I') shl 8) or (Byte('K') shl 16) or (Byte('i') shl 24));
  FORMAT_MARKER_APE = DWORD(Byte('M') or (Byte('A') shl 8) or (Byte('C') shl 16) or (Byte(' ') shl 24));

  FORMAT_MARKER_GIF = DWORD(Byte('G') or (Byte('I') shl 8) or (Byte('F') shl 16) or (Byte('8') shl 24));

  // Part of tga footer signature is converted to DWORD to avoid string comparing
  //ffTGAID = DWORD(Byte('-') or (Byte('X') shl 8) or (Byte('F') shl 16) or (Byte('I') shl 24));
  //http://www.root.cz/clanky/graficky-format-tga-jednoduchy-oblibeny-pouzivany/
  // TGA - Begin of Uncompressed RGB image
  FORMAT_MARKER_TGA = DWORD($00 or ($00 shl 8) or ($02 shl 16) or ($00 shl 24));

  // PNG ID and Markers
  FORMAT_MARKER_PNG   = DWORD($89 or (Byte('P') shl 8) or (Byte('N') shl 16) or (Byte('G') shl 24));
  //FORMAT_MARKER_PNG_IHDR  = DWORD(Byte('I') or (Byte('H') shl 8) or (Byte('D') shl 16) or (Byte('R') shl 24));
  //FORMAT_MARKER_PNG_IDAT  = DWORD(Byte('I') or (Byte('D') shl 8) or (Byte('A') shl 16) or (Byte('T') shl 24));
  //FORMAT_MARKER_PNG_IEND  = DWORD(Byte('I') or (Byte('E') shl 8) or (Byte('N') shl 16) or (Byte('D') shl 24));

  // DDS Magic and DXT compression IDs
  FORMAT_MARKER_DDS   = DWORD(Byte('D') or (Byte('D') shl 8) or (Byte('S') shl 16) or (Byte(' ') shl 24));
  //FORMAT_MARKER_DDS_DXT1  = DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('1') shl 24));
  //FORMAT_MARKER_DDS_DXT3  = DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('3') shl 24));
  //FORMAT_MARKER_DDS_DXT5  = DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('5') shl 24));
  //http://www.koders.com/cpp/fid0641587A4DA23569ED3F21C8CE41723BEDA2251D.aspx?s=3DC+header#L66
  //FORMAT_MARKER_DDS_ATI1  = DWORD(Byte('A') or (Byte('T') shl 8) or (Byte('I') shl 16) or (Byte('1') shl 24));
  //FORMAT_MARKER_DDS_ATI2  = DWORD(Byte('A') or (Byte('T') shl 8) or (Byte('I') shl 16) or (Byte('2') shl 24));
  //FORMAT_MARKER_DDS_DX10  = DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('1') shl 16) or (Byte('0') shl 24));

  //FORMAT_MARKER_BMP   = WORD(Byte('B') or (Byte('M') shl 8));
  // JFIF ID and markers
  FORMAT_MARKER_JFIF  = DWORD(Byte('J') or (Byte('F') shl 8) or (Byte('I') shl 16) or (Byte('F') shl 24));
  //FORMAT_MARKER_JFIF_SOF0  = WORD($FF or ($C0 shl 8)); // For testing usage
  //FORMAT_MARKER_JFIF_APP0  = WORD($FF or ($E0 shl 8));
  //FORMAT_MARKER_JFIF_SOI   = WORD($FF or ($D8 shl 8));
  //FORMAT_MARKER_JFIF_SOS   = WORD($FF or ($DA shl 8));
  //FORMAT_MARKER_JFIF_EOI   = WORD($FF or ($D9 shl 8));

  // 7z ID and Version
  FORMAT_MARKER_7ZIP    = DWORD(Byte('7') or (Byte('z') shl 8) or ($BC shl 16) or ($AF shl 24));
  //FORMAT_MARKER_7Z_VER = DWORD($27 or ($1C shl 8) or ($00 shl 16) or ($02 shl 24));

  // ZLib
  //FORMAT_MARKER_ZLIB_0 = WORD($78 or ($DA shl 8));
  //FORMAT_MARKER_ZLIB_1 = WORD($78 or ($9C shl 8));

  // 3DS
  //FORMAT_MARKER_3DS = WORD(Byte('M') or (Byte('M') shl 8));
  (*
  // MP3
  FORMAT_MARKER_MP3_MIN = WORD($FF or ($E2 shl 8));
  FORMAT_MARKER_MP3_MAX = WORD($FF or ($FF shl 8));
  FORMAT_MARKER_MP3_TABLE : Array[0..17] of WORD = (
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
  *)
  (*
    $FFFF,$FFFE,$FFFD,$FFFC,$FFFB,$FFFA,
    $FFF7,$FFF6,$FFF5,$FFF4,$FFF3,$FFF2,
    $FFE7,$FFE6,$FFE5,$FFE4,$FFE3,$FFE2
  *)

  // ID3
  //ffMP3ID = WORD($FF or ($FB shl 8));
  FORMAT_MARKER_ID3V2 = DWORD(Byte('I') or (Byte('D') shl 8) or (Byte('3') shl 16) or ($02 shl 24));
  FORMAT_MARKER_ID3V3 = DWORD(Byte('I') or (Byte('D') shl 8) or (Byte('3') shl 16) or ($03 shl 24));
  FORMAT_MARKER_ID3V4 = DWORD(Byte('I') or (Byte('D') shl 8) or (Byte('3') shl 16) or ($04 shl 24));

  // M4A ID and Markers
  FORMAT_MARKER_MPEG4_M4A = DWORD(Byte('M') or (Byte('4') shl 8) or (Byte('A') shl 16) or (Byte(' ') shl 24));
  FORMAT_MARKER_MPEG4_MP4 = DWORD(Byte('m') or (Byte('p') shl 8) or (Byte('4') shl 16) or (Byte('2') shl 24));
  FORMAT_MARKER_MPEG4_3GP = DWORD(Byte('3') or (Byte('g') shl 8) or (Byte('p') shl 16) or (Byte('4') shl 24));
  FORMAT_MARKER_MPEG4_3G2 = DWORD(Byte('3') or (Byte('g') shl 8) or (Byte('2') shl 16) or (Byte('a') shl 24));

  FORMAT_MARKER_MP4 = DWORD(Byte('f') or (Byte('t') shl 8) or (Byte('y') shl 16) or (Byte('p') shl 24));
  FORMAT_MARKER_MOV = DWORD(Byte('m') or (Byte('o') shl 8) or (Byte('o') shl 16) or (Byte('v') shl 24));
  //FORMAT_MARKER_MPEG4_FREE = DWORD(Byte('f') or (Byte('r') shl 8) or (Byte('e') shl 16) or (Byte('e') shl 24));
  //FORMAT_MARKER_MPEG4_MDAT = DWORD(Byte('m') or (Byte('d') shl 8) or (Byte('a') shl 16) or (Byte('t') shl 24));
  //FORMAT_MARKER_MPEG4_WIDE = DWORD(Byte('w') or (Byte('i') shl 8) or (Byte('d') shl 16) or (Byte('e') shl 24));
  //FORMAT_MARKER_MPEG4_MVHD = DWORD(Byte('m') or (Byte('v') shl 8) or (Byte('h') shl 16) or (Byte('d') shl 24));
  //FORMAT_MARKER_MPEG4_UDTA = DWORD(Byte('u') or (Byte('d') shl 8) or (Byte('t') shl 16) or (Byte('a') shl 24));


  //ZIP IDs
  FORMAT_MARKER_ZIP = DWORD(Byte('P') or (Byte('K') shl 8) or ($03 shl 16) or ($04 shl 24));
 // FORMAT_MARKER_ZIP_DIR = DWORD(Byte('P') or (Byte('K') shl 8) or ($01 shl 16) or ($02 shl 24));
  //FORMAT_MARKER_ZIP_END = DWORD(Byte('P') or (Byte('K') shl 8) or ($05 shl 16) or ($06 shl 24));
  //FORMAT_MARKER_ZIP_EXT = DWORD(Byte('P') or (Byte('K') shl 8) or ($07 shl 16) or ($08 shl 24));

  // xIFF and so on
  // http://www.borg.com/~jglatt/tech/aboutiff.htm
  // http://www.irisa.fr/texmex/people/dufouil/ffmpegdoxy/aiff_8c-source.html
  FORMAT_MARKER_IFF = DWORD(Byte('F') or (Byte('O') shl 8) or (Byte('R') shl 16) or (Byte('M') shl 24));
  FORMAT_MARKER_AIFF = DWORD(Byte('A') or (Byte('I') shl 8) or (Byte('F') shl 16) or (Byte('F') shl 24));

  //MIDI
  // http://www.sonicspot.com/guide/midifiles.html
  FORMAT_MARKER_MIDI = DWORD(Byte('M') or (Byte('T') shl 8) or (Byte('h') shl 16) or (Byte('d') shl 24));
  //FORMAT_MARKER_MIDI_MTRK = DWORD(Byte('M') or (Byte('T') shl 8) or (Byte('r') shl 16) or (Byte('k') shl 24));

  //PSD
  FORMAT_MARKER_PSD = DWORD(Byte('8') or (Byte('B') shl 8) or (Byte('P') shl 16) or (Byte('S') shl 24));
  //FORMAT_MARKER_PSD_8BIM = DWORD(Byte('8') or (Byte('B') shl 8) or (Byte('I') shl 16) or (Byte('M') shl 24));

  // SWF
  FORMAT_MARKER_SWF = DWORD(Byte('F') or (Byte('W') shl 8) or (Byte('S') shl 16) or ($05 shl 24));

  // WMA - ASF
  //ffWMAID = DWORD($30 or ($26 shl 8) or ($B2 shl 16) or ($75 shl 24));

  // EXE
  //FORMAT_MARKER_EXE_MZ = WORD(Byte('M') or (Byte('Z') shl 8));
  //FORMAT_MARKER_EXE_PE = DWORD(Byte('P') or (Byte('E') shl 8) or ($00 shl 16) or ($00 shl 24));


  //SWS
  FORMAT_MARKER_SWS = DWORD(Byte('C') or (Byte('T') shl 8) or (Byte('R') shl 16) or (Byte('L') shl 24));
  FORMAT_MARKER_FILM = DWORD(Byte('F') or (Byte('I') shl 8) or (Byte('L') shl 16) or (Byte('M') shl 24));
  //FORMAT_MARKER_SWS_SNDS = DWORD(Byte('S') or (Byte('N') shl 8) or (Byte('D') shl 16) or (Byte('S') shl 24));
  //FORMAT_MARKER_SWS_FILL = DWORD(Byte('F') or (Byte('I') shl 8) or (Byte('L') shl 16) or (Byte('L') shl 24));

  //SIFF
  FORMAT_MARKER_SIFF = DWORD(Byte('S') or (Byte('I') shl 8) or (Byte('F') shl 16) or (Byte('F') shl 24));
  //FORMAT_MARKER_SIFF_VBV1 = DWORD(Byte('V') or (Byte('B') shl 8) or (Byte('V') shl 16) or (Byte('1') shl 24));

  //FLV
  FORMAT_MARKER_FLV = DWORD(Byte('F') or (Byte('L') shl 8) or (Byte('V') shl 16) or ($01 shl 24));

  //RMF
  FORMAT_MARKER_RMF = DWORD($2E or (Byte('R') shl 8) or (Byte('M') shl 16) or (Byte('F') shl 24));
  //FORMAT_MARKER_RMF_PROP = DWORD(Byte('P') or (Byte('R') shl 8) or (Byte('O') shl 16) or (Byte('P') shl 24));
  //FORMAT_MARKER_RMF_MDPR = DWORD(Byte('M') or (Byte('D') shl 8) or (Byte('P') shl 16) or (Byte('R') shl 24));
  //FORMAT_MARKER_RMF_CONT = DWORD(Byte('C') or (Byte('O') shl 8) or (Byte('N') shl 16) or (Byte('T') shl 24));
  //FORMAT_MARKER_RMF_DATA = DWORD(Byte('D') or (Byte('A') shl 8) or (Byte('T') shl 16) or (Byte('A') shl 24));
  //FORMAT_MARKER_RMF_INDX = DWORD(Byte('I') or (Byte('N') shl 8) or (Byte('D') shl 16) or (Byte('X') shl 24));

  //ASF
  FORMAT_MARKER_ASF = DWORD($30 or ($26 shl 8) or ($B2 shl 16) or ($75 shl 24));

  //SND
  FORMAT_MARKER_SND = DWORD($2E or (Byte('s') shl 8) or (Byte('n') shl 16) or (Byte('d') shl 24));

  // WAV PACK
  FORMAT_MARKER_WVPK = DWORD(Byte('w') or (Byte('v') shl 8) or (Byte('p') shl 16) or (Byte('k') shl 24));

  // RAF
  FORMAT_MARKER_RAF = DWORD($2E or (Byte('r') shl 8) or (Byte('a') shl 16) or ($FD shl 24));

  // SMK
  FORMAT_MARKER_SMK = DWORD(Byte('S') or (Byte('M') shl 8) or (Byte('K') shl 16) or (Byte('4') shl 24));

  // XPR
  FORMAT_MARKER_XPR0 = DWORD(Byte('X') or (Byte('P') shl 8) or (Byte('R') shl 16) or (Byte('0') shl 24));

  // XPR2
  FORMAT_MARKER_XPR2 = DWORD(Byte('X') or (Byte('P') shl 8) or (Byte('R') shl 16) or (Byte('2') shl 24));

  // XMV - XBOX
  FORMAT_MARKER_XMV = DWORD(Byte('x') or (Byte('o') shl 8) or (Byte('b') shl 16) or (Byte('X') shl 24));

  // XWMA
  FORMAT_MARKER_XWMA = DWORD(Byte('X') or (Byte('W') shl 8) or (Byte('M') shl 16) or (Byte('A') shl 24));

  // CAB
  FORMAT_MARKER_CAB = DWORD(Byte('M') or (Byte('S') shl 8) or (Byte('C') shl 16) or (Byte('F') shl 24));

  // XNB
  FORMAT_MARKER_XNB = DWORD(Byte('X') or (Byte('N') shl 8) or (Byte('B') shl 16) or (Byte('w') shl 24));

  // WAD
  FORMAT_MARKER_WAD2 = DWORD(Byte('W') or (Byte('A') shl 8) or (Byte('D') shl 16) or (Byte('2') shl 24));

  // MDL 7
  FORMAT_MARKER_MDL7 = DWORD(Byte('M') or (Byte('D') shl 8) or (Byte('L') shl 16) or (Byte('7') shl 24));

  // 4XM
  FORMAT_MARKER_4XM = DWORD(Byte('4') or (Byte('X') shl 8) or (Byte('M') shl 16) or (Byte('V') shl 24));

  // PSMF
  FORMAT_MARKER_PSMF = DWORD(Byte('P') or (Byte('S') shl 8) or (Byte('M') shl 16) or (Byte('F') shl 24));

  // FLX
  //FORMAT_MARKER_FLI = WORD($11 or ($AF shl 8));
  //FORMAT_MARKER_FLC = WORD($12 or ($AF shl 8));
  //FORMAT_MARKER_FLX = WORD($44 or ($AF shl 8));

  // TTA
  FORMAT_MARKER_TTA = DWORD(Byte('T') or (Byte('T') shl 8) or (Byte('A') shl 16) or (Byte('1') shl 24));

  // OFR
  FORMAT_MARKER_OFR = DWORD(Byte('O') or (Byte('F') shl 8) or (Byte('R') shl 16) or (Byte(' ') shl 24));
  //FORMAT_MARKER_OFR_TAIL = DWORD(Byte('T') or (Byte('A') shl 8) or (Byte('I') shl 16) or (Byte('L') shl 24));

  // LA
  //FORMAT_MARKER_LA = DWORD(Byte('L') or (Byte('A') shl 8) or (Byte('0') shl 16) or (Byte('4') shl 24));

  // LPAC
  FORMAT_MARKER_LPAC = DWORD(Byte('L') or (Byte('P') shl 8) or (Byte('A') shl 16) or (Byte('C') shl 24));

  // VQF
  FORMAT_MARKER_VQF = DWORD(Byte('T') or (Byte('W') shl 8) or (Byte('I') shl 16) or (Byte('N') shl 24));
  //FORMAT_MARKER_VQF_DSIZ = DWORD(Byte('D') or (Byte('S') shl 8) or (Byte('I') shl 16) or (Byte('Z') shl 24));

  // AVS
  FORMAT_MARKER_AVS = DWORD(Byte('w') or (Byte('W') shl 8) or ($10 shl 16) or ($00 shl 24));

  // NSV
  FORMAT_MARKER_NSV = DWORD(Byte('N') or (Byte('S') shl 8) or (Byte('V') shl 16) or (Byte('f') shl 24));

  // PVA
  FORMAT_MARKER_PVA = DWORD(Byte('A') or (Byte('V') shl 8) or ($01 shl 16) or ($00 shl 24));
  //FORMAT_MARKER_AV = WORD(Byte('A') or (Byte('V') shl 8));

  // bres
  FORMAT_MARKER_BRES = DWORD(Byte('b') or (Byte('r') shl 8) or (Byte('e') shl 16) or (Byte('s') shl 24));
  FORMAT_MARKER_REFT = DWORD(Byte('R') or (Byte('E') shl 8) or (Byte('F') shl 16) or (Byte('T') shl 24));
  FORMAT_MARKER_RFNA = DWORD(Byte('R') or (Byte('F') shl 8) or (Byte('N') shl 16) or (Byte('A') shl 24));
  FORMAT_MARKER_RFNT = DWORD(Byte('R') or (Byte('F') shl 8) or (Byte('N') shl 16) or (Byte('T') shl 24));
  FORMAT_MARKER_RSTM = DWORD(Byte('R') or (Byte('S') shl 8) or (Byte('T') shl 16) or (Byte('M') shl 24));
  FORMAT_MARKER_RSAR = DWORD(Byte('R') or (Byte('S') shl 8) or (Byte('A') shl 16) or (Byte('R') shl 24));

  // GR2
  FORMAT_MARKER_GR2 = DWORD($B8 or ($67 shl 8) or ($B0 shl 16) or ($CA shl 24));

  FORMAT_MARKER_LWO2 = DWORD(Byte('L') or (Byte('W') shl 8) or (Byte('O') shl 16) or (Byte('2') shl 24));

  FORMAT_MARKER_SDAT =  DWORD(Byte('S') or (Byte('D') shl 8) or (Byte('A') shl 16) or (Byte('T') shl 24));
  FORMAT_MARKER_SSEQ =  DWORD(Byte('S') or (Byte('S') shl 8) or (Byte('E') shl 16) or (Byte('Q') shl 24));
  FORMAT_MARKER_SSAR =  DWORD(Byte('S') or (Byte('S') shl 8) or (Byte('A') shl 16) or (Byte('R') shl 24));
  FORMAT_MARKER_SWAR =  DWORD(Byte('S') or (Byte('W') shl 8) or (Byte('A') shl 16) or (Byte('R') shl 24));
  FORMAT_MARKER_SBNK =  DWORD(Byte('S') or (Byte('B') shl 8) or (Byte('N') shl 16) or (Byte('K') shl 24));

  FORMAT_MARKER_NCER = DWORD(Byte('R') or (Byte('E') shl 8) or (Byte('C') shl 16) or (Byte('N') shl 24));
  FORMAT_MARKER_NANR = DWORD(Byte('R') or (Byte('N') shl 8) or (Byte('A') shl 16) or (Byte('N') shl 24));
  FORMAT_MARKER_NCLR = DWORD(Byte('R') or (Byte('L') shl 8) or (Byte('C') shl 16) or (Byte('N') shl 24));
  FORMAT_MARKER_NARC = DWORD(Byte('N') or (Byte('A') shl 8) or (Byte('R') shl 16) or (Byte('C') shl 24));

  FORMAT_MARKER_8SVX = DWORD(Byte('8') or (Byte('S') shl 8) or (Byte('V') shl 16) or (Byte('X') shl 24));

  FORMAT_MARKER_DMSC = DWORD(Byte('D') or (Byte('M') shl 8) or (Byte('S') shl 16) or (Byte('C') shl 24));
  FORMAT_MARKER_DMSG = DWORD(Byte('D') or (Byte('M') shl 8) or (Byte('S') shl 16) or (Byte('G') shl 24));

  FORMAT_MARKER_THP = DWORD(Byte('T') or (Byte('H') shl 8) or (Byte('P') shl 16) or ($00 shl 24));

  FORMAT_MARKER_STAB = DWORD(Byte('S') or (Byte('T') shl 8) or (Byte('A') shl 16) or (Byte('B') shl 24));

  //http://flac.sourceforge.net/format.html
  //http://ff123.net/samples.html

  FORMAT_MARKER_RAS = $956AA659;

  FORMAT_MARKER_DPX1 = DWORD(Byte('S') or (Byte('D') shl 8) or (Byte('P') shl 16) or (Byte('X') shl 24));

  FORMAT_MARKER_DPX4 = $D75F2A80;
  
  FORMAT_MARKER_R3D = DWORD(Byte('R') or (Byte('E') shl 8) or (Byte('D') shl 16) or (Byte('1') shl 24));

  // XBG
  FORMAT_MARKER_XBG2 = DWORD(Byte('X') or (Byte('B') shl 8) or (Byte('G') shl 16) or ($02 shl 24));
  FORMAT_MARKER_XBG3 = DWORD(Byte('X') or (Byte('B') shl 8) or (Byte('G') shl 16) or ($03 shl 24));
  FORMAT_MARKER_XBG4 = DWORD(Byte('X') or (Byte('B') shl 8) or (Byte('G') shl 16) or ($04 shl 24));
  FORMAT_MARKER_XBG5 = DWORD(Byte('X') or (Byte('B') shl 8) or (Byte('G') shl 16) or ($05 shl 24));
  FORMAT_MARKER_XBG6 = DWORD(Byte('X') or (Byte('B') shl 8) or (Byte('G') shl 16) or ($06 shl 24));
  FORMAT_MARKER_XBG7 = DWORD(Byte('X') or (Byte('B') shl 8) or (Byte('G') shl 16) or ($07 shl 24));

/// File Headers ID
///////////////////////////////////////

implementation

end.
