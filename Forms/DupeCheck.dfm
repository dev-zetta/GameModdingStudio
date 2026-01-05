object DupeCheckForm: TDupeCheckForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Dupe Checker'
  ClientHeight = 310
  ClientWidth = 324
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  ScreenSnap = True
  SnapBuffer = 50
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GBoxFolder: TGroupBox
    Left = 5
    Top = 0
    Width = 190
    Height = 145
    TabOrder = 0
    object Label1: TLabel
      Left = 5
      Top = 10
      Width = 70
      Height = 13
      Caption = 'Source Folder:'
    end
    object Label5: TLabel
      Left = 5
      Top = 45
      Width = 69
      Height = 13
      Caption = 'Target Folder:'
    end
    object Label3: TLabel
      Left = 5
      Top = 80
      Width = 51
      Height = 13
      Caption = 'Extension:'
    end
    object Label2: TLabel
      Left = 5
      Top = 95
      Width = 32
      Height = 13
      Caption = 'Prefix:'
    end
    object Label4: TLabel
      Left = 5
      Top = 110
      Width = 61
      Height = 13
      Caption = 'Batch Name:'
    end
    object Label6: TLabel
      Left = 5
      Top = 125
      Width = 66
      Height = 13
      Caption = 'FileList Name:'
    end
    object EdtSourceFolder: TEdit
      Left = 5
      Top = 25
      Width = 120
      Height = 17
      TabStop = False
      AutoSelect = False
      AutoSize = False
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      MaxLength = 255
      ReadOnly = True
      TabOrder = 0
    end
    object BtnSourceFolder: TButton
      Left = 130
      Top = 25
      Width = 55
      Height = 17
      Caption = 'Browse'
      TabOrder = 1
      TabStop = False
      OnClick = BtnSourceFolderClick
    end
    object EdtTargetFolder: TEdit
      Left = 5
      Top = 60
      Width = 120
      Height = 17
      TabStop = False
      AutoSelect = False
      AutoSize = False
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      MaxLength = 255
      ReadOnly = True
      TabOrder = 2
    end
    object BtnTargetFolder: TButton
      Left = 130
      Top = 60
      Width = 55
      Height = 17
      Caption = 'Browse'
      TabOrder = 3
      TabStop = False
      OnClick = BtnTargetFolderClick
    end
    object EdtSourceExt: TEdit
      Left = 70
      Top = 80
      Width = 50
      Height = 15
      TabStop = False
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      TabOrder = 4
    end
    object EdtPrefix: TEdit
      Left = 70
      Top = 95
      Width = 50
      Height = 15
      TabStop = False
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Enabled = False
      TabOrder = 5
    end
    object EdtBatch: TEdit
      Left = 70
      Top = 110
      Width = 50
      Height = 15
      TabStop = False
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      TabOrder = 6
    end
    object EdtList: TEdit
      Left = 70
      Top = 125
      Width = 50
      Height = 15
      TabStop = False
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      TabOrder = 7
    end
  end
  object PnlLogger: TPanel
    Left = 5
    Top = 185
    Width = 315
    Height = 120
    FullRepaint = False
    ParentBackground = False
    TabOrder = 1
    object Gauge1: TGauge
      Left = 70
      Top = 7
      Width = 175
      Height = 12
      BackColor = clSilver
      Color = clSilver
      ForeColor = clOlive
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Progress = 0
      ShowText = False
    end
    object BtnSave: TButton
      Left = 5
      Top = 5
      Width = 50
      Height = 17
      Caption = 'Save'
      TabOrder = 0
      TabStop = False
    end
    object BtnClear: TButton
      Left = 260
      Top = 5
      Width = 50
      Height = 17
      Caption = 'Clear'
      TabOrder = 1
      TabStop = False
    end
    object RichEdit1: TRichEdit
      Left = 5
      Top = 25
      Width = 305
      Height = 90
      TabStop = False
      BevelOuter = bvRaised
      BevelKind = bkFlat
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 2
    end
  end
  object GBoxTodo: TGroupBox
    Left = 200
    Top = 0
    Width = 120
    Height = 65
    Caption = 'Action:'
    TabOrder = 2
    object RBtnNone: TRadioButton
      Left = 5
      Top = 15
      Width = 50
      Height = 17
      Caption = 'None'
      TabOrder = 0
    end
    object RBtnCopy: TRadioButton
      Left = 5
      Top = 30
      Width = 50
      Height = 17
      Caption = 'Copy'
      TabOrder = 1
    end
    object RBtnDelete: TRadioButton
      Left = 60
      Top = 15
      Width = 50
      Height = 17
      Caption = 'Delete'
      TabOrder = 2
    end
    object RBtnErase: TRadioButton
      Left = 60
      Top = 30
      Width = 50
      Height = 17
      Caption = 'Erase'
      TabOrder = 3
    end
    object RBtnMove: TRadioButton
      Left = 5
      Top = 45
      Width = 50
      Height = 17
      Caption = 'Move'
      TabOrder = 4
    end
    object RBtnReport: TRadioButton
      Left = 60
      Top = 45
      Width = 50
      Height = 17
      Caption = 'Report'
      TabOrder = 5
    end
  end
  object GBoxComp: TGroupBox
    Left = 200
    Top = 65
    Width = 120
    Height = 65
    Caption = 'Compare:'
    TabOrder = 3
    object ChBoxName: TCheckBox
      Left = 5
      Top = 15
      Width = 50
      Height = 17
      TabStop = False
      Caption = 'Name'
      TabOrder = 0
    end
    object ChBoxData: TCheckBox
      Left = 60
      Top = 30
      Width = 50
      Height = 17
      TabStop = False
      Caption = 'Data'
      TabOrder = 1
    end
    object ChBoxSize: TCheckBox
      Left = 5
      Top = 30
      Width = 50
      Height = 17
      TabStop = False
      Caption = 'Size'
      TabOrder = 2
    end
    object ChBoxPath: TCheckBox
      Left = 60
      Top = 15
      Width = 50
      Height = 17
      TabStop = False
      Caption = 'Path'
      TabOrder = 3
    end
    object ChBoxExt: TCheckBox
      Left = 5
      Top = 45
      Width = 65
      Height = 17
      TabStop = False
      Caption = 'Extension'
      TabOrder = 4
    end
  end
  object GBoxFeat: TGroupBox
    Left = 200
    Top = 130
    Width = 120
    Height = 50
    Caption = 'Features:'
    TabOrder = 4
    object ChBoxBatch: TCheckBox
      Left = 5
      Top = 15
      Width = 97
      Height = 17
      TabStop = False
      Caption = 'Generate batch'
      TabOrder = 0
    end
    object ChBoxList: TCheckBox
      Left = 5
      Top = 30
      Width = 97
      Height = 17
      TabStop = False
      Caption = 'Generate file list'
      TabOrder = 1
    end
  end
  object PnlSearch: TPanel
    Left = 5
    Top = 150
    Width = 190
    Height = 30
    BevelInner = bvRaised
    BevelKind = bkTile
    TabOrder = 5
    object BtnSearch: TButton
      Left = 5
      Top = 5
      Width = 55
      Height = 17
      Caption = 'Search'
      TabOrder = 0
      TabStop = False
      OnClick = BtnSearchClick
    end
    object BtnCancel: TButton
      Left = 125
      Top = 5
      Width = 55
      Height = 17
      Caption = 'Cancel'
      Enabled = False
      TabOrder = 1
      TabStop = False
    end
    object BtnPause: TButton
      Left = 65
      Top = 5
      Width = 55
      Height = 17
      Caption = 'Pause'
      Enabled = False
      TabOrder = 2
      TabStop = False
    end
  end
end
