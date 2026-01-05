unit AsciiEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,SharedFunc, Menus, Grids, StdCtrls, ColorGrd, ExtCtrls, ButtonGroup,
  AppEvnts, ComCtrls;

type
  TAsciiEditorForm = class(TForm)
    InfoGrid: TStringGrid;
    AsciiGrid: TStringGrid;
    ColorDialog: TColorDialog;
    ColorGrid: TDrawGrid;
    Panel1: TPanel;
    cbFontList: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    shBackColor: TShape;
    shForeColor: TShape;
    bgMainCommand: TButtonGroup;
    OpenDialog: TOpenDialog;
    Panel2: TPanel;
    SaveDialog: TSaveDialog;
    btnResetBack: TButton;
    btnResetFore: TButton;
    Button1: TButton;
    ApplicationEvents1: TApplicationEvents;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    edtBrushWidth: TEdit;
    udBrushWidth: TUpDown;
    edtBrushHeight: TEdit;
    udBrushHeight: TUpDown;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Label3: TLabel;
    Button10: TButton;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cbFontListChange(Sender: TObject);
    procedure InfoGridKeyPress(Sender: TObject; var Key: Char);
    procedure InfoGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ColorGridDblClick(Sender: TObject);
    procedure ColorGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ColorGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColorGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure InfoGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ibNoneClick(Sender: TObject);
    procedure AsciiGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure InfoGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure InfoGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure InfoGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure bgMainCommandButtonClicked(Sender: TObject; Index: Integer);
    procedure shBackColorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure shForeColorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnResetForeClick(Sender: TObject);
    procedure btnResetBackClick(Sender: TObject);

    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure InfoGridTopLeftChanged(Sender: TObject);
    procedure udBrushWidthChanging(Sender: TObject; var AllowChange: Boolean);
    procedure udBrushHeightChanging(Sender: TObject; var AllowChange: Boolean);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button10Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AsciiEditorForm: TAsciiEditorForm;

implementation

uses Main;

{$R *.dfm}

type
  PGridCellInfo = ^TGridCellInfo;
  TGridCellInfo = Record
    Rect: TRect;
    Value: String;
    BackColor: TColor;
    ForeColor: TColor;
  end;

  TInfoToolType = (itNone, itPen, itBrush, itRectangle, itFrame);

  TColorPalette = Array[0..15] of Array[0..7] of TColor;

  PRectangleInfo = ^TRectangleInfo;
  TRectangleInfo = Record
    Top: Integer;
    Left: Integer;
    Bottom: Integer;
    Right: Integer;
    Value: String;
    ForeColor: TColor;
    BackColor: TColor;
  end;

  PInfoDocument = ^TInfoDocument;
  TInfoDocument = Record
    DrawTick: DWORD;
    IsLoaded: Boolean;
    Canvas: TCanvas;
    AutoCellMove: Boolean;

    Bitmap: TBitmap;
    BitmapWidth: DWORD;
    BitmapHeight: DWORD;

    RowIndex: DWORD;
    RowCount: DWORD;

    ColIndex: DWORD;
    ColCount: DWORD;

    Cells: Array of Array of TGridCellInfo;

    CellWidth: DWORD;
    CellHeight: DWORD;

    ColorTable: TColorPalette;
    ColorRowIndex: DWORD;
    ColorColIndex: DWORD;

    BackColor: TColor;
    ForeColor: TColor;

    Tool: TInfoToolType;

    AsciiChar: String;

    StartDraw: Boolean;

    Rectangle: TRectangleInfo;

    BrushWidth: DWORD;
    BrushHeight: DWORD;
  end;

  TFillOperation = (foFillErase, foFillChar, foFillFore, foFillBack, foFillNegative);


const
  DEFAULT_PALETTE_PATH = 'Data\default_palette.pal';

var
  InfoDocument: TInfoDocument;
  ExePath: String;



(*
function DrawGridCell(const Document: PInfoDocument; const ColIndex, RowIndex: DWORD):Boolean; overload;
var
  GridCell: PGridCellInfo;
begin
  Result:= False;
  if ColIndex >= Document^.ColCount then
  Exit;

  if RowIndex >= Document^.RowCount then
  Exit;

  GridCell:= @Document^.Cells[ColIndex, RowIndex];
  Document^.Canvas.Brush.Color:= GridCell^.BackColor;
  Document^.Canvas.Font.Color:= GridCell^.ForeColor;
  Document^.Canvas.FillRect(GridCell^.Rect);
  Document^.Canvas.TextOut(GridCell^.Rect.Left + 2, GridCell^.Rect.Top + 2, GridCell^.Value);
end;

function DrawGridCell(const Document: PInfoDocument; const GridCell: PGridCellInfo):Boolean; overload;
begin
  Result:= False;
  Document^.Canvas.Brush.Color:= GridCell^.BackColor;
  Document^.Canvas.Font.Color:= GridCell^.ForeColor;
  Document^.Canvas.FillRect(GridCell^.Rect);
  Document^.Canvas.TextOut(GridCell^.Rect.Left + 2, GridCell^.Rect.Top + 2, GridCell^.Value);
end;
*)

function BitmapToAscii (const FileName: String): Boolean;
type
  TRGB24 = Packed Record
    R: BYTE;
    G: BYTE;
    B: BYTE;
  end;

  TColorData = Array[0..128000] of TRGB24;
  PColorData = ^TColorData;

const
  MAX_SHADES = 10;
  Shades : Array[0..MAX_SHADES - 1] of CHAR = ('#','$','O','=','+','|','-','^','.',' ');

var
  X,Y : DWORD;
  Bitmap: TBitmap;
  ScanLine: PColorData;
  AverageColor: Single;

  AsciiData: String;
  OutFile: TextFile;
begin

  Result:= False;
  if not FileExists(FileName) then
    Exit;

  Bitmap:= TBitmap.Create;
  Bitmap.LoadFromFile(FileName);
  Bitmap.PixelFormat:= pf24bit;

  AssignFile(OutFile, ChangeFileExt(FileName, '.nfo'));
  Rewrite(OutFile);

  SetLength(AsciiData, Bitmap.Width + 2);
  AsciiData[Bitmap.Width + 1]:= #13;
  AsciiData[Bitmap.Width + 1]:= #10;

  for Y := 0 to Bitmap.Height - 1 do
  begin
    ScanLine:= Bitmap.ScanLine[Y];
    for X := 0 to Bitmap.Width - 1 do
    begin
      AverageColor:= (ScanLine^[X].R + ScanLine^[X].G + ScanLine^[X].B) / 3;
      AverageColor:= AverageColor / (256 / MAX_SHADES);

      if AverageColor >= MAX_SHADES then
      AverageColor:= AverageColor - 1;

      AsciiData[X + 1]:= Shades[Round(AverageColor)];
    end;

    WriteLn(OutFile, AsciiData);
  end;

  CloseFile(OutFile);
  Bitmap.Free;
  Result:= True;
end;

function GenerateRandomPalette(const Document: PInfoDocument):Boolean;
var
  RowIndex: DWORD;
  ColIndex: DWORD;
begin

  Result:= False;
  for RowIndex := 0 to 8 - 1 do
  begin
    for ColIndex := 0 to 16 - 1 do
    begin
      Document^.ColorTable[ColIndex, RowIndex]:= RGB(Random(255), Random(255), Random(255));
    end;
  end;
  Result:= True;
end;

function LoadPaletteFromFile(const FileName: String; const Document: PInfoDocument):Boolean;
var
  InFile: File of Byte;
begin

  Result:= False;
  if Document = nil then
    Exit;

  if not FileExists(FileName) then
    Exit;

  AssignFile(InFile, FileName);
  Reset(InFile);

  BlockRead(InFile, Document^.ColorTable[0][0], SizeOf(TColorPalette));
  CloseFile(InFile);

  Result:= True;
end;

function SavePaletteToFile(const FileName: String; const Document: PInfoDocument):Boolean;
var
  InFile: File of Byte;
begin

  Result:= False;
  if Document = nil then
    Exit;

  AssignFile(InFile, FileName);
  Rewrite(InFile);

  BlockWrite(InFile, Document^.ColorTable[0][0], SizeOf(TColorPalette));
  CloseFile(InFile);

  Result:= True;
end;

procedure FillAciiGrid ();
var
  RowIndex: DWORD;
  ColIndex: DWORD;
  CharByte: BYTE;
begin

  CharByte:= 0;
  for RowIndex := 0 to 8 - 1 do
  begin
    for ColIndex := 0 to 32 - 1 do
    begin
      AsciiEditorForm.AsciiGrid.Cells[ColIndex, RowIndex]:= CHAR(CharByte);
      Inc(CharByte);
    end;
  end;
end;

procedure FillInfoGrid(const Document: PInfoDocument);
var
  RowIndex, ColIndex: DWORD;
  GridCell: PGridCellInfo;
begin

  if Document = nil then
    Exit;

  AsciiEditorForm.InfoGrid.ColCount:= Document^.ColCount;
  AsciiEditorForm.InfoGrid.RowCount:= Document^.RowCount;

  for RowIndex := 0 to Document^.RowCount - 1 do
  begin
    for ColIndex := 0 to Document^.ColCount - 1 do
    begin
      GridCell:= @Document^.Cells[ColIndex, RowIndex];
      AsciiEditorForm.InfoGrid.Cells[ColIndex, RowIndex]:=GridCell^.Value;
    end;
  end;

end;

function InitInfoDocument(const Document: PInfoDocument; const Canvas: TCanvas): Boolean;
begin

  Result:= False;
  if Document = nil then
    Exit;

  FillChar(Document^, SizeOf(TInfoDocument), 0);
  Document^.Canvas:= Canvas;
  Document^.ForeColor:= clBlack;
  Document^.BackColor:= clWhite;

  Result:= True;
end;

function LoadInfoFromFile(const FileName: String; const Document: PInfoDocument): Boolean;
var
  InFile: TextFile;
  LineList: Array of String;
  LineIndex, LineCount: DWORD;

  MaxLineLength, LineLength: DWORD;

  //CharIndex: DWORD;
  GridCell: PGridCellInfo;

  ColIndex, RowIndex: DWORD;
begin

  Result:= False;

  if Document = nil then
    Exit;

  if not FileExists(FileName) then
    Exit;

  AssignFile(InFile, FileName);
  Reset(InFile);

  LineCount:= 0;

  MaxLineLength:= 0;
  while not EOF(InFile) do
  begin
    SetLength(LineList, LineCount + 1);
    ReadLn(InFile, LineList[LineCount]);
    LineLength:= Length(LineList[LineCount]);

    if LineLength > MaxLineLength  then
    MaxLineLength:= LineLength;

    Inc(LineCount);
  end;
  CloseFile(InFile);

  Document^.RowCount:= LineCount;
  Document^.ColCount:= MaxLineLength;

  SetLength(Document^.Cells, Document^.ColCount);
  for ColIndex := 0 to Document^.ColCount - 1 do
  begin
    SetLength(Document^.Cells[ColIndex], Document^.RowCount);

    for RowIndex := 0 to Document^.RowCount - 1 do
    begin
      GridCell:= @Document^.Cells[ColIndex][RowIndex];

      if ColIndex < Length(LineList[RowIndex]) then
        GridCell^.Value:= Copy(LineList[RowIndex], ColIndex + 1, 1)
      else GridCell^.Value:= ' ';

      GridCell^.BackColor:= clWhite;
      GridCell^.ForeColor:= clBlack;
    end;
  end;

  Document^.IsLoaded:= True;
  Result:= True;
end;

function SaveInfoToBitmap(const FileName: String; const Document: PInfoDocument): Boolean;
var
  CellRect, CanvasRect: TRect;

  Bitmap: TBitmap;
  BitmapWidth: DWORD;
  BitmapHeight: DWORD;
  RowIndex, ColIndex: DWORD;

  CharWidth, CharHeight: DWORD;

  GridCell: PGridCellInfo;
begin

  Result:= False;
  if Document = nil then
    Exit;

  CharWidth:= Document^.Canvas.Font.Size - 2;
  CharHeight:= Document^.Canvas.Font.Size;

  BitmapWidth:= Document^.ColCount * CharWidth;
  BitmapHeight:= Document^.RowCount * CharHeight;

  Bitmap:= TBitmap.Create;
  Bitmap.PixelFormat:= pf24Bit;
  Bitmap.SetSize(BitmapWidth, BitmapHeight);
  Bitmap.Canvas.Font:= Document^.Canvas.Font;

  for RowIndex := 0 to Document^.RowCount - 1 do
  begin
    for ColIndex := 0 to Document^.ColCount - 1 do
    begin
      CellRect.Top:= RowIndex * CharHeight;
      CellRect.Left:= ColIndex * CharWidth;
      CellRect.Right:= CellRect.Left + CharWidth;
      CellRect.Bottom:= CellRect.Top + CharHeight;

      GridCell:= @Document^.Cells[ColIndex][RowIndex];
      Bitmap.Canvas.Brush.Color:= GridCell^.BackColor;
      Bitmap.Canvas.Font.Color:= GridCell^.ForeColor;

      Bitmap.Canvas.FillRect(CellRect);
      Bitmap.Canvas.TextOut(CellRect.Left , CellRect.Top , GridCell^.Value);
    end;
  end;

  Bitmap.SaveToFile(FileName);
  Bitmap.Free;
  Result:= True;
end;

function SaveInfoToFile(const FileName: String; const Document: PInfoDocument): Boolean;
var
  RowIndex, ColIndex: DWORD;

  GridCell: PGridCellInfo;
  InFile: TextFile;
  RowLine: String;
begin

  Result:= False;
  if Document = nil then
    Exit;

  AssignFile(InFile, FileName);
  Rewrite(InFile);

  SetLength(RowLine, Document^.ColCount);
  for RowIndex := 0 to Document^.RowCount - 1 do
  begin
    for ColIndex := 0 to Document^.ColCount - 1 do
    begin
      GridCell:= @Document^.Cells[ColIndex][RowIndex];
      RowLine[ColIndex + 1]:= GridCell^.Value[1];
    end;
    WriteLn(InFile, RowLine);
  end;

  CloseFile(InFile);
  Result:= True;
end;

function FillInfoDocument(const Document: PInfoDocument; const FillOperation: TFillOperation): Boolean;
var
  ColIndex, RowIndex: DWORD;
  GridCell: PGridCellInfo;
begin

  Result:= False;
  if Document = nil then
    Exit;

  for ColIndex := 0 to Document^.ColCount - 1 do
  begin
    for RowIndex := 0 to Document^.RowCount - 1 do
    begin
      GridCell:= @Document^.Cells[ColIndex][RowIndex];

      case FillOperation of
        foFillErase:
        begin
          GridCell^.Value:= ' ';
          GridCell^.BackColor:= clWhite;
          GridCell^.ForeColor:= clBlack;
        end;
        foFillChar:
        begin
          GridCell^.Value:= Document^.AsciiChar;
        end;
        foFillFore:
        begin
          GridCell^.ForeColor:= Document^.ForeColor;
        end;
        foFillBack:
        begin
          GridCell^.BackColor:= Document^.BackColor;
        end;
        foFillNegative:
        begin
          GridCell^.ForeColor:= Document^.BackColor;
          GridCell^.BackColor:= Document^.ForeColor;
        end;
      end;
    end;
  end;
  Result:= True;
end;

procedure TAsciiEditorForm.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
var
  GridCell: PGridCellInfo;
begin

  Handled:= False;
  if (Msg.hwnd <> InfoGrid.Handle) then
    Exit;

  case Msg.message of
    WM_KEYDOWN:
    begin
      GridCell:= @InfoDocument.Cells[InfoDocument.ColIndex, InfoDocument.RowIndex];

      if Msg.wParam = VK_TAB then
      begin
        if InfoDocument.IsLoaded then
        begin
          if (InfoGrid.Col + 5 < InfoGrid.ColCount) then
          begin
            InfoGrid.Col:= InfoGrid.Col + 5;
          end;
        end;

        Handled:= True;
        Exit;
      end;

      if Msg.wParam = VK_BACK then   // backspace pressed
      begin
        if (InfoGrid.Col = 0) then
        begin
          if InfoGrid.Row > 0 then
          begin
            InfoGrid.Col:= InfoGrid.ColCount - 1;
            InfoGrid.Row:= InfoGrid.Row - 1;
          end;
        end
          else
        begin
          InfoGrid.Col:= InfoGrid.Col - 1;
        end;

        GridCell^.Value:= ' ';
        Handled:= True;
        Exit;
      end;

      if Msg.wParam = VK_RETURN then // Enter pressed
      begin
        if (InfoGrid.Row + 1 < InfoGrid.RowCount) then
        begin
          InfoGrid.Col:= 0;
          InfoGrid.Row:= InfoGrid.Row + 1;
        end;
        Handled:= True;
        Exit;
      end;
      (*
      if Key = VK_CONTROL then
      begin
        InfoDocument.Tool:= itAsciiDraw;
      end;
      *)
    end;
  end;
end;

procedure TAsciiEditorForm.AsciiGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if (ACol = 0) and (ARow = 0) then // Prevent from selecting null char
    InfoDocument.AsciiChar:= ' '
  else InfoDocument.AsciiChar:= AsciiGrid.Cells[ACol, ARow];

  //InfoDocument.Tool:= itAsciiDraw;
end;

procedure TAsciiEditorForm.bgMainCommandButtonClicked(Sender: TObject;
  Index: Integer);
begin
  case Index of
    0:
    begin

    end;
    1:
    begin

    end;
    2:
    begin

    end;
    3:
    begin
      OpenDialog.Filter:= 'NFO Files|*.nfo';
      OpenDialog.DefaultExt:= '.nfo';
      if not OpenDialog.Execute then
        Exit;

      if LoadInfoFromFile(OpenDialog.FileName, @InfoDocument) then
        FillInfoGrid(@InfoDocument);
    end;
    4:
    begin
      SaveDialog.Filter:= 'NFO Files|*.nfo';
      SaveDialog.DefaultExt:= '.nfo';
      if not SaveDialog.Execute then
        Exit;
      
      SaveInfoToFile(SaveDialog.FileName, @InfoDocument);
    end;
    5:
    begin
      SaveDialog.Filter:= 'Bitmap Files|*.bmp';
      SaveDialog.DefaultExt:= '.bmp';
      if not SaveDialog.Execute then
        Exit;

      SaveInfoToBitmap(SaveDialog.FileName, @InfoDocument);
    end;
    6: // Load palette
    begin
      OpenDialog.Filter:= 'Palette Files|*.pal';
      OpenDialog.DefaultExt:= '.pal';
      if not OpenDialog.Execute then
        Exit;

      LoadPaletteFromFile(OpenDialog.FileName, @InfoDocument);
    end;
    7: // Save palette
    begin
      SaveDialog.Filter:= 'Palette Files|*.pal';
      SaveDialog.DefaultExt:= '.pal';
      if not SaveDialog.Execute then
        Exit;

      SavePaletteToFile(SaveDialog.FileName, @InfoDocument);
    end;
    8: // Randomize palette
    begin
      GenerateRandomPalette(@InfoDocument);
      ColorGrid.Repaint;
    end;
    9: // BmpToAscii
    begin
      OpenDialog.Filter:= 'Bitmap Files|*.bmp';
      OpenDialog.DefaultExt:= '.bmp';
      if not OpenDialog.Execute then
        Exit;

      if BitmapToAscii(OpenDialog.FileName) then
        ShowMessage('Bitmap successfully converted!')
      else ShowMessage('Failed to convert Bitmap to Ascii');
    end;

  end;
end;

procedure TAsciiEditorForm.btnResetBackClick(Sender: TObject);
begin
  shBackColor.Brush.Color:= clWhite;
end;

procedure TAsciiEditorForm.btnResetForeClick(Sender: TObject);
begin
  shForeColor.Brush.Color:= clBlack;
end;

procedure TAsciiEditorForm.Button10Click(Sender: TObject);
begin
  ShowMessage('Are you blind ?');
end;

procedure TAsciiEditorForm.Button1Click(Sender: TObject);
begin
  InfoDocument.Tool:= itNone;
end;

procedure TAsciiEditorForm.Button2Click(Sender: TObject);
begin
  InfoDocument.Tool:= itPen;
end;

procedure TAsciiEditorForm.Button3Click(Sender: TObject);
begin
  InfoDocument.Tool:= itRectangle;
end;

procedure TAsciiEditorForm.Button4Click(Sender: TObject);
begin
  InfoDocument.Tool:= itFrame;
end;

procedure TAsciiEditorForm.Button5Click(Sender: TObject);
begin
  InfoDocument.Tool:= itBrush;
  InfoDocument.BrushWidth:= udBrushWidth.Position;
  InfoDocument.BrushHeight:= udBrushHeight.Position;
end;

procedure TAsciiEditorForm.Button6Click(Sender: TObject);
begin
  FillInfoDocument(@InfoDocument, foFillErase);
  InfoGrid.Repaint;
end;

procedure TAsciiEditorForm.Button7Click(Sender: TObject);
begin
  FillInfoDocument(@InfoDocument, foFillChar);
  InfoGrid.Repaint;
end;

procedure TAsciiEditorForm.Button8Click(Sender: TObject);
begin
  FillInfoDocument(@InfoDocument, foFillBack);
  InfoGrid.Repaint;
end;

procedure TAsciiEditorForm.Button9Click(Sender: TObject);
begin
  FillInfoDocument(@InfoDocument, foFillFore);
  InfoGrid.Repaint;
end;

procedure TAsciiEditorForm.cbFontListChange(Sender: TObject);
begin
  InfoGrid.Font.Name:= cbFontList.Text;
  AsciiGrid.Font.Name:= cbFontList.Text;

  InfoGrid.Canvas.Font.Name:= InfoGrid.Font.Name;
end;

procedure TAsciiEditorForm.ColorGridDblClick(Sender: TObject);
begin
  if ColorDialog.Execute() then
  begin
    InfoDocument.ColorTable[ColorGrid.Col, ColorGrid.Row]:= ColorDialog.Color;
    InfoDocument.ForeColor:= ColorDialog.Color;
  end;
end;

procedure TAsciiEditorForm.ColorGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  ColorGrid.Canvas.Brush.Color:= InfoDocument.ColorTable[ACol][ARow];
  ColorGrid.Canvas.FillRect(Rect);
end;

procedure TAsciiEditorForm.ColorGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ARow, ACol: Integer;
begin
  case Button of
    mbLeft:
    begin
      InfoDocument.ForeColor:= InfoDocument.ColorTable[InfoDocument.ColorColIndex, InfoDocument.ColorRowIndex];
      shForeColor.Brush.Color:= InfoDocument.ForeColor;
    end;
    mbRight:
    begin
      ColorGrid.MouseToCell(X, Y, ACol, ARow);
      InfoDocument.ColorColIndex:= ACol;
      InfoDocument.ColorRowIndex:= ARow;
      InfoDocument.BackColor:= InfoDocument.ColorTable[InfoDocument.ColorColIndex, InfoDocument.ColorRowIndex];
      shBackColor.Brush.Color:= InfoDocument.BackColor;
    end;
  end;
end;

procedure TAsciiEditorForm.ColorGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  InfoDocument.ColorColIndex:= ACol;
  InfoDocument.ColorRowIndex:= ARow;
  CanSelect:= True;
end;

procedure TAsciiEditorForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SavePaletteToFile(ExePath + DEFAULT_PALETTE_PATH, @InfoDocument);
  MainForm.miAsciiEditor.Enabled:= True;
  Action:= caFree;
end;

procedure TAsciiEditorForm.FormCreate(Sender: TObject);
begin
  //BitmapToAscii('E:\Documents and Settings\Administrator\Desktop\vodka_costume.bmp');
  InfoGrid.DoubleBuffered:= True;

  udBrushWidth.Associate:= edtBrushWidth;
  udBrushHeight.Associate:= edtBrushHeight;

  cbFontList.Items.Assign(Screen.Fonts);
  cbFontList.Text := 'Fonts...';

  ExePath:= ExtractFilePath(ParamStr(0));

  InitInfoDocument(@InfoDocument, InfoGrid.Canvas);
  LoadPaletteFromFile(ExePath + DEFAULT_PALETTE_PATH, @InfoDocument);
  //LoadInfoFromFile('nfo.nfo', @InfoDocument);

  FillAciiGrid();
  //FillInfoGrid(@InfoDocument);
end;

procedure TAsciiEditorForm.ibNoneClick(Sender: TObject);
begin
  InfoDocument.Tool:= itNone;
end;

procedure TAsciiEditorForm.InfoGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  GridCell: PGridCellInfo;
begin
  if not InfoDocument.IsLoaded then
    Exit;

  (*
  if InfoDocument.StartDraw then
  begin
    if (InfoDocument.Tool = itRectangle) then //or (InfoDocument.Tool = itFrame) then
    begin
      if (ARow >= InfoDocument.Rectangle.Top) and (ARow <= InfoDocument.Rectangle.Bottom) then
      begin
        if (ACol >= InfoDocument.Rectangle.Left) and (ACol <= InfoDocument.Rectangle.Right) then
        Exit; // Prevent redrawing recrangle area, it should stop flickering
      end;
    end;
  end;
  *)
  GridCell:= @InfoDocument.Cells[ACol, ARow];
  GridCell^.Rect:= Rect;

  //DrawGridCell(@InfoDocument, GridCell);

  InfoDocument.Canvas.Brush.Color:= GridCell^.BackColor;
  InfoDocument.Canvas.FillRect(Rect);

  InfoDocument.Canvas.Font.Color:= GridCell^.ForeColor;
  InfoDocument.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, GridCell^.Value);
end;

procedure TAsciiEditorForm.InfoGridKeyPress(Sender: TObject; var Key: Char);
var
  GridCell: PGridCellInfo;
begin

  if not InfoDocument.IsLoaded then
    Exit;

  if (Key < #32) or (Key > #128) then
    Exit;

  InfoDocument.AutoCellMove:= True;
  GridCell:= @InfoDocument.Cells[InfoDocument.ColIndex, InfoDocument.RowIndex];

  GridCell^.Value:= Char(Key);
  GridCell^.BackColor:= InfoDocument.BackColor;
  GridCell^.ForeColor:= InfoDocument.ForeColor;

  if InfoDocument.AutoCellMove then
  begin
    if (InfoGrid.Col + 1 = InfoGrid.ColCount) then
    begin
      if InfoGrid.Row + 1 < InfoGrid.RowCount then
      begin
        InfoGrid.Col:= 0;
        InfoGrid.Row:= InfoGrid.Row + 1;
      end;
    end
      else
    begin
      InfoGrid.Col:= InfoGrid.Col + 1;
    end;
  end;
end;

procedure TAsciiEditorForm.InfoGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin

  if not InfoDocument.IsLoaded then
    Exit;

  case InfoDocument.Tool of
    itPen, itBrush:
    begin
      if (Button = mbLeft) then
        InfoDocument.StartDraw:= True
      else InfoDocument.StartDraw:= False;
    end;
    itRectangle, itFrame:
    begin
      if (Button = mbLeft) then
      begin
        InfoDocument.StartDraw:= True;

        InfoGrid.MouseToCell(X, Y, ACol, ARow);
        InfoDocument.Rectangle.Top:= ARow;
        InfoDocument.Rectangle.Left:= ACol;
        InfoDocument.Rectangle.Bottom:= ARow;
        InfoDocument.Rectangle.Right:= ACol;
      end else InfoDocument.StartDraw:= False;
    end;
  end;
end;

function DrawRectangle(const Document: PInfoDocument; const OnlyDraw: Boolean):Boolean;
var
  GridCell: PGridCellInfo;

  RowIndex, ColIndex, RowCount, ColCount: Integer;
  Rectangle: PRectangleInfo;

begin
  Rectangle:= @Document^.Rectangle;

  //ColCount:= Rectangle^.Right - Rectangle^.Left;
  //RowCount:= Rectangle^.Bottom - Rectangle^.Top;

  Document^.Canvas.Brush.Color:= Document^.BackColor;
  Document^.Canvas.Font.Color:= Document^.ForeColor;

  for RowIndex := Rectangle^.Top to Rectangle^.Bottom do
  begin
    for ColIndex := Rectangle^.Left to Rectangle^.Right do
    begin
      GridCell:= @Document^.Cells[ColIndex, RowIndex];

      if OnlyDraw then
      begin
        Document^.Canvas.FillRect(GridCell^.Rect);
        Document^.Canvas.TextOut(GridCell^.Rect.Left + 2, GridCell^.Rect.Top + 2, Document^.AsciiChar);
      end
        else
      begin
        GridCell^.Value:= Document^.AsciiChar;
        GridCell^.BackColor:= Document^.BackColor;
        GridCell^.ForeColor:= Document^.ForeColor;
      end;
    end;
  end;
end;

function DrawFrame(const Document: PInfoDocument; const OnlyDraw: Boolean):Boolean;
var
  GridCell: PGridCellInfo;

  RowIndex, ColIndex, RowCount, ColCount: Integer;
  Rectangle: PRectangleInfo;

  IsFrameArea: Boolean;
begin
  Rectangle:= @Document^.Rectangle;

  for RowIndex := Rectangle^.Top to Rectangle^.Bottom  do
  begin
    for ColIndex := Rectangle^.Left to Rectangle^.Right  do
    begin
      GridCell:= @Document^.Cells[ColIndex, RowIndex];

      IsFrameArea:= not (
        (RowIndex > Rectangle^.Top) and 
        (ColIndex > Rectangle^.Left) and
        (RowIndex < Rectangle^.Bottom) and 
        (ColIndex < Rectangle^.Right));
      
      if IsFrameArea then
      begin
        if OnlyDraw then
        begin
          Document^.Canvas.Brush.Color:= Document^.BackColor;
          Document^.Canvas.Font.Color:= Document^.ForeColor;
          Document^.Canvas.FillRect(GridCell^.Rect);
          Document^.Canvas.TextOut(GridCell^.Rect.Left + 2, GridCell^.Rect.Top + 2, Document^.AsciiChar);
        end
          else
        begin
          GridCell^.Value:= Document^.AsciiChar;
          GridCell^.BackColor:= Document^.BackColor;
          GridCell^.ForeColor:= Document^.ForeColor;
        end;
      end
        else
      begin
        Document^.Canvas.Brush.Color:= GridCell^.BackColor;
        Document^.Canvas.Font.Color:= GridCell^.ForeColor;
        Document^.Canvas.FillRect(GridCell^.Rect);
        Document^.Canvas.TextOut(GridCell^.Rect.Left + 2, GridCell^.Rect.Top + 2, GridCell^.Value);
      end;
    end;
  end;
end;

function DrawBrush(const Document: PInfoDocument):Boolean;
var
  GridCell: PGridCellInfo;

  RowIndex, ColIndex: Integer;
begin

  for RowIndex := Document^.RowIndex to (Document^.RowIndex + Document^.BrushHeight) - 1 do
  begin
    for ColIndex := Document^.ColIndex to (Document^.ColIndex + Document^.BrushWidth) - 1 do
    begin
      if ColIndex >= Document^.ColCount then
        Continue;

      if RowIndex >= Document^.RowCount then
        Continue;

      GridCell:= @Document^.Cells[ColIndex, RowIndex];
      GridCell^.Value:= Document^.AsciiChar;
      GridCell^.BackColor:= Document^.BackColor;
      GridCell^.ForeColor:= Document^.ForeColor;

      Document^.Canvas.Brush.Color:= GridCell^.BackColor;
      Document^.Canvas.Font.Color:= GridCell^.ForeColor;
      Document^.Canvas.FillRect(GridCell^.Rect);
      Document^.Canvas.TextOut(GridCell^.Rect.Left + 2, GridCell^.Rect.Top + 2, GridCell^.Value);
    end;
  end;
end;

procedure TAsciiEditorForm.InfoGridMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  ACol, ARow: Integer;
  GridCell: PGridCellInfo;
  Tick: DWORD;

begin

  if not InfoDocument.IsLoaded then
    Exit;

  if not (ssLeft in Shift) then
    Exit;

  case InfoDocument.Tool of
    itPen:
    begin
      if not InfoDocument.StartDraw then
        Exit;

      InfoGrid.MouseToCell(X, Y, ACol, ARow);
      if (ACol < 0) or (ARow < 0) then
        Exit;

      InfoGrid.Col:= ACol;
      InfoGrid.Row:= ARow;

      InfoDocument.ColIndex:= ACol;
      InfoDocument.RowIndex:= ARow;

      GridCell:= @InfoDocument.Cells[ACol, ARow];
      GridCell^.Value:= InfoDocument.AsciiChar;
      GridCell^.BackColor:= InfoDocument.BackColor;
      GridCell^.ForeColor:= InfoDocument.ForeColor;
    end;
    itBrush:
    begin
      if not InfoDocument.StartDraw then
        Exit;

      InfoGrid.MouseToCell(X, Y, ACol, ARow);
      if (ACol < 0) or (ARow < 0) then
        Exit;

      InfoGrid.Col:= ACol;
      InfoGrid.Row:= ARow;

      InfoDocument.ColIndex:= ACol;
      InfoDocument.RowIndex:= ARow;

      DrawBrush(@InfoDocument);
    end;
    itRectangle, itFrame:
    begin
      if (not InfoDocument.StartDraw) then
        Exit;
      (*
      Tick:= GetTickCount();

      if (Tick - InfoDocument.DrawTick) > 100 then
      begin
        InfoDocument.DrawTick:= Tick;
      end else Exit;
      *)
      InfoGrid.MouseToCell(X, Y, ACol, ARow);
      if (ACol < 0) or (ARow < 0) then
        Exit;
    
      //InfoGrid.Col:= ACol;
      //InfoGrid.Row:= ARow;

      //InfoDocument.ColIndex:= ACol;
      //InfoDocument.RowIndex:= ARow;

      //if (InfoDocument.Rectangle.Right <> ACol) or (InfoDocument.Rectangle.Bottom <> ARow)  then
      begin
        //InfoGrid.Repaint;

        InfoDocument.Rectangle.Right:= ACol;
        InfoDocument.Rectangle.Bottom:= ARow;

        if InfoDocument.Tool = itRectangle then
          DrawRectangle(@InfoDocument, True)
        else DrawFrame(@InfoDocument, True);
        //InfoGrid.Repaint;
      end;

      //GridCell:= @InfoDocument.Cells[ACol, ARow];
      //GridCell^.Value:= InfoDocument.AsciiChar;
      //GridCell^.BackColor:= shBackColor.Brush.Color;
      //GridCell^.ForeColor:= shForeColor.Brush.Color;
    end;
  end;
end;

procedure TAsciiEditorForm.InfoGridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  if not InfoDocument.IsLoaded then
    Exit;

  case InfoDocument.Tool of
    itRectangle:
    begin
      if InfoDocument.StartDraw then
      begin
        DrawRectangle(@InfoDocument, False);
        InfoGrid.Repaint;
      end;
    end;
    itFrame:
    begin
      if InfoDocument.StartDraw then
      begin
        DrawFrame(@InfoDocument, False);
        InfoGrid.Repaint;
      end;
    end;
  end;

  InfoDocument.StartDraw:= False;
end;

procedure TAsciiEditorForm.InfoGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin

  if not InfoDocument.IsLoaded then
    Exit;

  InfoDocument.ColIndex:= ACol;
  InfoDocument.RowIndex:= ARow;
  CanSelect:= True;
end;

procedure TAsciiEditorForm.InfoGridTopLeftChanged(Sender: TObject);
begin

  // Do not remove, when user change pos of topleft item (use scrollbars for example),
  // then we must get new TRect for CellInfo, so we force to repaint
  // it and OnDrawCell will update out TRect in CellInfo
  InfoGrid.Repaint;
end;

procedure TAsciiEditorForm.shBackColorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

  if ColorDialog.Execute then
  begin
    InfoDocument.BackColor:= ColorDialog.Color;
    shBackColor.Brush.Color:= ColorDialog.Color;
  end;
end;

procedure TAsciiEditorForm.shForeColorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

  if ColorDialog.Execute then
  begin
    InfoDocument.ForeColor:= ColorDialog.Color;
    shForeColor.Brush.Color:= ColorDialog.Color;
  end;
end;

procedure TAsciiEditorForm.udBrushHeightChanging(Sender: TObject;
  var AllowChange: Boolean);
begin

  InfoDocument.BrushHeight:= udBrushHeight.Position + 1;
end;

procedure TAsciiEditorForm.udBrushWidthChanging(Sender: TObject;
  var AllowChange: Boolean);
begin

  InfoDocument.BrushWidth:= udBrushWidth.Position + 1;
end;

end.
