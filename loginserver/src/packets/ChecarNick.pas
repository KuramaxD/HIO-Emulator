unit ChecarNick;

(*

Unit que verifica o nick recebido.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Roda uma query para saber se o nick já esta sendo usado
ou não.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts, NickDisponivel, NickIndisponivel;

procedure LxChecarNick(data: ansistring; i: integer);

implementation

uses main, sockets, database;

procedure LxChecarNick(data: ansistring; i: integer);
var
  nick: ansistring;
  u: integer;
  existe: Boolean;
begin
  nick:=copy(data,10,byte(data[8]));
  MySQL.Connected:=true;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_members where nick = '+QuotedStr(nick)+'');
  Query.Open;
  if Query.isempty then begin
    existe:=false;
    for u:=0 to Length(Lista)-1 do begin
      if Lista[u].status then
        if Lista[u].nick=nick then
          existe:=True;
    end;
    if existe=False then begin
      Lista[i].nick:=nick;
      Px0Ed(i);
    end
    else Px0Ei(i);
  end
  else begin
    Px0Ei(i);
  end;
  Query.Close;
  MySQL.Connected:=false;
end;

end.
