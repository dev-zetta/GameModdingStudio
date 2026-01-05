object TextureConverterForm: TTextureConverterForm
  Left = 183
  Top = 230
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Texture Converter'
  ClientHeight = 325
  ClientWidth = 569
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
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GBoxFolder: TGroupBox
    Left = 5
    Top = 0
    Width = 190
    Height = 135
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
    object ChBoxSaveTexRecData: TCheckBox
      Left = 5
      Top = 80
      Width = 164
      Height = 17
      TabStop = False
      Caption = 'Save TexRec Data'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = ChBoxSaveTexRecDataClick
    end
    object PnlSaveTexRecData: TPanel
      Left = 5
      Top = 100
      Width = 180
      Height = 25
      TabOrder = 5
      object EdtTexRecDataPath: TEdit
        Left = 5
        Top = 5
        Width = 120
        Height = 15
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
      object BtnTexRecDataPath: TButton
        Left = 130
        Top = 5
        Width = 45
        Height = 15
        Caption = 'Browse'
        TabOrder = 1
        TabStop = False
        OnClick = BtnTexRecDataPathClick
      end
    end
  end
  object GBoxFormat: TGroupBox
    Left = 5
    Top = 170
    Width = 190
    Height = 150
    TabOrder = 1
    object Label3: TLabel
      Left = 5
      Top = 10
      Width = 74
      Height = 13
      Caption = 'Source Format:'
    end
    object Label4: TLabel
      Left = 5
      Top = 75
      Width = 73
      Height = 13
      Caption = 'Target Format:'
    end
    object Label12: TLabel
      Left = 90
      Top = 10
      Width = 67
      Height = 13
      Caption = 'Added Filters:'
    end
    object LBoxSourceExt: TListBox
      Left = 5
      Top = 25
      Width = 75
      Height = 50
      TabStop = False
      Style = lbOwnerDrawFixed
      AutoComplete = False
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      ExtendedSelect = False
      ItemHeight = 13
      Items.Strings = (
        'JPG'
        'TGA'
        'DDS'
        'BMP'
        'PNG')
      TabOrder = 0
    end
    object LBoxTargetExt: TListBox
      Left = 5
      Top = 90
      Width = 75
      Height = 50
      TabStop = False
      Style = lbOwnerDrawFixed
      AutoComplete = False
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      ExtendedSelect = False
      ItemHeight = 13
      Items.Strings = (
        'JPG'
        'TGA'
        'DDS'
        'BMP'
        'PNG')
      TabOrder = 1
    end
    object BtnAddFilter: TButton
      Left = 90
      Top = 125
      Width = 40
      Height = 15
      Caption = 'Add'
      TabOrder = 2
      TabStop = False
      OnClick = BtnAddFilterClick
    end
    object LBoxTexFilters: TListBox
      Left = 90
      Top = 25
      Width = 90
      Height = 95
      TabStop = False
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      ItemHeight = 13
      TabOrder = 3
    end
    object BtnDeleteFilter: TButton
      Left = 140
      Top = 125
      Width = 40
      Height = 15
      Caption = 'Delete'
      TabOrder = 4
      TabStop = False
      OnClick = BtnDeleteFilterClick
    end
  end
  object GBoxSetting: TGroupBox
    Left = 200
    Top = 0
    Width = 365
    Height = 210
    Caption = 'Settings:'
    TabOrder = 2
    object PnlAScanEnabled: TPanel
      Left = 175
      Top = 35
      Width = 180
      Height = 170
      TabOrder = 0
      object Label2: TLabel
        Left = 5
        Top = 5
        Width = 120
        Height = 13
        Caption = 'Files with Alpha Channel:'
      end
      object Label9: TLabel
        Left = 5
        Top = 80
        Width = 71
        Height = 13
        Caption = 'Extra Folder:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RBtnACopyToExtra: TRadioButton
        Left = 5
        Top = 50
        Width = 129
        Height = 17
        Caption = 'Copy to Extra Folder'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
      end
      object RBtnAMoveToExtra: TRadioButton
        Left = 5
        Top = 35
        Width = 129
        Height = 17
        Caption = 'Move to Extra Folder'
        TabOrder = 1
      end
      object RBtnAReportOnly: TRadioButton
        Left = 5
        Top = 20
        Width = 113
        Height = 17
        Caption = 'Only Report'
        TabOrder = 2
      end
      object RBtnASplitAlpha: TRadioButton
        Left = 5
        Top = 65
        Width = 132
        Height = 17
        Caption = 'Split and delete alpha '
        TabOrder = 3
      end
      object ChBoxASaveAlphaList: TCheckBox
        Left = 5
        Top = 120
        Width = 115
        Height = 17
        TabStop = False
        Caption = 'Save AlphaList:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = ChBoxASaveAlphaListClick
      end
      object PnlASaveAlphaList: TPanel
        Left = 5
        Top = 140
        Width = 170
        Height = 24
        TabOrder = 5
        object EdtAAlphaListPath: TEdit
          Left = 5
          Top = 5
          Width = 110
          Height = 15
          TabStop = False
          AutoSelect = False
          AutoSize = False
          BevelKind = bkFlat
          BevelOuter = bvRaised
          BorderStyle = bsNone
          Ctl3D = True
          MaxLength = 255
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 0
        end
        object BtnAAlphaListPath: TButton
          Left = 120
          Top = 5
          Width = 45
          Height = 15
          Caption = 'Browse'
          TabOrder = 1
          TabStop = False
          OnClick = BtnAAlphaListPathClick
        end
      end
      object PnlExtra: TPanel
        Left = 5
        Top = 95
        Width = 170
        Height = 24
        Caption = 'Panel5'
        TabOrder = 6
        object EdtAExtraFolder: TEdit
          Left = 5
          Top = 5
          Width = 110
          Height = 15
          TabStop = False
          AutoSelect = False
          AutoSize = False
          BevelKind = bkFlat
          BevelOuter = bvRaised
          BorderStyle = bsNone
          Ctl3D = True
          MaxLength = 255
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 0
        end
        object BtnAExtraFolder: TButton
          Left = 121
          Top = 5
          Width = 45
          Height = 15
          Caption = 'Browse'
          TabOrder = 1
          TabStop = False
          OnClick = BtnAExtraFolderClick
        end
      end
    end
    object ChBoxAScanEnabled: TCheckBox
      Left = 175
      Top = 17
      Width = 145
      Height = 17
      TabStop = False
      Caption = 'Enable Alpha Scanner'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = ChBoxAScanEnabledClick
    end
    object GBoxTarget: TGroupBox
      Left = 5
      Top = 90
      Width = 165
      Height = 115
      Caption = 'Target Format:'
      TabOrder = 2
      object Label6: TLabel
        Left = 5
        Top = 15
        Width = 59
        Height = 13
        Caption = 'JPG Quality:'
      end
      object Label7: TLabel
        Left = 55
        Top = 30
        Width = 14
        Height = 14
        Caption = '%'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 75
        Top = 15
        Width = 88
        Height = 13
        Caption = 'PNG Compression:'
      end
      object ChBoxDelMipMaps: TCheckBox
        Left = 5
        Top = 65
        Width = 119
        Height = 17
        TabStop = False
        Caption = 'Delete MipMaps'
        TabOrder = 0
      end
      object ChBoxDelCubeMap: TCheckBox
        Left = 5
        Top = 80
        Width = 119
        Height = 17
        TabStop = False
        Caption = 'Delete Cube Map'
        TabOrder = 1
      end
      object ChBoxDelVolTex: TCheckBox
        Left = 5
        Top = 95
        Width = 129
        Height = 17
        TabStop = False
        Caption = 'Delete Volume Texture'
        TabOrder = 2
        OnClick = ChBoxDelVolTexClick
      end
      object ChBoxEnableRLEComp: TCheckBox
        Left = 5
        Top = 50
        Width = 140
        Height = 17
        TabStop = False
        Caption = 'Enable RLE Compression'
        TabOrder = 3
      end
      object EdtJPGCompLvl: TEdit
        Left = 5
        Top = 30
        Width = 30
        Height = 17
        TabStop = False
        AutoSize = False
        Ctl3D = False
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 4
        Text = '10'
      end
      object UDJPGCompLvl: TUpDown
        Left = 35
        Top = 30
        Width = 15
        Height = 17
        Associate = EdtJPGCompLvl
        Min = 10
        Max = 90
        Increment = 10
        Position = 10
        TabOrder = 5
      end
      object EdtPNGCompLvl: TEdit
        Left = 75
        Top = 30
        Width = 30
        Height = 17
        TabStop = False
        AutoSize = False
        Ctl3D = False
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 6
        Text = '0'
      end
      object UDPNGCompLvl: TUpDown
        Left = 105
        Top = 30
        Width = 15
        Height = 17
        Associate = EdtPNGCompLvl
        Max = 9
        TabOrder = 7
      end
    end
    object GBoxSource: TGroupBox
      Left = 5
      Top = 18
      Width = 165
      Height = 71
      Caption = 'Source Format:'
      TabOrder = 3
      object Label10: TLabel
        Left = 5
        Top = 15
        Width = 86
        Height = 13
        Caption = 'Min. Texture size:'
      end
      object Label11: TLabel
        Left = 55
        Top = 30
        Width = 34
        Height = 14
        Caption = 'Bytes'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object EdtMinTexSize: TEdit
        Left = 5
        Top = 30
        Width = 30
        Height = 17
        TabStop = False
        AutoSize = False
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        Text = '0'
      end
      object ChBoxDelOrgTex: TCheckBox
        Left = 5
        Top = 50
        Width = 132
        Height = 17
        TabStop = False
        Caption = 'Delete original textures'
        TabOrder = 1
      end
      object UDMinTexSize: TUpDown
        Left = 35
        Top = 30
        Width = 16
        Height = 17
        Associate = EdtMinTexSize
        Max = 32767
        Increment = 1024
        TabOrder = 2
        Thousands = False
      end
    end
  end
  object PnlLogger: TPanel
    Left = 200
    Top = 215
    Width = 365
    Height = 105
    FullRepaint = False
    ParentBackground = False
    TabOrder = 3
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
      OnClick = BtnSaveClick
    end
    object BtnClear: TButton
      Left = 310
      Top = 5
      Width = 50
      Height = 17
      Caption = 'Clear'
      TabOrder = 1
      TabStop = False
      OnClick = BtnClearClick
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
    Top = 137
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
  object SaveDialog1: TSaveDialog
    DefaultExt = '.trl'
    FileName = 'TexRecList'
    Filter = '*.trl|.trl'
    InitialDir = 'C:\'
    Left = 528
    Top = 8
  end
  object SaveDialog2: TSaveDialog
    DefaultExt = '.lst'
    FileName = 'AlphaList'
    Filter = '*.lst|.lst'
    InitialDir = 'C:\'
    Left = 528
    Top = 40
  end
end
