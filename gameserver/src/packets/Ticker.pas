unit Ticker;

(*

Unit que gerencia o sistema de Ticker do PangYa.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Envia, recebe e checa os status do Ticker.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts, Cookies;

procedure LxChecarTicker(i: Integer);
procedure LxEnviarTicker(data: ansistring; i: integer);

implementation

uses main, sockets, database;

procedure LxChecarTicker(i: Integer);
var
  pdata: ansistring;
  cookies: integer;
begin
  if dbug=1 then debug('Liberando ticker',i);
  MySQL.Connected:=True;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_members where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  cookies:=Query.fieldbyname('cookies').AsInteger;
  if (cookies-300) < 0 then begin
    pdata:=EncryptS(Compress(#$CB#$00#$00#$00#$00#$00#$00#$00),Lista[i].key);
    Lista[i].socket.SendText(pdata);
  end
  else begin
    pdata:=EncryptS(Compress(#$CA#$00#$00#$00#$00#$00#$00#$00),Lista[i].key);
    Lista[i].socket.SendText(pdata);
  end;
  Query.Close;
  MySQL.Connected:=false;
end;

procedure LxEnviarTicker(data: ansistring; i: integer);
var
  pdata, mensagem: ansistring;
  cookies, u: integer;
begin
  if dbug=1 then debug('Enviando ticker',i);
  mensagem:=Copy(data,10,byte(data[8]));
  MySQL.Connected:=True;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_members where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  cookies:=Query.fieldbyname('cookies').AsInteger;
  if (cookies-300) < 0 then begin
    pdata:=EncryptS(Compress(#$CB#$00#$00#$00#$00#$00#$00#$00),Lista[i].key);
    Lista[i].socket.SendText(pdata);
  end
  else begin
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('update py_members set cookies=cookies-300 where uid='+QuotedStr(inttostr(Lista[i].uid))+'');
    Query.ExecSQL;
    for u:=0 to length(Lista)-1 do begin
      if Lista[u].status=True then
        if Lista[u].canal=Lista[i].canal then begin
          pdata:=EncryptS(Compress(#$C9#$00+chr(length(Lista[i].nick))+#$00+Lista[i].nick+chr(Length(mensagem))+#$00+mensagem),Lista[u].key);
          Lista[u].socket.SendText(pdata);
        end;
    end;
    Px150(i);
  end;
  Query.Close;
  MySQL.Connected:=false;
end;

end.
