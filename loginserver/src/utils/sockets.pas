unit sockets;

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts, packetprocess, database;

type
  TObjeto = class(TObject)
   public
    procedure OnListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
end;

TLista = record
  status: boolean;
  socket: TCustomWinSocket;
  key: integer;
  login: AnsiString;
  nick: AnsiString;
  uid: integer;
  codigo1: ansistring;
  codigo2: ansistring;
end;

var
  Objeto: TObjeto;
  Socket: TServerSocket;
  Lista: array of TLista;

function iniciarsocket(porta: integer): boolean;

implementation

function iniciarsocket(porta: integer): boolean;
begin
  TObjeto.Create;
  Socket:=TServerSocket.Create(nil);
  Socket.OnListen:=Objeto.OnListen;
  Socket.OnClientConnect:=Objeto.OnConnect;
  Socket.OnClientDisconnect:=Objeto.OnDisconnect;
  Socket.OnClientRead:=Objeto.OnRead;
  Socket.OnClientError:=Objeto.OnError;
  Socket.Port:=porta;
  Socket.ServerType:=StNonBlocking;
  try
    Socket.Open;
  except
    on E: Exception do begin
      writeln('[SERVER_S] Error ao iniciar o servidor! ('+e.Message+')');
      result:=false;
      exit;
    end;
  end;
  result:=true;
end;

procedure TObjeto.OnListen(Sender: TObject; Socket: TCustomWinSocket);
begin
  TextColor(10);
  Writeln('[SERVER_S] Servidor ligado.');
  TextColor(7);
end;

procedure TObjeto.OnConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  teste: boolean;
  i: integer;
begin
  teste:=false;
  for i:=0 to length(Lista)-1 do
    if not Lista[i].status then begin
      teste:=true;
      break;
    end;
    if not teste then begin
      setlength(Lista, length(Lista)+1);
      i:=length(Lista)-1;
    end;
    Lista[i].status:=true;
    Lista[i].socket:=socket;
    randomize;
    Lista[i].key:=random(15);
    TextColor(10);
    Writeln('[SERVER_S] Cliente recebido com sucesso! key: '+inttostr(Lista[i].key));
    TextColor(7);
    enviarkey(i);
end;

procedure TObjeto.OnDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  i: integer;
begin
  for i:=0 to length(Lista)-1 do
    if Lista[i].status then
      if Lista[i].socket=socket then begin
        Lista[i].status:=false;
        if Lista[i].uid > 0 then begin
          MySQL.Connected:=true;
          Query.Close;
          Query.SQL.Clear;
          Query.SQL.Add('update py_members set loginstatus = 0 where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
          Query.ExecSQL;
          MySQL.Connected:=false;
        end;
        break;
      end;
end;

procedure TObjeto.OnRead(Sender: TObject; Socket: TCustomWinSocket);
var
  i, packetid, x, y, nrand: integer;
  data, datadec: ansistring;
begin
  for i:=0 to length(Lista)-1 do begin
    if Lista[i].status then
    if Lista[i].socket=socket then begin
      data:=socket.receivetext;
      if length(data)=returnsize(data[2]+data[3]) then begin
        nrand:=ord(data[1]);
        x:=byte(keys[(Lista[i].key shl 8)+nrand+1]);
        y:=byte(keys[(Lista[i].key shl 8)+nrand+4097]);
        if y=(x xor ord(data[5])) then begin
          datadec:=decryptS(data,Lista[i].key);
          packetid:=returnsize(datadec[6]+datadec[7])-4;
          case packetid of
            1: checarlogin(datadec,i);
            3: codigo2(i);
            6: salvarnick(datadec,i);
            7: checarnick(datadec,i);
            8: terminarprimeirologin(datadec,i);
            11: ; //não é usado no oficial e não é necessário, porém é um aviso de desconexão de usuário
          else begin
            writeln('packet id: '+inttostr(packetid));
            writeln(space(stringtohex(datadec)));
          end;
          end;
        end
        else begin
          Lista[i].socket.close;
        end;
      end
      else begin
        Lista[i].socket.close;
      end;
      break;
    end;
  end;
end;

procedure TObjeto.OnError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
var
  i: integer;
begin
  for i:=0 to length(Lista)-1 do
    if Lista[i].status then
      if Lista[i].socket=socket then begin
        Lista[i].status:=false;
        if Lista[i].uid > 0 then begin
          Query.Close;
          Query.SQL.Clear;
          Query.SQL.Add('update py_members set loginstatus = 0 where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
          Query.ExecSQL;
        end;
        break;
      end;
end;

end.
