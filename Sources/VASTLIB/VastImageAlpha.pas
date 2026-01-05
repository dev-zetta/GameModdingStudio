unit VastImageAlpha;

interface

uses
  VastImage, VastMemory, VastImageTypes, VastUtils, CRCFunc, ProcTimer;

function ApplyAlphaMask(const InImage:PVastImage;const Color:DWORD):Boolean;overload;
function AlphaBlendImage(const InImage:PVastImage;const OutImage:PVastImage;const AlphaValue:DWORD):Boolean;overload;
function AlphaBlendImage(const InImage:PVastImage;const OutImage:PVastImage):Boolean;overload;

function TestAlphaChannel (const Image:PVastImage):Boolean;
function ExtractAlphaChannel(var InImage:PVastImage;var OutImage:PVastImage):Boolean;

function AlphaBlendImageTest(const InImage:PVastImage;const OutImage:PVastImage):Boolean;overload;
implementation

function ApplyAlphaMask(const InImage:PVastImage;const Color:DWORD):Boolean;overload;
var
  InDataMem:DWORD;
  PixelIndex:DWORD;
  PixelCount:DWORD;
  PixelSize:DWORD;
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

  Inc(InDataMem,3);
  for PixelIndex:=0 to PixelCount - 1 do
  begin
    if PBYTE(InDataMem)^ = 0 then
    PDWORD(InDataMem)^:=Color;

    inc(InDataMem, PixelSize);
  end;
end;


function AlphaBlendPixel(const dwSource:DWORD;const dwTarget:DWORD):DWORD;
var                      
  InAlpha,InRed,InGreen,dwInBlue:DWORD;
  OutAlpha,OutRed,OutGreen,OutBlue:DWORD;
  AlphaValue:DWORD;
begin

  InAlpha:=dwSource and $000000FF;
  (*
  if InAlpha = 0 then
  begin
    Result:=dwTarget;
    Exit;
  end;
  *)
  InRed:=(dwSource and $FF000000) shr 24;
  InGreen:=(dwSource and $00FF0000) shr 16;
  dwInBlue:=(dwSource and $0000FF00) shr 8;

  OutAlpha:=dwTarget and $000000FF;
  OutRed:=(dwTarget and $FF000000) shr 24;
  OutGreen:=(dwTarget and $00FF0000) shr 16;
  OutBlue:=(dwTarget and $0000FF00) shr 8;

  // Get final alpha channel.
  //FA = S[A]+1 + ((256-S[A])*D[A])>>8
  //AlphaValue:=(InAlpha + 1) + ((256 - InAlpha) * OutAlpha) shr 8;


  // Get percentage (out of 256) of source alpha compared to final alpha
  //if (FA==0) SA = 0
  //else SA = (S[A]<<8)/FA
  //if AlphaValue = 0 then
  //InAlpha:=0 else InAlpha:= (InAlpha shl 8) div AlphaValue;

  // Destination percentage is just the additive inverse.
  //DA = 256-SA
  //OutAlpha:= 256 - InAlpha;

  //R[A] = FA
  //R[B] = (S[B] * SA + D[B] * DA)>>8
  //R[G] = (S[G] * SA + D[G] * DA)>>8
  //R[R] = (S[R] * SA + D[R] * DA)>>8

  //OutRed:=((InRed * InAlpha) + (OutRed * OutAlpha)) shr 8;
  //OutGreen:=((InGreen * InAlpha) + (OutGreen * OutAlpha)) shr 8;
  //OutBlue:=((dwInBlue * InAlpha) + (OutBlue * OutAlpha)) shr 8;

  OutAlpha:=InAlpha;
  OutRed:=InRed;
  OutGreen:=InGreen;
  OutBlue:=dwInBlue;

  Result:=((Byte(OutRed) shl 24) or (Byte(OutGreen) shl 16) or (Byte(OutBlue) shl 8) or (Byte(OutAlpha) shl 0));



(*
  unsigned int rb = (((src & $00ff00ff) * a) + ((bg & $00ff00ff) * ($ff - a))) & $ff00ff00;

  unsigned int g = (((src & $0000ff00) * a) + ((bg & $0000ff00) * ($ff - a))) & $00ff0000;

  return (src & 0xff000000) | ((rb | g) >> 8);
*)
end;

function AlphaBlendImageTest(const InImage:PVastImage;const OutImage:PVastImage):Boolean;overload;
var
  InDataMem:DWORD;
  OutDataMem:DWORD;

  PixelIndex:DWORD;
  PixelCount:DWORD;
  PixelSize:DWORD;
  Red,Green,Blue:DWORD;
begin
  Result:=False;

  if not IsImageSet(InImage) then
  Exit;

  PixelSize:=InImage^.PixelSize div 8;
  if PixelSize < 3 then
  Exit;

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);
  PixelCount:=InImage^.Width * InImage^.Height;

  //Inc(dwInDataMem,3);
  for PixelIndex:=0 to PixelCount - 1 do
  begin
    PDWORD(OutDataMem)^:=AlphaBlendPixel(PDWORD(InDataMem)^,PDWORD(OutDataMem)^);

    inc(InDataMem, PixelSize);
    inc(OutDataMem, PixelSize);
  end;
end;

function AlphaBlendImage(const InImage:PVastImage;const OutImage:PVastImage;const AlphaValue:DWORD):Boolean;overload;
var
  InDataMem:DWORD;
  OutDataMem:DWORD;

  PixelIndex:DWORD;
  PixelCount:DWORD;
  PixelSize:DWORD;
  Red,Green,Blue:DWORD;
begin
  Result:=False;

  if not IsImageSet(InImage) then
  Exit;

  PixelSize:=InImage^.PixelSize div 8;
  if PixelSize < 3 then
  Exit;

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);
  PixelCount:=InImage^.Width * InImage^.Height;

  //Inc(dwInDataMem,3);
  for PixelIndex:=0 to PixelCount - 1 do
  begin
    Red:=(AlphaValue * (PBYTE(InDataMem+$00)^ - PBYTE(OutDataMem+$00)^) shr 8) + PBYTE(OutDataMem+$00)^;
    Green:=(AlphaValue * (PBYTE(InDataMem+$01)^ - PBYTE(OutDataMem+$01)^) shr 8) + PBYTE(OutDataMem+$01)^;
    Blue:=(AlphaValue * (PBYTE(InDataMem+$02)^ - PBYTE(OutDataMem+$02)^) shr 8) + PBYTE(OutDataMem+$02)^;
    //blue  = (ALPHA * (sb - db) >> 8) + db;
    //green = (ALPHA * (sg - dg) >> 8) + dg;
    //red   = (ALPHA * (sr - dr) >> 8) + dr;

    PBYTE(OutDataMem+$00)^:=Red;
    PBYTE(OutDataMem+$01)^:=Green;
    PBYTE(OutDataMem+$02)^:=Blue;

    inc(InDataMem,PixelSize);
    inc(OutDataMem,PixelSize);
  end;
end;

function AlphaBlendImage(const InImage:PVastImage;const OutImage:PVastImage):Boolean;overload;
var
  InDataMem:DWORD;
  OutDataMem:DWORD;

  PixelIndex:DWORD;
  PixelCount:DWORD;
  PixelSize:DWORD;
  AlphaValue,RedValue,GreenValue,BlueValue:DWORD;
begin
  Result:=False;

  if not IsImageSet(InImage) then
  Exit;

  PixelSize:=InImage^.PixelSize div 8;
  if PixelSize < 3 then
  Exit;

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);
  PixelCount:=InImage^.Width * InImage^.Height;

  //Inc(InDataMem,3);
  for PixelIndex:=0 to PixelCount - 1 do
  begin
    AlphaValue:=PBYTE(InDataMem+$03)^;
    RedValue:=(AlphaValue * (PBYTE(InDataMem+$00)^ - PBYTE(OutDataMem+$00)^) shr 8) + PBYTE(OutDataMem+$00)^;
    GreenValue:=(AlphaValue * (PBYTE(InDataMem+$01)^ - PBYTE(OutDataMem+$01)^) shr 8) + PBYTE(OutDataMem+$01)^;
    BlueValue:=(AlphaValue * (PBYTE(InDataMem+$02)^ - PBYTE(OutDataMem+$02)^) shr 8) + PBYTE(OutDataMem+$02)^;

    PBYTE(OutDataMem+$00)^:=RedValue;
    PBYTE(OutDataMem+$01)^:=GreenValue;
    PBYTE(OutDataMem+$02)^:=BlueValue;

    inc(InDataMem,PixelSize);
    inc(OutDataMem,PixelSize);
  end;
end;

function TestAlphaChannel (const Image:PVastImage):Boolean;
label
  lblStartUpdate,lblFinishUpdate,lblSkipStartUpdate,lblSkipFinishUpdate;
var
  InDataMem:DWORD;
  PixelIndex:DWORD;
  PixelCount:DWORD;

  AlphaValue:DWORD;
  //dwAlphaPixelTableMem:DWORD;
  AlphaPixelCount:DWORD;

  SkipStartUpdate:BOOLEAN;
begin
  Result:=False;
  if not IsImageSet(Image) then
  Exit;

  if Image^.IsAlphaTested then
  Exit;

  SkipStartUpdate:=True;
  goto lblSkipStartUpdate;

  lblStartUpdate:
  begin
    //GetMem(Image^.mAlphaPixelTable,SizeOf(TAlphaPixelTable));
    //EraseMem(DWORD(Image^.mAlphaPixelTable),SizeOf(TAlphaPixelTable));
    //if not hAllocMem(POINTER(Image^.mAlphaPixelTable),SizeOf(TAlphaPixelTable)) then
    //Exit;

    InDataMem:=DWORD(Image^.Data);
    //dwAlphaPixelTableMem:=DWORD(Image^.mAlphaPixelTable);
    AlphaPixelCount:=0;

    PixelCount:=(Image^.Width * Image^.Height);

    SkipStartUpdate:=False;
  end;

  lblSkipStartUpdate:
  case Image^.PixelFormat of
//==================================================================//
    PIXEL_FORMAT_A1: // TODO: Test
//==================================================================//
    begin
      if SkipStartUpdate then
      goto lblStartUpdate;

      for PixelIndex:=0 to PixelCount - 1 do
      begin
        if (PixelIndex mod 8) = 0 then
        begin
          AlphaValue:=PBYTE(InDataMem)^;
          inc(InDataMem);
        end;

        // Update pixel table
        //inc(PBYTE(dwAlphaPixelTableMem + (AlphaValue and $01))^);
        // Check if there is any non opaque pixels
        if (AlphaValue and $01) < $01 then
        inc(AlphaPixelCount);

        AlphaValue:= AlphaValue shr 1;
      end;
      //if not SkipStartUpdate then
      goto lblFinishUpdate;
    end;
//==================================================================//
    PIXEL_FORMAT_A2: // TODO: Test
//==================================================================//
    begin
      if SkipStartUpdate then
      goto lblStartUpdate;

      for PixelIndex:=0 to PixelCount - 1 do
      begin
        if (PixelIndex mod 4) = 0 then
        begin
          AlphaValue:=PBYTE(InDataMem)^;
          inc(InDataMem);
        end;

        // Update pixel table
        //inc(PBYTE(dwAlphaPixelTableMem + (AlphaValue and $03))^);
        // Check if there is any non opaque pixels
        if (AlphaValue and $03) < $03 then
        inc(AlphaPixelCount);

        AlphaValue:= AlphaValue shr 2;
      end;
      //if not SkipStartUpdate then
      goto lblFinishUpdate;
    end;
//==================================================================//
    PIXEL_FORMAT_A4: // TODO: Test
//==================================================================//
    begin
      if SkipStartUpdate then
      goto lblStartUpdate;

      for PixelIndex:=0 to PixelCount - 1 do
      begin
        if (PixelIndex mod 2) = 0 then
        begin
          AlphaValue:=PBYTE(InDataMem)^;
          inc(InDataMem);
        end;

        // Update pixel table
        //inc(PBYTE(dwAlphaPixelTableMem + (AlphaValue and $0F))^);
        // Check if there is any non opaque pixels
        if (AlphaValue and $0F) < $0F then
        inc(AlphaPixelCount);

        AlphaValue:= AlphaValue shr 4;
      end;
      //if not SkipStartUpdate then
      goto lblFinishUpdate;
    end;
//==================================================================//
    PIXEL_FORMAT_A8: // TODO: Test
//==================================================================//
    begin
      if SkipStartUpdate then
      goto lblStartUpdate;

      for PixelIndex:=0 to PixelCount - 1 do
      begin
        AlphaValue:=PBYTE(InDataMem)^;
        inc(InDataMem);

        // Update pixel table
        //inc(PBYTE(dwAlphaPixelTableMem + AlphaValue)^);
        // Check if there is any non opaque pixels
        if AlphaValue < $FF then
        inc(AlphaPixelCount);
      end;
      //if not SkipStartUpdate then
      goto lblFinishUpdate;
    end;
//==================================================================//
    PIXEL_FORMAT_A10:; // TODO: ADD
//==================================================================//

//==================================================================//
    PIXEL_FORMAT_A16: // TODO: Test ;How to handle 16 bit alpha range ?
//==================================================================//
    begin
      if SkipStartUpdate then
      goto lblStartUpdate;

      for PixelIndex:=0 to PixelCount - 1 do
      begin
        AlphaValue:=PWORD(InDataMem)^;
        inc(InDataMem,2);

        // Check if there is any non opaque pixels
        if AlphaValue < $FFFF then
        inc(AlphaPixelCount);

        //if AlphaValue > $FF then
        //AlphaValue:=$FF;

        // Update pixel table
        //inc(PBYTE(dwAlphaPixelTableMem + AlphaValue)^);
      end;
      //if not SkipStartUpdate then
      goto lblFinishUpdate;
    end;
//==================================================================//
    PIXEL_FORMAT_A32: // TODO: Test ;How to handle 16 bit alpha range ?
//==================================================================//
    begin
      if SkipStartUpdate then
      goto lblStartUpdate;

      for PixelIndex:=0 to PixelCount - 1 do
      begin
        AlphaValue:=PDWORD(InDataMem)^;
        inc(InDataMem,4);

        // Check if there is any non opaque pixels
        if AlphaValue < $FFFFFFFF then
        inc(AlphaPixelCount);

        //if AlphaValue > $FF then
        //AlphaValue:=$FF;

        // Update pixel table
        //inc(PBYTE(dwAlphaPixelTableMem + AlphaValue)^);
      end;
      //if not SkipStartUpdate then
      goto lblFinishUpdate;
    end;
//==================================================================//
    PIXEL_FORMAT_A4R4G4B4,PIXEL_FORMAT_A4B4G4R4: // TODO: Test
//==================================================================//
    begin
      if SkipStartUpdate then
      goto lblStartUpdate;

      for PixelIndex:=0 to PixelCount - 1 do
      begin
        AlphaValue:=PBYTE(InDataMem)^ shr 4;
        inc(InDataMem,2);

        // Update pixel table
        //inc(PBYTE(dwAlphaPixelTableMem + AlphaValue)^);
        // Check if there is any non opaque pixels
        if AlphaValue < $0F then
        inc(AlphaPixelCount);
      end;
      //if not SkipStartUpdate then
      goto lblFinishUpdate;
    end;
//==================================================================//
    PIXEL_FORMAT_A1R5G5B5,PIXEL_FORMAT_A1B5G5R5: // TODO: Test
//==================================================================//
    begin
      if SkipStartUpdate then
      goto lblStartUpdate;

      for PixelIndex:=0 to PixelCount - 1 do
      begin
        AlphaValue:=PBYTE(InDataMem)^ shr 7;
        inc(InDataMem,2);

        // Update pixel table
        //inc(PBYTE(dwAlphaPixelTableMem + AlphaValue)^);
        // Check if there is any non opaque pixels
        if AlphaValue < $01 then
        inc(AlphaPixelCount);
      end;
      //if not SkipStartUpdate then
      goto lblFinishUpdate;
    end;
//==================================================================//
    PIXEL_FORMAT_R8G8B8A8,PIXEL_FORMAT_B8G8R8A8,
    PIXEL_FORMAT_A8R8G8B8,PIXEL_FORMAT_A8B8G8R8: // Tested
//==================================================================//
    begin
      if SkipStartUpdate then
      goto lblStartUpdate;

      if (Image^.PixelFormat = PIXEL_FORMAT_R8G8B8A8) or
         (Image^.PixelFormat = PIXEL_FORMAT_B8G8R8A8) then
      inc(InDataMem,3);

      for PixelIndex:=0 to PixelCount - 1 do
      begin
        AlphaValue:=PBYTE(InDataMem)^;
        // Seek to next pixel
        inc(InDataMem,4);
        // Update pixel table
        //inc(PBYTE(dwAlphaPixelTableMem + AlphaValue)^);
        // Check if there is any non opaque pixels
        if AlphaValue < $FF then
        inc(AlphaPixelCount);
      end;
      //if not SkipStartUpdate then
      goto lblFinishUpdate;
    end; // case
//==================================================================//
    PIXEL_FORMAT_R16G16B16A16,PIXEL_FORMAT_B16G16R16A16,
    PIXEL_FORMAT_A16R16G16B16,PIXEL_FORMAT_A16B16G16R16,
    PIXEL_FORMAT_R16G16B16A16F,PIXEL_FORMAT_B16G16R16A16F,
    PIXEL_FORMAT_A16R16G16B16F,PIXEL_FORMAT_A16B16G16R16F: // Test
//==================================================================//
    begin
      if SkipStartUpdate then
      goto lblStartUpdate;
      // Maybe use Case ?
      if (Image^.PixelFormat = PIXEL_FORMAT_R16G16B16A16) or
         (Image^.PixelFormat = PIXEL_FORMAT_B16G16R16A16) or
         (Image^.PixelFormat = PIXEL_FORMAT_R16G16B16A16F) or
         (Image^.PixelFormat = PIXEL_FORMAT_B16G16R16A16F) then
      inc(InDataMem,6);

      for PixelIndex:=0 to PixelCount - 1 do
      begin
        AlphaValue:=PWORD(InDataMem)^;
        // Seek to next pixel
        inc(InDataMem,8);

        // Check if there is any non opaque pixels
        if AlphaValue < $FFFF then
        inc(AlphaPixelCount);

        //if AlphaValue > $FF then
        //AlphaValue:=$FF;

        // Update pixel table
        //inc(PBYTE(dwAlphaPixelTableMem + AlphaValue)^);
      end;
      //if not SkipStartUpdate then
      goto lblFinishUpdate;
    end; // case
//==================================================================//
    PIXEL_FORMAT_R32G32B32A32,PIXEL_FORMAT_B32G32R32A32,
    PIXEL_FORMAT_A32R32G32B32,PIXEL_FORMAT_A32B32G32R32,
    PIXEL_FORMAT_R32G32B32A32F,PIXEL_FORMAT_B32G32R32A32F,
    PIXEL_FORMAT_A32R32G32B32F,PIXEL_FORMAT_A32B32G32R32F: // Test
//==================================================================//
    begin
      if SkipStartUpdate then
      goto lblStartUpdate;
      // Maybe use Case ?
      if (Image^.PixelFormat = PIXEL_FORMAT_R32G32B32A32) or
         (Image^.PixelFormat = PIXEL_FORMAT_B32G32R32A32) or
         (Image^.PixelFormat = PIXEL_FORMAT_R32G32B32A32F) or
         (Image^.PixelFormat = PIXEL_FORMAT_B32G32R32A32F) then
      inc(InDataMem,12);

      for PixelIndex:=0 to PixelCount - 1 do
      begin
        AlphaValue:=PDWORD(InDataMem)^;
        // Seek to next pixel
        inc(InDataMem,16);

        // Check if there is any non opaque pixels
        if AlphaValue < $FFFFFFFF then
        inc(AlphaPixelCount);

        //if AlphaValue > $FF then
        //AlphaValue:=$FF;

        // Update pixel table
        //inc(PBYTE(dwAlphaPixelTableMem + AlphaValue)^);
      end;
      //if not SkipStartUpdate then
      goto lblFinishUpdate;
    end; // case
  end; // case end
  
  lblSkipFinishUpdate:
  begin
    Exit;  // TODO: Error Message ?
  end;

  lblFinishUpdate:
  begin
    Image^.IsAlphaTested:=True;
    Image^.IsAlphaIncluded:= AlphaPixelCount > 0;
    Image^.AlphaPixelCount:= AlphaPixelCount;
    Result:=True;
    Exit;
  end;
end;

function ExtractAlphaChannel(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
label
  lblAllocMem,lblSkipAllocMem;
var
  InDataMem:DWORD;
  InDataMemMax:DWORD;
  OutDataMem:DWORD;
  OutDataSize:DWORD;
  AlphaChannelSize:DWORD;
  ScanLineMem:DWORD;

  BlockIndex:DWORD;
  BlockCount:DWORD;
  //dwScanLineIndex:DWORD;
  //dwScanLineSize:DWORD;

  //PixelCount:DWORD;
  //PixelIndex:DWORD;
begin
  Result:=False;
  if not IsImageSet (InImage) then
  Exit;

  //AlphaChannelSize:=GetAlphaChannelSize(InImage);
  //if AlphaChannelSize = 0 then
  //Exit;
  goto lblSkipAllocMem;

  lblAllocMem:
  begin
    if not InitImage(OutImage) then
    Exit;

    //OutImage^.PixelFormat:=enTargetFormat;
    //GetMem(OutImage^.Data,OutDataSize);
    //OutImage^.dwSize:=OutDataSize;
    if not InitImageData(OutImage,OutDataSize) then
    Exit;
    
    OutImage^.Width:=InImage^.Width;
    OutImage^.Height:=InImage^.Height;
    InDataMem:=DWORD(InImage^.Data);
    InDataMemMax:=InDataMem + InImage^.Size;
    OutDataMem:=DWORD(OutImage^.Data);

    //PixelCount:= InImage^.Width * InImage^.Height;
  end;


  lblSkipAllocMem:
  case InImage^.PixelFormat of
//==================================================================//
    PIXEL_FORMAT_A4R4G4B4,PIXEL_FORMAT_A4B4G4R4:
//==================================================================//
    begin
      if OutImage = nil then
      begin
        OutDataSize:=(InImage^.Width*InImage^.Height) div 2;
        goto lblAllocMem;
      end;
      OutImage^.PixelFormat:=PIXEL_FORMAT_A4;
      OutImage^.PixelSize:=4;

      while InDataMem < InDataMemMax do
      begin
        PBYTE(OutDataMem)^:=((PBYTE(InDataMem+$00)^ and $F0) shr $00) or ((PBYTE(InDataMem+$02)^ and $F0) shr $04);
        inc(InDataMem,4);
        inc(OutDataMem);
      end;
    end;
//==================================================================//
    PIXEL_FORMAT_A1R5G5B5,PIXEL_FORMAT_A1B5G5R5:
//==================================================================//
    begin
      if OutImage = nil then
      begin
        OutDataSize:=(InImage^.Width*InImage^.Height) div 8;
        goto lblAllocMem;
      end;
      OutImage^.PixelFormat:=PIXEL_FORMAT_A1;
      OutImage^.PixelSize:=1;

      while InDataMem < InDataMemMax do
      begin
        // Process 8 pixels at same time
        PBYTE(OutDataMem)^:=
        ((PBYTE(InDataMem+$00)^ and $80) shr $00) or ((PBYTE(InDataMem+$02)^ and $40) shr $01) or
        ((PBYTE(InDataMem+$04)^ and $20) shr $02) or ((PBYTE(InDataMem+$06)^ and $10) shr $03) or
        ((PBYTE(InDataMem+$08)^ and $08) shr $04) or ((PBYTE(InDataMem+$0A)^ and $04) shr $05) or
        ((PBYTE(InDataMem+$0C)^ and $02) shr $06) or ((PBYTE(InDataMem+$0E)^ and $01) shr $07);
        inc(InDataMem,16);
        inc(OutDataMem);
      end;
    end;
//==================================================================//
    PIXEL_FORMAT_B8G8R8A8,PIXEL_FORMAT_R8G8B8A8:
//==================================================================//
    begin
      if OutImage = nil then
      begin
        OutDataSize:=(InImage^.Width*InImage^.Height);
        goto lblAllocMem;
      end;
      OutImage^.PixelFormat:=PIXEL_FORMAT_A8;
      OutImage^.PixelSize:=8;

      inc(InDataMem,$03);
      while InDataMem < InDataMemMax do
      begin
        PBYTE(OutDataMem)^:=PBYTE(InDataMem)^;
        inc(InDataMem,4);
        inc(OutDataMem);
      end;
    end;
//==================================================================//
    PIXEL_FORMAT_A8R8G8B8,PIXEL_FORMAT_A8B8G8R8:
//==================================================================//
    begin
      if OutImage = nil then
      begin
        OutDataSize:=(InImage^.Width*InImage^.Height);
        goto lblAllocMem;
      end;
      OutImage^.PixelFormat:=PIXEL_FORMAT_A8;
      OutImage^.PixelSize:=8;

      while InDataMem < InDataMemMax do
      begin
        PBYTE(OutDataMem)^:=PBYTE(InDataMem)^;
        inc(InDataMem,4);
        inc(OutDataMem);
      end;
    end;
//==================================================================//
    PIXEL_FORMAT_R16G16B16A16,PIXEL_FORMAT_B16G16R16A16,
    PIXEL_FORMAT_R16G16B16A16F,PIXEL_FORMAT_B16G16R16A16F:
//==================================================================//
    begin
      if OutImage = nil then
      begin
        OutDataSize:=(InImage^.Width*InImage^.Height) * 2;
        goto lblAllocMem;
      end;
      OutImage^.PixelFormat:=PIXEL_FORMAT_A16;
      OutImage^.PixelSize:=16;

      inc(InDataMem,$06);
      while InDataMem < InDataMemMax do
      begin
        PWORD(OutDataMem)^:=PWORD(InDataMem)^;
        inc(InDataMem,8);
        inc(OutDataMem,2);
      end;
    end;
//==================================================================//
    PIXEL_FORMAT_A16R16G16B16,PIXEL_FORMAT_A16B16G16R16,
    PIXEL_FORMAT_A16R16G16B16F,PIXEL_FORMAT_A16B16G16R16F:
//==================================================================//
    begin
      if OutImage = nil then
      begin
        OutDataSize:=(InImage^.Width*InImage^.Height) * 2;
        goto lblAllocMem;
      end;
      OutImage^.PixelFormat:=PIXEL_FORMAT_A16;
      OutImage^.PixelSize:=16;

      while InDataMem < InDataMemMax do
      begin
        PWORD(OutDataMem)^:=PWORD(InDataMem)^;
        inc(InDataMem,8);
        inc(OutDataMem,2);
      end;
    end;
//==================================================================//
    PIXEL_FORMAT_R32G32B32A32,PIXEL_FORMAT_B32G32R32A32,
    PIXEL_FORMAT_R32G32B32A32F,PIXEL_FORMAT_B32G32R32A32F:
//==================================================================//
    begin
      if OutImage = nil then
      begin
        OutDataSize:=(InImage^.Width*InImage^.Height) * 4;
        goto lblAllocMem;
      end;
      OutImage^.PixelFormat:=PIXEL_FORMAT_A32;
      OutImage^.PixelSize:=32;

      inc(InDataMem,$0C);
      while InDataMem < InDataMemMax do
      begin
        PDWORD(OutDataMem)^:=PDWORD(InDataMem)^;
        inc(InDataMem,16);
        inc(OutDataMem,4);
      end;
    end;
//==================================================================//
    PIXEL_FORMAT_A32R32G32B32,PIXEL_FORMAT_A32B32G32R32,
    PIXEL_FORMAT_A32R32G32B32F,PIXEL_FORMAT_A32B32G32R32F:
//==================================================================//
    begin
      if OutImage = nil then
      begin
        OutDataSize:=(InImage^.Width*InImage^.Height) * 4;
        goto lblAllocMem;
      end;
      OutImage^.PixelFormat:=PIXEL_FORMAT_A32;
      OutImage^.PixelSize:=32;

      while InDataMem < InDataMemMax do
      begin
        PDWORD(OutDataMem)^:=PDWORD(InDataMem)^;
        inc(InDataMem,16);
        inc(OutDataMem,4);
      end;
    end;
//==================================================================//
    PIXEL_FORMAT_BC1:
//==================================================================//
    begin
      // Really Vast algorithm which extracts alpha channel information from compressed block without real decompression
      //StartTimer(Timer); I cant get any time on BC1 256x256 - Always 0
      if OutImage = nil then
      begin
        OutDataSize:=(InImage^.Width*InImage^.Height);
        goto lblAllocMem;
      end;
      OutImage^.PixelFormat:=PIXEL_FORMAT_A8;
      OutImage^.PixelSize:=8;

      //BlockIndex:=1;
      BlockCount:=InImage ^.Width div 4;
      while InDataMem < InDataMemMax do
      begin
        for BlockIndex:=0 to BlockCount - 1 do
        begin
          ScanLineMem:=OutDataMem;
          case PWORD(InDataMem + $00)^ > PWORD(InDataMem + $02)^ of
            True:
            begin
              // Block Without alpha
              inc(InDataMem,8);
              PDWORD(ScanLineMem)^:=$FFFFFFFF;
              inc(ScanLineMem,InImage ^.Width);
              PDWORD(ScanLineMem)^:=$FFFFFFFF;
              inc(ScanLineMem,InImage ^.Width);
              PDWORD(ScanLineMem)^:=$FFFFFFFF;
              inc(ScanLineMem,InImage ^.Width);
              PDWORD(ScanLineMem)^:=$FFFFFFFF;

              inc(OutDataMem,4);
            end;
            False:
            begin
              // Block With alpha
              inc(InDataMem,4);

              // 1 ScanLine
              if (PBYTE(InDataMem)^ and $03) = $03 then
              PBYTE(ScanLineMem + $00)^:= $00 else PBYTE(ScanLineMem + $00)^:= $FF;

              if (PBYTE(InDataMem)^ and $0C) = $0C then
              PBYTE(ScanLineMem + $01)^:= $00 else PBYTE(ScanLineMem + $01)^:= $FF;

              if (PBYTE(InDataMem)^ and $30) = $30 then
              PBYTE(ScanLineMem + $02)^:= $00 else PBYTE(ScanLineMem + $02)^:= $FF;

              if (PBYTE(InDataMem)^ and $C0) = $C0 then
              PBYTE(ScanLineMem + $03)^:= $00 else PBYTE(ScanLineMem + $03)^:= $FF;

              inc(InDataMem);
              inc(ScanLineMem,InImage ^.Width);

              // 2 ScanLine
              if (PBYTE(InDataMem)^ and $03) = $03 then
              PBYTE(ScanLineMem + $00)^:= $00 else PBYTE(ScanLineMem + $00)^:= $FF;

              if (PBYTE(InDataMem)^ and $0C) = $0C then
              PBYTE(ScanLineMem + $01)^:= $00 else PBYTE(ScanLineMem + $01)^:= $FF;

              if (PBYTE(InDataMem)^ and $30) = $30 then
              PBYTE(ScanLineMem + $02)^:= $00 else PBYTE(ScanLineMem + $02)^:= $FF;

              if (PBYTE(InDataMem)^ and $C0) = $C0 then
              PBYTE(ScanLineMem + $03)^:= $00 else PBYTE(ScanLineMem + $03)^:= $FF;

              inc(InDataMem);
              inc(ScanLineMem,InImage ^.Width);

              // 3 ScanLine
              if (PBYTE(InDataMem)^ and $03) = $03 then
              PBYTE(ScanLineMem + $00)^:= $00 else PBYTE(ScanLineMem + $00)^:= $FF;

              if (PBYTE(InDataMem)^ and $0C) = $0C then
              PBYTE(ScanLineMem + $01)^:= $00 else PBYTE(ScanLineMem + $01)^:= $FF;

              if (PBYTE(InDataMem)^ and $30) = $30 then
              PBYTE(ScanLineMem + $02)^:= $00 else PBYTE(ScanLineMem + $02)^:= $FF;

              if (PBYTE(InDataMem)^ and $C0) = $C0 then
              PBYTE(ScanLineMem + $03)^:= $00 else PBYTE(ScanLineMem + $03)^:= $FF;

              inc(InDataMem);
              inc(ScanLineMem,InImage ^.Width);

              // 4 ScanLine
              if (PBYTE(InDataMem)^ and $03) = $03 then
              PBYTE(ScanLineMem + $00)^:= $00 else PBYTE(ScanLineMem + $00)^:= $FF;

              if (PBYTE(InDataMem)^ and $0C) = $0C then
              PBYTE(ScanLineMem + $01)^:= $00 else PBYTE(ScanLineMem + $01)^:= $FF;

              if (PBYTE(InDataMem)^ and $30) = $30 then
              PBYTE(ScanLineMem + $02)^:= $00 else PBYTE(ScanLineMem + $02)^:= $FF;

              if (PBYTE(InDataMem)^ and $C0) = $C0 then
              PBYTE(ScanLineMem + $03)^:= $00 else PBYTE(ScanLineMem + $03)^:= $FF;

              inc(InDataMem);
              inc(OutDataMem,4);
            end; // case
          end; // case end
        end; // for
        //Inc(OutDataMem,InImage^.Width * 3);
        OutDataMem:=ScanLineMem+4;
      end; // while
      //StopTimer(Timer);
      //ShowTimer(Timer);
      Result:=True;
      Exit;
    end;  // case
//==================================================================//
    PIXEL_FORMAT_BC2:
    begin
      // Really Vast algorithm which extracts alpha channel information from compressed block without real decompression
      //StartTimer(Timer); I cant get any time on BC1 256x256 - Always 0
      if OutImage = nil then
      begin
        OutDataSize:=(InImage^.Width*InImage^.Height);
        goto lblAllocMem;
      end;
      OutImage^.PixelFormat:=PIXEL_FORMAT_A8;
      OutImage^.PixelSize:=8;

      //BlockIndex:=1;
      //inc(InDataMem,8);
      BlockCount:=InImage ^.Width div 4;
      while InDataMem < InDataMemMax do
      begin
        for BlockIndex:=0 to BlockCount - 1 do
        begin
          ScanLineMem:=OutDataMem;
          // 1 ScanLine
          PBYTE(ScanLineMem + $00)^:=(PBYTE(InDataMem)^ and $0F); //or ((PBYTE(InDataMem)^ and $0F)) shl 4);
          PBYTE(ScanLineMem + $00)^:=PBYTE(ScanLineMem + $00)^ or (PBYTE(ScanLineMem + $00)^ shl 4);
          PBYTE(ScanLineMem + $01)^:=(PBYTE(InDataMem)^ and $F0);
          PBYTE(ScanLineMem + $01)^:=PBYTE(ScanLineMem + $01)^ or (PBYTE(ScanLineMem + $01)^ shr 4);
          inc(InDataMem);

          PBYTE(ScanLineMem + $02)^:=(PBYTE(InDataMem)^ and $0F);
          PBYTE(ScanLineMem + $02)^:=PBYTE(ScanLineMem + $02)^ or (PBYTE(ScanLineMem + $02)^ shl 4);
          PBYTE(ScanLineMem + $03)^:=(PBYTE(InDataMem)^ and $F0);
          PBYTE(ScanLineMem + $03)^:=PBYTE(ScanLineMem + $03)^ or (PBYTE(ScanLineMem + $03)^ shr 4);
          inc(InDataMem);

          inc(ScanLineMem,InImage ^.Width);

          // 2 ScanLine
          PBYTE(ScanLineMem + $00)^:=(PBYTE(InDataMem)^ and $0F); //or ((PBYTE(InDataMem)^ and $0F)) shl 4);
          PBYTE(ScanLineMem + $00)^:=PBYTE(ScanLineMem + $00)^ or (PBYTE(ScanLineMem + $00)^ shl 4);
          PBYTE(ScanLineMem + $01)^:=(PBYTE(InDataMem)^ and $F0);
          PBYTE(ScanLineMem + $01)^:=PBYTE(ScanLineMem + $01)^ or (PBYTE(ScanLineMem + $01)^ shr 4);
          inc(InDataMem);

          PBYTE(ScanLineMem + $02)^:=(PBYTE(InDataMem)^ and $0F);
          PBYTE(ScanLineMem + $02)^:=PBYTE(ScanLineMem + $02)^ or (PBYTE(ScanLineMem + $02)^ shl 4);
          PBYTE(ScanLineMem + $03)^:=(PBYTE(InDataMem)^ and $F0);
          PBYTE(ScanLineMem + $03)^:=PBYTE(ScanLineMem + $03)^ or (PBYTE(ScanLineMem + $03)^ shr 4);
          inc(InDataMem);

          inc(ScanLineMem,InImage ^.Width);

          // 3 ScanLine
          PBYTE(ScanLineMem + $00)^:=(PBYTE(InDataMem)^ and $0F); //or ((PBYTE(InDataMem)^ and $0F)) shl 4);
          PBYTE(ScanLineMem + $00)^:=PBYTE(ScanLineMem + $00)^ or (PBYTE(ScanLineMem + $00)^ shl 4);
          PBYTE(ScanLineMem + $01)^:=(PBYTE(InDataMem)^ and $F0);
          PBYTE(ScanLineMem + $01)^:=PBYTE(ScanLineMem + $01)^ or (PBYTE(ScanLineMem + $01)^ shr 4);
          inc(InDataMem);

          PBYTE(ScanLineMem + $02)^:=(PBYTE(InDataMem)^ and $0F);
          PBYTE(ScanLineMem + $02)^:=PBYTE(ScanLineMem + $02)^ or (PBYTE(ScanLineMem + $02)^ shl 4);
          PBYTE(ScanLineMem + $03)^:=(PBYTE(InDataMem)^ and $F0);
          PBYTE(ScanLineMem + $03)^:=PBYTE(ScanLineMem + $03)^ or (PBYTE(ScanLineMem + $03)^ shr 4);
          inc(InDataMem);

          inc(ScanLineMem,InImage ^.Width);

          // 4 ScanLine
          PBYTE(ScanLineMem + $00)^:=(PBYTE(InDataMem)^ and $0F); //or ((PBYTE(InDataMem)^ and $0F)) shl 4);
          PBYTE(ScanLineMem + $00)^:=PBYTE(ScanLineMem + $00)^ or (PBYTE(ScanLineMem + $00)^ shl 4);
          PBYTE(ScanLineMem + $01)^:=(PBYTE(InDataMem)^ and $F0);
          PBYTE(ScanLineMem + $01)^:=PBYTE(ScanLineMem + $01)^ or (PBYTE(ScanLineMem + $01)^ shr 4);
          inc(InDataMem);

          PBYTE(ScanLineMem + $02)^:=(PBYTE(InDataMem)^ and $0F);
          PBYTE(ScanLineMem + $02)^:=PBYTE(ScanLineMem + $02)^ or (PBYTE(ScanLineMem + $02)^ shl 4);
          PBYTE(ScanLineMem + $03)^:=(PBYTE(InDataMem)^ and $F0);
          PBYTE(ScanLineMem + $03)^:=PBYTE(ScanLineMem + $03)^ or (PBYTE(ScanLineMem + $03)^ shr 4);
          inc(InDataMem);

          inc(InDataMem,8);
          inc(OutDataMem,4);
        end; // for
        //Inc(OutDataMem,InImage^.Width * 3);
        OutDataMem:=ScanLineMem+4;
      end; // while
      //StopTimer(Timer);
      //ShowTimer(Timer);
      Result:=True;
      Exit;
    end;  // case


    //PIXEL_FORMAT_BC3: AlphaChannelSize:=8;
  end; // case end
  //Result:=AlphaChannelSize;

end;

end.
