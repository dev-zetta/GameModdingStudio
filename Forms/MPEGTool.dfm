object MPEGToolForm: TMPEGToolForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MPEGTool'
  ClientHeight = 303
  ClientWidth = 374
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GBoxFolder: TGroupBox
    Left = 5
    Top = 0
    Width = 190
    Height = 160
    TabOrder = 0
    object Label1: TLabel
      Left = 5
      Top = 10
      Width = 56
      Height = 13
      Caption = 'Source File:'
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
      Top = 85
      Width = 85
      Height = 13
      Caption = 'Min Frame Count:'
    end
    object lblMinFrameCount: TLabel
      Left = 95
      Top = 85
      Width = 6
      Height = 13
      AutoSize = False
      Caption = '2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 5
      Top = 105
      Width = 80
      Height = 13
      Caption = 'Secret Message:'
    end
    object Label10: TLabel
      Left = 5
      Top = 140
      Width = 116
      Height = 13
      Caption = 'Secret Message Length:'
    end
    object lblSecretMessageLength: TLabel
      Left = 125
      Top = 140
      Width = 6
      Height = 13
      Caption = '0'
    end
    object edtSourceFile: TEdit
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
    object btnSourceFile: TButton
      Left = 130
      Top = 25
      Width = 55
      Height = 17
      Caption = 'Browse'
      TabOrder = 1
      TabStop = False
      OnClick = btnSourceFileClick
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
    object udMinFrameCount: TUpDown
      Left = 105
      Top = 85
      Width = 30
      Height = 13
      ArrowKeys = False
      Min = 1
      Max = 9
      Orientation = udHorizontal
      Position = 2
      TabOrder = 4
      OnClick = udMinFrameCountClick
    end
    object edtSecretMessage: TEdit
      Left = 5
      Top = 120
      Width = 180
      Height = 17
      TabStop = False
      AutoSelect = False
      AutoSize = False
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      MaxLength = 255
      TabOrder = 5
    end
  end
  object PnlLogger: TPanel
    Left = 5
    Top = 195
    Width = 365
    Height = 105
    FullRepaint = False
    ParentBackground = False
    TabOrder = 1
    object Gauge1: TGauge
      Left = 60
      Top = 7
      Width = 243
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
      Left = 310
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
      Width = 355
      Height = 75
      TabStop = False
      BevelOuter = bvRaised
      BevelKind = bkFlat
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 2
    end
  end
  object PnlSearch: TPanel
    Left = 5
    Top = 160
    Width = 190
    Height = 30
    BevelInner = bvRaised
    BevelKind = bkTile
    TabOrder = 2
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
  object gbActionBox: TGroupBox
    Left = 200
    Top = 0
    Width = 169
    Height = 190
    Caption = 'Action panel'
    TabOrder = 3
    object Label2: TLabel
      Left = 5
      Top = 15
      Width = 72
      Height = 13
      Caption = 'Frames Found:'
    end
    object Label4: TLabel
      Left = 5
      Top = 30
      Width = 76
      Height = 13
      Caption = 'Clusters Found:'
    end
    object Label6: TLabel
      Left = 5
      Top = 45
      Width = 79
      Height = 13
      Caption = 'Min Cluster Size:'
    end
    object Label7: TLabel
      Left = 5
      Top = 60
      Width = 83
      Height = 13
      Caption = 'Max Cluster Size:'
    end
    object lblFramesFound: TLabel
      Left = 100
      Top = 15
      Width = 6
      Height = 13
      Caption = '0'
    end
    object lblClustersFound: TLabel
      Left = 100
      Top = 30
      Width = 6
      Height = 13
      Caption = '0'
    end
    object lblMinClusterSize: TLabel
      Left = 100
      Top = 45
      Width = 6
      Height = 13
      Caption = '0'
    end
    object lblMaxClusterSize: TLabel
      Left = 100
      Top = 60
      Width = 6
      Height = 13
      Caption = '0'
    end
    object rbExtractToFolder: TRadioButton
      Left = 5
      Top = 110
      Width = 142
      Height = 17
      Caption = 'Extract clusters to folder'
      TabOrder = 0
    end
    object rbExtractToFile: TRadioButton
      Left = 5
      Top = 95
      Width = 150
      Height = 17
      Caption = 'Extract clusters to file'
      TabOrder = 1
    end
    object btnPerform: TButton
      Left = 55
      Top = 165
      Width = 60
      Height = 17
      Caption = 'Perform'
      TabOrder = 2
      TabStop = False
      OnClick = btnPerformClick
    end
    object rbReadSecretMessage: TRadioButton
      Left = 5
      Top = 125
      Width = 142
      Height = 17
      Caption = 'Read secret message'
      TabOrder = 3
    end
    object rbSaveSecretMessage: TRadioButton
      Left = 5
      Top = 140
      Width = 142
      Height = 17
      Caption = 'Save secret message'
      TabOrder = 4
    end
    object rbDumpToFile: TRadioButton
      Left = 5
      Top = 80
      Width = 150
      Height = 17
      Caption = 'Dump mpeg info to file'
      Checked = True
      TabOrder = 5
      TabStop = True
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'All|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent]
    Left = 336
    Top = 232
  end
end
