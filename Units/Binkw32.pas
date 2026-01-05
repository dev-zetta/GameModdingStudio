{-------------------------------------------------------------------------------

                      BINK 1.0q LIBRARY HEADER FOR DELPHI
                        - By Lars Peter Christiansen.

                      http://home1.stofanet.dk/nitezhifter

PLEASE READ THIS :
   "Bink" is a video library from RAD Tools. You have to be licensed in order
   to use bink commercially.
   Visit RADTools for legal info :  www.smacker.com


   This file is a hack !
   Alot of record fields are still incomplete.
   Not all functions exists!
   I don't have the Bink SDK, and regardless of hours of search on the net, i
   haven't found any info/extracts of the SDK. All i had to go on, was the tiny
   info on RADTools website. Here is a list of approaches i used :
   - Reading any written info of the Bink (sdk overview, changelogs)
   - Reading any info of the Smacker (they might have things in common)
   - Disassembling of the Binkw32.dll  (names, parameters)
   - Disassembling and debugging of games using the lib. ( Diablo2 )
   - Creating various testing programs.(automating bitflags and stuff)


   Binkw32.dll versions:
   There are difference in function names and existence between the different
   library versions. They are not always backwards-compatible!


   DON'T RELEASE ANYTHING USING THIS FILE BEFORE YOU'VE READ AND UNDERSTOOD
   THE LEGAL INFO AT www.smacker.com !


02-08-2000:
   First version of the binkw32.pas.
   We can open and display a binkfile. Can't get the audio to work though!

22-10-2001:
   Did some research of the different versions of binkw32.dll. Seems that i've
   been working on some beta version, which caused the switch of colors on
   movies compiled at later dates. Movies play nicely now and works great with
   a standard windows bitmap.

23-10-2001:
   After some heavy analysis, the surfacetype constants fell into place. Still
   not sure about 8bit. Is it supported at all?
   After some _serious_ disassembling of Diablo2 and Red alert2 i finally solved
   the great puzzle of the sound system. Those callbacks really bugged me.
   Still can't create a custom sound system.

24-10-2001:
   After a bit RedAlert2 debugging, support for playing off a stream
   with offset has beed added.
   Added a GetBinkVersion() function.


-------------------------------------------------------------------------------}
unit binkw32;

interface
uses windows;

Const
  BinkDll = 'Plugins\Binkw32.dll';

Type

  HBink = ^Tbink;
  TBink = packed record
    Width,
    Height,
    Frames: Longword;
    CurrentFrame: longword;
    LastFrame: longword; // always "1" ?
    FrameRate:Longword;
    FrameRateDiv: Longword;
    Flags  : Longword; //bitflag
  end;

  TBinkRealTimeInfo = packed record
    CurrentFrame:Longword;
    FrameRate:longword;
    FrameRate2:longword;
    ActualFrameRate:longword;
    MSPrFrame : longword;
    data1 : array[0..5] of longword;
    f : double;
    DataRate:longword;
  end;

  TBinkSummary = packed record
    data1 : array[0..127] of byte;
  end;

  HbinkBuffer = pointer;


const
  // these might only work with certain files...
  BINK_OPEN_CRASH       = $4000; // bit 15. bink crashes! please help.
  BINK_OPEN_REVERSECOLOR= $8000; // bit 16. red->blue blue->red
  BINK_OPEN_GRAYSCALE   = $F0000; // bit 17. grayscale 
  BINK_OPEN_CRASH2      = $400000; // bit 23.
  BINK_OPEN_STREAM      = $800000; // BinkOpen() takes a filehandle instead of
                                   // Pchar
  BINK_OPEN_CRASH3      = $2000000; // bit 26.

  // Scaling flags
  BINK_OPEN_2xHEIGHT_DBL  = $10000000; // 28: Heightx2 doubled
  BINK_OPEN_2xHEIGHT_INT  = $20000000; // 29. Heightx2 interlaced
  BINK_OPEN_2xSIZE        = $40000000; // 30: stretches to double size(x&y)
  BINK_OPEN_2xWIDTH_DBL   = $30000000; // width x 2 doubled
  BINK_OPEN_2xSIZE_INT    = $50000000; // double size using interlace

  // CopyToBuffer Types.
  BINKSURFACE4444     =  7; // 16bit with 4 channels. each 4 bit.
  BINKSURFACE565R     =  8; // 16bit 565 reversed bitorder
  BINKSURFACE555R     =  9; // 16bit 555 reversed bitorder
  BINKSURFACE565      = 10; // 16bit 565. Standard for Windows Bitmaps
  BINKSURFACE555      = 11; // 16bit 565
  BINKSURFACE5551     = 12; // 16bit 555+1bit alpha. Weird!
  BINKSURFACE16INT    = 13; // 16bit strange interleaving ?!
  BINKSURFACE16INTR   = 14; // ..and reversed. Who uses this ?
  BINKSURFACE8        = 15; // haven't tested yet. it's a guess.
  BINKSURFACE24       = 17; // Normal 24bit
  BINKSURFACE24R      = 18; // reversed order
  BINKSURFACE32       = 19; // normal 32bit
  BINKSURFACE32R      = 20; // reversed order
  BINKSURFACE32A      = 21; // normal with alpha
  BINKSURFACE32AR     = 22; // reversed order with alpha


Function BinkOpen(Filename:Pchar;flags:LongWord) : Hbink;overload;
  stdcall external binkdll name'_BinkOpen@8';
Function BinkOpen(Filehandle:THandle;flags:LongWord) : Hbink;overload;
  stdcall external binkdll name'_BinkOpen@8';

procedure BinkClose(bink:Hbink);stdcall
  external binkdll name'_BinkClose@4';

function BinkGetError:Pchar;stdcall;
  external binkdll name'_BinkGetError@0';

Function BinkDoFrame(Bink:Hbink):LongWord;stdcall;
  external binkdll name'_BinkDoFrame@4';

Function BinkNextFrame(Bink:Hbink):LongWord;stdcall;
  external binkdll name'_BinkNextFrame@4';

Function BinkGoto(Bink:HBink;target,P3:Longword):Longword;
stdcall external binkdll name'_BinkGoto@12';

Function BinkCopyToBuffer(Bink:HBink;pBuf:Pointer;Pitch,unknown,Xoffset,Yoffset,
                          Flags:LongWord):LongWord;
                          stdcall external binkdll name '_BinkCopyToBuffer@28';

function BinkWait(Bink:Hbink):LongWord;
 stdcall external binkdll name '_BinkWait@4';

Function BinkSetVideoOnOff(Bink:Hbink;TurnOn:Longword):LongWord;
  stdcall external binkdll name'_BinkSetVideoOnOff@8';

function BinkOpenDirectSound:pointer;
function _BinkOpenDirectSound(P:pointer):longword;
  stdcall external binkdll name'_BinkOpenDirectSound@4';

function BinkOpenwaveOut:pointer;
function _BinkOpenwaveOut(p:pointer):longword;
  stdcall external binkdll name'_BinkOpenWaveOut@4';

Function BinkSetSoundSystem(SoundSystem:pointer;NotifyCallback:pointer):LongBool;
  stdcall external binkdll name'_BinkSetSoundSystem@8';
{-------------------------------------------------------------------------------
  BinkSetSoundSystem()

  there are predefined systemfunctions that opens sound :
    _BinkOpenDirectSound()
    _BinkOpenWaveOut()

  Delphi's external declarations is a wrap around the function,
  and since BinkSetSoundSystem() takes the direct pointer to a systemfunction
  you must use the "macros" :
    BinkOpenDirectSound
    BinkOpenWaveOut

  NotifyCallback = procedure(rsv1:pointer;Freq,Bits,Channels,
                             ScaleFlag:longword;Bink:HBINK);stdcall;

  rsv1 is apparently = Hbink - 270b .
  there is a sequence of 10 longwords that steadily increases at pos 216 !?

-------------------------------------------------------------------------------}

Function BinkDDSurfaceType(LPDIRECTDDRAWSURFACE:Pointer):LongWord;
  stdcall external binkdll name'_BinkDDSurfaceType@4';

Function BinkBufferOpen(wnd:LongWord;BlitType,width,height:LongWord):HBinkBuffer;
  stdcall external binkdll name'_BinkBufferOpen@16';

Function BinkSetVolume(Bink:Hbink;Volume:LongWord):LongWord;
  stdcall external binkdll name'_BinkSetVolume@12';

Function BinkSetSoundTrack(ArrayofID:PLongWord):LongWord;
  stdcall external binkdll name'_BinkSetSoundTrack@8';
Function BinkGetSummary(Bink:HBink;var sum:TBinkSummary):pchar;
  stdcall external binkdll name'_BinkGetSummary@8';
Function BinkLogoAddress:Pointer;
  stdcall external binkdll name'_BinkLogoAddress@0';
function BinkSetPan(bink:hbink;Pan:longword):longword;
  stdcall external binkdll name'_BinkSetPan@12';
Function BinkSetSoundOnOff(Bink:Hbink;TurnOn:LongBool):LongWord;
  stdcall external binkdll name'_BinkSetSoundOnOff@8';
function BinkGetRealtime(Bink:Hbink;Var Info:TBinkRealTimeInfo;Flags:longword):longword;
  stdcall external binkdll name'_BinkGetRealtime@12';
function BinkSetSimulate(SimSpeed:longword):longword;
  stdcall external binkdll name'_BinkSetSimulate@4';
function BinkOpenTrack(bink:hbink;ID:longword):longword;
  stdcall external binkdll name'_BinkOpenTrack@8';
function BinkSetIOSize(var ioSize:longword):longword;
  stdcall external binkdll name'_BinkSetIOSize@4';
function BinkSetFrameRate(Bink:HBink;FrameRate:longword):longword;
  stdcall external binkdll name'_BinkSetFrameRate@8';
function RADTimerRead:longword;
  stdcall external binkdll name'_RADTimerRead@0';

function GetBinkVersion(vname:string='ProductVersion'):string;

implementation

function BinkOpenDirectSound:pointer;
var H:Thandle;
begin
  H := GetModuleHandle(binkdll);
  result:= GetProcAddress(H,'_BinkOpenDirectSound@4');
end;

function BinkOpenWaveOut:pointer;
var H:Thandle;
begin
  H := GetModuleHandle(binkdll);
  result:= GetProcAddress(H,'_BinkOpenWaveOut@4');
end;

{-------------------------------------------------------------------------------
    GetBinkVersion()

    Get version of the DLL.
    can probe for :
      CompanyName
      FileDescription
      FileVersion
      InternalName
      LegalCopyright
      OriginalFilename
      ProductName
      ProductVersion
-------------------------------------------------------------------------------}
function GetBinkVersion(vname:string='ProductVersion'):string;
const
  FMTLEN = 1024;
var
  Info,
  Lang : pointer;
  infosize,LangLen,destlen:longword;
  fmt,Dest:pchar;
  hw,lw:longword;
  P:pointer;
begin
  infosize := GetFileVersionInfoSize(binkdll,hw);
  if infosize=0 then exit;
  GetMem(Info,infosize);
  if GetFileVersionInfo(BinkDll,0,infosize,info) then
  begin
    lang:=nil;
    VerQueryValue(Info,'/VarFileInfo/Translation',Lang,LangLen);
    if langlen<>0 then
      begin
        hw := Plongword(Lang)^ and $0000FFFF;
        lw := Plongword(Lang)^ and $FFFF0000;
      end
    else
      begin
        lw :=$0409;
        hw :=$04E4;
      end;

    p :=  pchar(vname);
    GetMem(fmt,FMTLEN);
    asm
      push [p]; push [hw]; push [lw]; // marshall 3 parameters
    end;
    wsprintf(fmt,'\StringFileInfo\%4.4x%4.4x\%s');
    asm
      add esp, 20; // ditch 2+3 parameters (wsprintf uses cdecl)
    end;

    if VerQueryValue(Info,fmt,pointer(dest),destlen) then
    begin
      result := dest;
    end;

    FreeMem(fmt,FMTLEN);
  end;

  if infosize >0 then FreeMem(info,infosize);
end;


end.
