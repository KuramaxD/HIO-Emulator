program PYLogin;

(*

Projeto principal de loginserver para PangYa.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
É apenas o arquivo de projeto padrão do Delphi 7. Apenas um loop para não fechar o console, e iniciação do servidor pela procedure iniciar();

Referências:
http://rvelthuis.de/programs/console.html

*)

{$APPTYPE CONSOLE}

{$R 'icon.res' 'icon.rc'}

uses
  SysUtils,
  Windows,
  main in 'src\main.pas',
  colors in 'src\etc\colors.pas',
  funcoes in 'src\utils\funcoes.pas',
  crypts in 'src\utils\crypts.pas',
  packetprocess in 'src\packets\packetprocess.pas',
  database in 'src\utils\database.pas',
  sockets in 'src\utils\sockets.pas';

var
  Msg: TMsg;
  bRet: LongBool;

begin
  try
    iniciar;
    repeat
      bRet := GetMessage(Msg, 0, 0, 0);
      if Integer(bRet) = -1 then begin
        Break;
      end
      else begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
    until not bRet;
  except
    on E: Exception do begin
      Writeln(E.Classname, ': ', E.Message);
  end;
end;
end.
