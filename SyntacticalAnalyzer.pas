unit SyntacticalAnalyzer;

interface

uses Logger;

procedure Analyze();
procedure Viragenie(var i: integer);
function OpCycle(var i: integer): boolean;
function OpVvod(var i: integer): boolean;
function OpVivod(var i: integer): boolean;

implementation

uses
  Unit1;

// разбор конструкции заголовка
// возвращает TRUE если ошибок нет
function Zagolovok(var i: integer): boolean;
var
  lex: string;
  // начало подпрограммы
  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
  end;
// конец подпрограммы

begin
  // i := -1;
  // NextLex();
  lex := SysAlfa[IdArray[i].id];

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
  result := true;
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
      begin
        TLogger.Log('Ожидается символ присваивания');
        result := false;
      end
    end
    else
    begin
      TLogger.Log('Неизвестный идентификатор: ' + ident);
      result := false;
      exit;
    end;
    // NextLex();  ///////////////////////

  end
  else
  begin
    TLogger.Log('ожидается идентификатор');
    result := false;
  end;
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
  result := false;
  id := IdArray[i].id;
  lex := SysAlfa[IdArray[i].id];
  ident := IdArray[i].name;
  // lex := ident;

  case id of
    12:
      begin
        if OpPrisv(i) then
          result := true
        else
        begin
          lex := SysAlfa[IdArray[i].id];
          lex := SysAlfa[IdArray[i].id + 1];
          result := false;
        end
      end;
    9:
      begin
        // ToDo:реализовать оператор цикл
        if OpCycle(i) then
          result := true
        else
        begin
          lex := SysAlfa[IdArray[i].id];
          lex := SysAlfa[IdArray[i + 1].id];
          lex := SysAlfa[IdArray[i + 2].id];
          ident := IdArray[i].name;
          result := false;
        end
      end;
    7:
      begin
        // ToDo:реализовать оператор ввода
        if OpVvod(i) then
          result := true
        else
        begin
          lex := SysAlfa[IdArray[i].id];
          result := false;
        end
      end;
    8:
      begin
        // ToDo:реализовать оператор вывода
        if OpVivod(i) then
          result := true

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
        TLogger.Log('Неизвестный идентификатор: ' + ident);
    end;
  end
  else if lex = 'число' then
    exit;
  if lex = '(' then
  begin
    NextLex();
    Viragenie(i);

    lex := SysAlfa[IdArray[i].id];
    ident := IdArray[i].name;

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
  // NextLex();
  lex := SysAlfa[IdArray[i].id];
  nLex := SysAlfa[IdArray[i + 1].id];
  // i := SearchLexInIdArray('begin');
  Slagaemoe(i);
  // NextLex();
  // возможно здесь лишний пеерход к след элементу, т.к. слагаемое самое прееходит к след элементу
  lex := SysAlfa[IdArray[i].id];
  nLex := SysAlfa[IdArray[i + 1].id];

  while ((lex = '+') or (lex = '-')) do
  BEGIN
    NextLex();
    Slagaemoe(i);

    lex := SysAlfa[IdArray[i].id];
    nLex := SysAlfa[IdArray[i + 1].id];
    // NextLex();
  END;

end;

function SpisokObiavlenii(var i: integer): boolean;
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
  i := i - 1;
  NextLex;

  Obiavlenie(i);
  NextLex();
  while ((nLex <> 'begin') and (lex = ';')) do
  BEGIN
    Obiavlenie(i);
    NextLex();
  END;
  result := true;
end;

function SpisokOperatorov(var i: integer): boolean;
var
  lex, nLex: string;

  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
    nLex := SysAlfa[IdArray[i + 1].id];
  end;

begin
  result := true;
  // i := SearchLexInIdArray('begin');
  NextLex();

  if not Operators(i) then
  begin
    result := false;
    exit;
  end;
  // NextLex();
  lex := SysAlfa[IdArray[i].id];
  nLex := SysAlfa[IdArray[i + 1].id];

  while (lex = ';') and (nLex <> 'end') do
  BEGIN
    NextLex();
    if not Operators(i) then
    begin
      result := false;
      exit;
    end;

    lex := SysAlfa[IdArray[i].id];
    nLex := SysAlfa[IdArray[i + 1].id];

    // усбрал вот это для двух операторов. второй оператор присваивание обычное
    // NextLex();
  END;
end;

function IndVirag(var i: integer): boolean;
var
  lex, nLex, ident: string;
  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
    ident := IdArray[i].name;
    nLex := SysAlfa[IdArray[i + 1].id];
  end;

begin
  lex := SysAlfa[IdArray[i].id];
  ident := IdArray[i].name;
  result := true;

  if lex = 'идентификатор' then
  begin
    if Unit1.SearchIdentifier(ident) then
    begin
      NextLex();
      if lex = '=' then
      begin
        NextLex();
        Viragenie(i);
        // здесь скорее всего нужно перейти к след элепемнту но это не точно
        lex := SysAlfa[IdArray[i].id];

        if lex = 'to' then
        begin
          NextLex();
          Viragenie(i);
        end
        else
        begin
          TLogger.Log('ожидается to');
          result := false;
          exit;
        end;
      end
      else
      begin
        TLogger.Log('ожидается символ присваивания');
        result := false;
        exit;
      end;
    end
    else
    begin
      TLogger.Log('Неизвестный идентификатор: ' + ident);
      result := false;
      exit;
    end;
  end
  else
  begin
    TLogger.Log('ожидается идентификатор');
    result := false;
  end
end;

function TeloCycle(var i: integer): boolean;
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

  if lex = 'begin' then
  begin
    result := SpisokOperatorov(i);
    NextLex();
    if lex = 'end' then
    begin
      NextLex();
      result := true;
      exit;
    end
    else
      TLogger.Log('ожидается end')
  end
  else
    result := Operators(i);
end;

function OpCycle(var i: integer): boolean;
var
  lex, nLex: string;
  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
    nLex := SysAlfa[IdArray[i + 1].id];
  end;

begin
  lex := SysAlfa[IdArray[i].id];
  if lex = 'for' then
  begin
    NextLex();
    if IndVirag(i) then
    begin
      lex := SysAlfa[IdArray[i].id];
      nLex := SysAlfa[IdArray[i + 1].id];

      if lex = 'do' then
      begin
        NextLex();
        result := TeloCycle(i);
      end
      else
      begin
        TLogger.Log('ожидается do');
        result := false;
        exit;
      end;
    end
  end
  else
  begin
    TLogger.Log('ожидается for');
    exit;
  end;
end;

procedure SpisIdentif(var i: integer);
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
      while (lex = ',') do
      begin
        NextLex();
        if (lex = 'идентификатор') then
          if Unit1.SearchIdentifier(ident) then
          begin
            NextLex();
            Continue;
          end
          else
            TLogger.Log('Неизвестный идентификатор: ' + ident)
        else
          TLogger.Log('Ожидается идентификатор');
      end;
    end
    else
      TLogger.Log('Неизвестный идентификатор: ' + ident);
  end
  else
    TLogger.Log('Ожидается идентификатор');
end;

function OpVvod(var i: integer): boolean;
var
  lex, ident: string;
  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
    ident := IdArray[i].name;
  end;

begin
  result := false;
  lex := SysAlfa[IdArray[i].id];
  ident := IdArray[i].name;

  if lex = 'read' then
  begin
    NextLex();
    if lex = '(' then
    begin
      NextLex();
      SpisIdentif(i);
      lex := SysAlfa[IdArray[i].id];
      if (lex = ')') then
      begin
        NextLex();
        result := true;
        exit;
      end
      else
        TLogger.Log('Ожидается правая скобка');
    end
    else
      TLogger.Log('Ожидается левая скобка');
  end
  else
    TLogger.Log('Ожидается read');
end;

function OpVivod(var i: integer): boolean;
var
  lex, ident: string;
  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
    ident := IdArray[i].name;
  end;

begin
  result := false;
  lex := SysAlfa[IdArray[i].id];
  ident := IdArray[i].name;

  if lex = 'write' then
  begin
    NextLex();
    if lex = '(' then
    begin
      NextLex();
      SpisIdentif(i);
      lex := SysAlfa[IdArray[i].id];
      if (lex = ')') then
      begin
        NextLex();
        result := true;
        exit;
      end
      else
        TLogger.Log('Ожидается правая скобка');
    end
    else
      TLogger.Log('Ожидается левая скобка');
  end
  else
    TLogger.Log('Ожидается write');
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
  i := -1;
  NextLex;

  if Zagolovok(i) then
  begin
    NextLex;
    if lex = 'var' then
    begin
      if SpisokObiavlenii(i) then
      begin
        NextLex;
        if lex = 'begin' then
        begin
          if SpisokOperatorov(i) then
          begin
            NextLex();
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
          end;
        end
        else
          TLogger.Log('ожидается begin');
      end;
    end;
  end;

end;

end.
