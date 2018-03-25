unit SyntacticalAnalyzer;

interface

uses Logger;

procedure Analyze();
procedure Viragenie(var i: integer);
procedure OpCycle(var i: integer);
procedure OpVvod(var i: integer);
procedure OpVivod(var i: integer);

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

  if lex = '�������������' then
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
        TLogger.Log('�����=');
    end
    else
    begin
      TLogger.Log('������');
      result := false;
      exit;
    end;
    // NextLex();  ///////////////////////

  end
  else
    TLogger.Log('��������� �������������');
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
  // lex := ident;

  case id of
    12:
      begin

        OpPrisv(i);
      end;
    9:
      begin
        // ToDo:����������� �������� �����
        OpCycle(i);
      end;
    7:
      begin
        // ToDo:����������� �������� �����
        OpVvod(i);
      end;
    8:
      begin
        // ToDo:����������� �������� ������
        OpVivod(i);
      end;
  else
    begin
      TLogger.Log('����������� ��������');
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
    NextLex();
    Viragenie(i);

    lex := SysAlfa[IdArray[i].id];
    ident := IdArray[i].name;

    if lex = ')' then
      exit
    else
      TLogger.Log('��������� )')
  end
  else
    TLogger.Log('��������� (');
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
  // �������� ����� ������ ������� � ���� ��������, �.�. ��������� ����� ��������� � ���� ��������
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
    nLex := SysAlfa[IdArray[i + 1].id];
  end;

begin
  // i := SearchLexInIdArray('begin');
  NextLex();

  Operators(i);
  // NextLex();
  lex := SysAlfa[IdArray[i].id];
  nLex := SysAlfa[IdArray[i + 1].id];

  while (lex = ';') and (nLex <> 'end') do
  BEGIN
    NextLex();
    Operators(i);

    lex := SysAlfa[IdArray[i].id];
    nLex := SysAlfa[IdArray[i + 1].id];

    // ������ ��� ��� ��� ���� ����������. ������ �������� ������������ �������
    // NextLex();
  END;
end;

procedure IndVirag(var i: integer);
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

  if lex = '�������������' then
  begin
    if Unit1.SearchIdentifier(ident) then
    begin
      NextLex();
      if lex = '=' then
      begin
        NextLex();
        Viragenie(i);
        // ����� ������ ����� ����� ������� � ���� ��������� �� ��� �� �����
        lex := SysAlfa[IdArray[i].id];

        if lex = 'to' then
        begin
          NextLex();
          Viragenie(i);
        end
        else
        begin
          TLogger.Log('��������� to');
          exit;
        end;
      end
      else
      begin
        TLogger.Log('��������� ������ ������������');
        exit;
      end;
    end
    else
    begin
      TLogger.Log('����������� �������������');
      exit;
    end;
  end
  else
    TLogger.Log('��������� �������������');
end;

procedure TeloCycle(var i: integer);
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
  nLex := SysAlfa[IdArray[i + 1].id];

  if lex = 'begin' then
  begin
    SpisokOperatorov(i);
    NextLex();
    if lex = 'end' then
    begin
      NextLex();
      exit;
    end
    else
      TLogger.Log('��������� end')
  end
  else
    Operators(i);
end;

procedure OpCycle(var i: integer);
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
    IndVirag(i);

    lex := SysAlfa[IdArray[i].id];
    nLex := SysAlfa[IdArray[i + 1].id];

    if lex = 'do' then
    begin
      NextLex();
      TeloCycle(i);
    end
    else
    begin
      TLogger.Log('��������� do');
      exit;
    end;
  end
  else
  begin
    TLogger.Log('��������� for');
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

  if lex = '�������������' then
  begin
    if Unit1.SearchIdentifier(ident) then
    begin
      NextLex();
      while (lex = ',') do
      begin
        NextLex();
        if (lex = '�������������') then
          if Unit1.SearchIdentifier(ident) then
          begin
            NextLex();
            Continue;
          end
          else
            TLogger.Log('����������� �������������')
        else
          TLogger.Log('��������� �������������');
      end;
    end
    else
      TLogger.Log('����������� �������������');
  end
  else
    TLogger.Log('��������� �������������');
end;

procedure OpVvod(var i: integer);
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
        exit;
      end
      else
        TLogger.Log('��������� ������ ������');
    end
    else
      TLogger.Log('��������� ����� ������');
  end
  else
    TLogger.Log('��������� read');
end;

procedure OpVivod(var i: integer);
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
        exit;
      end
      else
        TLogger.Log('��������� ������ ������');
    end
    else
      TLogger.Log('��������� ����� ������');
  end
  else
    TLogger.Log('��������� write');
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
    TLogger.Log('��������� ������� �������������');
  result := SpisokObiavlenii();
  if result = true then
    TLogger.Log('������ ���������� ������� �������������');

  i := SearchLexInIdArray('begin');
  lex := SysAlfa[IdArray[i].id];
  if lex = 'begin' then
  begin
    SpisokOperatorov(i);
    NextLex();
    // ���� ��������� � ���� �������� �� �� ��������������� �� ; ������� ����� ������� � ���� �������
    // lex := SysAlfa[IdArray[i].id];
    if lex = 'end' then
    begin
      NextLex();
      if lex = '.' then
      begin
        TLogger.Log('������� �������������');
        exit
      end
      else
        TLogger.Log('��������� .')
    end

    else
      TLogger.Log('��������� end')
  end
  else
    TLogger.Log('��������� begin');
end;

end.
