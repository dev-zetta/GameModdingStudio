object AsciiEditorForm: TAsciiEditorForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'AsciiEditor v0.1beta'
  ClientHeight = 575
  ClientWidth = 794
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
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
  object InfoGrid: TStringGrid
    Left = 5
    Top = 5
    Width = 780
    Height = 340
    TabStop = False
    BevelKind = bkFlat
    BevelOuter = bvRaised
    BorderStyle = bsNone
    ColCount = 1
    Ctl3D = True
    DefaultColWidth = 12
    DefaultRowHeight = 12
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Font.Charset = OEM_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Terminal'
    Font.Style = []
    Options = [goVertLine, goHorzLine, goRangeSelect]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    OnDrawCell = InfoGridDrawCell
    OnKeyPress = InfoGridKeyPress
    OnMouseDown = InfoGridMouseDown
    OnMouseMove = InfoGridMouseMove
    OnMouseUp = InfoGridMouseUp
    OnSelectCell = InfoGridSelectCell
    OnTopLeftChanged = InfoGridTopLeftChanged
  end
  object AsciiGrid: TStringGrid
    Left = 5
    Top = 440
    Width = 515
    Height = 132
    TabStop = False
    BevelInner = bvLowered
    BevelKind = bkFlat
    BorderStyle = bsNone
    ColCount = 32
    DefaultColWidth = 15
    DefaultRowHeight = 15
    FixedCols = 0
    RowCount = 8
    FixedRows = 0
    Font.Charset = OEM_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Terminal'
    Font.Style = []
    Options = [goVertLine, goHorzLine]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 1
    OnSelectCell = AsciiGridSelectCell
  end
  object ColorGrid: TDrawGrid
    Left = 525
    Top = 440
    Width = 260
    Height = 132
    TabStop = False
    BevelInner = bvLowered
    BevelKind = bkFlat
    BorderStyle = bsNone
    ColCount = 16
    DefaultColWidth = 15
    DefaultRowHeight = 15
    FixedCols = 0
    RowCount = 8
    FixedRows = 0
    TabOrder = 2
    OnDblClick = ColorGridDblClick
    OnDrawCell = ColorGridDrawCell
    OnMouseDown = ColorGridMouseDown
    OnSelectCell = ColorGridSelectCell
  end
  object Panel1: TPanel
    Left = 525
    Top = 350
    Width = 260
    Height = 85
    BevelInner = bvRaised
    BevelKind = bkSoft
    TabOrder = 3
    object Label1: TLabel
      Left = 5
      Top = 30
      Width = 52
      Height = 13
      Caption = 'Back color:'
    end
    object Label2: TLabel
      Left = 5
      Top = 50
      Width = 52
      Height = 13
      Caption = 'Fore color:'
    end
    object shBackColor: TShape
      Left = 60
      Top = 30
      Width = 15
      Height = 15
      OnMouseDown = shBackColorMouseDown
    end
    object shForeColor: TShape
      Left = 60
      Top = 50
      Width = 15
      Height = 15
      Brush.Color = clBlack
      OnMouseDown = shForeColorMouseDown
    end
    object cbFontList: TComboBox
      Left = 5
      Top = 5
      Width = 120
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      TabStop = False
      OnChange = cbFontListChange
    end
    object bgMainCommand: TButtonGroup
      Left = 130
      Top = 5
      Width = 120
      Height = 70
      BevelKind = bkTile
      BorderStyle = bsNone
      ButtonHeight = 22
      ButtonOptions = [gboFullSize, gboShowCaptions]
      Items = <
        item
          Caption = 'New project'
        end
        item
          Caption = 'Load project'
        end
        item
          Caption = 'Save project'
        end
        item
          Caption = 'Load from file'
        end
        item
          Caption = 'Save to file'
        end
        item
          Caption = 'Save to bitmap'
        end
        item
          Caption = 'Load palette'
        end
        item
          Caption = 'Save palette'
        end
        item
          Caption = 'Randomize palette'
        end
        item
          Caption = 'BmpToAscii'
        end>
      TabOrder = 1
      TabStop = False
      OnButtonClicked = bgMainCommandButtonClicked
    end
    object btnResetBack: TButton
      Left = 80
      Top = 30
      Width = 15
      Height = 15
      Caption = 'W'
      TabOrder = 2
      TabStop = False
      OnClick = btnResetBackClick
    end
    object btnResetFore: TButton
      Left = 80
      Top = 50
      Width = 15
      Height = 15
      Caption = 'B'
      TabOrder = 3
      TabStop = False
      OnClick = btnResetForeClick
    end
  end
  object Panel2: TPanel
    Left = 5
    Top = 350
    Width = 515
    Height = 85
    BevelInner = bvRaised
    BevelKind = bkSoft
    TabOrder = 4
    object Label3: TLabel
      Left = 380
      Top = 11
      Width = 53
      Height = 13
      Hint = 'Brush Size - Width and Height'
      Caption = 'Brush Size:'
      ParentShowHint = False
      ShowHint = True
    end
    object Label4: TLabel
      Left = 135
      Top = 40
      Width = 164
      Height = 19
      Caption = 'Under construction !'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Button1: TButton
      Left = 5
      Top = 5
      Width = 60
      Height = 20
      Caption = 'None'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 70
      Top = 5
      Width = 60
      Height = 20
      Caption = 'Pen'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 200
      Top = 5
      Width = 60
      Height = 20
      Caption = 'Rectangle'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 265
      Top = 5
      Width = 60
      Height = 20
      Caption = 'Frame'
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 135
      Top = 5
      Width = 60
      Height = 20
      Caption = 'Brush'
      TabOrder = 4
      OnClick = Button5Click
    end
    object edtBrushWidth: TEdit
      Left = 380
      Top = 30
      Width = 15
      Height = 21
      ReadOnly = True
      TabOrder = 5
    end
    object udBrushWidth: TUpDown
      Left = 395
      Top = 30
      Width = 16
      Height = 20
      Min = 1
      Position = 1
      TabOrder = 6
      OnChanging = udBrushWidthChanging
    end
    object edtBrushHeight: TEdit
      Left = 410
      Top = 30
      Width = 15
      Height = 21
      ReadOnly = True
      TabOrder = 7
    end
    object udBrushHeight: TUpDown
      Left = 425
      Top = 30
      Width = 16
      Height = 20
      Min = 1
      Position = 1
      TabOrder = 8
      OnChanging = udBrushHeightChanging
    end
    object Button6: TButton
      Left = 380
      Top = 55
      Width = 60
      Height = 20
      Hint = 'This will erase document!'
      Caption = 'Erase all'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 445
      Top = 5
      Width = 60
      Height = 20
      Hint = 'This will fill document with char from ascii table'
      Caption = 'Char Fill'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      OnClick = Button7Click
    end
    object Button8: TButton
      Left = 445
      Top = 30
      Width = 60
      Height = 20
      Hint = 'This will fill document with back color'
      Caption = 'Back Fill'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
      OnClick = Button8Click
    end
    object Button9: TButton
      Left = 445
      Top = 55
      Width = 60
      Height = 20
      Hint = 'This will fill document with fore color'
      Caption = 'Fore Fill'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 12
      OnClick = Button9Click
    end
    object Button10: TButton
      Left = 5
      Top = 30
      Width = 60
      Height = 20
      Caption = 'Dont click'
      TabOrder = 13
      Visible = False
      OnClick = Button10Click
    end
  end
  object ColorDialog: TColorDialog
    Left = 752
    Top = 536
  end
  object OpenDialog: TOpenDialog
    Filter = 'All Files|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 752
    Top = 504
  end
  object SaveDialog: TSaveDialog
    Filter = 'All files|*.*'
    Left = 720
    Top = 504
  end
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 720
    Top = 536
  end
end
