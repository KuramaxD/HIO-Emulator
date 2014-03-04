unit CriarMacros;

(*

Unit que envia o pacote de macros.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Serve para criar o pacote de macros de acordo com os macros
salvos na database e enviar para o cliente.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure Px06(i: Integer);

implementation

uses main, sockets, database;

procedure Px06(i: Integer);
var
  pdata: AnsiString;
  u: integer;
begin
  MySQL.Connected:=true;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_macros where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  pdata:='';
  for u:=1 to 9 do begin
    pdata:=pdata+wrapper(Query.FieldByName('macro'+inttostr(u)).AsString,64);
  end;
  pdata:=EncryptS(Compress(#$06#$00+pdata),Lista[i].key);
  Lista[i].socket.SendText(pdata);
  Query.Close;
  MySQL.Connected:=false;
end;

end.
