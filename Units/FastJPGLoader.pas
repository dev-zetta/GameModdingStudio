unit FastJPGLoader;

interface

uses
  SysUtils,FastJPGTypes;

type
  TFastImage = Packed Record
    Data:Pointer;
    Size:LongWord;
    Width:LongWord;
    Height:LongWord;
    PixelSize:LongWord; // In bits
  end;

  TFastJPGLoader = Class
    private

    public
      function LoadImage(const FileName: ShortString;var Image:TFastImage):boolean;
  end;

implementation

function TFastJPGLoader.LoadImage(const FileName: ShortString; var Image: TFastImage);
var
  FFile:File of Byte;
  FSize:LongWord;
  FPos:LongWord;
  Marker:TJPEGMarker;
begin
  Result:=False;
  if not FileExists(FileName) then
  Exit;

  AssignFile(FFile,FileName);
  Reset(FFile);
  BlockRead(FFile,Marker,SizeOf(TJPEGMarker));
  if Marker<>M_SOI then
  Exit;

  while FPos<FSize do
  begin
    BlockRead(FFile,Marker,SizeOf(TJPEGMarker));

    case Marker of
      M_SOF0: ;
      M_SOF1: ;
      M_SOF2: ;
      M_SOF3: ;
      M_SOF5: ;
      M_SOF6: ;
      M_SOF7: ;
      M_JPG: ;
      M_SOF9: ;
      M_SOF10: ;
      M_SOF11: ;
      M_SOF13: ;
      M_SOF14: ;
      M_SOF15: ;
      M_DHT: ;
      M_DAC: ;
      M_RST0: ;
      M_RST1: ;
      M_RST2: ;
      M_RST3: ;
      M_RST4: ;
      M_RST5: ;
      M_RST6: ;
      M_RST7: ;
      M_SOI: ;
      M_EOI: ;
      M_SOS: ;
      M_DQT: ;
      M_DNL: ;
      M_DRI: ;
      M_DHP: ;
      M_EXP: ;
      M_APP0: ;
      M_APP15: ;
      M_JPG0: ;
      M_JPG13: ;
      M_COM: ;
      M_TEM: ;
    end;

  end;

end;

end.
