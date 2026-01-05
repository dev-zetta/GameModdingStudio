unit VastBCDecode;

interface

uses
  VastImage, VastImageTypes, VastImagePixelFormat, VastMemory, ProcTimer, VastBCTablesLow;

  function BC1Decode0(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
  function BC2Decode0(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
  function BC3Decode0(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
  function BC4Decode0(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
  function BC5Decode0(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
implementation


function BC1Decode0(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
var
  InDataMem:DWORD;
  OutDataMem:DWORD;

  OutScanLineMem:DWORD;
  InScanLineMem:DWORD;
  //dwPrevScanLineMem:DWORD;

  ScanLineSize:DWORD;

  XBlockIndex:DWORD;
  YBlockIndex:DWORD;
  XBlockCount:DWORD;
  YBlockCount:DWORD;

  XSkip:DWORD;
  YSkip:DWORD;

  IndexTableBlock:BYTE;
  MinIndex:BYTE;
  MaxIndex:BYTE;
  MinColor:WORD;
  MaxColor:WORD;

  ColorTable:Array[0..3] of Array[0..3] of BYTE;
begin
  Result:=False;
  if not IsImageSet(InImage) then
  Exit;

  //if ((InImage^.Width mod 16) > 0) or ((InImage^.Height mod 16) > 0) then
  //Exit;

  // Create new Image
  //if not InitImage(OutImage) then
  //Exit;

  // Copy image input image information to output image
  OutImage^.PixelFormat:=PIXEL_FORMAT_R8G8B8A8;
  OutImage^.Size:=(InImage^.Width * InImage^.Height) * 4;
  OutImage^.Width:=InImage^.Width;
  OutImage^.Height:=InImage^.Height;
  OutImage^.PixelSize:=32;

  // Alocate target image data memory
  if not mAllocMem(OutImage^.Data,OutImage^.Size) then
  begin
    FreeImage(OutImage);
    Exit;
  end;

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);

  ScanLineSize:=InImage^.Width * 4;
  XBlockCount:=(InImage^.Width + 3) shr 2;
  YBlockCount:=(InImage^.Height + 3) shr 2;
  //StartTimer(Timer);
  for YBlockIndex:=0 to YBlockCount - 1 do
  begin
    for XBlockIndex:=0 to XBlockCount - 1 do
    begin
      MinColor:=PWORD(InDataMem+$00)^;
      MaxColor:=PWORD(InDataMem+$02)^;

      if MinColor > MaxColor then
      begin
        // Without alpha channel
        ColorTable[0][0]:=(MinColor and $001F) shl 3;
        ColorTable[0][1]:=(MinColor and $07E0) shr 3;
        ColorTable[0][2]:=(MinColor and $F800) shr 8;
        ColorTable[0][3]:=$FF;

        ColorTable[1][0]:=(MaxColor and $001F) shl 3;
        ColorTable[1][1]:=(MaxColor and $07E0) shr 3;
        ColorTable[1][2]:=(MaxColor and $F800) shr 8;
        ColorTable[1][3]:=$FF;

        ColorTable[2][0]:=((ColorTable[0][0] shl 1) + ColorTable[1][0]) div 3;
        ColorTable[2][1]:=((ColorTable[0][1] shl 1) + ColorTable[1][1]) div 3;
        ColorTable[2][2]:=((ColorTable[0][2] shl 1) + ColorTable[1][2]) div 3;
        ColorTable[2][3]:=$FF;

        ColorTable[3][0]:=((ColorTable[1][0] shl 1) + ColorTable[0][0]) div 3;
        ColorTable[3][1]:=((ColorTable[1][1] shl 1) + ColorTable[0][1]) div 3;
        ColorTable[3][2]:=((ColorTable[1][2] shl 1) + ColorTable[0][2]) div 3;
        ColorTable[3][3]:=$FF;
      end // if
        else
      begin
        // With alpha channel
        ColorTable[0][0]:=(MinColor and $001F) shl 3;
        ColorTable[0][1]:=(MinColor and $07E0) shr 3;
        ColorTable[0][2]:=(MinColor and $F800) shr 8;
        ColorTable[0][3]:=$FF;

        ColorTable[1][0]:=(MaxColor and $001F) shl 3;
        ColorTable[1][1]:=(MaxColor and $07E0) shr 3;
        ColorTable[1][2]:=(MaxColor and $F800) shr 8;
        ColorTable[1][3]:=$FF;

        ColorTable[2][0]:=(ColorTable[0][0] + ColorTable[1][0]) div 2;
        ColorTable[2][1]:=(ColorTable[0][1] + ColorTable[1][1]) div 2;
        ColorTable[2][2]:=(ColorTable[0][2] + ColorTable[1][2]) div 2;
        ColorTable[2][3]:=$FF;

        ColorTable[3][0]:=((ColorTable[1][0] shl 1) + ColorTable[0][0]) div 3;
        ColorTable[3][1]:=((ColorTable[1][1] shl 1) + ColorTable[0][1]) div 3;
        ColorTable[3][2]:=((ColorTable[1][2] shl 1) + ColorTable[0][2]) div 3;
        ColorTable[3][3]:=$00;
      end; // if
      OutScanLineMem:=OutDataMem;

      IndexTableBlock:=PBYTE(InDataMem+$04)^;
      PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[(IndexTableBlock and $03) shr $00])^;
      PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[(IndexTableBlock and $0C) shr $02])^;
      PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[(IndexTableBlock and $30) shr $04])^;
      PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[(IndexTableBlock and $C0) shr $06])^;
      inc(OutScanLineMem,ScanLineSize);

      IndexTableBlock:=PBYTE(InDataMem+$05)^;
      PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[(IndexTableBlock and $03) shr $00])^;
      PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[(IndexTableBlock and $0C) shr $02])^;
      PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[(IndexTableBlock and $30) shr $04])^;
      PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[(IndexTableBlock and $C0) shr $06])^;
      inc(OutScanLineMem,ScanLineSize);

      IndexTableBlock:=PBYTE(InDataMem+$06)^;
      PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[(IndexTableBlock and $03) shr $00])^;
      PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[(IndexTableBlock and $0C) shr $02])^;
      PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[(IndexTableBlock and $30) shr $04])^;
      PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[(IndexTableBlock and $C0) shr $06])^;
      inc(OutScanLineMem,ScanLineSize);

      IndexTableBlock:=PBYTE(InDataMem+$07)^;
      PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[(IndexTableBlock and $03) shr $00])^;
      PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[(IndexTableBlock and $0C) shr $02])^;
      PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[(IndexTableBlock and $30) shr $04])^;
      PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[(IndexTableBlock and $C0) shr $06])^;

      inc(InDataMem,8);
      inc(OutDataMem,16);
    end; // for x
    OutDataMem:=OutScanLineMem + 16;
  end; // for y
  //StopTimer(Timer);
  //ShowTimer(Timer);
end;


function BC2Decode0(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
var
  InDataMem:DWORD;
  OutDataMem:DWORD;

  OutScanLineMem:DWORD;
  InScanLineMem:DWORD;
  //dwPrevScanLineMem:DWORD;

  ScanLineSize:DWORD;

  XBlockIndex:DWORD;
  YBlockIndex:DWORD;
  XBlockCount:DWORD;
  YBlockCount:DWORD;

  //XSkip:DWORD;
  //YSkip:DWORD;

  Block:BYTE;

  MinColor:WORD;
  MaxColor:WORD;

  ColorTable:Array[0..3] of Array[0..3] of BYTE;
begin
  Result:=False;
  if not IsImageSet(InImage) then
  Exit;

  //if ((InImage^.Width mod 16) > 0) or ((InImage^.Height mod 16) > 0) then
  //Exit;

  // Create new Image
  //if not InitImage(OutImage) then
  //Exit;

  // Copy image input image information to output image
  //OutImage^.enPixelFormat:=PIXEL_FORMAT_R8G8B8A8;
  SetPixelFormatInfo(OutImage, PIXEL_FORMAT_R8G8B8A8);
  OutImage^.Size:=(InImage^.Width * InImage^.Height) * 4;
  OutImage^.Width:=InImage^.Width;
  OutImage^.Height:=InImage^.Height;

  if OutImage^.Data = nil then
  begin
    // Alocate target image data memory
    if not mAllocMem(OutImage^.Data,OutImage^.Size) then
    begin
      FreeImage(OutImage);
      Exit;
    end;
  end;

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);

  ScanLineSize:=InImage^.Width * 4;
  XBlockCount:=(InImage^.Width + 3) div 4;
  YBlockCount:=(InImage^.Height + 3) div 4;
  //StartTimer(Timer);
  for YBlockIndex:=0 to YBlockCount - 1 do
  begin
    for XBlockIndex:=0 to XBlockCount - 1 do
    begin
      MinColor:=PWORD(InDataMem+$08)^;
      MaxColor:=PWORD(InDataMem+$0A)^;
    //--------------------
    // Decode colors
    //--------------------
      // Without alpha channel
      ColorTable[0][0]:=(MinColor and $001F) shl 3;
      ColorTable[0][1]:=(MinColor and $07E0) shr 3;
      ColorTable[0][2]:=(MinColor and $F800) shr 8;

      ColorTable[1][0]:=(MaxColor and $001F) shl 3;
      ColorTable[1][1]:=(MaxColor and $07E0) shr 3;
      ColorTable[1][2]:=(MaxColor and $F800) shr 8;

      ColorTable[2][0]:=((ColorTable[0][0] shl 1) + ColorTable[1][0]) div 3;
      ColorTable[2][1]:=((ColorTable[0][1] shl 1) + ColorTable[1][1]) div 3;
      ColorTable[2][2]:=((ColorTable[0][2] shl 1) + ColorTable[1][2]) div 3;

      ColorTable[3][0]:=((ColorTable[1][0] shl 1) + ColorTable[0][0]) div 3;
      ColorTable[3][1]:=((ColorTable[1][1] shl 1) + ColorTable[0][1]) div 3;
      ColorTable[3][2]:=((ColorTable[1][2] shl 1) + ColorTable[0][2]) div 3;

      OutScanLineMem:=OutDataMem;

      Block:=PBYTE(InDataMem+$0C)^;
      PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[(Block and $03) shr $00])^;
      PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[(Block and $0C) shr $02])^;
      PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[(Block and $30) shr $04])^;
      PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[(Block and $C0) shr $06])^;
      inc(OutScanLineMem,ScanLineSize);

      Block:=PBYTE(InDataMem+$0D)^;
      PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[(Block and $03) shr $00])^;
      PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[(Block and $0C) shr $02])^;
      PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[(Block and $30) shr $04])^;
      PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[(Block and $C0) shr $06])^;
      inc(OutScanLineMem,ScanLineSize);

      Block:=PBYTE(InDataMem+$0E)^;
      PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[(Block and $03) shr $00])^;
      PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[(Block and $0C) shr $02])^;
      PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[(Block and $30) shr $04])^;
      PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[(Block and $C0) shr $06])^;
      inc(OutScanLineMem,ScanLineSize);

      Block:=PBYTE(InDataMem+$0F)^;
      PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[(Block and $03) shr $00])^;
      PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[(Block and $0C) shr $02])^;
      PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[(Block and $30) shr $04])^;
      PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[(Block and $C0) shr $06])^;

    //--------------------
    // Decode alpha
    //--------------------
      OutScanLineMem:=OutDataMem;
      // ScanLine 1
      Block:=PBYTE(InDataMem+$00)^;
      PBYTE(OutScanLineMem+$03)^:=(Block shl $04) or (Block and $0F);
      PBYTE(OutScanLineMem+$07)^:=(Block shr $04) or (Block and $F0);
      Block:=PBYTE(InDataMem+$01)^;
      PBYTE(OutScanLineMem+$0B)^:=(Block shl $04) or (Block and $0F);
      PBYTE(OutScanLineMem+$0F)^:=(Block shr $04) or (Block and $F0);
      inc(OutScanLineMem,ScanLineSize);
      // ScanLine 2
      Block:=PBYTE(InDataMem+$02)^;
      PBYTE(OutScanLineMem+$03)^:=(Block shl $04) or (Block and $0F);
      PBYTE(OutScanLineMem+$07)^:=(Block shr $04) or (Block and $F0);
      Block:=PBYTE(InDataMem+$03)^;
      PBYTE(OutScanLineMem+$0B)^:=(Block shl $04) or (Block and $0F);
      PBYTE(OutScanLineMem+$0F)^:=(Block shr $04) or (Block and $F0);
      inc(OutScanLineMem,ScanLineSize);
      // ScanLine 3
      Block:=PBYTE(InDataMem+$04)^;
      PBYTE(OutScanLineMem+$03)^:=(Block shl $04) or (Block and $0F);
      PBYTE(OutScanLineMem+$07)^:=(Block shr $04) or (Block and $F0);
      Block:=PBYTE(InDataMem+$05)^;
      PBYTE(OutScanLineMem+$0B)^:=(Block shl $04) or (Block and $0F);
      PBYTE(OutScanLineMem+$0F)^:=(Block shr $04) or (Block and $F0);
      inc(OutScanLineMem,ScanLineSize);
      // ScanLine 4
      Block:=PBYTE(InDataMem+$06)^;
      PBYTE(OutScanLineMem+$03)^:=(Block shl $04) or (Block and $0F);
      PBYTE(OutScanLineMem+$07)^:=(Block shr $04) or (Block and $F0);
      Block:=PBYTE(InDataMem+$07)^;
      PBYTE(OutScanLineMem+$0B)^:=(Block shl $04) or (Block and $0F);
      PBYTE(OutScanLineMem+$0F)^:=(Block shr $04) or (Block and $F0);

      inc(InDataMem,16);
      inc(OutDataMem,16);
    end; // for x
    OutDataMem:=OutScanLineMem + 16;
  end; // for y
  //StopTimer(Timer);
  //ShowTimer(Timer);
end;

function BC3Decode0(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
var
  InDataMem:DWORD;
  OutDataMem:DWORD;

  OutScanLineMem:DWORD;
  InScanLineMem:DWORD;
  //dwPrevScanLineMem:DWORD;

  ScanLineSize:DWORD;

  XBlockIndex:DWORD;
  YBlockIndex:DWORD;
  XBlockCount:DWORD;
  YBlockCount:DWORD;

  Block:BYTE;

  MinColor:WORD;
  MaxColor:WORD;

  ColorTable:Array[0..3] of Array[0..3] of BYTE;
begin
  Result:=False;
  if not IsImageSet(InImage) then
  Exit;

  //if ((InImage^.Width mod 16) > 0) or ((InImage^.Height mod 16) > 0) then
  //Exit;

  // Create new Image
  //if not InitImage(OutImage) then
  //Exit;

  // Copy image input image information to output image
  //OutImage^.enPixelFormat:=PIXEL_FORMAT_R8G8B8A8;
  SetPixelFormatInfo(OutImage, PIXEL_FORMAT_R8G8B8A8);
  OutImage^.Size:=(InImage^.Width * InImage^.Height) * 4;
  OutImage^.Width:=InImage^.Width;
  OutImage^.Height:=InImage^.Height;

  if OutImage^.Data = nil then
  begin
    // Alocate target image data memory
    if not mAllocMem(OutImage^.Data,OutImage^.Size) then
    begin
      FreeImage(OutImage);
      Exit;
    end;
  end;

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);

  ScanLineSize:=InImage^.Width * 4;
  XBlockCount:=(InImage^.Width + 3) div 4;
  YBlockCount:=(InImage^.Height + 3) div 4;
  //StartTimer(Timer);
  for YBlockIndex:=0 to YBlockCount - 1 do
  begin
    for XBlockIndex:=0 to XBlockCount - 1 do
    begin
      MinColor:=PWORD(InDataMem+$08)^;
      MaxColor:=PWORD(InDataMem+$0A)^;
    //--------------------
    // Decode colors
    //--------------------
      // Without alpha channel
      ColorTable[0][0]:=(MinColor and $001F) shl 3;
      ColorTable[0][1]:=(MinColor and $07E0) shr 3;
      ColorTable[0][2]:=(MinColor and $F800) shr 8;

      ColorTable[1][0]:=(MaxColor and $001F) shl 3;
      ColorTable[1][1]:=(MaxColor and $07E0) shr 3;
      ColorTable[1][2]:=(MaxColor and $F800) shr 8;

      ColorTable[2][0]:=((ColorTable[0][0] shl 1) + ColorTable[1][0]) div 3;
      ColorTable[2][1]:=((ColorTable[0][1] shl 1) + ColorTable[1][1]) div 3;
      ColorTable[2][2]:=((ColorTable[0][2] shl 1) + ColorTable[1][2]) div 3;

      ColorTable[3][0]:=((ColorTable[1][0] shl 1) + ColorTable[0][0]) div 3;
      ColorTable[3][1]:=((ColorTable[1][1] shl 1) + ColorTable[0][1]) div 3;
      ColorTable[3][2]:=((ColorTable[1][2] shl 1) + ColorTable[0][2]) div 3;

      OutScanLineMem:=OutDataMem;

      Block:=PBYTE(InDataMem+$0C)^;
      PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[(Block and $03) shr $00])^;
      PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[(Block and $0C) shr $02])^;
      PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[(Block and $30) shr $04])^;
      PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[(Block and $C0) shr $06])^;
      inc(OutScanLineMem,ScanLineSize);

      Block:=PBYTE(InDataMem+$0D)^;
      PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[(Block and $03) shr $00])^;
      PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[(Block and $0C) shr $02])^;
      PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[(Block and $30) shr $04])^;
      PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[(Block and $C0) shr $06])^;
      inc(OutScanLineMem,ScanLineSize);

      Block:=PBYTE(InDataMem+$0E)^;
      PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[(Block and $03) shr $00])^;
      PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[(Block and $0C) shr $02])^;
      PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[(Block and $30) shr $04])^;
      PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[(Block and $C0) shr $06])^;
      inc(OutScanLineMem,ScanLineSize);

      Block:=PBYTE(InDataMem+$0F)^;
      PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[(Block and $03) shr $00])^;
      PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[(Block and $0C) shr $02])^;
      PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[(Block and $30) shr $04])^;
      PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[(Block and $C0) shr $06])^;

    //--------------------
    // Decode alpha
    //--------------------
      OutScanLineMem:=OutDataMem;
      // ScanLine 1
      Block:=PBYTE(InDataMem+$00)^;
      PBYTE(OutScanLineMem+$03)^:=(Block shl $04) or (Block and $0F);
      PBYTE(OutScanLineMem+$07)^:=(Block shr $04) or (Block and $F0);
      Block:=PBYTE(InDataMem+$01)^;
      PBYTE(OutScanLineMem+$0B)^:=(Block shl $04) or (Block and $0F);
      PBYTE(OutScanLineMem+$0F)^:=(Block shr $04) or (Block and $F0);
      inc(OutScanLineMem,ScanLineSize);
      // ScanLine 2
      Block:=PBYTE(InDataMem+$02)^;
      PBYTE(OutScanLineMem+$03)^:=(Block shl $04) or (Block and $0F);
      PBYTE(OutScanLineMem+$07)^:=(Block shr $04) or (Block and $F0);
      Block:=PBYTE(InDataMem+$03)^;
      PBYTE(OutScanLineMem+$0B)^:=(Block shl $04) or (Block and $0F);
      PBYTE(OutScanLineMem+$0F)^:=(Block shr $04) or (Block and $F0);
      inc(OutScanLineMem,ScanLineSize);
      // ScanLine 3
      Block:=PBYTE(InDataMem+$04)^;
      PBYTE(OutScanLineMem+$03)^:=(Block shl $04) or (Block and $0F);
      PBYTE(OutScanLineMem+$07)^:=(Block shr $04) or (Block and $F0);
      Block:=PBYTE(InDataMem+$05)^;
      PBYTE(OutScanLineMem+$0B)^:=(Block shl $04) or (Block and $0F);
      PBYTE(OutScanLineMem+$0F)^:=(Block shr $04) or (Block and $F0);
      inc(OutScanLineMem,ScanLineSize);
      // ScanLine 4
      Block:=PBYTE(InDataMem+$06)^;
      PBYTE(OutScanLineMem+$03)^:=(Block shl $04) or (Block and $0F);
      PBYTE(OutScanLineMem+$07)^:=(Block shr $04) or (Block and $F0);
      Block:=PBYTE(InDataMem+$07)^;
      PBYTE(OutScanLineMem+$0B)^:=(Block shl $04) or (Block and $0F);
      PBYTE(OutScanLineMem+$0F)^:=(Block shr $04) or (Block and $F0);

      inc(InDataMem,16);
      inc(OutDataMem,16);
    end; // for x
    OutDataMem:=OutScanLineMem + 16;
  end; // for y
  //StopTimer(Timer);
  //ShowTimer(Timer);
end;

function BC4Decode0(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
var
  InDataMem:DWORD;
  OutDataMem:DWORD;

  OutScanLineMem:DWORD;
  InScanLineMem:DWORD;
  PrevScanLineMem:DWORD;

  ScanLineSize:DWORD;

  XBlockIndex:DWORD;
  YBlockIndex:DWORD;
  XBlockCount:DWORD;
  YBlockCount:DWORD;

  IndexTableBlock:DWORD;
  //IndexTableBlockW:WORD;

  PrevRedBlock:QWORD;

  CopyRedBlock:BOOLEAN;

  MinRed:BYTE;
  MaxRed:BYTE;

  RedTable:Array[0..7] of BYTE;
  //GTable:Array[0..7] of BYTE;
begin
  Result:=False;
  if not IsImageSet(InImage) then
  Exit;

  //if ((InImage^.Width mod 16) > 0) or ((InImage^.Height mod 16) > 0) then
  //Exit;

  // Create new Image
  if not InitImage(OutImage) then
  Exit;

  // Copy image input image information to output image
  OutImage^.PixelFormat:=PIXEL_FORMAT_R8;
  OutImage^.Size:=(InImage^.Width * InImage^.Height);
  OutImage^.Width:=InImage^.Width;
  OutImage^.Height:=InImage^.Height;
  OutImage^.PixelSize:=8;

  // Alocate target image data memory
  //if OutImage^.mData = nil then
  //GetMem(OutImage^.mData,OutImage^.dwSize);
  if not mAllocMem(OutImage^.Data,OutImage^.Size) then
  begin
    FreeImage(OutImage);
    Exit;
  end;

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);

  ScanLineSize:=InImage^.Width;
  XBlockCount:=(InImage^.Width + 3) shr 2;
  YBlockCount:=(InImage^.Height + 3) shr 2;
  //dwBlocksDuplicated:=0;
  PrevRedBlock:=PQWORD(InDataMem)^+1;
  //PrevColorBlock:=0;
  //PrevIndexBlock:=0;
  //StartTimer(Timer);
  // 628 602 613 634
  // 599 595 603 595
  // 601 593 609 597
  // 626 624 597 607
  for YBlockIndex:=0 to YBlockCount - 1 do
  begin
    for XBlockIndex:=0 to XBlockCount - 1 do
    begin
      CopyRedBlock:=False;
      if WORD(PrevRedBlock) = PWORD(InDataMem+$00)^ then
      begin
        if PrevRedBlock = PQWORD(InDataMem+$00)^ then
        CopyRedBlock:=True else PrevRedBlock:=PQWORD(InDataMem+$00)^;
      end
        else
      begin
        PrevRedBlock:=PQWORD(InDataMem+$00)^;
        MinRed:=PBYTE(InDataMem+$00)^;
        MaxRed:=PBYTE(InDataMem+$01)^;
        if MinRed > MaxRed then
        begin
          // 8 bit alpha channel
          RedTable[0]:=MinRed;
          RedTable[1]:=MaxRed;
          RedTable[2]:=(6 * MinRed + 1 * MaxRed) div 7;
          RedTable[3]:=(5 * MinRed + 2 * MaxRed) div 7;
          RedTable[4]:=(4 * MinRed + 3 * MaxRed) div 7;
          RedTable[5]:=(3 * MinRed + 4 * MaxRed) div 7;
          RedTable[6]:=(2 * MinRed + 5 * MaxRed) div 7;
          RedTable[7]:=(1 * MinRed + 6 * MaxRed) div 7;
        end // if
          else
        begin
          // 6 bit alpha channel
          RedTable[0]:=MinRed;
          RedTable[1]:=MaxRed;
          RedTable[2]:=(4 * MinRed + 1 * MaxRed) div 5;
          RedTable[3]:=(3 * MinRed + 2 * MaxRed) div 5;
          RedTable[4]:=(2 * MinRed + 3 * MaxRed) div 5;
          RedTable[5]:=(1 * MinRed + 4 * MaxRed) div 5;
          RedTable[6]:=$00;
          RedTable[7]:=$FF;
        end; // else
      end; // else
      //CopyRedBlock:=False;
      if CopyRedBlock then
      begin
        InScanLineMem:=PrevScanLineMem;
        OutScanLineMem:=OutDataMem;
        //inc(dwBlocksDuplicated);
        PDWORD(OutScanLineMem)^:=PDWORD(InScanLineMem)^;
        //PBYTE(OutScanLineMem+$01)^:=PBYTE(InScanLineMem+$01)^;
        //PBYTE(OutScanLineMem+$02)^:=PBYTE(InScanLineMem+$02)^;
        //PBYTE(OutScanLineMem+$03)^:=PBYTE(InScanLineMem+$03)^;
        inc(OutScanLineMem,ScanLineSize);
        inc(InScanLineMem,ScanLineSize);

        PDWORD(OutScanLineMem)^:=PDWORD(InScanLineMem)^;
        //PBYTE(OutScanLineMem+$01)^:=PBYTE(InScanLineMem+$01)^;
        //PBYTE(OutScanLineMem+$02)^:=PBYTE(InScanLineMem+$02)^;
        //PBYTE(OutScanLineMem+$03)^:=PBYTE(InScanLineMem+$03)^;
        inc(OutScanLineMem,ScanLineSize);
        inc(InScanLineMem,ScanLineSize);

        PDWORD(OutScanLineMem)^:=PDWORD(InScanLineMem)^;
        //PBYTE(OutScanLineMem+$01)^:=PBYTE(InScanLineMem+$01)^;
        //PBYTE(OutScanLineMem+$02)^:=PBYTE(InScanLineMem+$02)^;
        //PBYTE(OutScanLineMem+$03)^:=PBYTE(InScanLineMem+$03)^;
        inc(OutScanLineMem,ScanLineSize);
        inc(InScanLineMem,ScanLineSize);

        PDWORD(OutScanLineMem)^:=PDWORD(InScanLineMem)^;
        //PBYTE(OutScanLineMem+$01)^:=PBYTE(InScanLineMem+$01)^;
        //PBYTE(OutScanLineMem+$02)^:=PBYTE(InScanLineMem+$02)^;
        //PBYTE(OutScanLineMem+$03)^:=PBYTE(InScanLineMem+$03)^;
      end
        else
      begin
        PrevScanLineMem:=OutDataMem;
        OutScanLineMem:=OutDataMem;

        IndexTableBlock:=PDWORD(InDataMem+$02)^; //and $00FFFFFF;

        // ScanLine 1
        //IndexTableBlockW:=IndexTableBlockL and $00000FFF;
        PBYTE(OutScanLineMem+$00)^:=RedTable[(IndexTableBlock and $00000007) shr $00];
        PBYTE(OutScanLineMem+$01)^:=RedTable[(IndexTableBlock and $00000038) shr $03];
        PBYTE(OutScanLineMem+$02)^:=RedTable[(IndexTableBlock and $000001C0) shr $06];
        PBYTE(OutScanLineMem+$03)^:=RedTable[(IndexTableBlock and $00000E00) shr $09];
        inc(OutScanLineMem,ScanLineSize);

        // ScanLine 2
        //IndexTableBlockW:=IndexTableBlockL shr $0C;
        PBYTE(OutScanLineMem+$00)^:=RedTable[(IndexTableBlock and $00007000) shr $0C];
        PBYTE(OutScanLineMem+$01)^:=RedTable[(IndexTableBlock and $00038000) shr $0F];
        PBYTE(OutScanLineMem+$02)^:=RedTable[(IndexTableBlock and $001C0000) shr $12];
        PBYTE(OutScanLineMem+$03)^:=RedTable[(IndexTableBlock and $00E00000) shr $15];
        inc(OutScanLineMem,ScanLineSize);

        IndexTableBlock:=PDWORD(InDataMem+$05)^; //and $00FFFFFF;

        // ScanLine 3
        //IndexTableBlockW:=IndexTableBlockL and $00000FFF;
        PBYTE(OutScanLineMem+$00)^:=RedTable[(IndexTableBlock and $00000007) shr $00];
        PBYTE(OutScanLineMem+$01)^:=RedTable[(IndexTableBlock and $00000038) shr $03];
        PBYTE(OutScanLineMem+$02)^:=RedTable[(IndexTableBlock and $000001C0) shr $06];
        PBYTE(OutScanLineMem+$03)^:=RedTable[(IndexTableBlock and $00000E00) shr $09];
        inc(OutScanLineMem,ScanLineSize);

        // ScanLine 4
        //IndexTableBlockW:=IndexTableBlockL shr $0C;
        PBYTE(OutScanLineMem+$00)^:=RedTable[(IndexTableBlock and $00007000) shr $0C];
        PBYTE(OutScanLineMem+$01)^:=RedTable[(IndexTableBlock and $00038000) shr $0F];
        PBYTE(OutScanLineMem+$02)^:=RedTable[(IndexTableBlock and $001C0000) shr $12];
        PBYTE(OutScanLineMem+$03)^:=RedTable[(IndexTableBlock and $00E00000) shr $15];
        //inc(OutScanLineMem,ScanLineSize);
      end;

      inc(InDataMem,8);
      inc(OutDataMem,4);
    end; // for x
    OutDataMem:=OutScanLineMem + 4;
  end; // for y
  //if dwBlocksDuplicated > 0 then
  //Halt(0);
  //FreeMem(POINTER(dwColorTableMem));
  //StopTimer(Timer);
  //ShowTimer(Timer);
end;

function BC5Decode0(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
var
  InDataMem:DWORD;
  OutDataMem:DWORD;

  OutScanLineMem:DWORD;
  InScanLineMem:DWORD;
  PrevScanLineMem:DWORD;

  ScanLineSize:DWORD;

  XBlockIndex:DWORD;
  YBlockIndex:DWORD;
  XBlockCount:DWORD;
  YBlockCount:DWORD;

  IndexTableBlock:DWORD;
  //IndexTableBlockW:WORD;

  PrevRedBlock:QWORD;
  PrevGreenBlock:QWORD;

  CopyRedBlock:BOOLEAN;
  CopyGreenBlock:BOOLEAN;

  MinRed:BYTE;
  MaxRed:BYTE;
  MinGreen:BYTE;
  MaxGreen:BYTE;

  RedTable:Array[0..7] of BYTE;
  GreenTable:Array[0..7] of BYTE;
begin
  Result:=False;
  if (not IsImageSet(InImage)) or IsImageSet(OutImage) then
  Exit;

  //if ((InImage^.Width mod 16) > 0) or ((InImage^.Height mod 16) > 0) then
  //Exit;

  // Create new Image
  if not InitImage(OutImage) then
  Exit;

  // Copy image input image information to output image
  OutImage^.PixelFormat:=PIXEL_FORMAT_R8G8;
  OutImage^.Size:=(InImage^.Width * InImage^.Height) * 2;
  OutImage^.Width:=InImage^.Width;
  OutImage^.Height:=InImage^.Height;
  OutImage^.PixelSize:=16;

  // Alocate target image data memory
  //if OutImage^.mData = nil then
  //GetMem(OutImage^.mData,OutImage^.dwSize);
  if not mAllocMem(OutImage^.Data,OutImage^.Size) then
  begin
    FreeImage(OutImage);
    Exit;
  end;

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);

  ScanLineSize:=InImage^.Width * 2;
  XBlockCount:=(InImage^.Width + 3) shr 2;
  YBlockCount:=(InImage^.Height + 3) shr 2;
  //XBlockCount:=512;
  //dwBlocksDuplicated:=0;
  PrevRedBlock:=PQWORD(InDataMem)^+1;
  PrevGreenBlock:=PQWORD(InDataMem)^+2;
  //PrevColorBlock:=0;
  //PrevIndexBlock:=0;
  //StartTimer(Timer);
  // 628 602 613 634
  // 599 595 603 595
  // 601 593 609 597
  // 626 624 597 607
  for YBlockIndex:=0 to YBlockCount - 1 do
  begin
    for XBlockIndex:=0 to XBlockCount - 1 do
    begin
      CopyRedBlock:=False;
      if WORD(PrevRedBlock) = PWORD(InDataMem+$00)^ then
      begin
        if PrevRedBlock = PQWORD(InDataMem+$00)^ then
        CopyRedBlock:=True else PrevRedBlock:=PQWORD(InDataMem+$00)^;
      end
        else
      begin
        PrevRedBlock:=PQWORD(InDataMem+$00)^;
        MinRed:=PBYTE(InDataMem+$00)^;
        MaxRed:=PBYTE(InDataMem+$01)^;
        if MinRed > MaxRed then
        begin
          // 8 bit alpha channel
          RedTable[0]:=MinRed;
          RedTable[1]:=MaxRed;
          RedTable[2]:=(6 * MinRed + 1 * MaxRed) div 7;
          RedTable[3]:=(5 * MinRed + 2 * MaxRed) div 7;
          RedTable[4]:=(4 * MinRed + 3 * MaxRed) div 7;
          RedTable[5]:=(3 * MinRed + 4 * MaxRed) div 7;
          RedTable[6]:=(2 * MinRed + 5 * MaxRed) div 7;
          RedTable[7]:=(1 * MinRed + 6 * MaxRed) div 7;
        end // if
          else
        begin
          // 6 bit alpha channel
          RedTable[0]:=MinRed;
          RedTable[1]:=MaxRed;
          RedTable[2]:=(4 * MinRed + 1 * MaxRed) div 5;
          RedTable[3]:=(3 * MinRed + 2 * MaxRed) div 5;
          RedTable[4]:=(2 * MinRed + 3 * MaxRed) div 5;
          RedTable[5]:=(1 * MinRed + 4 * MaxRed) div 5;
          RedTable[6]:=$00;
          RedTable[7]:=$FF;
        end; // else
      end; // else

      CopyGreenBlock:=False;
      if WORD(PrevGreenBlock) = PWORD(InDataMem+$08)^ then
      begin
        if PrevGreenBlock = PQWORD(InDataMem+$08)^ then
        CopyGreenBlock:=True else PrevGreenBlock:=PQWORD(InDataMem+$08)^;
      end
        else
      begin
        PrevGreenBlock:=PQWORD(InDataMem+$08)^;
        MinGreen:=PBYTE(InDataMem+$08)^;
        MaxGreen:=PBYTE(InDataMem+$09)^;
        if MinGreen > MaxGreen then
        begin
          // 8 bit alpha channel
          GreenTable[0]:=MinGreen;
          GreenTable[1]:=MaxGreen;
          GreenTable[2]:=(6 * MinGreen + 1 * MaxGreen) div 7;
          GreenTable[3]:=(5 * MinGreen + 2 * MaxGreen) div 7;
          GreenTable[4]:=(4 * MinGreen + 3 * MaxGreen) div 7;
          GreenTable[5]:=(3 * MinGreen + 4 * MaxGreen) div 7;
          GreenTable[6]:=(2 * MinGreen + 5 * MaxGreen) div 7;
          GreenTable[7]:=(1 * MinGreen + 6 * MaxGreen) div 7;
        end // if
          else
        begin
          // 6 bit alpha channel
          GreenTable[0]:=MinGreen;
          GreenTable[1]:=MaxGreen;
          GreenTable[2]:=(4 * MinGreen + 1 * MaxGreen) div 5;
          GreenTable[3]:=(3 * MinGreen + 2 * MaxGreen) div 5;
          GreenTable[4]:=(2 * MinGreen + 3 * MaxGreen) div 5;
          GreenTable[5]:=(1 * MinGreen + 4 * MaxGreen) div 5;
          GreenTable[6]:=$00;
          GreenTable[7]:=$FF;
        end; // else
      end; // else

      //CopyRedBlock:=False;
      //CopyGreenBlock:=False;
      if CopyRedBlock and CopyGreenBlock then
      begin
        // Red and Green components is same a in previous block so we copy them (at same time) instead of decoding
        InScanLineMem:=PrevScanLineMem;
        OutScanLineMem:=OutDataMem;

        PDWORD(OutScanLineMem+$00)^:=PDWORD(InScanLineMem+$00)^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(InScanLineMem+$04)^;
        inc(OutScanLineMem,ScanLineSize);
        inc(InScanLineMem,ScanLineSize);

        PDWORD(OutScanLineMem+$00)^:=PDWORD(InScanLineMem+$00)^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(InScanLineMem+$04)^;
        inc(OutScanLineMem,ScanLineSize);
        inc(InScanLineMem,ScanLineSize);

        PDWORD(OutScanLineMem+$00)^:=PDWORD(InScanLineMem+$00)^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(InScanLineMem+$04)^;
        inc(OutScanLineMem,ScanLineSize);
        inc(InScanLineMem,ScanLineSize);

        PDWORD(OutScanLineMem+$00)^:=PDWORD(InScanLineMem+$00)^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(InScanLineMem+$04)^;
      end
        else
      begin
        if CopyRedBlock then
        begin
          InScanLineMem:=PrevScanLineMem;
          OutScanLineMem:=OutDataMem;

          PBYTE(OutScanLineMem+$00)^:=PBYTE(InScanLineMem+$00)^;
          PBYTE(OutScanLineMem+$02)^:=PBYTE(InScanLineMem+$02)^;
          PBYTE(OutScanLineMem+$04)^:=PBYTE(InScanLineMem+$04)^;
          PBYTE(OutScanLineMem+$06)^:=PBYTE(InScanLineMem+$06)^;
          inc(OutScanLineMem,ScanLineSize);
          inc(InScanLineMem,ScanLineSize);

          PBYTE(OutScanLineMem+$00)^:=PBYTE(InScanLineMem+$00)^;
          PBYTE(OutScanLineMem+$02)^:=PBYTE(InScanLineMem+$02)^;
          PBYTE(OutScanLineMem+$04)^:=PBYTE(InScanLineMem+$04)^;
          PBYTE(OutScanLineMem+$06)^:=PBYTE(InScanLineMem+$06)^;
          inc(OutScanLineMem,ScanLineSize);
          inc(InScanLineMem,ScanLineSize);

          PBYTE(OutScanLineMem+$00)^:=PBYTE(InScanLineMem+$00)^;
          PBYTE(OutScanLineMem+$02)^:=PBYTE(InScanLineMem+$02)^;
          PBYTE(OutScanLineMem+$04)^:=PBYTE(InScanLineMem+$04)^;
          PBYTE(OutScanLineMem+$06)^:=PBYTE(InScanLineMem+$06)^;
          inc(OutScanLineMem,ScanLineSize);
          inc(InScanLineMem,ScanLineSize);

          PBYTE(OutScanLineMem+$00)^:=PBYTE(InScanLineMem+$00)^;
          PBYTE(OutScanLineMem+$02)^:=PBYTE(InScanLineMem+$02)^;
          PBYTE(OutScanLineMem+$04)^:=PBYTE(InScanLineMem+$04)^;
          PBYTE(OutScanLineMem+$06)^:=PBYTE(InScanLineMem+$06)^;
        end
          else
        begin
          PrevScanLineMem:=OutDataMem;
          OutScanLineMem:=OutDataMem;

          IndexTableBlock:=PDWORD(InDataMem+$02)^; //and $00FFFFFF;
          // ScanLine 1
          //IndexTableBlockW:=IndexTableBlockL and $00000FFF;
          PBYTE(OutScanLineMem+$00)^:=RedTable[(IndexTableBlock and $00000007) shr $00];
          PBYTE(OutScanLineMem+$02)^:=RedTable[(IndexTableBlock and $00000038) shr $03];
          PBYTE(OutScanLineMem+$04)^:=RedTable[(IndexTableBlock and $000001C0) shr $06];
          PBYTE(OutScanLineMem+$06)^:=RedTable[(IndexTableBlock and $00000E00) shr $09];
          inc(OutScanLineMem,ScanLineSize);

          // ScanLine 2
          //IndexTableBlockW:=IndexTableBlockL shr $0C;
          PBYTE(OutScanLineMem+$00)^:=RedTable[(IndexTableBlock and $00007000) shr $0C];
          PBYTE(OutScanLineMem+$02)^:=RedTable[(IndexTableBlock and $00038000) shr $0F];
          PBYTE(OutScanLineMem+$04)^:=RedTable[(IndexTableBlock and $001C0000) shr $12];
          PBYTE(OutScanLineMem+$06)^:=RedTable[(IndexTableBlock and $00E00000) shr $15];
          inc(OutScanLineMem,ScanLineSize);

          IndexTableBlock:=PDWORD(InDataMem+$05)^; //and $00FFFFFF;

          // ScanLine 3
          //IndexTableBlockW:=IndexTableBlockL and $00000FFF;
          PBYTE(OutScanLineMem+$00)^:=RedTable[(IndexTableBlock and $00000007) shr $00];
          PBYTE(OutScanLineMem+$02)^:=RedTable[(IndexTableBlock and $00000038) shr $03];
          PBYTE(OutScanLineMem+$04)^:=RedTable[(IndexTableBlock and $000001C0) shr $06];
          PBYTE(OutScanLineMem+$06)^:=RedTable[(IndexTableBlock and $00000E00) shr $09];
          inc(OutScanLineMem,ScanLineSize);

          // ScanLine 4
          //IndexTableBlockW:=IndexTableBlockL shr $0C;
          PBYTE(OutScanLineMem+$00)^:=RedTable[(IndexTableBlock and $00007000) shr $0C];
          PBYTE(OutScanLineMem+$02)^:=RedTable[(IndexTableBlock and $00038000) shr $0F];
          PBYTE(OutScanLineMem+$04)^:=RedTable[(IndexTableBlock and $001C0000) shr $12];
          PBYTE(OutScanLineMem+$06)^:=RedTable[(IndexTableBlock and $00E00000) shr $15];
        end;

        if CopyGreenBlock then
        begin
          InScanLineMem:=PrevScanLineMem;
          OutScanLineMem:=OutDataMem;

          PBYTE(OutScanLineMem+$01)^:=PBYTE(InScanLineMem+$01)^;
          PBYTE(OutScanLineMem+$03)^:=PBYTE(InScanLineMem+$03)^;
          PBYTE(OutScanLineMem+$05)^:=PBYTE(InScanLineMem+$05)^;
          PBYTE(OutScanLineMem+$07)^:=PBYTE(InScanLineMem+$07)^;
          inc(OutScanLineMem,ScanLineSize);
          inc(InScanLineMem,ScanLineSize);

          PBYTE(OutScanLineMem+$01)^:=PBYTE(InScanLineMem+$01)^;
          PBYTE(OutScanLineMem+$03)^:=PBYTE(InScanLineMem+$03)^;
          PBYTE(OutScanLineMem+$05)^:=PBYTE(InScanLineMem+$05)^;
          PBYTE(OutScanLineMem+$07)^:=PBYTE(InScanLineMem+$07)^;
          inc(OutScanLineMem,ScanLineSize);
          inc(InScanLineMem,ScanLineSize);

          PBYTE(OutScanLineMem+$01)^:=PBYTE(InScanLineMem+$01)^;
          PBYTE(OutScanLineMem+$03)^:=PBYTE(InScanLineMem+$03)^;
          PBYTE(OutScanLineMem+$05)^:=PBYTE(InScanLineMem+$05)^;
          PBYTE(OutScanLineMem+$07)^:=PBYTE(InScanLineMem+$07)^;
          inc(OutScanLineMem,ScanLineSize);
          inc(InScanLineMem,ScanLineSize);

          PBYTE(OutScanLineMem+$01)^:=PBYTE(InScanLineMem+$01)^;
          PBYTE(OutScanLineMem+$03)^:=PBYTE(InScanLineMem+$03)^;
          PBYTE(OutScanLineMem+$05)^:=PBYTE(InScanLineMem+$05)^;
          PBYTE(OutScanLineMem+$07)^:=PBYTE(InScanLineMem+$07)^;
        end
          else
        begin
          PrevScanLineMem:=OutDataMem;
          OutScanLineMem:=OutDataMem;

          IndexTableBlock:=PDWORD(InDataMem+$0A)^; //and $00FFFFFF;
          // ScanLine 1
          //IndexTableBlockW:=IndexTableBlockL and $00000FFF;
          PBYTE(OutScanLineMem+$01)^:=GreenTable[(IndexTableBlock and $00000007) shr $00];
          PBYTE(OutScanLineMem+$03)^:=GreenTable[(IndexTableBlock and $00000038) shr $03];
          PBYTE(OutScanLineMem+$05)^:=GreenTable[(IndexTableBlock and $000001C0) shr $06];
          PBYTE(OutScanLineMem+$07)^:=GreenTable[(IndexTableBlock and $00000E00) shr $09];
          inc(OutScanLineMem,ScanLineSize);

          // ScanLine 2
          //IndexTableBlockW:=IndexTableBlockL shr $0C;
          PBYTE(OutScanLineMem+$01)^:=GreenTable[(IndexTableBlock and $00007000) shr $0C];
          PBYTE(OutScanLineMem+$03)^:=GreenTable[(IndexTableBlock and $00038000) shr $0F];
          PBYTE(OutScanLineMem+$05)^:=GreenTable[(IndexTableBlock and $001C0000) shr $12];
          PBYTE(OutScanLineMem+$07)^:=GreenTable[(IndexTableBlock and $00E00000) shr $15];
          inc(OutScanLineMem,ScanLineSize);

          IndexTableBlock:=PDWORD(InDataMem+$0D)^; //and $00FFFFFF;

          // ScanLine 1
          //IndexTableBlockW:=IndexTableBlockL and $00000FFF;
          PBYTE(OutScanLineMem+$01)^:=GreenTable[(IndexTableBlock and $00000007) shr $00];
          PBYTE(OutScanLineMem+$03)^:=GreenTable[(IndexTableBlock and $00000038) shr $03];
          PBYTE(OutScanLineMem+$05)^:=GreenTable[(IndexTableBlock and $000001C0) shr $06];
          PBYTE(OutScanLineMem+$07)^:=GreenTable[(IndexTableBlock and $00000E00) shr $09];
          inc(OutScanLineMem,ScanLineSize);

          // ScanLine 2
          //IndexTableBlockW:=IndexTableBlockL shr $0C;
          PBYTE(OutScanLineMem+$01)^:=GreenTable[(IndexTableBlock and $00007000) shr $0C];
          PBYTE(OutScanLineMem+$03)^:=GreenTable[(IndexTableBlock and $00038000) shr $0F];
          PBYTE(OutScanLineMem+$05)^:=GreenTable[(IndexTableBlock and $001C0000) shr $12];
          PBYTE(OutScanLineMem+$07)^:=GreenTable[(IndexTableBlock and $00E00000) shr $15];
        end;
      end;
      inc(InDataMem,16);
      inc(OutDataMem,8);
    end; // for x
    OutDataMem:=OutScanLineMem + 8;
  end; // for y
  //if dwBlocksDuplicated > 0 then
  //Halt(0);
  //FreeMem(POINTER(dwColorTableMem));
  //StopTimer(Timer);
  //ShowTimer(Timer);
end;















(*
function BC1Decode(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
var
  InDataMem:DWORD;
  OutDataMem:DWORD;

  OutScanLineMem:DWORD;
  InScanLineMem:DWORD;
  dwPrevScanLineMem:DWORD;

  ScanLineSize:DWORD;

  XBlockIndex:DWORD;
  YBlockIndex:DWORD;
  XBlockCount:DWORD;
  YBlockCount:DWORD;

  XSkip:DWORD;
  YSkip:DWORD;

  IndexTableBlock:BYTE;

  PrevColorBlock:DWORD;
  dwPrevIndexBlock:DWORD;

  bCopyColorBlock:BOOLEAN;

  MinIndex:BYTE;
  MaxIndex:BYTE;
  MinColor:WORD;
  MaxColor:WORD;

  ColorTable:Array[0..3] of Array[0..3] of BYTE;
begin
  Result:=False;
  if not IsImageSet(InImage) then
  Exit;

  //if ((InImage^.Width mod 16) > 0) or ((InImage^.Height mod 16) > 0) then
  //Exit;

  // Create new Image
  //if not InitImage(OutImage) then
  //Exit;

  // Copy image input image information to output image
  OutImage^.enPixelFormat:=PIXEL_FORMAT_R8G8B8A8;
  OutImage^.Size:=(InImage^.Width * InImage^.Height) * 4;
  OutImage^.Width:=InImage^.Width;
  OutImage^.Height:=InImage^.Height;
  OutImage^.dwPixelSize:=32;

  // Alocate target image data memory
  if not mAllocMem(OutImage^.Data,OutImage^.Size) then
  begin
    FreeImage(OutImage);
    Exit;
  end;

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);

  ScanLineSize:=InImage^.Width * 4;
  XBlockCount:=(InImage^.Width + 3) shr 2;
  YBlockCount:=(InImage^.Height + 3) shr 2;
  PrevColorBlock:=0;
  dwPrevIndexBlock:=0;
  //StartTimer(Timer);
  for YBlockIndex:=0 to YBlockCount - 1 do
  begin
    for XBlockIndex:=0 to XBlockCount - 1 do
    begin
      bCopyColorBlock:=False;
      if PrevColorBlock = PDWORD(InDataMem+$00)^ then
      begin
        // We found that previous colors in block are same as current block so we check if current
        // block have same color indexes ,if yes then we
        if dwPrevIndexBlock = PDWORD(InDataMem+$04)^ then
        bCopyColorBlock:=True else dwPrevIndexBlock:=PDWORD(InDataMem+$04)^
      end
        else
      begin
        PrevColorBlock:=PDWORD(InDataMem+$00)^;
        dwPrevIndexBlock:=PDWORD(InDataMem+$04)^;

        MinColor:=PWORD(InDataMem+$00)^;
        MaxColor:=PWORD(InDataMem+$02)^;

        if MinColor > MaxColor then
        begin
          // Without alpha channel
          ColorTable[0][0]:=(MinColor and $001F) shl 3;
          ColorTable[0][1]:=(MinColor and $07E0) shr 3;
          ColorTable[0][2]:=(MinColor and $F800) shr 8;
          ColorTable[0][3]:=$FF;

          ColorTable[1][0]:=(MaxColor and $001F) shl 3;
          ColorTable[1][1]:=(MaxColor and $07E0) shr 3;
          ColorTable[1][2]:=(MaxColor and $F800) shr 8;
          ColorTable[1][3]:=$FF;

          ColorTable[2][0]:=((ColorTable[0][0] shl 1) + ColorTable[1][0]) div 3;
          ColorTable[2][1]:=((ColorTable[0][1] shl 1) + ColorTable[1][1]) div 3;
          ColorTable[2][2]:=((ColorTable[0][2] shl 1) + ColorTable[1][2]) div 3;
          ColorTable[2][3]:=$FF;

          ColorTable[3][0]:=((ColorTable[1][0] shl 1) + ColorTable[0][0]) div 3;
          ColorTable[3][1]:=((ColorTable[1][1] shl 1) + ColorTable[0][1]) div 3;
          ColorTable[3][2]:=((ColorTable[1][2] shl 1) + ColorTable[0][2]) div 3;
          ColorTable[3][3]:=$FF;
        end // if
          else
        begin
          // With alpha channel
          ColorTable[0][0]:=(MinColor and $001F) shl 3;
          ColorTable[0][1]:=(MinColor and $07E0) shr 3;
          ColorTable[0][2]:=(MinColor and $F800) shr 8;
          ColorTable[0][3]:=$FF;

          ColorTable[1][0]:=(MaxColor and $001F) shl 3;
          ColorTable[1][1]:=(MaxColor and $07E0) shr 3;
          ColorTable[1][2]:=(MaxColor and $F800) shr 8;
          ColorTable[1][3]:=$FF;

          ColorTable[2][0]:=(ColorTable[0][0] + ColorTable[1][0]) div 2;
          ColorTable[2][1]:=(ColorTable[0][1] + ColorTable[1][1]) div 2;
          ColorTable[2][2]:=(ColorTable[0][2] + ColorTable[1][2]) div 2;
          ColorTable[2][3]:=$FF;

          ColorTable[3][0]:=((ColorTable[1][0] shl 1) + ColorTable[0][0]) div 3;
          ColorTable[3][1]:=((ColorTable[1][1] shl 1) + ColorTable[0][1]) div 3;
          ColorTable[3][2]:=((ColorTable[1][2] shl 1) + ColorTable[0][2]) div 3;
          ColorTable[3][3]:=$00;
        end; // else
      end; // if

      if bCopyColorBlock then
      begin
        InScanLineMem:=dwPrevScanLineMem;
        OutScanLineMem:=OutDataMem;
        //inc(dwBlocksDuplicated);
        PDWORD(OutScanLineMem+$00)^:=PDWORD(InScanLineMem+$00)^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(InScanLineMem+$04)^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(InScanLineMem+$08)^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(InScanLineMem+$0C)^;
        inc(OutScanLineMem,ScanLineSize);
        inc(InScanLineMem,ScanLineSize);

        PDWORD(OutScanLineMem+$00)^:=PDWORD(InScanLineMem+$00)^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(InScanLineMem+$04)^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(InScanLineMem+$08)^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(InScanLineMem+$0C)^;
        inc(OutScanLineMem,ScanLineSize);
        inc(InScanLineMem,ScanLineSize);

        PDWORD(OutScanLineMem+$00)^:=PDWORD(InScanLineMem+$00)^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(InScanLineMem+$04)^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(InScanLineMem+$08)^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(InScanLineMem+$0C)^;
        inc(OutScanLineMem,ScanLineSize);
        inc(InScanLineMem,ScanLineSize);

        PDWORD(OutScanLineMem+$00)^:=PDWORD(InScanLineMem+$00)^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(InScanLineMem+$04)^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(InScanLineMem+$08)^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(InScanLineMem+$0C)^;
      end
        else
      begin
        dwPrevScanLineMem:=OutDataMem;
        OutScanLineMem:=OutDataMem;

        IndexTableBlock:=PBYTE(InDataMem+$04)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlock][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlock][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlock][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlock][3]])^;
        inc(OutScanLineMem,ScanLineSize);

        IndexTableBlock:=PBYTE(InDataMem+$05)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlock][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlock][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlock][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlock][3]])^;
        inc(OutScanLineMem,ScanLineSize);

        IndexTableBlock:=PBYTE(InDataMem+$06)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlock][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlock][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlock][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlock][3]])^;
        inc(OutScanLineMem,ScanLineSize);

        IndexTableBlock:=PBYTE(InDataMem+$07)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlock][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlock][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlock][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlock][3]])^;
      end; // else
      inc(InDataMem,8);
      inc(OutDataMem,16);
    end; // for x
    OutDataMem:=OutScanLineMem + 16;
  end; // for y
  //if dwBlocksDuplicated > 0 then
  //Halt(0);
  //FreeMem(POINTER(dwColorTableMem));
  //StopTimer(Timer);
  //ShowTimer(Timer);
end;
*)
end.
