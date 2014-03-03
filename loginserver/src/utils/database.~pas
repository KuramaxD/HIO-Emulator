unit database;

interface

uses Windows, SysUtils, ZConnection, ZDataset;

var
  MySQL: TZConnection;
  Query: TZQuery;

function iniciardatabase(ipsql, loginsql, senhasql, database: AnsiString; porta: integer): boolean;

implementation

function iniciardatabase(ipsql, loginsql, senhasql, database: AnsiString; porta: integer): boolean;
begin
  MySQL:=TZConnection.Create(nil);
  MySQL.Protocol:='mysql';
  MySQL.User:=loginsql;
  MySQL.Password:=senhasql;
  MySQL.Database:=database;
  MySQL.Catalog:=database;
  MySQL.HostName:=ipsql;
  MySQL.Port:=porta;
  MySQL.AutoCommit:=true;
  Query:=TZQuery.Create(nil);
  Query.Connection:=MySQL;
  try
    MySQL.Connected:=True;
  except
    on E: Exception do begin
      MySQL.Connected:=False;
      writeln('[DB_S] Erro ao iniciar o mysql ('+e.Message+')');
      result:=false;
      exit;
    end;
  end;
  writeln('[DB_S] Database conectada');
  Result:=true;
end;

end.
