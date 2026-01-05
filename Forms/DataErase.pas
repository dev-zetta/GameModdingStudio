unit DataErase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Gauges;

type
  TDataEraseForm = class(TForm)
    GBoxFolder: TGroupBox;
    PnlSearchFolder: TPanel;
    Label1: TLabel;
    EdtSourceFolder: TEdit;
    EdtSourceExt: TEdit;
    BtnSourceFolder: TButton;
    PnlSearchFile: TPanel;
    EdtSourceFile: TEdit;
    BtnSourceFile: TButton;
    RBtnSearchFile: TRadioButton;
    RBtnSearchFolder: TRadioButton;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    PnlSearch: TPanel;
    BtnSearch: TButton;
    BtnCancel: TButton;
    BtnPause: TButton;
    PnlLogger: TPanel;
    Gauge1: TGauge;
    BtnSave: TButton;
    BtnClear: TButton;
    RichEdit1: TRichEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataEraseForm: TDataEraseForm;

implementation

{$R *.dfm}

end.
