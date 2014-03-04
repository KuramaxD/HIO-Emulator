unit Codigo1;

(*

Unit que gera o primeiro código do PangYa.

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

procedure Px10(i: Integer);

implementation

uses main, sockets, database;

procedure Px10(i: Integer);
var
  pdata: AnsiString;
begin
  Lista[i].codigo1:=gerarcodigo;
  MySQL.Connected:=true;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('update py_members set codigo1 = '+QuotedStr(Lista[i].codigo1)+' where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.ExecSQL;
  pdata:=EncryptS(Compress(#$10#$00+chr(Length(Lista[i].codigo1))+#$00+Lista[i].codigo1),Lista[i].key);
  Lista[i].socket.SendText(pdata);
  MySQL.Connected:=false;
end;

end.
