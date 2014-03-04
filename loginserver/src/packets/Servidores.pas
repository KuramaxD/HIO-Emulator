unit Servidores;

(*

Unit que contém o pacote de lista de servidores.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Serve para criar o pacote de lista de servidores de acordo com
os servidores listados na database e enviar para o cliente.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure Px02(i: Integer);

implementation

uses main, sockets, database;

procedure Px02(i: Integer);
var
  pdata: AnsiString;
  qt: integer;
begin
  qt:=0;
  MySQL.Connected:=true;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_servers');
  Query.Open;
  while not Query.eof do begin
    qt:=qt+1;
    pdata:=pdata+wrapper(Query.FieldByName('nome').AsString,40)+hextoascii(reversestring(IntToHex(Query.FieldByName('sid').AsInteger,8)))+#$40#$06#$00#$00#$F0#$00#$00#$00+wrapper(Query.FieldByName('ip').AsString,18)+hextoascii(reversestring(IntToHex(Query.FieldByName('porta').AsInteger,8)))+#$00#$00#$00#$00+hextoascii(reversestring(IntToHex(Query.FieldByName('usuariosonline').AsInteger,8)))+#$00#$00#$00#$00#$64#$00#$00#$00+chr(Query.FieldByName('icone').AsInteger)+#$00;
    Query.Next;
  end;
  pdata:=EncryptS(Compress(#$02#$00+chr(qt)+pdata),Lista[i].key);
  Lista[i].socket.SendText(pdata);
  Query.Close;
  MySQL.Connected:=false;
end;

end.
