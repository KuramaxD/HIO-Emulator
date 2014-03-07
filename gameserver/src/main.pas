unit main;

interface

uses Windows, SysUtils, colors, funcoes, crypts, packetprocess, database, sockets, dialogs, iff;

type
TCanais = record
  nome: AnsiString;
  tipo: integer;
  maxusuarios: integer;
end;

var
  Canais: array of TCanais;
  dbug: integer;

procedure iniciar();
function onclose(CtrlType : DWord) : Bool; stdcall; far;
procedure onopen();

implementation

procedure carregarcanais(quantidade: integer);
var
  i: integer;
begin
  SetLength(Canais,quantidade);
  for i:=0 to Length(Canais)-1 do begin
    Canais[i].nome:='Canal 1';
    Canais[i].tipo:=0;
    Canais[i].maxusuarios:=5;
  end;
end;

procedure iniciar();
begin
  //======================================
  //  PREPARA O SERVIDOR PARA SER LIGADO
  //======================================
  SetConsoleTitle('PY Game GB.R6.727.00');
  Writeln('[SERVER_S] Iniciando servidor.');
  carregarcanais(1);
  //Le iffs
  loadiffs;
  // Preparar canais
  //======================================
  //  ARRUMA AS PROCEDURES DO COMPONENTE
  //======================================
  iniciardatabase('127.0.0.1','root','vertrigo','pangya',3306);
  iniciarsocket(7997);
  onopen;
  dbug:=1;
end;

procedure onopen();
begin
  Writeln('[SERVER_S] Zerando quantidade de usuarios online no servidor');
  MySQL.Connected:=true;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('update py_servers set usuariosonline = 0 where porta = '+QuotedStr(inttostr(Sockets.Socket.port))+'');
  Query.ExecSQL;
  MySQL.Connected:=false;
end;

function onclose(CtrlType : DWord) : Bool; stdcall; far;
var
  i: integer;
begin
  if (CtrlType = CTRL_CLOSE_EVENT) then begin
    MySQL.Connected:=true;
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('update py_servers set usuariosonline = 0 where porta = '+QuotedStr(inttostr(Sockets.Socket.port))+'');
    Query.ExecSQL;
    for i:=0 to Length(Lista)-1 do begin
      if Lista[i].status=true then begin
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add('update py_members set gamestatus = 0 where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
        Query.ExecSQL;
      end;
    end;
    MySQL.Connected:=false;
  end;
  result:=false;
end;


end.
