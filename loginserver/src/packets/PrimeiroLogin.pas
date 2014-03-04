unit PrimeiroLogin;

(*

Unit que cont�m os pacotes de primeiro login.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do c�digo:
Serve para dizer ao cliente para enviar o usuario para a
tela de primeiro login do PangYa.

Refer�ncias:
Sem refer�ncias no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure Px0F(i: Integer);

implementation

uses main, sockets, database;

procedure Px0F(i: integer);
var
  pdata: ansistring;
begin
  pdata:=EncryptS(Compress(#$0F#$00#$00+chr(Length(Lista[i].login))+#$00+Lista[i].login+#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key);
  Lista[i].socket.SendText(pdata);
  pdata:=EncryptS(Compress(#$01#$00#$D8#$FF#$FF#$FF#$FF#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key);
  Lista[i].socket.SendText(pdata);
end;

end.
