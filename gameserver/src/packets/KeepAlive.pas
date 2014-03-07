unit KeepAlive;

(*

Unit que faz checagem de conex�o.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do c�digo:
Serve para checar se o cliente est� realmente conectado
e se est� pelo cliente original.

Refer�ncias:
Sem refer�ncias no momento

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
