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

// ������ ����������� ���������
// ���������� TRUE ���� ������ ���
function Zagolovok(var i: integer): boolean;
var
  lex: string;
  // ������ ������������
  procedure NextLex();
  begin
    inc(i);
    lex := SysAlfa[IdArray[i].id];
  end;
// ����� ������������

begin
  // i := -1;
  // NextLex();
  lex := SysAlfa[IdArray[i].id];

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
  result := true;
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
      begin
        TLogger.Log('��������� ������ ������������');
        result := false;
      end
    end
    else
    begin
      TLogger.Log('����������� �������������: ' + ident);
      result := false;
      exit;
    end;
    // NextLex();  ///////////////////////

  end
  else
  begin
    TLogger.Log('��������� �������������');
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
        // ToDo:����������� �������� ����
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
        // ToDo:����������� �������� �����
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
        // ToDo:����������� �������� ������
        if OpVivod(i) then
          result := true

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
        TLogger.Log('����������� �������������: ' + ident);
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

    // ������ ��� ��� ��� ���� ����������. ������ �������� ������������ �������
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
          result := false;
          exit;
        end;
      end
      else
      begin
        TLogger.Log('��������� ������ ������������');
        result := false;
        exit;
      end;
    end
    else
    begin
      TLogger.Log('����������� �������������: ' + ident);
      result := false;
      exit;
    end;
  end
  else
  begin
    TLogger.Log('��������� �������������');
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
      TLogger.Log('��������� end')
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
        TLogger.Log('��������� do');
        result := false;
        exit;
      end;
    end
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
            TLogger.Log('����������� �������������: ' + ident)
        else
          TLogger.Log('��������� �������������');
      end;
    end
    else
      TLogger.Log('����������� �������������: ' + ident);
  end
  else
    TLogger.Log('��������� �������������');
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
        TLogger.Log('��������� ������ ������');
    end
    else
      TLogger.Log('��������� ����� ������');
  end
  else
    TLogger.Log('��������� read');
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
                TLogger.Log('������� �������������');
                exit
              end
              else
                TLogger.Log('��������� .')
            end

            else
              TLogger.Log('��������� end')
          end;
        end
        else
          TLogger.Log('��������� begin');
      end;
    end;
  end;

end;

end.
