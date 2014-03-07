unit Chat;

(*

Unit que gerencia todo o sistema de chat do jogo.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Faz as devidas seleções para enviar as mensagens.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure LxPM(data: ansistring; i: integer);

implementation

uses main, sockets, database;

procedure LxPM(data: ansistring; i: integer);
var
  pdata, mensagem, nick: ansistring;
  u: integer;
  enviado: Boolean;
begin
  if dbug=1 then debug('PM',i);
  enviado:=false;
  nick:=copy(data,10,byte(data[8]));
  mensagem:=copy(data,12+byte(data[8]),byte(data[10+byte(data[8])]));
  if (Lista[i].lobby=true) and (Lista[i].canal<>-1) then begin
    for u:=0 to Length(Lista)-1 do begin
      if Lista[u].status=true then
        if Lista[u].canal<>-1 then
          if Lista[u].nick=nick then begin
            pdata:=EncryptS(Compress(#$84#$00#$00+chr(length(Lista[i].nick))+#$00+Lista[i].nick+chr(length(mensagem))+#$00+mensagem),Lista[u].key);
            Lista[u].socket.SendText(pdata);
            pdata:=EncryptS(Compress(#$84#$00#$00+chr(length(Lista[u].nick))+#$00+Lista[u].nick+chr(length(mensagem))+#$00+mensagem),Lista[i].key);
            Lista[i].socket.SendText(pdata);
            enviado:=true;
            break;
          end;
    end;
    if enviado=false then begin
      pdata:=EncryptS(Compress(#$40#$00#$05+chr(length(nick))+#$00+nick+#$00#$00),Lista[i].key);
      Lista[i].socket.SendText(pdata);
    end;
  end
  else
    Lista[i].socket.close;
end;

end.
