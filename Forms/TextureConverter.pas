unit TextureConverter;

interface

uses
  Windows, Messages, SysUtils, Variants,
  Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, CheckLst,
  ExtCtrls, Gauges,

  SharedHeaders, SharedTypes, SharedFunc,
  Imaging, ImagingTypes, TexConverter;

type
  TTextureConverterForm = class(TForm)
    GBoxFolder: TGroupBox;
    Label1: TLabel;
    BtnTexRecDataPath: TButton;
    EdtSourceFolder: TEdit;
    BtnSearch: TButton;
    EdtTexRecDataPath: TEdit;
    BtnSourceFolder: TButton;
    LBoxSourceExt: TListBox;
    LBoxTargetExt: TListBox;
    Label3: TLabel;
    Label4: TLabel;
    EdtTargetFolder: TEdit;
    BtnTargetFolder: TButton;
    Label5: TLabel;
    GBoxFormat: TGroupBox;
    UDJPGCompLvl: TUpDown;
    EdtJPGCompLvl: TEdit;
    GBoxSetting: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    EdtPNGCompLvl: TEdit;
    Label8: TLabel;
    UDPNGCompLvl: TUpDown;
    ChBoxDelOrgTex: TCheckBox;
    ChBoxAScanEnabled: TCheckBox;
    PnlAScanEnabled: TPanel;
    PnlLogger: TPanel;
    BtnSave: TButton;
    BtnClear: TButton;
    EdtMinTexSize: TEdit;
    Label10: TLabel;
    UDMinTexSize: TUpDown;
    Label11: TLabel;
    SaveDialog1: TSaveDialog;
    SaveDialog2: TSaveDialog;
    ChBoxDelMipMaps: TCheckBox;
    ChBoxEnableRLEComp: TCheckBox;
    GBoxTarget: TGroupBox;
    ChBoxDelCubeMap: TCheckBox;
    ChBoxDelVolTex: TCheckBox;
    BtnAddFilter: TButton;
    LBoxTexFilters: TListBox;
    BtnDeleteFilter: TButton;
    BtnCancel: TButton;
    BtnPause: TButton;
    RichEdit1: TRichEdit;
    ChBoxSaveTexRecData: TCheckBox;
    EdtAAlphaListPath: TEdit;
    BtnAAlphaListPath: TButton;
    Gauge1: TGauge;
    PnlSaveTexRecData: TPanel;
    PnlSearch: TPanel;
    GBoxSource: TGroupBox;
    RBtnACopyToExtra: TRadioButton;
    RBtnAMoveToExtra: TRadioButton;
    RBtnAReportOnly: TRadioButton;
    Label2: TLabel;
    RBtnASplitAlpha: TRadioButton;
    Label9: TLabel;
    ChBoxASaveAlphaList: TCheckBox;
    PnlASaveAlphaList: TPanel;
    PnlExtra: TPanel;
    EdtAExtraFolder: TEdit;
    BtnAExtraFolder: TButton;
    Label12: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListBox_DrawItem(Control: TWinControl;Index: Integer;Rect: TRect;State: TOwnerDrawState) ;
    procedure BtnClearClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnSourceFolderClick(Sender: TObject);
    procedure BtnTargetFolderClick(Sender: TObject);
    procedure BtnTexRecDataPathClick(Sender: TObject);
    procedure ChBoxAScanEnabledClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnAExtraFolderClick(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
    procedure BtnAddFilterClick(Sender: TObject);
    procedure BtnDeleteFilterClick(Sender: TObject);
    procedure BtnPauseClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure ChBoxSaveTexRecDataClick(Sender: TObject);
    procedure BtnAAlphaListPathClick(Sender: TObject);
    procedure ChBoxASaveAlphaListClick(Sender: TObject);
    procedure ChBoxDelVolTexClick(Sender: TObject);

  private
    { Private declarations }
    function SaveSetting:boolean;
    function LoadSetting:boolean;
    function UpdateSetting(const SaveLoad:TSaveLoad):boolean;

    procedure AddTexFilter;
    procedure DelTexFilter;
    //procedure LogMsgRed (const Msg:ShortString);
    //procedure LogMsgBlue (const Msg:ShortString);
  public
    { Public declarations }
  end;

var
  TextureConverterForm: TTextureConverterForm;

implementation

uses
  Main;

{$R *.dfm}

var
  TexConverter:TTexConverter;
  TexConverterSetting:TTexToolSetting;
  ProcessCanceled:Boolean=false;
  ProcessPaused:Boolean=false;

///////////////////////////////////////
procedure LogMsgRed (const Msg:ShortString);
begin
  with TextureConverterForm.RichEdit1 do
  begin
    SelAttributes.Color:=clRED;
    Lines.Add(Msg);
    SelStart:=Length(Lines.Text);
  end;
end;
///////////////////////////////////////
procedure LogMsgBlue (const Msg:ShortString);
begin
  with TextureConverterForm.RichEdit1 do
  begin
    SelAttributes.Color:=clBLUE;
    Lines.Add(Msg);
    SelStart:=Length(Lines.Text);
  end;
end;
///////////////////////////////////////
function TTextureConverterForm.SaveSetting:boolean;
begin
  Result:=WriteBuffer(EXEPATH+TEXCONV_CONFIG,TexConverterSetting,SizeOf(TTexToolSetting));
end;
///////////////////////////////////////
function TTextureConverterForm.LoadSetting:boolean;
begin
    Result:=ReadBuffer(EXEPATH+TEXCONV_CONFIG,TexConverterSetting,SizeOf(TTexToolSetting));
end;
///////////////////////////////////////
function TTextureConverterForm.UpdateSetting(const SaveLoad:TSaveLoad):boolean;
begin
  Result:=True;
  try
    if SaveLoad=slLOAD then
      with TexConverterSetting do
      begin
        EdtSourceFolder.Text:=SourceFolder;
        EdtTargetFolder.Text:=TargetFolder;

        ChBoxSaveTexRecData.Checked:=SaveTexRecData;
        EdtTexRecDataPath.Text:=TexRecDataPath;

        //EdtJPGCompLvl.Text:=IntToStr(JPGCompLvl);
        //EdtPNGCompLvl.Text:=IntToStr(PNGCompLvl);
        //EdtMinTexSize.Text:=IntToStr(MinTexSize);

        UDJPGCompLvl.Position:=JPGComLevel;
        UDPNGCompLvl.Position:=PNGComLevel;
        UDMinTexSize.Position:=MinSourceFileSize;

        ChBoxDelOrgTex.Checked:=DelSourceFiles;
        ChBoxEnableRLEComp.Checked:=EnableRLEComp;

        ChBoxDelMipMaps.Checked:=DelMipMaps;
        ChBoxDelVolTex.Checked:=DelVolTex;
        ChBoxDelCubeMap.Checked:=DelCubeMap;

        EdtAExtraFolder.Text:=AlphaSetting.ExtraFolder;

        ChBoxAScanEnabled.Checked:=AlphaSetting.IsEnabled;
        //RBtnAReportOnly.Checked:=AlphaSetting.ReportOnly;
        //RBtnACopyToExtra.Checked:=AlphaSetting.CopyToExtra;
        //RBtnAMoveToExtra.Checked:=AlphaSetting.MoveToExtra;
        //RBtnASplitAlpha.Checked:=AlphaSetting.SplitAlpha;
        case AlphaSetting.ActionMode of
          ModeAlphaReport: RBtnAReportOnly.Checked:=True;
          ModeAlphaCopy: RBtnACopyToExtra.Checked:=True;
          ModeAlphaMove: RBtnAMoveToExtra.Checked:=True;
          ModeAlphaSplit: RBtnASplitAlpha.Checked:=True;
        end;

        ChBoxASaveAlphaList.Checked:=AlphaSetting.SaveFileList;
        EdtAAlphaListPath.Text:=AlphaSetting.FileListPath;

        EnableControl(PnlSaveTexRecData,SaveTexRecData);
        EnableControl(PnlAScanEnabled,AlphaSetting.IsEnabled);
        if AlphaSetting.IsEnabled then
        EnableControl(PnlASaveAlphaList,AlphaSetting.SaveFileList);
      end
    else
    if SaveLoad=slSAVE then
      with TexConverterSetting do
      begin
        SourceFolder:=EdtSourceFolder.Text;
        TargetFolder:=EdtTargetFolder.Text;

        SaveTexRecData:=ChBoxSaveTexRecData.Checked;
        TexRecDataPath:=EdtTexRecDataPath.Text;

        //JPGCompLvl:=StrToInt(EdtJPGCompLvl.Text);
        //PNGCompLvl:=StrToInt(EdtPNGCompLvl.Text);
        //MinTexSize:=StrToInt(EdtMinTexSize.Text);
        JPGComLevel:=UDJPGCompLvl.Position;
        PNGComLevel:=UDPNGCompLvl.Position;
        MinSourceFileSize:=UDMinTexSize.Position;

        DelSourceFiles:=ChBoxDelOrgTex.Checked;
        EnableRLEComp:=ChBoxEnableRLEComp.Checked;

        DelMipMaps:=ChBoxDelMipMaps.Checked;
        DelCubeMap:=ChBoxDelCubeMap.Checked;
        DelVolTex:=ChBoxDelVolTex.Checked;

        with AlphaSetting do
        begin
          Enabled:=ChBoxAScanEnabled.Checked;
          ExtraFolder:=EdtAExtraFolder.Text;

          if RBtnAReportOnly.Checked then
          ActionMode:=ModeAlphaReport;

          if RBtnACopyToExtra.Checked then
          ActionMode:=ModeAlphaCopy;

          if RBtnAMoveToExtra.Checked then
          ActionMode:=ModeAlphaMove;

          if RBtnASplitAlpha.Checked then
          ActionMode:=ModeAlphaSplit;

          SaveFileList:=ChBoxASaveAlphaList.Checked;
          FileListPath:=EdtAAlphaListPath.Text;
        end;

        with TexConverter,TexConverterSetting do
        begin
          SetMinTexSize(MinSourceFileSize);
          SetMsgSenderRed(LogMsgRed);
          SetMsgSenderBlue(LogMsgBlue);
          SetSourceFolder(SourceFolder);
          SetTargetFolder(TargetFolder);
          SetExtraFolder(AlphaSetting.ExtraFolder);
          SetAlphaListPath(AlphaSetting.FileListPath);
          SetTexRecDataPath(TexRecDataPath);
          SetJPGCompLvl(JPGComLevel);
          SetPNGCompLvl(PNGComLevel);

          //EnableTexOption(xSaveTexList,SaveFileList);
          TexConverter.ResetTexOptions;

          EnableTexOption(xSaveAlphaList,AlphaSetting.SaveFileList);
          EnableTexOption(xSaveTexRecData,SaveTexRecData);
          EnableTexOption(xAlphaScan,AlphaSetting.IsEnabled);

          //EnableTexOption(xAlphaSplit,AlphaSetting.SplitAlpha);
          //EnableTexOption(xAlphaMove,AlphaSetting.MoveToExtra);
          //EnableTexOption(xAlphaCopy,AlphaSetting.CopyToExtra);
          case AlphaSetting.ActionMode of
            ModeAlphaReport: ;//AddTexOption(xAlphaSplit);
            ModeAlphaCopy: AddTexOption(xAlphaCopy);
            ModeAlphaMove: AddTexOption(xAlphaMove);
            ModeAlphaSplit: AddTexOption(xAlphaSplit);
          end;

          EnableTexOption(xDelSourceFile, DelSourceFiles);
          EnableTexOption(xDelCubeMap, DelCubeMap);
          EnableTexOption(xDelVolTexture, DelVolTex);
          EnableTexOption(xDelMipMaps, DelMipMaps);
          EnableTexOption(xEnableRLE, EnableRLEComp);
        end;
      end
  except
    Result:=False;
  end;
end;
///////////////////////////////////////
procedure TTextureConverterForm.AddTexFilter;
var
  i,j:LongWord;
begin
  for i := 0 to LBoxSourceExt.Count - 1 do
  begin
    if LBoxSourceExt.Selected[i] then
    begin
      for j := 0 to LBoxTargetExt.Count - 1 do
      begin
        if LBoxTargetExt.Selected[j] then
        begin
          if TexConverter.IsTexFilterSet(LBoxSourceExt.Items[i],LBoxTargetExt.Items[j]) then
          Exit;

          TexConverter.AddTexFilter(LBoxSourceExt.Items[i],LBoxTargetExt.Items[j]);
          LBoxTexFilters.Items.Add(LBoxSourceExt.Items[i] + ' to ' + LBoxTargetExt.Items[j]);
          Exit;
        end; //if
      end; // for j
    end; //if
  end; //for i
end;
///////////////////////////////////////
procedure TTextureConverterForm.DelTexFilter;
var
  i:LongWord;
begin
  if LBoxTexFilters.Count=0 then
  Exit;

  for i := LBoxTexFilters.Count - 1 downto 0 do
  begin
    if LBoxTexFilters.Selected[i] then
    begin
      LBoxTexFilters.Items.Delete(i);
      TexConverter.DelTexFilter(i);
      Exit;
    end;
  end;
end;
///////////////////////////////////////
procedure TTextureConverterForm.BtnCancelClick(Sender: TObject);
begin
  if ProcessCanceled then
  exit;
  
  ProcessCanceled:=True;
  LogMsgRed ('Process Canceled !');
  BtnCancel.Enabled:=False;
  BtnPause.Enabled:=False;
  BtnSearch.Enabled:=True;
end;
///////////////////////////////////////
procedure TTextureConverterForm.BtnClearClick(Sender: TObject);
begin
  RichEdit1.Clear;
end;
///////////////////////////////////////
procedure TTextureConverterForm.BtnAExtraFolderClick(Sender: TObject);
begin
  EdtAExtraFolder.Text:=BrowseDialog ('Select Directory',TexConverterSetting.AlphaSetting.ExtraFolder);
end;
///////////////////////////////////////
procedure TTextureConverterForm.BtnAAlphaListPathClick(Sender: TObject);
begin
  if SaveDialog2.Execute then
  EdtAAlphaListPath.Text:=SaveDialog2.FileName;
end;
///////////////////////////////////////
procedure TTextureConverterForm.BtnTexRecDataPathClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
  EdtTexRecDataPath.Text:=SaveDialog1.FileName;
end;
///////////////////////////////////////
procedure TTextureConverterForm.BtnPauseClick(Sender: TObject);
begin
  if ProcessCanceled then
  exit;

  if not ProcessPaused then
  begin
    ProcessPaused:=True;
    LogMsgRed ('Process Paused!');
    Exit;
  end;

  if ProcessPaused then
  begin
    ProcessPaused:=False;
    LogMsgRed ('Process UnPaused!');
    Exit;
  end;
  //ProcessPaused:=not ProcessPaused;
end;
///////////////////////////////////////
procedure TTextureConverterForm.BtnSaveClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
  RichEdit1.Lines.SaveToFile(SaveDialog1.FileName);
end;
///////////////////////////////////////
procedure TTextureConverterForm.BtnSearchClick(Sender: TObject);
var
  i:LongWord;
begin
  UpdateSetting (slSAVE);

  Gauge1.Progress:=0;
  EnableSearchPanel (PnlSearch,False);
  ProcessCanceled:=False;
  ProcessPaused:=False;
  with TexConverter do
  begin
    SetMsgSenderBlue(LogMsgBlue);
    SetMsgSenderRed(LogMsgRed);

    Search;
    Gauge1.MaxValue:=TexFound;

    if TexFound>0 then
    begin
      for i := 0 to TexFound - 1 do
      begin
        if ProcessPaused then
        begin
          while ProcessPaused and (not ProcessCanceled) do
          begin
            Sleep(50);
            Application.ProcessMessages;
          end;
        end;

        if ProcessCanceled then
        Break;

        if Convert(i) then
        Gauge1.Progress:=i;

        if (i mod 2)=0 then
        Application.ProcessMessages;
      end;
      //LogMsgRed('Deleted files: ' + IntToStr(DeleteLoaded));
    end;

    SaveAlphaList;
    SaveTexRecData;
    LogMsgBlue('Converting done!');
    LogMsgRed('Converted: ' + IntToStr(TexConverted) + '/' + IntToStr(TexFound));
  end;
  TexConverter.Reset;

  ProcessCanceled:=False;
  ProcessPaused:=False;
  EnableSearchPanel (PnlSearch,True);
end;
///////////////////////////////////////
procedure TTextureConverterForm.BtnSourceFolderClick(Sender: TObject);
begin
  EdtSourceFolder.Text:=BrowseDialog ('Select Folder',TexConverterSetting.SourceFolder);
end;
///////////////////////////////////////
procedure TTextureConverterForm.BtnTargetFolderClick(Sender: TObject);
begin
  EdtTargetFolder.Text:=BrowseDialog ('Select Folder',TexConverterSetting.TargetFolder);
end;
///////////////////////////////////////
procedure TTextureConverterForm.BtnAddFilterClick(Sender: TObject);
begin
  AddTexFilter;
end;
///////////////////////////////////////
procedure TTextureConverterForm.BtnDeleteFilterClick(Sender: TObject);
begin
  DelTexFilter;
end;
///////////////////////////////////////
procedure TTextureConverterForm.ChBoxASaveAlphaListClick(Sender: TObject);
begin
  EnableControl(PnlASaveAlphaList,ChBoxASaveAlphaList.Checked);
end;
///////////////////////////////////////
procedure TTextureConverterForm.ChBoxAScanEnabledClick(Sender: TObject);
begin
  EnableControl(PnlAScanEnabled,ChBoxAScanEnabled.Checked);
  if ChBoxAScanEnabled.Checked then
  EnableControl(PnlASaveAlphaList,ChBoxASaveAlphaList.Checked);
end;

procedure TTextureConverterForm.ChBoxDelVolTexClick(Sender: TObject);
begin

end;

///////////////////////////////////////
procedure TTextureConverterForm.ChBoxSaveTexRecDataClick(Sender: TObject);
begin
  EnableControl(PnlSaveTexRecData,ChBoxSaveTexRecData.Checked);
end;
///////////////////////////////////////
procedure TTextureConverterForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;
///////////////////////////////////////
procedure TTextureConverterForm.FormCreate(Sender: TObject);
begin
  LoadSetting;
  UpdateSetting (slLOAD);

  TexConverter:=TTexConverter.Create;
  RichEdit1.Font.Style:=[fsBold];

  with LBoxSourceExt do
  begin
    Style := lbOwnerDrawFixed;
    ItemHeight := 15;
    OnDrawItem := ListBox_DrawItem;
  end;

  with LBoxTargetExt do
  begin
    Style := lbOwnerDrawFixed;
    ItemHeight := 15;
    OnDrawItem := ListBox_DrawItem;
  end;
end;
///////////////////////////////////////
procedure TTextureConverterForm.FormDestroy(Sender: TObject);
begin
  TexConverter.Destroy;
  MainForm.miTextureConverter.Enabled:=True;
  UpdateSetting (slSAVE);
  SaveSetting;
end;
///////////////////////////////////////
procedure TTextureConverterForm.ListBox_DrawItem(
   Control: TWinControl;
   Index: Integer;
   Rect: TRect;
   State: TOwnerDrawState) ;
const
   IsSelected : array[Boolean] of Integer = (DFCS_BUTTONRADIO, DFCS_BUTTONRADIO or DFCS_CHECKED) ;
var
   optionButtonRect: TRect;
   listBox : TListBox;
begin
   listBox := Control as TListBox;
   with listBox.Canvas do
   begin
     listBox.Canvas.Brush.Color:= clSilver;
     //listBox.Canvas.Rectangle();
     FillRect(rect) ;

     optionButtonRect.Left := rect.Left + 1;
     optionButtonRect.Right := Rect.Left + 13;
     optionButtonRect.Bottom := Rect.Bottom;
     optionButtonRect.Top := Rect.Top;

     DrawFrameControl(Handle, optionButtonRect, DFC_BUTTON, IsSelected[odSelected in State]) ;

     listBox.Canvas.Brush.Style:= bsClear;

     if odSelected in State then
     listBox.Canvas.Font.Color:= clBlue
     else listBox.Canvas.Font.Color:= clBlack;

     TextOut(15, rect.Top, listBox.Items[Index]) ;

     if odSelected in State then
     begin
      listBox.Canvas.Brush.Color:= clRed;
      FrameRect(rect);
     end;
   end;
end;
///////////////////////////////////////
end.
