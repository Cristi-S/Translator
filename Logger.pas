unit Logger;

interface

Type
  TLogger = class
    class procedure LogMessage(text: string);
  end;

implementation

uses Unit1;

class procedure TLogger.LogMessage(text: string);
begin
  Form1.Memo2.Lines.Add(text);
end;

end.
