unit FileRipperFormats;

interface

uses
  FileRipperSections,
  FileRipperMarkers,
  FileRipperExtensions,
  FileRipperDescriptions,
  FileRipperShared,
  FileRipperScanner;

const
  FORMAT_TYPE_UNKNOWN : TFormatType = (
    Enabled: False;
    Index: 0;
    Offset: 0;
    Marker: 0;
    Scanner: nil;
    MinSize: 0;
    Section: FORMAT_SECTION_NONE;
    Extension: 'UNKNOWN';
    Description: 'Unknown format';
  );

//-------------------------------
// Audio
//-------------------------------

  FORMAT_TYPE_SND : TFormatType = (
    Enabled: True;
    Index: 1;
    Offset: 0;
    Marker: FORMAT_MARKER_SND;
    Scanner: SearchSND;
    MinSize: 0;
    Section: FORMAT_SECTION_AUDIO;
    Extension: FORMAT_EXTENSION_SND;
    Description: FORMAT_DESCRIPTION_SND;
  );

  FORMAT_TYPE_TTA : TFormatType = (
    Enabled: True;
    Index: 2;
    Offset: 0;
    Marker: FORMAT_MARKER_TTA;
    Scanner: SearchTTA;
    MinSize: 0;
    Section: FORMAT_SECTION_AUDIO;
    Extension: FORMAT_EXTENSION_TTA;
    Description: FORMAT_DESCRIPTION_TTA;
  );

  FORMAT_TYPE_APE : TFormatType = (
    Enabled: True;
    Index: 3;
    Offset: 0;
    Marker: FORMAT_MARKER_APE;
    Scanner: SearchAPE;
    MinSize: 0;
    Section: FORMAT_SECTION_AUDIO;
    Extension: FORMAT_EXTENSION_APE;
    Description: FORMAT_DESCRIPTION_APE;
  );

  FORMAT_TYPE_RAF : TFormatType = (
    Enabled: True;
    Index: 4;
    Marker: FORMAT_MARKER_RAF;
    Scanner: SearchRAF;
    MinSize: 0;
    Section: FORMAT_SECTION_AUDIO;
    Extension: FORMAT_EXTENSION_RAF;
    Description: FORMAT_DESCRIPTION_RAF;
  );

  FORMAT_TYPE_OFR : TFormatType = (
    Enabled: True;
    Index: 5;
    Offset: 0;
    Marker: FORMAT_MARKER_OFR;
    Scanner: SearchOFR;
    MinSize: 0;
    Section: FORMAT_SECTION_AUDIO;
    Extension: FORMAT_EXTENSION_OFR;
    Description: FORMAT_DESCRIPTION_OFR;
  );

  FORMAT_TYPE_VQF : TFormatType = (
    Enabled: True;
    Index: 6;
    Offset: 0;
    Marker: FORMAT_MARKER_VQF;
    Scanner: SearchVQF;
    MinSize: 0;
    Section: FORMAT_SECTION_AUDIO;
    Extension: FORMAT_EXTENSION_VQF;
    Description: FORMAT_DESCRIPTION_VQF;
  );

  FORMAT_TYPE_MIDI : TFormatType = (
    Enabled: True;
    Index: 7;
    Offset: 0;
    Marker: FORMAT_MARKER_MIDI;
    Scanner: SearchMIDI;
    MinSize: 0;
    Section: FORMAT_SECTION_AUDIO;
    Extension: FORMAT_EXTENSION_MIDI;
    Description: FORMAT_DESCRIPTION_MIDI;
  );

  FORMAT_TYPE_SIFF : TFormatType = (
    Enabled: True;
    Index: 8;
    Offset: 0;
    Marker: FORMAT_MARKER_SIFF;
    Scanner: SearchSIFF;
    MinSize: 0;
    Section: FORMAT_SECTION_AUDIO;
    Extension: FORMAT_EXTENSION_SIFF;
    Description: FORMAT_DESCRIPTION_SIFF;
  );

  FORMAT_TYPE_WVPK : TFormatType = (
    Enabled: True;
    Index: 9;
    Offset: 0;
    Marker: FORMAT_MARKER_WVPK;
    Scanner: SearchWVPK;
    MinSize: 0;
    Section: FORMAT_SECTION_AUDIO;
    Extension: FORMAT_EXTENSION_WVPK;
    Description: FORMAT_DESCRIPTION_WVPK;
  );

  FORMAT_TYPE_LPAC : TFormatType = (
    Enabled: True;
    Index: 10;
    Offset: 0;
    Marker: FORMAT_MARKER_LPAC;
    Scanner: SearchLPAC;
    MinSize: 0;
    Section: FORMAT_SECTION_AUDIO;
    Extension: FORMAT_EXTENSION_LPAC;
    Description: FORMAT_DESCRIPTION_LPAC;
  );

  FORMAT_TYPE_8SVX : TFormatType = (
    Enabled: True;
    Index: 11;
    Offset: 0;
    Marker: FORMAT_MARKER_IFF;
    Scanner: SearchIFF;
    MinSize: 0;
    Section: FORMAT_SECTION_AUDIO;
    Extension: FORMAT_EXTENSION_8SVX;
    Description: FORMAT_DESCRIPTION_8SVX;
  );

//-------------------------------
// Video
//-------------------------------

  FORMAT_TYPE_BIK : TFormatType = (
    Enabled: True;
    Index: 12;
    Offset: 0;
    Marker: FORMAT_MARKER_BIK;
    Scanner: SearchBIK;
    MinSize: 0;
    Section: FORMAT_SECTION_VIDEO;
    Extension: FORMAT_EXTENSION_BIK;
    Description: FORMAT_DESCRIPTION_BIK;
  );

  FORMAT_TYPE_SMK : TFormatType = (
    Enabled: True;
    Index: 13;
    Offset: 0;
    Marker: FORMAT_MARKER_SMK;
    Scanner: SearchSMK;
    MinSize: 0;
    Section: FORMAT_SECTION_VIDEO;
    Extension: FORMAT_EXTENSION_SMK;
    Description: FORMAT_DESCRIPTION_SMK;
  );

  FORMAT_TYPE_4XM : TFormatType = (
    Enabled: True;
    Index: 14;
    Offset: 0;
    Marker: FORMAT_MARKER_RIFF;
    Scanner: SearchRIFF;
    MinSize: 0;
    Section: FORMAT_SECTION_VIDEO;
    Extension: FORMAT_EXTENSION_4XM;
    Description: FORMAT_DESCRIPTION_4XM;
  );

  FORMAT_TYPE_AVS : TFormatType = (
    Enabled: True;
    Index: 15;
    Offset: 0;
    Marker: FORMAT_MARKER_AVS;
    Scanner: SearchAVS;
    MinSize: 0;
    Section: FORMAT_SECTION_VIDEO;
    Extension: FORMAT_EXTENSION_AVS;
    Description: FORMAT_DESCRIPTION_AVS;
  );

  FORMAT_TYPE_NSV : TFormatType = (
    Enabled: True;
    Index: 16;
    Offset: 0;
    Marker: FORMAT_MARKER_NSV;
    Scanner: SearchNSV;
    MinSize: 0;
    Section: FORMAT_SECTION_VIDEO;
    Extension: FORMAT_EXTENSION_NSV;
    Description: FORMAT_DESCRIPTION_NSV;
  );

  FORMAT_TYPE_PVA : TFormatType = (
    Enabled: True;
    Index: 17;
    Offset: 0;
    Marker: FORMAT_MARKER_PVA;
    Scanner: SearchPVA;
    MinSize: 0;
    Section: FORMAT_SECTION_VIDEO;
    Extension: FORMAT_EXTENSION_PVA;
    Description: FORMAT_DESCRIPTION_PVA;
  );

//-------------------------------
// Image
//-------------------------------

  FORMAT_TYPE_PNG : TFormatType = (
    Enabled: True;
    Index: 18;
    Offset: 0;
    Marker: FORMAT_MARKER_PNG;
    Scanner: SearchPNG;
    MinSize: 0;
    Section: FORMAT_SECTION_IMAGE;
    Extension: FORMAT_EXTENSION_PNG;
    Description: FORMAT_DESCRIPTION_PNG;
  );

  FORMAT_TYPE_DDS : TFormatType = (
    Enabled: True;
    Index: 19;
    Offset: 0;
    Marker: FORMAT_MARKER_DDS;
    Scanner: SearchDDS;
    MinSize: 0;
    Section: FORMAT_SECTION_IMAGE;
    Extension: FORMAT_EXTENSION_DDS;
    Description: FORMAT_DESCRIPTION_DDS;
  );

  FORMAT_TYPE_GIF : TFormatType = (
    Enabled: False;
    Index: 20;
    Offset: 0;
    Marker: FORMAT_MARKER_GIF;
    Scanner: nil;
    MinSize: 0;
    Section: FORMAT_SECTION_IMAGE;
    Extension: FORMAT_EXTENSION_GIF;
    Description: FORMAT_DESCRIPTION_GIF;
  );

  FORMAT_TYPE_PSD : TFormatType = (
    Enabled: True;
    Index: 21;
    Offset: 0;
    Marker: FORMAT_MARKER_PSD;
    Scanner: SearchPSD;
    MinSize: 0;
    Section: FORMAT_SECTION_IMAGE;
    Extension: FORMAT_EXTENSION_PSD;
    Description: FORMAT_DESCRIPTION_PSD;
  );


//-------------------------------
// STREAM
//-------------------------------

  FORMAT_TYPE_SWS : TFormatType = (
    Enabled: True;
    Index: 22;
    Offset: 0;
    Marker: FORMAT_MARKER_SWS;
    Scanner: SearchSWS;
    MinSize: 0;
    Section: FORMAT_SECTION_STREAM;
    Extension: FORMAT_EXTENSION_SWS;
    Description: FORMAT_DESCRIPTION_SWS;
  );


//-------------------------------
// ARCHIVE
//-------------------------------

  FORMAT_TYPE_ZIP : TFormatType = (
    Enabled: True;
    Index: 23;
    Offset: 0;
    Marker: FORMAT_MARKER_ZIP;
    Scanner: SearchZIP;
    MinSize: 0;
    Section: FORMAT_SECTION_ARCHIVE;
    Extension: FORMAT_EXTENSION_ZIP;
    Description: FORMAT_DESCRIPTION_ZIP;
  );

  FORMAT_TYPE_7ZIP : TFormatType = (
    Enabled: True;
    Index: 24;
    Offset: 0;
    Marker: FORMAT_MARKER_7ZIP;
    Scanner: Search7ZIP;
    MinSize: 0;
    Section: FORMAT_SECTION_ARCHIVE;
    Extension: FORMAT_EXTENSION_7ZIP;
    Description: FORMAT_DESCRIPTION_7ZIP;
  );

  FORMAT_TYPE_CAB : TFormatType = (
    Enabled: True;
    Index: 25;
    Offset: 0;
    Marker: FORMAT_MARKER_CAB;
    Scanner: SearchCAB;
    MinSize: 0;
    Section: FORMAT_SECTION_ARCHIVE;
    Extension: FORMAT_EXTENSION_CAB;
    Description: FORMAT_DESCRIPTION_CAB;
  );

//-------------------------------
// MODEL
//-------------------------------

  FORMAT_TYPE_GR2 : TFormatType = (
    Enabled: True;
    Index: 26;
    Offset: 0;
    Marker: FORMAT_MARKER_GR2;
    Scanner: SearchGR2;
    MinSize: 0;
    Section: FORMAT_SECTION_MODEL;
    Extension: FORMAT_EXTENSION_GR2;
    Description: FORMAT_DESCRIPTION_GR2;
  );

  FORMAT_TYPE_LWO2 : TFormatType = (
    Enabled: True;
    Index: 27;
    Offset: 0;
    Marker: FORMAT_MARKER_IFF;
    Scanner: SearchIFF;
    MinSize: 0;
    Section: FORMAT_SECTION_MODEL;
    Extension: FORMAT_EXTENSION_LWO2;
    Description: FORMAT_DESCRIPTION_LWO2;
  );

//-------------------------------
// GAMESTUDIO
//-------------------------------

  FORMAT_TYPE_WAD2 : TFormatType = (
    Enabled: True;
    Index: 28;
    Offset: 0;
    Marker: FORMAT_MARKER_WAD2;
    Scanner: SearchWAD2;
    MinSize: 0;
    Section: FORMAT_SECTION_GAMESTUDIO;
    Extension: FORMAT_EXTENSION_WAD2;
    Description: FORMAT_DESCRIPTION_WAD2;
  );

  FORMAT_TYPE_MDL7 : TFormatType = (
    Enabled: True;
    Index: 29;
    Offset: 0;
    Marker: FORMAT_MARKER_MDL7;
    Scanner: SearchMDL7;
    MinSize: 0;
    Section: FORMAT_SECTION_GAMESTUDIO;
    Extension: FORMAT_EXTENSION_MDL7;
    Description: FORMAT_DESCRIPTION_MDL7;
  );

//-------------------------------
// PLAYSTATION
//-------------------------------

  FORMAT_TYPE_PSMF : TFormatType = (
    Enabled: True;
    Index: 30;
    Offset: 0;
    Marker: FORMAT_MARKER_PSMF;
    Scanner: SearchPSMF;
    MinSize: 0;
    Section: FORMAT_SECTION_PLAYSTATION;
    Extension: FORMAT_EXTENSION_PSMF;
    Description: FORMAT_DESCRIPTION_PSMF;
  );

//-------------------------------
// XBOX
//-------------------------------

  FORMAT_TYPE_XBG2 : TFormatType = (
    Enabled: True;
    Index: 31;
    Offset: 0;
    Marker: FORMAT_MARKER_XBG2;
    Scanner: SearchXBG2;
    MinSize: 0;
    Section: FORMAT_SECTION_XBOX;
    Extension: FORMAT_EXTENSION_XBG2;
    Description: FORMAT_DESCRIPTION_XBG2;
  );

  FORMAT_TYPE_XPR0 : TFormatType = (
    Enabled: True;
    Index: 32;
    Offset: 0;
    Marker: FORMAT_MARKER_XPR0;
    Scanner: SearchXPR0;
    MinSize: 0;
    Section: FORMAT_SECTION_XBOX;
    Extension: FORMAT_EXTENSION_XPR0;
    Description: FORMAT_DESCRIPTION_XPR0;
  );

  FORMAT_TYPE_XMV : TFormatType = (
    Enabled: False;
    Index: 33;
    Offset: 0;
    Marker: FORMAT_MARKER_XMV;
    Scanner: SearchXMV;
    MinSize: 0;
    Section: FORMAT_SECTION_XBOX;
    Extension: FORMAT_EXTENSION_XMV;
    Description: FORMAT_DESCRIPTION_XMV;
  );

  FORMAT_TYPE_XWMA : TFormatType = (
    Enabled: True;
    Index: 34;
    Offset: 0;
    Marker: FORMAT_MARKER_RIFF;
    Scanner: SearchRIFF;
    MinSize: 0;
    Section: FORMAT_SECTION_XBOX;
    Extension: FORMAT_EXTENSION_XWMA;
    Description: FORMAT_DESCRIPTION_XWMA;
  );


  FORMAT_TYPE_XNB : TFormatType = (
    Enabled: True;
    Index: 35;
    Offset: 0;
    Marker: FORMAT_MARKER_XNB;
    Scanner: SearchXNB;
    MinSize: 0;
    Section: FORMAT_SECTION_XBOX;
    Extension: FORMAT_EXTENSION_XNB;
    Description: FORMAT_DESCRIPTION_XNB;
  );

  FORMAT_TYPE_XPR2 : TFormatType = (
    Enabled: True;
    Index: 36;
    Offset: 0;
    Marker: FORMAT_MARKER_XPR2;
    Scanner: SearchXPR2;
    MinSize: 0;
    Section: FORMAT_SECTION_XBOX;
    Extension: FORMAT_EXTENSION_XPR2;
    Description: FORMAT_DESCRIPTION_XPR2;
  );

//-------------------------------
// NINTENDO
//-------------------------------

  // Wii
  FORMAT_TYPE_BRES : TFormatType = (
    Enabled: True;
    Index: 37;
    Offset: 0;
    Marker: FORMAT_MARKER_BRES;
    Scanner: SearchBRES;
    MinSize: 0;
    Section: FORMAT_SECTION_NINTENDO;
    Extension: FORMAT_EXTENSION_BRES;
    Description: FORMAT_DESCRIPTION_BRES;
  );

  FORMAT_TYPE_REFT : TFormatType = (
    Enabled: True;
    Index: 38;
    Offset: 0;
    Marker: FORMAT_MARKER_REFT;
    Scanner: SearchREFT;
    MinSize: 0;
    Section: FORMAT_SECTION_NINTENDO;
    Extension: FORMAT_EXTENSION_REFT;
    Description: FORMAT_DESCRIPTION_REFT;
  );

  FORMAT_TYPE_RFNA : TFormatType = (
    Enabled: True;
    Index: 39;
    Offset: 0;
    Marker: FORMAT_MARKER_RFNA;
    Scanner: SearchRFNA;
    MinSize: 0;
    Section: FORMAT_SECTION_NINTENDO;
    Extension: FORMAT_EXTENSION_RFNA;
    Description: FORMAT_DESCRIPTION_RFNA;
  );

  FORMAT_TYPE_RFNT : TFormatType = (
    Enabled: True;
    Index: 40;
    Offset: 0;
    Marker: FORMAT_MARKER_RFNT;
    Scanner: SearchRFNT;
    MinSize: 0;
    Section: FORMAT_SECTION_NINTENDO;
    Extension: FORMAT_EXTENSION_RFNT;
    Description: FORMAT_DESCRIPTION_RFNT;
  );

  FORMAT_TYPE_RSAR : TFormatType = (
    Enabled: True;
    Index: 41;
    Offset: 0;
    Marker: FORMAT_MARKER_RSAR;
    Scanner: SearchRSAR;
    MinSize: 0;
    Section: FORMAT_SECTION_NINTENDO;
    Extension: FORMAT_EXTENSION_RSAR;
    Description: FORMAT_DESCRIPTION_RSAR;
  );

  FORMAT_TYPE_RSTM : TFormatType = (
    Enabled: True;
    Index: 42;
    Offset: 0;
    Marker: FORMAT_MARKER_RSTM;
    Scanner: SearchRSTM;
    MinSize: 0;
    Section: FORMAT_SECTION_NINTENDO;
    Extension: FORMAT_EXTENSION_RSTM;
    Description: FORMAT_DESCRIPTION_RSTM;
  );
  // Nintendo DS ?
  FORMAT_TYPE_NCER : TFormatType = (
    Enabled: True;
    Index: 43;
    Offset: 0;
    Marker: FORMAT_MARKER_NCER;
    Scanner: SearchNCER;
    MinSize: 0;
    Section: FORMAT_SECTION_NINTENDO;
    Extension: FORMAT_EXTENSION_NCER;
    Description: FORMAT_DESCRIPTION_NCER;
  );

  FORMAT_TYPE_NANR : TFormatType = (
    Enabled: True;
    Index: 44;
    Offset: 0;
    Marker: FORMAT_MARKER_NANR;
    Scanner: SearchNANR;
    MinSize: 0;
    Section: FORMAT_SECTION_NINTENDO;
    Extension: FORMAT_EXTENSION_NANR;
    Description: FORMAT_DESCRIPTION_NANR;
  );

  FORMAT_TYPE_NCLR : TFormatType = (
    Enabled: True;
    Index: 45;
    Offset: 0;
    Marker: FORMAT_MARKER_NCLR;
    Scanner: SearchNCLR;
    MinSize: 0;
    Section: FORMAT_SECTION_NINTENDO;
    Extension: FORMAT_EXTENSION_NCLR;
    Description: FORMAT_DESCRIPTION_NCLR;
  );

  FORMAT_TYPE_NARC : TFormatType = (
    Enabled: True;
    Index: 46;
    Offset: 0;
    Marker: FORMAT_MARKER_NARC;
    Scanner: SearchNARC;
    MinSize: 0;
    Section: FORMAT_SECTION_NINTENDO;
    Extension: FORMAT_EXTENSION_NARC;
    Description: FORMAT_DESCRIPTION_NARC;
  );

  FORMAT_TYPE_SDAT : TFormatType = (
    Enabled: True;
    Index: 47;
    Offset: 0;
    Marker: FORMAT_MARKER_SDAT;
    Scanner: SearchSDAT;
    MinSize: 0;
    Section: FORMAT_SECTION_NINTENDO;
    Extension: FORMAT_EXTENSION_SDAT;
    Description: FORMAT_DESCRIPTION_SDAT;
  );

  FORMAT_TYPE_SSEQ : TFormatType = (
    Enabled: True;
    Index: 48;
    Offset: 0;
    Marker: FORMAT_MARKER_SSEQ;
    Scanner: SearchSSEQ;
    MinSize: 0;
    Section: FORMAT_SECTION_NINTENDO;
    Extension: FORMAT_EXTENSION_SSEQ;
    Description: FORMAT_DESCRIPTION_SSEQ;
  );

  FORMAT_TYPE_SSAR : TFormatType = (
    Enabled: True;
    Index: 49;
    Offset: 0;
    Marker: FORMAT_MARKER_SSAR;
    Scanner: SearchSSAR;
    MinSize: 0;
    Section: FORMAT_SECTION_NINTENDO;
    Extension: FORMAT_EXTENSION_SSAR;
    Description: FORMAT_DESCRIPTION_SSAR;
  );

  FORMAT_TYPE_SWAR : TFormatType = (
    Enabled: True;
    Index: 50;
    Offset: 0;
    Marker: FORMAT_MARKER_SWAR;
    Scanner: SearchSWAR;
    MinSize: 0;
    Section: FORMAT_SECTION_NINTENDO;
    Extension: FORMAT_EXTENSION_SWAR;
    Description: FORMAT_DESCRIPTION_SWAR;
  );

  FORMAT_TYPE_SBNK : TFormatType = (
    Enabled: True;
    Index: 51;
    Offset: 0;
    Marker: FORMAT_MARKER_SBNK;
    Scanner: SearchSBNK;
    MinSize: 0;
    Section: FORMAT_SECTION_NINTENDO;
    Extension: FORMAT_EXTENSION_SBNK;
    Description: FORMAT_DESCRIPTION_SBNK;
  );

  FORMAT_TYPE_THP : TFormatType = (
    Enabled: True;
    Index: 52;
    Offset: 0;
    Marker: FORMAT_MARKER_THP;
    Scanner: SearchTHP;
    MinSize: 0;
    Section: FORMAT_SECTION_NINTENDO;
    Extension: FORMAT_EXTENSION_THP;
    Description: FORMAT_DESCRIPTION_THP;
  );


//-------------------------------
// Container
//-------------------------------
  FORMAT_TYPE_AVI : TFormatType = (
    Enabled: True;
    Index: 53;
    Offset: 0;
    Marker: FORMAT_MARKER_RIFF;
    Scanner: SearchRIFF;
    MinSize: 0;
    Section: FORMAT_SECTION_CONTAINER;
    Extension: FORMAT_EXTENSION_AVI;
    Description: FORMAT_DESCRIPTION_AVI;
  );

  FORMAT_TYPE_WAV : TFormatType = (
    Enabled: True;
    Index: 54;
    Offset: 0;
    Marker: FORMAT_MARKER_RIFF;
    Scanner: SearchRIFF;
    MinSize: 0;
    Section: FORMAT_SECTION_CONTAINER;
    Extension: FORMAT_EXTENSION_WAV;
    Description: FORMAT_DESCRIPTION_WAV;
  );

  FORMAT_TYPE_RIFF : TFormatType = (
    Enabled: True;
    Index: 55;
    Offset: 0;
    Marker: FORMAT_MARKER_RIFF;
    Scanner: SearchRIFF;
    MinSize: 0;
    Section: FORMAT_SECTION_CONTAINER;
    Extension: FORMAT_EXTENSION_RIFF;
    Description: FORMAT_DESCRIPTION_RIFF;
  );

  FORMAT_TYPE_IFF : TFormatType = (
    Enabled: True;
    Index: 56;
    Offset: 0;
    Marker: FORMAT_MARKER_IFF;
    Scanner: SearchIFF;
    MinSize: 0;
    Section: FORMAT_SECTION_CONTAINER;
    Extension: FORMAT_EXTENSION_IFF;
    Description: FORMAT_DESCRIPTION_IFF;
  );

  FORMAT_TYPE_MOV : TFormatType = (
    Enabled: True;
    Index: 57;
    Offset: 0;
    Marker: FORMAT_MARKER_MOV;
    Scanner: SearchMOV;
    MinSize: 0;
    Section: FORMAT_SECTION_CONTAINER;
    Extension: FORMAT_EXTENSION_MOV;
    Description: FORMAT_DESCRIPTION_MOV;
  );

  FORMAT_TYPE_ASF : TFormatType = (
    Enabled: True;
    Index: 58;
    Offset: 0;
    Marker: FORMAT_MARKER_ASF;
    Scanner: SearchASF;
    MinSize: 0;
    Section: FORMAT_SECTION_CONTAINER;
    Extension: FORMAT_EXTENSION_ASF;
    Description: FORMAT_DESCRIPTION_ASF;
  );

  FORMAT_TYPE_MP4 : TFormatType = (
    Enabled: True;
    Index: 59;
    Offset: 0;
    Marker: FORMAT_MARKER_MP4;
    Scanner: SearchMP4;
    MinSize: 0;
    Section: FORMAT_SECTION_CONTAINER;
    Extension: FORMAT_EXTENSION_MP4;
    Description: FORMAT_DESCRIPTION_MP4;
  );

  FORMAT_TYPE_M4A : TFormatType = (
    Enabled: True;
    Index: 60;
    Offset: 0;
    Marker: FORMAT_MARKER_MP4;
    Scanner: SearchMP4;
    MinSize: 0;
    Section: FORMAT_SECTION_CONTAINER;
    Extension: FORMAT_EXTENSION_M4A;
    Description: FORMAT_DESCRIPTION_M4A;
  );

  FORMAT_TYPE_AIFF : TFormatType = (
    Enabled: True;
    Index: 61;
    Offset: 0;
    Marker: FORMAT_MARKER_IFF;
    Scanner: SearchIFF;
    MinSize: 0;
    Section: FORMAT_SECTION_CONTAINER;
    Extension: FORMAT_EXTENSION_AIFF;
    Description: FORMAT_DESCRIPTION_AIFF;
  );

  FORMAT_TYPE_OGG : TFormatType = (
    Enabled: True;
    Index: 62;
    Offset: 0;
    Marker: FORMAT_MARKER_OGG;
    Scanner: SearchOGG;
    MinSize: 0;
    Section: FORMAT_SECTION_CONTAINER;
    Extension: FORMAT_EXTENSION_OGG;
    Description: FORMAT_DESCRIPTION_OGG;
  );

  FORMAT_TYPE_3GP : TFormatType = (
    Enabled: True;
    Index: 63;
    Offset: 0;
    Marker: FORMAT_MARKER_MP4;
    Scanner: SearchMP4;
    MinSize: 0;
    Section: FORMAT_SECTION_CONTAINER;
    Extension: FORMAT_EXTENSION_3GP;
    Description: FORMAT_DESCRIPTION_3GP;
  );

  FORMAT_TYPE_3G2 : TFormatType = (
    Enabled: True;
    Index: 64;
    Offset: 0;
    Marker: FORMAT_MARKER_MP4;
    Scanner: SearchMP4;
    MinSize: 0;
    Section: FORMAT_SECTION_CONTAINER;
    Extension: FORMAT_EXTENSION_3G2;
    Description: FORMAT_DESCRIPTION_3G2;
  );

  FORMAT_TYPE_RMF : TFormatType = (
    Enabled: True;
    Index: 65;
    Offset: 0;
    Marker: FORMAT_MARKER_RMF;
    Scanner: SearchRMF;
    MinSize: 0;
    Section: FORMAT_SECTION_CONTAINER;
    Extension: FORMAT_EXTENSION_RMF;
    Description: FORMAT_DESCRIPTION_RMF;
  );

//-------------------------------
// OTHER
//-------------------------------

  FORMAT_TYPE_SWF : TFormatType = (
    Enabled: True;
    Index: 66;
    Offset: 0;
    Marker: FORMAT_MARKER_SWF;
    Scanner: SearchSWF;
    MinSize: 0;
    Section: FORMAT_SECTION_OTHER;
    Extension: FORMAT_EXTENSION_SWF;
    Description: FORMAT_DESCRIPTION_SWF;
  );

  FORMAT_TYPE_FLV : TFormatType = (
    Enabled: True;
    Index: 67;
    Offset: 0;
    Marker: FORMAT_MARKER_FLV;
    Scanner: SearchFLV;
    MinSize: 0;
    Section: FORMAT_SECTION_OTHER;
    Extension: FORMAT_EXTENSION_FLV;
    Description: FORMAT_DESCRIPTION_FLV;
  );

  FORMAT_TYPE_DMSC : TFormatType = (
    Enabled: True;
    Index: 68;
    Offset: 0;
    Marker: FORMAT_MARKER_RIFF;
    Scanner: SearchRIFF;
    MinSize: 0;
    Section: FORMAT_SECTION_OTHER;
    Extension: FORMAT_EXTENSION_DMSC;
    Description: FORMAT_DESCRIPTION_DMSC;
  );

  FORMAT_TYPE_DMSG : TFormatType = (
    Enabled: True;
    Index: 69;
    Offset: 0;
    Marker: FORMAT_MARKER_RIFF;
    Scanner: SearchRIFF;
    MinSize: 0;
    Section: FORMAT_SECTION_OTHER;
    Extension: FORMAT_EXTENSION_DMSG;
    Description: FORMAT_DESCRIPTION_DMSG;
  );

  FORMAT_TYPE_FILM : TFormatType = (
    Enabled: True;
    Index: 70;
    Offset: 0;
    Marker: FORMAT_MARKER_FILM;
    Scanner: SearchFILM;
    MinSize: 0;
    Section: FORMAT_SECTION_OTHER;
    Extension: FORMAT_EXTENSION_FILM;
    Description: FORMAT_DESCRIPTION_FILM;
  );

//-------------------------------
// MIXED - ADDED LATER
//-------------------------------
  FORMAT_TYPE_JFIF : TFormatType = (
    Enabled: True;
    Index: 71;
    Offset: -6;
    Marker: FORMAT_MARKER_JFIF;
    Scanner: SearchJFIF;
    MinSize: 0;
    Section: FORMAT_SECTION_IMAGE;
    Extension: FORMAT_EXTENSION_JFIF;
    Description: FORMAT_DESCRIPTION_JFIF;
  );

  FORMAT_TYPE_RAS : TFormatType = (
    Enabled: True;
    Index: 72;
    Offset: 0;
    Marker: FORMAT_MARKER_RAS;
    Scanner: SearchRAS;
    MinSize: 0;
    Section: FORMAT_SECTION_IMAGE;
    Extension: FORMAT_EXTENSION_RAS;
    Description: FORMAT_DESCRIPTION_RAS;
  );

  FORMAT_TYPE_DPX1 : TFormatType = (
    Enabled: True;
    Index: 73;
    Offset: 0;
    Marker: FORMAT_MARKER_DPX1;
    Scanner: SearchDPX1;
    MinSize: 0;
    Section: FORMAT_SECTION_IMAGE;
    Extension: FORMAT_EXTENSION_DPX1;
    Description: FORMAT_DESCRIPTION_DPX1;
  );

  FORMAT_TYPE_DPX4 : TFormatType = (
    Enabled: True;
    Index: 74;
    Offset: 0;
    Marker: FORMAT_MARKER_DPX4;
    Scanner: SearchDPX4;
    MinSize: 0;
    Section: FORMAT_SECTION_IMAGE;
    Extension: FORMAT_EXTENSION_DPX4;
    Description: FORMAT_DESCRIPTION_DPX4;
  );

  FORMAT_TYPE_R3D : TFormatType = (
    Enabled: True;
    Index: 75;
    Offset: -4;
    Marker: FORMAT_MARKER_R3D;
    Scanner: SearchR3D;
    MinSize: 0;
    Section: FORMAT_SECTION_VIDEO;
    Extension: FORMAT_EXTENSION_R3D;
    Description: FORMAT_DESCRIPTION_R3D;
  );

  FORMAT_TYPE_XBG3 : TFormatType = (
    Enabled: True;
    Index: 76;
    Offset: 0;
    Marker: FORMAT_MARKER_XBG3;
    Scanner: SearchXBG2;
    MinSize: 0;
    Section: FORMAT_SECTION_XBOX;
    Extension: FORMAT_EXTENSION_XBG3;
    Description: FORMAT_DESCRIPTION_XBG3;
  );

  FORMAT_TYPE_XBG4 : TFormatType = (
    Enabled: True;
    Index: 77;
    Offset: 0;
    Marker: FORMAT_MARKER_XBG4;
    Scanner: SearchXBG2;
    MinSize: 0;
    Section: FORMAT_SECTION_XBOX;
    Extension: FORMAT_EXTENSION_XBG4;
    Description: FORMAT_DESCRIPTION_XBG4;
  );

  FORMAT_TYPE_XBG5 : TFormatType = (
    Enabled: True;
    Index: 76;
    Offset: 0;
    Marker: FORMAT_MARKER_XBG5;
    Scanner: SearchXBG2;
    MinSize: 0;
    Section: FORMAT_SECTION_XBOX;
    Extension: FORMAT_EXTENSION_XBG5;
    Description: FORMAT_DESCRIPTION_XBG5;
  );

  FORMAT_TYPE_XBG6 : TFormatType = (
    Enabled: True;
    Index: 76;
    Offset: 0;
    Marker: FORMAT_MARKER_XBG6;
    Scanner: SearchXBG2;
    MinSize: 0;
    Section: FORMAT_SECTION_XBOX;
    Extension: FORMAT_EXTENSION_XBG6;
    Description: FORMAT_DESCRIPTION_XBG6;
  );

  FORMAT_TYPE_XBG7 : TFormatType = (
    Enabled: True;
    Index: 76;
    Offset: 0;
    Marker: FORMAT_MARKER_XBG7;
    Scanner: SearchXBG2;
    MinSize: 0;
    Section: FORMAT_SECTION_XBOX;
    Extension: FORMAT_EXTENSION_XBG7;
    Description: FORMAT_DESCRIPTION_XBG7;
  );




const
  FormatCount = 81;
  FormatTable : Array[0..FormatCount-1] of PFormatType = (
    @FORMAT_TYPE_UNKNOWN,

    // Container
    @FORMAT_TYPE_RIFF, @FORMAT_TYPE_IFF, @FORMAT_TYPE_AVI, @FORMAT_TYPE_WAV,
    @FORMAT_TYPE_MOV, @FORMAT_TYPE_ASF, @FORMAT_TYPE_MP4, @FORMAT_TYPE_M4A,
    @FORMAT_TYPE_AIFF, @FORMAT_TYPE_OGG, @FORMAT_TYPE_3GP, @FORMAT_TYPE_3G2,
    @FORMAT_TYPE_RMF,

    // Audio
    @FORMAT_TYPE_SND, @FORMAT_TYPE_TTA, @FORMAT_TYPE_APE, @FORMAT_TYPE_RAF,
    @FORMAT_TYPE_OFR, @FORMAT_TYPE_VQF, @FORMAT_TYPE_MIDI, @FORMAT_TYPE_SIFF,
    @FORMAT_TYPE_WVPK, @FORMAT_TYPE_LPAC, @FORMAT_TYPE_8SVX,
    // Video
    @FORMAT_TYPE_BIK, @FORMAT_TYPE_SMK, @FORMAT_TYPE_4XM, @FORMAT_TYPE_AVS,
    @FORMAT_TYPE_NSV, @FORMAT_TYPE_PVA, @FORMAT_TYPE_R3D,
    // Image
    @FORMAT_TYPE_PNG, @FORMAT_TYPE_DDS, @FORMAT_TYPE_GIF, @FORMAT_TYPE_PSD,
    @FORMAT_TYPE_JFIF, @FORMAT_TYPE_RAS, @FORMAT_TYPE_DPX1, @FORMAT_TYPE_DPX4,
    // Stream
    @FORMAT_TYPE_SWS,
    // Archive
    @FORMAT_TYPE_ZIP, @FORMAT_TYPE_7ZIP, @FORMAT_TYPE_CAB,
    // Model
    @FORMAT_TYPE_GR2, @FORMAT_TYPE_LWO2,
    // GameStudio
    @FORMAT_TYPE_WAD2, @FORMAT_TYPE_MDL7,
    // PlayStation
    @FORMAT_TYPE_PSMF,
    // Xbox
    @FORMAT_TYPE_XBG2, @FORMAT_TYPE_XPR0, @FORMAT_TYPE_XMV, @FORMAT_TYPE_XWMA,
    @FORMAT_TYPE_XBG3, @FORMAT_TYPE_XBG4, @FORMAT_TYPE_XBG5, @FORMAT_TYPE_XBG6,
    @FORMAT_TYPE_XBG7, @FORMAT_TYPE_XNB, @FORMAT_TYPE_XPR2,

    // Nintendo
    @FORMAT_TYPE_BRES, @FORMAT_TYPE_REFT, @FORMAT_TYPE_RFNA, @FORMAT_TYPE_RFNT,
    @FORMAT_TYPE_RSAR, @FORMAT_TYPE_RSTM,

    @FORMAT_TYPE_NCER, @FORMAT_TYPE_NANR, @FORMAT_TYPE_NCLR, @FORMAT_TYPE_NARC,
    @FORMAT_TYPE_SDAT, @FORMAT_TYPE_SSEQ, @FORMAT_TYPE_SSAR, @FORMAT_TYPE_SWAR,
    @FORMAT_TYPE_SBNK, @FORMAT_TYPE_THP,

    // Other
    @FORMAT_TYPE_SWF, @FORMAT_TYPE_FLV, @FORMAT_TYPE_DMSC, @FORMAT_TYPE_DMSG,
    @FORMAT_TYPE_FILM
  );

procedure IncludeFormat(const FormatTypeSet: PFormatTypeSet; const FormatType: PFormatType);
procedure ExcludeFormat(const FormatTypeSet: PFormatTypeSet; const FormatType: PFormatType);
function IsFormatIncluded(const FormatTypeSet: PFormatTypeSet; const FormatType: PFormatType):BOOLEAN;

implementation

procedure IncludeFormat(const FormatTypeSet: PFormatTypeSet; const FormatType: PFormatType);
begin
  FormatTypeSet^[FormatType^.Index]:= FormatType;
end;

procedure ExcludeFormat(const FormatTypeSet: PFormatTypeSet; const FormatType: PFormatType);
begin
  FormatTypeSet^[FormatType^.Index]:= nil;
end;

function IsFormatIncluded(const FormatTypeSet: PFormatTypeSet; const FormatType: PFormatType):BOOLEAN;
begin
  Result:= FormatTypeSet^[FormatType^.Index] <> nil;
end;

end.
