unit LexicalAnalyzer;

interface

uses
  classes, Logger, System.SysUtils, System.Generics.Collections;

procedure Analyze(Strings: TStrings);

implementation

uses
  Unit1;

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

// ��������� �������� �� ����� ������
function IsNumber(Str: string): boolean;
var
  i: integer;
begin
  result := true;

  for i := 1 to Str.Length do
    if not(Str[i] in ['0' .. '9']) then
      result := false;
end;

// ����� ����� � ������� ��������� ����
// name - �������� ��������������
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
      // ��������� ����� �� ���
      if Str[1] in ['0' .. '9'] then
      begin
        if IsNumber(Str) then
        begin
          result := 13;
          exit;
        end
        // ���� ��� �� ����� � ������ ������ ����� - ������
        else
        begin
          result := 90;
        end;
      end
      else
      // ���� ��� ��������������, � �� �����
      begin
        result := 12;
      end;
    end;
end;

// ��������� ��������� ������� � ����� ���������� ��������
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

// ��������� ������ �� �����
function Parser(Str: string): TStringList;
var
  s1: TStringList;
begin
  s1 := TStringList.Create;
  ExtractStrings([' '], [' '], PChar(Str), s1);

  result := s1;
end;

procedure Analyze(Strings: TStrings);
var
  line, Str: string;
  s: TStringList;
  i, j: integer;
  word: string;
  id: integer;
  value: TLexScaner;
begin
  for j := 0 to Strings.Count - 1 do
  begin
    line := Strings[j];

    if not IsSymbolInAlha(line) then
    begin
      Strings.Add('Error: ����������� ������');
    end;

    Str := '';
    line := AddSpace(line);
    s := Parser(line);
    for i := 0 to s.Count - 1 do
    begin
      word := s[i];
      id := SearchKeyWord(word);
      value.id := id;
      if id = 12 then
        value.name := word;
      if id = 13 then
        value.number := id;
      Unit1.IdArray.Add(value);
    end;
  end;

end;

end.
