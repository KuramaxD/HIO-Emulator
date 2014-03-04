unit DadosPessoais;

(*

Unit que contém os pacotes de dados.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Serve para enviar para o cliente alguns dados importantes como
id da conta e nick.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure Px01d(i: integer);

implementation

uses main, sockets, database;

procedure Px01d(i: integer);
var
  pdata: ansistring;
begin
  pdata:=EncryptS(Compress(#$01#$00#$00+chr(length(Lista[i].login))+#$00+Lista[i].login+hextoascii(reversestring(inttohex(Lista[i].uid,8)))+#$00#$00#$00#$00#$1A#$00#$00#$00#$00#$00#$00#$00#$00#$00+chr(length(Lista[i].nick))+#$00+Lista[i].nick+#$00#$00),Lista[i].key);
  Lista[i].socket.SendText(pdata);
  pdata:=EncryptS(Compress(#$03#$09#$00#$00),Lista[i].key);
  Lista[i].socket.SendText(pdata);
end;

end.
