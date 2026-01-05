unit LameJPEGImage;

interface

uses
  Windows,VastImage,VastImageTypes;

procedure PrepareColorTables;

implementation

var
  ColorBlock : Array[$00..$3D] of DWORD;    // 8*8 * 4 = 256 (Width * Height * Pixel Size)

  //YCCTable : Array[$00000000..$001FFFFF] of DWORD;  // 8MB of memory
  //RGBTable : Array[$00000000..$001FFFFF] of DWORD;  // 8MB of memory
  YCCTable : Array[$00..$08] of Array[$00..$FF] of BYTE;  //
  //YCCTable :  Array[$00..$FF] of Array[$00..$FF] of Array[$00..$FF] of BYTE;  //


  //GTable : Array[$00..$FF] of DOUBLE;
  //RTable : Array[$00..$FF] of DOUBLE;


//TGAXMarker = DWORD(Byte('T') or (Byte('G') shl 8) or (Byte('A') shl 16) or (Byte('X') shl 24));
procedure PrepareColorTables;
var
  n,r,g,b:DWORD;
begin

  for n:=0 to 255 do
  begin
    YCCTable[0][n]:=Round(0.299 * n);
    YCCTable[1][n]:=Round(0.587 * n);
    YCCTable[2][n]:=Round(0.114 * n);

    YCCTable[3][n]:=Round(0.5 * n);
    YCCTable[4][n]:=Round(0.41874 * n);
    YCCTable[5][n]:=Round(0.0813 * n);

    YCCTable[6][n]:=Round(-0.1687 * n);
    YCCTable[7][n]:=Round(0.3313 * n);
    YCCTable[8][n]:=Round(0.5 * n);
  end;
  if YCCTable[0][0] > 0 then
  Halt(0);


(*
  for r:=0 to 127 do
  begin
    for g:=0 to 127 do
    begin
      for b:=0 to 127 do
      begin
        YCCTable[(r*128*128)+(g*128) + b + 0]:= Round(0.299 * R + 0.587 * G + 0.114 * B);
        YCCTable[(r*128*128)+(g*128) + b + 1]:= Round(-0.1687 * R - 0.3313 * G + 0.5 * B + 128);
        YCCTable[(r*128*128)+(g*128) + b + 2]:= Round(0.5 * R - 0.41874 * G - 0.0813 * B + 128);
      end;
    end;
*)
(*
  n:=0;
  for r:=0 to 255 do
  begin
    for g:=0 to 255 do
    begin
      for b:=0 to 255 do
      begin
        //Y  =      (0.257 * R) + (0.504 * G) + (0.098 * B) + 16
        //Cr = V =  (0.439 * R) - (0.368 * G) - (0.071 * B) + 128
        //Cb = U = -(0.148 * R) - (0.291 * G) + (0.439 * B) + 128
        //YCCTable[r][g][b][0]:=Round((0.257 * R) + (0.504 * G) + (0.098 * B) + 16);
        //YCCTable[r][g][b][1]:=Round((0.439 * R) - (0.368 * G) - (0.071 * B) + 128);
        //YCCTable[r][g][b][2]:=Round(-(0.148 * R) - (0.291 * G) + (0.439 * B) + 128);


        //YCCIncTable[r][g][b][0]:=Round(Frac(0.299 * R) + Frac(0.587 * G) + Frac(0.114 * B));
        //YCCIncTable[r][g][b][1]:=Round(Frac(0.5 * R) - Frac(0.41874 * G) - Frac(0.0813 * B) + 128);
        //YCCIncTable[r][g][b][2]:=Round(Frac(-0.1687 * R) - Frac(0.3313 * G) + Frac(0.5 * B) + 128);

        //YCCTable[r][g][b]:=Round(0.299 * R + 0.587 * G + 0.114 * B) - (Round(0.299 * R) + Round(0.587 * G) + Round(0.114 * B));
        //YCCTable[r][g][b]:=Round(-0.1687 * R - 0.3313 * G + 0.5 * B + 128) - (Round(-0.1687 * R) - Round(0.3313 * G) + Round(0.5 * B) + 128);
        //YCCTable[r][g][b]:=Round(0.5 * R - 0.41874 * G - 0.0813 * B + 128) - (Round(0.5 * R) - Round(0.41874 * G) - Round(0.0813 * B) + 128);
      end;
    end;
  end;
  if n > 0 then
  Halt(0);
  *)

end;

procedure PreProcessBlock;
begin
  ColorBlock[
end;

procedure SubSampleImage (var mInImage:PVastImage);
var
  dwYPos:DWORD;
  dwXPos:DWORD;
  dwYMaxPos:DWORD;
  dwXMaxPos:DWORD;
  //dwPixelSize:DWORD;
  //dwPixelPos:DWORD;
  dwScanLineMem:DWORD;
  dwInDataMem:DWORD;
  PixelTable:Array[0..3] of DWORD;
  dwScanLineSize:DWORD;
begin

  if mInImage^.dwPixelSize <> $20 then
  Exit;

  dwInDataMem:=DWORD(mInImage^.mData);
  //dwPixelSize:=mInImage^.dwPixelSize div $08;
  dwScanLineSize:= mInImage^.dwWidth * 4;
  dwXMaxPos:=mInImage^.dwWidth div $04;
  dwYMaxPos:=mInImage^.dwHeight div $04;
	for dwYPos:= 0 to dwYMaxPos - 1 do
  begin
		for dwXPos := 0 to dwXMaxPos - 1 do
    begin
      // Erase pixel table
      PixelTable[$00]:=$00;
      PixelTable[$01]:=$00;
      PixelTable[$02]:=$00;
      PixelTable[$03]:=$00;

      //// Load Pixels
      dwScanLineMem:=dwInDataMem;

      // ScanLine 1
      Inc(PixelTable[$00],PBYTE(dwScanLineMem+$00)^);
      Inc(PixelTable[$01],PBYTE(dwScanLineMem+$01)^);
      Inc(PixelTable[$02],PBYTE(dwScanLineMem+$02)^);
      Inc(PixelTable[$03],PBYTE(dwScanLineMem+$03)^);

      Inc(PixelTable[$00],PBYTE(dwScanLineMem+$04)^);
      Inc(PixelTable[$01],PBYTE(dwScanLineMem+$05)^);
      Inc(PixelTable[$02],PBYTE(dwScanLineMem+$06)^);
      Inc(PixelTable[$03],PBYTE(dwScanLineMem+$07)^);

      Inc(PixelTable[$00],PBYTE(dwScanLineMem+$08)^);
      Inc(PixelTable[$01],PBYTE(dwScanLineMem+$09)^);
      Inc(PixelTable[$02],PBYTE(dwScanLineMem+$0A)^);
      Inc(PixelTable[$03],PBYTE(dwScanLineMem+$0B)^);

      Inc(PixelTable[$00],PBYTE(dwScanLineMem+$0C)^);
      Inc(PixelTable[$01],PBYTE(dwScanLineMem+$0D)^);
      Inc(PixelTable[$02],PBYTE(dwScanLineMem+$0E)^);
      Inc(PixelTable[$03],PBYTE(dwScanLineMem+$0F)^);

      Inc(dwScanLineMem,dwScanLineSize);

      // ScanLine 2
      Inc(PixelTable[$00],PBYTE(dwScanLineMem+$00)^);
      Inc(PixelTable[$01],PBYTE(dwScanLineMem+$01)^);
      Inc(PixelTable[$02],PBYTE(dwScanLineMem+$02)^);
      Inc(PixelTable[$03],PBYTE(dwScanLineMem+$03)^);

      Inc(PixelTable[$00],PBYTE(dwScanLineMem+$04)^);
      Inc(PixelTable[$01],PBYTE(dwScanLineMem+$05)^);
      Inc(PixelTable[$02],PBYTE(dwScanLineMem+$06)^);
      Inc(PixelTable[$03],PBYTE(dwScanLineMem+$07)^);

      Inc(PixelTable[$00],PBYTE(dwScanLineMem+$08)^);
      Inc(PixelTable[$01],PBYTE(dwScanLineMem+$09)^);
      Inc(PixelTable[$02],PBYTE(dwScanLineMem+$0A)^);
      Inc(PixelTable[$03],PBYTE(dwScanLineMem+$0B)^);

      Inc(PixelTable[$00],PBYTE(dwScanLineMem+$0C)^);
      Inc(PixelTable[$01],PBYTE(dwScanLineMem+$0D)^);
      Inc(PixelTable[$02],PBYTE(dwScanLineMem+$0E)^);
      Inc(PixelTable[$03],PBYTE(dwScanLineMem+$0F)^);

      Inc(dwScanLineMem,dwScanLineSize);

      // ScanLine 3
      Inc(PixelTable[$00],PBYTE(dwScanLineMem+$00)^);
      Inc(PixelTable[$01],PBYTE(dwScanLineMem+$01)^);
      Inc(PixelTable[$02],PBYTE(dwScanLineMem+$02)^);
      Inc(PixelTable[$03],PBYTE(dwScanLineMem+$03)^);

      Inc(PixelTable[$00],PBYTE(dwScanLineMem+$04)^);
      Inc(PixelTable[$01],PBYTE(dwScanLineMem+$05)^);
      Inc(PixelTable[$02],PBYTE(dwScanLineMem+$06)^);
      Inc(PixelTable[$03],PBYTE(dwScanLineMem+$07)^);

      Inc(PixelTable[$00],PBYTE(dwScanLineMem+$08)^);
      Inc(PixelTable[$01],PBYTE(dwScanLineMem+$09)^);
      Inc(PixelTable[$02],PBYTE(dwScanLineMem+$0A)^);
      Inc(PixelTable[$03],PBYTE(dwScanLineMem+$0B)^);

      Inc(PixelTable[$00],PBYTE(dwScanLineMem+$0C)^);
      Inc(PixelTable[$01],PBYTE(dwScanLineMem+$0D)^);
      Inc(PixelTable[$02],PBYTE(dwScanLineMem+$0E)^);
      Inc(PixelTable[$03],PBYTE(dwScanLineMem+$0F)^);

      Inc(dwScanLineMem,dwScanLineSize);

      // ScanLine 4
      Inc(PixelTable[$00],PBYTE(dwScanLineMem+$00)^);
      Inc(PixelTable[$01],PBYTE(dwScanLineMem+$01)^);
      Inc(PixelTable[$02],PBYTE(dwScanLineMem+$02)^);
      Inc(PixelTable[$03],PBYTE(dwScanLineMem+$03)^);

      Inc(PixelTable[$00],PBYTE(dwScanLineMem+$04)^);
      Inc(PixelTable[$01],PBYTE(dwScanLineMem+$05)^);
      Inc(PixelTable[$02],PBYTE(dwScanLineMem+$06)^);
      Inc(PixelTable[$03],PBYTE(dwScanLineMem+$07)^);

      Inc(PixelTable[$00],PBYTE(dwScanLineMem+$08)^);
      Inc(PixelTable[$01],PBYTE(dwScanLineMem+$09)^);
      Inc(PixelTable[$02],PBYTE(dwScanLineMem+$0A)^);
      Inc(PixelTable[$03],PBYTE(dwScanLineMem+$0B)^);

      Inc(PixelTable[$00],PBYTE(dwScanLineMem+$0C)^);
      Inc(PixelTable[$01],PBYTE(dwScanLineMem+$0D)^);
      Inc(PixelTable[$02],PBYTE(dwScanLineMem+$0E)^);
      Inc(PixelTable[$03],PBYTE(dwScanLineMem+$0F)^);

      // Get average pixel value
      PixelTable[$00]:=PixelTable[$00] div $10;
      PixelTable[$01]:=PixelTable[$01] div $10;
      PixelTable[$02]:=PixelTable[$02] div $10;
      PixelTable[$03]:=PixelTable[$03] div $10;

      //// Save Pixels
      dwScanLineMem:=dwInDataMem;

      // ScanLine 1
      PBYTE(dwScanLineMem+$00)^:=PixelTable[$00];
      PBYTE(dwScanLineMem+$01)^:=PixelTable[$01];
      PBYTE(dwScanLineMem+$02)^:=PixelTable[$02];
      PBYTE(dwScanLineMem+$03)^:=PixelTable[$03];

      PBYTE(dwScanLineMem+$04)^:=PixelTable[$00];
      PBYTE(dwScanLineMem+$05)^:=PixelTable[$01];
      PBYTE(dwScanLineMem+$06)^:=PixelTable[$02];
      PBYTE(dwScanLineMem+$07)^:=PixelTable[$03];

      PBYTE(dwScanLineMem+$08)^:=PixelTable[$00];
      PBYTE(dwScanLineMem+$09)^:=PixelTable[$01];
      PBYTE(dwScanLineMem+$0A)^:=PixelTable[$02];
      PBYTE(dwScanLineMem+$0B)^:=PixelTable[$03];

      PBYTE(dwScanLineMem+$0C)^:=PixelTable[$00];
      PBYTE(dwScanLineMem+$0D)^:=PixelTable[$01];
      PBYTE(dwScanLineMem+$0E)^:=PixelTable[$02];
      PBYTE(dwScanLineMem+$0F)^:=PixelTable[$03];

      Inc(dwScanLineMem,dwScanLineSize);

      // ScanLine 2
      PBYTE(dwScanLineMem+$00)^:=PixelTable[$00];
      PBYTE(dwScanLineMem+$01)^:=PixelTable[$01];
      PBYTE(dwScanLineMem+$02)^:=PixelTable[$02];
      PBYTE(dwScanLineMem+$03)^:=PixelTable[$03];

      PBYTE(dwScanLineMem+$04)^:=PixelTable[$00];
      PBYTE(dwScanLineMem+$05)^:=PixelTable[$01];
      PBYTE(dwScanLineMem+$06)^:=PixelTable[$02];
      PBYTE(dwScanLineMem+$07)^:=PixelTable[$03];

      PBYTE(dwScanLineMem+$08)^:=PixelTable[$00];
      PBYTE(dwScanLineMem+$09)^:=PixelTable[$01];
      PBYTE(dwScanLineMem+$0A)^:=PixelTable[$02];
      PBYTE(dwScanLineMem+$0B)^:=PixelTable[$03];

      PBYTE(dwScanLineMem+$0C)^:=PixelTable[$00];
      PBYTE(dwScanLineMem+$0D)^:=PixelTable[$01];
      PBYTE(dwScanLineMem+$0E)^:=PixelTable[$02];
      PBYTE(dwScanLineMem+$0F)^:=PixelTable[$03];

      Inc(dwScanLineMem,dwScanLineSize);

      // ScanLine 3
      PBYTE(dwScanLineMem+$00)^:=PixelTable[$00];
      PBYTE(dwScanLineMem+$01)^:=PixelTable[$01];
      PBYTE(dwScanLineMem+$02)^:=PixelTable[$02];
      PBYTE(dwScanLineMem+$03)^:=PixelTable[$03];

      PBYTE(dwScanLineMem+$04)^:=PixelTable[$00];
      PBYTE(dwScanLineMem+$05)^:=PixelTable[$01];
      PBYTE(dwScanLineMem+$06)^:=PixelTable[$02];
      PBYTE(dwScanLineMem+$07)^:=PixelTable[$03];

      PBYTE(dwScanLineMem+$08)^:=PixelTable[$00];
      PBYTE(dwScanLineMem+$09)^:=PixelTable[$01];
      PBYTE(dwScanLineMem+$0A)^:=PixelTable[$02];
      PBYTE(dwScanLineMem+$0B)^:=PixelTable[$03];

      PBYTE(dwScanLineMem+$0C)^:=PixelTable[$00];
      PBYTE(dwScanLineMem+$0D)^:=PixelTable[$01];
      PBYTE(dwScanLineMem+$0E)^:=PixelTable[$02];
      PBYTE(dwScanLineMem+$0F)^:=PixelTable[$03];

      Inc(dwScanLineMem,dwScanLineSize);

      // ScanLine 4
      PBYTE(dwScanLineMem+$00)^:=PixelTable[$00];
      PBYTE(dwScanLineMem+$01)^:=PixelTable[$01];
      PBYTE(dwScanLineMem+$02)^:=PixelTable[$02];
      PBYTE(dwScanLineMem+$03)^:=PixelTable[$03];

      PBYTE(dwScanLineMem+$04)^:=PixelTable[$00];
      PBYTE(dwScanLineMem+$05)^:=PixelTable[$01];
      PBYTE(dwScanLineMem+$06)^:=PixelTable[$02];
      PBYTE(dwScanLineMem+$07)^:=PixelTable[$03];

      PBYTE(dwScanLineMem+$08)^:=PixelTable[$00];
      PBYTE(dwScanLineMem+$09)^:=PixelTable[$01];
      PBYTE(dwScanLineMem+$0A)^:=PixelTable[$02];
      PBYTE(dwScanLineMem+$0B)^:=PixelTable[$03];

      PBYTE(dwScanLineMem+$0C)^:=PixelTable[$00];
      PBYTE(dwScanLineMem+$0D)^:=PixelTable[$01];
      PBYTE(dwScanLineMem+$0E)^:=PixelTable[$02];
      PBYTE(dwScanLineMem+$0F)^:=PixelTable[$03];

      Inc(dwInDataMem,$10);
    end;  // for x
    dwInDataMem:=dwScanLineMem + $10;
  end; // for y
end;

end.
