unit Logger;

interface

Type
  TLogger = class
    class procedure Log(text: string);
  end;

implementation

uses Unit1;

class procedure TLogger.Log(text: string);
begin
  Form1.Memo2.Lines.Add(text);
end;

end.
