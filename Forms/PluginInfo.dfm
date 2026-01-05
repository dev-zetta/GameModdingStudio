object PluginInfoForm: TPluginInfoForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'PluginInfo v1.0'
  ClientHeight = 243
  ClientWidth = 464
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
  object gbActionPanel: TGroupBox
    Left = 180
    Top = 0
    Width = 280
    Height = 220
    Caption = 'Plugin info:'
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 105
      Width = 57
      Height = 13
      Caption = 'Description:'
    end
    object Label2: TLabel
      Left = 10
      Top = 25
      Width = 54
      Height = 13
      Caption = 'Kit Version:'
    end
    object Label3: TLabel
      Left = 85
      Top = 25
      Width = 70
      Height = 13
      Caption = 'Plugin Version:'
    end
    object Label4: TLabel
      Left = 160
      Top = 25
      Width = 77
      Height = 13
      Caption = 'Author of plugin'
    end
    object Label5: TLabel
      Left = 10
      Top = 65
      Width = 57
      Height = 13
      Caption = 'Plugin path:'
    end
    object edtKitVersion: TEdit
      Left = 10
      Top = 40
      Width = 70
      Height = 20
      AutoSize = False
      TabOrder = 0
    end
    object mmPluginDescription: TMemo
      Left = 10
      Top = 120
      Width = 260
      Height = 90
      TabOrder = 1
    end
    object edtPluginVersion: TEdit
      Left = 85
      Top = 40
      Width = 70
      Height = 20
      AutoSize = False
      TabOrder = 2
    end
    object edtPluginAuthor: TEdit
      Left = 160
      Top = 40
      Width = 110
      Height = 20
      AutoSize = False
      TabOrder = 3
    end
    object edtPluginPath: TEdit
      Left = 10
      Top = 80
      Width = 260
      Height = 20
      AutoSize = False
      TabOrder = 4
    end
  end
  object lvPluginList: TListView
    Left = 5
    Top = 5
    Width = 170
    Height = 215
    Columns = <
      item
        Caption = 'Plugin Name'
        Width = 115
      end
      item
        Caption = 'Enabled'
      end>
    ColumnClick = False
    FlatScrollBars = True
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnSelectItem = lvPluginListSelectItem
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 224
    Width = 464
    Height = 19
    Panels = <
      item
        Width = 175
      end
      item
        Width = 50
      end>
  end
end
