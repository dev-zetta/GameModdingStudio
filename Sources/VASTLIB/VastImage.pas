unit VastImage;

interface

uses
  Windows, VastImageTypes, VastMemory, VastUtils, CRCFunc, ProcTimer;

function InitLibrary:Boolean;

function IsImageSet (const Image:PVastImage):Boolean;
function IsMultiImageSet (const MultiImage:PMultiVastImage):Boolean;

function InitImage (var Image:PVastImage):Boolean;
function InitMultiImage (var MultiImage:PMultiVastImage; ImageCount:DWORD):Boolean;
function InitImageData (var Image:PVastImage; const Size:DWORD):Boolean;

function CloneImage (var InImage:PVastImage; var OutImage:PVastImage):Boolean;
function CloneImageStruct (var InImage:PVastImage; var OutImage:PVastImage):Boolean;
function CloneImageData (var InImage:PVastImage; var OutImage:PVastImage):Boolean;

function CloneAlphaPixelTable (var InImage:PVastImage;var OutImage:PVastImage):Boolean;

function FreeImage (var Image:PVastImage):Boolean;
function FreeImageData (var Image:PVastImage):Boolean;
//function FreeImageAlphaPixelTable (var Image:PVastImage):Boolean;

//function ConvertImageToBlocks (var mInImage:PVastImage;var mOutImage:PVastImage;wBlockWidthMax:WORD;wBlockHeightMax:WORD):Boolean;
//function ConvertBlocksToImage (var mInImage:PVastImage;var mOutImage:PVastImage;wBlockWidthMax:WORD;wBlockHeightMax:WORD):Boolean;

//function ConvertPixelFormat(var mInImage:PVastImage;var mOutImage:PVastImage;const enTargetFormat:TPIXEL_FORMAT):Boolean;

function GetRMSError(const InImage1:PVastImage;var InImage2:PVastImage):DOUBLE;

//function TestAlphaChannel (const Image:PVastImage):Boolean;
//function ExtractAlphaChannel(var mInImage:PVastImage;var mOutImage:PVastImage):Boolean;

//procedure SubSampleImage444 (var mInImage:PVastImage);
//procedure AntiAliasImage444 (var mInImage:PVastImage);
//procedure AntiAliasImage444 (var mInImage:PVastImage;var mOutImage:PVastImage);

procedure AlignImageRes (var Width:DWORD;var Height:DWORD;const Size:DWORD);
function AlignImageDim (const Dim:DWORD;const Size:DWORD):DWORD;

//function SplitImageChannels (var mInImage:PVastImage;var mOutImage:PVastImage;wBlockWidthMax:WORD;wBlockHeightMax:WORD):Boolean;
//function MergeImageChannels (var mInImage:PVastImage;var mOutImage:PVastImage;wBlockWidthMax:WORD;wBlockHeightMax:WORD):Boolean;

//function CompressImage (var mInImage:PVastImage;var mOutData:POINTER;var dwOutSize:DWORD;wBlockWidthMax:WORD;wBlockHeightMax:WORD):Boolean;
procedure AverageMiddlePixels224 (var InImage:PVastImage);
procedure AveragePixels444 (var InImage:PVastImage);

procedure VastMessage(const Caption, Text:STRING);

implementation

//const
//  BMPMarker = WORD(Byte('B') or (Byte('M') shl 8));

//  IMGHMarker = DWORD(Byte('I') or (Byte('M') shl 8) or (Byte('G') shl 16) or (Byte('H') shl 24));
//  IMGXMarker = DWORD(Byte('I') or (Byte('M') shl 8) or (Byte('G') shl 16) or (Byte('X') shl 24));
var
  Timer:TProcTimer;
  InstructSet:DWORD = 0;

function InitLibrary:Boolean;
begin
  InstructSet:=GetInstructionSet;
end;

procedure AveragePixels444 (var InImage:PVastImage);
var
  YPos:DWORD;
  XPos:DWORD;
  YMaxPos:DWORD;
  XMaxPos:DWORD;
  //dwPixelSize:DWORD;
  //dwPixelPos:DWORD;
  ScanLineMem:DWORD;
  InDataMem:DWORD;
  PixelTable:Array[0..3] of DWORD;
  ScanLineSize:DWORD;
begin
  //if (dwFactor > 32) or (dwFactor <12) then
  //dwFactor:=16;

  //if DDSInfo^.BitsPerPixel=32 then
  //ConvertRGBAToRGB;
  //dwXInc:=
  //dwYInc:=

  if InImage^.PixelSize <> $20 then
  Exit;

  InDataMem:=DWORD(InImage^.Data);
  //dwPixelSize:=mInImage^.dwPixelSize div $08;
  ScanLineSize:= InImage^.Width * 4;
  XMaxPos:=InImage^.Width div $04;
  YMaxPos:=InImage^.Height div $04;
	for YPos:= 0 to YMaxPos - 1 do
  begin
		for XPos := 0 to XMaxPos - 1 do
    begin
      // Erase pixel table
      PixelTable[$00]:=$00;
      PixelTable[$01]:=$00;
      PixelTable[$02]:=$00;
      PixelTable[$03]:=$00;

      //// Load Pixels
      ScanLineMem:=InDataMem;

      // ScanLine 1
      Inc(PixelTable[$00],PBYTE(ScanLineMem+$00)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$01)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$02)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$03)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$04)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$05)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$06)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$07)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$08)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$09)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$0A)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$0B)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$0C)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$0D)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$0E)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$0F)^);

      Inc(ScanLineMem, ScanLineSize);

      // ScanLine 2
      Inc(PixelTable[$00],PBYTE(ScanLineMem+$00)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$01)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$02)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$03)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$04)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$05)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$06)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$07)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$08)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$09)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$0A)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$0B)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$0C)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$0D)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$0E)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$0F)^);

      Inc(ScanLineMem, ScanLineSize);

      // ScanLine 3
      Inc(PixelTable[$00],PBYTE(ScanLineMem+$00)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$01)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$02)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$03)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$04)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$05)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$06)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$07)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$08)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$09)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$0A)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$0B)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$0C)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$0D)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$0E)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$0F)^);

      Inc(ScanLineMem, ScanLineSize);

      // ScanLine 4
      Inc(PixelTable[$00],PBYTE(ScanLineMem+$00)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$01)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$02)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$03)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$04)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$05)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$06)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$07)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$08)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$09)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$0A)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$0B)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$0C)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$0D)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$0E)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$0F)^);

      // Get average pixel value
      PixelTable[$00]:=PixelTable[$00] div $10;
      PixelTable[$01]:=PixelTable[$01] div $10;
      PixelTable[$02]:=PixelTable[$02] div $10;
      PixelTable[$03]:=PixelTable[$03] div $10;

      //// Save Pixels
      ScanLineMem:=InDataMem;

      // ScanLine 1
      PBYTE(ScanLineMem+$00)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$01)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$02)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$03)^:=PixelTable[$03];

      PBYTE(ScanLineMem+$04)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$05)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$06)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$07)^:=PixelTable[$03];

      PBYTE(ScanLineMem+$08)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$09)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$0A)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$0B)^:=PixelTable[$03];

      PBYTE(ScanLineMem+$0C)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$0D)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$0E)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$0F)^:=PixelTable[$03];

      Inc(ScanLineMem, ScanLineSize);

      // ScanLine 2
      PBYTE(ScanLineMem+$00)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$01)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$02)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$03)^:=PixelTable[$03];

      PBYTE(ScanLineMem+$04)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$05)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$06)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$07)^:=PixelTable[$03];

      PBYTE(ScanLineMem+$08)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$09)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$0A)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$0B)^:=PixelTable[$03];

      PBYTE(ScanLineMem+$0C)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$0D)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$0E)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$0F)^:=PixelTable[$03];

      Inc(ScanLineMem, ScanLineSize);

      // ScanLine 3
      PBYTE(ScanLineMem+$00)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$01)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$02)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$03)^:=PixelTable[$03];

      PBYTE(ScanLineMem+$04)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$05)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$06)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$07)^:=PixelTable[$03];

      PBYTE(ScanLineMem+$08)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$09)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$0A)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$0B)^:=PixelTable[$03];

      PBYTE(ScanLineMem+$0C)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$0D)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$0E)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$0F)^:=PixelTable[$03];

      Inc(ScanLineMem, ScanLineSize);

      // ScanLine 4
      PBYTE(ScanLineMem+$00)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$01)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$02)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$03)^:=PixelTable[$03];

      PBYTE(ScanLineMem+$04)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$05)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$06)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$07)^:=PixelTable[$03];

      PBYTE(ScanLineMem+$08)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$09)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$0A)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$0B)^:=PixelTable[$03];

      PBYTE(ScanLineMem+$0C)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$0D)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$0E)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$0F)^:=PixelTable[$03];

      Inc(InDataMem, $10);
    end;  // for x
    InDataMem:=ScanLineMem + $10;
  end; // for y
end;
(*
// Classic antialias
procedure AntiAliasImage444 (var mInImage:PVastImage;var mOutImage:PVastImage);
var
  dwYPos:DWORD;
  dwXPos:DWORD;
  dwYMaxPos:DWORD;
  dwXMaxPos:DWORD;
  //dwPixelSize:DWORD;
  //dwPixelPos:DWORD;
  ScanLineMem:DWORD;
  dwInDataMem:DWORD;
  dwOutDataMem:DWORD;
  PixelTable:Array[0..3] of DWORD;
  dwScanLineSize:DWORD;
begin
  if not IsImageSet(mInImage) then
  Exit;

  if mInImage^.dwPixelSize <> $20 then
  Exit;

  if not InitImage(mOutImage) then
  Exit;

  if not CloneImageStruct(mInImage,mOutImage) then
  Exit;

  mOutImage^.mData:=nil;
  mOutImage^.dwWidth:=mOutImage^.dwWidth div 3;
  mOutImage^.dwHeight:=mOutImage^.dwHeight div 3;
  mOutImage^.dwSize:=mOutImage^.dwSize div 3;
  
  GetMem(mOutImage^.mData,mOutImage^.dwSize);
  dwInDataMem:=DWORD(mInImage^.mData);
  dwOutDataMem:=DWORD(mOutImage^.mData);
  //dwPixelSize:=mInImage^.dwPixelSize div $08;
  dwScanLineSize:= mInImage^.dwWidth * 4;

  // Skip first 3 rows
  //Inc(dwInDataMem,dwScanLineSize * 3);
  // Skip first 3 pixels in row
  //Inc(dwInDataMem,12);

  dwXMaxPos:=mOutImage^.dwWidth;
  dwYMaxPos:=mOutImage^.dwHeight;
	for dwYPos:= 0 to dwYMaxPos - 1 do
  begin
		for dwXPos := 0 to dwXMaxPos - 1 do
    begin
      ScanLineMem:=dwInDataMem;

      PixelTable[$00]:=$00;
      PixelTable[$01]:=$00;
      PixelTable[$02]:=$00;
      PixelTable[$03]:=$00;

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$00)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$01)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$02)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$03)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$04)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$05)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$06)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$07)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$08)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$09)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$0A)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$0B)^);

      Inc(ScanLineMem,dwScanLineSize);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$00)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$01)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$02)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$03)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$04)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$05)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$06)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$07)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$08)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$09)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$0A)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$0B)^);

      Inc(ScanLineMem,dwScanLineSize);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$00)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$01)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$02)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$03)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$04)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$05)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$06)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$07)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$08)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$09)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$0A)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$0B)^);

      // Set target pixels
      PBYTE(dwOutDataMem+$00)^:= PixelTable[$00] div $09;
      PBYTE(dwOutDataMem+$01)^:= PixelTable[$01] div $09;
      PBYTE(dwOutDataMem+$02)^:= PixelTable[$02] div $09;
      PBYTE(dwOutDataMem+$03)^:= PixelTable[$03] div $09;

      Inc(dwInDataMem,12);
      Inc(dwOutDataMem,4);
    end; // x
    dwInDataMem:= ScanLineMem + 12;
    //Dec(dwOutDataMem,1);
  end;

end;
*)

// You must call first SubSampleImage444,so you averagize every 4 pixels
// This procedure gets 8x8 pixels and averagize 2x2 pixels in middle so image wont look so blocky
procedure AverageMiddlePixels224 (var InImage:PVastImage);
var
  YPos:DWORD;
  XPos:DWORD;
  YMaxPos:DWORD;
  XMaxPos:DWORD;
  //dwPixelSize:DWORD;
  //dwPixelPos:DWORD;
  ScanLineMem:DWORD;
  InDataMem:DWORD;
  PixelTable:Array[0..3] of DWORD;
  ScanLineSize:DWORD;
begin
  //if (dwFactor > 32) or (dwFactor <12) then
  //dwFactor:=16;

  //if DDSInfo^.BitsPerPixel=32 then
  //ConvertRGBAToRGB;
  //dwXInc:=
  //dwYInc:=

  if InImage^.PixelSize <> $20 then
  Exit;

  InDataMem:=DWORD(InImage^.Data);
  //dwPixelSize:=InImage^.dwPixelSize div $08;
  ScanLineSize:= InImage^.Width * 4;

  // Skip first 3 rows
  Inc(InDataMem,ScanLineSize * 3);
  // Skip first 3 pixels in row
  Inc(InDataMem,12);

  XMaxPos:=InImage^.Width div $04;
  YMaxPos:=InImage^.Height div $04;
	for YPos:= 0 to YMaxPos - 2 do
  begin
		for XPos := 0 to XMaxPos - 2 do
    begin
      // Erase pixel table
      PixelTable[$00]:=$00;
      PixelTable[$01]:=$00;
      PixelTable[$02]:=$00;
      PixelTable[$03]:=$00;

      //// Load Pixels
      ScanLineMem:=InDataMem;

      // ScanLine 1
      Inc(PixelTable[$00],PBYTE(ScanLineMem+$00)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$01)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$02)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$03)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$04)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$05)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$06)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$07)^);

      Inc(ScanLineMem,ScanLineSize);

      // ScanLine 2
      Inc(PixelTable[$00],PBYTE(ScanLineMem+$00)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$01)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$02)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$03)^);

      Inc(PixelTable[$00],PBYTE(ScanLineMem+$04)^);
      Inc(PixelTable[$01],PBYTE(ScanLineMem+$05)^);
      Inc(PixelTable[$02],PBYTE(ScanLineMem+$06)^);
      Inc(PixelTable[$03],PBYTE(ScanLineMem+$07)^);

      // Get average pixel value
      PixelTable[$00]:=PixelTable[$00] div $04;
      PixelTable[$01]:=PixelTable[$01] div $04;
      PixelTable[$02]:=PixelTable[$02] div $04;
      PixelTable[$03]:=PixelTable[$03] div $04;

      // Black pixels for tests only
      //PixelTable[$00]:=$00;
      //PixelTable[$01]:=$00;
      //PixelTable[$02]:=$00;
      //PixelTable[$03]:=$00;

      //// Save Pixels
      ScanLineMem:=InDataMem;

      // ScanLine 1
      PBYTE(ScanLineMem+$00)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$01)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$02)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$03)^:=PixelTable[$03];

      PBYTE(ScanLineMem+$04)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$05)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$06)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$07)^:=PixelTable[$03];

      Inc(ScanLineMem,ScanLineSize);

      // ScanLine 2
      PBYTE(ScanLineMem+$00)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$01)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$02)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$03)^:=PixelTable[$03];

      PBYTE(ScanLineMem+$04)^:=PixelTable[$00];
      PBYTE(ScanLineMem+$05)^:=PixelTable[$01];
      PBYTE(ScanLineMem+$06)^:=PixelTable[$02];
      PBYTE(ScanLineMem+$07)^:=PixelTable[$03];

      Inc(InDataMem,16);
    end;  // for x
    //Break;
    InDataMem:=ScanLineMem + 16;
    Inc(InDataMem,ScanLineSize * 2);
    Inc(InDataMem,16);
    //Inc(InDataMem,8);
  end; // for y
end;

procedure AlignImageRes (var Width:DWORD;var Height:DWORD;const Size:DWORD);
var
  XInc:DWORD;
  YInc:DWORD;
begin
  if Size <= 1 then
  Exit;

  XInc:=Width and (Size-1);
  if XInc > 0 then
  Inc(Width, Size-XInc);

  YInc:=Height and (Size-1);
  if YInc > 0 then
  Inc(Height, Size-YInc);
end;

function AlignImageDim (const Dim:DWORD;const Size:DWORD):DWORD;
var
  DimInc:DWORD;
begin
  Result:=Dim;
  if Size <= 1 then
  Exit;

  DimInc:=Dim and (Size-1);
  if DimInc > 0 then
  Inc(Result, Size-DimInc);
end;

function IsImageSet (const Image:PVastImage):Boolean;
begin
  Result:=(Image <> nil) and (Image^.PixelFormat <> PIXEL_FORMAT_UNKNOWN) and (Image^.Data <> nil) and (Image^.Size > 0);
end;

function IsMultiImageSet (const MultiImage:PMultiVastImage):Boolean;
begin
  Result:=(MultiImage <> nil) and (MultiImage^.ImageCount > 0) and (MultiImage^.Image <> nil);
end;

function InitImage (var Image:PVastImage):Boolean;
begin
  Result:=False;
  if IsImageSet(Image) then
  Exit;

  //GetMem(Image,SizeOf(TVastImage));
  //if EraseMem(DWORD(Image),SizeOf(TVastImage)) then
  if hAllocMem(POINTER(Image),SizeOf(TVastImage)) then
  Result:=True;
end;

function InitMultiImage (var MultiImage:PMultiVastImage; ImageCount:DWORD):Boolean;
begin
  Result:=False;
  if IsMultiImageSet(MultiImage) then
  Exit;

  //mMultiImage:=nil;
  //GetMem(mMultiImage,SizeOf(TMultiVastImage));
  //if mMultiImage = nil then
  //Exit;
  if not hAllocMem(POINTER(MultiImage),SizeOf(TMultiVastImage)) then
  Exit;

  //EraseMem(DWORD(mMultiImage),SizeOf(TMultiVastImage));

  if ImageCount > 0 then
  begin
    //GetMem(mMultiImage^.Image,dwImageCount * SizeOf(TVastImage));
    //EraseMem(DWORD(mMultiImage^.Image),dwImageCount * SizeOf(TVastImage));
    if not hAllocMem(POINTER(MultiImage^.Image), ImageCount * SizeOf(TVastImage)) then
    Exit;

    MultiImage^.ImageCount:= ImageCount;
  end;

  Result:=True;
end;

function InitImageData (var Image:PVastImage;const Size:DWORD):Boolean;
begin
  Result:=False;
  if Image = nil then
  Exit;

  if mAllocMem(Image^.Data, Size) then
  begin
    Image^.Size:=Size;
    Result:=True;
  end;
end;

function CloneImage (var InImage:PVastImage;var OutImage:PVastImage):Boolean;
begin
  Result:=False;
  if (not IsImageSet(InImage)) then
  Exit;

  if OutImage = nil then
  InitImage (OutImage);

  if not CloneImageStruct(InImage, OutImage) then
  Exit;

  OutImage^.Data:=nil;
  Result:=CloneImageData(InImage, OutImage);
end;

function CloneImageStruct (var InImage:PVastImage;var OutImage:PVastImage):Boolean;
begin
  Result:=False;
  if (not IsImageSet(InImage)) or (OutImage = nil) then
  Exit;

  if InImage = OutImage then
  Exit;

  OutImage^:=InImage^;
  //mOutImage^.mData:= nil;
  Result:=True;
end;

function CloneImageData (var InImage:PVastImage;var OutImage:PVastImage):Boolean;
//var
  //InDataMem:DWORD;
  //dwOutDataMem:DWORD;
begin
  Result:=False;
  if (not IsImageSet(InImage)) or (OutImage = nil) then
  Exit;

  if InImage^.Data = OutImage^.Data then
  begin
    Result:=True;
    Exit;
  end;

  if OutImage^.Data <> nil then
  FreeMem(OutImage^.Data);
  //FreeMem(mOutImage^.mData);

  //GetMem(mOutImage^.mData,InImage^.dwSize);
  if not InitImageData(OutImage,InImage^.Size) then
  Exit;
  //mOutImage^.dwSize:= InImage^.dwSize;
  //dwInstructSet:=INSTRUCT_SET_NONE;
  //StartTimer(Timer);
  //CopyMemSwap(DWORD(InImage^.mData),DWORD(mOutImage^.mData),mOutImage^.dwSize);
  //result:=true;
  //exit;
  case InstructSet of
    INSTRUCT_SET_NONE:
    begin
      if CopyMem(DWORD(InImage^.Data),DWORD(OutImage^.Data), OutImage^.Size) then
      Result:=True;
    end;
    INSTRUCT_SET_MMX:
    begin
      if CopyMemMMX(DWORD(InImage^.Data),DWORD(OutImage^.Data), OutImage^.Size) then
      Result:=True;
    end;
    INSTRUCT_SET_SSE,INSTRUCT_SET_SSE2,
    INSTRUCT_SET_SSE3,INSTRUCT_SET_SSSE3,
    INSTRUCT_SET_SSE41,INSTRUCT_SET_SSE42:
    begin
      if CopyMemSSE(DWORD(InImage^.Data),DWORD(OutImage^.Data),OutImage^.Size) then
      Result:=True;
    end;
  end; // case
  //StopTimer(Timer);
  //ShowTimer(Timer);
end;

function CloneAlphaPixelTable (var InImage:PVastImage;var OutImage:PVastImage):Boolean;
begin
  Result:=False;
  if (not IsImageSet(InImage)) or (OutImage = nil) then
  Exit;

  OutImage^.IsAlphaTested:= InImage^.IsAlphaTested;
  OutImage^.IsAlphaIncluded:=InImage^.IsAlphaIncluded;
  OutImage^.AlphaPixelCount:=InImage^.AlphaPixelCount;
  //mOutImage^.mAlphaPixelTable^:=InImage^.mAlphaPixelTable^;
  // TODO: use copymem intread ?
  Result:=True;
end;

function FreeImage (var Image:PVastImage):Boolean;
begin
  Result:=False;
  if not IsImageSet(Image) then
  Exit;

  if Image^.Data <> nil then
  mFreeMem(Image^.Data);

  //if Image^.mAlphaPixelTable <> nil then
  //hFreeMem(POINTER(Image^.mAlphaPixelTable));

  if hFreeMem(POINTER(Image)) then
  Result:=True;
end;

function FreeImageData (var Image:PVastImage):Boolean;
begin
  Result:=False;
  if not IsImageSet(Image) then
  Exit;

  if not mFreeMem(Image^.Data) then
  Exit;

  Image^.Size:=0;
  Result:=True;
end;
(*
function FreeImageAlphaPixelTable (var Image:PVastImage):Boolean;
begin
  Result:=False;
  if not IsImageSet(Image) then
  Exit;
  
  if Image^.mAlphaPixelTable = nil then
  Exit;

  if hFreeMem(POINTER(Image^.mAlphaPixelTable)) then
  Result:=True;
end;
*)
function FreeMultiImage (var MultiImage:PMultiVastImage):Boolean;
var
  ImageIndex:DWORD;
  Image:PVastImage;
begin
  Result:=False;
  if MultiImage = nil then
  Exit;

  if MultiImage^.ImageCount > 0 then
  begin
    // We freed image data of all images in array
    Image:=MultiImage^.Image;
    for ImageIndex:=0 to MultiImage^.ImageCount do
    begin
      if Image^.Data <> nil then
      FreeMem(Image^.Data);
      Inc(Image);
    end;
    // This will freed all images in array
    hFreeMem(POINTER(MultiImage^.Image));
  end;
  // Now we finally freed whole DDS image
  if hFreeMem(POINTER(MultiImage)) then
  Result:=True;
end;

function GetRMSError(const InImage1:PVastImage;var InImage2:PVastImage):DOUBLE;
var
  InData1Mem:DWORD;
  InData2Mem:DWORD;
  PixelIndex:DWORD;
  PixelCount:DWORD;
  PixelSize:DWORD;
  PixelPos:DWORD;
  In1,In2:BYTE;
  RMSError:SINGLE;
begin
  if InImage1 =  InImage2 then
  Exit;

  if (not IsImageSet(InImage1)) or (not IsImageSet(InImage2)) then
  Exit;

  if InImage1^.Width <> InImage2^.Width then
  Exit;

  if InImage1^.Height <> InImage2^.Height then
  Exit;

  PixelSize:=InImage1^.PixelSize div 8;
  if PixelSize = 0 then
  Exit;
  
  InData1Mem:=DWORD(InImage1^.Data);
  InData2Mem:=DWORD(InImage2^.Data);
  RMSError:=0.0;
  PixelCount:=InImage1^.Width * InImage1^.Height;

  for PixelIndex:=0 to PixelCount - 1 do
  begin
    for PixelPos:=0 to PixelSize - 1 do
    begin
      In1:=PBYTE(InData1Mem)^;
      In2:=PBYTE(InData2Mem)^;
      RMSError:=RMSError + ((In1 - In2) * (In1 - In2));
      inc(InData1Mem);
      inc(InData2Mem);
    end;
  end;
  Result:=sqrt(RMSError / PixelCount);
end;


function GetAlphaChannelSize (const Image:PVastImage):DWORD;
var
  AlphaChannelSize:DWORD;
begin
  AlphaChannelSize:=0;
  case Image^.PixelFormat of
    PIXEL_FORMAT_A1:  AlphaChannelSize:=1;
    PIXEL_FORMAT_A2:  AlphaChannelSize:=2;
    PIXEL_FORMAT_A4:  AlphaChannelSize:=4;
    PIXEL_FORMAT_A8:  AlphaChannelSize:=8;
    PIXEL_FORMAT_A10: AlphaChannelSize:=10;
    PIXEL_FORMAT_A16: AlphaChannelSize:=16;
    PIXEL_FORMAT_A32: AlphaChannelSize:=32;

    PIXEL_FORMAT_A4R4G4B4: AlphaChannelSize:=4;
    PIXEL_FORMAT_X4R4G4B4: AlphaChannelSize:=4;

    PIXEL_FORMAT_A1R5G5B5: AlphaChannelSize:=1;
    PIXEL_FORMAT_X1R5G5B5: AlphaChannelSize:=1;

    PIXEL_FORMAT_R8G8B8A8: AlphaChannelSize:=8;
    PIXEL_FORMAT_R8G8B8X8: AlphaChannelSize:=8;

    PIXEL_FORMAT_B8G8R8A8: AlphaChannelSize:=8;
    PIXEL_FORMAT_B8G8R8X8: AlphaChannelSize:=8;

    PIXEL_FORMAT_A8R8G8B8: AlphaChannelSize:=8;
    PIXEL_FORMAT_X8R8G8B8: AlphaChannelSize:=8;

    PIXEL_FORMAT_A8B8G8R8: AlphaChannelSize:=8;
    PIXEL_FORMAT_X8B8G8R8: AlphaChannelSize:=8;

    PIXEL_FORMAT_R16G16B16A16: AlphaChannelSize:=16;
    PIXEL_FORMAT_R16G16B16X16: AlphaChannelSize:=16;

    PIXEL_FORMAT_B16G16R16A16: AlphaChannelSize:=16;
    PIXEL_FORMAT_B16G16R16X16: AlphaChannelSize:=16;

    PIXEL_FORMAT_A16R16G16B16: AlphaChannelSize:=16;
    PIXEL_FORMAT_X16R16G16B16: AlphaChannelSize:=16;

    PIXEL_FORMAT_A16B16G16R16: AlphaChannelSize:=16;
    PIXEL_FORMAT_X16B16G16R16: AlphaChannelSize:=16;

    PIXEL_FORMAT_R32G32B32A32: AlphaChannelSize:=32;
    PIXEL_FORMAT_R32G32B32X32: AlphaChannelSize:=32;

    PIXEL_FORMAT_B32G32R32A32: AlphaChannelSize:=32;
    PIXEL_FORMAT_B32G32R32X32: AlphaChannelSize:=32;

    PIXEL_FORMAT_A32R32G32B32: AlphaChannelSize:=32;
    PIXEL_FORMAT_X32R32G32B32: AlphaChannelSize:=32;

    PIXEL_FORMAT_A32B32G32R32: AlphaChannelSize:=32;
    PIXEL_FORMAT_X32B32G32R32: AlphaChannelSize:=32;

    PIXEL_FORMAT_R16G16B16A16F: AlphaChannelSize:=16;
    PIXEL_FORMAT_R16G16B16X16F: AlphaChannelSize:=16;

    PIXEL_FORMAT_B16G16R16A16F: AlphaChannelSize:=16;
    PIXEL_FORMAT_B16G16R16X16F: AlphaChannelSize:=16;

    PIXEL_FORMAT_A16R16G16B16F: AlphaChannelSize:=16;
    PIXEL_FORMAT_X16R16G16B16F: AlphaChannelSize:=16;

    PIXEL_FORMAT_A16B16G16R16F: AlphaChannelSize:=16;
    PIXEL_FORMAT_X16B16G16R16F: AlphaChannelSize:=16;

    PIXEL_FORMAT_R32G32B32A32F: AlphaChannelSize:=32;
    PIXEL_FORMAT_R32G32B32X32F: AlphaChannelSize:=32;

    PIXEL_FORMAT_B32G32R32A32F: AlphaChannelSize:=32;
    PIXEL_FORMAT_B32G32R32X32F: AlphaChannelSize:=32;

    PIXEL_FORMAT_A32R32G32B32F: AlphaChannelSize:=32;
    PIXEL_FORMAT_X32R32G32B32F: AlphaChannelSize:=32;

    PIXEL_FORMAT_A32B32G32R32F: AlphaChannelSize:=32;
    PIXEL_FORMAT_X32B32G32R32F: AlphaChannelSize:=32;

    // BC is compressed format but we know how many bits from compressed image block has alpha information per pixel encoded
    PIXEL_FORMAT_BC1: AlphaChannelSize:=1;
    PIXEL_FORMAT_BC2: AlphaChannelSize:=4;
    PIXEL_FORMAT_BC3: AlphaChannelSize:=8;
  end; // case end
  Result:=AlphaChannelSize;
end;

procedure VastMessage(const Caption, Text:STRING);
begin
  MessageBox(0, PChar(Text), PChar(Caption), 0);
end;


end.
