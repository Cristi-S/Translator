unit Unit1;

{$optimization off}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ButtonCompile: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Button2: TButton;
    procedure ButtonCompileClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    function Zagolovok(): boolean;
    function SpisokObiavlenii():boolean;
    procedure Obiavlenie(var index: integer);
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
  Identifier: TList<String>;
  IdArray: array [1 .. 200] of TLexScaner;
  // массив скомпилированных идентефикаторов


  // Alfa: array[1..AlfaCount] of string = ('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z');

implementation

{$R *.dfm}

// проверяет вхождение символа в набор допустимых символов
function IsSymbolInAlha(Str: string): boolean;
var
  i: integer;
begin
  result := true;
  for i := 1 to Str.Length do
    if not(Str[i] in ['a' .. 'z', '0' .. '9', ';', ':', ',', '=', '.', '+', '-',
      '*', '(', ')', ' ']) then
      result := false;
end;

// проверяет является ли слово числом
function IsNumber(Str: string): boolean;
var
  i: integer;
begin
  result := true;

  for i := 1 to Str.Length do
    if not(Str[i] in ['0' .. '9']) then
      result := false;
end;

// разбивает строку на слова
function Parser(Str: string): TStringList;
var
  s1: TStringList;
begin
  s1 := TStringList.Create;
  ExtractStrings([' '], [' '], PChar(Str), s1);

  result := s1;
end;

// поиск имени в таблице служебных слов
// name - название идентефикатора
function SearchKeyWord(Str: string): integer;
var
  i: integer;
begin
  for i := 1 to SysAlfaCount do
    if Str = SysAlfa[i] then
    begin
      result := i;
      exit
    end
    else
    begin
      // проверяем число ли это
      if Str[1] in ['0' .. '9'] then
      begin
        if IsNumber(Str) then
        begin
          result := 13;
          exit;
        end
        // если это не число и первый символ цифра - ошибка
        else
        begin
          result := 90;
        end;
      end
      else
      // если это иденетефикатор, а не число
      begin
        result := 12;
      end;
    end;
end;

function SearchLexInIdArray(aLex: string): integer;
var
  i: integer;
begin
  for i := 0 to Length(IdArray) do
  begin
    if SysAlfa[IdArray[i].id] = aLex then
    begin
      result := i;
      break;
    end;
  end;
end;

function AddSpace(Str: string): string;
begin
  Str := Str.Replace(':', ' : ');
  Str := Str.Replace(';', ' ; ');
  Str := Str.Replace('(', ' ( ');
  Str := Str.Replace(')', ' ) ');
  Str := Str.Replace('+', ' + ');
  Str := Str.Replace('-', ' - ');
  Str := Str.Replace('*', ' * ');
  Str := Str.Replace(',', ' , ');
  Str := Str.Replace('.', ' . ');
  Str := Str.Replace('=', ' = ');
  result := Str;
end;

function SearchIdentifier(lex: string): boolean;
begin
  Result:= Identifier.Contains(lex);
end;

procedure AddIdentifier(lex: string);
var
  i: integer;
begin
  Identifier.Add(lex);
end;

procedure TForm1.Obiavlenie(var index: integer);
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
  i:=index;
  NextLex();

  if lex = 'идентификатор' then
  begin
    if SearchIdentifier(ident) then
      Memo2.Lines.Add('Такой индефикатор уже существует')
    else
      AddIdentifier(ident);

    NextLex();
    while lex = ',' do
    begin
      NextLex();
      if SearchIdentifier(ident) then
        Memo2.Lines.Add('Такой индефикатор уже существует')
      else
        AddIdentifier(ident);
      NextLex();
    end;

    if (lex = ':') then
    begin
      NextLex();
      if (lex = 'integer') then
        begin
          index:=i;
          exit
        end
      else
        Memo2.Lines.Add('Ожидается integer');
    end
    else
      Memo2.Lines.Add('Ожидается двоеточие');
  end
  else
    Memo2.Lines.Add('Ожидается идентефикорав');

  index:=i;
end;

function TForm1.SpisokObiavlenii():boolean;
var
  i: integer;
  lex, nLex: string;

  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
    nLex:= SysAlfa[IdArray[i+1].id];
  end;

begin
  result:= false;
  i := -1;
  NextLex();

  i := SearchLexInIdArray('var');

  Obiavlenie(i);
  NextLex();
  while ((nlex <> 'begin') and (lex = ';' )) do
    BEGIN
      Obiavlenie(i);
      NextLex();
    END;
  result:=true;
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
          Memo2.Lines.Add('Ожидается точка с запятой');
          result := false;
          exit
        end;
      end
      else
      begin
        Memo2.Lines.Add('Ожидается инднфикатор');
        result := false;
        exit;
      end
    end
    else
    begin
      Memo2.Lines.Add('Ожидается PROGRAM');
      result := false;
      exit
    end;
    NextLex();
  end;
  result := true;
end;

procedure TForm1.ButtonCompileClick(Sender: TObject);
var
  line, Str: string;
  s: TStringList;
  i, j: integer;
  word: string;
  id: integer;
  index: integer;
begin
  index := 0;
  for j := 0 to Memo1.Lines.Count - 1 do
  begin
    line := Memo1.Lines[j];

    if not IsSymbolInAlha(line) then
    begin
      Memo2.Lines.Add('Error: Неизвестный символ');
    end;

    Str := '';
    line := AddSpace(line);
    s := Parser(line);
    for i := 0 to s.Count - 1 do
    begin
      word := s[i];
      id := SearchKeyWord(word);
      IdArray[index].id := id;
      if id = 12 then
        IdArray[index].name := word;
      if id = 13 then
        IdArray[index].number := id;
      inc(index);
    end;
  end;

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
  // for I := 0 to Length(IdArray) do
  // begin
  // lex:= SysAlfa[IdArray[i].id];
  // end;
  result := Zagolovok();
  if result = true then
    Memo2.Lines.Add('Заголовок успешно скомпилирован');
  result:=SpisokObiavlenii();
  if result = true then
    Memo2.Lines.Add('Список объявлений успешно скомпилирован');

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Memo1.Clear;
  Memo2.Clear;
end;

end.
