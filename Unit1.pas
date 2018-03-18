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
//    function Zagolovok(): boolean;
//    function SpisokObiavlenii(): boolean;
//    function Obiavlenie(var index: integer): boolean;
//    procedure SyntaxAnalyzer();
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

type
  // ќбъ€вление записи
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

  function SearchIdentifier(lex: string): boolean;
  procedure AddIdentifier(lex: string);
  function SearchLexInIdArray(aLex: string): integer;
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

procedure TForm1.ButtonCompileClick(Sender: TObject);
begin
  IdArray := TList<TLexScaner>.Create;
  LexicalAnalyzer.Analyze(Memo1.Lines);
  SyntacticalAnalyzer.Analyze();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Identifier := TList<String>.Create;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Memo1.Clear;
  Memo2.Clear;
end;

end.
