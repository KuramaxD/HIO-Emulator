unit Autenticacao;

(*

Unit que contém a lógica para login.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Serve para checar tudo sobre a conta que esta tentando logar
e decidir o que fazer.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts, packetprocess;

procedure LxAutenticar(data: ansistring; i: integer);

implementation

uses main, sockets, database;

procedure LxAutenticar(data: ansistring; i: integer);
var
  login,code1,versao,code2: ansistring;
  uid: integer;
begin
  if dbug=1 then debug('Autenticando cliente',i);
  login:=copy(data,10,byte(data[8]));
  uid:=returnsize(copy(data,10+byte(data[8]),Lista[i].key))-4;
  code1:=copy(data,22+byte(data[8]),byte(data[20+byte(data[8])]));
  versao:=Copy(data,24+byte(data[8])+byte(data[20+byte(data[8])]),Byte(data[22+byte(data[8])+byte(data[20+byte(data[8])])]));
  code2:=Copy(data,34+byte(data[8])+byte(data[20+byte(data[8])])+Byte(data[22+byte(data[8])+byte(data[20+byte(data[8])])]),Byte(data[32+byte(data[8])+byte(data[20+byte(data[8])])+Byte(data[22+byte(data[8])+byte(data[20+byte(data[8])])])]));
  MySQL.Connected:=True;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_members where login = '+QuotedStr(login)+'');
  Query.Open;
  if (code1=Query.FieldByName('codigo1').AsString) and (code2=Query.FieldByName('codigo2').AsString) and (0=Query.FieldByName('gamestatus').Asinteger) and (uid=Query.FieldByName('uid').Asinteger) then begin
    Lista[i].login:=login;
    Lista[i].uid:=uid;
    Lista[i].nick:=Query.fieldbyname('nick').asstring;
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('update py_members set gamestatus = 1 where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
    Query.ExecSQL;
    Writeln('[SERVER_S] Login permitido');
    teste(i);
  end
  else begin
    TextColor(12);
    Writeln('[SERVER_S] Login nao permitido');
    TextColor(7);
    Lista[i].socket.Close;
  end;
  Query.Close;
  MySQL.Connected:=false;
end;

end.
