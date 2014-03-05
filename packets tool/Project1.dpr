program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {frmain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'HIO-Emulator Packets Tool';
  Application.CreateForm(Tfrmain, frmain);
  Application.Run;
end.
