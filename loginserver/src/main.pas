unit main;

(*

Unit que contém a função iniciar(); Que serve para ligar o servidor.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Apenas chame a função iniciar(); Ao abrir o programa.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, colors, funcoes, crypts, packetprocess, database, sockets;

procedure iniciar();

implementation

procedure iniciar();
begin
  SetConsoleTitle('HIO-Emulator Login Server');
  Writeln('[SERVER_S] Iniciando servidor.');
  iniciardatabase('127.0.0.1','root','vertrigo','pangya',3306);
  iniciarsocket(10103);
end;

end.
