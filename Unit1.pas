unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  SyntacticalAnalyzer, Logger, LexicalAnalyzer;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Memo1: TMemo;
    Memo2: TMemo;
    Button2: TButton;
    ButtonCompile: TButton;
    procedure ButtonCompileClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    function Zagolovok(): boolean;
    function SpisokObiavlenii(): boolean;
    function Obiavlenie(var index: integer): boolean;
    procedure SyntaxAnalyzer();
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  // Объявление записи
  TLexScaner = Record
    id: integer;
    name: string;
    number: integer;
  end;

const
  SysAlfaCount = 23;
  NumbersCount = 10;
  AlfaCount = 26;
  KolInd = 5;

var
  Form1: TForm1;
  // массив скомпилированных кодов программы
  // IdArray: array [1 .. 200] of TLexScaner;
  IdArray: TList<TLexScaner>;
  // список идентификаторов
  Identifier: TList<String>;
  SysAlfa: array [1 .. SysAlfaCount] of string = (
    'program',
    'var',
    'begin',
    'end',
    'integer',
    'div',
    'read',
    'write',
    'for',
    'do',
    'to',
    'идентификатор',
    'число',
    ';',
    ':',
    ',',
    '=',
    '.',
    '+',
    '-',
    '*',
    '(',
    ')'
  );
  Numbers: array [1 .. NumbersCount] of string = (
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0'
  );

implementation

{$R *.dfm}

function SearchLexInIdArray(aLex: string): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to IdArray.Count do
  begin
    if SysAlfa[IdArray[i].id] = aLex then
    begin
      result := i;
      break;
    end;
  end;
end;

function SearchIdentifier(lex: string): boolean;
begin
  result := Identifier.Contains(lex);
end;

procedure AddIdentifier(lex: string);
begin
  Identifier.Add(lex);
end;

function TForm1.Obiavlenie(var index: integer): boolean;
var
  i: integer;
  lex, ident: string;

  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
    ident := IdArray[i].name;
  end;

begin
  i := index;
  NextLex();

  if lex = 'идентификатор' then
  begin
    if SearchIdentifier(ident) then
      TLogger.Log('Такой индефикатор уже существует')
    else
      AddIdentifier(ident);

    NextLex();
    while lex = ',' do
    begin
      NextLex();
      if SearchIdentifier(ident) then
        TLogger.Log('Такой индефикатор уже существует')
      else
        AddIdentifier(ident);
      NextLex();
    end;

    if (lex = ':') then
    begin
      NextLex();
      if (lex = 'integer') then
      begin
        index := i;
        exit
      end
      else
        TLogger.Log('Ожидается integer');
    end
    else
      TLogger.Log('Ожидается двоеточие');
  end
  else
    TLogger.Log('Ожидается идентефикорав');

  index := i;
end;

function TForm1.SpisokObiavlenii(): boolean;
var
  i: integer;
  lex, nLex: string;

  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
    nLex := SysAlfa[IdArray[i + 1].id];
  end;

begin
  result := false;
  i := -1;
  NextLex();

  i := SearchLexInIdArray('var');

  Obiavlenie(i);
  NextLex();
  while ((nLex <> 'begin') and (lex = ';')) do
  BEGIN
    Obiavlenie(i);
    NextLex();
  END;
  result := true;
end;

// разбор конструкции заголовка
// возвращает TRUE если ошибок нет
function TForm1.Zagolovok(): boolean;
var
  i: integer;
  lex: string;
  // начало подпрограммы
  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
  end;
// конец подпрограммы

begin
  i := -1;
  NextLex();

  while lex <> 'var' do
  begin
    if lex = 'program' then
    begin
      NextLex();
      if lex = 'идентификатор' then
      begin
        NextLex();
        if lex = ';' then
        else
        begin
          TLogger.Log('Ожидается точка с запятой');
          result := false;
          exit
        end;
      end
      else
      begin
        TLogger.Log('Ожидается инднфикатор');
        result := false;
        exit;
      end
    end
    else
    begin
      TLogger.Log('Ожидается PROGRAM');
      result := false;
      exit
    end;
    NextLex();
  end;
  result := true;
end;

procedure TForm1.ButtonCompileClick(Sender: TObject);
begin
  IdArray := TList<TLexScaner>.Create;
  LexicalAnalyzer.Analyze(Memo1.Lines);

  SyntaxAnalyzer();

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Identifier := TList<String>.Create;
end;

procedure TForm1.SyntaxAnalyzer();
var
  result: boolean;
begin
  result := Zagolovok();
  if result = true then
    TLogger.Log('Заголовок успешно скомпилирован');
  result := SpisokObiavlenii();
  if result = true then
    TLogger.Log('Список объявлений успешно скомпилирован');

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Memo1.Clear;
  Memo2.Clear;
end;

end.
