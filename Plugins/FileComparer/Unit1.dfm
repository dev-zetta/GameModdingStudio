object PluginForm: TPluginForm
  Left = 302
  Top = 165
  AlphaBlend = True
  AlphaBlendValue = 240
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'FileComparer'
  ClientHeight = 203
  ClientWidth = 552
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lvCompare: TListView
    Left = 221
    Top = 5
    Width = 308
    Height = 172
    Columns = <
      item
        Caption = 'Offset'
        Width = 100
      end
      item
        Caption = 'Original value'
        Width = 100
      end
      item
        Caption = 'Changed value'
        Width = 100
      end>
    ColumnClick = False
    FlatScrollBars = True
    GridLines = True
    HotTrack = True
    RowSelect = True
    TabOrder = 0
    TabStop = False
    ViewStyle = vsReport
  end
  object GroupBox1: TGroupBox
    Left = 5
    Top = 0
    Width = 200
    Height = 145
    TabOrder = 1
    object Label1: TLabel
      Left = 5
      Top = 10
      Width = 54
      Height = 13
      Caption = 'Original file:'
    end
    object Label2: TLabel
      Left = 5
      Top = 50
      Width = 62
      Height = 13
      Caption = 'Changed file:'
    end
    object Label3: TLabel
      Left = 8
      Top = 125
      Width = 107
      Height = 13
      Caption = 'Number of differences:'
    end
    object lblDifferentCount: TLabel
      Left = 120
      Top = 125
      Width = 6
      Height = 13
      Caption = '0'
    end
    object btnOriginalFile: TButton
      Left = 130
      Top = 25
      Width = 50
      Height = 20
      Caption = 'Browse'
      TabOrder = 0
      OnClick = btnOriginalFileClick
    end
    object edtOriginalFile: TEdit
      Left = 5
      Top = 25
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object edtChangedFile: TEdit
      Left = 5
      Top = 65
      Width = 121
      Height = 21
      TabOrder = 2
    end
    object btnChangedFile: TButton
      Left = 130
      Top = 65
      Width = 50
      Height = 20
      Caption = 'Browse'
      TabOrder = 3
      OnClick = btnChangedFileClick
    end
    object btnStart: TButton
      Left = 8
      Top = 96
      Width = 50
      Height = 20
      Caption = 'Start'
      TabOrder = 4
      OnClick = btnStartClick
    end
    object cbEqual: TCheckBox
      Left = 72
      Top = 96
      Width = 113
      Height = 17
      Caption = 'Filesize must equal'
      TabOrder = 5
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 184
    Width = 552
    Height = 19
    Panels = <
      item
        Text = 'Info:'
        Width = 50
      end
      item
        Width = 300
      end
      item
        Text = 'Only 1024 differences will be shown!'
        Width = 50
      end>
  end
  object ProgressBar1: TProgressBar
    Left = 5
    Top = 150
    Width = 200
    Height = 16
    TabOrder = 3
  end
  object OpenDialog1: TOpenDialog
    Filter = 'All files|*.*'
    Left = 224
    Top = 168
  end
end
