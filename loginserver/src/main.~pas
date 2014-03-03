unit main;

interface

uses Windows, SysUtils, colors, funcoes, crypts, packetprocess, database, sockets;

procedure iniciar();

implementation

procedure iniciar();
begin
  //======================================
  //  PREPARA O SERVIDOR PARA SER LIGADO
  //======================================
  SetConsoleTitle('PY Login GB.R6.726.00');
  Writeln('[SERVER_S] Iniciando servidor.');
  //======================================
  //  ARRUMA AS PROCEDURES DO COMPONENTE
  //======================================
  iniciardatabase('127.0.0.1','root','vertrigo','pangya',3306);
  iniciarsocket(10103);
end;

end.
