object frmBuscaCEP: TfrmBuscaCEP
  Left = 0
  Top = 0
  Caption = 'BuscaCEP'
  ClientHeight = 655
  ClientWidth = 819
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object gpConsultar: TGroupBox
    Left = 8
    Top = 8
    Width = 561
    Height = 377
    TabOrder = 0
    object lblCEP: TLabel
      Left = 16
      Top = 6
      Width = 21
      Height = 15
      Caption = 'CEP'
    end
    object lblAviso: TLabel
      Left = 103
      Top = 23
      Width = 180
      Height = 15
      Caption = 'DIGITE UM CEP PARA CONSULTAR'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCrimson
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lblLogradouro: TLabel
      Left = 16
      Top = 49
      Width = 79
      Height = 15
      Caption = 'LOGRADOURO'
    end
    object lblComplemento: TLabel
      Left = 16
      Top = 92
      Width = 87
      Height = 15
      Caption = 'COMPLEMENTO'
    end
    object lblBairro: TLabel
      Left = 16
      Top = 134
      Width = 41
      Height = 15
      Caption = 'BAIRRO'
    end
    object lblLocalidade: TLabel
      Left = 16
      Top = 173
      Width = 95
      Height = 15
      Caption = 'LOCALIDADE / UF'
    end
    object lblIBGE: TLabel
      Left = 16
      Top = 213
      Width = 24
      Height = 15
      Caption = 'IBGE'
    end
    object lblGIA: TLabel
      Left = 16
      Top = 253
      Width = 19
      Height = 15
      Caption = 'GIA'
    end
    object lblDDD: TLabel
      Left = 16
      Top = 293
      Width = 24
      Height = 15
      Caption = 'DDD'
    end
    object lblSIAFI: TLabel
      Left = 16
      Top = 330
      Width = 26
      Height = 15
      Caption = 'SIAFI'
    end
    object btnBuscarCEP: TButton
      Left = 424
      Top = 23
      Width = 105
      Height = 41
      Caption = 'Buscar CEP'
      TabOrder = 0
      OnClick = btnBuscarCEPClick
    end
    object edtCEP: TEdit
      Left = 16
      Top = 20
      Width = 65
      Height = 23
      TabOrder = 1
    end
    object edtLogradouro: TEdit
      Left = 16
      Top = 63
      Width = 353
      Height = 23
      TabOrder = 2
    end
    object edtComplemento: TEdit
      Left = 16
      Top = 105
      Width = 353
      Height = 23
      TabOrder = 3
    end
    object edtBairro: TEdit
      Left = 16
      Top = 147
      Width = 225
      Height = 23
      TabOrder = 4
    end
    object edtLocalidade: TEdit
      Left = 16
      Top = 187
      Width = 225
      Height = 23
      TabOrder = 5
    end
    object edtUF: TEdit
      Left = 247
      Top = 187
      Width = 41
      Height = 23
      TabOrder = 6
      Text = 'PR'
    end
    object edtIBGE: TEdit
      Left = 16
      Top = 226
      Width = 121
      Height = 23
      TabOrder = 7
    end
    object edtGIA: TEdit
      Left = 16
      Top = 266
      Width = 121
      Height = 23
      TabOrder = 8
    end
    object edtDDD: TEdit
      Left = 16
      Top = 306
      Width = 121
      Height = 23
      TabOrder = 9
    end
    object edtSiafi: TEdit
      Left = 16
      Top = 343
      Width = 121
      Height = 23
      TabOrder = 10
    end
    object btnVerificarCEP: TButton
      Left = 424
      Top = 96
      Width = 105
      Height = 41
      Caption = 'Verificar CEP'
      TabOrder = 11
      OnClick = btnVerificarCEPClick
    end
  end
  object gpJson: TGroupBox
    Left = 8
    Top = 376
    Width = 561
    Height = 271
    TabOrder = 1
    object mmJson: TMemo
      Left = 16
      Top = 3
      Width = 473
      Height = 265
      Lines.Strings = (
        'mmJson')
      TabOrder = 0
    end
  end
  object RESTClient1: TRESTClient
    Params = <>
    SynchronizedEvents = False
    Left = 624
    Top = 600
  end
  object RESTRequest1: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 624
    Top = 568
  end
  object RESTResponse1: TRESTResponse
    Left = 624
    Top = 536
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Dataset = FDMemTable1
    FieldDefs = <>
    Response = RESTResponse1
    TypesMode = Rich
    Left = 624
    Top = 504
  end
  object FDMemTable1: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    Left = 728
    Top = 600
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=viaCEP'
      'User_Name=postgres'
      'Server=localhost'
      'Password=PauloHC01'
      'DriverID=PG')
    Connected = True
    Left = 728
    Top = 504
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorHome = 
      'C:\Users\paulo\OneDrive\Documentos\Embarcadero\Studio\Projects\l' +
      'ib'
    Left = 728
    Top = 536
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 728
    Top = 568
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 728
    Top = 472
  end
end
