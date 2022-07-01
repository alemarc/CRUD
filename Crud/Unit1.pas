unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Data.SqlExpr, Data.DBXMySQL, Vcl.NumberBox, FireDAC.Phys.MySQLDef,
  FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.VCLUI.Wait;

type
  TForm1 = class(TForm)
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    txtNomeS: TEdit;
    txtTitulo: TEdit;
    txtDescricao: TMemo;
    btnIncluir: TButton;
    tbAnuncio: TDBGrid;
    Query: TFDQuery;
    Label4: TLabel;
    numValor: TNumberBox;
    MySQLDriver: TFDPhysMySQLDriverLink;
    conexao: TFDConnection;
    DataSource1: TDataSource;
    Label5: TLabel;
    txtCodigo: TEdit;
    btnAlterar: TButton;
    btnExcluir: TButton;
    btnBuscar: TButton;
    btnTodos: TButton;
    btnLimpar: TButton;
    //procedure FormCreate(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure tbAnuncioCellClick(Column: TColumn);
    procedure btnTodosClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure reiniciar();
    procedure txtCodigoChange(Sender: TObject);
    procedure txtNomeSChange(Sender: TObject);
    procedure txtTituloChange(Sender: TObject);
    procedure txtDescricaoChange(Sender: TObject);
    procedure numValorChangeValue(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure DimensionarGrid(dbg: TDBGrid);
type
  TArray = Array of Integer;
  procedure AjustarColumns(Swidth, TSize: Integer; Asize: TArray);
  var
    idx: Integer;
  begin
    if TSize = 0 then
    begin
      TSize := dbg.Columns.count;
      for idx := 0 to dbg.Columns.count - 1 do
        dbg.Columns[idx].Width := (dbg.Width - dbg.Canvas.TextWidth('AAAAAA')
          ) div TSize
    end
    else
      for idx := 0 to dbg.Columns.count - 1 do
        dbg.Columns[idx].Width := dbg.Columns[idx].Width +
          (Swidth * Asize[idx] div TSize);
  end;

var
  idx, Twidth, TSize, Swidth: Integer;
  AWidth: TArray;
  Asize: TArray;
  NomeColuna: String;
begin
  SetLength(AWidth, dbg.Columns.count);
  SetLength(Asize, dbg.Columns.count);
  Twidth := 0;
  TSize := 0;
  for idx := 0 to dbg.Columns.count - 1 do
  begin
    NomeColuna := dbg.Columns[idx].Title.Caption;
    dbg.Columns[idx].Width := dbg.Canvas.TextWidth
      (dbg.Columns[idx].Title.Caption + 'A');
    AWidth[idx] := dbg.Columns[idx].Width;
    Twidth := Twidth + AWidth[idx];

    if Assigned(dbg.Columns[idx].Field) then
      Asize[idx] := dbg.Columns[idx].Field.Size
    else
      Asize[idx] := 1;

    TSize := TSize + Asize[idx];
  end;
  if TDBGridOption.dgColLines in dbg.Options then
    Twidth := Twidth + dbg.Columns.count;

  // adiciona a largura da coluna indicada do cursor
  if TDBGridOption.dgIndicator in dbg.Options then
    Twidth := Twidth + IndicatorWidth;

  Swidth := dbg.ClientWidth - Twidth;
  AjustarColumns(Swidth, TSize, Asize);
end;

procedure TForm1.btnAlterarClick(Sender: TObject);
var
command:string;
resposta:Integer;
begin
    command:= 'UPDATE `CRUD`.`TB_ANUNCIO` SET `NOMES` = '+Quotedstr(txtNomeS.Text)+','+
              '`TITULO` = '+Quotedstr(txtTitulo.Text)+',' +
              '`DESCRICAO` = '+Quotedstr(txtDescricao.Text)+','+
              '`VALOR` = '+numValor.Value.ToString+','+
              '`DATA_ALTERACAO` = (SELECT NOW())' +
              ' WHERE (`IDANUNCIO` = '+Quotedstr(txtCodigo.Text)+');';
    resposta:= MessageDlg('Você esta prestes a alterar este cadastro! Deseja continuar?', mtConfirmation, [mbYes, mbNo], 0);
    case resposta of
      mrYes: // usuário clicou Sim
      try
        Query.SQL.Clear;
        Query.SQL.Add(command);
        Query.ExecSQL;
        Query.SQL.Clear;
        Query.SQL.Add('SELECT idAnuncio as `CODIGO`,titulo as TITULO, nomeS as `NOME`,'+
                      'descricao as `Descrição`, valor as `VALOR`, data_criacao as `DATA INCLUSÃO`,'+
                      'data_alteracao as `DATA ALTERAÇÃO` FROM tb_anuncio' +
                      ' WHERE IDANUNCIO ='+Quotedstr(txtCodigo.Text));
        Query.Open;
        DimensionarGrid(tbAnuncio);
      finally

      end;
    end;

end;

procedure TForm1.btnBuscarClick(Sender: TObject);
begin
    if(not (Trim(txtCodigo.Text) = ''))then
    begin
    Query.SQL.Clear;
    Query.SQL.Add('SELECT idAnuncio as `CODIGO`,titulo as TITULO, nomeS as `NOME`,'+
                  'descricao as `Descrição`, valor as `VALOR`, data_criacao as `DATA INCLUSÃO`,'+
                  'data_alteracao as `DATA ALTERAÇÃO` FROM tb_anuncio' +
                  ' WHERE IDANUNCIO ='+txtCodigo.Text);
    Query.Open;
    DimensionarGrid(tbAnuncio);
        if(not(Trim(Query.FieldByName('CODIGO').AsString) = ''))then
        begin
            txtCodigo.Text := Query.FieldByName('CODIGO').AsString;
            txtNomeS.Text:= Query.FieldByName('NOME').AsString;
            txtTitulo.Text := Query.FieldByName('TITULO').AsString;
            numValor.Value := Query.FieldByName('VALOR').AsFloat;
            txtDescricao.Text:= Query.FieldByName('DESCRIÇÃO').AsString;
            btnIncluir.Enabled := false;
            btnBuscar.Enabled:=false;
            btnTodos.Enabled := true;
            btnTodos.Visible := true;
            txtCodigo.Enabled := false;
            btnAlterar.Enabled:= true;
            btnexcluir.Enabled:= true;
            txtNomeS.Enabled := true;
            txtTitulo.Enabled:= true;
            numValor.Enabled:= true;
            txtDescricao.Enabled:= true;
            btnLimpar.Enabled := false;
            btnLimpar.Visible := false;
        end
        else
        begin
            Query.SQL.Clear;
            Query.SQL.Add('SELECT idAnuncio as `CODIGO`,titulo as TITULO, nomeS as `NOME`,'+
                          'descricao as `Descrição`, valor as `VALOR`, data_criacao as `DATA INCLUSÃO`,'+
                          'data_alteracao as `DATA ALTERAÇÃO` FROM tb_anuncio;');
            conexao.Connected := true;
            Query.Active := true;
            DimensionarGrid(tbAnuncio);
            txtCodigo.Clear;
            txtNomeS.Clear;
            txtTitulo.Clear;
            numValor.Clear;
            txtDescricao.Clear;
            btnTodos.Enabled := false;
            btnTodos.Visible := false;
            txtCodigo.Enabled := true;
            btnIncluir.Enabled:= true;
            btnBuscar.Enabled:= true;
            btnAlterar.Enabled:= false;
            btnexcluir.Enabled:= false;
            ShowMessage('Cadastro não encontrao!');
        end;
    end
    else
    begin
      ShowMessage('Por favor informe um código válido!');
    end;

end;

procedure TForm1.btnExcluirClick(Sender: TObject);
var
resposta:Integer;
command:string;
begin
    command:= 'DELETE FROM TB_ANUNCIO WHERE IDANUNCIO ='+Quotedstr(txtCodigo.Text);
    resposta:= MessageDlg('Realmente deseja excluir o cadastro de:'+txtNomeS.Text+'?', mtConfirmation, [mbYes, mbNo], 0);
    case resposta of
      mrYes:
      try
        Query.SQL.Clear;
        Query.SQL.Add(command);
        Query.ExecSQL;
        Query.SQL.Clear;
        Query.SQL.Add('SELECT idAnuncio as `CODIGO`,titulo as TITULO, nomeS as `NOME`,'+
                'descricao as `Descrição`, valor as `VALOR`, data_criacao as `DATA INCLUSÃO`,'+
                'data_alteracao as `DATA ALTERAÇÃO` FROM tb_anuncio;');
        conexao.Connected := true;
        Query.Active := true;
        DimensionarGrid(tbAnuncio);
        txtCodigo.Clear;
        txtNomeS.Clear;
        txtTitulo.Clear;
        numValor.Clear;
        txtDescricao.Clear;
        btnTodos.Enabled := false;
        btnTodos.Visible := false;
        txtCodigo.Enabled := true;
        btnIncluir.Enabled:= true;
        btnBuscar.Enabled:= true;
        btnAlterar.Enabled:= false;
        btnexcluir.Enabled:= false;
      finally

      end;

    end;
end;

procedure TForm1.btnIncluirClick(Sender: TObject);

var
command:String;
data: TDate;
dataformat:array[0..3] of string;
traco: char;
begin
  if(Trim(txtNomeS.Text) = '')then
  begin
     ShowMessage('Preencha o campo Nome do solicitante!');
     abort;
  end;
  if(Trim(txtTitulo.Text) = '')then
  begin
     ShowMessage('Preencha o campo Titulo!');
     abort;
  end;
  if(numValor.Value = 0)then
  begin
     ShowMessage('Preencha o campo Valor!');
     abort;
  end;
  if(Trim(txtdescricao.Text) = '')then
  begin
     ShowMessage('Preencha o campo Descrição!');
     abort;
  end;
  command := 'INSERT INTO TB_ANUNCIO (NOMES, TITULO, DESCRICAO, VALOR, DATA_CRIACAO)'
            + 'VALUES ('+ QuotedSTR(txtNomes.Text)+ ', '
            + Quotedstr(txtTitulo.Text)+ ', '
            + Quotedstr(txtDescricao.Text) + ', '
            + numValor.Value.ToString() + ', '
            + '(SELECT NOW()))';
  Query.SQL.Clear;
  Query.SQL.Add(command);
  Query.ExecSQL;
  reiniciar();
end;

procedure TForm1.btnLimparClick(Sender: TObject);
begin
  reiniciar();
end;

procedure TForm1.btnTodosClick(Sender: TObject);
begin
    reiniciar();
end;

//procedure TForm1.FormCreate(Sender: TObject);
//var
//  NomeArquivo: string;
//  INI: TextFile;
//  linha:string;
//  parametros:array[0..6] of string;
//  separator:char;
//  i:Integer;
//begin
//    NomeArquivo:= GetCurrentDir()+'\crud.ini';
//    separator:='=';
//    i := 0;
//    if(not FileExists(NomeArquivo))then
//    begin
//         ShowMessage('Ambiente de conexão não configurado!');
//         try
//            AssignFile(INI, NomeArquivo);
//            Rewrite(INI);
//            Writeln(INI,'HOST=');
//            Writeln(INI,'USER=');
//            Writeln(INI,'PASS=');
//            Writeln(INI,'PORT=');
//            Writeln(INI,'DATABASE=');
//            Writeln(INI,'DLL=libmysql41.dll');
//         finally
//            CloseFile(INI); // fecha o arquivo
//         end;
//    end
//    else
//    begin
//        AssignFile(INI, NomeArquivo);
//        Reset(INI);
//
//        while(not EoF(INI))do
//        begin
//          Readln(INI,linha);
//          //parametros[i]:= ArrayToString(linha);
//          parametros[i]:= linha.Split(separator)[1];
//          i:=i+1;
//        end;
//
//        try
//            if((not((Trim(parametros[0])) = '')) and (not((Trim(parametros[1])) = '')) and (not((Trim(parametros[2])) = '')) and (not((Trim(parametros[3])) = '')) and (not((Trim(parametros[4])) = '')) and (not((Trim(parametros[5])) = '')))then
//            begin
//                conexao.Params.Values['Server']:= parametros[0];
//                conexao.Params.Values['User_Name']:= parametros[1];
//                conexao.Params.Values['Password']:= parametros[2];
//                conexao.Params.Values['Port']:= parametros[3];
//                conexao.Params.Values['Database']:=parametros[4];
//                MySQLDriver.VendorLib:= GetCurrentDir()+'\'+parametros[5];
//                Query.SQL.Add('SELECT idAnuncio as `CODIGO`,titulo as TITULO, nomeS as `NOME`,'+
//                              'descricao as `Descrição`, valor as `VALOR`, data_criacao as `DATA INCLUSÃO`,'+
//                              'data_alteracao as `DATA ALTERAÇÃO` FROM tb_anuncio;');
//                conexao.Connected := true;
//                Query.Active := true;
//                DimensionarGrid(tbAnuncio);
//                txtNomeS.Clear;
//                txtTitulo.Clear;
//                txtDescricao.Clear;
//                btnAlterar.Enabled:= false;
//                btnexcluir.Enabled:= false;
//            end
//            else
//            begin
//              ShowMessage('Ambiente de conexão não configurado!');
//            end;
//        finally
//        end;
//
//    end;
//end;


procedure TForm1.FormShow(Sender: TObject);
var
  NomeArquivo: string;
  INI: TextFile;
  linha:string;
  parametros:array[0..6] of string;
  separator:char;
  i:Integer;
begin
    NomeArquivo:= GetCurrentDir()+'\crud.ini';
    separator:='=';
    i := 0;
    if(not FileExists(NomeArquivo))then
    begin
         ShowMessage('Ambiente de conexão não configurado!');
         try
            AssignFile(INI, NomeArquivo);
            Rewrite(INI);
            Writeln(INI,'HOST=');
            Writeln(INI,'USER=');
            Writeln(INI,'PASS=');
            Writeln(INI,'PORT=');
            Writeln(INI,'DATABASE=');
            Writeln(INI,'DLL=libmysql41.dll');
         finally
            CloseFile(INI); // fecha o arquivo
            Close;
         end;
    end
    else
    begin
        AssignFile(INI, NomeArquivo);
        Reset(INI);

        while(not EoF(INI))do
        begin
          Readln(INI,linha);
          //parametros[i]:= ArrayToString(linha);
          parametros[i]:= linha.Split(separator)[1];
          i:=i+1;
        end;

        try
            if((not((Trim(parametros[0])) = '')) and (not((Trim(parametros[1])) = '')) and (not((Trim(parametros[2])) = '')) and (not((Trim(parametros[3])) = '')) and (not((Trim(parametros[4])) = '')) and (not((Trim(parametros[5])) = '')))then
            begin
                conexao.Params.Values['Server']:= parametros[0];
                conexao.Params.Values['User_Name']:= parametros[1];
                conexao.Params.Values['Password']:= parametros[2];
                conexao.Params.Values['Port']:= parametros[3];
                conexao.Params.Values['Database']:=parametros[4];
                MySQLDriver.VendorLib:= GetCurrentDir()+'\'+parametros[5];
                Query.SQL.Add('SELECT idAnuncio as `CODIGO`,titulo as TITULO, nomeS as `NOME`,'+
                              'descricao as `Descrição`, valor as `VALOR`, data_criacao as `DATA INCLUSÃO`,'+
                              'data_alteracao as `DATA ALTERAÇÃO` FROM tb_anuncio;');
                conexao.Connected := true;
                Query.Active := true;
                DimensionarGrid(tbAnuncio);
                txtNomeS.Clear;
                txtTitulo.Clear;
                txtDescricao.Clear;
                btnAlterar.Enabled:= false;
                btnexcluir.Enabled:= false;
            end
            else
            begin
              ShowMessage('Ambiente de conexão não configurado!');
              Close;
            end;
        finally
        end;

    end;
end;

procedure TForm1.numValorChangeValue(Sender: TObject);
begin
  if((not (numValor.Value = 0)) or (not (Trim(txtNomeS.Text) = '')) or (not (Trim(txtTitulo.Text) = '')) or (not (Trim(txtDescricao.Text) = '')))then
  begin
    txtCodigo.Enabled := false;
    if(btnBuscar.Enabled = true)then
    begin
      btnLimpar.Enabled:= true;
      btnLimpar.Visible:= true;
    end;
  end
  else
  begin
     txtCodigo.Enabled := true;
     btnLimpar.Enabled:= false;
     btnLimpar.Visible:= false;
  end;
end;

procedure TForm1.tbAnuncioCellClick(Column: TColumn);
var
valores:TStringList;
codigo,select:string;
begin
    codigo:= tbAnuncio.Columns.Items[0].Field.Text;
    Query.SQL.Clear;
    Query.SQL.Add('SELECT idAnuncio as `CODIGO`,titulo as TITULO, nomeS as `NOME`,'+
                  'descricao as `Descrição`, valor as `VALOR`, data_criacao as `DATA INCLUSÃO`,'+
                  'data_alteracao as `DATA ALTERAÇÃO` FROM tb_anuncio' +
                  ' WHERE IDANUNCIO ='+codigo);
    Query.Open;
    DimensionarGrid(tbAnuncio);
    txtCodigo.Text := Query.FieldByName('CODIGO').AsString;
    txtNomeS.Text:= Query.FieldByName('NOME').AsString;
    txtTitulo.Text := Query.FieldByName('TITULO').AsString;
    numValor.Value := Query.FieldByName('VALOR').AsFloat;
    txtDescricao.Text:= Query.FieldByName('DESCRIÇÃO').AsString;
    btnIncluir.Enabled := false;
    btnBuscar.Enabled:=false;
    btnTodos.Enabled := true;
    btnTodos.Visible := true;
    txtCodigo.Enabled := false;
    btnAlterar.Enabled:= true;
    btnexcluir.Enabled:= true;
    txtNomeS.Enabled:= true;
    txtTitulo.Enabled:= true;
    numValor.Enabled:= true;
    txtDescricao.Enabled:= true;
end;

procedure TForm1.txtCodigoChange(Sender: TObject);
begin
  if((not (Trim(txtCodigo.Text) = '')))then
  begin
     txtNomeS.Enabled := false;
     txtTitulo.Enabled:= false;
     numValor.Enabled:= false;
     txtDescricao.Enabled:= false;
  end
  else
  begin
     txtNomeS.Enabled := true;
     txtTitulo.Enabled:= true;
     numValor.Enabled:= true;
     txtDescricao.Enabled:= true;
  end;
end;

procedure TForm1.txtDescricaoChange(Sender: TObject);
begin
  if((not (numValor.Value = 0)) or (not (Trim(txtNomeS.Text) = '')) or (not (Trim(txtTitulo.Text) = '')) or (not (Trim(txtDescricao.Text) = '')))then
  begin
    txtCodigo.Enabled := false;
    if(btnBuscar.Enabled = true)then
    begin
      btnLimpar.Enabled:= true;
      btnLimpar.Visible:= true;
    end;

  end
  else
  begin
     txtCodigo.Enabled := true;
     btnLimpar.Enabled:= false;
     btnLimpar.Visible:= false;
  end;
end;

procedure TForm1.txtNomeSChange(Sender: TObject);
begin
  if((not (numValor.Value = 0)) or (not (Trim(txtNomeS.Text) = '')) or (not (Trim(txtTitulo.Text) = '')) or (not (Trim(txtDescricao.Text) = '')))then
  begin
    txtCodigo.Enabled := false;
    if(btnBuscar.Enabled = true)then
    begin
      btnLimpar.Enabled:= true;
      btnLimpar.Visible:= true;
    end;
  end
  else
  begin
     txtCodigo.Enabled := true;
     btnLimpar.Enabled:= false;
     btnLimpar.Visible:= false;
  end;
end;

procedure TForm1.txtTituloChange(Sender: TObject);
begin
  if((not (numValor.Value = 0)) or (not (Trim(txtNomeS.Text) = '')) or (not (Trim(txtTitulo.Text) = '')) or (not (Trim(txtDescricao.Text) = '')))then
  begin
    txtCodigo.Enabled := false;
    if(btnBuscar.Enabled = true)then
    begin
      btnLimpar.Enabled:= true;
      btnLimpar.Visible:= true;
    end;
  end
  else
  begin
     txtCodigo.Enabled := true;
     btnLimpar.Enabled:= false;
     btnLimpar.Visible:= false;
  end;
end;

procedure TForm1.reiniciar;
begin
  Query.SQL.Clear;
  Query.SQL.Add('SELECT idAnuncio as `CODIGO`,titulo as TITULO, nomeS as `NOME`,'+
                'descricao as `Descrição`, valor as `VALOR`, data_criacao as `DATA INCLUSÃO`,'+
                'data_alteracao as `DATA ALTERAÇÃO` FROM tb_anuncio;');
  conexao.Connected := true;
  Query.Active := true;
  DimensionarGrid(tbAnuncio);
  txtCodigo.Clear;
  txtNomeS.Clear;
  txtTitulo.Clear;
  numValor.Value := 0;
  txtDescricao.Clear;
  btnTodos.Enabled := false;
  btnTodos.Visible := false;
  txtCodigo.Enabled := true;
  btnIncluir.Enabled:= true;
  btnBuscar.Enabled:= true;
  btnAlterar.Enabled:= false;
  btnexcluir.Enabled:= false;
end;


end.
