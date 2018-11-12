unit cadCli1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JsBotao1, ExtCtrls, Mask, JsEditCPF1, JsEdit1,
  JsEditInteiro1, func, untnfce;

type
  TCadClienteSimplificado = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    nome: JsEdit;
    cnpj: JsEditCPF;
    ToolBar1: TPanel;
    button: JsBotao;
    procedure bairroKeyPress(Sender: TObject; var Key: Char);
    procedure buttonKeyPress(Sender: TObject; var Key: Char);
    procedure codKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure buttonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure numeroKeyPress(Sender: TObject; var Key: Char);
    procedure cnpjKeyPress(Sender: TObject; var Key: Char);
    procedure codKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure nomeKeyPress(Sender: TObject; var Key: Char);
    procedure nomeExit(Sender: TObject);
  private
    function insereCliente : String;
    procedure buscaCliente(cpf1 : String);
    procedure montaRetorno(limp : boolean = false);
    { Private declarations }
  public
    codCliente : String;
    procedure limpa();
    { Public declarations }
  end;

var
  CadClienteSimplificado: TCadClienteSimplificado;

implementation

uses unit1;

{$R *.dfm}

procedure TCadClienteSimplificado.limpa();
begin
  codCliente := '';
  nome.Text  := '';
  cnpj.Text  := '';
end;

procedure TCadClienteSimplificado.bairroKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
    begin
      key := #0;
      limpa;
    end;

  if key = #13 then
    begin
      button.SetFocus;
    end;  
end;

procedure TCadClienteSimplificado.buttonKeyPress(Sender: TObject; var Key: Char);
begin
  key := #0;
end;

function TCadClienteSimplificado.insereCliente : String;
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'insert into';
end;

procedure TCadClienteSimplificado.codKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 116) then
    begin
      tedit(sender).Text := funcoes.localizar1('Localizar Cliente','cliente','cod,nome,telres,telcom,cnpj as cpfcnpj,bairro','cod','','nome','nome',false,false,false,'','',450, nil);
      key := 0;
    end;
end;

procedure TCadClienteSimplificado.buttonClick(Sender: TObject);
begin
  montaRetorno();
  //codCliente := jsedit.GravaNoBD(self);
  close;
end;

procedure TCadClienteSimplificado.FormShow(Sender: TObject);
begin
  jsedit.SetTabelaDoBd(self, 'cliente', dm.IBQuery1);
  nome.SetFocus;
end;

procedure TCadClienteSimplificado.numeroKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then button.SetFocus;
end;

procedure TCadClienteSimplificado.cnpjKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      if not testacpf(cnpj.Text) then
        begin
          MessageDlg('CPF Inv�lido!', mtError, [mbOK], 1);
          key := #0;
          abort;
          exit;
        end
      else
        begin
          key := #0;
          buscaCliente(cnpj.Text);
          montaRetorno();
          button.SetFocus;
        end;
    end;


end;

procedure TCadClienteSimplificado.codKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then close;
end;

procedure TCadClienteSimplificado.FormCreate(Sender: TObject);
begin
  codCliente := '';
end;

procedure TCadClienteSimplificado.buscaCliente(cpf1 : String);
begin
  dm.IBQuery1.Close;
  dm.IBQuery1.SQL.Text := 'select cod, nome, ende, bairro from cliente where cnpj = :cnpj';
  dm.IBQuery1.ParamByName('cnpj').AsString := cpf1;
  dm.IBQuery1.Open;

  if dm.IBQuery1.IsEmpty then
    begin
      dm.IBQuery1.Close;
      exit;
    end;

  //cod.Text    := dtmMain.IBQuery1.fieldbyname('cod').AsString;
  NOME.Text   := dm.IBQuery1.fieldbyname('nome').AsString;
  //ende.Text   := dtmMain.IBQuery1.fieldbyname('ende').AsString;
  //bairro.Text := dtmMain.IBQuery1.fieldbyname('bairro').AsString;
  dm.IBQuery1.Close;
end;

procedure TCadClienteSimplificado.montaRetorno(limp : boolean = false);
begin
  if limp then
    begin
      codCliente := '';
      exit;
    end;

  if length(nome.Text) < 2 then nome.Text := 'Venda ao Consumidor';
  codCliente := 'nome=' + nome.Text + #13 +
  'cpf=' + cnpj.Text;
end;

procedure TCadClienteSimplificado.nomeKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
    begin
      montaRetorno(true);
      close;
    end;
end;

procedure TCadClienteSimplificado.nomeExit(Sender: TObject);
begin
  if length(nome.Text) < 2 then nome.Text := 'Venda ao Consumidor';
end;

end.
