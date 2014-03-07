unit sockets;

(*

Unit que contém o gerenciamento dos sockets.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Serve para organizar cada cliente em uma matriz e usar
os recursos de cada um, individualmente ou não.

Referências:
http://docwiki.embarcadero.com/RADStudio/XE5/en/Installing_Socket_Components

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts, packetprocess, database, EnviarKey,
Autenticacao, SelecionarCanal;

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
  data: ansistring;
  login: AnsiString;
  nick: AnsiString;
  uid: integer;
  codigo1: ansistring;
  codigo2: ansistring;
  canal: integer;
  timestamp: integer;
  lobby: Boolean;
  sala: integer;
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
    Lista[i].data:='';
    Lista[i].timestamp:=0;
    Lista[i].lobby:=false;
    Lista[i].sala:=-1;
    Lista[i].canal:=-1;
    randomize;
    Lista[i].key:=Random(15)+1;
    TextColor(10);
    Writeln('[SERVER_S] Cliente recebido com sucesso! key: '+inttostr(Lista[i].key-1)+' ('+inttostr(i)+')');
    TextColor(7);
    PxKey(i);
    MySQL.Connected:=True;
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('update py_servers set usuariosonline = usuariosonline+1 where porta = '+QuotedStr(inttostr(Sockets.Socket.port))+'');
    Query.ExecSQL;
    MySQL.Connected:=false;
end;

procedure TObjeto.OnDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  i: integer;
begin
  for i:=0 to length(Lista)-1 do
    if Lista[i].status then
      if Lista[i].socket=socket then begin
        Lista[i].status:=false;
        Lista[i].lobby:=false;
        if Lista[i].uid > 0 then begin
          MySQL.Connected:=True;
          Query.Close;
          Query.SQL.Clear;
          Query.SQL.Add('update py_members set gamestatus = 0 where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
          Query.ExecSQL;
          Query.Close;
          Query.SQL.Clear;
          Query.SQL.Add('update py_servers set usuariosonline = usuariosonline-1 where porta = '+QuotedStr(inttostr(Sockets.Socket.port))+'');
          Query.ExecSQL;
          MySQL.Connected:=false;
          TextColor(12);
          Writeln('[SERVER_S] Cliente desconectado! ('+inttostr(i)+')');
          TextColor(7);
        end;
        break;
      end;
end;

procedure TObjeto.OnRead(Sender: TObject; Socket: TCustomWinSocket);
var
  i, packetid, x, y, nrand, size: integer;
  datacortada, datadec: ansistring;
begin
  for i:=0 to length(Lista)-1 do begin
    if Lista[i].status then
    if Lista[i].socket=socket then begin
      Lista[i].data:=Lista[i].data+socket.receivetext;
      while true do begin
        size:=0;
        if length(Lista[i].data) > 0 then size:=returnsize(Lista[i].data[2]+Lista[i].data[3]);
        if size=0 then Break;
        if size<=Length(Lista[i].data) then begin
          datacortada:=Copy(Lista[i].data,1,size);
          if length(datacortada)=returnsize(datacortada[2]+datacortada[3]) then begin
            nrand:=ord(datacortada[1]);
            x:=byte(keys[((Lista[i].key-1) shl 8)+nrand+1]);
            y:=byte(keys[((Lista[i].key-1) shl 8)+nrand+4097]);
            if y=(x xor ord(datacortada[5])) then begin
              if Lista[i].timestamp<>0 then begin
                if (gettickcount-Lista[i].timestamp)>30000 then begin
                  socket.close;
                end;
              end;
              datadec:=decryptS(datacortada,Lista[i].key);
              packetid:=returnsize(datadec[6]+datadec[7])-4;
              case packetid of
                2: LxAutenticar(datadec,i);
                3: chat(datadec,i);
                4: LxEntrarCanal(datadec,i);
                11: atualizarbarra(datadec,i);
                32: atualizar(datadec,i);
                42: pm(datadec,i);
                57: pagarcaddie(datadec,i);
                129: entrarnolobby(i);
                130: sairdolobby(i);
                102: enviarticker(datadec,i);
                103: liberarticker(i);
                107: atualizarpayday(datadec,i);
                112: begin
                  Lista[i].socket.sendtext(EncryptS(Compress(#$D5#$00#$05#$00#$00#$00),Lista[i].key));
                  Lista[i].socket.sendtext(EncryptS(Compress(#$DD#$00#$00#$00#$00#$00#$01#$00#$00#$00#$00#$00#$00#$00#$0A#$00#$00#$18#$49#$12#$E3#$05#$02#$00#$00#$00#$01#$00#$00#$00),Lista[i].key));
                end;
                244: timestamp(i);
                365: enviardiasonline2(i);
                366: x2(i);

                //181: teste4(i);
                //211: teste5(i);
                //196: teste6(i);
                193: teste6(i);

                181: begin
                  Lista[i].socket.sendtext(EncryptS(Compress(#$2B#$01#$01#$00#$00#$00#$74#$24#$14#$00#$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00),Lista[i].key));
                end;
                183: myroom(i);
              else begin
                writeln('packet id: '+inttostr(packetid));
                writeln(space(stringtohex(datadec)));
              end;
              end;
              Delete(Lista[i].data,1,size);
            end
            else begin
              Lista[i].socket.close;
            end;
          end
          else begin
            Lista[i].socket.close;
          end;
        end
        else break;
      end;
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
        Lista[i].lobby:=false;
        if Lista[i].uid > 0 then begin
          MySQL.Connected:=True;
          Query.Close;
          Query.SQL.Clear;
          Query.SQL.Add('update py_members set gamestatus = 0 where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
          Query.ExecSQL;
          Query.Close;
          Query.SQL.Clear;
          Query.SQL.Add('update py_servers set usuariosonline = usuariosonline-1 where porta = '+QuotedStr(inttostr(Sockets.Socket.port))+'');
          Query.ExecSQL;
          MySQL.Connected:=false;
        end;
        break;
      end;
end;

end.
