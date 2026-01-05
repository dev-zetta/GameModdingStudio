unit BIK_Unit;


interface

uses Windows,Forms,Graphics,Classes,SysUtils,FastFileStream,BlankFiles,FileTypes,Binkw32,CustomFunc;

function BikSearch (FileName:ShortString):Word;
function BikExtract (FileName,Folder:ShortString):boolean;
function BikDupe (FileName:ShortString):boolean;
procedure BikClean;
procedure BikPlayInit (FileName:ShortString);
procedure BikPlay (Canvas:TCanvas;Offset:LongWord);
procedure BikPlayFormCreate;
procedure BikPlayFormDestroy;
procedure BikStop;

var
  BIKPlayInited:boolean=false;
  BikStillPlay:boolean=false;

var
  BikForm:TForm;
  //BikPaintBox:TPaintBox;

implementation

type
  BIKHeader = packed record
  ID: array[0..3] of char;
  FileSize:LongWord;
end;

var
  BIKStream: TFileStream;
  Fbmp: TBitmap;
  BikHeaderInfo: hbink;

//
// BIK Functions Starts here
//

procedure BikPlayInit (FileName:ShortString);
begin
  if not BinkSetSoundSystem(binkOpenDirectSound,0) then
  Exit;

  BIKPlayInited:=true;
  BikStream:= TFileStream.create(FileName,fmOpenRead);
  Fbmp := TBitmap.create;
end;

procedure BikPlayFormCreate ();
begin
  BikForm:=TForm.Create(nil);
  //BikPaintBox:=TPaintBox.Create(BikForm);

  //BikPaintBox.Parent:=BikForm;
  BikForm.AutoSize:=false;
  BikForm.BorderStyle:=bsDialog;
  BikForm.Caption:='Bink Player';
end;

procedure BikPlayFormDestroy ();
begin
  if BIKStream<> nil then
  BIKStream.Free;
  BIKPlayInited:=false;
  if BikForm <> nil then
  BikForm.Destroy;

  if Fbmp <> nil then
  Fbmp:=nil;
end;

procedure BikPlayFormResize (Width,Height:Word);
begin
  BikForm.Width:=Width;
  BikForm.Height:=Height;
  //BikPaintBox.Width:=Width;
  //BikPaintBox.Height:=Height;
  BikForm.Position:=poDesktopCenter;
end;

procedure BikStop;
begin
  BikStillPlay:=false;
  BikForm.Hide;
end;

procedure BikPlay (Canvas:TCanvas;Offset:LongWord);
var
  B:tagBITMAP;
  R:Trect;
  s:ShortString;
begin
  // need this to obtain the address of the bitmap data
  BikStream.Position:=Offset;

  BikHeaderInfo:= BinkOpen(Pointer(BikStream.handle),BINK_OPEN_STREAM);

  if BikHeaderInfo<>nil then
  begin
    Fbmp.Width:= BikHeaderInfo.Width;
    Fbmp.Height:= BikHeaderInfo.Height;
    Fbmp.PixelFormat:= pf32bit;
    Fbmp.Canvas.Brush.Color:=0;
  end;

  BikPlayFormResize (Fbmp.Width,Fbmp.Height);
  if not BikForm.Visible then
  BikForm.Show;

  GetObject(Fbmp.Handle,sizeof(tagBITMAP),@b);
  BikStillPlay:=true;
  while (BikHeaderInfo.CurrentFrame)<BikHeaderInfo.Frames do
   begin
    // Decompress frame

    if not BikStillPlay then
    Break;

    ProcessMessages;
    BinkDoFrame(BikHeaderInfo);

    // Copy to buffer
    BinkCopyToBuffer( BikHeaderInfo,b.bmBits,
                      FBmp.Width*4,  // Pitch = Width*(bpp/8)
                      FBmp.Height,       // ??
                      0,               // x offset
                      0, 	       // Y offset!
                      BINKSURFACE32);// BufferType

    R.Left := FBmp.Canvas.ClipRect.Left;
    R.Right := FBmp.Canvas.ClipRect.Right;
    R.Top := FBmp.Canvas.ClipRect.bottom;
    R.Bottom := FBmp.Canvas.ClipRect.top;
    Canvas.StretchDraw(r,fbmp);

    while BinkWait(BikHeaderInfo)<>0 do; // busy waiting, but who cares when viewing a

    BinkNextFrame(BikHeaderInfo);
   end;
  BinkClose(BikHeaderInfo);
  BikStillPlay:=false;
end;

function BikSearch (FileName:ShortString):Word;
var
  BikFile:TFastFileStream;
  Buf:array[0..2047] of Char;
  i,FileSize:LongWord;
  j:Word;
  BIKH:BIKHeader;
  CurrentItem:Word;
  Found:Boolean;
begin
  BikFile:=TFastFileStream.Create(FileName);
  pBIKFiles:=@BIKFiles;
  Found:=False;
  i:=0;
  while i<BikFile.Size-2048 do
  begin
    if not Found then
    BikFile.Seek(i,soFromBeginning);

    BikFile.ReadBuffer(Buf,2048);
    inc (i,2048);

    for j:=0 to Length(Buf)-1 do
    begin
      if (Buf[j]='B') and (Buf[j+1]='I') and (Buf[j+2]='K') and (Buf[j+3]='i') then
        begin
           if i>2048 then
          dec (i,2048-j);
          Found:=True;
          Break;
        end;
    end;

    if Found = true then
      begin
        SetLength (BIKFiles,Length(BIKFiles)+1);
        CurrentItem:=Length (BikFiles)-1;
        BikFile.Seek(i+4,soFromBeginning);
        BikFile.ReadBuffer(FileSize,4);
        BikFiles[CurrentItem].Offset:=i;
        BikFiles[CurrentItem].FileSize:=FileSize+8;
        BikFiles[CurrentItem].FileName:=Format('BIKFile%.5d.bik', [CurrentItem]);

        inc (i,FileSize+8);
        Found:=False;
    end; // if buf
  end; // for while
  Buf:='';
  BikFile.Destroy;
end;

function BikExtract (FileName,Folder:ShortString):boolean;
var
i:LongWord;
BikFile:TFastFileStream;
OutFile:File of Byte;
Buf:Array of Byte;
begin
Result:=false;
if Length (BIKFiles)>0 then
begin
  BIKFile:=TFastFileStream.Create(Filename);

  for i:=0 to Length (BikFiles)-1 do
  begin
    BikFile.Seek(BikFiles[i].Offset,soFromBeginning);
    SetLength (Buf,BikFiles[i].FileSize);
    BikFile.Read(Buf[0],BikFiles[i].FileSize);

    AssignFile (OutFile,Folder + BikFiles[i].FileName);
    Rewrite (OutFile);
    BlockWrite (OutFile,Buf[0],Length(Buf)-1);
    CloseFile (OutFile);
  end;
  BikFile.Destroy;
  Buf:=nil;
  Result:=true;
  end;
end;

function BikDupe (FileName:ShortString):boolean;
var
i,j:LongWord;
InputFile:File of Byte;
Buf:Array of Byte;
begin
Result:=false;
if Length (BikFiles)>0 then
  begin
  AssignFile (InputFile,FileName);
  Reset (InputFile);
  for i:=0 to Length (BikFiles)-1 do
  begin
    Seek(InputFile,BikFiles[i].Offset);
    SetLength (Buf,BikFiles[i].FileSize);

    FillChar (Pointer(Buf)^,BikFiles[i].FileSize,$00);

    BlockWrite (InputFile,Buf[0],Length(Buf));
    Seek (InputFile,BikFiles[i].Offset);

    BlockWrite (InputFile,BlankBik[0],Length(BlankBik));
  end;
  Buf:=nil;
  CloseFile (InputFile);
  end;
  Result:=true;
end;

procedure BikClean;
begin
BikFiles:=nil;
end;

//
// BIK Functions ends here
//

end.
 