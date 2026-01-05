object FileRipForm: TFileRipForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'FileRipper'
  ClientHeight = 495
  ClientWidth = 479
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDesigned
  ScreenSnap = True
  SnapBuffer = 50
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GBoxFolder: TGroupBox
    Left = 275
    Top = 0
    Width = 200
    Height = 175
    TabOrder = 0
    object Label4: TLabel
      Left = 5
      Top = 135
      Width = 69
      Height = 13
      Caption = 'Target Folder:'
    end
    object PnlSearchFolder: TPanel
      Left = 5
      Top = 75
      Width = 180
      Height = 60
      TabOrder = 0
      object Label1: TLabel
        Left = 5
        Top = 25
        Width = 51
        Height = 13
        Caption = 'Extension:'
      end
      object EdtSourceFolder: TEdit
        Left = 5
        Top = 5
        Width = 120
        Height = 17
        TabStop = False
        BevelKind = bkFlat
        BorderStyle = bsNone
        TabOrder = 0
      end
      object EdtSourceExt: TEdit
        Left = 5
        Top = 40
        Width = 50
        Height = 15
        TabStop = False
        BevelKind = bkFlat
        BevelOuter = bvRaised
        BorderStyle = bsNone
        TabOrder = 1
      end
      object BtnSourceFolder: TButton
        Left = 131
        Top = 5
        Width = 45
        Height = 17
        Caption = 'Browse'
        TabOrder = 2
        TabStop = False
        OnClick = BtnSourceFolderClick
      end
    end
    object PnlSearchFile: TPanel
      Left = 5
      Top = 30
      Width = 180
      Height = 25
      TabOrder = 1
      object EdtSourceFile: TEdit
        Left = 5
        Top = 4
        Width = 120
        Height = 17
        TabStop = False
        BevelKind = bkFlat
        BorderStyle = bsNone
        TabOrder = 0
      end
      object BtnSourceFile: TButton
        Left = 130
        Top = 4
        Width = 45
        Height = 17
        Caption = 'Browse'
        TabOrder = 1
        TabStop = False
        OnClick = BtnSourceFileClick
      end
    end
    object EdtTargetFolder: TEdit
      Left = 5
      Top = 150
      Width = 120
      Height = 17
      TabStop = False
      BevelKind = bkFlat
      BorderStyle = bsNone
      TabOrder = 2
    end
    object BtnTargetFolder: TButton
      Left = 130
      Top = 150
      Width = 45
      Height = 17
      Caption = 'Browse'
      TabOrder = 3
      TabStop = False
      OnClick = BtnTargetFolderClick
    end
    object RBtnSearchFile: TRadioButton
      Left = 5
      Top = 10
      Width = 113
      Height = 17
      Caption = 'Search in one file:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = RBtnSearchFileClick
    end
    object RBtnSearchFolder: TRadioButton
      Left = 5
      Top = 55
      Width = 142
      Height = 17
      Caption = 'Search in more files'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = RBtnSearchFolderClick
    end
  end
  object PnlFormats: TGroupBox
    Left = 275
    Top = 205
    Width = 200
    Height = 110
    Caption = 'Formats:'
    TabOrder = 1
    object TreeFormat: TTreeView
      Left = 5
      Top = 15
      Width = 130
      Height = 90
      Indent = 19
      ReadOnly = True
      TabOrder = 0
      TabStop = False
      OnMouseDown = TreeFormatMouseDown
    end
    object GBoxSelect: TGroupBox
      Left = 140
      Top = 10
      Width = 55
      Height = 60
      Caption = 'Select:'
      TabOrder = 1
      object BtnSelectAll: TButton
        Left = 5
        Top = 15
        Width = 45
        Height = 17
        Caption = 'All'
        TabOrder = 0
        TabStop = False
        OnClick = BtnSelectAllClick
      end
      object BtnSelectNone: TButton
        Left = 5
        Top = 35
        Width = 45
        Height = 17
        Caption = 'None'
        TabOrder = 1
        TabStop = False
        OnClick = BtnSelectNoneClick
      end
    end
  end
  object PnlLogger: TPanel
    Left = 5
    Top = 370
    Width = 470
    Height = 120
    FullRepaint = False
    ParentBackground = False
    TabOrder = 2
    object Gauge1: TGauge
      Left = 64
      Top = 7
      Width = 340
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
      Left = 415
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
      Width = 460
      Height = 90
      TabStop = False
      BevelOuter = bvRaised
      BevelKind = bkFlat
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 2
    end
  end
  object GBoxFound: TGroupBox
    Left = 5
    Top = 0
    Width = 265
    Height = 315
    Caption = 'Found Entries:'
    TabOrder = 3
    object GBoxCheck: TGroupBox
      Left = 204
      Top = 10
      Width = 55
      Height = 60
      Caption = ' Check:'
      TabOrder = 0
      object BtnCheckAll: TButton
        Left = 5
        Top = 15
        Width = 45
        Height = 17
        Caption = 'All'
        TabOrder = 0
        TabStop = False
        OnClick = BtnCheckAllClick
      end
      object BtnCheckNone: TButton
        Left = 5
        Top = 35
        Width = 45
        Height = 17
        Caption = 'None'
        TabOrder = 1
        TabStop = False
        OnClick = BtnCheckNoneClick
      end
    end
    object GBoxSelected: TGroupBox
      Left = 205
      Top = 70
      Width = 55
      Height = 80
      Caption = 'Selected:'
      TabOrder = 1
      object BtnOpen: TButton
        Left = 5
        Top = 15
        Width = 45
        Height = 17
        Caption = 'Open'
        TabOrder = 0
        TabStop = False
        OnClick = BtnOpenClick
      end
      object BtnHEX: TButton
        Left = 5
        Top = 35
        Width = 45
        Height = 17
        Caption = 'Hex'
        TabOrder = 1
        TabStop = False
        OnClick = BtnHEXClick
      end
    end
    object GBoxChecked: TGroupBox
      Left = 205
      Top = 150
      Width = 55
      Height = 80
      Caption = 'Checked:'
      TabOrder = 2
      object BtnExtract: TButton
        Left = 5
        Top = 15
        Width = 45
        Height = 17
        Caption = 'Extract'
        Enabled = False
        TabOrder = 0
        TabStop = False
        OnClick = BtnExtractClick
      end
      object BtnReplace: TButton
        Left = 5
        Top = 55
        Width = 45
        Height = 17
        Caption = 'Replace'
        Enabled = False
        TabOrder = 1
        TabStop = False
        OnClick = BtnReplaceClick
      end
      object BtnDelete: TButton
        Left = 5
        Top = 35
        Width = 45
        Height = 17
        Caption = 'Delete'
        Enabled = False
        TabOrder = 2
        TabStop = False
        OnClick = BtnDeleteClick
      end
    end
    object GBoxAll: TGroupBox
      Left = 205
      Top = 230
      Width = 55
      Height = 80
      Caption = 'All (Fast):'
      TabOrder = 3
      object BtnExtractAll: TButton
        Left = 5
        Top = 15
        Width = 45
        Height = 17
        Caption = 'Extract'
        Enabled = False
        TabOrder = 0
        TabStop = False
        OnClick = BtnExtractAllClick
      end
      object BtnDupeAll: TButton
        Left = 5
        Top = 55
        Width = 45
        Height = 17
        Caption = 'Replace'
        Enabled = False
        TabOrder = 1
        TabStop = False
        OnClick = BtnDupeAllClick
      end
      object BtnDeleteAll: TButton
        Left = 5
        Top = 35
        Width = 45
        Height = 17
        Caption = 'Delete'
        Enabled = False
        TabOrder = 2
        TabStop = False
        OnClick = BtnDeleteAllClick
      end
    end
    object TreeFile: TTreeView
      Left = 5
      Top = 15
      Width = 195
      Height = 295
      Indent = 19
      ReadOnly = True
      TabOrder = 4
      OnClick = TreeFileClick
      OnMouseDown = TreeFileMouseDown
    end
  end
  object PnlSearch: TPanel
    Left = 280
    Top = 175
    Width = 190
    Height = 30
    BevelInner = bvRaised
    BevelKind = bkTile
    TabOrder = 4
    object BtnSearch: TButton
      Left = 5
      Top = 5
      Width = 55
      Height = 17
      Caption = 'Start'
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
      OnClick = BtnCancelClick
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
      OnClick = BtnPauseClick
    end
  end
  object GBoxEntryInfo: TGroupBox
    Left = 5
    Top = 315
    Width = 130
    Height = 50
    Caption = 'Selected Chunk Info:'
    TabOrder = 5
    object LblChunkOffsetSel: TLabel
      Left = 5
      Top = 15
      Width = 35
      Height = 13
      Caption = 'Offset:'
    end
    object LblChunkSizeSel: TLabel
      Left = 5
      Top = 30
      Width = 23
      Height = 13
      Caption = 'Size:'
    end
  end
  object GBoxInfoAll: TGroupBox
    Left = 275
    Top = 315
    Width = 200
    Height = 50
    Caption = 'Total Info:'
    TabOrder = 6
    object LblChunkCountTot: TLabel
      Left = 5
      Top = 15
      Width = 39
      Height = 13
      Caption = 'Chunks:'
    end
    object LblChunkSizeTot: TLabel
      Left = 5
      Top = 30
      Width = 23
      Height = 13
      Caption = 'Size:'
    end
  end
  object GBoxInfoArchive: TGroupBox
    Left = 140
    Top = 315
    Width = 130
    Height = 50
    Caption = 'Archive Chunks Info:'
    TabOrder = 7
    object LblChunkCountArch: TLabel
      Left = 5
      Top = 15
      Width = 39
      Height = 13
      Caption = 'Chunks:'
    end
    object LblChunkSizeArch: TLabel
      Left = 5
      Top = 30
      Width = 23
      Height = 13
      Caption = 'Size:'
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'All Files|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofNoNetworkButton, ofEnableSizing, ofForceShowHidden]
    Left = 625
    Top = 365
  end
end
