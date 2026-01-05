unit VastImageEffect;

interface

uses
  VastImage,VastImageTypes,VastUtils;

type
  TKernelFilter3x3 = Array[0..2] of Array[0..2] of SMALLINT;

const
(*
  BlurFilter:TKernelFilter3x3=(
    (  -1,  -1,  -1),
    (  -1,   1,  -1),
    (  -1,  -1,  -1)
  );

  SharpFilter:TKernelFilter3x3=(
    (  -5,  -5,  -5),
    (  -5, 160,  -5),
    (  -5,  -5,  -5)
  );

  EdgeFilter:TKernelFilter3x3=(
    (  -1,  -1,  -1),
    (  -1,   8,  -1),
    (  -1,  -1,  -1)
  );

  EmbossFilter:TKernelFilter3x3=(
    (-100,   0,   0),
    (   0,   0,   0),
    (   0,   0, 100)
  );

  Enhance3DFilter:TKernelFilter3x3=(
    (-100,   5,   5),
    (   5,   5,   5),
    (   5,   5, 100)
  );

  TVImageFilter:TKernelFilter3x3=(
    (  50,  50,  50),
    (  50,  50,  50),
    (  50,  50,  50)
  );


  TestFilter:TKernelFilter3x3=(
    (  1,  1,  1),
    (  0,   0,  0),
    (  -1,  -1,  -1)
  );
*)
  AverageFilter:TKernelFilter3x3=(
    (  1,  1,  1),
    (  1,  1,  1),
    (  1,  1,  1)
  );

  GaussianFilter:TKernelFilter3x3=(
    (  1,  2,  1),
    (  2,  4,  2),
    (  1,  2,  1)
  );

  SobelHorizontalFilter:TKernelFilter3x3=(
    (  -1,  0,  1),
    (  -2,  0,  2),
    (  -1,  0,  1)
  );

  SobelVecticalFilter:TKernelFilter3x3=(
    (  1,  2,  1),
    (  0,  0,  0),
    (  -1,  -2,  -1)
  );

  PrewittHorizontalFilter:TKernelFilter3x3=(
    (  1,  1,  1),
    (  0,  0,  0),
    (  -1,  -1,  -1)
  );

  PrewittVerticalFilter:TKernelFilter3x3=(
    (  -1,  0, 1),
    (  -1,  0, 1),
    (  -1,  0, 1)
  );

  KirshHorizontalFilter:TKernelFilter3x3=(
    (  5,  5,  5),
    (  -3,  0,  -3),
    (  -3,  -3,  -3)
  );

  KirshVerticalFilter:TKernelFilter3x3=(
    (  5,  -3, -3),
    (  5,  0, -3),
    (  5,  -3, -3)
  );

  LaplaceFilter:TKernelFilter3x3=(
    (  -1,  -1,  -1),
    (  -1,  8,  -1),
    (  -1,  -1,  -1)
  );

  SharpenFilter:TKernelFilter3x3=(
    (  -1,  -1,  -1),
    (  -1,  9,  -1),
    (  -1,  -1,  -1)
  );

  EdgeEnhanceFilter:TKernelFilter3x3=(
    (  -1,  -2,  -1),
    (  -2,  16,  -2),
    (  -1,  -2,  -1)
  );

  TraceControurFilter:TKernelFilter3x3=(
    (  -6,  -6,  -2),
    (  -1,  32,  -1),
    (  -6,  -2,  -6)
  );

  NegativeFilter:TKernelFilter3x3=(
    (  0,  0,  0),
    (  0, -1,  0),
    (  0,  0,  0)
  );

  EmbossFilter:TKernelFilter3x3=(
    (  2,  0,  0),
    (  0, -1,  0),
    (  0,  0,  -1)
  );

function ApplyKernelFilter3x3(var InImage:PVastImage;const KernelFilter:TKernelFilter3x3):Boolean;

implementation


function ApplyKernelFilter3x3(var InImage:PVastImage;const KernelFilter:TKernelFilter3x3):Boolean;
var
  PixelTable:Array[0..3] of INTEGER;
  InDataMem:DWORD;
  //dwPixelIndex:DWORD;
  //dwPixelCount:DWORD;
  PixelPos,PixelSize:DWORD;
  ScanLineMem:DWORD;
  ScanLineSize:DWORD;
  YPos,YMaxPos:DWORD;
  XPos,XMaxPos:DWORD;
  KernelXPos,KernelYPos:DWORD;
  KernelXSize,KernelYSize:DWORD;
  FilterFactor:INTEGER;
begin
  Result:=False;
  if not IsImageSet(InImage) then
  Exit;

  PixelSize:=InImage^.PixelSize div 8;
  if PixelSize < 3 then
  Exit;

  ScanLineSize:= InImage^.Width * PixelSize;

  InDataMem:=DWORD(InImage^.Data);

  KernelXSize:=3;
  KernelYSize:=3;

  FilterFactor:=0;
  for KernelYPos:=0 to KernelYSize - 1 do
  begin
    for KernelXPos:=0 to KernelXSize - 1 do
    begin
      Inc(FilterFactor,KernelFilter[KernelYPos,KernelXPos]);
    end;
  end;
  if FilterFactor = 0 then
  FilterFactor:=1;

  XMaxPos:=InImage^.Width;
  YMaxPos:=InImage^.Height;
	for YPos:= 0 to (YMaxPos - KernelYSize) - 1 do
  begin
		for XPos:= 0 to (XMaxPos - KernelXSize) - 1 do
    begin
      PixelTable[0]:=0;
      PixelTable[1]:=0;
      PixelTable[2]:=0;
      PixelTable[3]:=0;

      ScanLineMem:=InDataMem;
      for KernelYPos:=0 to KernelYSize - 1 do
      begin
        for KernelXPos:=0 to KernelXSize - 1 do
        begin
          for PixelPos:=0 to PixelSize - 1 do
          begin
            Inc(PixelTable[PixelPos],PBYTE(ScanLineMem + PixelPos)^ * KernelFilter[KernelYPos][KernelXPos]);
          end; // PixelPos
          Inc(ScanLineMem,PixelSize);

        end; // KernelXPos
        Inc(ScanLineMem,ScanLineSize - (KernelXSize * PixelSize));
      end; //  KernelYPos

      // Set output pixel
      for PixelPos:=0 to PixelSize - 1 do
      begin
        PBYTE(InDataMem + PixelPos)^:=ClampBYTE(PixelTable[PixelPos] div FilterFactor);
      end; // PixelPos

      Inc(InDataMem,PixelSize);
    end;
    //InDataMem:=ScanLineMem + PixelPos;
  end;

end;

end.
