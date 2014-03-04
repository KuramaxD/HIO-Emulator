unit UsuarioBanido;

(*

Unit que contém o pacote de usuario banido.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Serve para indicar ao cliente que a conta requisitada para
login, está banida.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure Px01b(i: Integer);

implementation

uses main, sockets, database;

procedure Px01b(i: Integer);
var
  pdata: ansistring;
begin
  pdata:=EncryptS(Compress(#$01#$00#$E2#$F4#$D1#$4D#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key);
  Lista[i].socket.SendText(pdata);
end;

end.

