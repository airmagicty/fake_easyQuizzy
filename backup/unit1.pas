unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  LazUTF8, Process;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  value, total, proz: integer;
  res_str, testkill, t1, evalue: string;
  ldate, enddate: TDate;

implementation

{$R *.lfm}

{ TForm2 }
uses Unit2;

{ TForm1 }

//TaskKill
procedure TaskKill(FileName: String);
var AProcess: TProcess;
  begin
    AProcess := TProcess.Create(nil);
    AProcess.CommandLine := 'cmd  /x/c taskkill /f /im "'+FileName+'"';
    //AProcess.CommandLine := 'notepad.exe';
    AProcess.Options := AProcess.Options + [poWaitOnExit];
    AProcess.Execute;
    AProcess.Free;
    //ShowMessage ('notepad.exe остановлен!');
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  // открываем новое окно и -скрываем старое
  Form2.Show;
  Form1.Hide;
  //Form1.Visible := false;

  // Килл теста
  if length(Form1.Edit4.Text) <> 0 then
    begin
    testkill := trim(Form1.Edit4.Text);
    t1 := testkill[length(testkill)] +
          testkill[length(testkill)-1] +
          testkill[length(testkill)-2] +
          testkill[length(testkill)-3];
    // имя килла
    if t1 = 'exe.' then
      TaskKill(testkill)
    else
      TaskKill(testkill+'.exe');
  end;

  // меняем имя титула Form2
  if length(Form1.Edit3.Text) <> 0 then
    Form2.Caption := trim(Form1.Edit3.Text) + ' — результат тестирования easyQuizzy'
  else
    Form2.Caption := 'Created by @airmagicty — результат тестирования easyQuizzy';

  // value total
  if length(Form1.Edit1.Text) <> 0 then
    value := StrToInt(Form1.Edit1.Text)
  else value := 0;

  if length(Form1.Edit2.Text) <> 0 then
    total := StrToInt(Form1.Edit2.Text)
  else total := 0;

  // проверка какой тип теста
  if Form1.RadioButton1.Checked = true then
  begin
    // большая цифра
    Form2.Label1.Caption := Form1.Edit1.Text;

    // label3 form2 балл
    Form2.Label3.Caption := 'Подождите 10 секунд';

    // окончание
    if (value >= 11) and (value <= 14) then
      res_str := 'баллов'
    else case value mod 10 of
      1: res_str := 'балл';
      2..4: res_str := 'балла';
      else res_str := 'баллов';
    end;

    // n из m
    if (length(Form1.Edit1.Text) <> 0) and (length(Form1.Edit2.Text) <> 0) then
      Form2.Label2.Caption := Form1.Edit1.Text + ' ' + res_str + ' из ' + Form1.Edit2.Text
    else
      Form2.Label2.Caption := 'Created by @airmagicty';

  end
  // если выбран 2й вариант
  else if Form1.RadioButton2.Checked = true then
  begin
    // большая цифра
    if total <> 0 then
      proz := round((value/total)*100)
    else
      proz := 100;

    if length(Form1.Edit5.Text) <= 0 then
    begin
      if proz = 0 then
        evalue := '1';
      if proz >= 10 then
        evalue := '2';
      if proz >= 50 then
        evalue := '3';
      if proz >= 70 then
        evalue := '4';
      if proz >= 90 then
        evalue := '5';
    end
    else
      evalue := Form1.Edit5.Text;

    // label3 form2 балл
    Form2.Label3.Caption := 'Подождите 30 секунд';

    // окончание
    if (value >= 11) and (value <= 14) then
      res_str := 'правильных ответов'
    else case value mod 10 of
      1: res_str := 'правильный ответ';
      2..4: res_str := 'правильных ответа';
      else res_str := 'правильных ответов';
    end;

    // n из m
    if (length(Form1.Edit1.Text) <> 0) and (length(Form1.Edit2.Text) <> 0) then
    begin
      Form2.Label2.Caption := Form1.Edit1.Text + ' ' + res_str + ' из ' + Form1.Edit2.Text;
      Form2.Label1.Caption := evalue;
    end
    else
      Form2.Label2.Caption := 'Created by @airmagicty';
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // дата конца и текущая
  enddate := StrToDate('01.01.2999');
  ldate := date();

  // ограничения
  if ldate > enddate then
  begin
    Form1.Button1.Visible := false;
    Form1.Label2.Font.Color := clRed;
    Form1.Edit1.Enabled := false;
    Form1.Edit2.Enabled := false;
    Form1.Edit3.Enabled := false;
    Form1.Edit4.Enabled := false;
    Form1.Edit5.Enabled := false;
    Form1.RadioButton1.Enabled := false;
    Form1.RadioButton2.Enabled := false;
    Form1.Label2.Caption := 'Приобретите лицензию';
  end
  else
  begin
    Form1.Label2.Font.Color := clHotLight;
    Form1.Label2.Caption := 'Лицензия до: ' + DateToStr(enddate);
  end;

end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  Form1.Edit5.Visible := false;
  Form1.RadioButton2.Caption := 'Экзамен';
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  Form1.RadioButton2.Caption := 'Экз';
  Form1.Edit5.Visible := true;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  ShowMessage('FLTest - Генератор результата тестирования easyQuizzy'+#13+
              'Версия: 1.1 release'+#13+
              'Разработчик: airmagicty'+#13+
              '© 2022г'+#13+
              #13+
              'Автор не несет ответственности за использование пользователем данной программы, все предоставлено исключительно в образовательных и развлекательных целях.'+#13+
              #13+
              'Инструкция по использованию:'+#13+
              '1. В первую строку введите [количество полученных баллов] из [всего баллов (обычно равно количеству вопросов)].'+#13+
              '2. Во вторую строку [Заголовок] введите текст, который будет оборажаться сверху при сгенерированном окне тестирования. К примеру, мой тест имеет заголовок «Проверочный тест к главе 1 "Информация и информационные процессы"».'+#13+
              '3. В третью строку [Процесс.exe] введите имя файла тестирования, который вы запустили. Например мой файл называется "test-10-1.exe" и я введу "test-10-1" (можно и с .exe, программа все-равно поймет правильно). Это необходимо для того, чтобы завершить уже запущенное тестирование (по умолчанию у них защита от закрытия крестиком). Поле можно оставить пустым, если такого процесса нет, и оно будет прогнорировано.'+#13+
              '4. Выберите тип тестирования: простое или экзаменационное. Разница в таймере ожидания, "баллы" заменены на "ответы" и изменен формат оценки.'+#13+
              '4.1 При выборе экзаменационного типы вы можете вручную задать желаемую оценку. Игнорируйте это поле, если хотите, чтобы рассчет произвелся автоматически (90-70-50-1-0).'+#13+
              '5. Нажмите [Создать] - это окно скроется, закроется открытый процесс (если поле [Процесс.exe] не пустое) и откроется сгенерированное окно с заданными параметрами.'+#13+
              'Примечание1: при сворачивании сгенерированного окна с результатом - оно скроется.'+#13+
              'Примечание2: с помощью кнопки [Сохранить в файл...] можно загрузить заранее подготовленный вами отчет (только .rtf).'+#13+
              #13+
              'Если вы не можете пользоваться продуктом и видите надпись "Приобретите лицензию" - то значит, что ваш срок пользования программой истек. Обратитесь к создателю для продления.'+#13+
              'Создано для: Босова Л. Л. - Электронное приложение к учебнику «Информатика» + Экзамен на easyQuizzy'+#13);
end;

end.

