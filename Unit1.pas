unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
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
    procedure Zagolovok();
    procedure SpisokObiavleii();
    procedure Obiavleie(index: integer);
    procedure SyntaxAnalyzer();
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

const SysAlfaCount=23;
        NumbersCount=10;
        AlfaCount=26;
        KolInd=10;

var
  Form1: TForm1;
  SysAlfa: array[1..SysAlfaCount] of string = ('program','var','begin','end','integer','div','read','write','for','do','to','идентификатор','число',';',':',',','=','.','+','-','*','(',')');
  Numbers: array[1..NumbersCount] of string = ('1','2','3','4','5','6','7','8','9','0');
  Ind: array [1..KolInd] of string;
  IdArray: array[1..200] of TLexScaner;


  //Alfa: array[1..AlfaCount] of string = ('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z');


implementation

{$R *.dfm}
//проверяет вхождение символа в набор допустимых символов
function IsSymbolInAlha(Str:string):Boolean;
var
  i: Integer;
begin
  result:=true;
  for i := 1 to Str.Length do
      if not(Str[i] in ['a'..'z', '0'..'9', ';',':',',','=','.','+','-','*','(',')',' ']) then
       result:=false;
end;

//проверяет является ли слово числом
function IsNumber(str:string):Boolean;
var
  i: Integer;
begin
  Result:=True;

  for i := 1 to str.Length do
    if not (str[i] in ['0'..'9']) then
      Result:=false;
end;

//разбивает строку на слова
function Parser(str:string):TStringList;
var
  s1:TStringList;
begin
  s1 := TStringList.Create;
  ExtractStrings([' '], [' '],  PChar(str), s1);

  Result:=s1;
end;

//поиск имени в таблице служебных слов
//name - название идентефикатора
function SearchKeyWord(str:string):integer;
var
  i: Integer;
begin
   for i := 1 to SysAlfaCount do
      if str=SysAlfa[i] then
       begin
         result:=i;
         exit
       end
      else
        begin
          //проверяем число ли это
          if str[1] in ['0'..'9'] then
            begin
              if IsNumber(str) then
              begin
                Result:=13;
                exit;
              end
              //если это не число и первый символ цифра - ошибка
              else
              begin
                 Result:=90;
              end;
            end
            else
            //если это иденетефикатор, а не число
            begin
              Result:=12;
            end;
        end;
end;

function SearchLexInIdArray(aLex:string):integer;
  var i: integer;
  begin
    for I := 0 to Length(IdArray) do
      begin
        if SysAlfa[IdArray[i].id] = aLex then
        begin
          result:= i;
          break;
        end;
      end;
  end;

function AddSpace(str:string):string;
begin
  str:= str.Replace(':', ' : ');
  str:= str.Replace(';', ' ; ');
  str:= str.Replace('(', ' ( ');
  str:= str.Replace(')', ' ) ');
  str:= str.Replace('+', ' + ');
  str:= str.Replace('-', ' - ');
  str:= str.Replace('*', ' * ');
  str:= str.Replace(',', ' , ');
  str:= str.Replace('.', ' . ');
  str:= str.Replace('=', ' = ');
  Result:=str;
end;

procedure TForm1.Obiavleie(index: integer);
var i,j,indexT:integer;
    Result:Boolean;
begin
indexT:=SearchLexInIdArray
//  for i := index to indexT do
//      if lex=SysAlfa[i] then
//        begin
//         if i=12 then
//             begin
//                 Result := false;
//                 for j := 0 to KolInd do
//                       if Ind[j] = lex then
//                         begin
//                            Result := true;
//                               begin
//                                   if Result = true then
//                                   Memo2.Lines.Add('Такой индефикатор уже существует')
//                                   else  Ind[j]:=lex;
//                               end;
//                         end;
//             end;
//          while i=16 do
//           begin
//                 Result := false;
//                 for j := 0 to KolInd do
//                       if Ind[j] = lex then
//                         begin
//                            Result := true;
//                               begin
//                                   if Result = true then
//                                   Memo2.Lines.Add('Такой индефикатор уже существует')
//                                   else  Ind[j]:=lex;
//                               end;
//                         end;
//           end;
//        end
//      else  Memo2.Lines.Add('Ожидается инднфикатор');
//   if i=15 then
//       if i=5 then  exit
//          else  Memo2.Lines.Add('Ожидается integer')
//     else Memo2.Lines.Add('Ожидается двоеточие');

 end;

procedure TForm1.SpisokObiavleii();
var i:integer;
    lex: string;

  procedure NextLex();
  begin
    inc(i);
    lex:= SysAlfa[IdArray[i].id];
  end;

begin
  i:=-1;
  NextLex();

  i:=SearchLexInIdArray('var');

  Obiavleie(i+1);
  while lex=';' do
     Obiavleie(i);
end;


procedure TForm1.Zagolovok();
var i:integer;
    lex: string;

procedure NextLex();
begin
  inc(i);
  lex:= SysAlfa[IdArray[i].id];
end;

begin
  i:=-1;
  NextLex();

  while lex<>'var' do
  begin
    if lex='program' then
    begin
     NextLex();
        if lex='идентификатор' then
          begin
             NextLex();
             if lex=';' then
             else
             begin
              Memo2.Lines.Add('Ожидается точка с запятой');
              exit
             end;
          end
        else
          begin
            Memo2.Lines.Add('Ожидается инднфикатор');
            exit;
          end
    end
    else
      begin
        Memo2.Lines.Add('Ожидается PROGRAM');
        exit
      end;
    NextLex();
  end;
end;

procedure TForm1.ButtonCompileClick(Sender: TObject);
var
  line, str:string;
  s:TStringList;
  i, j:integer;
  word:string;
  id:integer;
  ok:Boolean;
  index: integer;
begin
  index:= 0;
  for j := 0 to Memo1.Lines.Count - 1 do
  begin
    line:=Memo1.Lines[j];

    if not IsSymbolInAlha(line) then begin
      Memo2.Lines.add ('Error: Неизвестный символ');
    end;

    str:='';
    line:= AddSpace(line);
    s:=Parser(line);
    for i:= 0 to s.Count-1 do
      begin
        word:= s[i];
        id:= SearchKeyWord(word);
        IdArray[index].id:= id;
        if id=12 then IdArray[index].name:= word;
        if id=13 then IdArray[index].number:= id;
        inc(index);
      end;
  end;

  SyntaxAnalyzer();


   {     str:=str+' '+ IntToStr(id);


        case id of
          90: Memo2.Lines.add (word+' // ''Error: ошибка, иденетфикатор начинается с числа...(-_-)')
        end;
      end;
    Memo2.Lines.Add(str);
//        if (id=12) or (id=13)  then
//          Memo2.Lines.Add(word+' // '+IntToStr(id)+' '+s[i]);
//        if id=90 then
//          Memo2.Lines.Add('Error: ошибка, иденетфикатор начинается с числа...')
//          else Memo2.Lines.Add(word+' // '+IntToStr(id));
//        else  Memo2.Lines.Add(word+' // '+IntToStr(id));
//        if id=90  then
//         Memo2.Lines.Add('Error: ошибка, иденетфикатор начинается с числа...');
//
//      end;   }

//  end;


end;

procedure TForm1.SyntaxAnalyzer();
var
  I: Integer;
  lex: string;
begin
//  for I := 0 to Length(IdArray) do
//  begin
//    lex:= SysAlfa[IdArray[i].id];
//  end;
  Zagolovok();

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Memo1.Clear;
  Memo2.Clear;
end;

end.
