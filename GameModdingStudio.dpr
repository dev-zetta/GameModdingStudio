program GameModdingStudio;

uses
  Forms,
  FileRip in 'Forms\FileRip.pas' {FileRipForm},
  About in 'Forms\About.pas' {AboutBox},
  Main in 'Forms\Main.pas' {MainForm},
  BlankFiles in 'Units\BlankFiles.pas',
  SharedTypes in 'Units\SharedTypes.pas',
  SharedFunc in 'Units\SharedFunc.pas',
  FileRipper in 'Units\FileRipper.pas',
  TextureConverter in 'Forms\TextureConverter.pas' {TextureConverterForm},
  Imaging in 'Sources\Imaging\Imaging.pas',
  ImagingBitmap in 'Sources\Imaging\ImagingBitmap.pas',
  ImagingCanvases in 'Sources\Imaging\ImagingCanvases.pas',
  ImagingClasses in 'Sources\Imaging\ImagingClasses.pas',
  ImagingColors in 'Sources\Imaging\ImagingColors.pas',
  ImagingComponents in 'Sources\Imaging\ImagingComponents.pas',
  ImagingDds in 'Sources\Imaging\ImagingDds.pas',
  ImagingExport in 'Sources\Imaging\ImagingExport.pas',
  ImagingFormats in 'Sources\Imaging\ImagingFormats.pas',
  ImagingGif in 'Sources\Imaging\ImagingGif.pas',
  ImagingIO in 'Sources\Imaging\ImagingIO.pas',
  ImagingJpeg in 'Sources\Imaging\ImagingJpeg.pas',
  ImagingNetworkGraphics in 'Sources\Imaging\ImagingNetworkGraphics.pas',
  ImagingPortableMaps in 'Sources\Imaging\ImagingPortableMaps.pas',
  ImagingTarga in 'Sources\Imaging\ImagingTarga.pas',
  ImagingTypes in 'Sources\Imaging\ImagingTypes.pas',
  ImagingUtility in 'Sources\Imaging\ImagingUtility.pas',
  imjcapimin in 'Sources\Imaging\JpegLib\imjcapimin.pas',
  imjcapistd in 'Sources\Imaging\JpegLib\imjcapistd.pas',
  imjccoefct in 'Sources\Imaging\JpegLib\imjccoefct.pas',
  imjccolor in 'Sources\Imaging\JpegLib\imjccolor.pas',
  imjcdctmgr in 'Sources\Imaging\JpegLib\imjcdctmgr.pas',
  imjcinit in 'Sources\Imaging\JpegLib\imjcinit.pas',
  imjcmainct in 'Sources\Imaging\JpegLib\imjcmainct.pas',
  imjcmarker in 'Sources\Imaging\JpegLib\imjcmarker.pas',
  imjcmaster in 'Sources\Imaging\JpegLib\imjcmaster.pas',
  imjcomapi in 'Sources\Imaging\JpegLib\imjcomapi.pas',
  imjcparam in 'Sources\Imaging\JpegLib\imjcparam.pas',
  imjcphuff in 'Sources\Imaging\JpegLib\imjcphuff.pas',
  imjcprepct in 'Sources\Imaging\JpegLib\imjcprepct.pas',
  imjcsample in 'Sources\Imaging\JpegLib\imjcsample.pas',
  imjdapimin in 'Sources\Imaging\JpegLib\imjdapimin.pas',
  imjdapistd in 'Sources\Imaging\JpegLib\imjdapistd.pas',
  imjdcoefct in 'Sources\Imaging\JpegLib\imjdcoefct.pas',
  imjdcolor in 'Sources\Imaging\JpegLib\imjdcolor.pas',
  imjdct in 'Sources\Imaging\JpegLib\imjdct.pas',
  imjddctmgr in 'Sources\Imaging\JpegLib\imjddctmgr.pas',
  imjdeferr in 'Sources\Imaging\JpegLib\imjdeferr.pas',
  imjdhuff in 'Sources\Imaging\JpegLib\imjdhuff.pas',
  imjdinput in 'Sources\Imaging\JpegLib\imjdinput.pas',
  imjdmainct in 'Sources\Imaging\JpegLib\imjdmainct.pas',
  imjdmarker in 'Sources\Imaging\JpegLib\imjdmarker.pas',
  imjdmaster in 'Sources\Imaging\JpegLib\imjdmaster.pas',
  imjdmerge in 'Sources\Imaging\JpegLib\imjdmerge.pas',
  imjdphuff in 'Sources\Imaging\JpegLib\imjdphuff.pas',
  imjdpostct in 'Sources\Imaging\JpegLib\imjdpostct.pas',
  imjdsample in 'Sources\Imaging\JpegLib\imjdsample.pas',
  imjerror in 'Sources\Imaging\JpegLib\imjerror.pas',
  imjfdctflt in 'Sources\Imaging\JpegLib\imjfdctflt.pas',
  imjfdctfst in 'Sources\Imaging\JpegLib\imjfdctfst.pas',
  imjfdctint in 'Sources\Imaging\JpegLib\imjfdctint.pas',
  imjchuff in 'Sources\Imaging\JpegLib\imjchuff.pas',
  imjidctasm in 'Sources\Imaging\JpegLib\imjidctasm.pas',
  imjidctflt in 'Sources\Imaging\JpegLib\imjidctflt.pas',
  imjidctfst in 'Sources\Imaging\JpegLib\imjidctfst.pas',
  imjidctint in 'Sources\Imaging\JpegLib\imjidctint.pas',
  imjidctred in 'Sources\Imaging\JpegLib\imjidctred.pas',
  imjinclude in 'Sources\Imaging\JpegLib\imjinclude.pas',
  imjmemmgr in 'Sources\Imaging\JpegLib\imjmemmgr.pas',
  imjmemnobs in 'Sources\Imaging\JpegLib\imjmemnobs.pas',
  imjmorecfg in 'Sources\Imaging\JpegLib\imjmorecfg.pas',
  imjpeglib in 'Sources\Imaging\JpegLib\imjpeglib.pas',
  imjquant1 in 'Sources\Imaging\JpegLib\imjquant1.pas',
  imjquant2 in 'Sources\Imaging\JpegLib\imjquant2.pas',
  imjutils in 'Sources\Imaging\JpegLib\imjutils.pas',
  dzlib in 'Sources\Imaging\ZLib\dzlib.pas',
  imadler in 'Sources\Imaging\ZLib\imadler.pas',
  iminfblock in 'Sources\Imaging\ZLib\iminfblock.pas',
  iminfcodes in 'Sources\Imaging\ZLib\iminfcodes.pas',
  iminffast in 'Sources\Imaging\ZLib\iminffast.pas',
  iminftrees in 'Sources\Imaging\ZLib\iminftrees.pas',
  iminfutil in 'Sources\Imaging\ZLib\iminfutil.pas',
  impaszlib in 'Sources\Imaging\ZLib\impaszlib.pas',
  imtrees in 'Sources\Imaging\ZLib\imtrees.pas',
  imzdeflate in 'Sources\Imaging\ZLib\imzdeflate.pas',
  imzinflate in 'Sources\Imaging\ZLib\imzinflate.pas',
  imzutil in 'Sources\Imaging\ZLib\imzutil.pas',
  SharedHeaders in 'Units\SharedHeaders.pas',
  TexConverter in 'Units\TexConverter.pas',
  ProcTimer in 'Units\ProcTimer.pas',
  FastDDSLoader in 'Units\FastDDSLoader.pas',
  DupeCheck in 'Forms\DupeCheck.pas' {DupeCheckForm},
  CRCFunc in 'Units\CRCFunc.pas',
  FastFileStream in 'Sources\FastFileStream.pas',
  DupeChecker in 'Units\DupeChecker.pas',
  SplashScreen in 'Forms\SplashScreen.pas' {SplashForm},
  LTWaterEffect in 'Sources\LTWaterEffect.pas',
  WAVPlayer in 'Units\WAVPlayer.pas',
  //ProgressBarEx in 'Sources\ProgressBarEx.pas',
  AsciiEditor in 'Forms\AsciiEditor.pas' {AsciiEditorForm},
  FastPSDLoader in 'Units\FastPSDLoader.pas',
  pelib in 'Sources\pelib.pas',
  DataErase in 'Forms\DataErase.pas' {DataEraseForm},
  AlphaScan in 'Forms\AlphaScan.pas' {AlphaScanForm},
  AlphaScanner in 'Units\AlphaScanner.pas',
  VastFile in 'Sources\VASTLIB\VastFile.pas',
  VastMemory in 'Sources\VASTLIB\VastMemory.pas',
  VastUtils in 'Sources\VASTLIB\VastUtils.pas',
  FileRipperDescriptions in 'Units\FileRipperDescriptions.pas',
  FileRipperMarkers in 'Units\FileRipperMarkers.pas',
  FileRipperExtensions in 'Units\FileRipperExtensions.pas',
  FileRipperHeaders in 'Units\FileRipperHeaders.pas',
  FileRipperScanner in 'Units\FileRipperScanner.pas',
  FileRipperFormats in 'Units\FileRipperFormats.pas',
  FileRipperShared in 'Units\FileRipperShared.pas',
  FileRipperSections in 'Units\FileRipperSections.pas',
  AsmFun in 'Units\AsmFun.pas',
  MultiGaugeX in 'Sources\MultiGaugeX.pas',
  SystemInfo in 'Units\SystemInfo.pas',
  GlobalRefresh in 'Units\GlobalRefresh.pas',
  MPEGScanner in 'Units\MPEGScanner.pas',
  MPEGTool in 'Forms\MPEGTool.pas' {MPEGToolForm},
  PluginLoader in 'Units\PluginLoader.pas',
  ExternalLoader in 'Units\ExternalLoader.pas',
  PluginInfo in 'Forms\PluginInfo.pas' {PluginInfoForm};

{$R *.RES}

begin
  SplashForm := TSplashForm.Create(Application);
  Application.Initialize;

  SplashForm.Show;
  SplashForm.Update;
  SplashForm.Hide;
  SplashForm.Free;

  Application.Title := 'Game Modding Studio';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  //Application.CreateForm(TPluginInfoForm, PluginInfoForm);
  //Application.CreateForm(TMPEGToolForm, MPEGToolForm);
  //Application.CreateForm(TDataEraseForm, DataEraseForm);
  //Application.CreateForm(TAlphaScanForm, AlphaScanForm);
  //Application.CreateForm(TNfoufoForm, NFoufoForm);
  //Application.CreateForm(TDupeCheckForm, DupeCheckForm);
  //Application.CreateForm(TSplashFrm, SplashFrm);
  //Application.CreateForm(TZlibRipForm, ZlibRipForm);
  //Application.CreateForm(TTexConvForm, TexConvForm);
  Application.Run;
end.
