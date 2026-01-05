unit SharedTypes;

interface

uses Windows;

const
 DefArrayInc = 100; // Default Increament for arrays
 DefExtLen = 4; // Default length of file extension

///////////////////////////////////////
/// Section Names
  FORMAT_SECTION_NAME_NONE  ='None';
  FORMAT_SECTION_NAME_AUDIO ='Audio';
  FORMAT_SECTION_NAME_VIDEO = 'Video';
  FORMAT_SECTION_NAME_IMAGE ='Image';
  FORMAT_SECTION_NAME_STREAM  ='Stream';
  FORMAT_SECTION_NAME_ARCHIVE ='Archive';
  FORMAT_SECTION_NAME_MODEL ='Model';
  FORMAT_SECTION_NAME_XBOX  ='XBox';
  FORMAT_SECTION_NAME_XBOX360 ='XBox360';
  FORMAT_SECTION_NAME_PLAYSTATION ='PlayStation';
  FORMAT_SECTION_NAME_NINTENDO  ='Nintendo';
  FORMAT_SECTION_NAME_GAMESTUDIO  ='GameStudio';
  FORMAT_SECTION_NAME_OTHER ='Other';

/// Section Names
///////////////////////////////////////

///////////////////////////////////////
/// Format Extension
  FORMAT_EXTENSION_NONE   = 'NONE';
  FORMAT_EXTENSION_WAV_0  = 'WAV';
  FORMAT_EXTENSION_OGG_0  = 'OGG';

  FORMAT_EXTENSION_AVI_0  = 'AVI';
  FORMAT_EXTENSION_BIK_0  = 'BIK';

  FORMAT_EXTENSION_JFIF_0 = 'JPG';
  FORMAT_EXTENSION_DDS_0  = 'DDS';
  FORMAT_EXTENSION_PNG_0  = 'PNG';
  FORMAT_EXTENSION_TGA_0  = 'TGA';
  FORMAT_EXTENSION_BMP_0  = 'BMP';
  FORMAT_EXTENSION_ZLIB_0 = 'ZLIB';
  FORMAT_EXTENSION_APE_0  = 'APE';
  FORMAT_EXTENSION_M4A_0  = 'M4A';
  FORMAT_EXTENSION_MP4_0  = 'MP4';
  FORMAT_EXTENSION_MOV_0  = 'MOV';
  FORMAT_EXTENSION_7Z_0   = '7Z';
  FORMAT_EXTENSION_ZIP_0  = 'ZIP';
  FORMAT_EXTENSION_AIFF_0 = 'AIFF';
  FORMAT_EXTENSION_MIDI_0 = 'MIDI';
  FORMAT_EXTENSION_PSD_0  = 'PSD';
  FORMAT_EXTENSION_MP3_0  = 'MP3';
  FORMAT_EXTENSION_SWF_0  = 'SWF';
  FORMAT_EXTENSION_GIF_0  = 'GIF';
  FORMAT_EXTENSION_EXE_0  = 'EXE';
  FORMAT_EXTENSION_DLL_0  = 'DLL';
  FORMAT_EXTENSION_3GP_0  = '3GP';
  FORMAT_EXTENSION_3G2_0  = '3G2';
  FORMAT_EXTENSION_SWS_0  = 'SWS';
  FORMAT_EXTENSION_SIFF_0 = 'SIFF';
  FORMAT_EXTENSION_FLV_0  = 'FLV';
  FORMAT_EXTENSION_RMF_0  = 'RMF';
  FORMAT_EXTENSION_ASF_0  = 'ASF';
  FORMAT_EXTENSION_SND_0  = 'SND';
  FORMAT_EXTENSION_3DS_0  = '3DS';
  FORMAT_EXTENSION_WVPK_0 = 'WVPK';
  FORMAT_EXTENSION_RAF_0  = 'RAF';
  FORMAT_EXTENSION_SMK_0  = 'SMK';
  FORMAT_EXTENSION_XBG_0  = 'XBG';
  FORMAT_EXTENSION_XPR_0  = 'XPR';
  FORMAT_EXTENSION_XPR_2  = 'XPR';
  FORMAT_EXTENSION_XMV_0  = 'XMV';
  FORMAT_EXTENSION_TTF_0  = 'TTF';
  FORMAT_EXTENSION_XWMA_0 = 'XWMA';
  FORMAT_EXTENSION_CAB_0  = 'CAB';
  FORMAT_EXTENSION_XNB_0  = 'XNB';
  FORMAT_EXTENSION_WAD_0  = 'WAD';
  FORMAT_EXTENSION_MDL_7 = 'MDL7';
  FORMAT_EXTENSION_4XM_0  = '4XM';
  FORMAT_EXTENSION_PSMF_0 = 'PSMF';
  FORMAT_EXTENSION_FLI_0  = 'FLI';
  FORMAT_EXTENSION_FLC_0  = 'FLC';
  FORMAT_EXTENSION_FLX_0  = 'FLX';
  FORMAT_EXTENSION_TTA_0  = 'TTA';
  FORMAT_EXTENSION_OFR_0  = 'OFR';
  FORMAT_EXTENSION_LA_0   = 'LA';
  FORMAT_EXTENSION_LPAC_0 = 'LPAC';
  FORMAT_EXTENSION_VQF_0  = 'VQF';
  FORMAT_EXTENSION_AVS_0  = 'AVS';
  FORMAT_EXTENSION_NSV_0  = 'NSV';
  FORMAT_EXTENSION_PVA_0  = 'PVA';
  FORMAT_EXTENSION_BRES_0 = 'BRES';
  FORMAT_EXTENSION_REFT_0 = 'REFT';
  FORMAT_EXTENSION_RFNA_0 = 'RFNA';
  FORMAT_EXTENSION_RFNT_0 = 'RFNT';
  FORMAT_EXTENSION_RSAR_0 = 'RSAR';
  FORMAT_EXTENSION_RSTM_0 = 'RSTM';
  FORMAT_EXTENSION_GR2_0  = 'GR2';
  FORMAT_EXTENSION_LWO2_0 = 'LWO2';
  FORMAT_EXTENSION_SDAT_0 = 'SDAT';
  FORMAT_EXTENSION_SSEQ_0 = 'SSEQ';
  FORMAT_EXTENSION_SSAR_0 = 'SSAR';
  FORMAT_EXTENSION_SWAR_0 = 'SWAR';
  FORMAT_EXTENSION_SBNK_0 = 'SBNK';
  FORMAT_EXTENSION_NCER_0 = 'NCER';
  FORMAT_EXTENSION_NANR_0 = 'NANR';
  FORMAT_EXTENSION_NCLR_0 = 'NCLR';
  FORMAT_EXTENSION_NARC_0 = 'NARC';
  FORMAT_EXTENSION_8SVX_0 = '8SVX';
  FORMAT_EXTENSION_DMSC_0 = 'DMSC';
  FORMAT_EXTENSION_DMSG_0 = 'DMSG';
  FORMAT_EXTENSION_THP_0  = 'THP';
  FORMAT_EXTENSION_FILM_0 = 'FILM';

///
///////////////////////////////////////

///////////////////////////////////////
/// Format Name
  FORMAT_NAME_NONE    = 'No Format';
  FORMAT_NAME_WAV_0   = 'Waveform Audio Format';
  FORMAT_NAME_OGG_0   = 'Xiph Multimedia Container Format';

  FORMAT_NAME_AVI_0   = 'Microsoft Video Container Format';
  FORMAT_NAME_BIK_0   = 'RadTools Video Container Format';

  FORMAT_NAME_JFIF_0  = 'JPEG - Image Format';
  FORMAT_NAME_DDS_0   = 'Microsoft - Texture Format';
  FORMAT_NAME_PNG_0   = 'PNGLib - Image Format';
  FORMAT_NAME_TGA_0   = 'Truevision - Image Format';
  FORMAT_NAME_BMP_0   = 'Microsoft - Image Format';
  FORMAT_NAME_ZLIB_0  = 'Deflate Compression Format';
  FORMAT_NAME_APE_0   = 'Monkeys Audio - Audio Format';
  FORMAT_NAME_M4A_0   = 'Apple - Multimedia Container Format';
  FORMAT_NAME_MP4_0   = 'MPEG-4 - Multimedia Container Format';
  FORMAT_NAME_MOV_0   = 'Apple - Multimedia Container Format';
  FORMAT_NAME_7Z_0    = '7-Zip - Archive Format';
  FORMAT_NAME_ZIP_0   = 'PKZIP - Archive Format';
  FORMAT_NAME_AIFF_0  = 'Apple - Audio Container Format';
  FORMAT_NAME_MIDI_0  = 'MIDI - Audio Format';
  FORMAT_NAME_PSD_0   = 'Adobe - Photoshop Document Format';
  FORMAT_NAME_MP3_0   = 'MPEG-1 - Audio Format';
  FORMAT_NAME_SWF_0   = 'Adobe - Shockwave Flash Format';
  FORMAT_NAME_GIF_0   = 'CompuServe - Image Format';
  FORMAT_NAME_EXE_0   = 'Microsoft - Portable Executable Format';
  FORMAT_NAME_DLL_0   = 'Microsoft - Dynamic-link Library Format';
  FORMAT_NAME_3GP_0   = '3GPP - Multimedia Container Format';
  FORMAT_NAME_3G2_0   = '3GPP 2 - Multimedia Container Format';
  FORMAT_NAME_SWS_0   = 'Adobe - Shockwave Stream Format';
  FORMAT_NAME_SIFF_0  = 'Beam Software - Multimedia Container Format';
  FORMAT_NAME_FLV_0   = 'Adobe - Flash Video Container Format';
  FORMAT_NAME_RMF_0   = 'Real - Video Container Format';
  FORMAT_NAME_ASF_0   = 'Microsoft - Multimedia Container Format';
  FORMAT_NAME_SND_0   = 'Sun - Audio Format';
  FORMAT_NAME_3DS_0   = 'Autodesk - 3D Studio Model Format';
  FORMAT_NAME_WVPK_0  = 'WavPack - Audio Format';
  FORMAT_NAME_RAF_0   = 'Real - Audio Container Format';
  FORMAT_NAME_SMK_0   = 'RadTools - Video Container Format';
  FORMAT_NAME_XBG_0   = 'Microsoft - XBox Model Format';
  FORMAT_NAME_XPR_0   = 'Microsoft - XBox Packed Resource File';
  FORMAT_NAME_XPR_2   = 'Microsoft - XBox360 Packed Resource File';
  FORMAT_NAME_XMV_0   = 'Microsoft - XBox Video Container Format';
  FORMAT_NAME_TTF_0   = 'Apple - TrueType Font Format';
  FORMAT_NAME_XWMA_0  = 'Microsoft - Audio Format';
  FORMAT_NAME_CAB_0   = 'Microsoft - Archive Format';
  FORMAT_NAME_XNB_0   = 'Microsoft - XNA Binary Format';
  FORMAT_NAME_WAD_0   = 'GameStudio - Texture Format';
  FORMAT_NAME_MDL_7  = 'GameStudio - Model v7 Format';
  FORMAT_NAME_4XM_0   = '4X - Video Container Format';
  FORMAT_NAME_PSMF_0  = 'Sony - PlayStation Portable Video Format';
  FORMAT_NAME_FLI_0   = 'Autodesk - FLIC Animation Format';
  FORMAT_NAME_FLC_0   = 'Autodesk - FLIC Animation Format';
  FORMAT_NAME_FLX_0   = 'Autodesk - FLIC Animation Format';
  FORMAT_NAME_TTA_0   = 'True Audio - Audio Format';
  FORMAT_NAME_OFR_0   = 'OptimFROG - Audio Format';
  FORMAT_NAME_LA_0    = 'La Lossless - Audio Format';
  FORMAT_NAME_LPAC_0  = 'LPAC - Audio Format';
  FORMAT_NAME_VQF_0   = 'TwinVQ - Audio Format';
  FORMAT_NAME_AVS_0   = 'Argonaut Games - Video Format';
  FORMAT_NAME_NSV_0   = 'Nullsoft - Video Container Format';
  FORMAT_NAME_PVA_0   = 'TechnoTrend - Multimedia Container Format';

  FORMAT_NAME_BRES_0  = 'Nintendo - Wii Binary Container Format ?';
  FORMAT_NAME_REFT_0  = 'Nintendo - Wii Effect Container Format ?';
  FORMAT_NAME_RFNA_0  = 'Nintendo - Wii Font Container Format ?';
  FORMAT_NAME_RFNT_0  = 'Nintendo - Wii Font Container Format ?';
  FORMAT_NAME_RSAR_0  = 'Nintendo - Wii Audio Container Format ?';
  FORMAT_NAME_RSTM_0  = 'Nintendo - Wii Audio Stream Container ?';

  FORMAT_NAME_GR2_0   = 'RadTools - Model Format';
  FORMAT_NAME_LWO2_0  = 'LightWave - Model Format';

  FORMAT_NAME_SDAT_0  = 'Nintendo - DS Audio Data Format ?';
  FORMAT_NAME_SSEQ_0  = 'Nintendo - DS Audio Sequence Format';
  FORMAT_NAME_SSAR_0  = 'Nintendo - DS Audio Sequence Archive Format ?';
  FORMAT_NAME_SWAR_0  = 'Nintendo - DS Audio Archive Format ?';
  FORMAT_NAME_SBNK_0  = 'Nintendo - DS Audio Bank Info Format ?';

  FORMAT_NAME_NCER_0  = 'Nintendo - DS CEll Resource Format ?';
  FORMAT_NAME_NANR_0  = 'Nintendo - DS Animation Format ?';
  FORMAT_NAME_NCLR_0  = 'Nintendo - DS Color Resource Format ?';
  FORMAT_NAME_NARC_0  = 'Nintendo - DS Archive Format ?';
  FORMAT_NAME_8SVX_0  = 'Amiga - Audio Format';
  FORMAT_NAME_DMSC_0  = 'Microsoft - DirectMusic Script Format';
  FORMAT_NAME_DMSG_0  = 'Microsoft - DirectMusic Segment Format';
  FORMAT_NAME_THP_0   = 'Nintendo - Video Format';
  FORMAT_NAME_FILM_0  = 'Sega - Video Format';

///////////////////////////////////////

type
  TSaveLoad = (slLOAD,slSAVE);

  ByteArray = Array of Byte;
  pByteArray = ^ByteArray;

  TByteFile = File of Byte;
  pByteFile = ^TByteFile;

  TFileList = Array of String;
  pFileList = ^TFileList;


  //TFileNameEx = Array[0..1023] of Char;
  //PFileNameEx = ^TFileNameEx;
  //TFileExt = Array[0..15] of Char;



  TSearchOption = (soUnknown,soLoadSingleFile,soLoadMultiFile);
  TFileRipperSetting = Packed Record
    SearchOption:TSearchOption;

    SourceFile:ShortString;
    SourceFolder:ShortString;
    TargetFolder:ShortString;
    SourceExt:ShortString;
  end;

  TAlphaScanActionMode = (ModeAlphaReport, ModeAlphaCopy, ModeAlphaMove, ModeAlphaSplit);
  TAlphaScanSetting = Packed Record
    IsEnabled:Boolean;
    ActionMode:TAlphaScanActionMode;

    ExtraFolder:ShortString;
    SaveFileList:Boolean;
    FileListPath:ShortString;
  End;

  TTexToolSetting = Packed Record
    SourceFolder:ShortString;
    TargetFolder:ShortString;

    SaveTexRecData:Boolean;
    TexRecDataPath:ShortString;

    DelSourceFiles:Boolean;
    MinSourceFileSize:DWORD;

    JPGComLevel:BYTE;
    PNGComLevel:BYTE;
    EnableRLEComp:Boolean;
    DelMipMaps:Boolean;
    DelCubeMap:Boolean;
    DelVolTex:Boolean;

    AlphaSetting:TAlphaScanSetting;
  end;

  TDupeOption = (doNone,doReport,doMove,doCopy,doDelete,doErase);

  TDupeCheckerSetting = Packed Record
    SourceFolder:ShortString;
    TargetFolder:ShortString;
    SourceExt:ShortString;
    Prefix:ShortString;
    Option:TDupeOption;
    IsCMNameSet:Boolean;
    IsCMSizeSet:Boolean;
    IsCMExtSet:Boolean;
    IsCMPathSet:Boolean;
    IsCMDataSet:Boolean;
    CreateBatch:Boolean;
    BatchName:ShortString;
    FileListName:ShortString;
    CreateFileList:Boolean;
  end;

  TDataEraserSetting = Packed Record
    SourceFolder:ShortString;
    WriteRandom:BOOLEAN;
  end;

  TMsgSender = procedure (const Msg:ShortString);

implementation

end.
