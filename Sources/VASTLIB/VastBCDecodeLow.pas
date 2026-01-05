unit VastBCDecodeLow;

interface

uses
  VastImage,VastImageTypes,VastMemory,ProcTimer,VastBCTablesLow;

function BCXGeneratePreview(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
function BCXDecode(var InImage:PVastImage;var OutImage:PVastImage):Boolean; // decode all
function BC1Decode(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
function BC2Decode(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
function BC3Decode(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
function BC4Decode(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
function BC5Decode(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
//function BC1DecodeASM(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
implementation

var
  Timer:TProcTimer;
  // Total 221184 Bytes = 216 Kb

procedure SaveTables();
var
  FFile:File of Byte;
begin
  //AssignFile(FFile, '
end;

(*
function BC1DecodeASM(var InImage:PVastImage;var OutImage:PVastImage):Boolean;assembler;
var
  dwInDataMem:DWORD;
  dwOutDataMem:DWORD;

  OutScanLineMem:DWORD;
  InScanLineMem:DWORD;
  PrevScanLineMem:DWORD;

  ScanLineSize:DWORD;

  XBlockIndex:DWORD;
  YBlockIndex:DWORD;
  XBlockCount:DWORD;
  YBlockCount:DWORD;

  IndexTableBlockB:BYTE;

  PrevColorBlock:DWORD;
  PrevIndexBlock:DWORD;

  CopyColorBlock:BOOLEAN;

  //MinIndex:BYTE;
  //MaxIndex:BYTE;
  MinColor:WORD;
  MaxColor:WORD;

  ColorTable:Array[0..3] of Array[0..3] of BYTE;

asm
  //mov YBlockIndex,esp
  //pushad
  //push eax
  //push ebx
  //push ecx
  //push edx
  //push esi
  //push edi
  push ebx
  push esi
  push edi
  push ebp

  // EBX = InImage
  mov ebx,DWORD[eax]
  mov ecx,DWORD[edx]
  mov eax,ebx
  call IsImageSet
  cmp al,$00
  jz @exit

  // Width mod 16
  mov eax,DWORD[ebx+$0A]
  mov edx,eax
  shl edx,$02;
  mov ScanLineSize,edx;
  // Get XBlockCount
  mov edx,eax
  add edx,$03
  shr edx,$02
  //dec edx // Decrease for loop
  mov XBlockCount,edx
  // Continue Width mod 16
  and al,$0F
  test al,al
  jnz @exit

  // Height mod 16
  mov eax,DWORD[ebx+$0E]
  // Get YBlockCount
  mov edx,eax
  add edx,$03
  shr edx,$02
  //dec edx // Decrease for loop
  mov YBlockCount,edx
  // Continue Height mod 16
  and al,$0F
  test al,al
  jnz @exit

  // ECX = OutImage
  // Pixel Format
  mov WORD[ecx],$005C  // OutImage
  // Width
  mov eax,DWORD[ebx+$0A] // InImage
  mov DWORD[ecx+$0A],eax // OutImage
  // Height
  mov edx,DWORD[ebx+$0E] // InImage
  mov DWORD[ecx+$0E],edx // OutImage
  // Width * Height * 4
  mul edx
  shl eax,2
  mov DWORD[ecx+$06],eax  // OutImage
  // Pixel Size  = 32
  mov DWORD[ecx+$12],$20  // OutImage
  //push ebx
  //cmp DWORD[ebx+$02],$00
  //jnz @SkipMemAlloc
   push ecx
   call System.@GetMem
   test eax,eax
   pop ecx
  //@SkipMemAlloc:
  //pop ebx
  jz @exit
  mov DWORD[ecx+$02],eax
  mov edi,eax
  mov esi,DWORD[ebx+$02]

  mov PrevColorBlock,$00;
  mov PrevIndexBlock,$00;

  mov XBlockIndex,esp

  mov eax,XBlockCount
  mov ebx,YBlockCount
  @YBlockIndex:
    push eax
    mov ebx,XBlockCount
    @XBlockIndex:
      push ebx
      mov CopyColorBlock,$00
      // if PrevColorBlock = Current
      mov eax,PrevColorBlock
      cmp eax,DWORD[esi]
      jnz @DecodeColors
        mov eax,PrevIndexBlock
        cmp eax,DWORD[esi+$04]
        // if PrevIndexBlock = Current
        jnz @SetPrevIndexBlock
        mov CopyColorBlock,$01
        jmp @DecodeBlock
        // else
        @SetPrevIndexBlock:
        mov eax,DWORD[esi+$04]
        mov PrevIndexBlock,eax
        jmp @DecodeBlock
      // else
      @DecodeColors:
      // PrevColorBlock
      mov eax,DWORD[esi]
      mov PrevColorBlock,eax
      // PrevIndexBlock
      mov eax,DWORD[esi+$04]
      mov PrevIndexBlock,eax

    //======================
    // Decode RED component
      //lea edx,BCRIndexTable

      // EAX = BCRIndexTable[MinColor]
      //xor ecx,ecx
      movzx eax,WORD[esi]
      //add ecx,edx
      //xor eax,eax
      movzx eax,BYTE[BCRIndexTable+eax]

      // EBX = BCRIndexTable[MaxColor]
      //xor ebx,ebx
      movzx ebx,WORD[esi+$02]
      //add edx,ebx
      //xor ebx,ebx
      movzx ebx,BYTE[BCRIndexTable+ebx]

      // (BCRIndexTable[MinColor] * 32 * 4) + (BCRIndexTable[MaxColor] * 4)
      //mov cl,$80
      //mul cl
      shl eax,$07 // = EAX * 128

      //mov edx,eax
      //mov eax,ebx
      //mov cl,$04
      //mul cl
      shl ebx,$02 // = EBX * 4

      add eax,ebx
      lea ebx,BCRColorTable
      add eax,ebx
      // Copy decoded colors to ColorTable
      //lea ebx,ColorTable
      mov cl,BYTE[eax]
      mov BYTE[ColorTable],cl
      //add ebx,$04
      mov cl,BYTE[eax+$01]
      mov BYTE[ColorTable+$04],cl
      //add ebx,$04
      mov cl,BYTE[eax+$02]
      mov BYTE[ColorTable+$08],cl
      //add ebx,$04
      mov cl,BYTE[eax+$03]
      mov BYTE[ColorTable+$0C],cl
    // Decode RED component
    //======================

    //======================
    // Decode GREEN component
      //lea edx,BCGIndexTable

      // EAX = BCGIndexTable[MinColor]
      //xor ecx,ecx
      movzx eax,WORD[esi]
      //add ecx,edx
      //xor eax,eax
      movzx eax,BYTE[BCGIndexTable+eax]

      // EBX = BCGIndexTable[MaxColor]
      //xor ebx,ebx
      movzx ebx,WORD[esi+$02]
      //add edx,ebx
      //xor ebx,ebx
      movzx ebx,BYTE[BCGIndexTable+ebx]

      // (BCRIndexTable[MinColor] * 32 * 4) + (BCRIndexTable[MaxColor] * 4)
      //mov cx,$0100
      //mul cx
      shl eax,$08 // = EAX * 64
      //mov edx,eax
      //mov eax,ebx
      //mov cl,$04
      //mul cl
      shl ebx,$02 // = EDX * 4

      add eax,ebx
      lea ebx,BCGColorTable
      add eax,ebx
      // Copy decoded colors to ColorTable
      //lea ebx,ColorTable
      //inc ebx  // Seek to next color
      mov cl,BYTE[eax]
      mov BYTE[ColorTable+$01],cl
      //add ebx,$04
      mov cl,BYTE[eax+$01]
      mov BYTE[ColorTable+$05],cl
      //add ebx,$04
      mov cl,BYTE[eax+$02]
      mov BYTE[ColorTable+$09],cl
      //add ebx,$04
      mov cl,BYTE[eax+$03]
      mov BYTE[ColorTable+$0D],cl
     // Decode GREEN component
     //======================

     //======================
      // Decode BLUE component
      //lea edx,BCBIndexTable

      // EAX = BCRIndexTable[MinColor]
      //xor ecx,ecx
      movzx eax,WORD[esi]
      //add ecx,edx
      //xor eax,eax
      movzx eax,BYTE[BCBIndexTable+eax]

      // EBX = BCRIndexTable[MaxColor]
      //xor ebx,ebx
      movzx ebx,WORD[esi+$02]
      //add edx,ebx
      //xor ebx,ebx
      movzx ebx,BYTE[BCBIndexTable+ebx]

      // (BCRIndexTable[MinColor] * 32 * 4) + (BCRIndexTable[MaxColor] * 4)
      //mov cl,$80
      //mul cl
      shl eax,$07 // = EAX * 128

      //mov edx,eax
      //mov eax,ebx
      //mov cl,$04
      //mul cl
      shl ebx,$02 // = EBX * 4

      add eax,ebx
      lea ebx,BCBColorTable
      add eax,ebx
      // Copy decoded colors to ColorTable
      //lea ebx,ColorTable
      //add ebx,$02
      mov cl,BYTE[eax]
      mov BYTE[ColorTable+$02],cl
      //add ebx,$04
      mov cl,BYTE[eax+$01]
      mov BYTE[ColorTable+$06],cl
      //add ebx,$04
      mov cl,BYTE[eax+$02]
      mov BYTE[ColorTable+$0A],cl
      //add ebx,$04
      mov cl,BYTE[eax+$03]
      mov BYTE[ColorTable+$0E],cl
     // Decode BLUE component
     //======================

    @DecodeBlock:
      // BCIndex2Table[IndexTableBlockB][0]
      add esi,$04
      //mov OutScanLineMem,edi
      //mov eax,$00
      xor eax,eax
      //mov OutScanLineMem,edi
      push edi
      @ScanLineY:
        //mov OutScanLineMem,edi
        push eax
        //xor eax,eax
        // EAX = IndexTableBlockB
        movzx eax,BYTE[esi]
        inc esi
        shl eax,$02
        lea ecx,BCIndex2Table
        add eax,ecx
        //  EAX = @BCIndex2Table[IndexTableBlockB][0]
        //mov ebx,$00
        xor ebx,ebx
        @ScanLineX:
          //push ebx
          //xor ecx,ecx
          movzx ecx,BYTE[eax]
          shl ecx,$02
          lea edx,ColorTable
          add ecx,edx
          // ECX = ColorTable[BCIndex2Table[IndexTableBlockB][0]]
          mov edx,DWORD[ecx]
          //mov ecx,OutScanLineMem
          //shl ebx,$02
          //add ecx,ebx
          mov DWORD[edi+ebx*4],edx
          inc eax
          // EAX = BCIndex2Table[IndexTableBlockB][1]
        // Check ebx = 4
        //pop ebx
        inc ebx
        cmp ebx,$04
        jnz @ScanLineX
      // inc(OutScanLineMem,ScanLineSize);
      //pop eax
      //cmp eax,$03
      //jz @SkipIncY
       //mov ecx,OutScanLineMem
       //add ecx,ScanLineSize
       //mov OutScanLineMem,ecx
      add edi,ScanLineSize
      //@SkipIncY:
      // Check eax = 4
      pop eax
      inc eax
      cmp eax,$04
      jnz @ScanLineY
    //inc(dwInDataMem,8);
    //inc(dwOutDataMem,16);

    sub edi,ScanLineSize
    mov eax,edi
    pop edi
    add edi,$10
    //sub edi,ScanLineSize
    pop ebx
    dec ebx
    //test ebx,ebx
    cmp ebx,$00
    jnz @XBlockIndex
  //dwOutDataMem:=OutScanLineMem + 16;
  //mov edi,OutScanLineMem
  mov edi,eax
  //sub edi,ScanLineSize
  add edi,$10
  //mov OutScanLineMem,edi

  pop eax
  dec eax
  //test eax,eax
  cmp eax,$00
  jnz @YBlockIndex
  //popad
  add esp,$30
  pop ebp
  pop edi
  pop esi
  pop ebx
  ret
  //cmp esp,YBlockIndex
  //jnz @exit

  //popa
  //pop edi
  //pop esi
  //pop edx
  //pop ecx
  //pop ebx
  //pop eax
  //mov Result,$01
  //ret
  @exit:
  popa
  mov Result,$00;
  ret;
end;
*)



function BCXGeneratePreview(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
var
  InDataMem:DWORD;
  OutDataMem:DWORD;

  XPos:DWORD;
  YPos:DWORD;
  //XMaxPos:DWORD;
  //YMaxPos:DWORD;
  PixelPos:DWORD;
  PixelSize:DWORD;
  Width:DWORD;
  Height:DWORD;
  XBlockSkip:DWORD;
  YBlockSkip:DWORD;
  //bRChan:BYTE;
  //bGChan:BYTE;
  //bBChan:BYTE;
begin
  Result:=False;
  if not IsImageSet(InImage) then
  Exit;

  if (InImage^.Width < 64) or (InImage^.Height < 64) then
  Exit;

  // Create new Image
  if not InitImage(OutImage) then
  Exit;

  //XMaxPos:=InImage^.Width shr 2;
  //YMaxPos:=InImage^.Height shr 2;

  Width:=AlignImageDim(InImage^.Width,4) shr 2;
  Height:=AlignImageDim(InImage^.Height,4) shr 2;
  XBlockSkip:=(AlignImageDim(InImage^.Width,4) div Width) shl 1;
  YBlockSkip:=((AlignImageDim(InImage^.Height,4) div Height) - 4) * (AlignImageDim(InImage^.Height,4) shr 1);
  //YBlockSkip:=InImage^.Height * 2;

  // Copy image input image information to output image
  OutImage^.PixelFormat:=PIXEL_FORMAT_R8G8B8;
  OutImage^.Size:=(Width * Height) * 3;
  OutImage^.Width:=Width;
  OutImage^.Height:=Height;
  OutImage^.PixelSize:=24;
  // Alocate target image data memory
  //GetMem(OutImage^.mData,OutImage^.dwSize);
  if not mAllocMem(OutImage^.Data, OutImage^.Size) then
  begin
    FreeImage(OutImage);
    Exit;
  end;

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);
  // Get increment for XY coors,by doing this we increase a input memory pointer without using later multiplications
  // HINT: Whole function using only 3 multiplications and 3 divisions...
  //XSkip:=((InImage^.Width div Width) - 1) * PixelSize; // Rounded X scale factor * PixelSize
  //YSkip:=((InImage^.Height div Height) - 1) * (InImage^.Width * PixelSize); // Rounded Y scale factor * BytesPerLine
  StartTimer(Timer);
  for YPos:=0 to Height - 1 do
  begin
    for XPos:=0 to Width - 1 do
    begin
      if PWORD(InDataMem+$00)^ > PWORD(InDataMem+$02)^ then
      begin
        // Without alpha
        case PBYTE(InDataMem+$04)^ and $03 of
          $00: //PWORD(OutDataMem)^:= PWORD(InDataMem+$00)^;
          begin
            PBYTE(OutDataMem+$00)^:=(PWORD(InDataMem+$00)^ and $001F) shl 3;
            PBYTE(OutDataMem+$01)^:=(PWORD(InDataMem+$00)^ and $07E0) shr 3;
            PBYTE(OutDataMem+$02)^:=(PWORD(InDataMem+$00)^ and $F800) shr 8;
          end;
          $01: //PWORD(OutDataMem)^:= PWORD(InDataMem+$02)^;
          begin
            PBYTE(OutDataMem+$00)^:=(PWORD(InDataMem+$02)^ and $001F) shl 3;
            PBYTE(OutDataMem+$01)^:=(PWORD(InDataMem+$02)^ and $07E0) shr 3;
            PBYTE(OutDataMem+$02)^:=(PWORD(InDataMem+$02)^ and $F800) shr 8;
          end;
          $02:
          begin
            PBYTE(OutDataMem+$00)^:=(((PWORD(InDataMem+$00)^ and $001F) shl 4) + ((PWORD(InDataMem+$02)^ and $001F) shl 3)) div 3;
            PBYTE(OutDataMem+$01)^:=(((PWORD(InDataMem+$00)^ and $07E0) shr 2) + ((PWORD(InDataMem+$02)^ and $07E0) shr 3)) div 3;
            PBYTE(OutDataMem+$02)^:=(((PWORD(InDataMem+$00)^ and $F800) shr 7) + ((PWORD(InDataMem+$02)^ and $F800) shr 8)) div 3;
          end;
          $03:
          begin
            PBYTE(OutDataMem+$00)^:=(((PWORD(InDataMem+$00)^ and $001F) shl 3) + ((PWORD(InDataMem+$02)^ and $001F) shl 4)) div 3;
            PBYTE(OutDataMem+$01)^:=(((PWORD(InDataMem+$00)^ and $07E0) shr 3) + ((PWORD(InDataMem+$02)^ and $07E0) shr 2)) div 3;
            PBYTE(OutDataMem+$02)^:=(((PWORD(InDataMem+$00)^ and $F800) shr 8) + ((PWORD(InDataMem+$02)^ and $F800) shr 7)) div 3;
          end;
        end; // case end
      end // if
        else
      begin
        // With alpha
        case PBYTE(InDataMem+$04)^ and $03 of
          $00: //PWORD(OutDataMem)^:= PWORD(InDataMem+$00)^;
          begin
            PBYTE(OutDataMem+$00)^:=(PWORD(InDataMem+$00)^ and $001F) shl 3;
            PBYTE(OutDataMem+$01)^:=(PWORD(InDataMem+$00)^ and $07E0) shr 3;
            PBYTE(OutDataMem+$02)^:=(PWORD(InDataMem+$00)^ and $F800) shr 8;
          end;
          $01: //PWORD(OutDataMem)^:= PWORD(InDataMem+$02)^;
          begin
            PBYTE(OutDataMem+$00)^:=(PWORD(InDataMem+$02)^ and $001F) shl 3;
            PBYTE(OutDataMem+$01)^:=(PWORD(InDataMem+$02)^ and $07E0) shr 3;
            PBYTE(OutDataMem+$02)^:=(PWORD(InDataMem+$02)^ and $F800) shr 8;
          end;
          $02:
          begin
            PBYTE(OutDataMem+$00)^:=(((PWORD(InDataMem+$00)^ and $001F) shl 3) + ((PWORD(InDataMem+$02)^ and $001F) shl 3)) div 2;
            PBYTE(OutDataMem+$01)^:=(((PWORD(InDataMem+$00)^ and $07E0) shr 3) + ((PWORD(InDataMem+$02)^ and $07E0) shr 3)) div 2;
            PBYTE(OutDataMem+$02)^:=(((PWORD(InDataMem+$00)^ and $F800) shr 8) + ((PWORD(InDataMem+$02)^ and $F800) shr 8)) div 2;
          end;
          $03:
          begin
            PBYTE(OutDataMem+$00)^:=$00;
            PBYTE(OutDataMem+$01)^:=$00;
            PBYTE(OutDataMem+$02)^:=$00;
          end;
        end; // case
      end; // else
      inc(InDataMem,XBlockSkip);
      inc(OutDataMem,3);
    end; // for
    inc(InDataMem,YBlockSkip);
  end; // for
  StopTimer(Timer);
  ShowTimer(Timer);
end;

function BCXDecode(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
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

  IndexTableBlockB:BYTE;
  BCBlockSize:BYTE;
  PrevColorBlock:DWORD;
  PrevIndexBlock:DWORD;

  CopyColorBlock:BOOLEAN;

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
  if not InitImage(OutImage) then
  Exit;

  // Copy image input image information to output image
  OutImage^.PixelFormat:=PIXEL_FORMAT_R8G8B8A8;
  OutImage^.Size:=(InImage^.Width * InImage^.Height) * 4;
  OutImage^.Width:=InImage^.Width;
  OutImage^.Height:=InImage^.Height;
  OutImage^.PixelSize:=32;

  if not mAllocMem(OutImage^.Data,OutImage^.Size) then
  begin
    FreeImage(OutImage);
    Exit;
  end;

  // set required varibles for loops
  case InImage^.PixelFormat of
    PIXEL_FORMAT_BC1:
    begin
      InDataMem:=DWORD(InImage^.Data);
      BCBlockSize:=8;
    end;
    PIXEL_FORMAT_BC2:
    begin
      InDataMem:=DWORD(InImage^.Data)+8;
      BCBlockSize:=16;
    end;
    PIXEL_FORMAT_BC3:
    begin
      InDataMem:=DWORD(InImage^.Data)+8;
      BCBlockSize:=16;
    end;
    PIXEL_FORMAT_BC4:
    begin
      InDataMem:=DWORD(InImage^.Data);
      BCBlockSize:=8;
    end;
    PIXEL_FORMAT_BC5:
    begin
      InDataMem:=DWORD(InImage^.Data) + 8;
      BCBlockSize:=16;
    end;
  end;

  // Alocate target image data memory
  //if OutImage^.mData = nil then
  //GetMem(OutImage^.mData,OutImage^.dwSize);
  //if 1 > 2 then
  //Exit;

  OutDataMem:=DWORD(OutImage^.Data);
  ScanLineSize:=InImage^.Width * 4;
  XBlockCount:=AlignImageDim(InImage^.Width,4) shr 2;
  YBlockCount:=AlignImageDim(InImage^.Height,4) shr 2;
  //dwBlocksDuplicated:=0;
  PrevColorBlock:=0;
  PrevIndexBlock:=0;
  //StartTimer(Timer);

  for YBlockIndex:=0 to YBlockCount - 1 do
  begin
    for XBlockIndex:=0 to XBlockCount - 1 do
    begin
      CopyColorBlock:=False;
      if PrevColorBlock = PDWORD(InDataMem+$00)^ then
      begin
        // We found that previous colors in block are same as current block so we check if current
        // block have same color indexes ,if yes then we
        if PrevIndexBlock = PDWORD(InDataMem+$04)^ then
        CopyColorBlock:=True else PrevIndexBlock:=PDWORD(InDataMem+$04)^
      end
        else
      begin
        PrevColorBlock:=PDWORD(InDataMem+$00)^;
        PrevIndexBlock:=PDWORD(InDataMem+$04)^;

        MinColor:=PWORD(InDataMem+$00)^;
        MaxColor:=PWORD(InDataMem+$02)^;

        // Red
        ColorTable[0][0]:=BCRColorTable[BCRIndexTable[MinColor]][BCRIndexTable[MaxColor]][0];
        ColorTable[1][0]:=BCRColorTable[BCRIndexTable[MinColor]][BCRIndexTable[MaxColor]][1];
        ColorTable[2][0]:=BCRColorTable[BCRIndexTable[MinColor]][BCRIndexTable[MaxColor]][2];
        ColorTable[3][0]:=BCRColorTable[BCRIndexTable[MinColor]][BCRIndexTable[MaxColor]][3];

        // Green
        ColorTable[0][1]:=BCGColorTable[BCGIndexTable[MinColor]][BCGIndexTable[MaxColor]][0];
        ColorTable[1][1]:=BCGColorTable[BCGIndexTable[MinColor]][BCGIndexTable[MaxColor]][1];
        ColorTable[2][1]:=BCGColorTable[BCGIndexTable[MinColor]][BCGIndexTable[MaxColor]][2];
        ColorTable[3][1]:=BCGColorTable[BCGIndexTable[MinColor]][BCGIndexTable[MaxColor]][3];

        // Blue
        ColorTable[0][2]:=BCBColorTable[BCBIndexTable[MinColor]][BCBIndexTable[MaxColor]][0];
        ColorTable[1][2]:=BCBColorTable[BCBIndexTable[MinColor]][BCBIndexTable[MaxColor]][1];
        ColorTable[2][2]:=BCBColorTable[BCBIndexTable[MinColor]][BCBIndexTable[MaxColor]][2];
        ColorTable[3][2]:=BCBColorTable[BCBIndexTable[MinColor]][BCBIndexTable[MaxColor]][3];
      end; // if
      //CopyColorBlock:=False;
      if CopyColorBlock then
      begin
        InScanLineMem:=PrevScanLineMem;
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
        PrevScanLineMem:=OutDataMem;
        OutScanLineMem:=OutDataMem;

        IndexTableBlockB:=PBYTE(InDataMem+$04)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][3]])^;
        inc(OutScanLineMem,ScanLineSize);

        IndexTableBlockB:=PBYTE(InDataMem+$05)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][3]])^;
        inc(OutScanLineMem,ScanLineSize);

        IndexTableBlockB:=PBYTE(InDataMem+$06)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][3]])^;
        inc(OutScanLineMem,ScanLineSize);

        IndexTableBlockB:=PBYTE(InDataMem+$07)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][3]])^;
      end; // else
      inc(InDataMem,BCBlockSize);
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

function BC1Decode(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
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

  XSkip:DWORD;
  YSkip:DWORD;
  
  IndexTableBlockB:BYTE;

  PrevColorBlock:DWORD;
  PrevIndexBlock:DWORD;

  CopyColorBlock:BOOLEAN;

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
  //if OutImage^.mData = nil then
  //GetMem(OutImage^.mData,OutImage^.dwSize);
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
  PrevIndexBlock:=0;
  //StartTimer(Timer);
  for YBlockIndex:=0 to YBlockCount - 1 do
  begin
    for XBlockIndex:=0 to XBlockCount - 1 do
    begin
      CopyColorBlock:=False;
      if PrevColorBlock = PDWORD(InDataMem+$00)^ then
      begin
        // We found that previous colors in block are same as current block so we check if current
        // block have same color indexes ,if yes then we
        if PrevIndexBlock = PDWORD(InDataMem+$04)^ then
        CopyColorBlock:=True else PrevIndexBlock:=PDWORD(InDataMem+$04)^
      end
        else
      begin
        PrevColorBlock:=PDWORD(InDataMem+$00)^;
        PrevIndexBlock:=PDWORD(InDataMem+$04)^;

        MinColor:=PWORD(InDataMem+$00)^;
        MaxColor:=PWORD(InDataMem+$02)^;

        if MinColor > MaxColor then
        begin
          // Without alpha channel

          // Red
          MinIndex:=BCRIndexTable[MinColor];
          MaxIndex:=BCRIndexTable[MaxColor];
          ColorTable[0][0]:=BCRColorTable[MinIndex][MaxIndex][0];
          ColorTable[1][0]:=BCRColorTable[MinIndex][MaxIndex][1];
          ColorTable[2][0]:=BCRColorTable[MinIndex][MaxIndex][2];
          ColorTable[3][0]:=BCRColorTable[MinIndex][MaxIndex][3];

          // Green
          MinIndex:=BCGIndexTable[MinColor];
          MaxIndex:=BCGIndexTable[MaxColor];
          ColorTable[0][1]:=BCGColorTable[MinIndex][MaxIndex][0];
          ColorTable[1][1]:=BCGColorTable[MinIndex][MaxIndex][1];
          ColorTable[2][1]:=BCGColorTable[MinIndex][MaxIndex][2];
          ColorTable[3][1]:=BCGColorTable[MinIndex][MaxIndex][3];

          // Blue
          MinIndex:=BCBIndexTable[MinColor];
          MaxIndex:=BCBIndexTable[MaxColor];
          ColorTable[0][2]:=BCBColorTable[MinIndex][MaxIndex][0];
          ColorTable[1][2]:=BCBColorTable[MinIndex][MaxIndex][1];
          ColorTable[2][2]:=BCBColorTable[MinIndex][MaxIndex][2];
          ColorTable[3][2]:=BCBColorTable[MinIndex][MaxIndex][3];

          // Alpha
          ColorTable[0][3]:=$FF;
          ColorTable[1][3]:=$FF;
          ColorTable[2][3]:=$FF;
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

          //ColorTable[3][0]:=((ColorTable[1][0] shl 1) + ColorTable[0][0]) div 3;
          //ColorTable[3][1]:=((ColorTable[1][1] shl 1) + ColorTable[0][1]) div 3;
          //ColorTable[3][2]:=((ColorTable[1][2] shl 1) + ColorTable[0][2]) div 3;
          ColorTable[3][0]:=$00;
          ColorTable[3][1]:=$00;
          ColorTable[3][2]:=$00;
          ColorTable[3][3]:=$00;
        end; // else
      end; // if

      if CopyColorBlock then
      begin
        InScanLineMem:=PrevScanLineMem;
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
        PrevScanLineMem:=OutDataMem;
        OutScanLineMem:=OutDataMem;

        IndexTableBlockB:=PBYTE(InDataMem+$04)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][3]])^;
        inc(OutScanLineMem,ScanLineSize);

        IndexTableBlockB:=PBYTE(InDataMem+$05)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][3]])^;
        inc(OutScanLineMem,ScanLineSize);

        IndexTableBlockB:=PBYTE(InDataMem+$06)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][3]])^;
        inc(OutScanLineMem,ScanLineSize);

        IndexTableBlockB:=PBYTE(InDataMem+$07)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][3]])^;
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

function BC2Decode(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
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

  IndexTableBlockB:BYTE;

  PrevAlphaBlock:QWORD;
  PrevColorBlock:DWORD;
  PrevIndexBlock:DWORD;

  CopyAlphaBlock:BOOLEAN;
  CopyColorBlock:BOOLEAN;

  MinIndex:BYTE;
  MaxIndex:BYTE;
  MinColor:WORD;
  MaxColor:WORD;

  ColorTable:Array[0..3] of Array[0..3] of BYTE;
begin
  Result:=False;
  if not IsImageSet(InImage) then
  Exit;

  if ((InImage^.Width mod 16) > 0) or ((InImage^.Height mod 16) > 0) then
  Exit;

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
  //if OutImage^.mData = nil then
  //GetMem(OutImage^.mData,OutImage^.dwSize);
  if not mAllocMem(OutImage^.Data,OutImage^.Size) then
  begin
    FreeImage(OutImage);
    Exit;
  end;

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);

  //GetMem(POINTER(dwColorTableMem),16);

  ScanLineSize:=InImage^.Width * 4;
  XBlockCount:=(InImage^.Width + 3) shr 2;
  YBlockCount:=(InImage^.Height + 3) shr 2;
  //dwBlocksDuplicated:=0;
  PrevAlphaBlock:=0;
  PrevColorBlock:=0;
  PrevIndexBlock:=0;
  //StartTimer(Timer);
  // 628 602 613 634
  // 599 595 603 595
  // 601 593 609 597
  // 626 624 597 607
  for YBlockIndex:=0 to YBlockCount - 1 do
  begin
    for XBlockIndex:=0 to XBlockCount - 1 do
    begin
      //CopyAlphaBlock:=False;
      //if PrevAlphaBlock = PQWORD(InDataMem+$00)^ then
      //CopyAlphaBlock:=True;

      CopyColorBlock:=False;
      if PrevColorBlock = PDWORD(InDataMem+$08)^ then
      begin
        // We found that previous colors in block are same as current block so we check if current
        // block have same color indexes ,if yes then we
        if PrevIndexBlock = PDWORD(InDataMem+$0C)^ then
        CopyColorBlock:=True else PrevIndexBlock:=PDWORD(InDataMem+$0C)^
      end
        else
      begin
        PrevColorBlock:=PDWORD(InDataMem+$08)^;
        PrevIndexBlock:=PDWORD(InDataMem+$0C)^;

        MinColor:=PWORD(InDataMem+$08)^;
        MaxColor:=PWORD(InDataMem+$0A)^;

        // Red
        ColorTable[0][0]:=BCRColorTable[BCRIndexTable[MinColor]][BCRIndexTable[MaxColor]][0];
        ColorTable[1][0]:=BCRColorTable[BCRIndexTable[MinColor]][BCRIndexTable[MaxColor]][1];
        ColorTable[2][0]:=BCRColorTable[BCRIndexTable[MinColor]][BCRIndexTable[MaxColor]][2];
        ColorTable[3][0]:=BCRColorTable[BCRIndexTable[MinColor]][BCRIndexTable[MaxColor]][3];

        // Green
        ColorTable[0][1]:=BCGColorTable[BCGIndexTable[MinColor]][BCGIndexTable[MaxColor]][0];
        ColorTable[1][1]:=BCGColorTable[BCGIndexTable[MinColor]][BCGIndexTable[MaxColor]][1];
        ColorTable[2][1]:=BCGColorTable[BCGIndexTable[MinColor]][BCGIndexTable[MaxColor]][2];
        ColorTable[3][1]:=BCGColorTable[BCGIndexTable[MinColor]][BCGIndexTable[MaxColor]][3];

        // Blue
        ColorTable[0][2]:=BCBColorTable[BCBIndexTable[MinColor]][BCBIndexTable[MaxColor]][0];
        ColorTable[1][2]:=BCBColorTable[BCBIndexTable[MinColor]][BCBIndexTable[MaxColor]][1];
        ColorTable[2][2]:=BCBColorTable[BCBIndexTable[MinColor]][BCBIndexTable[MaxColor]][2];
        ColorTable[3][2]:=BCBColorTable[BCBIndexTable[MinColor]][BCBIndexTable[MaxColor]][3];
      end; // if

      if CopyColorBlock then
      begin
        InScanLineMem:=PrevScanLineMem;
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
        PrevScanLineMem:=OutDataMem;
        OutScanLineMem:=OutDataMem;

        // Scaline 1
        IndexTableBlockB:=PBYTE(InDataMem+$0C)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][3]])^;
        inc(OutScanLineMem,ScanLineSize);

        // Scanline 2
        IndexTableBlockB:=PBYTE(InDataMem+$0D)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][3]])^;
        inc(OutScanLineMem,ScanLineSize);

        // Scanline 3
        IndexTableBlockB:=PBYTE(InDataMem+$0E)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][3]])^;
        inc(OutScanLineMem,ScanLineSize);

        // Scanline 4
        IndexTableBlockB:=PBYTE(InDataMem+$0F)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][3]])^;

        //if CopyAlphaBlock then
        //CopyAlphaBlock:=False;
      end; // else

      if (not CopyAlphaBlock) or (not CopyColorBlock) then
      begin
        //PrevScanLineMem:=OutDataMem;
        OutScanLineMem:=OutDataMem;
        // ScanLine 1
        PBYTE(OutScanLineMem+$03)^:=BC2Alpha4Table[PBYTE(InDataMem+$00)^][0];
        PBYTE(OutScanLineMem+$07)^:=BC2Alpha4Table[PBYTE(InDataMem+$00)^][1];
        PBYTE(OutScanLineMem+$0B)^:=BC2Alpha4Table[PBYTE(InDataMem+$01)^][0];
        PBYTE(OutScanLineMem+$0F)^:=BC2Alpha4Table[PBYTE(InDataMem+$01)^][1];
        inc(OutScanLineMem,ScanLineSize);
        // ScanLine 2
        PBYTE(OutScanLineMem+$03)^:=BC2Alpha4Table[PBYTE(InDataMem+$02)^][0];
        PBYTE(OutScanLineMem+$07)^:=BC2Alpha4Table[PBYTE(InDataMem+$02)^][1];
        PBYTE(OutScanLineMem+$0B)^:=BC2Alpha4Table[PBYTE(InDataMem+$03)^][0];
        PBYTE(OutScanLineMem+$0F)^:=BC2Alpha4Table[PBYTE(InDataMem+$03)^][1];
        inc(OutScanLineMem,ScanLineSize);
        // ScanLine 3
        PBYTE(OutScanLineMem+$03)^:=BC2Alpha4Table[PBYTE(InDataMem+$04)^][0];
        PBYTE(OutScanLineMem+$07)^:=BC2Alpha4Table[PBYTE(InDataMem+$04)^][1];
        PBYTE(OutScanLineMem+$0B)^:=BC2Alpha4Table[PBYTE(InDataMem+$05)^][0];
        PBYTE(OutScanLineMem+$0F)^:=BC2Alpha4Table[PBYTE(InDataMem+$05)^][1];
        inc(OutScanLineMem,ScanLineSize);
         // ScanLine 4
        PBYTE(OutScanLineMem+$03)^:=BC2Alpha4Table[PBYTE(InDataMem+$06)^][0];
        PBYTE(OutScanLineMem+$07)^:=BC2Alpha4Table[PBYTE(InDataMem+$06)^][1];
        PBYTE(OutScanLineMem+$0B)^:=BC2Alpha4Table[PBYTE(InDataMem+$07)^][0];
        PBYTE(OutScanLineMem+$0F)^:=BC2Alpha4Table[PBYTE(InDataMem+$07)^][1];
      end;

      inc(InDataMem,16);
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

function BC3Decode(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
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

  IndexTableBlockB:BYTE;
  IndexTableBlockW:WORD;
  IndexTableBlockL:DWORD;

  PrevAlphaBlock:QWORD;
  PrevColorBlock:DWORD;
  PrevIndexBlock:DWORD;

  CopyAlphaBlock:BOOLEAN;
  CopyColorBlock:BOOLEAN;

  MinColor:WORD;
  MaxColor:WORD;

  MinAlpha:BYTE;
  MaxAlpha:BYTE;

  ColorTable:Array[0..3] of Array[0..3] of BYTE;
  AlphaTable:Array[0..7] of BYTE;
begin
  Result:=False;
  if not IsImageSet(InImage) then
  Exit;

  if ((InImage^.Width mod 16) > 0) or ((InImage^.Height mod 16) > 0) then
  Exit;

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
  //if OutImage^.mData = nil then
  //GetMem(OutImage^.mData,OutImage^.dwSize);
  if OutImage^.Data = nil then
  begin
    if not mAllocMem(OutImage^.Data,OutImage^.Size) then
    begin
      FreeImage(OutImage);
      Exit;
    end;
  end;

  InDataMem:=DWORD(InImage^.Data);
  OutDataMem:=DWORD(OutImage^.Data);

  //GetMem(POINTER(dwColorTableMem),16);

  ScanLineSize:=InImage^.Width * 4;
  XBlockCount:=(InImage^.Width + 3) shr 2;
  YBlockCount:=(InImage^.Height + 3) shr 2;
  //dwBlocksDuplicated:=0;
  PrevAlphaBlock:=0;
  PrevColorBlock:=0;
  PrevIndexBlock:=0;
  //StartTimer(Timer);
  // 628 602 613 634
  // 599 595 603 595
  // 601 593 609 597
  // 626 624 597 607
  for YBlockIndex:=0 to YBlockCount - 1 do
  begin
    for XBlockIndex:=0 to XBlockCount - 1 do
    begin
      CopyAlphaBlock:=False;
      if WORD(PrevAlphaBlock) = PWORD(InDataMem+$00)^ then
      begin
        if PrevAlphaBlock = PQWORD(InDataMem+$00)^ then
        CopyAlphaBlock:=True else PrevAlphaBlock:=PQWORD(InDataMem+$00)^;
      end
        else
      begin
        PrevAlphaBlock:=PQWORD(InDataMem+$00)^;
        MinAlpha:=PBYTE(InDataMem+$00)^;
        MaxAlpha:=PBYTE(InDataMem+$01)^;
        if MinAlpha > MaxAlpha then
        begin
          // 8 bit alpha channel
          AlphaTable[0]:=MinAlpha;
          AlphaTable[1]:=MaxAlpha;
          AlphaTable[2]:=BC3Alpha6Table[MinAlpha][MaxAlpha][0];
          AlphaTable[3]:=BC3Alpha6Table[MinAlpha][MaxAlpha][1];
          AlphaTable[4]:=BC3Alpha6Table[MinAlpha][MaxAlpha][2];
          AlphaTable[5]:=BC3Alpha6Table[MinAlpha][MaxAlpha][3];
          AlphaTable[6]:=BC3Alpha6Table[MinAlpha][MaxAlpha][4];
          AlphaTable[7]:=BC3Alpha6Table[MinAlpha][MaxAlpha][5];
        end // if
          else
        begin
          // 6 bit alpha channel
          AlphaTable[0]:=MinAlpha;
          AlphaTable[1]:=MaxAlpha;
          AlphaTable[2]:=BC3Alpha4Table[MinAlpha][MaxAlpha][0];
          AlphaTable[3]:=BC3Alpha4Table[MinAlpha][MaxAlpha][1];
          AlphaTable[4]:=BC3Alpha4Table[MinAlpha][MaxAlpha][2];
          AlphaTable[5]:=BC3Alpha4Table[MinAlpha][MaxAlpha][3];
          AlphaTable[6]:=$00;
          AlphaTable[7]:=$FF;
        end; // else
      end; // else

      CopyColorBlock:=False;
      if PrevColorBlock = PDWORD(InDataMem+$08)^ then
      begin
        // We found that previous colors in block are same as current block so we check if current
        // block have same color indexes ,if yes then we
        if PrevIndexBlock = PDWORD(InDataMem+$0C)^ then
        CopyColorBlock:=True else PrevIndexBlock:=PDWORD(InDataMem+$0C)^
      end
        else
      begin
        PrevColorBlock:=PDWORD(InDataMem+$08)^;
        PrevIndexBlock:=PDWORD(InDataMem+$0C)^;

        MinColor:=PWORD(InDataMem+$08)^;
        MaxColor:=PWORD(InDataMem+$0A)^;

        // Red
        ColorTable[0][0]:=BCRColorTable[BCRIndexTable[MinColor]][BCRIndexTable[MaxColor]][0];
        ColorTable[1][0]:=BCRColorTable[BCRIndexTable[MinColor]][BCRIndexTable[MaxColor]][1];
        ColorTable[2][0]:=BCRColorTable[BCRIndexTable[MinColor]][BCRIndexTable[MaxColor]][2];
        ColorTable[3][0]:=BCRColorTable[BCRIndexTable[MinColor]][BCRIndexTable[MaxColor]][3];

        // Green
        ColorTable[0][1]:=BCGColorTable[BCGIndexTable[MinColor]][BCGIndexTable[MaxColor]][0];
        ColorTable[1][1]:=BCGColorTable[BCGIndexTable[MinColor]][BCGIndexTable[MaxColor]][1];
        ColorTable[2][1]:=BCGColorTable[BCGIndexTable[MinColor]][BCGIndexTable[MaxColor]][2];
        ColorTable[3][1]:=BCGColorTable[BCGIndexTable[MinColor]][BCGIndexTable[MaxColor]][3];

        // Blue
        ColorTable[0][2]:=BCBColorTable[BCBIndexTable[MinColor]][BCBIndexTable[MaxColor]][0];
        ColorTable[1][2]:=BCBColorTable[BCBIndexTable[MinColor]][BCBIndexTable[MaxColor]][1];
        ColorTable[2][2]:=BCBColorTable[BCBIndexTable[MinColor]][BCBIndexTable[MaxColor]][2];
        ColorTable[3][2]:=BCBColorTable[BCBIndexTable[MinColor]][BCBIndexTable[MaxColor]][3];
      end; // if

      if CopyColorBlock then
      begin
        InScanLineMem:=PrevScanLineMem;
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
        PrevScanLineMem:=OutDataMem;
        OutScanLineMem:=OutDataMem;

        // Scaline 1
        IndexTableBlockB:=PBYTE(InDataMem+$0C)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][3]])^;
        inc(OutScanLineMem,ScanLineSize);

        // Scanline 2
        IndexTableBlockB:=PBYTE(InDataMem+$0D)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][3]])^;
        inc(OutScanLineMem,ScanLineSize);

        // Scanline 3
        IndexTableBlockB:=PBYTE(InDataMem+$0E)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][3]])^;
        inc(OutScanLineMem,ScanLineSize);

        // Scanline 4
        IndexTableBlockB:=PBYTE(InDataMem+$0F)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][0]])^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][1]])^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][2]])^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(@ColorTable[BCIndex2Table[IndexTableBlockB][3]])^;

        //if CopyAlphaBlock then
        //CopyAlphaBlock:=False;
      end; // else

      if (not CopyAlphaBlock) or (not CopyColorBlock) then
      begin
        //PrevScanLineMem:=OutDataMem;
        OutScanLineMem:=OutDataMem;

        IndexTableBlockL:=PDWORD(InDataMem+$02)^ and $00FFFFFF;

        // ScanLine 1
        IndexTableBlockW:=IndexTableBlockL and $00000FFF;
        PBYTE(OutScanLineMem+$03)^:=AlphaTable[BCIndex3Table[IndexTableBlockW][0]];
        PBYTE(OutScanLineMem+$07)^:=AlphaTable[BCIndex3Table[IndexTableBlockW][1]];
        PBYTE(OutScanLineMem+$0B)^:=AlphaTable[BCIndex3Table[IndexTableBlockW][2]];
        PBYTE(OutScanLineMem+$0F)^:=AlphaTable[BCIndex3Table[IndexTableBlockW][3]];
        inc(OutScanLineMem,ScanLineSize);

        // ScanLine 2
        IndexTableBlockW:=IndexTableBlockL shr $0C;
        PBYTE(OutScanLineMem+$03)^:=AlphaTable[BCIndex3Table[IndexTableBlockW][0]];
        PBYTE(OutScanLineMem+$07)^:=AlphaTable[BCIndex3Table[IndexTableBlockW][1]];
        PBYTE(OutScanLineMem+$0B)^:=AlphaTable[BCIndex3Table[IndexTableBlockW][2]];
        PBYTE(OutScanLineMem+$0F)^:=AlphaTable[BCIndex3Table[IndexTableBlockW][3]];
        inc(OutScanLineMem,ScanLineSize);

        IndexTableBlockL:=PDWORD(InDataMem+$05)^ and $00FFFFFF;

        // ScanLine 3
        IndexTableBlockW:=IndexTableBlockL and $00000FFF;
        PBYTE(OutScanLineMem+$03)^:=AlphaTable[BCIndex3Table[IndexTableBlockW][0]];
        PBYTE(OutScanLineMem+$07)^:=AlphaTable[BCIndex3Table[IndexTableBlockW][1]];
        PBYTE(OutScanLineMem+$0B)^:=AlphaTable[BCIndex3Table[IndexTableBlockW][2]];
        PBYTE(OutScanLineMem+$0F)^:=AlphaTable[BCIndex3Table[IndexTableBlockW][3]];
        inc(OutScanLineMem,ScanLineSize);
         // ScanLine 4
        IndexTableBlockW:=IndexTableBlockL shr $0C;
        PBYTE(OutScanLineMem+$03)^:=AlphaTable[BCIndex3Table[IndexTableBlockW][0]];
        PBYTE(OutScanLineMem+$07)^:=AlphaTable[BCIndex3Table[IndexTableBlockW][1]];
        PBYTE(OutScanLineMem+$0B)^:=AlphaTable[BCIndex3Table[IndexTableBlockW][2]];
        PBYTE(OutScanLineMem+$0F)^:=AlphaTable[BCIndex3Table[IndexTableBlockW][3]];
      end;

      inc(InDataMem,16);
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

function BC4Decode(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
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

  IndexTableBlockL:DWORD;
  IndexTableBlockW:WORD;

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
          RedTable[2]:=BC3Alpha6Table[MinRed][MaxRed][0];
          RedTable[3]:=BC3Alpha6Table[MinRed][MaxRed][1];
          RedTable[4]:=BC3Alpha6Table[MinRed][MaxRed][2];
          RedTable[5]:=BC3Alpha6Table[MinRed][MaxRed][3];
          RedTable[6]:=BC3Alpha6Table[MinRed][MaxRed][4];
          RedTable[7]:=BC3Alpha6Table[MinRed][MaxRed][5];
        end // if
          else
        begin
          // 6 bit alpha channel
          RedTable[0]:=MinRed;
          RedTable[1]:=MaxRed;
          RedTable[2]:=BC3Alpha4Table[MinRed][MaxRed][0];
          RedTable[3]:=BC3Alpha4Table[MinRed][MaxRed][1];
          RedTable[4]:=BC3Alpha4Table[MinRed][MaxRed][2];
          RedTable[5]:=BC3Alpha4Table[MinRed][MaxRed][3];
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

        IndexTableBlockL:=PDWORD(InDataMem+$02)^ and $00FFFFFF;

        // ScanLine 1
        IndexTableBlockW:=IndexTableBlockL and $00000FFF;
        PBYTE(OutScanLineMem+$00)^:=RedTable[BCIndex3Table[IndexTableBlockW][0]];
        PBYTE(OutScanLineMem+$01)^:=RedTable[BCIndex3Table[IndexTableBlockW][1]];
        PBYTE(OutScanLineMem+$02)^:=RedTable[BCIndex3Table[IndexTableBlockW][2]];
        PBYTE(OutScanLineMem+$03)^:=RedTable[BCIndex3Table[IndexTableBlockW][3]];
        inc(OutScanLineMem,ScanLineSize);

        // ScanLine 2
        IndexTableBlockW:=IndexTableBlockL shr $0C;
        PBYTE(OutScanLineMem+$00)^:=RedTable[BCIndex3Table[IndexTableBlockW][0]];
        PBYTE(OutScanLineMem+$01)^:=RedTable[BCIndex3Table[IndexTableBlockW][1]];
        PBYTE(OutScanLineMem+$02)^:=RedTable[BCIndex3Table[IndexTableBlockW][2]];
        PBYTE(OutScanLineMem+$03)^:=RedTable[BCIndex3Table[IndexTableBlockW][3]];
        inc(OutScanLineMem,ScanLineSize);

        IndexTableBlockL:=PDWORD(InDataMem+$05)^ and $00FFFFFF;

        // ScanLine 3
        IndexTableBlockW:=IndexTableBlockL and $00000FFF;
        PBYTE(OutScanLineMem+$00)^:=RedTable[BCIndex3Table[IndexTableBlockW][0]];
        PBYTE(OutScanLineMem+$01)^:=RedTable[BCIndex3Table[IndexTableBlockW][1]];
        PBYTE(OutScanLineMem+$02)^:=RedTable[BCIndex3Table[IndexTableBlockW][2]];
        PBYTE(OutScanLineMem+$03)^:=RedTable[BCIndex3Table[IndexTableBlockW][3]];
        inc(OutScanLineMem,ScanLineSize);
         // ScanLine 4
        IndexTableBlockW:=IndexTableBlockL shr $0C;
        PBYTE(OutScanLineMem+$00)^:=RedTable[BCIndex3Table[IndexTableBlockW][0]];
        PBYTE(OutScanLineMem+$01)^:=RedTable[BCIndex3Table[IndexTableBlockW][1]];
        PBYTE(OutScanLineMem+$02)^:=RedTable[BCIndex3Table[IndexTableBlockW][2]];
        PBYTE(OutScanLineMem+$03)^:=RedTable[BCIndex3Table[IndexTableBlockW][3]];
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

function BC5Decode(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
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

  IndexTableBlockL:DWORD;
  IndexTableBlockW:WORD;

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
          RedTable[2]:=BC3Alpha6Table[MinRed][MaxRed][0];
          RedTable[3]:=BC3Alpha6Table[MinRed][MaxRed][1];
          RedTable[4]:=BC3Alpha6Table[MinRed][MaxRed][2];
          RedTable[5]:=BC3Alpha6Table[MinRed][MaxRed][3];
          RedTable[6]:=BC3Alpha6Table[MinRed][MaxRed][4];
          RedTable[7]:=BC3Alpha6Table[MinRed][MaxRed][5];
        end // if
          else
        begin
          // 6 bit alpha channel
          RedTable[0]:=MinRed;
          RedTable[1]:=MaxRed;
          RedTable[2]:=BC3Alpha4Table[MinRed][MaxRed][0];
          RedTable[3]:=BC3Alpha4Table[MinRed][MaxRed][1];
          RedTable[4]:=BC3Alpha4Table[MinRed][MaxRed][2];
          RedTable[5]:=BC3Alpha4Table[MinRed][MaxRed][3];
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
          GreenTable[2]:=BC3Alpha6Table[MinGreen][MaxGreen][0];
          GreenTable[3]:=BC3Alpha6Table[MinGreen][MaxGreen][1];
          GreenTable[4]:=BC3Alpha6Table[MinGreen][MaxGreen][2];
          GreenTable[5]:=BC3Alpha6Table[MinGreen][MaxGreen][3];
          GreenTable[6]:=BC3Alpha6Table[MinGreen][MaxGreen][4];
          GreenTable[7]:=BC3Alpha6Table[MinGreen][MaxGreen][5];
        end // if
          else
        begin
          // 6 bit alpha channel
          GreenTable[0]:=MinGreen;
          GreenTable[1]:=MaxGreen;
          GreenTable[2]:=BC3Alpha4Table[MinGreen][MaxGreen][0];
          GreenTable[3]:=BC3Alpha4Table[MinGreen][MaxGreen][1];
          GreenTable[4]:=BC3Alpha4Table[MinGreen][MaxGreen][2];
          GreenTable[5]:=BC3Alpha4Table[MinGreen][MaxGreen][3];
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

          IndexTableBlockL:=PDWORD(InDataMem+$02)^ and $00FFFFFF;

          // ScanLine 1
          IndexTableBlockW:=IndexTableBlockL and $00000FFF;
          PBYTE(OutScanLineMem+$00)^:=RedTable[BCIndex3Table[IndexTableBlockW][0]];
          PBYTE(OutScanLineMem+$02)^:=RedTable[BCIndex3Table[IndexTableBlockW][1]];
          PBYTE(OutScanLineMem+$04)^:=RedTable[BCIndex3Table[IndexTableBlockW][2]];
          PBYTE(OutScanLineMem+$06)^:=RedTable[BCIndex3Table[IndexTableBlockW][3]];
          inc(OutScanLineMem,ScanLineSize);

          // ScanLine 2
          IndexTableBlockW:=IndexTableBlockL shr $0C;
          PBYTE(OutScanLineMem+$00)^:=RedTable[BCIndex3Table[IndexTableBlockW][0]];
          PBYTE(OutScanLineMem+$02)^:=RedTable[BCIndex3Table[IndexTableBlockW][1]];
          PBYTE(OutScanLineMem+$04)^:=RedTable[BCIndex3Table[IndexTableBlockW][2]];
          PBYTE(OutScanLineMem+$06)^:=RedTable[BCIndex3Table[IndexTableBlockW][3]];
          inc(OutScanLineMem,ScanLineSize);

          IndexTableBlockL:=PDWORD(InDataMem+$05)^ and $00FFFFFF;

          // ScanLine 3
          IndexTableBlockW:=IndexTableBlockL and $00000FFF;
          PBYTE(OutScanLineMem+$00)^:=RedTable[BCIndex3Table[IndexTableBlockW][0]];
          PBYTE(OutScanLineMem+$02)^:=RedTable[BCIndex3Table[IndexTableBlockW][1]];
          PBYTE(OutScanLineMem+$04)^:=RedTable[BCIndex3Table[IndexTableBlockW][2]];
          PBYTE(OutScanLineMem+$06)^:=RedTable[BCIndex3Table[IndexTableBlockW][3]];
          inc(OutScanLineMem,ScanLineSize);
          // ScanLine 4
          IndexTableBlockW:=IndexTableBlockL shr $0C;
          PBYTE(OutScanLineMem+$00)^:=RedTable[BCIndex3Table[IndexTableBlockW][0]];
          PBYTE(OutScanLineMem+$02)^:=RedTable[BCIndex3Table[IndexTableBlockW][1]];
          PBYTE(OutScanLineMem+$04)^:=RedTable[BCIndex3Table[IndexTableBlockW][2]];
          PBYTE(OutScanLineMem+$06)^:=RedTable[BCIndex3Table[IndexTableBlockW][3]];
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

          IndexTableBlockL:=PDWORD(InDataMem+$0A)^ and $00FFFFFF;

          // ScanLine 1
          IndexTableBlockW:=IndexTableBlockL and $00000FFF;
          PBYTE(OutScanLineMem+$01)^:=GreenTable[BCIndex3Table[IndexTableBlockW][0]];
          PBYTE(OutScanLineMem+$03)^:=GreenTable[BCIndex3Table[IndexTableBlockW][1]];
          PBYTE(OutScanLineMem+$05)^:=GreenTable[BCIndex3Table[IndexTableBlockW][2]];
          PBYTE(OutScanLineMem+$07)^:=GreenTable[BCIndex3Table[IndexTableBlockW][3]];
          inc(OutScanLineMem,ScanLineSize);

          // ScanLine 2
          IndexTableBlockW:=IndexTableBlockL shr $0C;
          PBYTE(OutScanLineMem+$01)^:=GreenTable[BCIndex3Table[IndexTableBlockW][0]];
          PBYTE(OutScanLineMem+$03)^:=GreenTable[BCIndex3Table[IndexTableBlockW][1]];
          PBYTE(OutScanLineMem+$05)^:=GreenTable[BCIndex3Table[IndexTableBlockW][2]];
          PBYTE(OutScanLineMem+$07)^:=GreenTable[BCIndex3Table[IndexTableBlockW][3]];
          inc(OutScanLineMem,ScanLineSize);

          IndexTableBlockL:=PDWORD(InDataMem+$0D)^ and $00FFFFFF;

          // ScanLine 3
          IndexTableBlockW:=IndexTableBlockL and $00000FFF;
          PBYTE(OutScanLineMem+$01)^:=GreenTable[BCIndex3Table[IndexTableBlockW][0]];
          PBYTE(OutScanLineMem+$03)^:=GreenTable[BCIndex3Table[IndexTableBlockW][1]];
          PBYTE(OutScanLineMem+$05)^:=GreenTable[BCIndex3Table[IndexTableBlockW][2]];
          PBYTE(OutScanLineMem+$07)^:=GreenTable[BCIndex3Table[IndexTableBlockW][3]];
          inc(OutScanLineMem,ScanLineSize);
          // ScanLine 4
          IndexTableBlockW:=IndexTableBlockL shr $0C;
          PBYTE(OutScanLineMem+$01)^:=GreenTable[BCIndex3Table[IndexTableBlockW][0]];
          PBYTE(OutScanLineMem+$03)^:=GreenTable[BCIndex3Table[IndexTableBlockW][1]];
          PBYTE(OutScanLineMem+$05)^:=GreenTable[BCIndex3Table[IndexTableBlockW][2]];
          PBYTE(OutScanLineMem+$07)^:=GreenTable[BCIndex3Table[IndexTableBlockW][3]];
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
function BC2Decode(var InImage:PVastImage;var OutImage:PVastImage):Boolean;
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

  IndexTableBlockB:BYTE;

  dwPrevAlphaBlock:DWORD;
  PrevColorBlock:DWORD;
  PrevIndexBlock:DWORD;

  dwColorTableMem:DWORD;
  //dwColorTableMem:DWORD;
  CopyColorBlock:BOOLEAN;

  wFirstColor:WORD;
  wLastColor:WORD;
begin
  Result:=False;
  if not IsImageSet(InImage) then
  Exit;

  if ((InImage^.Width mod 16) > 0) or ((InImage^.Height mod 16) > 0) then
  Exit;

  // Create new Image
  if not InitImage(OutImage) then
  Exit;

  // Copy image input image information to output image
  OutImage^.enPixelFormat:=PIXEL_FORMAT_R8G8B8A8;
  OutImage^.dwSize:=(InImage^.Width * InImage^.Height) * 4;
  OutImage^.Width:=InImage^.Width;
  OutImage^.Height:=InImage^.Height;
  OutImage^.PixelSize:=32;

  // Alocate target image data memory
  GetMem(OutImage^.mData,OutImage^.dwSize);

  InDataMem:=DWORD(InImage^.mData);
  OutDataMem:=DWORD(OutImage^.mData);

  GetMem(POINTER(dwColorTableMem),16);

  ScanLineSize:=InImage^.Width * 4;
  XBlockCount:=(InImage^.Width + 3) shr 2;
  YBlockCount:=(InImage^.Height + 3) shr 2;
  //dwBlocksDuplicated:=0;
  PrevColorBlock:=0;
  PrevIndexBlock:=0;
  StartTimer(Timer);
  // 628 602 613 634
  // 599 595 603 595
  // 601 593 609 597
  // 626 624 597 607
  for YBlockIndex:=0 to YBlockCount - 1 do
  begin
    for XBlockIndex:=0 to XBlockCount - 1 do
    begin
      CopyColorBlock:=False;
      if PrevColorBlock = PDWORD(InDataMem+$08)^ then
      begin
        // We found that previous colors in block are same as current block so we check if current
        // block have same color indexes ,if yes then we
        if PrevIndexBlock = PDWORD(InDataMem+$0C)^ then
        CopyColorBlock:=True else PrevIndexBlock:=PDWORD(InDataMem+$0C)^
      end
        else
      begin
        PrevColorBlock:=PDWORD(InDataMem+$08)^;
        PrevIndexBlock:=PDWORD(InDataMem+$0C)^;

        wFirstColor:=PWORD(InDataMem+$08)^;
        wLastColor:=PWORD(InDataMem+$0A)^;

        PBYTE(dwColorTableMem+$00)^:=(wFirstColor and $001F) shl 3;
        PBYTE(dwColorTableMem+$01)^:=(wFirstColor and $07E0) shr 3;
        PBYTE(dwColorTableMem+$02)^:=(wFirstColor and $F800) shr 8;
        //PBYTE(dwColorTableMem+$03)^:=$FF;

        PBYTE(dwColorTableMem+$04)^:=(wLastColor and $001F) shl 3;
        PBYTE(dwColorTableMem+$05)^:=(wLastColor and $07E0) shr 3;
        PBYTE(dwColorTableMem+$06)^:=(wLastColor and $F800) shr 8;
        //PBYTE(dwColorTableMem+$07)^:=$FF;

        PBYTE(dwColorTableMem+$08)^:=(((wFirstColor and $001F) shl 4) + ((wLastColor and $001F) shl 3)) div 3;
        PBYTE(dwColorTableMem+$09)^:=(((wFirstColor and $07E0) shr 2) + ((wLastColor and $07E0) shr 3)) div 3;
        PBYTE(dwColorTableMem+$0A)^:=(((wFirstColor and $F800) shr 7) + ((wLastColor and $F800) shr 8)) div 3;
        //PBYTE(dwColorTableMem+$0B)^:=$FF;

        PBYTE(dwColorTableMem+$0C)^:=(((wFirstColor and $001F) shl 3) + ((wLastColor and $001F) shl 4)) div 3;
        PBYTE(dwColorTableMem+$0D)^:=(((wFirstColor and $07E0) shr 3) + ((wLastColor and $07E0) shr 2)) div 3;
        PBYTE(dwColorTableMem+$0E)^:=(((wFirstColor and $F800) shr 8) + ((wLastColor and $F800) shr 7)) div 3;
        //PBYTE(dwColorTableMem+$0F)^:=$FF;
      end; // if

      if CopyColorBlock then
      begin
        InScanLineMem:=PrevScanLineMem;
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
        PrevScanLineMem:=OutDataMem;
        OutScanLineMem:=OutDataMem;

        IndexTableBlockB:=PBYTE(InDataMem+$04)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(dwColorTableMem+((IndexTableBlockB and $03) shl 2))^;
        PBYTE(OutScanLineMem+$03)^:=(PBYTE(InDataMem)^ and $0F) or (PBYTE(InDataMem)^ shl $04);

        PDWORD(OutScanLineMem+$04)^:=PDWORD(dwColorTableMem+((IndexTableBlockB and $0C) shl 0))^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(dwColorTableMem+((IndexTableBlockB and $30) shr 2))^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(dwColorTableMem+((IndexTableBlockB and $C0) shr 4))^;
        inc(OutScanLineMem,ScanLineSize);

        IndexTableBlockB:=PBYTE(InDataMem+$05)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(dwColorTableMem+((IndexTableBlockB and $03) shl 2))^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(dwColorTableMem+((IndexTableBlockB and $0C) shl 0))^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(dwColorTableMem+((IndexTableBlockB and $30) shr 2))^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(dwColorTableMem+((IndexTableBlockB and $C0) shr 4))^;
        inc(OutScanLineMem,ScanLineSize);

        IndexTableBlockB:=PBYTE(InDataMem+$06)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(dwColorTableMem+((IndexTableBlockB and $03) shl 2))^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(dwColorTableMem+((IndexTableBlockB and $0C) shl 0))^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(dwColorTableMem+((IndexTableBlockB and $30) shr 2))^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(dwColorTableMem+((IndexTableBlockB and $C0) shr 4))^;
        inc(OutScanLineMem,ScanLineSize);

        IndexTableBlockB:=PBYTE(InDataMem+$07)^;
        PDWORD(OutScanLineMem+$00)^:=PDWORD(dwColorTableMem+((IndexTableBlockB and $03) shl 2))^;
        PDWORD(OutScanLineMem+$04)^:=PDWORD(dwColorTableMem+((IndexTableBlockB and $0C) shl 0))^;
        PDWORD(OutScanLineMem+$08)^:=PDWORD(dwColorTableMem+((IndexTableBlockB and $30) shr 2))^;
        PDWORD(OutScanLineMem+$0C)^:=PDWORD(dwColorTableMem+((IndexTableBlockB and $C0) shr 4))^;
      end; // else
      inc(InDataMem,16);
      inc(OutDataMem,16);
    end; // for x
    OutDataMem:=OutScanLineMem + 16;
  end; // for y
  //if dwBlocksDuplicated > 0 then
  //Halt(0);
  StopTimer(Timer);
  ShowTimer(Timer);
end;
*)
end.
