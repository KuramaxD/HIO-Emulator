unit Codigo2;

(*

Unit que gera o segundo código do PangYa.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Serve para enviar um código que serve de autenticação para
o GameServer.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure Px03(i: Integer);

implementation

uses main, sockets, database;

procedure Px03(i: Integer);
var
  pdata: AnsiString;
begin
  Lista[i].codigo2:=gerarcodigo;
  MySQL.Connected:=true;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('update py_members set codigo2 = '+QuotedStr(Lista[i].codigo2)+' where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.ExecSQL;
  pdata:=EncryptS(Compress(#$03#$00#$00#$00#$00#$00+chr(Length(Lista[i].codigo2))+#$00+Lista[i].codigo2),Lista[i].key);
  Lista[i].socket.SendText(pdata);
  MySQL.Connected:=false;
end;

end.
