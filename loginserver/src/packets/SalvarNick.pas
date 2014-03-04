unit SalvarNick;

(*

Unit que salva o nick recebido.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Serve para salvar temporariamente o nick escolhido pelo cliente.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure Px01n(data: ansistring; i: integer);

implementation

uses main, sockets, database;

procedure Px01n(data: ansistring; i: integer);
var
  pdata, nick: ansistring;
begin
  nick:=copy(data,10,byte(data[8]));
  Lista[i].nick:=nick;
  pdata:=EncryptS(Compress(#$01#$00#$D9#$00#$00),Lista[i].key);
  Lista[i].socket.sendtext(pdata);
end;

end.
 