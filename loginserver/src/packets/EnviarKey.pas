unit EnviarKey;

(*

Unit que cont�m o envio de chaves de encripta��o para
o cliente.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do c�digo:
Serve para gerar chaves de encripta��o para serem usadas
tanto pelo cliente como pelo servidor.

Refer�ncias:
Sem refer�ncias no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure PxKey(i: integer);

implementation

uses main, sockets, database;

procedure PxKey(i: integer);
var
  pdata: ansistring;
begin
  pdata:=#$00#$0B#$00#$00#$00#$00+chr(Lista[i].key)+#$00#$00#$00#$0F#$27#$00#$00;
  Lista[i].socket.sendtext(pdata);
end;

end.
