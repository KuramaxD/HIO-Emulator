program PYGame;

(*

Projeto principal de gameserver para PangYa.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do c�digo:
� apenas o arquivo de projeto padr�o do Delphi 7. Apenas um loop para n�o fechar o console, e inicia��o do
servidor pela procedure iniciar();

Refer�ncias:
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
  sockets in 'src\utils\sockets.pas',
  iff in 'src\utils\iff.pas';

var
  Msg: TMsg;
  bRet: LongBool;

begin
  try
    iniciar;
    SetConsoleCtrlHandler(@onclose, true);
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
