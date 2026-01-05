unit VastYCbCrConvert;

{$I VastImageSettings.inc}

interface

uses
  {$IFNDEF LIGHT_VERSION}
  VastYCbCrTables,
  {$ENDIF}
  VastImage,VastImageTypes,VastUtils;

function ConvertRGBToYCbCr(var InImage:PVastImage):Boolean;overload;

function ConvertRGBToYCbCrPixel(const InDataMem:DWORD):Boolean;overload;
function ConvertRGBToYCbCrPixel(const Pixel:TRGB24Pixel):TRGB24Pixel;overload;

function ConvertYCbCrToRGB(var InImage:PVastImage):Boolean;overload;
function ConvertYCbCrToRGBPixel(const InDataMem:DWORD):Boolean;overload;
function ConvertYCbCrToRGBPixel(const Pixel:TRGB24Pixel):TRGB24Pixel;overload;

implementation

function ConvertRGBToYCbCr(var InImage:PVastImage):Boolean;overload;
var
  InDataMem:DWORD;
  PixelIndex:DWORD;
  PixelCount:DWORD;
  PixelSize:DWORD;
  Y,Cb,Cr:SMALLINT;
  R,G,B:BYTE;
begin
  //PrepareColorTable;
  Result:=False;

  if not IsImageSet(InImage) then
  Exit;

  PixelSize:=InImage^.PixelSize div 8;
  if PixelSize < 3 then
  Exit;

  InDataMem:=DWORD(InImage^.Data);
  PixelCount:=InImage^.Width * InImage^.Height;

  for PixelIndex:=0 to PixelCount - 1 do
  begin
    R:=PBYTE(InDataMem+$00)^;
    G:=PBYTE(InDataMem+$01)^;
    B:=PBYTE(InDataMem+$02)^;

    {$IFNDEF LIGHT_VERSION}
    PBYTE(InDataMem+$00)^:= (((YRTable[R] + YGTable[G] + YBTable[B]) shr $10));
    PBYTE(InDataMem+$01)^:= (((CbRTable[R] + CbGTable[G] + CbBTable[B]) shr $10) - 128);
    PBYTE(InDataMem+$02)^:= (((CrRTable[R] + CrGTable[G] + CrBTable[B]) shr $10) - 128);
    {$ELSE}
    PBYTE(InDataMem+$00)^:= ClampByte(Round( 0.29900 * R + 0.58700 * G + 0.11400 * B));
    PBYTE(InDataMem+$01)^:= ClampByte(Round(-0.16874 * R - 0.33126 * G + 0.50000 * B  + 128));
    PBYTE(InDataMem+$02)^:= ClampByte(Round( 0.50000 * R - 0.41869 * G - 0.08131 * B  + 128));
    {$ENDIF}

    inc(InDataMem,PixelSize);
  end;
end;

function ConvertRGBToYCbCrPixel(const InDataMem:DWORD):Boolean;overload;
var
  R,G,B:BYTE;
begin
  if InDataMem = 0 then
  begin
    Result:=False;
    Exit;
  end;

  R:=PBYTE(InDataMem+$00)^;
  G:=PBYTE(InDataMem+$01)^;
  B:=PBYTE(InDataMem+$02)^;

  {$IFNDEF LIGHT_VERSION}
  PBYTE(InDataMem+$00)^:= (((YRTable[R] + YGTable[G] + YBTable[B]) shr $10));
  PBYTE(InDataMem+$01)^:= (((CbRTable[R] + CbGTable[G] + CbBTable[B]) shr $10) - 128);
  PBYTE(InDataMem+$02)^:= (((CrRTable[R] + CrGTable[G] + CrBTable[B]) shr $10) - 128);
  {$ELSE}
  PBYTE(InDataMem+$00)^:= ClampByte(Round( 0.29900 * R + 0.58700 * G + 0.11400 * B));
  PBYTE(InDataMem+$01)^:= ClampByte(Round(-0.16874 * R - 0.33126 * G + 0.50000 * B  + 128));
  PBYTE(InDataMem+$02)^:= ClampByte(Round( 0.50000 * R - 0.41869 * G - 0.08131 * B  + 128));
  {$ENDIF}

  Result:=True;
end;

function ConvertRGBToYCbCrPixel(const Pixel:TRGB24Pixel):TRGB24Pixel;overload;
var
  R,G,B:BYTE;
begin

  R:=Pixel.R;
  G:=Pixel.G;
  B:=Pixel.B;
  {$IFNDEF LIGHT_VERSION}
  Result.R:= (((YRTable[R] + YGTable[G] + YBTable[B]) shr $10));
  Result.G:= (((CbRTable[R] + CbGTable[G] + CbBTable[B]) shr $10) - 128);
  Result.B:= (((CrRTable[R] + CrGTable[G] + CrBTable[B]) shr $10) - 128);
  {$ELSE}
  Result.R:= ClampByte(Round( 0.29900 * R + 0.58700 * G + 0.11400 * B));
  Result.G:= ClampByte(Round(-0.16874 * R - 0.33126 * G + 0.50000 * B  + 128));
  Result.B:= ClampByte(Round( 0.50000 * R - 0.41869 * G - 0.08131 * B  + 128));
  {$ENDIF}
end;

function ConvertYCbCrToRGB(var InImage:PVastImage):Boolean;overload;
var
  InDataMem:DWORD;
  PixelIndex:DWORD;
  PixelCount:DWORD;
  PixelSize:DWORD;
  //Y,Cb,Cr:SMALLINT;
  Y,Cb,Cr:BYTE;
begin
  //PrepareColorTable;
  Result:=False;

  if not IsImageSet(InImage) then
  Exit;

  PixelSize:=InImage^.PixelSize div 8;
  if PixelSize < 3 then
  Exit;

  InDataMem:=DWORD(InImage^.Data);
  PixelCount:=InImage^.Width * InImage^.Height;

  for PixelIndex:=0 to PixelCount - 1 do
  begin
    Y:=PBYTE(InDataMem+$00)^;
    Cb:=PBYTE(InDataMem+$01)^;
    Cr:=PBYTE(InDataMem+$02)^;

    {$IFNDEF LIGHT_VERSION}
    PBYTE(InDataMem+$00)^:= ClampByte(Y + SmallInt(RCrTable[Cr]) );
    PBYTE(InDataMem+$01)^:= ClampByte(Y + SmallInt(GYTable[((Cr shl 8) or Cb)])); //G
    PBYTE(InDataMem+$02)^:= ClampByte(Y + SmallInt(BCbTable[Cb]) );
    {$ELSE}
    PBYTE(InDataMem+$00)^:= ClampByte(Round(Y + 1.40200 * (Cr - 128)));
    PBYTE(InDataMem+$01)^:= ClampByte(Round(Y - 0.34414 * (Cb - 128) - 0.71414 * (Cr - 128)));
    PBYTE(InDataMem+$02)^:= ClampByte(Round(Y + 1.77200 * (Cb - 128)));
    {$ENDIF}

    inc(InDataMem,PixelSize);
  end;
end;

function ConvertYCbCrToRGBPixel(const InDataMem:DWORD):Boolean;overload;
var
  Y,Cb,Cr:BYTE;
begin
  if InDataMem = 0 then
  begin
    Result:=False;
    Exit;
  end;


  Y:=PBYTE(InDataMem+$00)^;
  Cb:=PBYTE(InDataMem+$01)^;
  Cr:=PBYTE(InDataMem+$02)^;

  {$IFNDEF LIGHT_VERSION}
  PBYTE(InDataMem+$00)^:= ClampByte(Y + SmallInt(RCrTable[Cr]) );
  PBYTE(InDataMem+$01)^:= ClampByte(Y + SmallInt(GYTable[((Cr shl 8) or Cb)])); //G
  PBYTE(InDataMem+$02)^:= ClampByte(Y + SmallInt(BCbTable[Cb]) );
  {$ELSE}
  PBYTE(InDataMem+$00)^:= ClampByte(Round(Y + 1.40200 * (Cr - 128)));
  PBYTE(InDataMem+$01)^:= ClampByte(Round(Y - 0.34414 * (Cb - 128) - 0.71414 * (Cr - 128)));
  PBYTE(InDataMem+$02)^:= ClampByte(Round(Y + 1.77200 * (Cb - 128)));
  {$ENDIF}

  Result:=True;
end;

function ConvertYCbCrToRGBPixel(const Pixel:TRGB24Pixel):TRGB24Pixel;overload;
var
  Y,Cb,Cr:BYTE;
begin

  Y:=Pixel.R;
  Cb:=Pixel.G;
  Cr:=Pixel.B;

  {$IFNDEF LIGHT_VERSION}
  Result.R:= ClampByte(Y + SmallInt(RCrTable[Cr]) );
  Result.G:= ClampByte(Y + SmallInt(GYTable[((Cr shl 8) or Cb)])); //G
  Result.B:= ClampByte(Y + SmallInt(BCbTable[Cb]) );
  {$ELSE}
  Result.R:= ClampByte(Round(Y + 1.40200 * (Cr - 128)));
  Result.G:= ClampByte(Round(Y - 0.34414 * (Cb - 128) - 0.71414 * (Cr - 128)));
  Result.B:= ClampByte(Round(Y + 1.77200 * (Cb - 128)));
  {$ENDIF}
end;

(*
var
  YRTable : Array[$00..$FF] of BYTE;
  YGTable : Array[$00..$FF] of BYTE;
  YBTable : Array[$00..$FF] of BYTE;

  CrRTable : Array[$00..$FF] of BYTE;
  CrGTable : Array[$00..$FF] of BYTE;
  CrBTable : Array[$00..$FF] of BYTE;

  CbRTable : Array[$00..$FF] of BYTE;
  CbGTable : Array[$00..$FF] of BYTE;
  CbBTable : Array[$00..$FF] of BYTE;



procedure PrepareColorTable;
var
  n,r,g,b:DWORD;
begin

  for n:=0 to 255 do
  begin
    YRTable[n]:=Round(0.299 * n);
    YGTable[n]:=Round(0.587 * n);
    YBTable[n]:=Round(0.114 * n);

    CrRTable[n]:=Round(0.5 * n);
    CrGTable[n]:=Round(0.41874 * n);
    CrBTable[n]:=Round(0.0813 * n);

    CbRTable[n]:=Round(-0.1687 * n);
    CbGTable[n]:=Round(0.3313 * n);
    CbBTable[n]:=Round(0.5 * n);
  end;
end;

function ConvertRGBToYCrCb(var InImage:PVastImage):Boolean;overload;
var
  InDataMem:DWORD;
  //dwOutDataMem:DWORD;
  PixelIndex:DWORD;
  PixelCount:DWORD;
  PixelSize:DWORD;
  Y,Cb,Cr:SMALLINT;
  R,G,B:BYTE;
begin
  PrepareColorTable;
  Result:=False;
  if not IsImageSet(InImage) then
  Exit;

  PixelSize:=InImage^.PixelSize div 8;
  if PixelSize < 3 then
  Exit;

  InDataMem:=DWORD(InImage^.mData);
  //dwOutDataMem:=DWORD(mOutImage^.mData);
  PixelCount:=InImage^.dwWidth * InImage^.dwHeight;

  for PixelIndex:=0 to PixelCount - 1 do
  begin
    R:=PBYTE(InDataMem+$00)^;
    G:=PBYTE(InDataMem+$01)^;
    B:=PBYTE(InDataMem+$02)^;

    PBYTE(InDataMem+$00)^:= ClampByte(YRTable[R] + YGTable[G] +YBTable[B]);
    PBYTE(InDataMem+$01)^:= ClampByte(YRTable[R] + YGTable[G] +YBTable[B] + 128);
    PBYTE(InDataMem+$02)^:= ClampByte(YRTable[R] + YGTable[G] +YBTable[B] + 128);

    inc(InDataMem,PixelSize);
  end;
end;
*)
end.
