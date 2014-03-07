unit KeepAlive;

(*

Unit que faz checagem de conexão.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Serve para checar se o cliente está realmente conectado
e se está pelo cliente original.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure LxSalvarKeepAlive(i: integer);

implementation

uses main, sockets, database;

procedure LxSalvarKeepAlive(i: integer);
var
  time: integer;
begin
  time:=GetTickCount;
  if dbug=1 then debug('Keep Alive '+inttostr(time),i);
  Lista[i].timestamp:=time;
end;

end.
