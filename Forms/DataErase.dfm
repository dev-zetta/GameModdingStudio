object DataEraseForm: TDataEraseForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Data Eraser'
  ClientHeight = 270
  ClientWidth = 404
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object GBoxFolder: TGroupBox
    Left = 5
    Top = 0
    Width = 200
    Height = 140
    TabOrder = 0
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
      end
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
      TabOrder = 2
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
      TabOrder = 3
    end
  end
  object GroupBox1: TGroupBox
    Left = 210
    Top = 0
    Width = 190
    Height = 70
    Caption = 'Settings:'
    TabOrder = 1
    object CheckBox1: TCheckBox
      Left = 5
      Top = 15
      Width = 97
      Height = 17
      Caption = 'Delete Files'
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 5
      Top = 30
      Width = 102
      Height = 17
      Caption = 'Random Rename'
      TabOrder = 1
    end
    object CheckBox3: TCheckBox
      Left = 5
      Top = 45
      Width = 116
      Height = 17
      Caption = 'Write Random Data'
      TabOrder = 2
    end
  end
  object PnlSearch: TPanel
    Left = 210
    Top = 110
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
  object PnlLogger: TPanel
    Left = 5
    Top = 145
    Width = 395
    Height = 120
    FullRepaint = False
    ParentBackground = False
    TabOrder = 3
    object Gauge1: TGauge
      Left = 70
      Top = 7
      Width = 260
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
      Left = 340
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
      Width = 385
      Height = 90
      TabStop = False
      BevelOuter = bvRaised
      BevelKind = bkFlat
      BorderStyle = bsNone
      ScrollBars = ssVertical
      TabOrder = 2
    end
  end
end
