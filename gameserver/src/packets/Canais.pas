unit Canais;

(*

Unit que envia a lista de canais.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Serve para criar o pacote de canais de acordo com
os canais carregados pela procedure carregarcanais
na unit main.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts, packetprocess;

procedure LxListadeCanais(i: Integer);

implementation

uses main, sockets, database;

procedure LxListadeCanais(i: Integer);
var
  pdata: ansistring;
  u, x, online: integer;
begin
  if dbug=1 then debug('Enviando canais',i);
  online:=0;
  for u:=0 to Length(main.canais)-1 do begin
    for x:=0 to Length(Lista)-1 do begin
      if Lista[x].status=true then begin
        if Lista[x].canal=u then online:=online+1;
      end;
    end;
    pdata:=pdata+wrapper(main.canais[u].nome,64)+hextoascii(reversestring2(inttohex(main.canais[i].maxusuarios,4)))+hextoascii(reversestring2(inttohex(online,4)))+chr(u)+#$00+chr(main.canais[i].tipo)+#$00#$00#$00#$00#$00#$00;
  end;
  pdata:=EncryptS(Compress(#$4D#$00+chr(Length(main.canais))+pdata),Lista[i].key);
  Lista[i].socket.SendText(pdata);
end;

end.
