unit SenhaIncorreta;

(*

Unit que contém o pacote de senha incorreta.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Serve para indicar ao cliente que a conta requisitada para
login, está com a senha diferente da enviada.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure Px01s(i: Integer);

implementation

uses main, sockets, database;

procedure Px01s(i: Integer);
var
  pdata: ansistring;
begin
  pdata:=EncryptS(Compress(#$01#$00#$E2#$61#$D2#$4D#$00#$1B#$00#$49#$6E#$63#$6F#$72#$72#$65#$63#$74#$20#$6C#$6F#$67#$69#$6E#$20#$63#$72#$65#$64#$65#$6E#$74#$69#$61#$6C#$73#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key);
  Lista[i].socket.SendText(pdata);
end;

end.
