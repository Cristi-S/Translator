unit SyntacticalAnalyzer;

interface

uses Logger;

procedure Analyze();
procedure Viragenie(var i: integer);

implementation

uses
  Unit1;

// разбор конструкции заголовка
// возвращает TRUE если ошибок нет
function Zagolovok(): boolean;
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

function Obiavlenie(var index: integer): boolean;
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
    if Unit1.SearchIdentifier(ident) then
    begin
      TLogger.Log('Такой индефикатор уже существует');
      result := false;
    end
    else
      Unit1.AddIdentifier(ident);

    NextLex();
    while lex = ',' do
    begin
      NextLex();
      if SearchIdentifier(ident) then
      begin
        TLogger.Log('Такой индефикатор уже существует');
        result := false;
      end
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
        result := true;
        exit
      end
      else
      begin
        TLogger.Log('Ожидается integer');
        result := false;
      end
    end
    else
    begin
      TLogger.Log('Ожидается двоеточие');
      result := false;
    end
  end
  else
  begin
    TLogger.Log('Ожидается идентификор');
    result := false;
  end;
  index := i;
end;

function OpPrisv(var i: integer): boolean;
var
  lex, ident: string;

  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
    ident := IdArray[i].name;
  end;

begin
  lex := SysAlfa[IdArray[i].id];
  ident := IdArray[i].name;

  if lex = 'идентификатор' then
  begin
    if Unit1.SearchIdentifier(ident) then
    begin
      NextLex();
      if lex = '=' then
      begin
        NextLex();
        Viragenie(i);
      end
      else
        TLogger.Log('нужно=');
    end
    else
    begin
      TLogger.Log('Объяви');
      result := false;
      exit;
    end;
//    NextLex();  ///////////////////////

  end
  else
    TLogger.Log('ожидается идентификатор');
end;

function Operators(var i: integer): boolean;
var
  id: integer;
  lex, ident: string;

  procedure NextLex();
  begin
    inc(i);
    id := IdArray[i].id;
    lex := SysAlfa[IdArray[i].id];
    ident := IdArray[i].name;
  end;

begin
  id := IdArray[i].id;
  lex := SysAlfa[IdArray[i].id];
  ident := IdArray[i].name;
//  lex := ident;

  case id of
    12:
      begin

        OpPrisv(i);
      end;
    9:
      begin
        // ToDo:реализовать оператор цикла
      end;
    7:
      begin
        // ToDo:реализовать оператор ввода
      end;
    8:
      begin
        // ToDo:реализовать оператор вывода
      end;
  else
    begin
      TLogger.Log('Неизвестный оператор');
      exit;
    end;
  end;
end;

function Mnogitel(var i: integer): boolean;
var
  lex, ident: string;

  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
    ident := IdArray[i].name;
  end;

begin
  lex := SysAlfa[IdArray[i].id];
  ident := IdArray[i].name;

  if lex = 'идентификатор' then
  begin
    begin
      if Unit1.SearchIdentifier(ident) then
        exit
      else
        TLogger.Log('неизвестный идентификатор');
    end;
  end
  else if lex = 'число' then
    exit;
  if lex = '(' then
  begin
    Viragenie(i);
    if lex = ')' then
      exit
    else
      TLogger.Log('ожидается )')
  end
  else
    TLogger.Log('ожидается (');
end;

function Slagaemoe(var i: integer): boolean;
var
  lex, nLex: string;

  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
    nLex := SysAlfa[IdArray[i + 1].id];
  end;

begin
  result := false;
  lex := SysAlfa[IdArray[i].id];
  nLex := SysAlfa[IdArray[i + 1].id];

  Mnogitel(i);
  NextLex();
  while ((lex = '*') or (lex = 'div')) do
  BEGIN
    NextLex();
    Mnogitel(i);
    NextLex();
  END;
  result := true;
end;

procedure Viragenie(var i: integer);
var
  lex, nLex: string;

  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
    nLex := SysAlfa[IdArray[i + 1].id];
  end;

begin
  //NextLex();
  lex := SysAlfa[IdArray[i].id];
  nLex := SysAlfa[IdArray[i + 1].id];
  // i := SearchLexInIdArray('begin');
  Slagaemoe(i);
  NextLex();
  while ((lex = '+') or (lex = '-')) do
  BEGIN
    Slagaemoe(i);
    NextLex();
  END;

end;

function SpisokObiavlenii(): boolean;
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

procedure SpisokOperatorov(var i: integer);
var
  lex, nLex: string;

  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
    nLex := SysAlfa[IdArray[i+1].id];
  end;

begin
  // i := SearchLexInIdArray('begin');
  NextLex();

  Operators(i);
//  NextLex();
  lex := SysAlfa[IdArray[i].id];
  nLex := SysAlfa[IdArray[i+1].id];

  while (lex = ';') and (nLex <> 'end') do
  BEGIN
    NextLex();
    Operators(i);
    NextLex();
  END;
end;

procedure Analyze();
var
  i: integer;
  lex, nLex: string;
  result: boolean;

  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
    // nLex := SysAlfa[IdArray[i].id];
  end;

begin
  result := Zagolovok();
  if result = true then
    TLogger.Log('Заголовок успешно скомпилирован');
  result := SpisokObiavlenii();
  if result = true then
    TLogger.Log('Список объявлений успешно скомпилирован');

  i := SearchLexInIdArray('begin');
  lex := SysAlfa[IdArray[i].id];
  if lex = 'begin' then
  begin
    SpisokOperatorov(i);
    // NextLex();
    lex := SysAlfa[IdArray[i].id];
    if lex = 'end' then
    begin
      NextLex();
      if lex = '.' then
      begin
        TLogger.Log('Успешно скомпилирован');
        exit
      end
      else
        TLogger.Log('ожидается .')
    end

    else
      TLogger.Log('ожидается end')
  end
  else
    TLogger.Log('ожидается begin');
end;

end.
