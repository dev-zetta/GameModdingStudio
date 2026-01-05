unit AsmFun;

interface

type
  DWORD = Cardinal;

function GetHiByte (const Value: WORD):BYTE; overload;
function GetHiByte (const Value: DWORD):BYTE; overload;

function SwapEndian(const Value: WORD): WORD; overload;
function SwapEndian(const Value: DWORD): DWORD; overload;

function mod2 (const Value: DWORD):DWORD;
function mod4 (const Value: DWORD):DWORD;
function mod8 (const Value: DWORD):DWORD;
function mod16 (const Value: DWORD):DWORD;

function ClampByte(const Value: DWORD):DWORD;
function ClampWord(const Value: DWORD):DWORD;

function GetHigherValue (const AValue: DWORD; const BValue: DWORD):DWORD;
function GetLowerValue (const AValue: DWORD; const BValue: DWORD):DWORD;

procedure SwapValues(var AValue: BYTE; var BValue: BYTE); overload;
procedure SwapValues(var AValue: WORD; var BValue: WORD); overload;
procedure SwapValues(var AValue: DWORD; var BValue: DWORD); overload;

function GetBit (const Value:DWORD;const BitIndex:DWORD):BYTE;
function SetBit (const Value:DWORD;const BitIndex:DWORD):BYTE;
function ResetBit (const Value:DWORD;const BitIndex:DWORD):BYTE;

function GetHighBitIndex (const Value:BYTE):DWORD; overload;
function GetHighBitIndex (const Value:WORD):DWORD; overload;
function GetHighBitIndex (const Value:DWORD):DWORD; overload;

function GetLowBitIndex (const Value:BYTE):DWORD; overload;
function GetLowBitIndex (const Value:WORD):DWORD; overload;
function GetLowBitIndex (const Value:DWORD):DWORD; overload;

procedure CPUID(var EAXValue, EBXValue, ECXValue, EDXValue: DWORD);

function ReadBits32(const Memory:Pointer; const BitPos, BitCount:DWORD):DWORD;
function WriteBits32(const Memory: Pointer; const MemoryPos, Value, BitPos, BitCount: DWORD):DWORD;

function IsIntelProcessor:BOOLEAN;
function IntelGetCoreCount: DWORD;
function IntelIsHyperThreading:BOOLEAN;

implementation

// You get first byte from value
function GetHiByte (const Value: WORD):BYTE; overload;
asm
  shr eax, $08
  ret
end;

// You get first byte from value
function GetHiByte (const Value: DWORD):BYTE; overload;
asm
  shr eax, $18
  ret
end;

// Convert from BigEndian <-> LittleEndian
function SwapEndian(const Value: WORD): WORD; overload;
asm
  xchg al, ah;
  ret
end;

function SwapEndian(const Value: DWORD): DWORD; overload;
asm
  bswap eax;
  ret
end;

function mod2 (const Value:DWORD):DWORD;
asm
  and eax, $00000001
  ret
end;

function mod4 (const Value:DWORD):DWORD;
asm
  and eax, $00000003
  ret
end;

function mod8 (const Value:DWORD):DWORD;
asm
  and eax, $00000007
  ret
end;

function mod16 (const Value:DWORD):DWORD;
asm
  and eax, $0000000F
  ret
end;

// Check if value is out of its range, if yes then clamp it to max or zero
function ClampByte(const Value:DWORD):DWORD;
asm
  test eax, $FFFFFF00
  js @RESULT_00  // Value < 0
  jnz @RESULT_FF  // Value > 255
  ret
  @RESULT_00: // Result = 0
  xor eax, eax
  ret
  @RESULT_FF: // Result = 255
  xor eax, eax
  mov al, $FF
  ret
end;

function ClampWord(const Value:DWORD):DWORD;
asm
  test eax, $FFFF0000
  js @RESULT_00  // Value < 0
  jnz @RESULT_FF  // Value > 65535
  // Result = Value
  ret
  @RESULT_00: // Result = 0
  xor eax, eax
  ret
  @RESULT_FF: // Result = 65535
  xor eax, eax
  mov ax, $FFFF
  ret
end;

// Replaces this function: if A > B then result:= A else Result:=B
function GetHigherValue (const AValue:DWORD; const BValue:DWORD):DWORD;
asm
  cmp eax, edx
  cmovl eax, edx
  ret
end;

function GetLowerValue (const AValue:DWORD; const BValue:DWORD):DWORD;
asm
  cmp eax, edx
  cmovg eax, edx
  ret
end;


// Well there is maybe better way... but we are exchanging memory data (DWORD)
// and not adresses of variables so xchg edx,eax is not possible in simple way
procedure SwapValues(var AValue: BYTE; var BValue: BYTE); overload;
asm
  //xchg edx,eax
  push ebx
  push ecx
  mov bl, [eax]
  mov cl, [edx]
  mov [eax], cl
  mov [edx], bl
  pop ecx
  pop ebx
  ret
end;

procedure SwapValues(var AValue: WORD; var BValue: WORD); overload;
asm
  //xchg edx,eax
  push ebx
  push ecx
  mov bx, [eax]
  mov cx, [edx]
  mov [eax], cx
  mov [edx], bx
  pop ecx
  pop ebx
  ret
end;

procedure SwapValues(var AValue: DWORD; var BValue: DWORD); overload;
asm
  //xchg edx,eax
  push ebx
  push ecx
  mov ebx, [eax]
  mov ecx, [edx]
  mov [eax], ecx
  mov [edx], ebx
  pop ecx
  pop ebx
  ret
end;

function GetBit (const Value:DWORD; const BitIndex:DWORD):BYTE;
asm
  bt eax, edx
  setc al
  //and eax,$000000FF
  ret
end;

function SetBit (const Value:DWORD; const BitIndex:DWORD):BYTE;
asm
  bts eax, edx
  setc al
  //and eax,$000000FF
  ret
end;

function ResetBit (const Value:DWORD; const BitIndex:DWORD):BYTE;
asm
  btr eax, edx
  setc al
  //and eax,$000000FF
  ret
end;

function GetHighBitIndex (const Value:BYTE):DWORD; overload;
asm
  //and eax,$0000FFFF
  test al, al
  jz @ZEROINPUT
  bsr ax, ax
  ret
  @ZEROINPUT:
  xor eax, eax
  ret
end;

function GetHighBitIndex (const Value:WORD):DWORD; overload;
asm
  //and eax,$0000FFFF
  test ax, ax
  jz @ZEROINPUT
  bsr ax, ax
  ret
  @ZEROINPUT:
  xor eax, eax
  ret
end;

function GetHighBitIndex (const Value:DWORD):DWORD; overload;
asm
  test eax, eax
  jz @ZEROINPUT
  bsr eax, eax
  ret
  @ZEROINPUT:
  xor eax, eax
  ret
end;


function GetLowBitIndex (const Value:DWORD):DWORD; overload;
asm
  test eax,eax
  jz @ZEROINPUT
  bsf eax,eax
  ret
  @ZEROINPUT:
  xor eax,eax
  ret
end;

function GetLowBitIndex (const Value:WORD):DWORD; overload;
asm
  //and eax,$0000FFFF
  test ax,ax
  jz @ZEROINPUT
  bsf ax,ax
  ret
  @ZEROINPUT:
  xor eax,eax
  ret
end;

function GetLowBitIndex (const Value:BYTE):DWORD; overload;
asm
  test al,al
  jz @ZEROINPUT
  bsf ax,ax
  ret
  @ZEROINPUT:
  xor eax,eax
  ret
end;

function CPUIDSupported: Boolean;
asm
  pushfd
  pop eax
  mov edx, eax
  xor eax, $200000
  push eax
  popfd
  pushfd
  pop eax
  xor eax, edx
  setnz al
end;

procedure CPUID(var EAXValue, EBXValue, ECXValue, EDXValue: DWORD);
asm
  pushad
  // Retreive values from parameters
  mov eax, [eax]
  mov ebx, [edx]
  mov ecx, [ecx]
  mov edx, [ebp+$08]
  mov edx, [edx]

  // Call cpuid instruction
  cpuid

  // Copy to output
  mov edi, [esp+$1C]
  mov [edi], eax

  mov edi, [esp+$14]
  mov [edi], ebx

  mov edi, [esp+$18]
  mov [edi], ecx

  mov edi, [ebp+$08]
  mov [edi], edx

  popad
  pop eax
  ret
end;


//-------------------------------------------------------
// Reads number of bits from source memory at bit pos,
// this funtion has similar usage as stream or file function BlockRead
// -BitPos is limited to 512MB because BitPos is in bits, not bytes,
// so after you reach 512MB limit, you should increase Source pointer, so you can continue
// -Bitcount is limited to 32 bits because result is DWORD
// -Result is read bits
//-------------------------------------------------------
function ReadBits32(const Memory:Pointer; const BitPos, BitCount:DWORD):DWORD;
asm
  test eax, eax
  jz @Exit //Source
  test ecx, ecx
  jz @Exit // BitCount

  test dl, $07 // if  BitPos is 8 aligned
  jz @ALIGNED
//------------------
// Unaligned bit pos
//------------------
  push ebx
  mov bl, cl // BL = BitCount
  mov cl, dl // CL = BitPos
  and cl, $07

  mov ch, $FF
  shr ch, cl // CH = bit mask

  // Seek to source pos
  shr edx, $03
  add edx, eax

  //Process bits
  xor eax, eax
  mov al, BYTE[edx] // Read first byte from source
  and al, ch // Erase uneeded bits (apply mask)

  neg cl
  add cl, $08 // CL = number of bits we have in AL
  cmp bl, cl // compare how many bits we need(BL) and we have(CL)

  jg @BYTECHECK // jump if we need more bits
  sub cl, bl //
  shr al, cl
  pop ebx
  ret

  @BYTECHECK:
  sub bl, cl
  mov cl, bl // Decrease BitCount by number of bits we need to copy to reach 8 bit boundary
  // Check if we have some bytes to do
  cmp cl, $08
  jl @BITCHECK
  // Now we copy as much bytes as possible
  @NEXTBYTE:
  shl eax, $08 // Prepare for next byte
  inc edx // Seek to next byte
  mov al, BYTE[edx]
  sub cl, $08
  cmp cl, $08
  jge @NEXTBYTE

  // We finish here
  @BITCHECK:
  test cl, cl
  jz @BITFINISH // Check if we need to copy some bits again
  shl eax, cl // Prepare space for bits
  neg cl
  add cl, $08 // CL = Number of unneeded bits in BL
  mov bl, BYTE[edx+$01] // Copy new byte
  shr bl, cl // Delete uneeded bits
  or al, bl // copy bits to output

  @BITFINISH:
  pop ebx
  ret // Finally we finished, EAX = Result
//------------------
// Aligned bit pos
//------------------
  @ALIGNED:
  shr edx, $03
  add edx, eax
  xor eax, eax

  cmp cl, $08
  je @ALIGNED8E
  jl @ALIGNED8L

  cmp cl, $10
  je @ALIGNED16E
  jl @ALIGNED16L

  cmp cl, $18
  je @ALIGNED24E
  jl @ALIGNED24L

  cmp cl, $20
  je @ALIGNED32E
  jl @ALIGNED32L

  @ALIGNED8E:
  mov al, BYTE[edx]
  ret

  @ALIGNED8L:
  mov al, BYTE[edx]
  not cl
  add cl, $09
  shr al, cl
  ret

  @ALIGNED16E:
  mov ah, BYTE[edx+$00]
  mov al, BYTE[edx+$01]
  ret

  @ALIGNED16L:
  mov ah, BYTE[edx+$00]
  mov al, BYTE[edx+$01]
  neg cl
  add cl, $10
  shr ax, cl
  ret

  @ALIGNED24E:
  mov edx, eax
  mov ah, $00
  mov al, BYTE[edx+$00]
  shl eax, $10
  mov ah, BYTE[edx+$01]
  mov al, BYTE[edx+$02]
  ret

  @ALIGNED24L:
  mov edx, eax
  mov ah, $00
  mov al, BYTE[edx+$00]
  shl eax, $10
  mov ah, BYTE[edx+$01]
  mov al, BYTE[edx+$02]
  neg cl
  add cl, $18
  shr eax, cl
  ret

  @ALIGNED32E:
  mov ah, BYTE[edx+$00]
  mov al, BYTE[edx+$01]
  shl eax, $10
  mov ah, BYTE[edx+$02]
  mov al, BYTE[edx+$03]
  ret

  @ALIGNED32L:
  mov ah, BYTE[edx+$00]
  mov al, BYTE[edx+$01]
  shl eax, $10
  mov ah, BYTE[edx+$02]
  mov al, BYTE[edx+$03]
  neg cl
  add cl, $20
  shr eax, cl
  ret

  @EXIT:
  xor eax, eax
  ret
end;

//TODO: Not done !!!
function WriteBits32(const Memory: Pointer; const MemoryPos, Value, BitPos, BitCount: DWORD):DWORD;
asm
  test eax, eax
  jz @Exit
  pushad
  mov esi, ecx  // Value
  mov edi, eax  // Memory

  mov ebx, DWORD[ebp+$0C] // BitPos
  mov ecx, DWORD[ebp+$08] // BitCount

  // Seek to target memory  + bitcount
  add edx, ecx
  mov eax, edx
  shr eax, $03
  add edi, eax

  mov ch, cl
  sub cl, bl

  shl esi, cl // Delete Value bits
  mov cl, ch // Restore BitCount
  shr esi, cl // Delete Value bits

  and edx, $07 // MemoryPos
  test edx, edx
  jz @SKIP
  mov al, BYTE[edi]


  @SKIP:
  //mov ebx, DWORD[esp+$0C]

  popad
  @Exit:
  xor eax, eax
  ret
end;


function IsIntelProcessor:BOOLEAN;
asm
  push ebx
  push ecx
  push edx

  mov eax, 0
  cpuid

  cmp ebx, $756E6547
  jne @NOTINTEL
  cmp edx, $49656E69
  jne @NOTINTEL
  cmp ecx, $6C65746E
  jne @NOTINTEL
  pop edx
  pop ecx
  pop ebx
  xor eax, eax
  inc al
  ret
  @NOTINTEL:
  pop edx
  pop ecx
  pop ebx
  xor eax, eax
  ret
end;

function IntelGetCoreCount: DWORD;
asm
  push ebx
  push ecx
  push edx

  mov eax, 0
  cpuid

  mov eax, 4
  mov ecx, 0
  cpuid
  shr eax, 26
  inc eax  // number of cores
  pop edx
  pop ecx
  pop ebx
  ret
end;

function IntelIsHyperThreading:BOOLEAN;
asm
  push ebx
  push ecx
  push edx

  mov eax,1
  cpuid

  test edx,$08000000
  jnz @IsPresent
  pop edx
  pop ecx
  pop ebx
  xor eax,eax
  ret

  @IsPresent:
  pop edx
  pop ecx
  pop ebx
  mov eax,1
  ret
end;


// Little bit modified original Delphi function
function ZeroMem(var InDataMem;const InDataSize:DWORD):BOOLEAN;
asm
// EAX = InDataMem
// EDX = InDataSize
  test eax,eax
  jz @exit
  test edx,edx
  jz @exit

  push edi
  mov edi,eax

  // Fill with zeros
  xor eax,eax

  mov ecx,edx
  shr ecx,$02 // sar ?

  rep stosd  //Fill count DIV 4 ords

  mov ecx,edx
  and ecx,$03

  rep stosb   //Fill count MOD 4 bytes
  //xor eax,eax
  //inc eax
  mov eax,$00000001
  pop edi
  ret
@exit:
  xor eax,eax
  ret
end;

// Same as FillChar but with DWORD value
function FillMemLong(var InDataMem;const InDataSize:DWORD;const Value:DWORD):BOOLEAN;
asm
// EAX = InDataMem
// EDX = InDataSize
  test eax,eax
  jz @exit
  test edx,edx
  jz @exit
  test dl,$03   // InDataSize must be DWORD aligned
  jnz @exit

  push edi
  mov edi,eax

// EAX = Value
  mov eax,ecx

  mov ecx,edx
  shr ecx,$02 // sar ?

  rep stosd  //Fill count DIV 4 ords

  //xor eax,eax
  //inc eax
  mov eax,$00000001
  pop edi
  ret
@exit:
  xor eax,eax
  ret
end;

function CopyMem(const InDataMem:DWORD;const OutDataMem:DWORD;const InDataSize:DWORD):BOOLEAN;assembler;
asm
  push ecx
  push esi
  push edi
  mov esi,InDataMem
  test esi,esi
  jz @WrongInput
  mov edi,OutDataMem
  test edi,edi
  jz @WrongInput
  mov ecx,InDataSize
  test ecx,ecx
  jz @WrongInput
  mov eax,ecx
  and al,$03
  shr ecx,$02
  test ecx,ecx
  jz @SKIPCOPYDWORD
  rep movs DWORD[edi],DWORD[esi]
  @SKIPCOPYDWORD:
  test al,al
  jz @SKIPCOPYBYTE
  movzx ecx,al
  rep movs BYTE[edi],BYTE[esi]
  @SKIPCOPYBYTE:
  pop edi
  pop esi
  pop ecx
  mov eax, $01
  ret
  @WrongInput:
  pop edi
  pop esi
  pop ecx
  xor eax,eax
  ret
end;

// TODO: UPDATE
//http://groups.google.com/group/comp.lang.asm.x86/browse_thread/thread/2ae6c66f8e69ae82/1950f09a79cd4056
function CopyMemMMX(const InDataMem:DWORD;const OutDataMem:DWORD;const InDataSize:DWORD):BOOLEAN;assembler;
asm
  push ecx
  push esi
  push edi
  mov esi,InDataMem
  test esi,esi
  jz @WrongInput
  mov edi,OutDataMem
  test edi,edi
  jz @WrongInput
  mov ecx,InDataSize
  test ecx,ecx
  jz @WrongInput
  mov eax,ecx
  and al,$07
  shr ecx,$03
  test ecx,ecx
  //rep movsq
  jz @SKIPCOPYQWORD
    @COPYQWORD:
     movq mm0,[esi]
     add esi,8
     movq [edi],mm0
     add edi,8
     dec ecx
     test ecx,ecx
     jnz @COPYQWORD
     emms
  @SKIPCOPYQWORD:
  test al,al
  jz @SKIPCOPYBYTE
  movzx ecx,al
  rep movs BYTE[edi],BYTE[esi]
  @SKIPCOPYBYTE:
  pop edi
  pop esi
  pop ecx
  //xor eax,eax
  //inc eax
  mov eax,$00000001
  ret
  @WrongInput:
  pop edi
  pop esi
  pop ecx
  xor eax,eax
  ret
end;

//http://groups.google.com/group/comp.lang.asm.x86/browse_thread/thread/2ae6c66f8e69ae82/1950f09a79cd4056
//http://coding.derkeiler.com/Archive/Assembler/comp.lang.asm.x86/2006-12/msg00078.html
// Works well on large memory copying
function CopyMemSSE(const InDataMem:DWORD;const OutDataMem:DWORD;const InDataSize:DWORD):BOOLEAN;
asm
  test eax,eax
  jz @WRONGINPUT
  test edx,edx
  jz @WRONGINPUT
  test ecx,ecx
  jz @WRONGINPUT
  jmp @START // if all input registers are nonzero then we can start

  @WRONGINPUT:
  xor eax,eax
  ret

  @START:
  push ebx
  push esi
  push edi
  // Copy input registers to work with "rep movsb",ecx register is already moved
  mov esi,eax
  mov edi,edx

  // Check is InDataSize > 1024KB and if its not then we can use normal copy instead
  //(no speedup at so small size)
  test ecx,$FFF00000
  jnz @COPYCONTINUE
    @NORMALCOPY:
    mov eax,ecx
    shr ecx,$02
    rep movsd    // Copy 4 Bytes
    and al,$03
    movzx ecx,al
    rep movsb    // Copy 1 Byte
    // Restore registers
    pop edi
    pop esi
    pop ebx
    // Exit
    mov eax,$01
    ret
  @COPYCONTINUE:

  // We check if input and output memory pointer is aligned by 16,if not then
  // we copy data in slower mode
  test al,$0F
  jnz @START_UNALIGNED
  test dl,$0F
  jnz @START_UNALIGNED
  // if input and output pointers are aligned by 16 then we can copy normally
  jmp @START_ALIGNED

  @START_UNALIGNED:
  mov eax,ecx  // Backup InDataSize
  shr ecx,$07
    @COPYBLOCK_UNALIGNED:
    prefetchnta [esi+$80]
    // Move block from memory
    movdqu xmm0,[esi+$00]
    movdqu xmm1,[esi+$10]
    movdqu xmm2,[esi+$20]
    movdqu xmm3,[esi+$30]
    movdqu xmm4,[esi+$40]
    movdqu xmm5,[esi+$50]
    movdqu xmm6,[esi+$60]
    movdqu xmm7,[esi+$70]
    // Move block to memory
    movdqu [edi+$00],xmm0
    movdqu [edi+$10],xmm1
    movdqu [edi+$20],xmm2
    movdqu [edi+$30],xmm3
    movdqu [edi+$40],xmm4
    movdqu [edi+$50],xmm5
    movdqu [edi+$60],xmm6
    movdqu [edi+$70],xmm7
    add esi,$80
    add edi,$80
    loop @COPYBLOCK_UNALIGNED
  sfence
  jmp @FINISH

  @START_ALIGNED:
  mov eax,ecx  // Backup InDataSize
  shr ecx,$07
    @COPYBLOCK_ALIGNED:
    prefetchnta [esi+$80]
    // Move block from memory
    movdqa xmm0,[esi+$00]
    movdqa xmm1,[esi+$10]
    movdqa xmm2,[esi+$20]
    movdqa xmm3,[esi+$30]
    movdqa xmm4,[esi+$40]
    movdqa xmm5,[esi+$50]
    movdqa xmm6,[esi+$60]
    movdqa xmm7,[esi+$70]
    // Move block to memory
    movntdq [edi+$00],xmm0
    movntdq [edi+$10],xmm1
    movntdq [edi+$20],xmm2
    movntdq [edi+$30],xmm3
    movntdq [edi+$40],xmm4
    movntdq [edi+$50],xmm5
    movntdq [edi+$60],xmm6
    movntdq [edi+$70],xmm7
    add esi,$80
    add edi,$80
    loop @COPYBLOCK_ALIGNED
  sfence

  @FINISH:
  and al,$7F // Copy remaing bytes if there is any
  movzx ecx,al
  rep movsb
  pop edi  // Restore registers and exit
  pop esi
  pop ebx
  mov eax,$01
  ret
end;

function EntryptMemSSE2(const InDataMem:DWORD;const OutDataMem:DWORD;const InDataSize:DWORD):DWORD;
asm
  push ebx
  push ecx
  push edx
  push esi
  push edi

  mov esi, eax
  mov edi, edx

  mov ebx, ecx

  shr ecx, 4 // div 16

  test ecx, ecx
  jnz @ENCRYPT
  xor eax, eax
  jmp @EXIT

  @ENCRYPT:
  movdqu xmm0,[esi]
  pshufd xmm7, xmm0, $1B
  pxor xmm7, xmm0 // Make Xor key
  // Skip 16 bytes
  inc ecx
  add esi, 16
  add edi, 16

  @NEXT:

    movdqu xmm0, [esi]
    pxor xmm0, xmm7
    //punpckhqdq xmm7, xmm0
    pandn xmm7, xmm0

    //pshufd xmm1, xmm0, $1B
    //punpckhqdq



    //pshufd xmm2, xmm0, $87
    //pshufd xmm1, xmm0, $1B
    //pxor xmm1, xmm0

    //movdqu xmm2,[esi+4]
    //pxor xmm2, xmm0
    //pxor xmm1, xmm2

    //pshufd xmm2, xmm0, $1B

    //movdqu xmm1,[esi]

    movdqu [edi], xmm0
    add esi, 16
    add edi, 16
  loop @NEXT
  
  @EXIT:
  pop edi
  pop esi
  pop edx
  pop ecx
  pop ebx
  //mov eax, $01
  ret
end;

end.
