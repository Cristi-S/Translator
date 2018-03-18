unit SyntacticalAnalyzer;

interface

uses Logger;

procedure Analyze();

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
        Result:=true;
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

procedure Analyze();
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

end.
