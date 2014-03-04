unit UsuarioLogado;

(*

Unit que contém o pacote de usuário já logado.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Serve para indicar ao cliente que a conta requerida para login
já está logada.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure Px01l(i: integer);

implementation

uses main, sockets, database;

procedure Px01l(i: integer);
var
  pdata: ansistring;
begin
  pdata:=EncryptS(Compress(#$01#$00#$E2#$4B#$D2#$4D#$00#$00#$00),Lista[i].key);
  Lista[i].socket.SendText(pdata);
end;

end.
