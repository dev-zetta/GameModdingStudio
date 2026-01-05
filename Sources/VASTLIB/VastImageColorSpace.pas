unit VastImageColorSpace;

interface

uses
  VastImage,VastImageTypes;

function ConvertRGBToYCoCg(var InImage:PVastImage;var OutImage:PVastImage):Boolean;overload;
function ConvertRGBToYCoCg(var InImage:PVastImage):Boolean;overload;
function ConvertYCoCgToRGB(var InImage:PVastImage;var OutImage:PVastImage):Boolean;overload;
function ConvertYCoCgToRGB(var InImage:PVastImage):Boolean;overload;

implementation


function ConvertRGBToYCoCg(var InImage:PVastImage;var OutImage:PVastImage):Boolean;overload;
var
  InDataMem:DWORD;
  OutDataMem:DWORD;
  PixelIndex:DWORD;
  PixelCount:DWORD;
  PixelSize:DWORD;
  T,Y,Co,Cg:SMALLINT;
  R,G,B:BYTE;
begin
  Result:=False;
  if not IsImageSet(InImage) then
  Exit;

  PixelSize:=InImage^.PixelSize div 8;
  if PixelSize < 3 then
  Exit;

  if InImage <> OutImage then
  begin
    if not InitImage(OutImage) then
    Exit;

    OutImage^.PixelFormat:=InImage^.PixelFormat;
    OutImage^.Size:=InImage^.Size;
    OutImage^.Width:=InImage^.Width;
    OutImage^.Height:=InImage^.Height;
    OutImage^.PixelSize:=InImage^.PixelSize;

    GetMem(OutImage^.Data,OutImage^.Size);
  end;

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);
  PixelCount:=OutImage^.Width * OutImage^.Height;

  for PixelIndex:=0 to PixelCount - 1 do
  begin
    R:=PBYTE(InDataMem+$00)^;
    G:=PBYTE(InDataMem+$01)^;
    B:=PBYTE(InDataMem+$02)^;

    Y:= ((R + (G shl 1) + B) + 2) shr 2;
    Co:=(((R shl 1) - (B shl 1) + 2) shr 2) + 128;
    Cg:=(((-R + (G shl 1) - B )+ 2) shr 2) + 128;

    // Y
    if Y > $FF then
    PBYTE(OutDataMem+$00)^:=$FF
      else
    if Y < $00 then
    PBYTE(OutDataMem+$00)^:=$00
      else
    PBYTE(OutDataMem+$00)^:=Y;

    //Co:=Co + 128;
    if Co > $FF then
    PBYTE(OutDataMem+$01)^:=$FF
      else
    if Co < $00 then
    PBYTE(OutDataMem+$01)^:=$00
      else
    PBYTE(OutDataMem+$01)^:=Co;

    //Cg:=Cg + 96;
    if Cg > $FF then
    PBYTE(OutDataMem+$02)^:=$FF
      else
    if Cg < $00 then
    PBYTE(OutDataMem+$02)^:=$00
      else
    PBYTE(OutDataMem+$02)^:=Cg;

    inc(InDataMem,PixelSize);
    inc(OutDataMem,PixelSize);
  end;
end;

function ConvertRGBToYCoCg(var InImage:PVastImage):Boolean;overload;
var
  InDataMem:DWORD;
  PixelIndex:DWORD;
  PixelCount:DWORD;
  PixelSize:DWORD;
  T,Y,Co,Cg:SMALLINT;
  R,G,B:BYTE;
begin
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

    Y:= ((R + (G shl 1) + B) + 2) shr 2;
    Co:=(((R shl 1) - (B shl 1) + 2) shr 2) + 128;
    Cg:=(((-R + (G shl 1) - B )+ 2) shr 2) + 128;

    // Y
    if Y > $FF then
    PBYTE(InDataMem+$00)^:=$FF
      else
    if Y < $00 then
    PBYTE(InDataMem+$00)^:=$00
      else
    PBYTE(InDataMem+$00)^:=Y;

    //Co:=Co + 128;
    if Co > $FF then
    PBYTE(InDataMem+$01)^:=$FF
      else
    if Co < $00 then
    PBYTE(InDataMem+$01)^:=$00
      else
    PBYTE(InDataMem+$01)^:=Co;

    //Cg:=Cg + 96;
    if Cg > $FF then
    PBYTE(InDataMem+$02)^:=$FF
      else
    if Cg < $00 then
    PBYTE(InDataMem+$02)^:=$00
      else
    PBYTE(InDataMem+$02)^:=Cg;

    inc(InDataMem,PixelSize);
  end;
end;

function ConvertYCoCgToRGB(var InImage:PVastImage;var OutImage:PVastImage):Boolean;overload;
var
  InDataMem:DWORD;
  OutDataMem:DWORD;
  PixelIndex:DWORD;
  PixelCount:DWORD;
  PixelSize:DWORD;
  Y,Co,Cg:BYTE;
  T,R,G,B:SMALLINT;
begin
  Result:=False;
  if not IsImageSet(InImage) then
  Exit;

  PixelSize:=InImage^.PixelSize div 8;
  if PixelSize < 3 then
  Exit;

  if InImage <> OutImage then
  begin
    if not InitImage(OutImage) then
    Exit;

    OutImage^.PixelFormat:=InImage^.PixelFormat;
    OutImage^.Size:=InImage^.Size;
    OutImage^.Width:=InImage^.Width;
    OutImage^.Height:=InImage^.Height;
    OutImage^.PixelSize:=InImage^.PixelSize;

    GetMem(OutImage^.Data,OutImage^.Size);
  end;

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);
  PixelCount:=OutImage^.Width * OutImage^.Height;

  for PixelIndex:=0 to PixelCount - 1 do
  begin
    Y:=PBYTE(InDataMem+$00)^;
    Co:=PBYTE(InDataMem+$01)^ - 128;
    Cg:=PBYTE(InDataMem+$02)^ - 128;

    R:= Y + (Co - Cg);
    G:= Y + Cg;
    B:= Y + (-Co - Cg);

    // Y
    if R > $FF then
    PBYTE(OutDataMem+$00)^:=$FF
      else
    if R < $00 then
    PBYTE(OutDataMem+$00)^:=$00
      else
    PBYTE(OutDataMem+$00)^:=R;

    //G:=Co + 128;
    if G > $FF then
    PBYTE(OutDataMem+$01)^:=$FF
      else
    if G < $00 then
    PBYTE(OutDataMem+$01)^:=$00
      else
    PBYTE(OutDataMem+$01)^:=G;

    //Cg:=Cg + 96;
    if B > $FF then
    PBYTE(OutDataMem+$02)^:=$FF
      else
    if B < $00 then
    PBYTE(OutDataMem+$02)^:=$00
      else
    PBYTE(OutDataMem+$02)^:=B;

    inc(InDataMem,PixelSize);
    inc(OutDataMem,PixelSize);
  end;
end;

function ConvertYCoCgToRGB(var InImage:PVastImage):Boolean;overload;
var
  InDataMem:DWORD;
  PixelIndex:DWORD;
  PixelCount:DWORD;
  PixelSize:DWORD;
  Y,Co,Cg:BYTE;
  T,R,G,B:SMALLINT;
begin
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
    Co:=PBYTE(InDataMem+$01)^ - 128;
    Cg:=PBYTE(InDataMem+$02)^ - 128;

    R:= Y + (Co - Cg);
    G:= Y + Cg;
    B:= Y + (-Co - Cg);

    // Y
    if R > $FF then
    PBYTE(InDataMem+$00)^:=$FF
      else
    if R < $00 then
    PBYTE(InDataMem+$00)^:=$00
      else
    PBYTE(InDataMem+$00)^:=R;

    if G > $FF then
    PBYTE(InDataMem+$01)^:=$FF
      else
    if G < $00 then
    PBYTE(InDataMem+$01)^:=$00
      else
    PBYTE(InDataMem+$01)^:=G;

    if B > $FF then
    PBYTE(InDataMem+$02)^:=$FF
      else
    if B < $00 then
    PBYTE(InDataMem+$02)^:=$00
      else
    PBYTE(InDataMem+$02)^:=B;

    inc(InDataMem,PixelSize);
  end;
end;
(*
function ConvertRGBToYCbCr(var InImage:PVastImage;var OutImage:PVastImage):Boolean;overload;
var
  InDataMem:DWORD;
  OutDataMem:DWORD;
  PixelIndex:DWORD;
  PixelCount:DWORD;
  PixelSize:DWORD;
  Y,wCb,wCr:SMALLINT;
  R,G,B:BYTE;
begin
  Result:=False;
  if not IsImageSet(InImage) then
  Exit;

  PixelSize:=InImage^.PixelSize div 8;
  if PixelSize < 3 then
  Exit;

  if InImage <> OutImage then
  begin
    if not InitImage(OutImage) then
    Exit;

    OutImage^.PixelFormat:=InImage^.PixelFormat;
    OutImage^.Size:=InImage^.Size;
    OutImage^.Width:=InImage^.Width;
    OutImage^.Height:=InImage^.Height;
    OutImage^.PixelSize:=InImage^.PixelSize;

    GetMem(OutImage^.Data,OutImage^.Size);
  end;

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);
  PixelCount:=OutImage^.Width * OutImage^.Height;

  for PixelIndex:=0 to PixelCount - 1 do
  begin
    R:=PBYTE(InDataMem+$00)^;
    G:=PBYTE(InDataMem+$01)^;
    B:=PBYTE(InDataMem+$02)^;

    Y:= Round( 0.29900 * R + 0.58700 * G + 0.11400 * B);
    wCb:= Round(-0.16874 * R - 0.33126 * G + 0.50000 * B  + 128);
    wCr:= Round( 0.50000 * R - 0.41869 * G - 0.08131 * B  + 128);

    // Y
    if Y > $FF then
    PBYTE(OutDataMem+$00)^:=$FF
      else
    if Y < $00 then
    PBYTE(OutDataMem+$00)^:=$00
      else
    PBYTE(OutDataMem+$00)^:=Y;

    if wCb > $FF then
    PBYTE(OutDataMem+$01)^:=$FF
      else
    if wCb < $00 then
    PBYTE(OutDataMem+$01)^:=$00
      else
    PBYTE(OutDataMem+$01)^:=wCb;

    if wCr > $FF then
    PBYTE(OutDataMem+$02)^:=$FF
      else
    if wCr < $00 then
    PBYTE(OutDataMem+$02)^:=$00
      else
    PBYTE(OutDataMem+$02)^:=wCr;

    inc(InDataMem,PixelSize);
    inc(OutDataMem,PixelSize);
  end;
end;

function ConvertRGBToYCbCr(var InImage:PVastImage):Boolean;overload;
var
  InDataMem:DWORD;
  PixelIndex:DWORD;
  PixelCount:DWORD;
  PixelSize:DWORD;
  Y,wCb,wCr:SMALLINT;
  R,G,B:BYTE;
begin
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

    Y:= Round( 0.29900 * R + 0.58700 * G + 0.11400 * B);
    wCb:= Round(-0.16874 * R - 0.33126 * G + 0.50000 * B  + 128);
    wCr:= Round( 0.50000 * R - 0.41869 * G - 0.08131 * B  + 128);

    // Y
    if Y > $FF then
    PBYTE(InDataMem+$00)^:=$FF
      else
    if Y < $00 then
    PBYTE(InDataMem+$00)^:=$00
      else
    PBYTE(InDataMem+$00)^:=Y;

    if wCb > $FF then
    PBYTE(InDataMem+$01)^:=$FF
      else
    if wCb < $00 then
    PBYTE(InDataMem+$01)^:=$00
      else
    PBYTE(InDataMem+$01)^:=wCb;

    if wCr > $FF then
    PBYTE(InDataMem+$02)^:=$FF
      else
    if wCr < $00 then
    PBYTE(InDataMem+$02)^:=$00
      else
    PBYTE(InDataMem+$02)^:=wCr;

    inc(InDataMem,PixelSize);
  end;
end;

function ConvertYCbCrToRGB(var InImage:PVastImage;var OutImage:PVastImage):Boolean;overload;
var
  InDataMem:DWORD;
  OutDataMem:DWORD;
  PixelIndex:DWORD;
  PixelCount:DWORD;
  PixelSize:DWORD;
  Y,bCr,bCb:BYTE;
  R,G,B:SMALLINT;
begin
  Result:=False;
  if not IsImageSet(InImage) then
  Exit;

  PixelSize:=InImage^.PixelSize div 8;
  if PixelSize < 3 then
  Exit;

  if InImage <> OutImage then
  begin
    if not InitImage(OutImage) then
    Exit;

    OutImage^.PixelFormat:=InImage^.PixelFormat;
    OutImage^.Size:=InImage^.Size;
    OutImage^.Width:=InImage^.Width;
    OutImage^.Height:=InImage^.Height;
    OutImage^.PixelSize:=InImage^.PixelSize;

    GetMem(OutImage^.Data,OutImage^.Size);
  end;

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);
  PixelCount:=OutImage^.Width * OutImage^.Height;

  for PixelIndex:=0 to PixelCount - 1 do
  begin
    Y:=PBYTE(InDataMem+$00)^;
    bCb:=PBYTE(InDataMem+$01)^;
    bCr:=PBYTE(InDataMem+$02)^;

    R:= Round(Y + 1.40200 * (bCr - 128));
    G:= Round(Y - 0.34414 * (bCb - 128) - 0.71414 * (bCr - 128));
    B:= Round(Y + 1.77200 * (bCb - 128));

    // Y
    if R > $FF then
    PBYTE(OutDataMem+$00)^:=$FF
      else
    if R < $00 then
    PBYTE(OutDataMem+$00)^:=$00
      else
    PBYTE(OutDataMem+$00)^:=R;

    //G:=wCr + 128;
    if G > $FF then
    PBYTE(OutDataMem+$01)^:=$FF
      else
    if G < $00 then
    PBYTE(OutDataMem+$01)^:=$00
      else
    PBYTE(OutDataMem+$01)^:=G;

    //wCb:=wCb + 96;
    if B > $FF then
    PBYTE(OutDataMem+$02)^:=$FF
      else
    if B < $00 then
    PBYTE(OutDataMem+$02)^:=$00
      else
    PBYTE(OutDataMem+$02)^:=B;

    inc(InDataMem,PixelSize);
    inc(OutDataMem,PixelSize);
  end;
end;

function ConvertYCbCrToRGB(var InImage:PVastImage):Boolean;overload;
var
  InDataMem:DWORD;
  PixelIndex:DWORD;
  PixelCount:DWORD;
  PixelSize:DWORD;
  Y,bCr,bCb:BYTE;
  R,G,B:SMALLINT;
begin
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
    bCb:=PBYTE(InDataMem+$01)^;
    bCr:=PBYTE(InDataMem+$02)^;

    R:= Round(Y + 1.40200 * (bCr - 128));
    G:= Round(Y - 0.34414 * (bCb - 128) - 0.71414 * (bCr - 128));
    B:= Round(Y + 1.77200 * (bCb - 128));

    // Y
    if R > $FF then
    PBYTE(InDataMem+$00)^:=$FF
      else
    if R < $00 then
    PBYTE(InDataMem+$00)^:=$00
      else
    PBYTE(InDataMem+$00)^:=R;

    //G:=wCr + 128;
    if G > $FF then
    PBYTE(InDataMem+$01)^:=$FF
      else
    if G < $00 then
    PBYTE(InDataMem+$01)^:=$00
      else
    PBYTE(InDataMem+$01)^:=G;

    //wCb:=wCb + 96;
    if B > $FF then
    PBYTE(InDataMem+$02)^:=$FF
      else
    if B < $00 then
    PBYTE(InDataMem+$02)^:=$00
      else
    PBYTE(InDataMem+$02)^:=B;

    inc(InDataMem,PixelSize);
  end;
end;
*)
end.
