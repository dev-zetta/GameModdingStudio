unit MultiGaugeX;

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, StdCtrls;

type

  //TMultiGaugeXKind = (gkText, gkHorizontalBar, gkVerticalBar, gkPie, gkNeedle);

  PGaugeData = ^TGaugeData;
  TGaugeData = Record
    DrawArea: TRect;
    DrawString: String;
    MinValue: DWORD;
    MaxValue: DWORD;
    CurValue: DWORD;
    //ForeColor: TColor;
    //BackColor: TColor;
    BarColor: TColor;
  end;

  TMultiGaugeX = class(TGraphicControl)
  private
    //FMinValue: DWORD;
    //FMaxValue: DWORD;
    //FCurValue: DWORD;
    //FKind: TMultiGaugeXKind;
    FBarHeight: DWORD;
    FMaxBarCount: DWORD;
    FBarWidth: DWORD;
    FBarSpace: DWORD;

    FShowText: Boolean;
    FBorderStyle: TBorderStyle;
    FForeColor: TColor;
    FBackColor: TColor;
    //FDrawString: String;
    //FBarColor: TColor;
    FBorderColor: TColor;
    FBorderWidth: DWORD;

    FGaugeTable: Array of TGaugeData;
    FGaugeCount: DWORD;
    FAutoResize: Boolean;

    procedure PaintBackground(AnImage: TBitmap);
    //procedure PaintAsText(AnImage: TBitmap; PaintRect: TRect);
    //procedure PaintAsNothing(AnImage: TBitmap; PaintRect: TRect);
    procedure PaintAsBar(AnImage: TBitmap);
    procedure SetShowText(Value: Boolean);
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetForeColor(Value: TColor);
    procedure SetBackColor(Value: TColor);

    procedure SetGaugeCount(Value: DWORD);

    function GetMinValue(Index: DWORD):DWORD;
    procedure SetMinValue(Index, Value: DWORD);
    function GetMaxValue(Index: DWORD):DWORD;
    procedure SetMaxValue(Index, Value: DWORD);

    procedure SetProgress(Index, Value: DWORD);
    function GetProgress(Index: DWORD):DWORD;

    procedure SetBarColor(Index, Value: DWORD);
    function GetBarColor(Index: DWORD):DWORD;

    function GetPercentDone(Index: DWORD): DWORD;
    function GetGaugePercentDone(Gauge: PGaugeData): DWORD;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    property Align;
    property Anchors;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property Color;
    property Constraints;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property ShowText: Boolean read FShowText write SetShowText default True;
    property Visible;
    //property DrawString: String read FDrawString write FDrawString;
    //property BarColor: TColor read FBarColor write FBarColor;

    property GaugeCount: DWORD read FGaugeCount write SetGaugeCount;
    property MinValue[Index: DWORD]: DWORD read GetMinValue write SetMinValue;
    property MaxValue[Index: DWORD]: DWORD read GetMaxValue write SetMaxValue;
    property Progress[Index: DWORD]: DWORD read GetProgress write SetProgress;

    property BarColor[Index: DWORD]: DWORD read GetBarColor write SetBarColor;
    property BackColor: TColor read FBackColor write SetBackColor default clSilver;
    property ForeColor: TColor read FForeColor write SetForeColor default clGray;

    procedure AddProgress(Index, Value: DWORD);
    property PercentDone[Index: DWORD]: DWORD read GetPercentDone;

    property BorderColor: TColor read FBorderColor write FBorderColor;
    property BorderWidth: DWORD read FBorderWidth write FBorderWidth;

    property AutoResize: Boolean read FAutoResize write FAutoResize;

    procedure UpdateGauge;

  end;

implementation

uses Consts;

type
  TBltBitmap = class(TBitmap)
    procedure MakeLike(ATemplate: TBitmap);
  end;

{ TBltBitmap }

procedure TBltBitmap.MakeLike(ATemplate: TBitmap);
begin
  Width := ATemplate.Width;
  Height := ATemplate.Height;
  Canvas.Brush.Color := clWindowFrame;
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(Rect(0, 0, Width, Height));
end;

{ This function solves for x in the equation "x is y% of z". }
function SolveForX(Y, Z: DWORD): DWORD;
begin
  Result := DWORD(Trunc( Z * (Y * 0.01) ));
end;

{ This function solves for y in the equation "x is y% of z". }
function SolveForY(X, Z: DWORD): DWORD;
begin
  if Z = 0 then Result := 0
  else Result := DWORD(Trunc( (X * 100.0) / Z ));
end;

{ TMultiGaugeX }

constructor TMultiGaugeX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csFramed, csOpaque];
  { default values }
  //FMinValue := 0;
  //FMaxValue := 100;
  //FCurValue := 0;
  //FKind := gkHorizontalBar;
  FShowText := True;

  FBorderStyle := bsSingle;
  FBorderColor:= clBlack;
  FBorderWidth:= 1;

  FForeColor := clGray;
  FBackColor := clSilver;

  FBarHeight:= 0;
  FBarWidth:= 0;

  FMaxBarCount:= 0;
  FBarSpace:= 2;

  FGaugeCount:= 0;
  FAutoResize:= False;

  Width := 100;
  Height := 25;
end;

function TMultiGaugeX.GetPercentDone(Index:DWORD): DWORD;
var
  Gauge: PGaugeData;
begin
  if Index + 1 > FGaugeCount then
  begin
    Result:= 0;
    Exit;
  end;
  Gauge:= @FGaugeTable[Index];
  Result := SolveForY(Gauge^.CurValue - Gauge^.MinValue, Gauge^.MaxValue - Gauge^.MinValue);
end;


function TMultiGaugeX.GetGaugePercentDone(Gauge: PGaugeData): DWORD;
begin
  if Gauge = nil then
  begin
    Result:= 0;
    Exit;
  end;

  Result := SolveForY(Gauge^.CurValue - Gauge^.MinValue, Gauge^.MaxValue - Gauge^.MinValue);
end;

procedure TMultiGaugeX.Paint;
var
  TheImage: TBitmap;
  OverlayImage: TBltBitmap;
  PaintRect: TRect;
  //GaugeIndex, GaugeCount: DWORD;
  //GaugeData: PGaugeData;
begin
  with Canvas do
  begin
    TheImage := TBitmap.Create;
    try
      TheImage.Height := Height;
      TheImage.Width := Width;
      PaintBackground(TheImage);
      PaintRect := ClientRect;

      OverlayImage := TBltBitmap.Create;
      try
        OverlayImage.MakeLike(TheImage);
        PaintBackground(OverlayImage);

        PaintAsBar(OverlayImage);

        //if FBorderStyle = bsSingle then
        //InflateRect(PaintRect, -1, -1);

        TheImage.Canvas.CopyMode := cmSrcInvert;
        TheImage.Canvas.Draw(0, 0, OverlayImage);
        TheImage.Canvas.CopyMode := cmSrcCopy;
        //if ShowText then PaintAsText(TheImage, PaintRect);

      finally
        OverlayImage.Free;
      end;
      Canvas.CopyMode := cmSrcCopy;
      Canvas.Draw(0, 0, TheImage);
    finally
      TheImage.Destroy;
    end;
  end;
end;

procedure TMultiGaugeX.PaintBackground(AnImage: TBitmap);
var
  ARect: TRect;
begin
  with AnImage.Canvas do
  begin
    CopyMode := cmBlackness;
    ARect := Rect(0, 0, Width, Height);
    CopyRect(ARect, Animage.Canvas, ARect);
    CopyMode := cmSrcCopy;
  end;
end;
(*
procedure TMultiGaugeX.PaintAsText(AnImage: TBitmap; PaintRect: TRect);
var
  //S: string;
  X, Y: Integer;
  OverRect: TBltBitmap;
begin
  OverRect := TBltBitmap.Create;
  try
    OverRect.MakeLike(AnImage);
    PaintBackground(OverRect);
    //S := Format('%d%%', [PercentDone]);
    with OverRect.Canvas do
    begin
      Brush.Style := bsClear;
      Font := Self.Font;
      Font.Color := clWhite;
      with PaintRect do
      begin
        X := (Right - Left + 1 - TextWidth(FDrawString)) div 2;
        Y := (Bottom - Top + 1 - TextHeight(FDrawString)) div 2;
      end;
      TextRect(PaintRect, X, Y, FDrawString);
    end;
    AnImage.Canvas.CopyMode := cmSrcInvert;
    AnImage.Canvas.Draw(0, 0, OverRect);
  finally
    OverRect.Free;
  end;
end;

procedure TMultiGaugeX.PaintAsNothing(AnImage: TBitmap; PaintRect: TRect);
begin
  with AnImage do
  begin
    Canvas.Brush.Color := BackColor;
    Canvas.FillRect(PaintRect);
  end;
end;
*)
procedure TMultiGaugeX.PaintAsBar(AnImage: TBitmap);
var
  //FillSize: DWORD;
  //W, H: Integer;
  GaugeData: PGaugeData;
  DrawRect: TRect;
  //BarWidth, BarHeight: DWORD;
  BarIndex, BarCount: DWORD;
  //MaxBarCount: DWORD;
  BarRect: TRect;
  //BarSpace: DWORD;
  R, G, B: BYTE;
  GaugeIndex, GaugeCount : DWORD;
begin
  //W := PaintRect.Right - PaintRect.Left + 1;
  //H := PaintRect.Bottom - PaintRect.Top + 1;

  with AnImage.Canvas do
  begin
    if (FBorderStyle = bsSingle) then
    begin
      DrawRect:=ClientRect;
      Brush.Color := FBackColor;
      FillRect(DrawRect);

      //DrawFocusRect(DrawRect);
      //InflateRect(DrawRect, -FBorderWidth, -FBorderWidth);
      //Brush.Color := BackColor;
     // FrameRect(DrawRect);
      //FillRect(DrawRect);
      Pen.Width:= FBorderWidth;
      Pen.Color:= FBorderColor;
      Rectangle(DrawRect);
    end;

    GaugeCount:= FGaugeCount;
    for GaugeIndex:=0 to GaugeCount - 1 do
    begin
      GaugeData:= @FGaugeTable[GaugeIndex];
      if GaugeData = nil then
      Continue;

      BarCount:= Trunc((FMaxBarCount / 10) * (GetGaugePercentDone(GaugeData) / 10));
      //if BarCount = 0 then
      //Continue;

      DrawRect:=GaugeData^.DrawArea;
      if (FBorderStyle = bsSingle) then
      begin
        InflateRect(DrawRect, -(FBorderWidth+1), -(FBorderWidth+1));
      end;

      //Brush.Color := BackColor;
      //FillRect(DrawRect);
      //Pen.Color := GaugeData^.ForeColor;
      //Pen.Width := 1;



      (*
      BarRect.Left:= (DrawRect.Left - 1) + FBarSpace;
      BarRect.Top:= (DrawRect.Top - 1) + 2;
      BarRect.Right:= (DrawRect.Left - 1) + FBarWidth  + FBarSpace;
      BarRect.Bottom:= (DrawRect.Top - 1) + FBarHeight - 2;
      *)
      BarRect.Left:= DrawRect.Left;
      BarRect.Top:= DrawRect.Top;
      BarRect.Right:= DrawRect.Left + FBarWidth;
      BarRect.Bottom:= DrawRect.Bottom ;

      if (FGaugeCount > 1) and (FBorderWidth >= 1) then
      begin
        if ((GaugeIndex mod 2) = 0) then
        begin
          Inc(BarRect.Bottom);
        end
          else
        begin
          Dec(BarRect.Top);
        end;
      end;

      //R:=GaugeData^.BarColor Shr 0;
      //G:=GaugeData^.BarColor Shr 8;
      //B:=GaugeData^.BarColor Shr 16;

      //Brush.Color:=GaugeData^.BarColor;
      for BarIndex:=0 to FMaxBarCount - 1 do
      begin
        //Brush.Color:=clRed;
        //Brush.Color:= RGB(R, G, B);
        //Brush.Style:=bsHorizontal;
        if BarIndex < BarCount then
        begin
          Brush.Color:=GaugeData^.BarColor;

        end
          else
        begin
          Brush.Color:=FForeColor;
        end;

        FillRect(BarRect);
        Inc(BarRect.Left, FBarWidth + FBarSpace );
        Inc(BarRect.Right, FBarWidth + FBarSpace);
      end;

      //if FillSize > 0 then
      //FillRect(Rect(PaintRect.Left, PaintRect.Top, FillSize, H));
    end;
  end;
end;
(*
procedure TMultiGaugeX.PaintAsPie(AnImage: TBitmap; PaintRect: TRect);
var
  MiddleX, MiddleY: Integer;
  Angle: Double;
  W, H: Integer;
begin
  W := PaintRect.Right - PaintRect.Left;
  H := PaintRect.Bottom - PaintRect.Top;
  if FBorderStyle = bsSingle then
  begin
    Inc(W);
    Inc(H);
  end;
  with AnImage.Canvas do
  begin
    Brush.Color := Color;
    FillRect(PaintRect);
    Brush.Color := BackColor;
    Pen.Color := ForeColor;
    Pen.Width := 1;
    Ellipse(PaintRect.Left, PaintRect.Top, W, H);
    if PercentDone > 0 then
    begin
      Brush.Color := ForeColor;
      MiddleX := W div 2;
      MiddleY := H div 2;
      Angle := (Pi * ((PercentDone / 50) + 0.5));
      Pie(PaintRect.Left, PaintRect.Top, W, H,
        Integer(Round(MiddleX * (1 - Cos(Angle)))),
        Integer(Round(MiddleY * (1 - Sin(Angle)))), MiddleX, 0);
    end;
  end;
end;

procedure TMultiGaugeX.PaintAsNeedle(AnImage: TBitmap; PaintRect: TRect);
var
  MiddleX: Integer;
  Angle: Double;
  X, Y, W, H: Integer;
begin
  with PaintRect do
  begin
    X := Left;
    Y := Top;
    W := Right - Left;
    H := Bottom - Top;
    if FBorderStyle = bsSingle then
    begin
      Inc(W);
      Inc(H);
    end;
  end;
  with AnImage.Canvas do
  begin
    Brush.Color := Color;
    FillRect(PaintRect);
    Brush.Color := BackColor;
    Pen.Color := ForeColor;
    Pen.Width := 1;
    Pie(X, Y, W, H * 2 - 1, X + W, PaintRect.Bottom - 1, X, PaintRect.Bottom - 1);
    MoveTo(X, PaintRect.Bottom);
    LineTo(X + W, PaintRect.Bottom);
    if PercentDone > 0 then
    begin
      Pen.Color := ForeColor;
      MiddleX := Width div 2;
      MoveTo(MiddleX, PaintRect.Bottom - 1);
      Angle := (Pi * ((PercentDone / 100)));
      LineTo(Integer(Round(MiddleX * (1 - Cos(Angle)))),
        Integer(Round((PaintRect.Bottom - 1) * (1 - Sin(Angle)))));
    end;
  end;
end;

procedure TMultiGaugeX.SeTMultiGaugeXKind(Value: TMultiGaugeXKind);
begin
  if Value <> FKind then
  begin
    FKind := Value;
    Refresh;
  end;
end;
*)
procedure TMultiGaugeX.SetShowText(Value: Boolean);
begin
  if Value <> FShowText then
  begin
    FShowText := Value;
    //Refresh;
  end;
end;

procedure TMultiGaugeX.SetBorderStyle(Value: TBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    //Refresh;
  end;
end;

procedure TMultiGaugeX.SetForeColor(Value: TColor);
begin
  if Value <> FForeColor then
  begin
    FForeColor := Value;
    //Refresh;
  end;
end;

procedure TMultiGaugeX.SetBackColor(Value: TColor);
begin
  if Value <> FBackColor then
  begin
    FBackColor := Value;
    //Refresh;
  end;
end;

procedure TMultiGaugeX.SetMinValue(Index, Value: DWORD);
var
  GaugeData: PGaugeData;
begin
  if (Index+1) > FGaugeCount then
  Exit;

  GaugeData:= @FGaugeTable[Index];
  if Value <> GaugeData^.MinValue then
  begin
    if Value > GaugeData^.MaxValue then
      if not (csLoading in ComponentState) then
        raise EInvalidOperation.CreateFmt(SOutOfRange, [-MaxInt, GaugeData^.MaxValue - 1]);
    GaugeData^.MinValue := Value;
    if GaugeData^.CurValue < Value then GaugeData^.CurValue := Value;
    //Refresh;
  end;
end;

procedure TMultiGaugeX.SetMaxValue(Index, Value: DWORD);
var
  GaugeData: PGaugeData;
begin
  if (Index+1) > FGaugeCount then
  Exit;

  GaugeData:= @FGaugeTable[Index];
  if Value <> GaugeData^.MaxValue then
  begin
    if Value < GaugeData^.MinValue then
      if not (csLoading in ComponentState) then
        raise EInvalidOperation.CreateFmt(SOutOfRange, [GaugeData^.MinValue + 1, MaxInt]);
    GaugeData^.MaxValue := Value;
    if GaugeData^.CurValue > Value then
    GaugeData^.CurValue := Value;
   // Refresh;
  end;
end;

procedure TMultiGaugeX.SetProgress(Index, Value: DWORD);
var
  GaugeData: PGaugeData;
  //TempPercent: DWORD;
begin
  if (Index+1) > FGaugeCount then
  Exit;

  GaugeData:= @FGaugeTable[Index];
  //TempPercent := GetGaugePercentDone(GaugeData);  { remember where we were }
  if Value < GaugeData^.MinValue then
    Value := GaugeData^.MinValue
  else if Value > GaugeData^.MaxValue then
    Value := GaugeData^.MaxValue;

  GaugeData^.CurValue := Value;
  (*
  if GaugeData^.CurValue <> Value then
  begin
    GaugeData^.CurValue := Value;
    if TempPercent <> GetGaugePercentDone(GaugeData) then { only refresh if percentage changed }
      Refresh;
  end;
*)
end;

procedure TMultiGaugeX.AddProgress(Index, Value: DWORD);
var
  GaugeData: PGaugeData;
begin
  if (Index+1) > FGaugeCount then
  Exit;

  GaugeData:= @FGaugeTable[Index];
  GaugeData^.CurValue:= GaugeData^.CurValue + Value;
  if GaugeData^.CurValue > GaugeData^.MaxValue then
  GaugeData^.CurValue:= GaugeData^.MaxValue
    else
  if GaugeData^.CurValue < GaugeData^.MinValue then
  GaugeData^.CurValue:= GaugeData^.MinValue;

  //Refresh;
end;

procedure TMultiGaugeX.SetGaugeCount(Value: DWORD);
var
  //IsGaugeUpdate: Boolean;
  GaugeData: PGaugeData;
  //UpdateIndex, UpdateCount: DWORD;
  DrawRect: TRect;
  GaugeHeight: DWORD;
  WidthNeed: DWORD;
  HeightNeed: DWORD;
  GaugeIndex: DWORD;
begin
  if Value = FGaugeCount then
  Exit;

  if (Value < 0) or (Value = 0) then
  begin
    FGaugeCount:= 0;
    SetLength(FGaugeTable, 0);
    Exit;
  end;

  if FAutoResize then
  begin
    HeightNeed:= Value * 10;
    if HeightNeed > Height then
    Height:=HeightNeed;

    WidthNeed:= (10 * 10) + FBarSpace;
    if WidthNeed > Width then
    Width:=WidthNeed;
  end;

  FMaxBarCount:= Width div 10;
  FBarWidth:= Width div FMaxBarCount;
  FBarHeight:= (Height div Value) - FBorderWidth;
  Dec(FBarWidth, FBarSpace);

  if Value < FGaugeCount then
  begin
    FGaugeCount:= Value;
    SetLength(FGaugeTable, FGaugeCount);
    Exit;
  end;

  FGaugeCount:= Value;
  SetLength(FGaugeTable, FGaugeCount);

  GaugeHeight:= Height div Value;
  DrawRect.Left:= 0;
  DrawRect.Top:=0;
  DrawRect.Right:= Width;
  DrawRect.Bottom:= GaugeHeight;

  for GaugeIndex:= 0 to  (Value - 1) do
  begin
    GaugeData:= @FGaugeTable[GaugeIndex];
    GaugeData^.MinValue:=0;
    GaugeData^.MaxValue:=100;
    GaugeData^.CurValue:=0;
    GaugeData^.DrawArea:=DrawRect;
    Inc(DrawRect.Top, GaugeHeight);
    Inc(DrawRect.Bottom, GaugeHeight);
  end;
end;

function TMultiGaugeX.GetMinValue(Index: DWORD):DWORD;
begin
  if (Index+1) > FGaugeCount then
  begin
    Result:= 0;
    Exit;
  end;

  Result:=FGaugeTable[Index].MinValue;
end;

function TMultiGaugeX.GetMaxValue(Index: DWORD):DWORD;
begin
  if (Index+1) > FGaugeCount then
  begin
    Result:= 0;
    Exit;
  end;

  Result:=FGaugeTable[Index].MaxValue;
end;

function TMultiGaugeX.GetProgress(Index: DWORD):DWORD;
begin
  if (Index+1) > FGaugeCount then
  begin
    Result:= 0;
    Exit;
  end;

  Result:=FGaugeTable[Index].CurValue;
end;


function TMultiGaugeX.GetBarColor(Index: DWORD):DWORD;
begin
  if (Index+1) > FGaugeCount then
  begin
    Result:= 0;
    Exit;
  end;

  Result:=FGaugeTable[Index].BarColor;
end;

procedure TMultiGaugeX.SetBarColor(Index, Value: DWORD);
begin
  if (Index+1) > FGaugeCount then
  begin
    Exit;
  end;

  FGaugeTable[Index].BarColor:=Value;
end;

procedure TMultiGaugeX.UpdateGauge();
begin
(*
  if GaugeData^.CurValue <> Value then
  begin
    GaugeData^.CurValue := Value;
    if TempPercent <> GetGaugePercentDone(GaugeData) then { only refresh if percentage changed }
      Refresh;
  end;
*)
  Refresh;
end;



end.
