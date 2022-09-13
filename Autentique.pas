unit Autentique;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.UITypes, System.Net.HttpClient, System.Net.Mime;

type
  TForm1 = class(TForm)
    BtEnviarArquivo: TButton;
    BtCriarPasta: TButton;
    Button1: TButton;
    MemoRetorno: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure BtEnviarArquivoClick(Sender: TObject);
    procedure BtCriarPastaClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure ProcCriarDocumento;
    procedure ProcCriarPasta;
    procedure ProcMoverDocumento;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ProcCriarDocumento;
Var HttpClient: THTTPClient;
    Params: TMultipartFormData;
    Response: TStringStream;
    URL, Operations, Map, Token, Doc, Email, PDF: String;
    StatusCode: Integer;
begin
  HttpClient := THTTPClient.Create;
  Params     := TMultipartFormData.Create();
  Response   := TStringStream.Create;

  // Este é o EndPoint da API
  URL := 'https://api.autentique.com.br/v2/graphql';

  // Este é o caminho do seu arquivo
  PDF := 'C:\Users\Windows\Downloads\Arquivo.pdf';

  // Este é o e-mail de quem vai receber o arquivo
  Email := 'substituir_por_email@teste.com';

  // Este é o nome do Documento dentro do Autentique
  Doc := 'Arquivo Teste API';

  // Seu token de acesso
  Token := 'Substituir_pelo_seu_token_de_acesso';

  // Esta é a mutation que cria o arquivo no Autentique
  Operations :=
  '{"query":"mutation CreateDocumentMutation'+
  '($document: DocumentInput!, $signers: [SignerInput!]!, $file: Upload!) '+
  '{createDocument(document: $document, signers: $signers, file: $file) '+
  '{id name refusable sortable created_at signatures '+
  '{ public_id name email created_at action { name } link { short_link } user { id name email }}}}", '+
  '"variables":{"document": {"name": "' + Doc + '"},'+
  '"signers": [{"email": "' + Email + '","action": "SIGN"}],"file":null}}';

  // Variável referente ao arquivo que será criado, não deve ser alterada pois o arquivo será enviado no form-data
  Map := '{"file": ["variables.file"]}';

  try
    try
      HttpClient.CustomHeaders['Authorization'] := 'Bearer ' + Token;

      Params.AddField('operations', Operations);
      Params.AddField('map', Map);
      Params.AddFile('file', PDF);

      // Dessa forma gravamos o StatusCode e a resposta em suas respectivas variáveis
      StatusCode := HttpClient.Post(URL, Params, Response).StatusCode;

      if StatusCode = 200 then
      begin
        Label2.Caption := '200 OK';
        Label2.Font.Color := clGreen;
      end
      else
      begin
        Label2.Caption := IntToStr(StatusCode) + 'Erro';
        Label2.Font.Color := clRed;
      end;

      MemoRetorno.Text := Response.DataString;
    except
      On E: Exception do
      begin
        // Pegamos o erro de exceção se alguma coisa der errado
        MessageDlg('Erro. Detalhes: ' + E.Message, mtError, [mbOK], 0);
        Abort;
      end;
    end;
  finally
    HttpClient.Free;
    Params.Free;
    Response.Free;
  end;

end;

procedure TForm1.ProcCriarPasta;
Var HttpClient: THTTPClient;
    Json, Folder, Token, URL: String;
    JsonRequest, Response: TStringStream;
    StatusCode: Integer;
begin
  HttpClient := THTTPClient.Create;
  Response   := TStringStream.Create;

  // Este é o EndPoint da API
  URL := 'https://api.autentique.com.br/v2/graphql';

  // Nome da pasta que você deseja criar
  Folder := 'Pasta criada via API';

  // Seu token de acesso
  Token := 'Substituir_pelo_seu_token_de_acesso';

  Json :=
  '{'+
    '"query": "mutation CreateFolderMutation($folder: FolderInput!) { createFolder(folder: $folder) { id name type created_at } }",'+
    '"variables": {'+
		  '"folder": {'+
		   	'"name": "'+ Folder +'"'+
	   	'}'+
   	'}'+
  '}';

  JsonRequest := TStringStream.Create(Json, TEncoding.UTF8);

  try
    try
      HttpClient.CustomHeaders['Authorization'] := 'Bearer ' + Token;

      HttpClient.ContentType   := 'application/json';
      HttpClient.AcceptCharSet := 'utf-8';

      // Dessa forma gravamos o StatusCode e a resposta em suas respectivas variáveis
      StatusCode := HttpClient.Post(URL, JsonRequest, Response).StatusCode;

      if StatusCode = 200 then
      begin
        Label2.Caption := '200 OK';
        Label2.Font.Color := clGreen;
      end
      else
      begin
        Label2.Caption := IntToStr(StatusCode) + 'Erro';
        Label2.Font.Color := clRed;
      end;

      MemoRetorno.Text := Response.DataString;
    except
      On E: Exception do
      begin
        // Pegamos o erro de exceção se alguma coisa der errado
        MessageDlg('Erro. Detalhes: ' + E.Message, mtError, [mbOK], 0);
        Abort;
      end;
    end;
  finally
    HttpClient.Free;
    JsonRequest.Free;
    Response.Free;
  end;
end;

procedure TForm1.ProcMoverDocumento;
Var HttpClient: THTTPClient;
    Json, FolderId, DocId, Token, URL: String;
    JsonRequest, Response: TStringStream;
    StatusCode: Integer;
begin
  HttpClient := THTTPClient.Create;
  Response   := TStringStream.Create;

  // Este é o EndPoint da API
  URL := 'https://api.autentique.com.br/v2/graphql';

  // Id do documento que será movido
  DocId := 'Substituir_por_um_id_de_documento_valido';

  // Id da pasta que receberá o arquivo
  FolderId := 'Substituir_por_um_id_de_pasta_valido';

  // Seu token de acesso
  Token := 'Substituir_pelo_seu_token_de_acesso';

  Json :=
  '{'+
      '"query": "mutation { moveDocumentToFolder(document_id: \"' + DocId +'\", folder_id: \"'+ FolderId +'\") }",'+
      '"variables": {}'+
  '}';

  JsonRequest := TStringStream.Create(Json, TEncoding.UTF8);

  try
    try
      HttpClient.CustomHeaders['Authorization'] := 'Bearer ' + Token;

      HttpClient.ContentType   := 'application/json';
      HttpClient.AcceptCharSet := 'utf-8';

      // Dessa forma gravamos o StatusCode e a resposta em suas respectivas variáveis
      StatusCode := HttpClient.Post(URL, JsonRequest, Response).StatusCode;

      if StatusCode = 200 then
      begin
        Label2.Caption := '200 OK';
        Label2.Font.Color := clGreen;
      end
      else
      begin
        Label2.Caption := IntToStr(StatusCode) + 'Erro';
        Label2.Font.Color := clRed;
      end;

      MemoRetorno.Text := Response.DataString;
    except
      On E: Exception do
      begin
        // Pegamos o erro de exceção se alguma coisa der errado
        MessageDlg('Erro. Detalhes: ' + E.Message, mtError, [mbOK], 0);
        Abort;
      end;
    end;
  finally
    HttpClient.Free;
    JsonRequest.Free;
    Response.Free;
  end;
end;

procedure TForm1.BtCriarPastaClick(Sender: TObject);
begin
  ProcCriarPasta;
end;

procedure TForm1.BtEnviarArquivoClick(Sender: TObject);
begin
  ProcCriarDocumento;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ProcMoverDocumento;
end;

end.
