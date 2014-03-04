unit NickIndisponivel;

(*

Unit que cont�m o pacote de nick indisponivel.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do c�digo:
Serve para indicar ao cliente que o login que ele decidiu usar
est� indispon�vel.

Refer�ncias:
Sem refer�ncias no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure Px0Ei(i: Integer);

implementation

uses main, sockets, database;

procedure Px0Ei(i: Integer);
var
  pdata: ansistring;
begin
  pdata:=EncryptS(Compress(#$0E#$00#$0B#$00#$00#$00#$21#$D2#$4D#$00),Lista[i].key);
  Lista[i].socket.SendText(pdata);
end;

end.
