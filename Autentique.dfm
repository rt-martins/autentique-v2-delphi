object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 190
  ClientWidth = 543
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 133
    Top = 169
    Width = 38
    Height = 13
    Caption = 'Status: '
  end
  object Label2: TLabel
    Left = 177
    Top = 169
    Width = 65
    Height = 13
    Caption = 'StatusCode'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 128
    Top = 8
    Width = 43
    Height = 13
    Caption = 'Retorno:'
  end
  object BtEnviarArquivo: TButton
    Left = 8
    Top = 48
    Width = 97
    Height = 25
    Caption = 'Criar Documento'
    TabOrder = 0
    OnClick = BtEnviarArquivoClick
  end
  object BtCriarPasta: TButton
    Left = 8
    Top = 87
    Width = 97
    Height = 25
    Caption = 'Criar Pasta'
    TabOrder = 1
    OnClick = BtCriarPastaClick
  end
  object Button1: TButton
    Left = 8
    Top = 126
    Width = 97
    Height = 25
    Caption = 'Mover para pasta'
    TabOrder = 2
    OnClick = Button1Click
  end
  object MemoRetorno: TMemo
    Left = 128
    Top = 27
    Width = 399
    Height = 137
    TabOrder = 3
  end
end
