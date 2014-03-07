unit Cookies;

(*

Unit que envia a quantidade de cookies para o servidor.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Cria o pacote 150 que contém a quantidade de cookies do cliente.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure Px150(i: integer);

implementation

uses main, sockets, database;

procedure Px150(i: integer);
var
  pdata: ansistring;
begin
  if dbug=1 then debug('Enviando cookies',i);
  MySQL.Connected:=True;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_members where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  pdata:=EncryptS(Compress(#$96#$00+hextoascii(reversestring2(IntToHex(Query.fieldbyname('cookies').AsInteger,8)))+#$00#$00#$00#$00),Lista[i].key);
  Lista[i].socket.sendtext(pdata);
  Query.Close;
  MySQL.Connected:=false;
end;

end.
