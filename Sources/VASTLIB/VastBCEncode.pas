unit VastBCEncode;

{$I VastImageSettings.inc}

interface

uses
  VastImage, VastImageTypes, VastMemory, ProcTimer, VastBCTablesLow, VastUtils;

function BC1Encode(var InImage:PVastImage;var OutImage:PVastImage):Boolean;

procedure PrepareDistanceTable();
//procedure ExtractBlock();

//procedure WriteColorBlock (const dwOutDataMem:DWORD);
implementation

var
  Timer:TProcTimer;
  ColorBlock:Array[0..15] of Array[0..3] of BYTE;
  DistanceTable:Array[0..255] of Array[0..255] of INTEGER;
  LookupColors:Array[0..3] of Array[0..3] of BYTE;
  MaskBlock:Array[0..15] of BYTE;

  IsAlphaBlock:DWORD;
  MinColor,MaxColor:DWORD;
  //dwMinColorIndex,dwMaxColorIndex:DWORD;
  BlockWidth,BlockHeight:DWORD;

  InDataMem:DWORD;
  ScanLineSize:DWORD;

procedure PrepareDistanceTable();
var
  dwCol1,dwCol2:DWORD;
begin
  for dwCol1:=0 to 255 do
  begin
    for dwCol2:=0 to 255 do
    begin
      DistanceTable[dwCol1][dwCol2]:=(dwCol1-dwCol2) * (dwCol1-dwCol2);
      //if DistanceTable[dwCol1][dwCol2] < 0 then
      //DistanceTable[dwCol1][dwCol2]:=0;
    end;
  end;
end;

// Be sure that width and height <= 4 because of ColorBlock size
procedure ExtractBlock();
var
  dwScanLineMem:DWORD;
begin
  dwScanLineMem:=InDataMem;
  PDWORD(@ColorBlock[0][0])^:=PDWORD(dwScanLineMem+$00)^;
  PDWORD(@ColorBlock[1][0])^:=PDWORD(dwScanLineMem+$04)^;
  PDWORD(@ColorBlock[2][0])^:=PDWORD(dwScanLineMem+$08)^;
  PDWORD(@ColorBlock[3][0])^:=PDWORD(dwScanLineMem+$0C)^;
  Inc(dwScanLineMem,ScanLineSize);

  PDWORD(@ColorBlock[4][0])^:=PDWORD(dwScanLineMem+$00)^;
  PDWORD(@ColorBlock[5][0])^:=PDWORD(dwScanLineMem+$04)^;
  PDWORD(@ColorBlock[6][0])^:=PDWORD(dwScanLineMem+$08)^;
  PDWORD(@ColorBlock[7][0])^:=PDWORD(dwScanLineMem+$0C)^;
  Inc(dwScanLineMem,ScanLineSize);

  PDWORD(@ColorBlock[8][0])^:=PDWORD(dwScanLineMem+$00)^;
  PDWORD(@ColorBlock[9][0])^:=PDWORD(dwScanLineMem+$04)^;
  PDWORD(@ColorBlock[10][0])^:=PDWORD(dwScanLineMem+$08)^;
  PDWORD(@ColorBlock[11][0])^:=PDWORD(dwScanLineMem+$0C)^;
  Inc(dwScanLineMem,ScanLineSize);

  PDWORD(@ColorBlock[12][0])^:=PDWORD(dwScanLineMem+$00)^;
  PDWORD(@ColorBlock[13][0])^:=PDWORD(dwScanLineMem+$04)^;
  PDWORD(@ColorBlock[14][0])^:=PDWORD(dwScanLineMem+$08)^;
  PDWORD(@ColorBlock[15][0])^:=PDWORD(dwScanLineMem+$0C)^;
  //Inc(dwScanLineMem,ScanLineSize);
end;
(*
asm
  cmp [BlockWidth],$000000FF
  jz @WRONG_INPUT
  cmp [BlockHeight],$000000FF
  jz @WRONG_INPUT
  //test ecx,ecx
  //jz @WRONG_INPUT
  jmp @CONTINUE
  @WRONG_INPUT:
  //pop eax
  ret


  @CONTINUE:
  push ebx
  push esi
  push edi

  mov esi,InDataMem
  lea edi,[ColorBlock]
  //mov edx,[BlockWidth]
  mov ecx,[BlockHeight]

  xor edx,edx
  mov [IsAlphaBlock],edx
  @LOOP_Y:
    @LOOP_X:
      mov ebx,[esi+edx*4]
      mov [edi+edx*4],ebx
      // Test Alpha channel
      test ebx,$80000000
      cmovz eax,ebx
    inc edx
    cmp edx,[BlockWidth] // Width
    jne @LOOP_X
  add esi,[ScanLineSize] // ScanLineSize
  add edi,$10
  xor edx,edx
  loop @LOOP_Y

  test eax,$80000000
  setz BYTE[IsAlphaBlock]
  //pop edx

  pop edi
  pop esi
  pop ebx
end;
*)
(*
procedure TestBlockAlpha;
asm
  lea eax,[ColorBlock+$03]
  //add eax,$03 // seek to alpha channel byte
  xor ecx,ecx
  mov cl,$10  // 16 pixels
  @TEST:
    mov dl,[eax]
    test dl,$80 // < 128
    jz @ISALPHA
  loop @TEST
  mov [IsAlphaBlock],$00000000
  ret
  @ISALPHA:
  mov [IsAlphaBlock],$00000001
  ret
end;
*)

function Pixel32To16(const dwPixel:DWORD):WORD;
asm
  mov edx,eax

  shr ah,$02 // Green
  shr ax,$03 // Red

  shr edx,$08
  and dh,$F8 // Blue

  or ah,dh
end;

function Pixel16To32(const dwPixel:DWORD):DWORD;
asm
  mov edx,eax

  shl eax,$08  // Blue
  mov al,ah
  shl al,$03 // Red

  shr edx,$03
  mov ah,dl  // Green

end;

procedure GetMinMaxColorIndex1();
var
  dwMinColorIndex,dwMaxColorIndex:DWORD;
  dwDistance,dwMaxDistance:DWORD;
  dwPos1,dwPos2:DWORD;
begin
  dwMinColorIndex:=0;
  dwMinColorIndex:=0;
  dwMaxDistance:=0;
  for dwPos1:=0 to 15 do
  begin
    for dwPos2:=dwPos1+1 to 15 do
    begin
      //dwDistance:=
      //DistanceTable[ColorBlock[dwPos1][0]][ColorBlock[dwPos2][0]] +
      //DistanceTable[ColorBlock[dwPos1][1]][ColorBlock[dwPos2][1]] +
      //DistanceTable[ColorBlock[dwPos1][2]][ColorBlock[dwPos2][2]] ;
      dwDistance:=
      ( (ColorBlock[dwPos1][0] - ColorBlock[dwPos2][0]) * (ColorBlock[dwPos1][0] - ColorBlock[dwPos2][0])) +
      ( (ColorBlock[dwPos1][1] - ColorBlock[dwPos2][1]) * (ColorBlock[dwPos1][1] - ColorBlock[dwPos2][1])) +
      ( (ColorBlock[dwPos1][2] - ColorBlock[dwPos2][2]) * (ColorBlock[dwPos1][2] - ColorBlock[dwPos2][2]));

      if dwDistance > dwMaxDistance then
      begin
        dwMaxDistance:=dwDistance;
        dwMinColorIndex:=dwPos1;
        dwMaxColorIndex:=dwPos2;
      end;

    end; // for pos2
  end; // for pos 1

  MinColor:=PDWORD(@ColorBlock[dwMinColorIndex][0])^;
  MaxColor:=PDWORD(@ColorBlock[dwMaxColorIndex][0])^;

  if IsAlphaBlock <> 0 then
  begin
    if Pixel32To16(MinColor) > Pixel32To16(MaxColor) then
    SwapDWORD(MinColor,MaxColor);
  end
    else
  begin
    if Pixel32To16(MinColor) < Pixel32To16(MaxColor) then
    SwapDWORD(MinColor,MaxColor);
  end;

end;

(*
procedure GetMinMaxColorIndex();
asm
  push ebx
  push esi
  push edi
  sub esp,$20
  //mov [esp],$0000000F  // 16
  xor ecx,ecx // 0

  // Init variables
  lea eax,ColorBlock
  mov [esp+$0C],eax
  mov [esp+$10],eax

  mov [esp+$08],ecx // maxdistance = 0
  @LOOP1:
    mov [esp+$04],ecx // dwPos1
    lea esi,[ColorBlock+ecx*4]
    inc ecx  // for dwPos2:=dwPos1+1 to 15 do
    //cmp ecx,$0F  // Check if ecx > 14 then
    //cmovg ecx,[esp] // ECX = 15
    //jg @SKIPLOOP2
    @LOOP2:
      lea edi,[ColorBlock+ecx*4]
      xor edx,edx  // EDX = Distance

      // Red1 * (256 * 4) + Red2 * 4
      movzx eax,BYTE[esi+$00]
      shl eax,$0A  //EAX = Red1 * (256 * 4)
      movzx ebx,BYTE[edi+$00]
      shl ebx,$02  //EBX = Red2 *  4

      add edx,DWORD[DistanceTable+eax+ebx]

      // Green
      movzx eax,BYTE[esi+$01]
      shl eax,$0A
      movzx ebx,BYTE[edi+$01]
      shl ebx,$02

      add edx,DWORD[DistanceTable+eax+ebx]

      // Blue
      movzx eax,BYTE[esi+$02]
      shl eax,$0A
      movzx ebx,BYTE[edi+$02]
      shl ebx,$02

      add edx,DWORD[DistanceTable+eax+ebx]

      cmp edx,[esp+$08]
      jle @SKIPUPDATE
        mov [esp+$08],edx   // Maxdistance = Distance
        mov [esp+$0C],esi   // Pointer to min color
        mov [esp+$10],edi   // Pointer to max color
      @SKIPUPDATE:
    inc ecx
    cmp ecx,$0F
    jng @LOOP2
  @SKIPLOOP2:
  mov ecx,[esp+$04]
  inc ecx
  cmp ecx,$0E
  jng @LOOP1
  // Update min max colors
  mov eax,[esp+$0C]
  mov eax,[eax]
  mov ebx,[esp+$10]
  mov ebx,[ebx]

  mov [MinColor],eax
  mov [MaxColor],ebx

  //pop ecx
  add esp,$20
  pop edi
  pop esi
  pop ebx
  ret
end;
*)
procedure WriteColorBlock (const dwOutDataMem:DWORD);
var
  bRed,bGreen,bBlue:BYTE;
begin

  PWORD(dwOutDataMem+$00)^:=Pixel32To16(MinColor);
  PWORD(dwOutDataMem+$02)^:=Pixel32To16(MaxColor);
  //bRed:=PBYTE(DWORD(@MinColor)+$00)^;
  //bGreen:=PBYTE(DWORD(@MinColor)+$01)^;
  //bBlue:=PBYTE(DWORD(@MinColor)+$02)^;
  (*
  bRed:=PBYTE(DWORD(@MinColor)+$02)^;
  bGreen:=PBYTE(DWORD(@MinColor)+$01)^;
  bBlue:=PBYTE(DWORD(@MinColor)+$00)^;

  PWORD(dwOutDataMem+$00)^:= ((bRed and $F8) shl 8) or ((bGreen and $FC) shl 3) or ((bBlue and $F8) shr 3);

  (
  bRed:=PBYTE(DWORD(@MaxColor)+$02)^;
  bGreen:=PBYTE(DWORD(@MaxColor)+$01)^;
  bBlue:=PBYTE(DWORD(@MaxColor)+$00)^;

  PWORD(dwOutDataMem+$02)^:= ((bRed and $F8) shl 8) or ((bGreen and $FC) shl 3) or ((bBlue and $F8) shr 3);
  *)
end;
(*
asm
  // Write Min color
  mov ecx,[MinColor]
  xor edx,edx
  // Red
  and cl,$1F
  or dl,cl
  shr ecx,$08
  shl edx,$05
  // Green
  and cl,$3F
  or dl,cl
  shr ecx,$08
  shl edx,$06
  // Blue
  and cl,$1F
  or dl,cl
  xchg dh,dl
  mov [eax],dx

  mov ecx,[MaxColor]
  xor edx,edx
  // Red
  and cl,$1F
  or dl,cl
  shr ecx,$08
  shl edx,$05
  // Green
  and cl,$3F
  or dl,cl
  shr ecx,$08
  shl edx,$06
  // Blue
  and cl,$1F
  or dl,cl
  xchg dh,dl
  mov [eax+$02],dx
end;
*)

procedure WriteColorMask (const dwOutDataMem:DWORD);
var
  dwDistance,dwMinDistance:DWORD;
  dwColorIndex:DWORD;
  dwLookupIndex:DWORD;
  dwIndexTable:DWORD;
begin
  PDWORD(@LookupColors[0][0])^:=Pixel16To32(Pixel32To16(MinColor));
  PDWORD(@LookupColors[1][0])^:=Pixel16To32(Pixel32To16(MaxColor));
  //DWORD(LookupColors[0][0]):=MinColor;

  //IsAlphaBlock:=0;

  if IsAlphaBlock <> 0 then
  begin
    // With alpha channel
    LookupColors[2][0]:=(LookupColors[0][0] + LookupColors[1][0]) div 2;
    LookupColors[2][1]:=(LookupColors[0][1] + LookupColors[1][1]) div 2;
    LookupColors[2][2]:=(LookupColors[0][2] + LookupColors[1][2]) div 2;
    LookupColors[2][3]:=$FF;
    //DWORD(LookupColors[3]):=0;

    for dwColorIndex:=0 to 15 do
    begin

      if ColorBlock[dwColorIndex][3] < $80 then
      begin
        MaskBlock[dwColorIndex]:=$03;
        Continue;
      end;

      dwMinDistance:=$FFFFFFFF;
      for dwLookupIndex:=0 to 2 do
      begin
        (*
        dwDistance:=
          DistanceTable[ColorBlock[dwColorIndex][0]][LookupColors[dwLookupIndex][0]] +
          DistanceTable[ColorBlock[dwColorIndex][1]][LookupColors[dwLookupIndex][1]] +
          DistanceTable[ColorBlock[dwColorIndex][2]][LookupColors[dwLookupIndex][2]] ;
        *)
        dwDistance:=
        ( (ColorBlock[dwColorIndex][0] - LookupColors[dwLookupIndex][0]) * (ColorBlock[dwColorIndex][0] - LookupColors[dwLookupIndex][0])) +
        ( (ColorBlock[dwColorIndex][1] - LookupColors[dwLookupIndex][1]) * (ColorBlock[dwColorIndex][1] - LookupColors[dwLookupIndex][1])) +
        ( (ColorBlock[dwColorIndex][2] - LookupColors[dwLookupIndex][2]) * (ColorBlock[dwColorIndex][2] - LookupColors[dwLookupIndex][2]));
        if dwDistance < dwMinDistance then
        begin
          dwMinDistance:=dwDistance;
          MaskBlock[dwColorIndex]:=dwLookupIndex;
        end;
      end; // for dwLookupIndex
    end; // for
  end
    else
  begin
  (*
    // Red
    LookupColors[2][0]:=BCRColorTable[LookupColors[0][0]][LookupColors[1][0]][0];
    LookupColors[3][0]:=BCRColorTable[LookupColors[0][0]][LookupColors[1][0]][1];

    // Green
    LookupColors[2][1]:=BCGColorTable[LookupColors[0][1]][LookupColors[1][1]][0];
    LookupColors[3][1]:=BCGColorTable[LookupColors[0][1]][LookupColors[1][1]][1];

    // Blue
    LookupColors[2][2]:=BCBColorTable[LookupColors[0][2]][LookupColors[1][2]][0];
    LookupColors[3][2]:=BCBColorTable[LookupColors[0][2]][LookupColors[1][2]][1];
  *)

    LookupColors[2][0]:= ((LookupColors[0][0] shl 1) + LookupColors[1][0] ) div 3;
    LookupColors[2][1]:= ((LookupColors[0][1] shl 1) + LookupColors[1][1] ) div 3;
    LookupColors[2][2]:= ((LookupColors[0][2] shl 1) + LookupColors[1][2] ) div 3;

    LookupColors[3][0]:= (LookupColors[0][0] + (LookupColors[1][0] shl 1) ) div 3;
    LookupColors[3][1]:= (LookupColors[0][1] + (LookupColors[1][1] shl 1) ) div 3;
    LookupColors[3][2]:= (LookupColors[0][2] + (LookupColors[1][2] shl 1) ) div 3;


    for dwColorIndex:=0 to 15 do
    begin
      dwMinDistance:=$FFFFFFFF;
      for dwLookupIndex:=0 to 3 do
      begin
      (*
        dwDistance:=
          DistanceTable[ColorBlock[dwColorIndex][0]][LookupColors[dwLookupIndex][0]] +
          DistanceTable[ColorBlock[dwColorIndex][1]][LookupColors[dwLookupIndex][1]] +
          DistanceTable[ColorBlock[dwColorIndex][2]][LookupColors[dwLookupIndex][2]] ;
      *)
        dwDistance:=
        ( (ColorBlock[dwColorIndex][0] - LookupColors[dwLookupIndex][0]) * (ColorBlock[dwColorIndex][0] - LookupColors[dwLookupIndex][0])) +
        ( (ColorBlock[dwColorIndex][1] - LookupColors[dwLookupIndex][1]) * (ColorBlock[dwColorIndex][1] - LookupColors[dwLookupIndex][1])) +
        ( (ColorBlock[dwColorIndex][2] - LookupColors[dwLookupIndex][2]) * (ColorBlock[dwColorIndex][2] - LookupColors[dwLookupIndex][2]));

        if dwDistance < dwMinDistance then
        begin
          dwMinDistance:=dwDistance;
          MaskBlock[dwColorIndex]:=dwLookupIndex;
        end;
      end; // for dwLookupIndex
    end; // for
  end;

  dwIndexTable:=0;
  for dwColorIndex := 0 to 15 do
  dwIndexTable:= dwIndexTable or (MaskBlock[dwColorIndex] shl (dwColorIndex shl 1));
  PDWORD(dwOutDataMem)^:=dwIndexTable;

  //PBYTE(dwOutDataMem+$00)^:= MaskBlock[0] or (MaskBlock[1] shl $02) or (MaskBlock[2] shl $04) or (MaskBlock[3] shl $06);
  //PBYTE(dwOutDataMem+$01)^:= MaskBlock[4] or (MaskBlock[5] shl $02) or (MaskBlock[6] shl $04) or (MaskBlock[7] shl $06);
  //PBYTE(dwOutDataMem+$02)^:= MaskBlock[8] or (MaskBlock[9] shl $02) or (MaskBlock[10] shl $04) or (MaskBlock[11] shl $06);
  //PBYTE(dwOutDataMem+$03)^:= MaskBlock[12] or (MaskBlock[13] shl $02) or (MaskBlock[14] shl $04) or (MaskBlock[15] shl $06);

 //for dwColorIndex:=0 to 15 do
  //begin
  //  dwIndexTable:=dwIndexTable or
  //end;


end;

function BC1Encode(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
var
  OutDataMem:DWORD;
  //dwOutDataSize:DWORD;
  //dwOutScanLineMem:DWORD;
  //dwInScanLineMem:DWORD;
  //dwPrevScanLineMem:DWORD;

  //ScanLineSize:DWORD;

  XBlockIndex:DWORD;
  YBlockIndex:DWORD;
  XBlockCount:DWORD;
  YBlockCount:DWORD;

  //dwXSkip:DWORD;
  //dwYSkip:DWORD;
  Width,Height:DWORD;
begin
  Result:=False;
  if not IsImageSet(InImage) then
  Exit;

  // Create new Image
  if not InitImage(OutImage) then
  Exit;
  PrepareDistanceTable;

  CloneImageStruct(InImage,OutImage);
  OutImage^.PixelFormat:=PIXEL_FORMAT_BC1;
  OutImage^.Data:=nil;
  OutImage^.Size:=AlignImageDim(OutImage^.Width,4) * AlignImageDim(OutImage^.Height,4);

  //Alocate target image data memory
  if not mAllocMem(OutImage^.Data, OutImage^.Size) then
  begin
    FreeImage(OutImage);
    Exit;
  end;

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);

  ScanLineSize:=InImage^.Width * 4;
  XBlockCount:=(InImage^.Width + 3) shr 2;
  YBlockCount:=(InImage^.Height + 3) shr 2;

  Width:=InImage^.Width;
  Height:=InImage^.Height;

  for YBlockIndex:=0 to YBlockCount - 2 do
  begin
    if Height > 4 then
    BlockHeight:=4 else BlockHeight:=Height;
    Dec(Height,BlockHeight);

    Width:=InImage^.Width;
    for XBlockIndex:=0 to XBlockCount - 2 do
    begin
      if Width > 4 then
      BlockWidth:=4 else BlockWidth:=Width;
      Dec(Width,BlockWidth);

      ExtractBlock();
      //IsAlphaBlock:=1;
      GetMinMaxColorIndex1();
      WriteColorBlock(OutDataMem);
      WriteColorMask(OutDataMem+4);

      Inc(InDataMem, BlockWidth*4);
      Inc(OutDataMem,$08);
    end; // for x
    Inc(InDataMem, ScanLineSize*3);
  end; // for y
end;

end.
