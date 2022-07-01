object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'CRUD'
  ClientHeight = 317
  ClientWidth = 765
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 104
    Width = 25
    Height = 15
    Caption = 'Titulo:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 8
    Top = 159
    Width = 44
    Height = 15
    Caption = 'Descri'#231#227'o:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 56
    Width = 84
    Height = 15
    Caption = 'Nome do solicitante:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 179
    Top = 104
    Width = 24
    Height = 15
    Caption = 'Valor:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 8
    Top = 8
    Width = 32
    Height = 15
    Caption = 'C'#243'digo:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
  end
  object txtNomeS: TEdit
    Left = 8
    Top = 73
    Width = 331
    Height = 28
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnChange = txtNomeSChange
  end
  object txtTitulo: TEdit
    Left = 8
    Top = 125
    Width = 165
    Height = 28
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnChange = txtTituloChange
  end
  object txtDescricao: TMemo
    Left = 8
    Top = 180
    Width = 331
    Height = 98
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnChange = txtDescricaoChange
  end
  object btnIncluir: TButton
    Left = 8
    Top = 284
    Width = 109
    Height = 25
    Caption = 'Incluir'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = btnIncluirClick
  end
  object tbAnuncio: TDBGrid
    Left = 345
    Top = 29
    Width = 413
    Height = 249
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 11
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnCellClick = tbAnuncioCellClick
  end
  object numValor: TNumberBox
    Left = 179
    Top = 125
    Width = 160
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnChangeValue = numValorChangeValue
  end
  object txtCodigo: TEdit
    Left = 8
    Top = 29
    Width = 129
    Height = 28
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial Narrow'
    Font.Style = []
    NumbersOnly = True
    ParentFont = False
    TabOrder = 0
    OnChange = txtCodigoChange
  end
  object btnAlterar: TButton
    Left = 123
    Top = 284
    Width = 103
    Height = 25
    Caption = 'Alterar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = btnAlterarClick
  end
  object btnExcluir: TButton
    Left = 232
    Top = 284
    Width = 107
    Height = 25
    Caption = 'Excluir'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    OnClick = btnExcluirClick
  end
  object btnBuscar: TButton
    Left = 143
    Top = 29
    Width = 105
    Height = 29
    Caption = 'Buscar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnBuscarClick
  end
  object btnTodos: TButton
    Left = 254
    Top = 29
    Width = 85
    Height = 29
    Caption = 'Ver todos'
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    Visible = False
    OnClick = btnTodosClick
  end
  object btnLimpar: TButton
    Left = 345
    Top = 284
    Width = 104
    Height = 25
    Caption = 'Limpar campos'
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
    Visible = False
    OnClick = btnLimparClick
  end
  object Query: TFDQuery
    Connection = conexao
    Left = 16
    Top = 320
  end
  object MySQLDriver: TFDPhysMySQLDriverLink
    Left = 80
    Top = 320
  end
  object conexao: TFDConnection
    Params.Strings = (
      'Port=3310'
      'Server=localhost'
      'User_Name=root'
      'Database=crud'
      'DriverID=MySQL')
    Left = 48
    Top = 320
  end
  object DataSource1: TDataSource
    DataSet = Query
    Left = 112
    Top = 320
  end
end
