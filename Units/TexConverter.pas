unit TexConverter;


interface

uses
  Windows,SysUtils,SharedFunc,SharedTypes,Imaging,ImagingTypes;

const
 TexRecID = LongWord(Byte('T') or (Byte('e') shl 8) or (Byte('X') shl 16) or
    (Byte('R') shl 24));
type
  TTexExt = (xUNK=0,xPNG=1,xJPG=2,xTGA=3,xDDS=4,xBMP=5);

  TTexOption = (xSaveTexList,xSaveAlphaList,xSaveTexRecData,xAlphaScan,xAlphaSplit,xAlphaMove,xAlphaCopy,xDelSourceFile,xDelCubeMap,xDelVolTexture,xDelMipMaps,xEnableRLE);
  TTexOptionSet = set of TTexOption;

  TTexFilter = Packed Record
    SourceExt:TTexExt;
    TargetExt:TTexExt;
  end;
  TTexFilterArr = Array of TTexFilter;

  TTexRecHeader = Packed Record
    ID:LongWord;
    Count:LongWord;
  end;

  TTexRecDataInfo = Packed Record
    // TGA,PNG,JPG Usage
    CompLvl:Byte;
    //PNG Only
    ProgMode:Byte;
    PreFilter:Byte;
    // DDS Only
    MipMaps:Byte;
    // For DDS CubeMap
    CubeMap:Byte;
    Faces:Byte;
    // For DDX Volume Texture
    VolumeTex:Byte;
    Slices:Byte;
  end;

  TTexRecData = Packed Record
    TexSourceExt:TTexExt;
    TexTargetExt:TTexExt;
    TexHasAlpha:Byte;
    TexFormat:Byte;
    TexDataInfo:TTexRecDataInfo;
    TexName:String[255];
  end;

  TTexRecDataArr = Array of TTexRecData;

  TTexConverter = Class (TObject)
   private
    TexOptions:TTexOptionSet;
    TexMsgBlue:TMsgSender;
    TexMsgRed:TMsgSender;
    TexFilter:TTexFilterArr;
    TexFilterLen:LongWord;

    TexRecData:TTexRecDataArr;
    TexRecDataLen:LongWord;
    TexRecDataConv:LongWord;
    TexRecDataPath:ShortString;

    TexList:TFileList;
    TexListLen:LongWord;

    AlphaList:TFileList;
    AlphaListLen:LongWord;
    AlphaListPath:ShortString;

    AlphaMask:ByteArray;
    AlphaMaskLen:LongWord;
    AlphaMaskIndex:LongWord;

    FMinTexSize:LongWord;
    FInFolder:ShortString;
    FOutFolder:ShortString;
    FExtraFolder:ShortString;
    FJPGCompLvl:LongWord;
    FPNGCompLvl:LongWord;

    procedure AddToTexRecData (const Name:ShortString;const FilterIndex:LongWord);
    procedure DelTexRecData (const Index:LongWord);
    procedure AddToTexList (const FileName:ShortString);
    procedure AddToAlphaList (const FileName:ShortString);

    function DelPath (const FileName,Path:ShortString):ShortString;
    function GetNonAlphaFormat (const ImageFormat:TImageFormat):TImageFormat;
    function IsAlphaFormat (const ImageFormat:TImageFormat):boolean;
    function IsSpecialFormat (const ImageFormat:TImageFormat):boolean;

    procedure InitAlphaMask (const Size:LongWord);
    procedure FreeAlphaMask;
    procedure SaveAlphaMask (const FileName:ShortString);
    procedure AddAlphaMaskByte (const Value:Byte);

    procedure SendMsgBlue (const Msg:ShortString);
    procedure SendMsgRed (const Msg:ShortString);
    procedure SearchInt (const Folder:ShortString);
   public
    constructor Create;
    destructor Destroy;

    property TexFound:LongWord read TexListLen;
    property TexConverted:LongWord read TexRecDataConv;

    procedure Search;
    function Convert (const Index:LongWord):boolean;

    procedure AddTexFilter (const SourceExt,TargetExt:ShortString);
    procedure DelTexFilter (const Index:LongWord);
    function IsTexFilterSet (const SourceExt,TargetExt:ShortString):boolean;

    procedure SetMsgSenderBlue(const MsgSender:TMsgSender);
    procedure SetMsgSenderRed(const MsgSender:TMsgSender);
    procedure SetMinTexSize (const Value:LongWord);
    procedure SetSourceFolder (const Folder:ShortString);
    procedure SetTargetFolder (const Folder:ShortString);
    procedure SetExtraFolder (const Folder:ShortString);
    procedure SetJPGCompLvl (const Value:LongWord);
    procedure SetPNGCompLvl (const Value:LongWord);

    procedure SetAlphaListPath (const FileName:ShortString);
    procedure SetTexRecDataPath (const FileName:ShortString);

    function IsTexOptionSet (const TexOption:TTexOption):boolean;
    procedure AddTexOption (const TexOption:TTexOption);
    procedure DelTexOption (const TexOption:TTexOption);
    procedure EnableTexOption (const TexOption:TTexOption;const Enabled:boolean);
    procedure ResetTexOptions();
    procedure SaveTexRecData;
    procedure SaveAlphaList;
    function DeleteLoaded:LongWord;

    procedure FreeAndNil;
    procedure Reset;
  end;
    function TexExtToStr(const TexExt:TTexExt):ShortString;
    function StrToTexExt (const Str:ShortString):TTexExt;

implementation

procedure TTexConverter.ResetTexOptions();
begin
  TexOptions:=[];
end;

function TTexConverter.DeleteLoaded:LongWord;
var
  i,n:LongWord;
begin
  n:=0;
  for i := 0 to TexListLen - 1 do
  begin
    if DeleteFile(TexList[i]) then
    inc(n);
  end;
  Result:=n;
    //SendMsgRed('ERROR(103): ' + TexList[Index]);
end;

procedure TTexConverter.SendMsgBlue (const Msg:ShortString);
begin
  TexMsgBlue(Msg);
end;

procedure TTexConverter.SendMsgRed (const Msg:ShortString);
begin
  TexMsgRed(Msg);
end;

procedure TTexConverter.SetMsgSenderBlue(const MsgSender: TMsgSender);
begin
  TexMsgBlue:=MsgSender;
end;

procedure TTexConverter.SetMsgSenderRed(const MsgSender: TMsgSender);
begin
  TexMsgRed:=MsgSender;
end;

procedure TTexConverter.Reset;
begin
    TexOptions:=[];
    TexMsgBlue:=nil;
    TexMsgRed:=nil;

    SetLength(TexRecData,0);
    TexRecDataLen:=0;
    TexRecDataConv:=0;
    TexRecDataPath:='';

    SetLength(TexList,0);
    TexListLen:=0;

    SetLength(AlphaList,0);
    AlphaListLen:=0;
    AlphaListPath:='';

    SetLength(AlphaMask,0);
    AlphaMaskLen:=0;
    AlphaMaskIndex:=0;

    FMinTexSize:=0;
    FInFolder:='';
    FOutFolder:='';
    FExtraFolder:='';
    FJPGCompLvl:=0;
    FPNGCompLvl:=0;
end;

procedure TTexConverter.FreeAndNil;
begin
  SetLength(TexFilter,0);
  TexFilterLen:=0;
  Reset;
end;

constructor TTexConverter.Create;
begin
  inherited Create;
  FreeAndNil;
end;

destructor TTexConverter.Destroy;
begin
  FreeAndNil;
  inherited Destroy;
end;

procedure TTexConverter.AddTexFilter (const SourceExt,TargetExt:ShortString);
begin
  inc (TexFilterLen);
  if Length(TexFilter)<TexFilterLen then
  SetLength(TexFilter,TexFilterLen+DefArrayInc);

  TexFilter[TexFilterLen-1].SourceExt:=StrToTexExt(SourceExt);
  TexFilter[TexFilterLen-1].TargetExt:=StrToTexExt(TargetExt);
end;

procedure TTexConverter.DelTexFilter (const Index:LongWord);
var
  i:LongWord;
begin
  if TexFilterLen=0 then
  Exit;

  for i := Index to TexFilterLen-1 do
  TexFilter[i]:=TexFilter[i+1];
  dec (TexFilterLen);
end;

function TTexConverter.IsTexFilterSet (const SourceExt,TargetExt:ShortString):boolean;
var
  i,j:LongWord;
begin
  Result:=False;
  if TexFilterLen=0 then
  Exit;

  for i := 0 to TexFilterLen - 1 do
  begin
    if (StrToTexExt(SourceExt)=TexFilter[i].SourceExt) and (StrToTexExt(TargetExt)=TexFilter[i].TargetExt) then
    begin
      Result:=True;
      Exit;
    end;
  end;
end;

function TexExtToStr(const TexExt:TTexExt):ShortString;
begin
  case TexExt of
    xPNG: Result:='PNG';
    xJPG: Result:='JPG';
    xTGA: Result:='TGA';
    xDDS: Result:='DDS';
    xBMP: Result:='BMP';
  end;
end;

function StrToTexExt (const Str:ShortString):TTexExt;
begin
  if Str='PNG' then
  Result:=xPNG
    else
  if Str='JPG' then
  Result:=xJPG
    else
  if Str='TGA' then
  Result:=xTGA
    else
  if Str='DDS' then
  Result:=xDDS
    else
  if Str='BMP' then
  Result:=xBMP
  else
  Result:=xUNK;
end;

procedure TTexConverter.AddTexOption (const TexOption:TTexOption);
begin
  Include (TexOptions,TexOption);
end;

procedure TTexConverter.DelTexOption (const TexOption:TTexOption);
begin
  Exclude (TexOptions,TexOption);
end;

procedure TTexConverter.EnableTexOption (const TexOption:TTexOption;const Enabled:boolean);
begin
  if Enabled then
  Include (TexOptions,TexOption)
  else
  Exclude (TexOptions,TexOption);
end;

function TTexConverter.IsTexOptionSet (const TexOption:TTexOption):boolean;
begin
  Result:=TexOption in TexOptions;
end;

procedure TTexConverter.AddToTexList (const FileName:ShortString);
begin
  inc(TexListLen);
  if Length(TexList)<TexListLen then
  SetLength(TexList,TexListLen+DefArrayInc);

  TexList[TexListLen-1]:=FileName;
end;

procedure TTexConverter.AddToAlphaList (const FileName:ShortString);
begin
  inc(AlphaListLen);
  if Length(AlphaList)<AlphaListLen then
  SetLength(AlphaList,AlphaListLen+DefArrayInc);

  AlphaList[AlphaListLen-1]:=FileName;
end;

procedure TTexConverter.AddToTexRecData (const Name:ShortString;const FilterIndex:LongWord);
begin
  inc(TexRecDataLen);
  if Length(TexRecData)<TexRecDataLen then
  SetLength(TexRecData,TexRecDataLen+DefArrayInc);

  FillChar(TexRecData[TexRecDataLen-1],SizeOf(TTexRecData),$00);
  with TexRecData[TexRecDataLen-1] do
  begin
    TexName:=Copy(Name,0,Length(Name)-DefExtLen);
    TexSourceExt:=TexFilter[FilterIndex].SourceExt;
    TexTargetExt:=TexFilter[FilterIndex].TargetExt;
  end;
end;

procedure TTexConverter.DelTexRecData(const Index: Cardinal);
var
  i:LongWord;
begin
  if TexRecDataLen=0 then
  Exit;

  for i := Index to TexRecDataLen - 1 do
  begin
    TexRecData[i]:=TexRecData[i+1];
  end;
  dec (TexRecDataLen);
end;


procedure TTexConverter.SetMinTexSize (const Value:LongWord);
begin
  FMinTexSize:=Value;
end;

procedure TTexConverter.Search;
begin
  SendMsgBlue('Searching started!');
  SearchInt (FInFolder);
  SendMsgRed(IntToStr(TexRecDataLen) + ' files found...');
end;

function TTexConverter.DelPath (const FileName,Path:ShortString):ShortString;
begin
  Result:=Copy(FileName,Length(Path)+1,Length(FileName)-Length(Path));
end;

procedure TTexConverter.SearchInt(const Folder:ShortString);
var
  Found: LongWord;
  SRec: TSearchRec;
  i:LongWord;
begin
  try
    Found:=FindFirst(Folder+'*.*',faAnyFile,SRec);
    while Found=0 do
    begin
      if (SRec.Attr and faDirectory = faDirectory) and (not ((SRec.Name = '..') or (SRec.Name = '.')))  then
      SearchInt(Folder+SRec.Name+'\')
    else
      begin
        for i:=0 to TexFilterLen - 1 do
        begin
          if (('.'+TexExtToStr(TexFilter[i].SourceExt))=UpperCase(ExtractFileExt(SRec.Name))) and (SRec.Size>=FMinTexSize) then
          begin
            AddToTexList (Folder+SRec.Name);
            AddToTexRecData (DelPath(Folder+SRec.Name,FInFolder),i);
          end;
        end;
      end;
    Found:=FindNext(SRec);
    end;
  finally
    FindClose(SRec)
  end;
end;

function TTexConverter.IsAlphaFormat (const ImageFormat:TImageFormat):boolean;
begin
  Result:=False;
  case ImageFormat of
    ifA8Gray8: Result:=True;
    ifA16Gray16: Result:=True;
    ifA1R5G5B5: Result:=True;
    ifA4R4G4B4: Result:=True;
    ifA8R8G8B8: Result:=True;
    ifA16R16G16B16: Result:=True;
    ifA16B16G16R16: Result:=True;
    ifA32R32G32B32F: Result:=True;
    ifA32B32G32R32F: Result:=True;
    ifA16R16G16B16F: Result:=True;
    ifA16B16G16R16F: Result:=True;
    ifDXT1: Result:=True;
    ifDXT3: Result:=True;
    ifDXT5: Result:=True;
    ifBTC: Result:=True;
  end;
end;

function TTexConverter.IsSpecialFormat (const ImageFormat:TImageFormat):boolean;
begin
  Result:=False;
  case ImageFormat of
    ifDXT1: Result:=True;
    ifDXT3: Result:=True;
    ifDXT5: Result:=True;
    ifBTC: Result:=True;
  end;
end;

function TTexConverter.GetNonAlphaFormat (const ImageFormat:TImageFormat):TImageFormat;
begin
  case ImageFormat of
    ifA8Gray8: Result:=ifGray8;
    ifA16Gray16: Result:=ifGray16;
    ifA1R5G5B5: Result:=ifR5G6B5 ;
    ifA4R4G4B4: Result:=ifR5G6B5;
    //ifX1R5G5B5: Result:=ifR5G6B5;
    //ifX4R4G4B4: Result:=ifR5G6B5;
    ifA8R8G8B8: Result:=ifR8G8B8;
    //ifX8R8G8B8: Result:=ifR8G8B8;
    //ifR16G16B16: ;
    ifA16R16G16B16: Result:=ifR16G16B16;
    ifA16B16G16R16: Result:=ifB16G16R16;
    ifDXT1: Result:=ifR8G8B8;
    ifDXT3: Result:=ifR8G8B8;
    ifDXT5: Result:=ifR8G8B8;
    ifBTC: Result:=ifR8G8B8;
    else
    Result:=ImageFormat;
  end;
end;

procedure TTexConverter.InitAlphaMask (const Size:LongWord);
begin
  AlphaMaskLen:=Size;
  AlphaMaskIndex:=0;
  SetLength(AlphaMask,AlphaMaskLen);
end;

procedure TTexConverter.FreeAlphaMask;
begin
  SetLength(AlphaMask,0);
  AlphaMaskLen:=0;
  AlphaMaskIndex:=0;
end;

procedure TTexConverter.SaveAlphaMask (const FileName:ShortString);
begin
  //if AlphaMask<>nil then
  if AlphaMaskLen>0 then
  WriteBuffer(FileName,AlphaMask[0],AlphaMaskLen);
end;

procedure TTexConverter.AddAlphaMaskByte (const Value:Byte);
begin
  AlphaMask[AlphaMaskIndex]:=Value;
  inc(AlphaMaskIndex);
end;

procedure TTexConverter.SetJPGCompLvl (const Value:LongWord);
begin
  FJPGCompLvl:=Value;
end;

procedure TTexConverter.SetPNGCompLvl (const Value:LongWord);
begin
  FPNGCompLvl:=Value;
end;

procedure TTexConverter.SetExtraFolder(const Folder: ShortString);
begin
  FExtraFolder:=Folder;
end;

procedure TTexConverter.SetSourceFolder (const Folder:ShortString);
begin
  FInFolder:=Folder;
end;

procedure TTexConverter.SetTargetFolder (const Folder:ShortString);
begin
  FOutFolder:=Folder;
end;
(*
function TTexConverter.Convert(const Index:LongWord):boolean;
var
  ImgArr:TDynImageDataArray;
  TargetFile,TargetExtra:ShortString;
  SourceExt,TargetExt:ShortString;
  HasAlpha:Boolean;
  Y,X:LongWord;
  AlphaByte:Byte;
begin
  Result:=False;

  if Index > TexRecDataLen then
  Exit;

  ///100 - Unable to load file to memory
  if not LoadMultiImageFromFile (TexList[Index],ImgArr) then
  begin
    SendMsgRed ('ERROR(100): ' + TexList[Index]);
    DelTexRecData(Index);
    Exit;
  end;

  with TexRecData[Index] do
  begin
    TexFormat:=Byte(ImgArr[0].Format);
    TargetFile:=FOutFolder+TexName;
    SourceExt:='.' + TexExtToStr(TexSourceExt);
    TargetExt:='.' + TexExtToStr(TexTargetExt);
    SendMsgBlue('Loaded file: ' + TexName + SourceExt);
  end;
  CreateFolder (ExtractFilePath(TargetFile));

  if IsTexOptionSet(xAlphaScan) and IsAlphaFormat (ImgArr[0].Format) then
  begin
    HasAlpha:=False;

    if IsSpecialFormat (ImgArr[0].Format) then
    ConvertImage(ImgArr[0],ifA8R8G8B8);

    if IsTexOptionSet(xAlphaSplit) then
    InitAlphaMask (ImgArr[0].Height*ImgArr[0].Width);

    for Y := 0 to ImgArr[0].Height - 1 do
    begin
      for X := 0 to ImgArr[0].Width - 1 do
      begin
        AlphaByte:=GetPixel32(ImgArr[0],X,Y).A;
        if AlphaByte < 255 then
        begin
          HasAlpha:=true;

          if not IsTexOptionSet(xAlphaSplit) then
          Break;
        end;
        if IsTexOptionSet(xAlphaSplit) then
        AddAlphaMaskByte (AlphaByte);
      end;

      if HasAlpha and not IsTexOptionSet(xAlphaSplit) then
      Break;
    end;

    if not HasAlpha  then
    begin
      if IsTexOptionSet(xAlphaSplit) then
      FreeAlphaMask;
      ConvertImage(ImgArr[0],GetNonAlphaFormat(ImgArr[0].Format));
    end
      else
    if HasAlpha then
    begin
      with TexRecData[Index] do
      begin
        SendMsgRed('Alpha information detected: ' + TexName + SourceExt);

        if IsTexOptionSet(xSaveAlphaList) then
        AddToAlphaList (TexName + SourceExt);

        if IsTexOptionSet(xAlphaCopy) or IsTexOptionSet(xAlphaMove) then
        begin
          TargetExtra:=FExtraFolder+TexName + SourceExt;
          CreateFolder (ExtractFilePath(TargetExtra));
        end;

        if IsTexOptionSet(xAlphaSplit) then
        begin
          SendMsgBlue('Splitting and deleting alpha channel!');
          // 101 - Unable to convert to another format
          if not ConvertImage (ImgArr[0],GetNonAlphaFormat(ImgArr[0].Format)) then
          begin
            SendMsgRed ('ERROR(101): ' + TexName + SourceExt);
            FreeImagesInArray (ImgArr);
            DelTexRecData(Index);
            Exit;
          end;

          SaveAlphaMask(TargetFile + SourceExt + '.alpha');
          FreeAlphaMask;
        end
          else
        if IsTexOptionSet(xAlphaCopy) then
        begin
          SendMsgBlue('Copying file: ' + TexName + SourceExt);
          sfCopyFile(TexList[Index],TargetExtra);
        end
          else
        if IsTexOptionSet(xAlphaMove) then
        begin
          SendMsgBlue('Moving file: ' + TexName + SourceExt);
          sfMoveFile(TexList[Index],TargetExtra);
        end;

        if not IsTexOptionSet(xAlphaSplit)  then
        begin
          FreeImagesInArray (ImgArr);
          Result:=True;
          Exit;
        end; // if not
      end; // with
    end; // HasAlpha
  end; // if IsAlpha

  with TexRecData[Index] do
  begin
    if IsTexOptionSet(xSaveTexRecData) then
    begin
      //FFormat:=Byte(ImgArr[0].Format);
      TexHasAlpha:=Byte(HasAlpha);
      with TexDataInfo do
      begin
        case TexSourceExt of
          xDDS:
          begin
            MipMaps:= GetOption(ImagingDDSLoadedMipMapCount);
            CubeMap:= GetOption(ImagingDDSLoadedCubeMap);
            Faces:= GetOption(ImagingDDSLoadedDepth);

            VolumeTex:= GetOption(ImagingDDSLoadedVolume);
            Slices:= GetOption(ImagingDDSLoadedDepth);
          end;
          xPNG:
          begin
            CompLvl:=GetOption (ImagingPNGCompressLevel);
            PreFilter:= GetOption (ImagingPNGPreFilter);
          end;
          xJPG:
          begin
            CompLvl:=GetOption (ImagingJpegQuality);
            ProgMode:=GetOption (ImagingJpegProgressive);
          end;
          xTGA:
          begin
            CompLvl:= GetOption (ImagingTargaRLE);
          end;
          xBMP:
          begin
            CompLvl:= GetOption (ImagingBitmapRLE);
          end;
        end; //case
      end; //with
    end;  // if

    case TexTargetExt of
      xDDS:
      begin
        if IsTexOptionSet(xDelMipMaps) then
        SetLength(ImgArr,1);
        //SetOption (ImagingDDSSaveMipMapCount,1);

        if IsTexOptionSet(xDelCubeMap) then
        SetOption (ImagingDDSSaveCubeMap,0);

        if IsTexOptionSet(xDelVolTexture) then
        SetOption (ImagingDDSSaveVolume,0);
      end;
      xPNG:
      begin
        SetOption (ImagingPNGCompressLevel,FPNGCompLvl);
      end;
      xJPG:
      begin
        SetOption (ImagingJpegQuality,FJPGCompLvl);
      end;
      xTGA:
      begin
        if IsTexOptionSet(xEnableRLE) then
        SetOption (ImagingTargaRLE,1);
      end;
      xBMP:
      begin
        if not IsTexOptionSet(xEnableRLE) then
        SetOption (ImagingBitmapRLE,0);
      end;
    end;
  end;

  case TexRecData[Index].TexTargetExt of
    xDDS:
    begin
      if not SaveMultiImageToFile(TargetFile + TargetExt,ImgArr) then
      begin
        SendMsgRed ('ERROR(102): ' + TexRecData[Index].TexName + SourceExt);
        FreeImagesInArray (ImgArr);
        DelTexRecData(Index);
        Exit;
      end;
    end;
    xJPG,xBMP,xTGA,xPNG:
    begin
      if not SaveImageToFile(TargetFile + TargetExt,ImgArr[0]) then
      begin
        SendMsgRed ('ERROR(102): ' + TexRecData[Index].TexName + SourceExt);
        FreeImagesInArray (ImgArr);
        DelTexRecData(Index);
        Exit;
      end;
    end;
  end;
  FreeImagesInArray (ImgArr);
  SendMsgRed('Texture has been successfully converted!');

  if IsTexOptionSet(xDelSourceFile) then
  DeleteFile(TexRecData[Index].TexName);

  Result:=True;
  inc (TexRecDataConv);
end;
*)

function TTexConverter.Convert(const Index:LongWord):boolean;
type
  TAlphaTable = Array[0..255] of Integer;
var
  Img:TImageData;
  TargetFile,TargetExtra:ShortString;
  SourceExt,TargetExt:ShortString;
  HasAlpha:Boolean;
  i, Y,X:LongWord;
  AlphaByte:Byte;
  AlphaTable: TAlphaTable;
  PixelCount: Integer;
  Score: Integer;
begin
  Result:=False;

  if Index > TexRecDataLen then
  Exit;

  ///100 - Unable to load file to memory
  if not LoadImageFromFile (TexList[Index],Img) then
  begin
    SendMsgRed ('ERROR(100): ' + TexList[Index]);
    DelTexRecData(Index);
    Exit;
  end;

  with TexRecData[Index] do
  begin
    TexFormat:=Byte(Img.Format);
    TargetFile:=FOutFolder+TexName;
    SourceExt:='.' + TexExtToStr(TexSourceExt);
    TargetExt:='.' + TexExtToStr(TexTargetExt);
    SendMsgBlue('Loaded file: ' + TexName + SourceExt);
  end;

  CreateFolder (ExtractFilePath(TargetFile));
  FillChar(AlphaTable, sizeof(TAlphaTable), 0);

  if (not IsAlphaFormat (Img.Format)) then
  begin
    FreeImage(Img);
    Result:= True;
    Exit;
  end;

  if IsSpecialFormat (Img.Format) then
  ConvertImage(Img, ifA8R8G8B8);

  PixelCount:= Img.Height * Img.Width;
  for Y := 0 to Img.Height - 1 do
  begin
    for X := 0 to Img.Width - 1 do
    begin
      AlphaByte:= GetPixel32(Img,X,Y).A;
      Inc(AlphaTable[AlphaByte]);
    end;
  end;

  FreeImage (Img);

  Score:= 0;
  for i := 0 to 255 do
  begin
    if (AlphaTable[i] <> 0) then
    Inc(Score);
    //ScoreTable[i]:= PixelCount / AlphaTable[i];
  end;

  HasAlpha:= (Score >= 2);

    if HasAlpha then
    begin
      with TexRecData[Index] do
      begin
        SendMsgRed('Alpha information detected: ' + TexName + SourceExt);

        if IsTexOptionSet(xSaveAlphaList) then
        AddToAlphaList (TexName + SourceExt);

        if IsTexOptionSet(xAlphaCopy) or IsTexOptionSet(xAlphaMove) then
        begin
          TargetExtra:=FExtraFolder+TexName + SourceExt;
          CreateFolder (ExtractFilePath(TargetExtra));
        end;

        if IsTexOptionSet(xAlphaSplit) then
        begin
        end
          else
        if IsTexOptionSet(xAlphaCopy) then
        begin
          SendMsgBlue('Copying file: ' + TexName + SourceExt);
          sfCopyFile(TexList[Index],TargetExtra);
        end
          else
        if IsTexOptionSet(xAlphaMove) then
        begin
          SendMsgBlue('Moving file: ' + TexName + SourceExt);
          sfMoveFile(TexList[Index],TargetExtra);
        end;
      end; // with
    end; // HasAlpha

  SendMsgRed('Texture has been successfully converted!');

  if IsTexOptionSet(xDelSourceFile) then
  DeleteFile(TexRecData[Index].TexName);

  Result:=True;
  Inc (TexRecDataConv);
end;

procedure TTexConverter.SetAlphaListPath (const FileName:ShortString);
begin
  AlphaListPath:=FileName;
end;

procedure TTexConverter.SetTexRecDataPath (const FileName:ShortString);
begin
  TexRecDataPath:=FileName;
end;

procedure TTexConverter.SaveTexRecData;
var
  FFile:File of Byte;
  TexRecHeader:TTexRecHeader;
begin
  if (not IsTexOptionSet(xSaveTexRecData)) or (TexRecDataLen=0) then
  Exit;

  SendMsgRed('Saving TexRec data');
  try
    AssignFile(FFile,TexRecDataPath);
    Rewrite(FFile);

    with TexRecHeader do
    begin
      ID:=TexRecID;
      Count:=TexRecDataConv;
    end;

    BlockWrite(FFile,TexRecHeader,SizeOf(TTexRecHeader));
    BlockWrite (FFile,TexRecData[0],TexRecDataConv * SizeOf(TTexRecData));
    CloseFile (FFile);
  except
    SendMsgRed('ERROR(104): ' + TexRecDataPath);
  end;
end;

procedure TTexConverter.SaveAlphaList;
var
  FFile:TextFile;
  i:LongWord;
begin
  if (not IsTexOptionSet(xSaveAlphaList)) or (AlphaListLen=0) then
  Exit;

  SendMsgRed('Saving AlphaList');
  try
    AssignFile(FFile,AlphaListPath);
    Rewrite(FFile);

    for i := 0 to AlphaListLen - 1 do
    WriteLn(FFile,AlphaList[i]);

    CloseFile(FFile);
  except
    SendMsgRed('ERROR(104): ' + AlphaListPath);
  end;
end;



end.
