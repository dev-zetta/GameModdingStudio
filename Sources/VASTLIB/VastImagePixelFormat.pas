unit VastImagePixelFormat;

interface

uses
  VastImage,VastImageTypes;

function PixelFormatToString(const PixelFormat:TPIXEL_FORMAT):STRING;
function SetPixelFormatInfo(var InImage:PVastImage;const PixelFormat:TPIXEL_FORMAT):BOOLEAN;
function ConvertPixelFormat(var InImage:PVastImage;var OutImage:PVastImage;const TargetFormat:TPIXEL_FORMAT):Boolean;
implementation


function PixelFormatToString(const PixelFormat:TPIXEL_FORMAT):STRING;
begin
  case PixelFormat of
    PIXEL_FORMAT_UNKNOWN:
    begin
      Result:='PIXEL_FORMAT_UNKNOWN';
      Exit;
    end;

    // Formats with 1 or 2 channels only
    PIXEL_FORMAT_INDEX1:
    begin
      Result:='PIXEL_FORMAT_INDEX1';
      Exit;
    end;

    PIXEL_FORMAT_INDEX8:
    begin
      Result:='PIXEL_FORMAT_INDEX8';
      Exit;
    end;

    PIXEL_FORMAT_A1:
    begin
      Result:='PIXEL_FORMAT_A1';
      Exit;
    end;

    PIXEL_FORMAT_A2:
    begin
      Result:='PIXEL_FORMAT_A2';
      Exit;
    end;

    PIXEL_FORMAT_A4:
    begin
      Result:='PIXEL_FORMAT_A4';
      Exit;
    end;

    PIXEL_FORMAT_A8:
    begin
      Result:='PIXEL_FORMAT_A8';
      Exit;
    end;

    PIXEL_FORMAT_A10:
    begin
      Result:='PIXEL_FORMAT_A10';
      Exit;
    end;

    PIXEL_FORMAT_A16:
    begin
      Result:='PIXEL_FORMAT_A16';
      Exit;
    end;

    PIXEL_FORMAT_A32:
    begin
      Result:='PIXEL_FORMAT_A32';
      Exit;
    end;
    // 3 and 4 channel formats

    PIXEL_FORMAT_B5G6R5:
    begin
      Result:='PIXEL_FORMAT_B5G6R5';
      Exit;
    end;

    PIXEL_FORMAT_R5G6B5:
    begin
      Result:='PIXEL_FORMAT_R5G6B5';
      Exit;
    end;

    PIXEL_FORMAT_A4R4G4B4:
    begin
      Result:='PIXEL_FORMAT_A4R4G4B4';
      Exit;
    end;

    PIXEL_FORMAT_X4R4G4B4:
    begin
      Result:='PIXEL_FORMAT_X4R4G4B4';
      Exit;
    end;

    PIXEL_FORMAT_A4B4G4R4:
    begin
      Result:='PIXEL_FORMAT_A4B4G4R4';
      Exit;
    end;

    PIXEL_FORMAT_X4B4G4R4:
    begin
      Result:='PIXEL_FORMAT_X4B4G4R4';
      Exit;
    end;

    PIXEL_FORMAT_R4G4B4A4:
    begin
      Result:='PIXEL_FORMAT_R4G4B4A4';
      Exit;
    end;

    PIXEL_FORMAT_R4G4B4X4:
    begin
      Result:='PIXEL_FORMAT_R4G4B4X4';
      Exit;
    end;

    PIXEL_FORMAT_B4G4R4A4:
    begin
      Result:='PIXEL_FORMAT_B4G4R4A4';
      Exit;
    end;

    PIXEL_FORMAT_B4G4R4X4:
    begin
      Result:='PIXEL_FORMAT_B4G4R4X4';
      Exit;
    end;

    PIXEL_FORMAT_A1R5G5B5:
    begin
      Result:='PIXEL_FORMAT_A1R5G5B5';
      Exit;
    end;

    PIXEL_FORMAT_X1R5G5B5:
    begin
      Result:='PIXEL_FORMAT_X1R5G5B5';
      Exit;
    end;

    PIXEL_FORMAT_A1B5G5R5:
    begin
      Result:='PIXEL_FORMAT_A1B5G5R5';
      Exit;
    end;

    PIXEL_FORMAT_X1B5G5R5:
    begin
      Result:='PIXEL_FORMAT_X1B5G5R5';
      Exit;
    end;

    PIXEL_FORMAT_R5G5B5A1:
    begin
      Result:='PIXEL_FORMAT_R5G5B5A1';
      Exit;
    end;

    PIXEL_FORMAT_R5G5B5X1:
    begin
      Result:='PIXEL_FORMAT_R5G5B5X1';
      Exit;
    end;

    PIXEL_FORMAT_B5G5R5A1:
    begin
      Result:='PIXEL_FORMAT_B5G5R5A1';
      Exit;
    end;

    PIXEL_FORMAT_B5G5R5X1:
    begin
      Result:='PIXEL_FORMAT_B5G5R5X1';
      Exit;
    end;
    // 8 bits per channel
    PIXEL_FORMAT_R8:
    begin
      Result:='PIXEL_FORMAT_R8';
      Exit;
    end;

    PIXEL_FORMAT_R8F:
    begin
      Result:='PIXEL_FORMAT_R8F';
      Exit;
    end;

    PIXEL_FORMAT_R8G8:
    begin
      Result:='PIXEL_FORMAT_R8G8';
      Exit;
    end;

    PIXEL_FORMAT_R8G8F:
    begin
      Result:='PIXEL_FORMAT_R8G8F';
      Exit;
    end;

    PIXEL_FORMAT_R8G8B8:
    begin
      Result:='PIXEL_FORMAT_R8G8B8';
      Exit;
    end;

    PIXEL_FORMAT_B8G8R8:
    begin
      Result:='PIXEL_FORMAT_B8G8R8';
      Exit;
    end;

    PIXEL_FORMAT_R8G8B8A8:
    begin
      Result:='PIXEL_FORMAT_R8G8B8A8';
      Exit;
    end;

    PIXEL_FORMAT_R8G8B8X8:
    begin
      Result:='PIXEL_FORMAT_R8G8B8X8';
      Exit;
    end;

    PIXEL_FORMAT_B8G8R8A8:
    begin
      Result:='PIXEL_FORMAT_B8G8R8A8';
      Exit;
    end;

    PIXEL_FORMAT_B8G8R8X8:
    begin
      Result:='PIXEL_FORMAT_B8G8R8X8';
      Exit;
    end;

    PIXEL_FORMAT_A8R8G8B8:
    begin
      Result:='PIXEL_FORMAT_A8R8G8B8';
      Exit;
    end;

    PIXEL_FORMAT_X8R8G8B8:
    begin
      Result:='PIXEL_FORMAT_X8R8G8B8';
      Exit;
    end;

    PIXEL_FORMAT_A8B8G8R8:
    begin
      Result:='PIXEL_FORMAT_A8B8G8R8';
      Exit;
    end;

    PIXEL_FORMAT_X8B8G8R8:
    begin
      Result:='PIXEL_FORMAT_X8B8G8R8';
      Exit;
    end;

    // 16 bits per channel
    PIXEL_FORMAT_R16:
    begin
      Result:='PIXEL_FORMAT_R16';
      Exit;
    end;

    PIXEL_FORMAT_R16F:
    begin
      Result:='PIXEL_FORMAT_R16F';
      Exit;
    end;

    PIXEL_FORMAT_R16G16:
    begin
      Result:='PIXEL_FORMAT_R16G16';
      Exit;
    end;

    PIXEL_FORMAT_R16G16F:
    begin
      Result:='PIXEL_FORMAT_R16G16F';
      Exit;
    end;

    PIXEL_FORMAT_R16G16B16:
    begin
      Result:='PIXEL_FORMAT_R16G16B16';
      Exit;
    end;

    PIXEL_FORMAT_R16G16B16F:
    begin
      Result:='PIXEL_FORMAT_R16G16B16F';
      Exit;
    end;

    PIXEL_FORMAT_B16G16R16:
    begin
      Result:='PIXEL_FORMAT_B16G16R16';
      Exit;
    end;

    PIXEL_FORMAT_B16G16R16F:
    begin
      Result:='PIXEL_FORMAT_B16G16R16F';
      Exit;
    end;

    PIXEL_FORMAT_R16G16B16A16:
    begin
      Result:='PIXEL_FORMAT_R16G16B16A16';
      Exit;
    end;

    PIXEL_FORMAT_R16G16B16A16F:
    begin
      Result:='PIXEL_FORMAT_R16G16B16A16F';
      Exit;
    end;

    PIXEL_FORMAT_R16G16B16X16:
    begin
      Result:='PIXEL_FORMAT_R16G16B16X16';
      Exit;
    end;

    PIXEL_FORMAT_R16G16B16X16F:
    begin
      Result:='PIXEL_FORMAT_R16G16B16X16F';
      Exit;
    end;

    PIXEL_FORMAT_B16G16R16A16:
    begin
      Result:='PIXEL_FORMAT_B16G16R16A16';
      Exit;
    end;

    PIXEL_FORMAT_B16G16R16A16F:
    begin
      Result:='PIXEL_FORMAT_B16G16R16A16F';
      Exit;
    end;

    PIXEL_FORMAT_B16G16R16X16:
    begin
      Result:='PIXEL_FORMAT_B16G16R16X16';
      Exit;
    end;

    PIXEL_FORMAT_B16G16R16X16F:
    begin
      Result:='PIXEL_FORMAT_B16G16R16X16F';
      Exit;
    end;

    PIXEL_FORMAT_A16R16G16B16:
    begin
      Result:='PIXEL_FORMAT_A16R16G16B16';
      Exit;
    end;

    PIXEL_FORMAT_A16R16G16B16F:
    begin
      Result:='PIXEL_FORMAT_A16R16G16B16F';
      Exit;
    end;

    PIXEL_FORMAT_X16R16G16B16:
    begin
      Result:='PIXEL_FORMAT_X16R16G16B16';
      Exit;
    end;

    PIXEL_FORMAT_X16R16G16B16F:
    begin
      Result:='PIXEL_FORMAT_X16R16G16B16F';
      Exit;
    end;

    PIXEL_FORMAT_A16B16G16R16:
    begin
      Result:='PIXEL_FORMAT_A16B16G16R16';
      Exit;
    end;

    PIXEL_FORMAT_A16B16G16R16F:
    begin
      Result:='PIXEL_FORMAT_A16B16G16R16F';
      Exit;
    end;

    PIXEL_FORMAT_X16B16G16R16:
    begin
      Result:='PIXEL_FORMAT_X16B16G16R16';
      Exit;
    end;

    PIXEL_FORMAT_X16B16G16R16F:
    begin
      Result:='PIXEL_FORMAT_X16B16G16R16F';
      Exit;
    end;

    // 32 bits per channel
    PIXEL_FORMAT_R32:
    begin
      Result:='PIXEL_FORMAT_R32';
      Exit;
    end;

    PIXEL_FORMAT_R32F:
    begin
      Result:='PIXEL_FORMAT_R32F';
      Exit;
    end;

    PIXEL_FORMAT_R32G32:
    begin
      Result:='PIXEL_FORMAT_R32G32';
      Exit;
    end;

    PIXEL_FORMAT_R32G32F:
    begin
      Result:='PIXEL_FORMAT_R32G32F';
      Exit;
    end;

    PIXEL_FORMAT_R32G32B32:
    begin
      Result:='PIXEL_FORMAT_R32G32B32';
      Exit;
    end;

    PIXEL_FORMAT_R32G32B32F:
    begin
      Result:='PIXEL_FORMAT_R32G32B32F';
      Exit;
    end;

    PIXEL_FORMAT_B32G32R32:
    begin
      Result:='PIXEL_FORMAT_B32G32R32';
      Exit;
    end;

    PIXEL_FORMAT_B32G32R32F:
    begin
      Result:='PIXEL_FORMAT_B32G32R32F';
      Exit;
    end;

    PIXEL_FORMAT_R32G32B32A32:
    begin
      Result:='PIXEL_FORMAT_R32G32B32A32';
      Exit;
    end;

    PIXEL_FORMAT_R32G32B32A32F:
    begin
      Result:='PIXEL_FORMAT_R32G32B32A32F';
      Exit;
    end;

    PIXEL_FORMAT_R32G32B32X32:
    begin
      Result:='PIXEL_FORMAT_R32G32B32X32';
      Exit;
    end;

    PIXEL_FORMAT_R32G32B32X32F:
    begin
      Result:='PIXEL_FORMAT_R32G32B32X32F';
      Exit;
    end;

    PIXEL_FORMAT_B32G32R32A32:
    begin
      Result:='PIXEL_FORMAT_B32G32R32A32';
      Exit;
    end;

    PIXEL_FORMAT_B32G32R32A32F:
    begin
      Result:='PIXEL_FORMAT_B32G32R32A32F';
      Exit;
    end;

    PIXEL_FORMAT_B32G32R32X32:
    begin
      Result:='PIXEL_FORMAT_B32G32R32X32';
      Exit;
    end;

    PIXEL_FORMAT_B32G32R32X32F:
    begin
      Result:='PIXEL_FORMAT_B32G32R32X32F';
      Exit;
    end;

    PIXEL_FORMAT_A32R32G32B32:
    begin
      Result:='PIXEL_FORMAT_A32R32G32B32';
      Exit;
    end;

    PIXEL_FORMAT_A32R32G32B32F:
    begin
      Result:='PIXEL_FORMAT_A32R32G32B32F';
      Exit;
    end;

    PIXEL_FORMAT_X32R32G32B32:
    begin
      Result:='PIXEL_FORMAT_X32R32G32B32';
      Exit;
    end;

    PIXEL_FORMAT_X32R32G32B32F:
    begin
      Result:='PIXEL_FORMAT_X32R32G32B32F';
      Exit;
    end;

    PIXEL_FORMAT_A32B32G32R32:
    begin
      Result:='PIXEL_FORMAT_A32B32G32R32';
      Exit;
    end;

    PIXEL_FORMAT_A32B32G32R32F:
    begin
      Result:='PIXEL_FORMAT_A32B32G32R32F';
      Exit;
    end;

    PIXEL_FORMAT_X32B32G32R32:
    begin
      Result:='PIXEL_FORMAT_X32B32G32R32';
      Exit;
    end;

    PIXEL_FORMAT_X32B32G32R32F:
    begin
      Result:='PIXEL_FORMAT_X32B32G32R32F';
      Exit;
    end;

    // Block Compression
    PIXEL_FORMAT_BC1:
    begin
      Result:='PIXEL_FORMAT_BC1';
      Exit;
    end;

    PIXEL_FORMAT_BC2:
    begin
      Result:='PIXEL_FORMAT_BC2';
      Exit;
    end;

    PIXEL_FORMAT_BC3:
    begin
      Result:='PIXEL_FORMAT_BC3';
      Exit;
    end;

    PIXEL_FORMAT_BC4:
    begin
      Result:='PIXEL_FORMAT_BC4';
      Exit;
    end;

    PIXEL_FORMAT_BC5:
    begin
      Result:='PIXEL_FORMAT_BC5';
      Exit;
    end;

    // Special
    PIXEL_FORMAT_R6A2G6A2B6A2:
    begin
      Result:='PIXEL_FORMAT_R6A2G6A2B6A2';
      Exit;
    end;
  end;
end;

function SetPixelFormatInfo(var InImage:PVastImage;const PixelFormat:TPIXEL_FORMAT):BOOLEAN;
begin
(*
  if not IsImageSet(InImage) then
  begin
    Result:=True;
    Exit;
  end;
*)
  case PixelFormat of
    PIXEL_FORMAT_UNKNOWN:
    begin
      Result:=False;
      Exit;
    end;

    // Formats with 1 or 2 channels only
    PIXEL_FORMAT_INDEX1:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_INDEX1;
      InImage^.PixelSize:=$01;
      InImage^.ChannelCount:=$01;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_INDEX8:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_INDEX8;
      InImage^.PixelSize:=$08;
      InImage^.ChannelCount:=$01;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A1:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A1;
      InImage^.PixelSize:=$01;
      InImage^.ChannelCount:=$01;
      InImage^.IsAlphaFormat:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A2:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A2;
      InImage^.PixelSize:=$02;
      InImage^.ChannelCount:=$01;
      InImage^.IsAlphaFormat:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A4:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A4;
      InImage^.PixelSize:=$04;
      InImage^.ChannelCount:=$01;
      InImage^.IsAlphaFormat:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A8:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A8;
      InImage^.PixelSize:=$08;
      InImage^.ChannelCount:=$01;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A10:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A10;
      InImage^.PixelSize:=$0A;
      InImage^.ChannelCount:=$01;
      InImage^.IsAlphaFormat:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A16:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A16;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$01;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A32:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A32;
      InImage^.PixelSize:=$20;
      InImage^.ChannelCount:=$01;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      Result:=True;
      Exit;
    end;
    // 3 and 4 channel formats

    PIXEL_FORMAT_B5G6R5:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B5G6R5;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R5G6B5:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R5G6B5;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A4R4G4B4:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A4R4G4B4;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_X4R4G4B4:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_X4R4G4B4;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A4B4G4R4:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A4B4G4R4;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_X4B4G4R4:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_X4B4G4R4;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R4G4B4A4:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R4G4B4A4;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R4G4B4X4:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R4G4B4X4;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B4G4R4A4:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B4G4R4A4;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B4G4R4X4:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B4G4R4X4;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A1R5G5B5:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A1R5G5B5;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_X1R5G5B5:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_X1R5G5B5;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A1B5G5R5:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A1B5G5R5;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_X1B5G5R5:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_X1B5G5R5;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R5G5B5A1:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R5G5B5A1;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R5G5B5X1:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R5G5B5X1;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B5G5R5A1:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B5G5R5A1;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B5G5R5X1:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B5G5R5X1;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$03;
      Result:=True;
      Exit;
    end;
    // 8 bits per channel
    PIXEL_FORMAT_R8:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R8;
      InImage^.PixelSize:=$08;
      InImage^.ChannelCount:=$01;
      InImage^.IsPixelAligned:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R8F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R8F;
      InImage^.PixelSize:=$08;
      InImage^.ChannelCount:=$01;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R8G8:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R8G8;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$02;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$01;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R8G8F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R8G8F;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$02;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$01;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R8G8B8:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R8G8B8;
      InImage^.PixelSize:=$18;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$01;
      InImage^.BluePos:=$02;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B8G8R8:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B8G8R8;
      InImage^.PixelSize:=$18;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$02;
      InImage^.GreenPos:=$01;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R8G8B8A8:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R8G8B8A8;
      InImage^.PixelSize:=$20;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$01;
      InImage^.BluePos:=$02;
      InImage^.AlphaPos:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R8G8B8X8:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R8G8B8X8;
      InImage^.PixelSize:=$20;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$01;
      InImage^.BluePos:=$02;
      InImage^.AlphaPos:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B8G8R8A8:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B8G8R8A8;
      InImage^.PixelSize:=$20;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$02;
      InImage^.GreenPos:=$01;
      InImage^.AlphaPos:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B8G8R8X8:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B8G8R8X8;
      InImage^.PixelSize:=$20;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$02;
      InImage^.GreenPos:=$01;
      InImage^.AlphaPos:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A8R8G8B8:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A8R8G8B8;
      InImage^.PixelSize:=$20;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$01;
      InImage^.GreenPos:=$02;
      InImage^.BluePos:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_X8R8G8B8:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_X8R8G8B8;
      InImage^.PixelSize:=$20;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$01;
      InImage^.GreenPos:=$02;
      InImage^.BluePos:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A8B8G8R8:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A8B8G8R8;
      InImage^.PixelSize:=$20;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$03;
      InImage^.GreenPos:=$02;
      InImage^.BluePos:=$01;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_X8B8G8R8:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_X8B8G8R8;
      InImage^.PixelSize:=$20;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$03;
      InImage^.GreenPos:=$02;
      InImage^.BluePos:=$01;
      Result:=True;
      Exit;
    end;

    // 16 bits per channel
    PIXEL_FORMAT_R16:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R16;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$01;
      InImage^.IsPixelAligned:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R16F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R16F;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$01;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R16G16:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R16G16;
      InImage^.PixelSize:=$20;
      InImage^.ChannelCount:=$02;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$02;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R16G16F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R16G16F;
      InImage^.PixelSize:=$20;
      InImage^.ChannelCount:=$02;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$02;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R16G16B16:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R16G16B16;
      InImage^.PixelSize:=$30;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$02;
      InImage^.BluePos:=$04;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R16G16B16F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R16G16B16F;
      InImage^.PixelSize:=$30;
      InImage^.ChannelCount:=$03;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$02;
      InImage^.BluePos:=$04;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B16G16R16:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B16G16R16;
      InImage^.PixelSize:=$30;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$04;
      InImage^.GreenPos:=$02;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B16G16R16F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B16G16R16F;
      InImage^.PixelSize:=$30;
      InImage^.ChannelCount:=$03;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$04;
      InImage^.GreenPos:=$02;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R16G16B16A16:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R16G16B16A16;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$02;
      InImage^.BluePos:=$04;
      InImage^.AlphaPos:=$06;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R16G16B16A16F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R16G16B16A16F;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$02;
      InImage^.BluePos:=$04;
      InImage^.AlphaPos:=$06;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R16G16B16X16:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R16G16B16X16;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$02;
      InImage^.BluePos:=$04;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R16G16B16X16F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R16G16B16X16F;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$03;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$02;
      InImage^.BluePos:=$04;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B16G16R16A16:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B16G16R16A16;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$04;
      InImage^.GreenPos:=$02;
      InImage^.AlphaPos:=$06;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B16G16R16A16F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B16G16R16A16F;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$04;
      InImage^.GreenPos:=$02;
      InImage^.AlphaPos:=$06;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B16G16R16X16:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B16G16R16X16;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$04;
      InImage^.GreenPos:=$02;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B16G16R16X16F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B16G16R16X16F;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$03;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$04;
      InImage^.GreenPos:=$02;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A16R16G16B16:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A16R16G16B16;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$02;
      InImage^.GreenPos:=$04;
      InImage^.BluePos:=$06;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A16R16G16B16F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A16R16G16B16F;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$02;
      InImage^.GreenPos:=$04;
      InImage^.BluePos:=$06;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_X16R16G16B16:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_X16R16G16B16;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$02;
      InImage^.GreenPos:=$04;
      InImage^.BluePos:=$06;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_X16R16G16B16F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_X16R16G16B16F;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$03;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$02;
      InImage^.GreenPos:=$04;
      InImage^.BluePos:=$06;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A16B16G16R16:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A16B16G16R16;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$06;
      InImage^.GreenPos:=$04;
      InImage^.BluePos:=$02;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A16B16G16R16F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A16B16G16R16F;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$06;
      InImage^.GreenPos:=$04;
      InImage^.BluePos:=$02;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_X16B16G16R16:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_X16B16G16R16;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$06;
      InImage^.GreenPos:=$04;
      InImage^.BluePos:=$02;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_X16B16G16R16F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_X16B16G16R16F;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$03;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$06;
      InImage^.GreenPos:=$04;
      InImage^.BluePos:=$02;
      Result:=True;
      Exit;
    end;

    // 32 bits per channel
    PIXEL_FORMAT_R32:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R32;
      InImage^.PixelSize:=$20;
      InImage^.ChannelCount:=$01;
      InImage^.IsPixelAligned:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R32F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R32F;
      InImage^.PixelSize:=$20;
      InImage^.ChannelCount:=$01;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R32G32:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R32G32;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$02;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$04;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R32G32F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R32G32F;
      InImage^.PixelSize:=$40;
      InImage^.ChannelCount:=$02;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$04;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R32G32B32:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R32G32B32;
      InImage^.PixelSize:=$60;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$04;
      InImage^.BluePos:=$08;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R32G32B32F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R32G32B32F;
      InImage^.PixelSize:=$60;
      InImage^.ChannelCount:=$03;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$04;
      InImage^.BluePos:=$08;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B32G32R32:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B32G32R32;
      InImage^.PixelSize:=$60;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$0C;
      InImage^.GreenPos:=$04;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B32G32R32F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B32G32R32F;
      InImage^.PixelSize:=$60;
      InImage^.ChannelCount:=$03;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$0C;
      InImage^.GreenPos:=$04;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R32G32B32A32:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R32G32B32A32;
      InImage^.PixelSize:=$80;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$04;
      InImage^.BluePos:=$08;
      InImage^.AlphaPos:=$0C;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R32G32B32A32F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R32G32B32A32F;
      InImage^.PixelSize:=$80;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$04;
      InImage^.BluePos:=$08;
      InImage^.AlphaPos:=$0C;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R32G32B32X32:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R32G32B32X32;
      InImage^.PixelSize:=$80;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$04;
      InImage^.BluePos:=$08;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_R32G32B32X32F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R32G32B32X32F;
      InImage^.PixelSize:=$80;
      InImage^.ChannelCount:=$03;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$04;
      InImage^.BluePos:=$08;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B32G32R32A32:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B32G32R32A32;
      InImage^.PixelSize:=$80;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$08;
      InImage^.GreenPos:=$04;
      InImage^.AlphaPos:=$0C;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B32G32R32A32F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B32G32R32A32F;
      InImage^.PixelSize:=$80;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$08;
      InImage^.GreenPos:=$04;
      InImage^.AlphaPos:=$0C;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B32G32R32X32:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B32G32R32X32;
      InImage^.PixelSize:=$80;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$08;
      InImage^.GreenPos:=$04;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_B32G32R32X32F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_B32G32R32X32F;
      InImage^.PixelSize:=$80;
      InImage^.ChannelCount:=$03;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$08;
      InImage^.GreenPos:=$04;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A32R32G32B32:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A32R32G32B32;
      InImage^.PixelSize:=$80;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$04;
      InImage^.GreenPos:=$08;
      InImage^.BluePos:=$0C;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A32R32G32B32F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A32R32G32B32F;
      InImage^.PixelSize:=$80;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$04;
      InImage^.GreenPos:=$08;
      InImage^.BluePos:=$0C;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_X32R32G32B32:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_X32R32G32B32;
      InImage^.PixelSize:=$80;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$04;
      InImage^.GreenPos:=$08;
      InImage^.BluePos:=$0C;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_X32R32G32B32F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_X32R32G32B32F;
      InImage^.PixelSize:=$80;
      InImage^.ChannelCount:=$03;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$04;
      InImage^.GreenPos:=$08;
      InImage^.BluePos:=$0C;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A32B32G32R32:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A32B32G32R32;
      InImage^.PixelSize:=$80;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$0C;
      InImage^.GreenPos:=$08;
      InImage^.BluePos:=$04;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_A32B32G32R32F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_A32B32G32R32F;
      InImage^.PixelSize:=$80;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$0C;
      InImage^.GreenPos:=$08;
      InImage^.BluePos:=$04;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_X32B32G32R32:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_X32B32G32R32;
      InImage^.PixelSize:=$80;
      InImage^.ChannelCount:=$03;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$0C;
      InImage^.GreenPos:=$08;
      InImage^.BluePos:=$04;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_X32B32G32R32F:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_X32B32G32R32F;
      InImage^.PixelSize:=$80;
      InImage^.ChannelCount:=$03;
      InImage^.IsFloatFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.RedPos:=$0C;
      InImage^.GreenPos:=$08;
      InImage^.BluePos:=$04;
      Result:=True;
      Exit;
    end;

    // Block Compression
    PIXEL_FORMAT_BC1:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_BC1;
      InImage^.PixelSize:=$20;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$01;
      InImage^.BluePos:=$02;
      InImage^.AlphaPos:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_BC2:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_BC2;
      InImage^.PixelSize:=$20;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$01;
      InImage^.BluePos:=$02;
      InImage^.AlphaPos:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_BC3:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_BC3;
      InImage^.PixelSize:=$20;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$01;
      InImage^.BluePos:=$02;
      InImage^.AlphaPos:=$03;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_BC4:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_BC4;
      InImage^.PixelSize:=$08;
      InImage^.ChannelCount:=$01;
      InImage^.IsPixelAligned:=True;
      Result:=True;
      Exit;
    end;

    PIXEL_FORMAT_BC5:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_BC5;
      InImage^.PixelSize:=$10;
      InImage^.ChannelCount:=$02;
      InImage^.IsPixelAligned:=True;
      InImage^.GreenPos:=$01;
      Result:=True;
      Exit;
    end;

    // Special
    PIXEL_FORMAT_R6A2G6A2B6A2:
    begin
      InImage^.PixelFormat:=PIXEL_FORMAT_R6A2G6A2B6A2;
      InImage^.PixelSize:=$18;
      InImage^.ChannelCount:=$04;
      InImage^.IsAlphaFormat:=True;
      Result:=True;
      Exit;
    end;
  end;
end;





//==============================================================================
// Convert one pixel format to another
// TODO: Add all variations of usage
function ConvertPixelFormat(var InImage:PVastImage;var OutImage:PVastImage;const TargetFormat:TPIXEL_FORMAT):Boolean;
var
  InDataMem:DWORD;
  InDataMemMax:DWORD;
  OutDataMem:DWORD;
  OutDataSize:DWORD;

  function InitOutImage():BOOLEAN;
  begin
    if not InitImage(OutImage) then
    begin
      Result:=False;
      Exit;
    end;

    if not InitImageData(OutImage,OutDataSize) then
    begin
      FreeImage(OutImage);
      Result:=False;
      Exit;
    end;

    if not SetPixelFormatInfo(OutImage, TargetFormat) then
    begin
      FreeImage(OutImage);
      Result:=False;
      Exit;
    end;

    OutImage^.Width:=InImage^.Width;
    OutImage^.Height:=InImage^.Height;

    InDataMem:=DWORD(InImage^.Data);
    InDataMemMax:=InDataMem + InImage^.Size;
    OutDataMem:=DWORD(OutImage^.Data);
    Result:=True;
  end;

begin
  Result:=False;
  if (not IsImageSet(InImage)) or (IsImageSet(OutImage)) then
  Exit;

  case InImage^.PixelFormat of
    PIXEL_FORMAT_UNKNOWN:Exit;
//==================================================================//
    PIXEL_FORMAT_INDEX1:
//==================================================================//
    begin
     // Target format
      case TargetFormat of
      //****************************//
        PIXEL_FORMAT_INDEX8:
      //****************************//
        begin
          OutDataSize:=(InImage^.Width * InImage^.Height) div $08;
          if not InitOutImage() then
          Exit;

          while InDataMem < InDataMemMax do
          begin
            // TODO: Check if its not wrong order
            // Convert 8 bits to 8 * 8 bits
            PBYTE(OutDataMem+$00)^:=(PBYTE(InDataMem+$00)^ and $80);
            PBYTE(OutDataMem+$01)^:=(PBYTE(InDataMem+$00)^ and $40);
            PBYTE(OutDataMem+$02)^:=(PBYTE(InDataMem+$00)^ and $20);
            PBYTE(OutDataMem+$03)^:=(PBYTE(InDataMem+$00)^ and $10);
            PBYTE(OutDataMem+$04)^:=(PBYTE(InDataMem+$00)^ and $08);
            PBYTE(OutDataMem+$05)^:=(PBYTE(InDataMem+$00)^ and $04);
            PBYTE(OutDataMem+$06)^:=(PBYTE(InDataMem+$00)^ and $02);
            PBYTE(OutDataMem+$07)^:=(PBYTE(InDataMem+$00)^ and $01);
            inc(InDataMem,$01);
            inc(OutDataMem,$08);
          end; // while
          Result:=True;
          Exit;
        end;  // case
      end; // case end eTargetFormat
    end; // case  PIXEL_FORMAT_INDEX
//==================================================================//
    PIXEL_FORMAT_INDEX8:;
//==================================================================//

//==================================================================//
    PIXEL_FORMAT_R8:
//==================================================================//
    begin
      // Target format
      case TargetFormat of
      //****************************//
        PIXEL_FORMAT_R8G8B8:
      //****************************//
        begin
          OutDataSize:=InImage^.Width * InImage^.Height * $03;
          if not InitOutImage() then
          Exit;

          while InDataMem < InDataMemMax do
          begin
            // Red
            PBYTE(OutDataMem+$00)^:=PBYTE(InDataMem+$00)^;
            // Green
            PBYTE(OutDataMem+$01)^:=$00;
            // Blue
            PBYTE(OutDataMem+$02)^:=$00;
            inc(InDataMem,$01);
            inc(OutDataMem,$03);
          end; // while
          Result:=True;
          Exit;
        end;  // case
      end; // case end eTargetFormat
    end;
//==================================================================//
    PIXEL_FORMAT_R8G8:
//==================================================================//
    begin
      // Target format
      case TargetFormat of
      //****************************//
        PIXEL_FORMAT_R8G8B8:
      //****************************//
        begin
          OutDataSize:=InImage^.Width * InImage^.Height * $03;
          if not InitOutImage() then
          Exit;

          while InDataMem < InDataMemMax do
          begin
            // Red
            PBYTE(OutDataMem+$00)^:=PBYTE(InDataMem+$00)^;
            // Green
            PBYTE(OutDataMem+$01)^:=PBYTE(InDataMem+$01)^;
            // Blue
            PBYTE(OutDataMem+$02)^:=$00;
            inc(InDataMem,$02);
            inc(OutDataMem,$03);
          end; // while
          Result:=True;
          Exit;
        end;  // case
      end; // case end eTargetFormat
    end;
//==================================================================//
    PIXEL_FORMAT_A4R4G4B4:;
//==================================================================//

//==================================================================//
    PIXEL_FORMAT_X4R4G4B4:;
//==================================================================//

//==================================================================//
    PIXEL_FORMAT_A1R5G5B5:;
//==================================================================//

//==================================================================//
    PIXEL_FORMAT_X1R5G5B5:;
//==================================================================//

//==================================================================//
    PIXEL_FORMAT_R8G8B8:
//==================================================================//
    begin
      // Target format
      case TargetFormat of
      //****************************//
        PIXEL_FORMAT_INDEX8:
      //****************************//
        begin
          OutDataSize:=InImage^.Width * InImage^.Height;
          if not InitOutImage() then
          Exit;

          while InDataMem < InDataMemMax do
          begin
            // Red
            PBYTE(OutDataMem+$00)^:= (PBYTE(InDataMem+$00)^ + PBYTE(InDataMem+$01)^ +PBYTE(OutDataMem+$02)^) div $03;
            // Green
            PBYTE(OutDataMem+$01)^:=PBYTE(OutDataMem+$00)^;
            // Blue
            PBYTE(OutDataMem+$02)^:=PBYTE(OutDataMem+$00)^;
            inc(InDataMem,$03);
            inc(OutDataMem,$03);
          end; // while
          Result:=True;
          Exit;
        end;  // case
      end; // case end eTargetFormat
    end;
//==================================================================//
    PIXEL_FORMAT_B8G8R8:;
//==================================================================//

//==================================================================//
    PIXEL_FORMAT_R8G8B8A8:
//==================================================================//
    begin
      // Target format
      case TargetFormat of
      //****************************//
        PIXEL_FORMAT_R6A2G6A2B6A2:
      //****************************//
        begin
          OutDataSize:=InImage^.Width*InImage^.Height* SizeOf(TRGB24Pixel);
          if not InitOutImage() then
          Exit;

          while InDataMem < InDataMemMax do
          begin
            // Red
            PBYTE(OutDataMem+$00)^:=(PBYTE(InDataMem+$00)^ and $FC) or ((PBYTE(InDataMem+$03)^ and $C0) shr $06);
            // Green
            PBYTE(OutDataMem+$01)^:=(PBYTE(InDataMem+$01)^ and $FC) or ((PBYTE(InDataMem+$03)^ and $30) shr $04);
            // Blue
            PBYTE(OutDataMem+$02)^:=(PBYTE(InDataMem+$02)^ and $FC) or ((PBYTE(InDataMem+$03)^ and $0C) shr $02);
            inc(InDataMem,SizeOf(TRGBA32Pixel));
            inc(OutDataMem,SizeOf(TRGB24Pixel));
          end; // while
          Result:=True;
          Exit;
        end;  // case
      end; // case end eTargetFormat
    end;
//==================================================================//
    PIXEL_FORMAT_R8G8B8X8:
//==================================================================//
    begin
      // Target format
      case TargetFormat of
      //****************************//
        PIXEL_FORMAT_R8G8B8A8:
      //****************************//
        begin
          Exit // TODO: Clone image ?
        end;
      //****************************//
        PIXEL_FORMAT_R8G8B8:
      //****************************//
        begin
          OutDataSize:=InImage^.Width * InImage^.Height * $03;
          if not InitOutImage() then
          Exit;

          while InDataMem < InDataMemMax do
          begin
            // Red
            PBYTE(OutDataMem+$00)^:=PBYTE(InDataMem+$00)^;
            // Green
            PBYTE(OutDataMem+$01)^:=PBYTE(InDataMem+$01)^;
            // Blue
            PBYTE(OutDataMem+$02)^:=PBYTE(InDataMem+$02)^;
            inc(InDataMem,SizeOf(TRGBA32Pixel));
            inc(OutDataMem,SizeOf(TRGB24Pixel));
          end; // while
          Result:=True;
          Exit;
        end;  // case
      end; // case end eTargetFormat
    end;
//==================================================================//
    PIXEL_FORMAT_A8R8G8B8:
//==================================================================//
    begin
      // Target format
      case TargetFormat of
      //****************************//
        PIXEL_FORMAT_R6A2G6A2B6A2:
      //****************************//
        begin
          OutDataSize:=InImage^.Width * InImage^.Height * $03;
          if not InitOutImage() then
          Exit;

          while InDataMem < InDataMemMax do
          begin
            // Red
            PBYTE(OutDataMem+$00)^:=PBYTE(InDataMem+$01)^ or ((PBYTE(InDataMem+$00)^ and $C0) shr $06);
            // Green
            PBYTE(OutDataMem+$01)^:=PBYTE(InDataMem+$02)^ or ((PBYTE(InDataMem+$00)^ and $30) shr $04);
            // Blue
            PBYTE(OutDataMem+$02)^:=PBYTE(InDataMem+$03)^ or ((PBYTE(InDataMem+$00)^ and $0C) shr $02);
            inc(InDataMem,SizeOf(TRGBA32Pixel));
            inc(OutDataMem,SizeOf(TRGB24Pixel));
          end; // while
          Result:=True;
          Exit;
        end;  // case
      end; // case end eTargetFormat

    end;
//==================================================================//
    PIXEL_FORMAT_X8R8G8B8:;
//==================================================================//

//==================================================================//
    PIXEL_FORMAT_B8G8R8A8:
//==================================================================//
    begin
      case TargetFormat of
      //****************************//
        PIXEL_FORMAT_R6A2G6A2B6A2:
      //****************************//
        begin
          OutDataSize:=InImage^.Width * InImage^.Height * $03;
          if not InitOutImage() then
          Exit;

          while InDataMem < InDataMemMax do
          begin
            // Red
            PBYTE(OutDataMem+$00)^:=PBYTE(InDataMem+$02)^ or ((PBYTE(InDataMem+$03)^ and $C0) shr $06);
            // Green
            PBYTE(OutDataMem+$01)^:=PBYTE(InDataMem+$01)^ or ((PBYTE(InDataMem+$03)^ and $30) shr $04);
            // Blue
            PBYTE(OutDataMem+$02)^:=PBYTE(InDataMem+$00)^ or ((PBYTE(InDataMem+$03)^ and $0C) shr $02);
            inc(InDataMem,SizeOf(TRGBA32Pixel));
            inc(OutDataMem,SizeOf(TRGB24Pixel));
          end; // while
          Result:=True;
          Exit;
        end;  // case
      end; // case end eTargetFormat
    end;
//==================================================================//
    PIXEL_FORMAT_B8G8R8X8:;
//==================================================================//

//==================================================================//
    PIXEL_FORMAT_R16G16B16:;
//==================================================================//

//==================================================================//
    PIXEL_FORMAT_B16G16R16:;
//==================================================================//

//==================================================================//
    PIXEL_FORMAT_A16R16G16B16:;
//==================================================================//

//==================================================================//
    PIXEL_FORMAT_X16R16G16B16:;
//==================================================================//
    PIXEL_FORMAT_B16G16R16A16:;
    PIXEL_FORMAT_B16G16R16X16:;
    PIXEL_FORMAT_R32F:;
//==================================================================//
    PIXEL_FORMAT_A32R32G32B32F:;
    PIXEL_FORMAT_X32R32G32B32F:;
//==================================================================//
    PIXEL_FORMAT_B32G32R32A32F:;
    PIXEL_FORMAT_B32G32R32X32F:;
//==================================================================//
    PIXEL_FORMAT_R16F:;
//==================================================================//
    PIXEL_FORMAT_A16R16G16B16F:;
    PIXEL_FORMAT_X16R16G16B16F:;
//==================================================================//
    PIXEL_FORMAT_B16G16R16A16F:;
    PIXEL_FORMAT_B16G16R16X16F:;
    PIXEL_FORMAT_BC1:;
    PIXEL_FORMAT_BC2:;
    PIXEL_FORMAT_BC3:;
    PIXEL_FORMAT_BC4:;
    PIXEL_FORMAT_BC5:;
//==================================================================//
    PIXEL_FORMAT_R6A2G6A2B6A2:
//==================================================================//
    begin
      // Target format
      case TargetFormat of
      //****************************//
        PIXEL_FORMAT_R8G8B8A8:
      //****************************//
        begin
          OutDataSize:=InImage^.Width * InImage^.Height * $04;
          if not InitOutImage() then
          Exit;

          while InDataMem < InDataMemMax do
          begin
            // Red
            PBYTE(OutDataMem+$00)^:=PBYTE(InDataMem+$00)^;
            // Green
            PBYTE(OutDataMem+$01)^:=PBYTE(InDataMem+$01)^;
            // Blue
            PBYTE(OutDataMem+$02)^:=PBYTE(InDataMem+$02)^;
            // Aplha
            PBYTE(OutDataMem+$03)^:=
            ((PBYTE(InDataMem+$00)^ and $03) shl $06) or
            ((PBYTE(InDataMem+$01)^ and $03) shl $04) or
            ((PBYTE(InDataMem+$02)^ and $03) shl $02);

            inc(InDataMem,SizeOf(TRGB24Pixel));
            inc(OutDataMem,SizeOf(TRGBA32Pixel));
          end; // while
          Result:=True;
          Exit;
        end;  // case
      end; // case end eTargetFormat
    end; // case
//==================================================================//
  end; // case end

  VastMessage('Error!', 'Unsupported pixel format convesion -> ' + PixelFormatToString(InImage^.PixelFormat) +' to ' + PixelFormatToString(TargetFormat));
end;

end.
