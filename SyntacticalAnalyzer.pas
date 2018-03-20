unit SyntacticalAnalyzer;

interface

uses Logger;

procedure Analyze();

implementation

uses
  Unit1;

// ������ ����������� ���������
// ���������� TRUE ���� ������ ���
function Zagolovok(): boolean;
var
  i: integer;
  lex: string;
  // ������ ������������
  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
  end;
// ����� ������������

begin
  i := -1;
  NextLex();

  while lex <> 'var' do
  begin
    if lex = 'program' then
    begin
      NextLex();
      if lex = '�������������' then
      begin
        NextLex();
        if lex = ';' then
        else
        begin
          TLogger.Log('��������� ����� � �������');
          result := false;
          exit
        end;
      end
      else
      begin
        TLogger.Log('��������� �����������');
        result := false;
        exit;
      end
    end
    else
    begin
      TLogger.Log('��������� PROGRAM');
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

  if lex = '�������������' then
  begin
    if Unit1.SearchIdentifier(ident) then
    begin
      TLogger.Log('����� ����������� ��� ����������');
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
        TLogger.Log('����� ����������� ��� ����������');
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
        TLogger.Log('��������� integer');
        result := false;
      end
    end
    else
    begin
      TLogger.Log('��������� ���������');
      result := false;
    end
  end
  else
  begin
    TLogger.Log('��������� �����������');
    result := false;
  end;
  index := i;
end;

function Operators(index: integer): boolean;
var
  i, id: integer;
  lex, ident: string;

  procedure NextLex();
  begin
    inc(i);
    id:= IdArray[i].id;
    lex := SysAlfa[IdArray[i].id];
    ident := IdArray[i].name;
  end;

begin
  i := index;
  NextLex();
  lex:= ident;

  case id of
    12:
      begin
        // ToDo:����������� �������� ������������
      end;
    9:
      begin
        // ToDo:����������� �������� �����
      end;
    7:
      begin
        // ToDo:����������� �������� �����
      end;
    8:
      begin
        // ToDo:����������� �������� ������
      end;
  else
    begin
      TLogger.Log('����������� ��������');
      exit;
    end;
  end;
end;

function OpPrisv(index: integer): boolean;
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

  if lex = '�������������' then
  begin
    if Unit1.SearchIdentifier(ident) then
    begin
      NextLex();
      if lex = '=' then
      begin
        // ToDo:����������� ���������
      end
      else
        TLogger.Log('�����=');
    end
    else
    begin
      TLogger.Log('������');
      result := false;
      exit;
    end;
    NextLex();

  end
  else
    TLogger.Log('��������� �������������');
end;

function Mnogitel(index: integer): boolean;
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

  if lex = '�������������' then
  begin
    begin
      if Unit1.SearchIdentifier(ident) then
        exit
      else
        TLogger.Log('����������� �������������');
    end;
  end
  else if lex = '�����' then
    exit;
  if lex = '(' then
  begin
    // ToDo:����������� ���������
    if lex = ')' then
      exit
    else
      TLogger.Log('��������� )')
  end
  else
    TLogger.Log('��������� (');
end;

function Slagaemoe(index:integer): boolean;
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
  i := index;
  NextLex();

  i := SearchLexInIdArray('begin');

  Mnogitel(i);
  NextLex();
  while ((nLex = '*') or (lex = 'div')) do
  BEGIN
    Mnogitel(i);
    NextLex();
  END;
  result := true;
end;

function Viragenie(): boolean;
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

  i := SearchLexInIdArray('begin');
  Slagaemoe(i);
  NextLex();
  while ((nLex = '+') or (lex = '-')) do
  BEGIN
    Slagaemoe(i);
    NextLex();
  END;
  result := true;
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

function SpisokOperatorov: boolean;
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

  i := SearchLexInIdArray('begin');

  Operators(i);
  NextLex();
  while (nLex <> '.') do
  BEGIN
    Operators(i);
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
    TLogger.Log('��������� ������� �������������');
  result := SpisokObiavlenii();
  if result = true then
    TLogger.Log('������ ���������� ������� �������������');

end;

end.
