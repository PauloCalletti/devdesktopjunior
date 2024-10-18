unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdHTTP, IdSSLOpenSSL,
  REST.Types, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.Json, uCEP,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait,
  FireDAC.Phys.MySQLDef, FireDAC.DApt, FireDAC.Comp.UI, FireDAC.Phys.MySQL;

type
  TfrmBuscaCEP = class(TForm)
    gpConsultar: TGroupBox;
    btnBuscarCEP: TButton;
    edtCEP: TEdit;
    lblCEP: TLabel;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    FDConnection1: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDQuery1: TFDQuery;
    edtLogradouro: TEdit;
    gpJson: TGroupBox;
    mmJson: TMemo;
    edtComplemento: TEdit;
    edtBairro: TEdit;
    edtLocalidade: TEdit;
    edtUF: TEdit;
    edtIBGE: TEdit;
    edtGIA: TEdit;
    edtDDD: TEdit;
    edtSiafi: TEdit;
    lblAviso: TLabel;
    lblLogradouro: TLabel;
    lblComplemento: TLabel;
    lblBairro: TLabel;
    lblLocalidade: TLabel;
    lblIBGE: TLabel;
    lblGIA: TLabel;
    lblDDD: TLabel;
    lblSIAFI: TLabel;
    btnVerificarCEP: TButton;
    procedure btnBuscarCEPClick(Sender: TObject);
    procedure btnVerificarCEPClick(Sender: TObject);
  private

  function ConsultarCEP(const ACEP: string): TCEP;
  procedure SalvarCEPBanco(const CEP: TCEP);

  public
    { Public declarations }
  end;


var
  frmBuscaCEP: TfrmBuscaCEP;
  FDQuery1: TFDQuery;
  Http : TidHTTP;
  JsonResponse : String;
  erroJson: String;
  RESTClient1: TRESTClient;
  RESTRequest1: TRESTRequest;
  RESTResponse1: TRESTResponse;
  RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
  JSONValue: TJSONValue;

implementation
{$R *.dfm}


function TfrmBuscaCEP.ConsultarCEP(const ACEP: string): TCEP;
begin
    RESTClient1.BaseURL := 'https://viacep.com.br/ws/' + edtCEP.Text + '/json/';
    RESTRequest1.Execute;
    JSONValue := TJSONObject.ParseJSONValue(RESTResponse1.Content);



    if (erroJson = 'true') then
    begin
      ShowMessage('CEP não encontrado na API do ViaCEP');
    end
    else
    begin
    try
      Result := TCEP.Create;
      Result.Cep := JSONValue.GetValue<string>('cep', '');
      Result.Logradouro := JSONValue.GetValue<string>('logradouro', '');
      Result.Complemento := JSONValue.GetValue<string>('complemento', '');
      Result.Bairro := JSONValue.GetValue<string>('bairro', '');
      Result.Localidade := JSONValue.GetValue<string>('localidade', '');
      Result.Uf := JSONValue.GetValue<string>('uf', '');
      Result.Ibge := JSONValue.GetValue<string>('ibge', '');
      Result.Gia := JSONValue.GetValue<string>('gia', '');
      Result.Ddd := JSONValue.GetValue<string>('ddd', '');
      Result.Siafi := JSONValue.GetValue<string>('siafi', '');

      Result.Json := RESTResponse1.Content;

      erroJson := JSONValue.GetValue<string>('erro', '');

    finally
      JSONValue.Free;
    end;
    end;
end;

procedure TfrmBuscaCEP.btnBuscarCEPClick(Sender: TObject);
begin
var
  cepResult: TCEP;

  mmJson.Clear;
  try

  cepResult := ConsultarCEP(edtCEP.Text);

  edtCEP.Text := cepResult.Cep;
  edtLogradouro.Text := cepResult.Logradouro;
  edtComplemento.Text := cepResult.Complemento;
  edtBairro.Text := cepResult.Bairro;
  edtLocalidade.Text := cepResult.Localidade;
  edtUF.Text := cepResult.uf;
  edtIBGE.Text := cepResult.Ibge;
  edtGIA.Text := cepResult.Gia;
  edtDDD.Text := cepResult.Ddd;
  edtSiafi.Text := cepResult.Siafi;
  mmJson.Lines.Text := cepResult.Json;


  SalvarCEPBanco(cepResult);

  except
    on e:Exception do
      ShowMessage('Erro ao consultar CEP: ' + e.Message);
  end;

end;

procedure TfrmBuscaCEP.SalvarCEPBanco(const CEP: TCEP);
begin
  FDQuery1.SQL.Clear;

  FDQuery1.SQL.Text := 'SELECT * FROM public."TspdCep" WHERE cep = :cep';

  FDQuery1.ParamByName('cep').AsString := CEP.Cep;

  FDQuery1.Open;

  if FDQuery1.RecordCount > 0 then
  begin
  try
    FDQuery1.SQL.Text := 'UPDATE public."TspdCep"	SET logradouro = :logradouro, complemento = :complemento, bairro = :bairro, localidade = :localidade, ' +
    'uf = :uf, ibge = :ibge, ddd = :ddd, json = :json	WHERE cep = :cep;';

    FDQuery1.ParamByName('logradouro').AsString := CEP.Logradouro;
    FDQuery1.ParamByName('complemento').AsString := CEP.Complemento;
    FDQuery1.ParamByName('bairro').AsString := CEP.Bairro;
    FDQuery1.ParamByName('localidade').AsString := CEP.Localidade;
    FDQuery1.ParamByName('uf').AsString := CEP.Uf;
    FDQuery1.ParamByName('ibge').AsString := CEP.Ibge;
    FDQuery1.ParamByName('ddd').AsString := CEP.Ddd;
    FDQuery1.ParamByName('json').AsString := CEP.Json;

    FDQuery1.ExecSQL;
    ShowMessage('CEP Adicionado na base de dados!');

  except
    on e:Exception do
      ShowMessage('Erro ao salvar CEP no banco: ' + e.Message);
  end;
  end
  else
  begin
  try
  FDQuery1.SQL.Text := 'INSERT INTO public."TspdCep"(cep, logradouro, complemento, bairro, localidade, uf, ibge, ddd, json) ' +
                         'VALUES (:cep, :logradouro, :complemento, :bairro, :localidade, :uf, :ibge, :ddd, :json)';

    FDQuery1.ParamByName('cep').AsString := CEP.Cep;
    FDQuery1.ParamByName('logradouro').AsString := CEP.Logradouro;
    FDQuery1.ParamByName('complemento').AsString := CEP.Complemento;
    FDQuery1.ParamByName('bairro').AsString := CEP.Bairro;
    FDQuery1.ParamByName('localidade').AsString := CEP.Localidade;
    FDQuery1.ParamByName('uf').AsString := CEP.Uf;
    FDQuery1.ParamByName('ibge').AsString := CEP.Ibge;
    FDQuery1.ParamByName('ddd').AsString := CEP.Ddd;
    FDQuery1.ParamByName('json').AsString := CEP.Json;
    FDQuery1.ExecSQL;

    ShowMessage('CEP Atualizado na base de dados!');
  except
    on e:Exception do
      ShowMessage('Erro ao inserir CEP no banco: ' + e.Message);
  end;
  end;
end;

procedure TfrmBuscaCEP.btnVerificarCEPClick(Sender: TObject);
begin
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Text := 'SELECT * FROM public."TspdCep" WHERE uf = :uf';

  FDQuery1.ParamByName('uf').AsString := edtUF.Text;
  FDQuery1.Open;

  if FDQuery1.RecordCount > 0 then
  begin
  try
    FDQuery1.First;
    mmJson.Lines.text := '';

    while not FDQuery1.Eof do
    begin
      mmJson.Lines.Add(FDQuery1.FieldByName('cep').AsString + ' - ' + FDQuery1.FieldByName('localidade').AsString + ' - ' + FDQuery1.FieldByName('uf').AsString);

      FDQuery1.Next;
    end;
  except
    on e:Exception do
      ShowMessage('Erro ao verificar UF no banco: ' + e.Message);
  end;
  end
  else
  begin
    ShowMessage('Nenhuma UF encontrada.');
  end;

  FDQuery1.Close;
end;

end.
