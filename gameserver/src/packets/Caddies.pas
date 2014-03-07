unit Caddies;

(*

Unit que gerencia todo o sistema de caddies do jogo.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Envia, renova e gerencia ações dos caddies de cada cliente.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts, iff;

procedure LxEnviarCaddies(i: integer);
procedure LxEnviarAvisodeExpiracao(i: Integer);
procedure LxAvisodeExpiracao(data: ansistring; i: integer);
procedure LxRenovarCaddie(data: ansistring; i: integer);

implementation

uses main, sockets, database;

procedure LxEnviarCaddies(i: integer);
var
  pdata: ansistring;
  quantidade, u, tempo: integer;
begin
  if dbug=1 then debug('Enviando caddies',i);
  MySQL.Connected:=True;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_caddies where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  quantidade:=0;
  while not Query.eof do begin
    tempo:=1;
    for u:=0 to length(iff.Caddies)-1 do begin
      if iff.Caddies[u].id=Query.fieldbyname('caddieid').asinteger then
        if iff.Caddies[u].preco > 0 then begin
          tempo:=2;
          break;
        end;
    end;
    quantidade:=quantidade+1;
    pdata:=pdata+hextoascii(reversestring2(IntToHex(Query.fieldbyname('cid').asinteger,8)))+hextoascii(reversestring2(IntToHex(Query.fieldbyname('caddieid').asinteger,8)))+hextoascii(reversestring2(IntToHex(Query.fieldbyname('skin').asinteger,8)))+chr(Query.fieldbyname('level').asinteger-1)+hextoascii(reversestring2(IntToHex(Query.fieldbyname('exp').asinteger,8)))+chr(tempo)+chr(Query.fieldbyname('dias').asinteger)+#$00+chr(Query.fieldbyname('tempo').asinteger)+#$00#$00+chr(Query.fieldbyname('payday').asinteger)+#$00;
    Query.next;
  end;
  pdata:=EncryptS(Compress(#$71#$00+chr(quantidade)+#$00+chr(quantidade)+#$00+pdata),Lista[i].key);
  Lista[i].socket.SendText(pdata);
  Query.Close;
  MySQL.Connected:=false;
end;

procedure LxEnviarAvisodeExpiracao(i: Integer);
var
  pdata: ansistring;
  quantidade: integer;
begin
  if dbug=1 then debug('Enviando payday',i);
  MySQL.Connected:=True;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_caddies where uid = '+QuotedStr(inttostr(Lista[i].uid))+' and payday = 1 and dias = 0');
  Query.Open;
  quantidade:=0;
  while not Query.eof do begin
    quantidade:=quantidade+1;
    pdata:=pdata+hextoascii(reversestring2(IntToHex(Query.fieldbyname('cid').asinteger,8)))+hextoascii(reversestring2(IntToHex(Query.fieldbyname('caddieid').asinteger,8)))+#$00#$00#$00#$00#$03#$2D#$0A#$00#$00#$02#$00#$00#$00#$00#$00#$01#$00;
    Query.next;
  end;
  pdata:=EncryptS(Compress(#$D4#$00+chr(quantidade)+#$00#$00#$00+pdata),Lista[i].key);
  Lista[i].socket.SendText(pdata);
  Query.Close;
  MySQL.Connected:=false;
end;

procedure LxAvisodeExpiracao(data: ansistring; i: integer);
var
  caddie, payday: integer;
begin
  if dbug=1 then debug('Atualizando payday',i);
  caddie:=returnsize(Copy(data,8,4))-4;
  payday:=byte(data[12]);
  MySQL.Connected:=True;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('update py_caddies set payday='+QuotedStr(inttostr(payday))+' where uid = '+QuotedStr(inttostr(Lista[i].uid))+' and cid = '+QuotedStr(inttostr(caddie))+'');
  Query.ExecSQL;
  MySQL.Connected:=false;
end;

procedure LxRenovarCaddie(data: ansistring; i: integer);
var
  caddie, caddieid, valor, u, pangs: integer;
  pdata: ansistring;
begin
  if dbug=1 then debug('Pagar caddie',i);
  caddieid:=returnsize(Copy(data,8,4))-4;
  valor:=0;
  MySQL.Connected:=True;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_caddies where cid = '+QuotedStr(inttostr(caddieid))+' and uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  caddie:=Query.fieldbyname('caddieid').asinteger;
  if not Query.Eof then begin
    for u:=0 to length(iff.Caddies)-1 do begin
      if iff.Caddies[u].id=caddie then begin
        valor:=iff.Caddies[u].preco;
        Break;
      end;
    end;
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select * from py_members where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
    Query.Open;
    pangs:=Query.fieldbyname('pangs').AsInteger;
    if (pangs-valor) < 0 then begin
      pdata:=EncryptS(Compress(#$93#$00#$04),Lista[i].key);
      Lista[i].socket.SendText(pdata);
    end
    else begin
      pdata:=EncryptS(Compress(#$93#$00#$02+hextoascii(reversestring2(IntToHex(caddieid,8)))+hextoascii(reversestring2(IntToHex((pangs-valor),8)))+#$00#$00#$00),Lista[i].key);
      Lista[i].socket.SendText(pdata);
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('update py_members set pangs = pangs-'+QuotedStr(inttostr(valor))+' where uid='+QuotedStr(inttostr(Lista[i].uid))+'');
      Query.ExecSQL;
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('update py_caddies set dias = dias+30 where cid='+QuotedStr(inttostr(caddieid))+' and uid='+QuotedStr(inttostr(Lista[i].uid))+'');
      Query.ExecSQL;
    end;
  end
  else Lista[i].socket.close;
  Query.Close;
  MySQL.Connected:=false;
end;

end.
