unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, PopupNotifier, ValEdit, LazHelpHTML, ComCtrls, RichMemo, RichView,
  RVStyle, PtblRV, RTTICtrls, SynEdit, SynExportHTML, SynCompletion,
  SynPluginSyncroEdit, IpHtml, JLabeledIntegerEdit, Types;

type

  { TForm2 }

  TForm2 = class(TForm)
    BitBtn1: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    RichMemo1: TRichMemo;
    Timer1: TTimer;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;
  stime: integer;
  res_str: string;

implementation

{$R *.lfm}

{ TForm1 }
uses Unit1;

{ TForm2 }

// Закрыть оба окна при закрытии Form2
procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Form1.Close;
end;

procedure TForm2.FormCreate(Sender: TObject);
var rs : TResourceStream;
begin
  // загрузка примера отчета из сурса
  rs := TResourceStream.Create(HInstance, 'TEST', PChar(RT_RCDATA));
  Form2.RichMemo1.LoadRichText(rs);
  FreeAndNil(rs);
end;

// запуск ожидания
procedure TForm2.FormActivate(Sender: TObject);
begin
  // обозначить экзамен или тест
  if Form1.RadioButton1.Checked = true then
    stime := 3; // 10-1
  if Form1.RadioButton2.Checked = true then
    stime := 29; // 30-1
  Form2.Timer1.Enabled := true;
end;

// по таймеру открыть кнопку отчета
procedure TForm2.Timer1Timer(Sender: TObject);
begin
  // пока идет таймер
  if stime = 0 then
  begin
    // таймер кончился
    Form2.Timer1.Enabled := false;
    Form2.Label3.Visible := false;
    Form2.Button1.Visible := true;
    Form2.Button1.SetFocus;
  end
  else
  begin
    // окончание
    if (stime >= 11) and (stime <= 14) then
      res_str := 'секунд'
    else case stime mod 10 of
      1: res_str := 'секунду';
      2..4: res_str := 'секунды';
      else res_str := 'секунд';
    end;
    Form2.Label3.Caption := 'Подождите ' + IntToStr(stime) + ' ' + res_str;

    // таймер идет
    stime := stime - 1;
  end;
end;

// показать отчет
procedure TForm2.Button1Click(Sender: TObject);
begin
  // скрыть старое
  Form2.Label1.Visible := false;
  Form2.Label2.Visible := false;
  Form2.Button1.Visible := false;

  // открыть новое
  Form2.Button2.Visible := true;
  Form2.BitBtn1.Visible := true;
  Form2.RichMemo1.Visible := true;

  // выделить синим Печать
  Form2.Button2.SetFocus;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  srtf: TFileStream;
begin
  srtf := nil;
  with TOpenDialog.Create(self) do
  try
    Filter:='RTF документы |*.rtf|'+'Все файлы |*.*|';
  if Execute then
  begin
    srtf := TFileStream.Create(Utf8ToAnsi(FileName), fmOpenRead or fmShareDenyNone);
    RichMemo1.LoadRichText(srtf);
  end;
  finally
    Free;
  end;
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
  // Тут я тестировал разную фигню, кнопка для отладки крч
end;

end.

