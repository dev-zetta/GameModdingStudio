unit VastUtils;

interface

uses
  Windows;

const
  INSTRUCT_SET_NONE   = 0;
  INSTRUCT_SET_MMX    = 1;
  INSTRUCT_SET_SSE    = 2;
  INSTRUCT_SET_SSE2   = 3;
  INSTRUCT_SET_SSE3   = 4;
  INSTRUCT_SET_SSSE3  = 5;
  INSTRUCT_SET_SSE41  = 6;
  INSTRUCT_SET_SSE42  = 7;


type
  TMEMORYSTATUSEX = Packed Record
    Length:DWORD;
    MemoryLoad:DWORD;
    TotalPhys:INT64;
    AvailPhys:INT64;
    TotalPageFile:INT64;
    AvailPageFile:INT64;
    TotalVirtual:INT64;
    AvailVirtual:INT64;
    AvailExtendedVirtual:INT64;
  end;
  PMEMORYSTATUSEX = ^TMEMORYSTATUSEX;


function IsFileExists(const FileName:PChar):Boolean;
function GetMemoryStatus(const MemStatus:PMEMORYSTATUSEX):BOOLEAN;
function GetSectorSize(const Volume:CHAR):DWORD;
function GetFreeSpace(const Volume:CHAR):INT64;

// Functions to copy memory between 2 memory locations,optimized
function CopyMem(const InDataMem:DWORD;const OutDataMem:DWORD;const InDataSize:DWORD):BOOLEAN;assembler;
function CopyMemMMX(const InDataMem:DWORD;const OutDataMem:DWORD;const InDataSize:DWORD):BOOLEAN;assembler;
function CopyMemSSE(const InDataMem:DWORD;const OutDataMem:DWORD;const InDataSize:DWORD):BOOLEAN;assembler;
function CopyMemSwap(const InDataMem:DWORD;const OutDataMem:DWORD;const InDataSize:DWORD):BOOLEAN;assembler;
// Basic FillChar replacement,but this should be Vaster
//function FillMem(const InDataMem:DWORD;const InDataSize:DWORD;const bValue:BYTE):BOOLEAN;assembler;

function FillDWORD(var InDataMem;const InDataSize:DWORD;const Value:DWORD):BOOLEAN;assembler;
function EraseMem(var InDataMem;const InDataSize:DWORD):BOOLEAN;assembler;

function mod2 (const Value:DWORD):DWORD;
function mod4 (const Value:DWORD):DWORD;
function mod8 (const Value:DWORD):DWORD;
function mod16 (const Value:DWORD):DWORD;

function GetLowerValue (const First:DWORD;const Last:DWORD):DWORD;assembler;
function GetHigherValue (const First:DWORD;const Last:DWORD):DWORD;assembler;

function ClampBYTE(const Value:DWORD):DWORD;assembler;
function ClampWORD(const Value:DWORD):DWORD;assembler;

// Exchange values
procedure SwapDWORD(var InValue:DWORD;var OutValue:DWORD);assembler;
procedure SwapWORD(var InValue:WORD;var OutValue:WORD);assembler;
procedure SwapBYTE(var InValue:BYTE;var OutValue:BYTE);assembler;

function GetBit (const Value:DWORD;const BitIndex:DWORD):BYTE;assembler;
function SetBit (const Value:DWORD;const BitIndex:DWORD):BYTE;assembler;
function ResetBit (const Value:DWORD;const BitIndex:DWORD):BYTE;assembler;

function GetHighBitIndex (const Value:DWORD):DWORD;assembler;overload;
function GetHighBitIndex (const Value:WORD):DWORD;assembler;overload;
function GetHighBitIndex (const Value:BYTE):DWORD;assembler;overload;

function GetLowBitIndex (const Value:DWORD):DWORD;assembler;overload;
function GetLowBitIndex (const Value:WORD):DWORD;assembler;overload;
function GetLowBitIndex (const Value:BYTE):DWORD;assembler;overload;

// Swap big/little endian
function SwapEndian (const Value:DWORD):DWORD;assembler;overload;
function SwapEndian (const Value:WORD):DWORD;assembler;overload;
// MMX
// http://www.laaca.borec.cz/mmx/mmx_main.htm
// http://www.tommesani.com/MMXPrimer.html#InstructionSet
// http://softpixel.com/~cwright/programming/simd/cpuid.php
// http://int21h.ic.cz/?id=38
// http://www.ews.uiuc.edu/~cjiang/reference/vc199.htm
// http://softpixel.com/~cwright/programming/simd/mmx.php

// SSE
// http://softpixel.com/~cwright/programming/simd/sse3.php
// http://www.jorgon.freeserve.co.uk/TestbugHelp/XMMintins.htm
// http://en.wikipedia.org/wiki/SSE2

// Basic functions to detect processor instruction sets
function GetInstructionSet:DWORD;assembler;
function IsMMXPresent:Boolean;assembler;
function IsSSEPresent:Boolean;assembler;
function IsSSE2Present:Boolean;assembler;
function IsSSE3Present:Boolean;assembler;
function IsSSSE3Present:Boolean;assembler;
function IsSSE41Present:Boolean;assembler;
function IsSSE42Present:Boolean;assembler;
function IsHTTPresent:Boolean;assembler;
function GetCacheSize:DWORD;assembler;
function GetCoreCount:DWORD;assembler;


// Not defined in Windows.h
function GlobalMemoryStatusEx(const MemStatus:PMEMORYSTATUSEX):DWORD;stdcall;external 'Kernel32.dll' name 'GlobalMemoryStatusEx';

implementation

// Get supported (and newest) instruction set by current CPU
function GetInstructionSet:DWORD;assembler;
asm
  mov eax,1
  CPUID
  test ecx,$00100000
  jnz @IsSSE42Present

  test ecx,$00080000
  jnz @IsSSE41Present

  test ecx,$00000200
  jnz @IsSSSE3Present

  test ecx,$00000001
  jnz @IsSSE3Present

  test edx,$04000000
  jnz @IsSSE2Present

  test edx,$02000000
  jnz @IsSSEPresent

  test edx,$00800000
  jnz @IsMMXPresent
  xor eax,eax //INSTRUCT_SET_NONE
  ret

  @IsMMXPresent:
  mov eax,INSTRUCT_SET_MMX
  ret

  @IsSSEPresent:
  mov eax,INSTRUCT_SET_SSE
  ret

  @IsSSE2Present:
  mov eax,INSTRUCT_SET_SSE2
  ret

  @IsSSE3Present:
  mov eax,INSTRUCT_SET_SSE3
  ret

  @IsSSSE3Present:
  mov eax,INSTRUCT_SET_SSSE3
  ret

  @IsSSE41Present:
  mov eax,INSTRUCT_SET_SSE41
  ret

  @IsSSE42Present:
  mov eax,INSTRUCT_SET_SSE42
  ret
end;

function IsMMXPresent:Boolean;assembler;
asm
  mov eax,1
  CPUID
  test edx,$00800000
  jnz @IsPresent
  xor eax,eax
  ret
  @IsPresent:
  mov eax,1
  ret
end;

function IsSSEPresent:Boolean;assembler;
asm
  mov eax,1
  CPUID
  test edx,$02000000
  jnz @IsPresent
  xor eax,eax
  ret
  @IsPresent:
  mov eax,1
  ret
end;

function IsSSE2Present:Boolean;assembler;
asm
  mov eax,1
  CPUID
  test edx,$04000000
  jnz @IsPresent
  xor eax,eax
  ret
  @IsPresent:
  mov eax,1
  ret
end;

function IsSSE3Present:Boolean;assembler;
asm
  mov eax,1
  CPUID
  test ecx,$00000001
  jnz @IsPresent
  xor eax,eax
  ret
  @IsPresent:
  mov eax,1
  ret
end;

function IsSSSE3Present:Boolean;assembler;
asm
  mov eax,1
  CPUID
  test ecx,$00000200
  jnz @IsPresent
  xor eax,eax
  ret
  @IsPresent:
  mov eax,1
  ret
end;

function IsSSE41Present:Boolean;assembler;
asm
  mov eax,1
  CPUID
  test ecx,$00080000
  jnz @IsPresent
  xor eax,eax
  ret
  @IsPresent:
  mov eax,1
  ret
end;

function IsSSE42Present:Boolean;assembler;
asm
  mov eax,1
  CPUID
  test ecx,$00100000
  jnz @IsPresent
  xor eax,eax
  ret
  @IsPresent:
  mov eax,1
  ret
end;

function IsHTTPresent:Boolean;assembler;
asm
  mov eax,1
  CPUID
  test edx,$08000000
  jnz @IsPresent
  xor eax,eax
  ret
  @IsPresent:
  mov eax,1
  ret
end;

// Get L2 cache size in KB
function GetCacheSize:DWORD;assembler;
asm
  // Check if function 80000006 is supported
  mov eax,$80000000
  CPUID
  cmp eax,$80000006
  jl @NOTSUPPORTED
  mov eax,$80000006
  CPUID
  shr ecx,16
  mov eax,ecx
  ret
  @NOTSUPPORTED:
  xor eax,eax
  ret
end;

// Not tested
//http://software.intel.com/en-us/articles/cpuid-for-x64-platforms-and-microsoft-visual-studio-net-2005
function GetCoreCount:DWORD;assembler;
asm
  // Check if function 80000006 is supported
  mov eax,$00000004
  xor ecx,ecx
  CPUID
  shr eax,26
  //and eax,$3F
  inc eax
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
  mov eax,$00000001
  //xor eax,eax
  //inc eax
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
function CopyMemSSE(const InDataMem:DWORD;const OutDataMem:DWORD;const InDataSize:DWORD):BOOLEAN;assembler;
asm
  //mov esi,InDataMem
  test eax,eax
  jz @WRONGINPUT
  //mov edi,OutDataMem
  test edx,edx
  jz @WRONGINPUT
  //mov ecx,InDataSize
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
    //xor eax,eax
    //inc eax
    mov eax,$00000001
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
  //xor eax,eax
  //inc al
  mov eax,$00000001
  ret
end;

function CopyMemSwap(const InDataMem:DWORD;const OutDataMem:DWORD;const InDataSize:DWORD):BOOLEAN;assembler;
asm
  //mov esi,InDataMem
  test eax,eax
  jz @WRONGINPUT
  //mov edi,OutDataMem
  test edx,edx
  jz @WRONGINPUT
  //mov ecx,InDataSize
  test ecx,ecx
  jz @WRONGINPUT
  jmp @START // if all input registers are nonzero then we can start

  @WRONGINPUT:
  xor eax,eax
  ret

  @START:
  mov esi,eax
  mov edi,edx

  add edi,ecx
  mov edx,ecx
  shr ecx,$02
  test ecx,ecx
  jz @COPYCONTINUE
    //add esi,$04
    sub edi,$04
    @COPYNEXT:
      mov eax,[esi]

      //bswap eax
      //ror eax,16
      //xchg al,ah
      bswap eax
      //xchg al,ah
      //rol eax,8

      mov [edi],eax
      add esi,$04
      sub edi,$04
    loop @COPYNEXT
  @COPYCONTINUE:

  //and al,$7F // Copy remaing bytes if there is any
  //movzx ecx,al
  //rep movsb
  //xor eax,eax
  //nc al
  mov eax,$00000001
  ret
end;

// Same as FillChar but with DWORD value
function FillDWORD(var InDataMem;const InDataSize:DWORD;const Value:DWORD):BOOLEAN;assembler;
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

// Little bit modified original Delphi function
function EraseMem(var InDataMem;const InDataSize:DWORD):BOOLEAN;assembler;
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

function mod2 (const Value:DWORD):DWORD;
asm
  and eax,$00000001
  ret
end;

function mod4 (const Value:DWORD):DWORD;
asm
  and eax,$00000003
  ret
end;

function mod8 (const Value:DWORD):DWORD;
asm
  and eax,$00000007
  ret
end;

function mod16 (const Value:DWORD):DWORD;
asm
  and eax,$0000000F
  ret
end;

function ClampBYTE(const Value:DWORD):DWORD;assembler;
asm
  test eax,$FFFFFF00
  js @RESULT_00  // Value < 0
  jnz @RESULT_FF  // Value > 255
  ret
  @RESULT_00: // Result = 0
  xor eax,eax
  ret
  @RESULT_FF: // Result = 255
  xor eax,eax
  mov al,$FF
  ret
end;

function ClampWORD(const Value:DWORD):DWORD;assembler;
asm
  test eax,$FFFF0000
  js @RESULT_00  // Value < 0
  jnz @RESULT_FF  // Value > 65535
  // Result = Value
  ret
  @RESULT_00: // Result = 0
  xor eax,eax
  ret
  @RESULT_FF: // Result = 65535
  xor eax,eax
  mov ax,$FFFF
  ret
end;

function GetHigherValue (const First:DWORD;const Last:DWORD):DWORD;assembler;
asm
  cmp eax,edx
  cmovl eax,edx
  ret
end;

function GetLowerValue (const First:DWORD;const Last:DWORD):DWORD;assembler;
asm
  cmp eax,edx
  cmovg eax,edx
  ret
end;

function SwapEndian (const Value:DWORD):DWORD;assembler;overload;
asm
  bswap eax
  ret
end;

function SwapEndian (const Value:WORD):DWORD;assembler;overload;
asm
  shl eax,$10
  //xchg al,ah
  bswap eax
  ret
end;

// Well there is maybe better way... but we are exchanging memory data (DWORD)
// and not adresses of variables so xchg edx,eax is not possible in simple way
procedure SwapDWORD(var InValue:DWORD;var OutValue:DWORD);assembler;
asm
  //xchg edx,eax
  push ebx
  push ecx
  mov ebx,[eax]
  mov ecx,[edx]
  mov [eax],ecx
  mov [edx],ebx
  pop ecx
  pop ebx
  ret
end;

procedure SwapWORD(var InValue:WORD;var OutValue:WORD);assembler;
asm
  //xchg edx,eax
  push ebx
  push ecx
  mov bx,[eax]
  mov cx,[edx]
  mov [eax],cx
  mov [edx],bx
  pop ecx
  pop ebx
  ret
end;

procedure SwapBYTE(var InValue:BYTE;var OutValue:BYTE);assembler;
asm
  //xchg edx,eax
  push ebx
  push ecx
  mov bl,[eax]
  mov cl,[edx]
  mov [eax],cl
  mov [edx],bl
  pop ecx
  pop ebx
  ret
end;

function GetBit (const Value:DWORD;const BitIndex:DWORD):BYTE;assembler;
asm
  bt eax,edx
  setc al
  //and eax,$000000FF
  ret
end;

function SetBit (const Value:DWORD;const BitIndex:DWORD):BYTE;assembler;
asm
  bts eax,edx
  setc al
  //and eax,$000000FF
  ret
end;

function ResetBit (const Value:DWORD;const BitIndex:DWORD):BYTE;assembler;
asm
  btr eax,edx
  setc al
  //and eax,$000000FF
  ret
end;

function GetHighBitIndex (const Value:DWORD):DWORD;assembler;overload;
asm
  test eax,eax
  jz @ZEROINPUT
  bsr eax,eax
  ret
  @ZEROINPUT:
  xor eax,eax
  ret
end;

function GetHighBitIndex (const Value:WORD):DWORD;assembler;overload;
asm
  //and eax,$0000FFFF
  test ax,ax
  jz @ZEROINPUT
  bsr ax,ax
  ret
  @ZEROINPUT:
  xor eax,eax
  ret
end;

function GetHighBitIndex (const Value:BYTE):DWORD;assembler;overload;
asm
  //and eax,$0000FFFF
  test al,al
  jz @ZEROINPUT
  bsr ax,ax
  ret
  @ZEROINPUT:
  xor eax,eax
  ret
end;

function GetLowBitIndex (const Value:DWORD):DWORD;assembler;overload;
asm
  test eax,eax
  jz @ZEROINPUT
  bsf eax,eax
  ret
  @ZEROINPUT:
  xor eax,eax
  ret
end;

function GetLowBitIndex (const Value:WORD):DWORD;assembler;overload;
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

function GetLowBitIndex (const Value:BYTE):DWORD;assembler;overload;
asm
  //and eax,$0000FFFF
  test al,al
  jz @ZEROINPUT
  bsf ax,ax
  ret
  @ZEROINPUT:
  xor eax,eax
  ret
end;

function IsFileExists(const FileName:PChar):Boolean;
var
  FileHandle:DWORD;
begin
  Result:=False;

  FileHandle:=CreateFileA(PAnsiChar(FileName),0,0,0,OPEN_EXISTING,0,0);
  if FileHandle <> INVALID_HANDLE_VALUE then
  CloseHandle(FileHandle);
  Result:=FileHandle <> INVALID_HANDLE_VALUE;
end;

//http://msdn.microsoft.com/en-us/library/aa366589(VS.85).aspx
function GetMemoryStatus(const MemStatus:PMEMORYSTATUSEX):BOOLEAN;
begin
  Result:=False;
  if MemStatus = nil then
  Exit;

  MemStatus^.Length:=SizeOf(TMEMORYSTATUSEX);
  if GlobalMemoryStatusEx(MemStatus) <> 0 then
  Result:=True;
end;

function GetSectorSize(const Volume:CHAR):DWORD;
var
  Drive:Array[0..3] of CHAR;
  SectorsPerCluster: DWORD;
  BytesPerSector: DWORD;
  NumberOfFreeClusters: DWORD;
  pTotalNumberOfClusters: DWORD;
begin
  Drive[0]:= Volume;
  Drive[1]:= ':';
  Drive[2]:= '\';
  Drive[3]:= #00;

  if GetDiskFreeSpace(@Drive,SectorsPerCluster,BytesPerSector,NumberOfFreeClusters,pTotalNumberOfClusters) then
  Result:= BytesPerSector else Result:=0;
end;

function GetFreeSpace(const Volume:CHAR):INT64;
var
  Drive:Array[0..3] of CHAR;
  SectorsPerCluster: DWORD;
  BytesPerSector: DWORD;
  NumberOfFreeClusters: DWORD;
  pTotalNumberOfClusters: DWORD;
begin
  Drive[0]:= Volume;
  Drive[1]:= ':';
  Drive[2]:= '\';
  Drive[3]:= #00;
  // TODO: FIX FATAL ERROR !!! Result is incorect,bad int64 multiplications
  if GetDiskFreeSpace(Drive,SectorsPerCluster,BytesPerSector,NumberOfFreeClusters,pTotalNumberOfClusters) then
  Result:= ((SectorsPerCluster * BytesPerSector) * NumberOfFreeClusters) else Result:=0;
end;

end.
