unit VastJPGEncoder;

{$I VastImageSettings.inc}

interface

uses
  {$IFNDEF LIGHT_VERSION}
  VastYCbCrTables,
  {$ENDIF}
  VastImage, VastImageTypes, VastUtils, VastFile, VastMemory, SysUtils;

function SaveJPGImage(const FileName:String;var mImage:PVastImage):Boolean;
implementation
(*
var
  YRTable:Array[0..255] of INTEGER;
  YGTable:Array[0..255] of INTEGER;
  YBTable:Array[0..255] of INTEGER;
  CbRTable:Array[0..255] of INTEGER;
  CbGTable:Array[0..255] of INTEGER;
  CbBTable:Array[0..255] of INTEGER;
  CrRTable:Array[0..255] of INTEGER;
  CrGTable:Array[0..255] of INTEGER;
  CrBTable:Array[0..255] of INTEGER;


  YBlock:Array[0..63] of BYTE;
  CrBlock:Array[0..63] of BYTE;
  CbBlock:Array[0..63] of BYTE;
*)

var
  bIsError:BOOLEAN;
  mErrorMessage:PCHAR;

procedure ResetErrorState;
begin
  bIsError:=False;
  //EraseMem(mErrorMessage,256);
  mErrorMessage:=nil;
end;

procedure SetErrorState(const Msg:PCHAR);
begin
  bIsError:=True;
  mErrorMessage:=MSG;
end;
(*
procedure PrepareYCrCbTables ();
var
  R,G,B:WORD;
  FFile:TextFile;

  procedure WriteTable(const FileName:String;mTable:PDWORD);
  var
    n:WORD;
    //str:STRING;
  begin
    AssignFile(FFile,FileName);
    Rewrite(FFile);

    WriteLn(FFile,'  ' + FileName + ' : Array[$00..$FF] of INTEGER = ( ');

    Write(FFile, '		');
    for n:=0 to 255 do
    begin

      //str:=IntToHex(mTable^,8) + ',';
      Write(FFile,'$'+IntToHex(mTable^,8) + ',');
      Inc(mTable);

      if ((n+1) mod 8) = 0 then
      Write(FFile,#13+#10 + '		');
    end;
    WriteLn(FFile,');');
    CloseFile(FFile);
  end;
begin

  for R:=0 to 255 do
  begin
    YRTable[R]:=Round(((65536*0.299)+0.5)*R);
    CbRTable[R]:=Round(((65536*-0.16874)+0.5)*R);
    CrRTable[R]:=Round((32768)*R);
  end;

  for G:=0 to 255 do
  begin
    YGTable[G]:=Round(((65536*0.587)+0.5)*G);
    CbGTable[G]:=Round(((65536*-0.33126)+0.5)*G);
    CrGTable[G]:=Round(((65536*-0.41869)+0.5)*G);
  end;

  for B:=0 to 255 do
  begin
    YBTable[B]:=Round(((65536*0.114)+0.5)*B);
    CbBTable[B]:=Round((32768)*B);
    CrBTable[B]:=Round(((65536*-0.08131)+0.5)*B);
  end;
  WriteTable('YRTable',@YRTable[0]);
  WriteTable('CbRTable',@CbRTable[0]);
  WriteTable('CrRTable',@CrRTable[0]);

  WriteTable('YGTable',@YGTable[0]);
  WriteTable('CbGTable',@CbGTable[0]);
  WriteTable('CrGTable',@CrGTable[0]);

  WriteTable('YBTable',@YBTable[0]);
  WriteTable('CbBTable',@CbBTable[0]);
  WriteTable('CrBTable',@CrBTable[0]);
end;
*)


(*
void main_encoder()
{
 SWORD DCY=0,DCCb=0,DCCr=0; //DC coefficients used for differential encoding
 WORD xpos,ypos;
 for (ypos=0;ypos<Yimage;ypos+=8)
  for (xpos=0;xpos<Ximage;xpos+=8)
   {
    load_data_units_from_RGB_buffer(xpos,ypos);
    process_DU(YDU,fdtbl_Y,&DCY,YDC_HT,YAC_HT);
    process_DU(CbDU,fdtbl_Cb,&DCCb,CbDC_HT,CbAC_HT);
    process_DU(CrDU,fdtbl_Cb,&DCCr,CbDC_HT,CbAC_HT);
   }
}
*)

var
  YMCU:Array[0..63] of BYTE;
  CbMCU:Array[0..63] of BYTE;
  CrMCU:Array[0..63] of BYTE;

procedure ExtractBlock(dwScanLineMem:DWORD;dwScanLineSize:DWORD);
var
  //dwScanLine
  dwXPos:DWORD;
  dwYPos:DWORD;
  dwMCUIndex:DWORD;
  //dwRPixel,dwGPixel,dwBPixel:DWORD;
  bR,bG,bB:BYTE;
begin

  for dwYPos:=0 to 7 do
  begin
    for dwXPos:=0 to 7 do
    begin
      dwMCUIndex:=(dwYPos * 8) + dwXPos;
      //dwRPixel:=PBYTE(dwScanLineMem+$00)^;
      //dwGPixel:=PBYTE(dwScanLineMem+$01)^;
      //dwBPixel:=PBYTE(dwScanLineMem+$02)^;
      bR:=PBYTE(dwScanLineMem+$00)^;
      bG:=PBYTE(dwScanLineMem+$01)^;
      bB:=PBYTE(dwScanLineMem+$02)^;

    {$IFDEF LIGHT_VERSION}
      YMCU[dwMCUIndex]:=ClampByte(Round( 0.29900 * bR + 0.58700 * bG + 0.11400 * bB));
      CbMCU[dwMCUIndex]:=ClampByte(Round(-0.16874 * bR - 0.33126 * bG + 0.50000 * bB  + 128));
      CrMCU[dwMCUIndex]:=ClampByte(Round( 0.50000 * bR - 0.41869 * bG - 0.08131 * bB  + 128));
    {$ELSE}
      YMCU[dwMCUIndex]:= (((YRTable[bR] + YGTable[bG] + YBTable[bB]) shr $10));
      CbMCU[dwMCUIndex]:= (((CbRTable[bR] + CbGTable[bG] + CbBTable[bB]) shr $10) - 128);
      CrMCU[dwMCUIndex]:= (((CrRTable[bR] + CrGTable[bG] + CrBTable[bB]) shr $10) - 128);
    {$ENDIF}

      Inc(dwScanLineMem,3);
    end;
    Inc(dwScanLineMem,dwScanLineSize - (8 * 3));
  end;
end;

procedure SubSampleBlock4x4();
var
{$IFDEF LIGHT_VERSION}
  dwXPos,dwYPos:DWORD;
  dwAvgCbValue,dwAvgCrValue,dwMCUIndex,dwPixelIndex:DWORD;
{$ELSE}
  dwAvgValue:DWORD;
{$ENDIF}
begin
  {$IFDEF LIGHT_VERSION}
  for dwYPos:=0 to 3 do
  begin
    dwAvgCbValue:=0;
    dwAvgCrValue:=0;

    for dwXPos:=0 to 3 do
    begin
      // Well,little bit lame ? Maybe its possibible to do that in better way...
      // But there is no multiplications... check via debugger
      if dwYPos > 1 then
      dwMCUIndex:=32 + ((dwYPos-2) * 4) + (dwXPos * 8)
      else dwMCUIndex:=(dwYPos * 4) + (dwXPos * 8);

      for dwPixelIndex:=0 to 3 do
      begin
        Inc(dwAvgCbValue,CbMCU[dwMCUIndex+dwPixelIndex]);
        Inc(dwAvgCrValue,CrMCU[dwMCUIndex+dwPixelIndex]);
      end;
    end;

    dwAvgCbValue:=dwAvgCbValue shr $04; // div 16
    dwAvgCrValue:=dwAvgCrValue shr $04; // div 16

    for dwXPos:=0 to 3 do
    begin
      // Well,little bit lame ? Maybe its possibible to do that in better way...
      if dwYPos > 1 then
      dwMCUIndex:=32 + ((dwYPos-2) * 4) + (dwXPos * 8)
      else dwMCUIndex:=(dwYPos * 4) + (dwXPos * 8);

      for dwPixelIndex:=0 to 3 do
      begin
        CbMCU[dwMCUIndex+dwPixelIndex]:=dwAvgCbValue;
        CrMCU[dwMCUIndex+dwPixelIndex]:=dwAvgCrValue;
      end;
    end;
  end;
  {$ELSE}
//==============================
// First pass,process Cb
//==============================
  dwAvgValue:=0;
// First 4x4 block
  Inc(dwAvgValue,CbMCU[$00]);
  Inc(dwAvgValue,CbMCU[$01]);
  Inc(dwAvgValue,CbMCU[$02]);
  Inc(dwAvgValue,CbMCU[$03]);

  Inc(dwAvgValue,CbMCU[$08]);
  Inc(dwAvgValue,CbMCU[$09]);
  Inc(dwAvgValue,CbMCU[$0A]);
  Inc(dwAvgValue,CbMCU[$0B]);

  Inc(dwAvgValue,CbMCU[$10]);
  Inc(dwAvgValue,CbMCU[$11]);
  Inc(dwAvgValue,CbMCU[$12]);
  Inc(dwAvgValue,CbMCU[$13]);

  Inc(dwAvgValue,CbMCU[$18]);
  Inc(dwAvgValue,CbMCU[$19]);
  Inc(dwAvgValue,CbMCU[$1A]);
  Inc(dwAvgValue,CbMCU[$1B]);

  dwAvgValue:= dwAvgValue shr $04; // div 16

  CbMCU[$00]:=dwAvgValue;
  CbMCU[$01]:=dwAvgValue;
  CbMCU[$02]:=dwAvgValue;
  CbMCU[$03]:=dwAvgValue;

  CbMCU[$08]:=dwAvgValue;
  CbMCU[$09]:=dwAvgValue;
  CbMCU[$0A]:=dwAvgValue;
  CbMCU[$0B]:=dwAvgValue;

  CbMCU[$10]:=dwAvgValue;
  CbMCU[$11]:=dwAvgValue;
  CbMCU[$12]:=dwAvgValue;
  CbMCU[$13]:=dwAvgValue;

  CbMCU[$18]:=dwAvgValue;
  CbMCU[$19]:=dwAvgValue;
  CbMCU[$1A]:=dwAvgValue;
  CbMCU[$1B]:=dwAvgValue;

  dwAvgValue:=0;

// Second 4x4 block
  Inc(dwAvgValue,CbMCU[$04]);
  Inc(dwAvgValue,CbMCU[$05]);
  Inc(dwAvgValue,CbMCU[$06]);
  Inc(dwAvgValue,CbMCU[$07]);

  Inc(dwAvgValue,CbMCU[$0C]);
  Inc(dwAvgValue,CbMCU[$0D]);
  Inc(dwAvgValue,CbMCU[$0E]);
  Inc(dwAvgValue,CbMCU[$0F]);

  Inc(dwAvgValue,CbMCU[$14]);
  Inc(dwAvgValue,CbMCU[$15]);
  Inc(dwAvgValue,CbMCU[$16]);
  Inc(dwAvgValue,CbMCU[$17]);

  Inc(dwAvgValue,CbMCU[$1C]);
  Inc(dwAvgValue,CbMCU[$1D]);
  Inc(dwAvgValue,CbMCU[$1E]);
  Inc(dwAvgValue,CbMCU[$1F]);

  dwAvgValue:= dwAvgValue shr $04; // div 16

  CbMCU[$04]:=dwAvgValue;
  CbMCU[$05]:=dwAvgValue;
  CbMCU[$06]:=dwAvgValue;
  CbMCU[$07]:=dwAvgValue;

  CbMCU[$0C]:=dwAvgValue;
  CbMCU[$0D]:=dwAvgValue;
  CbMCU[$0E]:=dwAvgValue;
  CbMCU[$0F]:=dwAvgValue;

  CbMCU[$14]:=dwAvgValue;
  CbMCU[$15]:=dwAvgValue;
  CbMCU[$16]:=dwAvgValue;
  CbMCU[$17]:=dwAvgValue;

  CbMCU[$1C]:=dwAvgValue;
  CbMCU[$1D]:=dwAvgValue;
  CbMCU[$1E]:=dwAvgValue;
  CbMCU[$1F]:=dwAvgValue;

  dwAvgValue:=0;

// Third 4x4 block
  Inc(dwAvgValue,CbMCU[$20]);
  Inc(dwAvgValue,CbMCU[$21]);
  Inc(dwAvgValue,CbMCU[$22]);
  Inc(dwAvgValue,CbMCU[$23]);

  Inc(dwAvgValue,CbMCU[$28]);
  Inc(dwAvgValue,CbMCU[$29]);
  Inc(dwAvgValue,CbMCU[$2A]);
  Inc(dwAvgValue,CbMCU[$2B]);

  Inc(dwAvgValue,CbMCU[$30]);
  Inc(dwAvgValue,CbMCU[$31]);
  Inc(dwAvgValue,CbMCU[$32]);
  Inc(dwAvgValue,CbMCU[$33]);

  Inc(dwAvgValue,CbMCU[$38]);
  Inc(dwAvgValue,CbMCU[$39]);
  Inc(dwAvgValue,CbMCU[$3A]);
  Inc(dwAvgValue,CbMCU[$3B]);

  dwAvgValue:= dwAvgValue shr $04; // div 16

  CbMCU[$20]:=dwAvgValue;
  CbMCU[$21]:=dwAvgValue;
  CbMCU[$22]:=dwAvgValue;
  CbMCU[$23]:=dwAvgValue;

  CbMCU[$28]:=dwAvgValue;
  CbMCU[$29]:=dwAvgValue;
  CbMCU[$2A]:=dwAvgValue;
  CbMCU[$2B]:=dwAvgValue;

  CbMCU[$30]:=dwAvgValue;
  CbMCU[$31]:=dwAvgValue;
  CbMCU[$32]:=dwAvgValue;
  CbMCU[$33]:=dwAvgValue;

  CbMCU[$38]:=dwAvgValue;
  CbMCU[$39]:=dwAvgValue;
  CbMCU[$3A]:=dwAvgValue;
  CbMCU[$3B]:=dwAvgValue;

  dwAvgValue:=0;

// Fourth 4x4 block
  Inc(dwAvgValue,CbMCU[$24]);
  Inc(dwAvgValue,CbMCU[$25]);
  Inc(dwAvgValue,CbMCU[$26]);
  Inc(dwAvgValue,CbMCU[$27]);

  Inc(dwAvgValue,CbMCU[$2C]);
  Inc(dwAvgValue,CbMCU[$2D]);
  Inc(dwAvgValue,CbMCU[$2E]);
  Inc(dwAvgValue,CbMCU[$2F]);

  Inc(dwAvgValue,CbMCU[$34]);
  Inc(dwAvgValue,CbMCU[$35]);
  Inc(dwAvgValue,CbMCU[$36]);
  Inc(dwAvgValue,CbMCU[$37]);

  Inc(dwAvgValue,CbMCU[$3C]);
  Inc(dwAvgValue,CbMCU[$3D]);
  Inc(dwAvgValue,CbMCU[$3E]);
  Inc(dwAvgValue,CbMCU[$3F]);

  dwAvgValue:= dwAvgValue shr $04; // div 16

  CbMCU[$24]:=dwAvgValue;
  CbMCU[$25]:=dwAvgValue;
  CbMCU[$26]:=dwAvgValue;
  CbMCU[$27]:=dwAvgValue;

  CbMCU[$2C]:=dwAvgValue;
  CbMCU[$2D]:=dwAvgValue;
  CbMCU[$2E]:=dwAvgValue;
  CbMCU[$2F]:=dwAvgValue;

  CbMCU[$34]:=dwAvgValue;
  CbMCU[$35]:=dwAvgValue;
  CbMCU[$36]:=dwAvgValue;
  CbMCU[$37]:=dwAvgValue;

  CbMCU[$3C]:=dwAvgValue;
  CbMCU[$3D]:=dwAvgValue;
  CbMCU[$3E]:=dwAvgValue;
  CbMCU[$3F]:=dwAvgValue;

//==============================
// Second pass,process Cr
//==============================

  dwAvgValue:=0;

// First 4x4 block
  Inc(dwAvgValue,CrMCU[$00]);
  Inc(dwAvgValue,CrMCU[$01]);
  Inc(dwAvgValue,CrMCU[$02]);
  Inc(dwAvgValue,CrMCU[$03]);

  Inc(dwAvgValue,CrMCU[$08]);
  Inc(dwAvgValue,CrMCU[$09]);
  Inc(dwAvgValue,CrMCU[$0A]);
  Inc(dwAvgValue,CrMCU[$0B]);

  Inc(dwAvgValue,CrMCU[$10]);
  Inc(dwAvgValue,CrMCU[$11]);
  Inc(dwAvgValue,CrMCU[$12]);
  Inc(dwAvgValue,CrMCU[$13]);

  Inc(dwAvgValue,CrMCU[$18]);
  Inc(dwAvgValue,CrMCU[$19]);
  Inc(dwAvgValue,CrMCU[$1A]);
  Inc(dwAvgValue,CrMCU[$1B]);

  dwAvgValue:= dwAvgValue shr $04; // div 16

  CrMCU[$00]:=dwAvgValue;
  CrMCU[$01]:=dwAvgValue;
  CrMCU[$02]:=dwAvgValue;
  CrMCU[$03]:=dwAvgValue;

  CrMCU[$08]:=dwAvgValue;
  CrMCU[$09]:=dwAvgValue;
  CrMCU[$0A]:=dwAvgValue;
  CrMCU[$0B]:=dwAvgValue;

  CrMCU[$10]:=dwAvgValue;
  CrMCU[$11]:=dwAvgValue;
  CrMCU[$12]:=dwAvgValue;
  CrMCU[$13]:=dwAvgValue;

  CrMCU[$18]:=dwAvgValue;
  CrMCU[$19]:=dwAvgValue;
  CrMCU[$1A]:=dwAvgValue;
  CrMCU[$1B]:=dwAvgValue;

  dwAvgValue:=0;

// Second 4x4 block
  Inc(dwAvgValue,CrMCU[$04]);
  Inc(dwAvgValue,CrMCU[$05]);
  Inc(dwAvgValue,CrMCU[$06]);
  Inc(dwAvgValue,CrMCU[$07]);

  Inc(dwAvgValue,CrMCU[$0C]);
  Inc(dwAvgValue,CrMCU[$0D]);
  Inc(dwAvgValue,CrMCU[$0E]);
  Inc(dwAvgValue,CrMCU[$0F]);

  Inc(dwAvgValue,CrMCU[$14]);
  Inc(dwAvgValue,CrMCU[$15]);
  Inc(dwAvgValue,CrMCU[$16]);
  Inc(dwAvgValue,CrMCU[$17]);

  Inc(dwAvgValue,CrMCU[$1C]);
  Inc(dwAvgValue,CrMCU[$1D]);
  Inc(dwAvgValue,CrMCU[$1E]);
  Inc(dwAvgValue,CrMCU[$1F]);

  dwAvgValue:= dwAvgValue shr $04; // div 16

  CrMCU[$04]:=dwAvgValue;
  CrMCU[$05]:=dwAvgValue;
  CrMCU[$06]:=dwAvgValue;
  CrMCU[$07]:=dwAvgValue;

  CrMCU[$0C]:=dwAvgValue;
  CrMCU[$0D]:=dwAvgValue;
  CrMCU[$0E]:=dwAvgValue;
  CrMCU[$0F]:=dwAvgValue;

  CrMCU[$14]:=dwAvgValue;
  CrMCU[$15]:=dwAvgValue;
  CrMCU[$16]:=dwAvgValue;
  CrMCU[$17]:=dwAvgValue;

  CrMCU[$1C]:=dwAvgValue;
  CrMCU[$1D]:=dwAvgValue;
  CrMCU[$1E]:=dwAvgValue;
  CrMCU[$1F]:=dwAvgValue;

  dwAvgValue:=0;

// Third 4x4 block
  Inc(dwAvgValue,CrMCU[$20]);
  Inc(dwAvgValue,CrMCU[$21]);
  Inc(dwAvgValue,CrMCU[$22]);
  Inc(dwAvgValue,CrMCU[$23]);

  Inc(dwAvgValue,CrMCU[$28]);
  Inc(dwAvgValue,CrMCU[$29]);
  Inc(dwAvgValue,CrMCU[$2A]);
  Inc(dwAvgValue,CrMCU[$2B]);

  Inc(dwAvgValue,CrMCU[$30]);
  Inc(dwAvgValue,CrMCU[$31]);
  Inc(dwAvgValue,CrMCU[$32]);
  Inc(dwAvgValue,CrMCU[$33]);

  Inc(dwAvgValue,CrMCU[$38]);
  Inc(dwAvgValue,CrMCU[$39]);
  Inc(dwAvgValue,CrMCU[$3A]);
  Inc(dwAvgValue,CrMCU[$3B]);

  dwAvgValue:= dwAvgValue shr $04; // div 16

  CrMCU[$20]:=dwAvgValue;
  CrMCU[$21]:=dwAvgValue;
  CrMCU[$22]:=dwAvgValue;
  CrMCU[$23]:=dwAvgValue;

  CrMCU[$28]:=dwAvgValue;
  CrMCU[$29]:=dwAvgValue;
  CrMCU[$2A]:=dwAvgValue;
  CrMCU[$2B]:=dwAvgValue;

  CrMCU[$30]:=dwAvgValue;
  CrMCU[$31]:=dwAvgValue;
  CrMCU[$32]:=dwAvgValue;
  CrMCU[$33]:=dwAvgValue;

  CrMCU[$38]:=dwAvgValue;
  CrMCU[$39]:=dwAvgValue;
  CrMCU[$3A]:=dwAvgValue;
  CrMCU[$3B]:=dwAvgValue;

  dwAvgValue:=0;

// Fourth 4x4 block
  Inc(dwAvgValue,CrMCU[$24]);
  Inc(dwAvgValue,CrMCU[$25]);
  Inc(dwAvgValue,CrMCU[$26]);
  Inc(dwAvgValue,CrMCU[$27]);

  Inc(dwAvgValue,CrMCU[$2C]);
  Inc(dwAvgValue,CrMCU[$2D]);
  Inc(dwAvgValue,CrMCU[$2E]);
  Inc(dwAvgValue,CrMCU[$2F]);

  Inc(dwAvgValue,CrMCU[$34]);
  Inc(dwAvgValue,CrMCU[$35]);
  Inc(dwAvgValue,CrMCU[$36]);
  Inc(dwAvgValue,CrMCU[$37]);

  Inc(dwAvgValue,CrMCU[$3C]);
  Inc(dwAvgValue,CrMCU[$3D]);
  Inc(dwAvgValue,CrMCU[$3E]);
  Inc(dwAvgValue,CrMCU[$3F]);

  dwAvgValue:= dwAvgValue shr $04; // div 16

  CrMCU[$24]:=dwAvgValue;
  CrMCU[$25]:=dwAvgValue;
  CrMCU[$26]:=dwAvgValue;
  CrMCU[$27]:=dwAvgValue;

  CrMCU[$2C]:=dwAvgValue;
  CrMCU[$2D]:=dwAvgValue;
  CrMCU[$2E]:=dwAvgValue;
  CrMCU[$2F]:=dwAvgValue;

  CrMCU[$34]:=dwAvgValue;
  CrMCU[$35]:=dwAvgValue;
  CrMCU[$36]:=dwAvgValue;
  CrMCU[$37]:=dwAvgValue;

  CrMCU[$3C]:=dwAvgValue;
  CrMCU[$3D]:=dwAvgValue;
  CrMCU[$3E]:=dwAvgValue;
  CrMCU[$3F]:=dwAvgValue;
  {$ENDIF}
end;

function SaveJPGImage(const FileName:String;var mImage:PVastImage):Boolean;
label
  lblExit;
var
  FFile:TVastFile;

  mInData:POINTER;
  dwInDataMem:DWORD;
  dwInDataSize:DWORD;

  mOutData:POINTER;
  dwOutDataMem:DWORD;
  dwOutDataSize:DWORD;

  dwInDataMemMax:DWORD;

  bIsCompressed:BOOLEAN;
  bIsPaletteUsed:BOOLEAN;

  dwPaletteMem:DWORD;
  dwPaletteSize:DWORD;

  dwAlphaChannelSize:DWORD;
  // byte position and size of pixel
  dwPixelPos:DWORD;
  dwPixelSize:DWORD;
  dwPixelMem:DWORD;
  // RLE Packet index and size
  dwIndex:DWORD;
  dwPacketSize:DWORD;

  dwChannelIndex,dwChannelCount:DWORD;

  dwWidth:DWORD;
  dwHeight:DWORD;

  dwQTYIndex:DWORD;
  dwQTCIndex:DWORD;

  dwHTDCIndex:DWORD;
  dwHTACIndex:DWORD;

  //HTDC81:Array[0..63] of BYTE;
  //HTDC82:Array[0..63] of BYTE;
  //HTDC81:Array[0..63] of BYTE;

  // Pointers to quantization tables in memory
  QT:Array[0..3] of DWORD;
  // Pointers to huffman tables in memory
  HTDC:Array[0..3] of DWORD;
  HTAC:Array[0..3] of DWORD;

  //dwMarker:DWORD;
  dwSegmentSize:DWORD;
  dwScanLineSize:DWORD;
begin
  Result:=False;

  ResetErrorState;

  if not IsImageSet(mImage) then
  begin
    SetErrorState('JPG SAVER: No image to save !');
    Exit;
  end;

  if not EraseMem(FFile,SizeOf(TVastFile)) then
  Exit;  // Fatal Error

  if not ffCreate(FFile,FileName) then
  begin
    SetErrorState('JPG SAVER: Cannot create output file !');
    Exit;
  end;

  dwInDataMem:=DWORD(Image^.Data);
  dwInDataSize:=Image^.dwSize;

  dwScanLineSize:=(mImage^.dwWidth * mImage^.dwPixelSize) div 8;
  ExtractBlock(dwInDataMem,dwScanLineSize);
  SubSampleBlock4x4();

  // Get maximum position where we can seek
  dwInDataMemMax:=dwInDataMem + dwInDataSize;
  while dwInDataMem < dwInDataMemMax - 1 do
  begin

  end;


  lblExit:
  begin
    if FFile.dwHandle <> 0 then
    ffClose(FFile);

    if mImage <> nil then
    FreeImage(mImage);

    if mInData <> nil then
    mFreeMem(mInData);

    if mOutData <> nil then
    mFreeMem(mOutData);
  end;
end;

end.
