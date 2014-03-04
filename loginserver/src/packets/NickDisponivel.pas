unit NickDisponivel;

(*

Unit que cont�m o pacote de nick disponivel.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do c�digo:
Serve para indicar ao cliente que o login que ele decidiu usar
est� dispon�vel.

Refer�ncias:
Sem refer�ncias no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure Px0Ed(i: Integer);

implementation

uses main, sockets, database;

procedure Px0Ed(i: Integer);
var
  pdata: ansistring;
begin
  pdata:=EncryptS(Compress(#$0E#$00#$00#$00#$00#$00+chr(length(Lista[i].nick))+#$00+Lista[i].nick),Lista[i].key);
  Lista[i].socket.SendText(pdata);
end;

end.
