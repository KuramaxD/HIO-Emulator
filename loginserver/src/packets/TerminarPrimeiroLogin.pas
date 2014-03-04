unit TerminarPrimeiroLogin;

(*

Unit que salva os dados no MySQL.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Serve para salvar os dados escolhidos pelo cliente no primeiro
login e enviar o cliente para tela de servidores.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts, Codigo1, CriarMacros, DadosPessoais, Servidores;

procedure LxTerminarPrimeiroLogin(data: ansistring; i: integer);

implementation

uses main, sockets, database;

procedure LxTerminarPrimeiroLogin(data: ansistring; i: integer);
var
  pdata: ansistring;
  personagem, cabelo, cid: integer;
begin
  personagem:=returnsize(copy(data,8,4))-4;
  cabelo:=returnsize(copy(data,12,2))-4;
  MySQL.Connected:=true;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('update py_members set nick = '+QuotedStr(Lista[i].nick)+' where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.ExecSQL;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('insert into py_chars (uid, personagem, cabelo) values ('+QuotedStr(inttostr(Lista[i].uid))+','+QuotedStr(inttostr(personagem))+','+QuotedStr(inttostr(cabelo))+')');
  Query.ExecSQL;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('update py_members set firstset = 1 where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.ExecSQL;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('insert into py_macros (uid) values ('+QuotedStr(inttostr(Lista[i].uid))+')');
  Query.ExecSQL;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_chars where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  cid:=Query.fieldbyName('cid').AsInteger;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('update py_members set personagemselecionado = '+QuotedStr(inttostr(cid))+' where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.ExecSQL;
  pdata:=EncryptS(Compress(#$11#$00#$00),Lista[i].key);
  Px10(i);
  Px06(i);
  Px02(i);
  Px01d(i);
  MySQL.Connected:=false;
end;

end.
