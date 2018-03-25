object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 581
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 633
    Height = 234
    Align = alTop
    TabOrder = 0
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 631
      Height = 232
      Align = alClient
      Lines.Strings = (
        'program test;'
        'var x,y,z, i:integer;'
        'k,a:integer;'
        'begin'
        'z=(100*x+2)*3;'
        'a = a + z;'
        'for i = 1 to 10 do'
        '  begin'
        '    x = x + 1;'
        '    y = k*x+z;'
        '  end;'
        'read(x, z);'
        'write(a);'
        'end.')
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 234
    Width = 633
    Height = 62
    Align = alClient
    TabOrder = 1
    object Button2: TButton
      Left = 136
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Clear'
      TabOrder = 0
      OnClick = Button2Click
    end
    object ButtonCompile: TButton
      Left = 40
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Compile'
      TabOrder = 1
      OnClick = ButtonCompileClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 296
    Width = 633
    Height = 285
    Align = alBottom
    TabOrder = 2
    object Memo2: TMemo
      Left = 1
      Top = 1
      Width = 631
      Height = 283
      Align = alClient
      TabOrder = 0
    end
  end
end
