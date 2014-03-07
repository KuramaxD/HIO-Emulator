unit Calendario;

(*

Unit que contém a lógica para gerenciar o calendário.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Serve para saber se o usuário já marcou presença no dia,
dar prêmios e etc.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure LxEnviarCalendario1(i: integer);
procedure LxEnviarCalendario2(i: integer);

implementation

uses main, sockets, database;

procedure LxEnviarCalendario1(i: integer);
var
  pdata: ansistring;
  diasmarcados, itemdehoje, quantidade, proxitem, proxquantidade: integer;
begin
  if dbug=1 then debug('Enviando calendario',i);
  MySQL.Connected:=True;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_members where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  if 0=Query.FieldByName('calendario').AsInteger then begin
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select * from py_members where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
    Query.Open;
    diasmarcados:=Query.FieldByName('diasmarcados').AsInteger;
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select * from py_calendario where data = CURDATE()');
    Query.Open;
    itemdehoje:=Query.fieldbyname('item').asinteger;
    quantidade:=Query.fieldbyname('quantidade').asinteger;
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select * from py_itens where uid = '+QuotedStr(inttostr(Lista[i].uid))+' and itemid = '+QuotedStr(inttostr(itemdehoje))+'');
    Query.Open;
    if Query.Eof then begin
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('insert into py_itens (uid, itemid, quantidade) values ('+QuotedStr(inttostr(Lista[i].uid))+','+QuotedStr(inttostr(itemdehoje))+','+QuotedStr(inttostr(quantidade))+')');
      Query.ExecSQL;
    end
    else begin
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('update py_itens set quantidade=quantidade+'+QuotedStr(inttostr(quantidade))+' where uid='+QuotedStr(inttostr(Lista[i].uid))+' and itemid='+QuotedStr(inttostr(itemdehoje))+'');
      Query.ExecSQL;
    end;
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('update py_members set calendario=1 where uid='+QuotedStr(inttostr(Lista[i].uid))+'');
    Query.ExecSQL;
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('update py_members set diasmarcados=diasmarcados+1 where uid='+QuotedStr(inttostr(Lista[i].uid))+'');
    Query.ExecSQL;
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select * from py_calendario where data = CURDATE() + INTERVAL 1 DAY');
    Query.Open;
    proxitem:=Query.fieldbyname('item').AsInteger;
    proxquantidade:=Query.fieldbyname('quantidade').AsInteger;
    pdata:=encryptS(compress(#$48#$02#$00#$00#$00#$00#$01+hextoascii(reversestring2(IntToHex(itemdehoje,8)))+hextoascii(reversestring2(IntToHex(quantidade,8)))+hextoascii(reversestring2(IntToHex(proxitem,8)))+hextoascii(reversestring2(IntToHex(proxquantidade,8)))+hextoascii(reversestring2(IntToHex(diasmarcados,8)))),Lista[i].key);
    Lista[i].socket.SendText(pdata);
  end
  else begin
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select * from py_members where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
    Query.Open;
    diasmarcados:=Query.FieldByName('diasmarcados').AsInteger;
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select * from py_calendario where data = CURDATE()');
    Query.Open;
    itemdehoje:=Query.fieldbyname('item').asinteger;
    quantidade:=Query.fieldbyname('quantidade').asinteger;
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select * from py_calendario where data = CURDATE() + INTERVAL 1 DAY');
    Query.Open;
    proxitem:=Query.fieldbyname('item').AsInteger;
    proxquantidade:=Query.fieldbyname('quantidade').AsInteger;
    pdata:=encryptS(compress(#$48#$02#$00#$00#$00#$00#$01+hextoascii(reversestring2(IntToHex(itemdehoje,8)))+hextoascii(reversestring2(IntToHex(quantidade,8)))+hextoascii(reversestring2(IntToHex(proxitem,8)))+hextoascii(reversestring2(IntToHex(proxquantidade,8)))+hextoascii(reversestring2(IntToHex(diasmarcados,8)))),Lista[i].key);
    Lista[i].socket.SendText(pdata);
  end;
  Query.Close;
  MySQL.Connected:=false;
end;

procedure LxEnviarCalendario2(i: integer);
var
  pdata: ansistring;
  diasmarcados, itemdehoje, quantidade, proxitem, proxquantidade: integer;
begin
  if dbug=1 then debug('Enviando calendario',i);
  MySQL.Connected:=true;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_members where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  diasmarcados:=Query.FieldByName('diasmarcados').AsInteger;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_calendario where data = CURDATE()');
  Query.Open;
  itemdehoje:=Query.fieldbyname('item').asinteger;
  quantidade:=Query.fieldbyname('quantidade').asinteger;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_calendario where data = CURDATE() + INTERVAL 1 DAY');
  Query.Open;
  proxitem:=Query.fieldbyname('item').AsInteger;
  proxquantidade:=Query.fieldbyname('quantidade').AsInteger;
  pdata:=EncryptS(Compress(#$47#$02#$00#$00#$00#$00#$01+hextoascii(reversestring2(IntToHex(itemdehoje,8)))+hextoascii(reversestring2(IntToHex(quantidade,8)))+hextoascii(reversestring2(IntToHex(proxitem,8)))+hextoascii(reversestring2(IntToHex(proxquantidade,8)))+hextoascii(reversestring2(IntToHex(diasmarcados,8)))),Lista[i].key);
  Lista[i].socket.sendtext(pdata);
  Query.Close;
  MySQL.Connected:=false;
end;

end.
