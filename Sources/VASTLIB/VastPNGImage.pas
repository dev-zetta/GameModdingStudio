unit VastPNGImage;

interface

uses
  VastImage, VastImageTypes, VastFile, VastMemory, VastUtils;

function IsPNGHeader(const Memory:POINTER):BOOLEAN;assembler;
function WritePNGHeader(const Memory:POINTER):BOOLEAN;assembler;

function IsPNGFooter(const Memory:POINTER):BOOLEAN;assembler;
function WritePNGFooter(const Memory:POINTER):BOOLEAN;assembler;
//procedure Test;

function LoadPNGImage(const FileName:PChar;var mImage:PVastImage):Boolean;
implementation

type
  TPNGHeader = Packed Record
    Marker:DWORD;
    ErrorCheck:DWORD;
  end;

  TPNGChunkHeader = Packed Record
    Size:DWORD;
    Marker:DWORD;
  end;

  TIHDRHeader = Packed Record
    Width:DWORD;              // Image width
    Height:DWORD;             // Image height
    BitDepth:BYTE;               // Bits per pixel or bits per sample (for truecolor)
    ColorType:BYTE;             // 0 = grayscale, 2 = truecolor, 3 = palette,
                                  // 4 = gray + alpha, 6 = truecolor + alpha
    Compression:BYTE;            // Compression type:  0 = ZLib
    Filter:BYTE;                // Used precompress filter
    Interlacing:BYTE;            // Used interlacing: 0 = no int, 1 = Adam7
  end;

const
  //PNGHEADER : Array[$00..$07] of BYTE = ($89,$50,$4E,$47,$0D,$0A,$1A,$0A);
  //PNGHEADER_SIZE = $08;
  //PNGFOOTER : Array[$00..$0B] of BYTE = ($00,$00,$00,$00,$49,$45,$4E,$44,$00,$00,$00,$00);
  //PNGFOOTER_SIZE = $0C;

  IHDRMarker = DWORD(Byte('I') or (Byte('H') shl $08) or (Byte('D') shl $10) or (Byte('R') shl $18));
  IENDMarker = DWORD(Byte('I') or (Byte('E') shl $08) or (Byte('N') shl $10) or (Byte('D') shl $18));
  IDATMarker = DWORD(Byte('I') or (Byte('D') shl $08) or (Byte('A') shl $10) or (Byte('T') shl $18));
  PLTEMarker = DWORD(Byte('P') or (Byte('L') shl $08) or (Byte('T') shl $10) or (Byte('E') shl $18));

var
  IsError:BOOLEAN;
  ErrorMessage:Array[0..255] of Char;

procedure ResetErrorState;
begin
  IsError:=False;
  EraseMem(ErrorMessage,256);
end;

//procedure SetErrorState(const

(*
procedure Test;
begin
  if IsPNGHeader(@PNGHEADER) then
  WritePNGHeader(@PNGHEADER);

  if IsPNGFooter(@PNGFOOTER) then
  WritePNGFooter(@PNGFOOTER);

end;
*)

function IsPNGHeader(const Memory:POINTER):BOOLEAN;assembler;
asm
  test eax,eax
  jz @EXIT
  //@HEADERID: DB  $89,$50,$4E,$47,$0D,$0A,$1A,$0A
  //@HEADERID: DQ  $89504E470D0A1A0A
  //movq mm0,[eax]
  //movq mm1,[@HEADERID]
  //pxor mm0,PNGHEADERID
  mov edx,DWORD[eax+$00]
  cmp edx,$474E5089
  jne @EXIT
  mov edx,DWORD[eax+$04]
  cmp edx,$0A1A0A0D
  jne @EXIT
  xor eax,eax
  inc eax
  ret
  @EXIT:
  xor eax,eax
  ret
end;

function WritePNGHeader(const Memory:POINTER):BOOLEAN;assembler;
asm
  test eax,eax
  jz @EXIT
  //movq mm0,[PNGHEADERID]
  //movq [eax],mm0
  //emms
  mov DWORD[eax+$00],$474E5089 // MARKER
  mov DWORD[eax+$04],$0A1A0A0D // PROTECTION INFO
  xor eax,eax
  inc eax
  ret
  @EXIT:
  xor eax,eax
  ret
end;

function IsPNGFooter(const Memory:POINTER):BOOLEAN;assembler;
asm
  // DO NOT TEST CRC VALUE !!! MAY BE ALWAYS DIFFERENT
  test eax,eax
  jz @EXIT
  mov edx,DWORD[eax+$00]
  test edx,edx      // SIZE
  jnz @EXIT
  mov edx,DWORD[eax+$04]
  cmp edx,$444E4549 // MARKER
  jne @EXIT
  xor eax,eax
  inc eax
  ret
  @EXIT:
  xor eax,eax
  ret
end;

function WritePNGFooter(const Memory:POINTER):BOOLEAN;assembler;
asm
  test eax,eax
  jz @EXIT
  //mov edx,DWORD[PNGFOOTER]
  //mov DWORD[eax],edx
  //mov edx,DWORD[PNGFOOTER+$04]
  //mov DWORD[eax+$04],edx
  //xor edx,edx // CRC = 0
  //mov DWORD[eax+$08],edx
  xor edx,edx
  mov DWORD[eax+$00],edx        // SIZE
  mov DWORD[eax+$04],$444E4549  // MARKER
  mov DWORD[eax+$08],edx        // CRC
  xor eax,eax
  inc eax
  ret
  @EXIT:
  xor eax,eax
  ret
end;



function LoadPNGImage(const FileName:PChar;var mImage:PVastImage):Boolean;
label
  lblExit;
var
  //FFile:File of Byte;
  FFile:TVastFile;

  FilePos:DWORD;
  FileSize:DWORD;

  Header:TPNGHeader;
  Chunk:TPNGChunkHeader;

  IHDRHeader:TIHDRHeader;

  InData:POINTER;
  InDataMem:DWORD;
  InDataSize:DWORD;

  OutData:POINTER;
  OutDataMem:DWORD;
  OutDataSize:DWORD;

  IsCompressed:BOOLEAN;
  IsPaletteUsed:BOOLEAN;

  PaletteMem:DWORD;
  PaletteSize:DWORD;

  AlphaChannelSize:DWORD;
  // byte position and size of pixel
  PixelPos:DWORD;
  PixelSize:DWORD;
  PixelMem:DWORD;
  // RLE Packet index and size
  Index:DWORD;
  PacketSize:DWORD;
begin
  Result:=False;

  ResetErrorState;

  if not EraseMem(FFile,SizeOf(TVastFile)) then
  Exit;  // Fatal Error

  if not ffOpen(FFile,FileName) then
  begin
    IsError:=True;
    ErrorMessage:='PNG LOADER: Cannot open input file !';
    Exit;
  end;

  if FFile.Size < 60 then // Minimum PNG size is cca 67 B
  begin
    IsError:=True;
    ErrorMessage:='PNG LOADER: Input file is too small !';
    goto lblExit;
  end;

  FileSize:=FFile.Size;

  // Read PNG Header
  if ffRead(FFile,Header,SizeOf(TPNGHeader)) < SizeOf(TPNGHeader) then
  begin
    IsError:=True;
    ErrorMessage:='PNG LOADER: Cannot read PNG header !';
    goto lblExit;
  end;

  if not IsPNGHeader(@Header) then
  begin
    IsError:=True;
    ErrorMessage:='PNG LOADER: Bad PNG header !';
    goto lblExit;
  end;

  if not InitImage(mImage) then
  begin
    IsError:=True;
    ErrorMessage:='PNG LOADER: Cannot init output image !';
    goto lblExit;
  end;

  FilePos:=SizeOf(TPNGHeader);
  while FilePos < FileSize - 1 do
  begin
    ffSeek(FFile,FilePos);
    ffRead(FFile,Chunk,SizeOf(TPNGChunkHeader));
    case Chunk.Marker of
      IHDRMarker:
      begin
        if ffRead(FFile,IHDRHeader,SizeOf(TIHDRHeader)) < SizeOf(TIHDRHeader) then
        begin
          IsError:=True;
          ErrorMessage:='PNG LOADER: IHDR chunk is not read correctly !';
          goto lblExit;
        end;

        case IHDRHeader.ColorType of
          // Grayscale
          $00: OutDataSize:= (IHDRHeader.Width * IHDRHeader.Height * IHDRHeader.BitDepth) div $08;
          //$01: goto lblExit;
          // RGB
          $02: OutDataSize:= ((IHDRHeader.Width * IHDRHeader.Height * IHDRHeader.BitDepth) div $08) * $03;
          // Palette
          $03: OutDataSize:= ((IHDRHeader.Width * IHDRHeader.Height * IHDRHeader.BitDepth) div $08) * $03;
          // GrayScale + Alpha
          $04: OutDataSize:= ((IHDRHeader.Width * IHDRHeader.Height * IHDRHeader.BitDepth) div $08) * $02;
          //$05: goto lblExit;
          // RGBA
          $06: OutDataSize:= ((IHDRHeader.Width * IHDRHeader.Height * IHDRHeader.BitDepth) div $08) * $04;
        end; // case end

        if not mAllocMem(OutData,OutDataSize) then
        begin
          IsError:=True;
          ErrorMessage:='PNG LOADER: Cannot allocate output memory !';
          goto lblExit;
        end;

        OutDataMem:=DWORD(OutData);
      end;
      IDATMarker:
      begin
        InDataSize:=SwapEndian(Chunk.Size);

        if not mAllocMem(InData,InDataSize) then
        begin
          IsError:=True;
          ErrorMessage:='PNG LOADER: Cannot allocate input memory !';
          goto lblExit;
        end;

        if ffRead(FFile,InData,InDataSize) < InDataSize then
        begin
          IsError:=True;
          ErrorMessage:='PNG LOADER: IDAT chunk not read correctly !';
          goto lblExit;
        end;
      end;
      PLTEMarker:
      begin

      end;
      IENDMarker:
      begin
        Break;
      end;
     //   else
      //begin
      //  ffSeekInc(FFile,SwapEndian(Chunk.Size));
     // end;
    end; // case end
    //Inc(FilePos,SwapEndian(Chunk.Size)+$04); // Skip CRC
  end;

  //GetMem(OutData,OutDataSize);
  if not mAllocMem(OutData,OutDataSize) then
  Exit;
 (*
  mImage^.mData:=OutData;
  mImage^.Size:=OutDataSize;
  mImage^.Width:=Header.wWidth;
  mImage^.Height:=Header.wHeight;
  mImage^.PixelSize:=Header.bPixelSize;
*)
  lblExit:
  begin
    if FFile.Handle <> 0 then
    ffClose(FFile);

    if mImage <> nil then
    FreeImage(mImage);

    if InData <> nil then
    mFreeMem(InData);

    if OutData <> nil then
    mFreeMem(OutData);
  end;
end;


end.
