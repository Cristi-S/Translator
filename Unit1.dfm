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
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 633
    Height = 193
    Align = alTop
    TabOrder = 0
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 631
      Height = 191
      Align = alClient
      Lines.Strings = (
        'program test;'
        'var x,z:integer;'
        'k,a:integer;'
        'begin'
        'z=100*x;'
        'end.')
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 193
    Width = 633
    Height = 63
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
    Top = 256
    Width = 633
    Height = 325
    Align = alBottom
    TabOrder = 2
    object Memo2: TMemo
      Left = 1
      Top = 1
      Width = 631
      Height = 323
      Align = alClient
      TabOrder = 0
    end
  end
end
