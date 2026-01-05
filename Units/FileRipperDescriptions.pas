unit FileRipperDescriptions;

interface

uses
  Windows; // only for DWORD

const

///////////////////////////////////////
/// Format Name
  FORMAT_DESCRIPTION_NONE  = 'No Format';
  FORMAT_DESCRIPTION_WAV   = 'Waveform Audio Format';
  FORMAT_DESCRIPTION_OGG   = 'Xiph Multimedia Container Format';
  FORMAT_DESCRIPTION_RIFF  = 'Resource Interchange File Format';
  FORMAT_DESCRIPTION_IFF   = 'Interchange File Format';
  FORMAT_DESCRIPTION_AVI   = 'Microsoft Video Container Format';
  FORMAT_DESCRIPTION_BIK   = 'RadTools Video Container Format';

  FORMAT_DESCRIPTION_JFIF  = 'JPEG - Image Format';
  FORMAT_DESCRIPTION_DDS   = 'Microsoft - Texture Format';
  FORMAT_DESCRIPTION_PNG   = 'PNGLib - Image Format';
  FORMAT_DESCRIPTION_TGA   = 'Truevision - Image Format';
  FORMAT_DESCRIPTION_BMP   = 'Microsoft - Image Format';
  FORMAT_DESCRIPTION_ZLIB  = 'Deflate Compression Format';
  FORMAT_DESCRIPTION_APE   = 'Monkeys Audio - Audio Format';
  FORMAT_DESCRIPTION_M4A   = 'Apple - Multimedia Container Format';
  FORMAT_DESCRIPTION_MP4   = 'MPEG-4 - Multimedia Container Format';
  FORMAT_DESCRIPTION_MOV   = 'Apple - Multimedia Container Format';
  FORMAT_DESCRIPTION_7ZIP  = '7-Zip - Archive Format';
  FORMAT_DESCRIPTION_ZIP   = 'PKZIP - Archive Format';
  FORMAT_DESCRIPTION_AIFF  = 'Apple - Audio Container Format';
  FORMAT_DESCRIPTION_MIDI  = 'MIDI - Audio Format';
  FORMAT_DESCRIPTION_PSD   = 'Adobe - Photoshop Document Format';
  FORMAT_DESCRIPTION_MP3   = 'MPEG-1 - Audio Format';
  FORMAT_DESCRIPTION_SWF   = 'Adobe - Shockwave Flash Format';
  FORMAT_DESCRIPTION_GIF   = 'CompuServe - Image Format';
  FORMAT_DESCRIPTION_EXE   = 'Microsoft - Portable Executable Format';
  FORMAT_DESCRIPTION_DLL   = 'Microsoft - Dynamic-link Library Format';
  FORMAT_DESCRIPTION_3GP   = '3GPP - Multimedia Container Format';
  FORMAT_DESCRIPTION_3G2   = '3GPP 2 - Multimedia Container Format';
  FORMAT_DESCRIPTION_SWS   = 'Adobe - Shockwave Stream Format';
  FORMAT_DESCRIPTION_SIFF  = 'Beam Software - Multimedia Container Format';
  FORMAT_DESCRIPTION_FLV   = 'Adobe - Flash Video Container Format';
  FORMAT_DESCRIPTION_RMF   = 'Real - Video Container Format';
  FORMAT_DESCRIPTION_ASF   = 'Microsoft - Multimedia Container Format';
  FORMAT_DESCRIPTION_SND   = 'Sun - Audio Format';
  FORMAT_DESCRIPTION_3DS   = 'Autodesk - 3D Studio Model Format';
  FORMAT_DESCRIPTION_WVPK  = 'WavPack - Audio Format';
  FORMAT_DESCRIPTION_RAF   = 'Real - Audio Container Format';
  FORMAT_DESCRIPTION_SMK   = 'RadTools - Video Container Format';
  FORMAT_DESCRIPTION_XBG   = 'Microsoft - XBox Model Format';
  FORMAT_DESCRIPTION_XPR0  = 'Microsoft - XBox Packed Resource File';
  FORMAT_DESCRIPTION_XPR2  = 'Microsoft - XBox360 Packed Resource File';
  FORMAT_DESCRIPTION_XMV   = 'Microsoft - XBox Video Container Format';
  FORMAT_DESCRIPTION_TTF   = 'Apple - TrueType Font Format';
  FORMAT_DESCRIPTION_XWMA  = 'Microsoft - Audio Format';
  FORMAT_DESCRIPTION_CAB   = 'Microsoft - Archive Format';
  FORMAT_DESCRIPTION_XNB   = 'Microsoft - XNA Binary Format';
  FORMAT_DESCRIPTION_WAD2  = 'GameStudio - Texture Format';
  FORMAT_DESCRIPTION_MDL7  = 'GameStudio - Model v7 Format';
  FORMAT_DESCRIPTION_4XM   = '4X - Video Container Format';
  FORMAT_DESCRIPTION_PSMF  = 'Sony - PlayStation Portable Video Format';
  FORMAT_DESCRIPTION_FLI   = 'Autodesk - FLIC Animation Format';
  FORMAT_DESCRIPTION_FLC   = 'Autodesk - FLIC Animation Format';
  FORMAT_DESCRIPTION_FLX   = 'Autodesk - FLIC Animation Format';
  FORMAT_DESCRIPTION_TTA   = 'True Audio - Audio Format';
  FORMAT_DESCRIPTION_OFR   = 'OptimFROG - Audio Format';
  FORMAT_DESCRIPTION_LA    = 'La Lossless - Audio Format';
  FORMAT_DESCRIPTION_LPAC  = 'LPAC - Audio Format';
  FORMAT_DESCRIPTION_VQF   = 'TwinVQ - Audio Format';
  FORMAT_DESCRIPTION_AVS   = 'Argonaut Games - Video Format';
  FORMAT_DESCRIPTION_NSV   = 'Nullsoft - Video Container Format';
  FORMAT_DESCRIPTION_PVA   = 'TechnoTrend - Multimedia Container Format';

  FORMAT_DESCRIPTION_BRES  = 'Nintendo - Wii Binary Container Format ?';
  FORMAT_DESCRIPTION_REFT  = 'Nintendo - Wii Effect Container Format ?';
  FORMAT_DESCRIPTION_RFNA  = 'Nintendo - Wii Font Container Format ?';
  FORMAT_DESCRIPTION_RFNT  = 'Nintendo - Wii Font Container Format ?';
  FORMAT_DESCRIPTION_RSAR  = 'Nintendo - Wii Audio Container Format ?';
  FORMAT_DESCRIPTION_RSTM  = 'Nintendo - Wii Audio Stream Container ?';

  FORMAT_DESCRIPTION_GR2   = 'RadTools - Model Format';
  FORMAT_DESCRIPTION_LWO2  = 'LightWave - Model Format';

  FORMAT_DESCRIPTION_SDAT  = 'Nintendo - DS Audio Data Format ?';
  FORMAT_DESCRIPTION_SSEQ  = 'Nintendo - DS Audio Sequence Format';
  FORMAT_DESCRIPTION_SSAR  = 'Nintendo - DS Audio Sequence Archive Format ?';
  FORMAT_DESCRIPTION_SWAR  = 'Nintendo - DS Audio Archive Format ?';
  FORMAT_DESCRIPTION_SBNK  = 'Nintendo - DS Audio Bank Info Format ?';

  FORMAT_DESCRIPTION_NCER  = 'Nintendo - DS CEll Resource Format ?';
  FORMAT_DESCRIPTION_NANR  = 'Nintendo - DS Animation Format ?';
  FORMAT_DESCRIPTION_NCLR  = 'Nintendo - DS Color Resource Format ?';
  FORMAT_DESCRIPTION_NARC  = 'Nintendo - DS Archive Format ?';
  FORMAT_DESCRIPTION_8SVX  = 'Amiga - Audio Format';
  FORMAT_DESCRIPTION_DMSC  = 'Microsoft - DirectMusic Script Format';
  FORMAT_DESCRIPTION_DMSG  = 'Microsoft - DirectMusic Segment Format';
  FORMAT_DESCRIPTION_THP   = 'Nintendo - Video Format';
  FORMAT_DESCRIPTION_FILM  = 'Sega - Video Format';

  FORMAT_DESCRIPTION_RAS  = 'SUN - Raster File Format';
  FORMAT_DESCRIPTION_DPX1 = 'SMPTE - Digital Picture Exchange Format v1.0';
  FORMAT_DESCRIPTION_DPX4 = 'SMPTE - Digital Picture Exchange Format v4.5';
  FORMAT_DESCRIPTION_R3D  = 'Redcode - RAW Video Format';

  FORMAT_DESCRIPTION_XBG2   = 'Microsoft - XBox Model Format v2';
  FORMAT_DESCRIPTION_XBG3   = 'Microsoft - XBox Model Format v3';
  FORMAT_DESCRIPTION_XBG4   = 'Microsoft - XBox Model Format v4';
  FORMAT_DESCRIPTION_XBG5   = 'Microsoft - XBox Model Format v5';
  FORMAT_DESCRIPTION_XBG6   = 'Microsoft - XBox Model Format v6';
  FORMAT_DESCRIPTION_XBG7   = 'Microsoft - XBox Model Format v7';

///////////////////////////////////////

implementation

end.
