unit packetprocess;

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts, Classes, StrUtils, iff;

procedure criarcanais(i: Integer);
procedure enviarpersonagens(i: integer);
procedure enviarinventorio(i: integer);
procedure teste(i: integer);
procedure teste4(i: integer);
procedure teste5(i: integer);
procedure teste6(i: integer);
procedure x2(i: integer);
procedure enviardiasonline(i: integer);
procedure enviardiasonline2(i: integer);
procedure atualizarbarra(data: AnsiString; i: Integer);
procedure timestamp(i: integer);
procedure liberarticker(i: Integer);
procedure enviarticker(data: ansistring; i: integer);
procedure entrarnolobby(i: integer);
procedure sairdolobby(i: integer);
procedure chat(data: ansistring; i: Integer);
function executarcomando(comando: AnsiString; i: integer): integer;
procedure pm(data: ansistring; i: integer);
procedure enviarmascotes(i: integer);
procedure enviarcaddies(i: integer);
procedure enviarpayday(i: Integer);
procedure atualizarpayday(data: ansistring; i: integer);
procedure pagarcaddie(data: ansistring;i: integer);
procedure atualizar(data: ansistring; i: integer);
procedure myroom(i: Integer);
procedure mainpacket(i: integer);

implementation

uses main, sockets, database;

procedure enviardiasonline(i: integer);
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

procedure enviardiasonline2(i: integer);
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

procedure criarcanais(i: Integer);
var
  pdata: ansistring;
  u, x, online: integer;
begin
  if dbug=1 then debug('Enviando canais',i);
  online:=0;
  for u:=0 to Length(main.canais)-1 do begin
    for x:=0 to Length(Lista)-1 do begin
      if Lista[x].status=true then begin
        if Lista[x].canal=u then online:=online+1;
      end;
    end;
    pdata:=pdata+wrapper(main.canais[u].nome,64)+hextoascii(reversestring2(inttohex(main.canais[i].maxusuarios,4)))+hextoascii(reversestring2(inttohex(online,4)))+chr(u)+#$00+chr(main.canais[i].tipo)+#$00#$00#$00#$00#$00#$00;
  end;
  pdata:=EncryptS(Compress(#$4D#$00+chr(Length(main.canais))+pdata),Lista[i].key);
  Lista[i].socket.SendText(pdata);
end;

procedure enviarpersonagens(i: integer);
var
  pdata: ansistring;
  quantidade, cid: integer;
begin
  if dbug=1 then debug('Enviando personagens',i);
  MySQL.Connected:=True;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_members where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  cid:=Query.FieldByName('personagemselecionado').AsInteger;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_chars where cid = '+QuotedStr(inttostr(cid))+'');
  Query.Open;
  pdata:=pdata+hextoascii(reversestring2(IntToHex(Query.FieldByName('personagem').AsInteger,8)))+hextoascii(reversestring2(IntToHex(cid,8)))+#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$08#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+hextoascii(reversestring2(IntToHex(Query.FieldByName('cabelo').AsInteger,8)))+#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00;
  quantidade:=1;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_chars where uid = '+QuotedStr(IntToStr(Lista[i].uid))+' and cid <> '+quotedstr(IntToStr(cid)));
  Query.Open;
  while not Query.eof do begin
    quantidade:=quantidade+1;
      pdata:=pdata+hextoascii(reversestring2(IntToHex(Query.FieldByName('personagem').AsInteger,8)))+hextoascii(reversestring2(IntToHex(Query.FieldByName('cid').AsInteger,8)))+#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$08#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+hextoascii(reversestring2(IntToHex(Query.FieldByName('cabelo').AsInteger,8)))+#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00;
    Query.Next;
  end;
  pdata:=EncryptS(Compress(#$70#$00#$02#$00+chr(quantidade)+#$00+pdata),Lista[i].key);
  Lista[i].socket.SendText(pdata);
  Query.Close;
  MySQL.Connected:=false;
end;

procedure enviarinventorio(i: integer);
var
  pdata: ansistring;
  quantidade: integer;
begin
  if dbug=1 then debug('Enviando inventorio',i);
  MySQL.Connected:=True;
  quantidade:=1;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_itens where uid = '+QuotedStr(IntToStr(Lista[i].uid))+' and tempo=0');
  Query.Open;
  while not Query.eof do begin
    quantidade:=quantidade+1;
    pdata:=pdata+hextoascii(reversestring2(IntToHex(Query.FieldByName('idi').AsInteger,8)))+hextoascii(reversestring2(IntToHex(Query.FieldByName('itemid').AsInteger,8)))+#$00#$00#$00#$00+hextoascii(reversestring2(IntToHex(Query.FieldByName('quantidade').AsInteger,4)))+#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
    #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
    #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
    #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
    #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
    #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00;
    Query.Next;
  end;
  pdata:=EncryptS(Compress(#$73#$00+hextoascii(reversestring2(IntToHex(quantidade,4)))+hextoascii(reversestring2(IntToHex(quantidade,4)))+pdata),Lista[i].key);
  Lista[i].socket.SendText(pdata);
  Query.Close;
  MySQL.Connected:=false;
end;

procedure barradeselecao(i: integer);
var
  pdata: AnsiString;
  u, cid, tacoid, bolaid, mascoteid, caddie: integer;
  itens: array[1..10] of integer;
begin
  if dbug=1 then debug('Enviando barra de selecao',i);
  MySQL.Connected:=True;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_members where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  tacoid:=Query.FieldByName('taco').AsInteger;
  cid:=Query.FieldByName('personagemselecionado').AsInteger;
  bolaid:=Query.FieldByName('bola').AsInteger;
  mascoteid:=Query.fieldbyname('mascote').asinteger;
  caddie:=Query.fieldbyname('caddie').asinteger;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_itens where idi = '+QuotedStr(inttostr(bolaid))+'');
  Query.Open;
  bolaid:=Query.FieldByName('itemid').AsInteger;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_mochila where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  itens[1]:=Query.fieldbyname('item1').asinteger;
  itens[2]:=Query.fieldbyname('item2').asinteger;
  itens[3]:=Query.fieldbyname('item3').asinteger;
  itens[4]:=Query.fieldbyname('item4').asinteger;
  itens[5]:=Query.fieldbyname('item5').asinteger;
  itens[6]:=Query.fieldbyname('item6').asinteger;
  itens[7]:=Query.fieldbyname('item7').asinteger;
  itens[8]:=Query.fieldbyname('item8').asinteger;
  itens[9]:=Query.fieldbyname('item9').asinteger;
  itens[10]:=Query.fieldbyname('item10').asinteger;
  for u:=1 to 10 do begin
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select * from py_itens where uid = '+QuotedStr(inttostr(Lista[i].uid))+' and idi = '+QuotedStr(inttostr(itens[u]))+'');
    Query.Open;
    itens[u]:=Query.fieldbyname('itemid').asinteger;
  end;
  pdata:=encryptS(compress(#$72#$00+hextoascii(reversestring2(IntToHex(caddie,8)))+hextoascii(reversestring2(IntToHex(cid,8)))+hextoascii(reversestring2(IntToHex(tacoid,8)))+hextoascii(reversestring2(IntToHex(bolaid,8)))+hextoascii(reversestring2(IntToHex(itens[1],8)))+hextoascii(reversestring2(IntToHex(itens[2],8)))+hextoascii(reversestring2(IntToHex(itens[3],8)))+hextoascii(reversestring2(IntToHex(itens[4],8)))+hextoascii(reversestring2(IntToHex(itens[5],8)))+hextoascii(reversestring2(IntToHex(itens[6],8)))+hextoascii(reversestring2(IntToHex(itens[7],8)))+hextoascii(reversestring2(IntToHex(itens[8],8)))+
  hextoascii(reversestring2(IntToHex(itens[9],8)))+hextoascii(reversestring2(IntToHex(itens[10],8)))+#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+hextoascii(reversestring2(IntToHex(mascoteid,8)))),Lista[i].key);
  Lista[i].socket.sendtext(pdata);
  Query.Close;
end;

procedure atualizarbarra(data: AnsiString; i: Integer);
var
  pdata: ansistring;
  personagem, taco, bola, mascote, caddie: integer;
begin
  //barrinha incompleta, precisa de equips
  if dbug=1 then debug('Atualizando barra de selecao',i);
  Writeln(space(stringtohex(data)));
  if byte(data[8])=4 then begin
    personagem:=returnsize(copy(data,9,4))-4;
    MySQL.Connected:=True;
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select * from py_chars where cid = '+QuotedStr(inttostr(personagem))+' and uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
    Query.Open;
    if not Query.Eof then begin
      pdata:=EncryptS(Compress(#$4B#$00#$04+hextoascii(reversestring2(IntToHex(i,8)))+hextoascii(reversestring2(IntToHex(Query.fieldbyname('personagem').AsInteger,8)))+hextoascii(reversestring2(IntToHex(personagem,8)))+#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$10#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key);
      Lista[i].socket.SendText(pdata);
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('update py_members set personagemselecionado = '+QuotedStr(inttostr(personagem))+' where uid='+QuotedStr(inttostr(Lista[i].uid))+'');
      Query.ExecSQL;
    end
    else Lista[i].socket.close;
    Query.Close;
    MySQL.Connected:=false;
  end;
  if byte(data[8])=2 then begin
    bola:=returnsize(copy(data,9,4))-4;
    MySQL.Connected:=True;
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select * from py_itens where itemid = '+QuotedStr(inttostr(bola))+' and uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
    Query.Open;
    if not Query.Eof then begin
      pdata:=EncryptS(Compress(#$4B#$00#$02+hextoascii(reversestring2(IntToHex(i,8)))+hextoascii(reversestring2(IntToHex(bola,8)))),Lista[i].key);
      Lista[i].socket.SendText(pdata);
      bola:=Query.fieldbyname('idi').asinteger;
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('update py_members set bola = '+QuotedStr(inttostr(bola))+' where uid='+QuotedStr(inttostr(Lista[i].uid))+'');
      Query.ExecSQL;
    end
    else Lista[i].socket.close;
    Query.Close;
    MySQL.Connected:=false;
  end;
  if byte(data[8])=3 then begin
    taco:=returnsize(copy(data,9,4))-4;
    MySQL.Connected:=True;
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select * from py_itens where idi = '+QuotedStr(inttostr(taco))+' and uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
    Query.Open;
    if not Query.Eof then begin
      pdata:=EncryptS(Compress(#$4B#$00#$03+hextoascii(reversestring2(IntToHex(i,8)))+hextoascii(reversestring2(IntToHex(taco,8)))+hextoascii(reversestring2(IntToHex(Query.fieldbyname('itemid').AsInteger,8)))+#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$BA#$0D#$E0#$80#$82#$7C#$00#$00#$E2#$00),Lista[i].key);
      Lista[i].socket.SendText(pdata);
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('update py_members set taco = '+QuotedStr(inttostr(taco))+' where uid='+QuotedStr(inttostr(Lista[i].uid))+'');
      Query.ExecSQL;
    end
    else Lista[i].socket.close;
    Query.Close;
    MySQL.Connected:=false;
  end;
  if byte(data[8])=5 then begin
    mascote:=returnsize(copy(data,9,4))-4;
    MySQL.Connected:=True;
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select * from py_mascots where mid = '+QuotedStr(inttostr(mascote))+' and uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
    Query.Open;
    if (not Query.Eof) or (mascote=0) then begin
      pdata:=EncryptS(Compress(#$4B#$00#$05+hextoascii(reversestring2(IntToHex(i,8)))+hextoascii(reversestring2(IntToHex(mascote,8)))+hextoascii(reversestring2(IntToHex(Query.fieldbyname('mascoteid').AsInteger,8)))+#$00#$00#$00#$00#$00+wrapper(Query.fieldbyname('mensagem').asstring,30)+hextoascii(reversestring2(IntToHex(Query.fieldbyname('dias').AsInteger,4)))+gerardataatual(Query.fieldbyname('tempo').AsString)+#$00),Lista[i].key);
      Lista[i].socket.SendText(pdata);
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('update py_members set mascote = '+QuotedStr(inttostr(mascote))+' where uid='+QuotedStr(inttostr(Lista[i].uid))+'');
      Query.ExecSQL;
    end
    else Lista[i].socket.close;
    Query.Close;
    MySQL.Connected:=false;
  end;
  if byte(data[8])=1 then begin
    caddie:=returnsize(copy(data,9,4))-4;
    MySQL.Connected:=True;
    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('select * from py_caddies where cid = '+QuotedStr(inttostr(caddie))+' and uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
    Query.Open;
    if (not Query.Eof) or (caddie=0) then begin
      pdata:=EncryptS(Compress(#$4B#$00#$01+hextoascii(reversestring2(IntToHex(i,8)))+hextoascii(reversestring2(IntToHex(caddie,8)))+hextoascii(reversestring2(IntToHex(Query.fieldbyname('caddieid').AsInteger,8)))+#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key);
      Lista[i].socket.SendText(pdata);
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('update py_members set caddie = '+QuotedStr(inttostr(caddie))+' where uid='+QuotedStr(inttostr(Lista[i].uid))+'');
      Query.ExecSQL;
    end
    else Lista[i].socket.close;
    Query.Close;
    MySQL.Connected:=false;
  end;
end;

procedure timestamp(i: integer);
var
  time: integer;
begin
  time:=GetTickCount;
  if dbug=1 then debug('Timestamp '+inttostr(time),i);
  Lista[i].timestamp:=time;
end;

procedure enviarcookies(i: integer);
var
  pdata: ansistring;
begin
  if dbug=1 then debug('Enviando cookies',i);
  MySQL.Connected:=True;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_members where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  pdata:=EncryptS(Compress(#$96#$00+hextoascii(reversestring2(IntToHex(Query.fieldbyname('cookies').AsInteger,8)))+#$00#$00#$00#$00),Lista[i].key);
  Lista[i].socket.sendtext(pdata);
  Query.Close;
  MySQL.Connected:=false;
end;

procedure liberarticker(i: Integer);
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

procedure enviarticker(data: ansistring; i: integer);
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
    enviarcookies(i);
  end;
  Query.Close;
  MySQL.Connected:=false;
end;

procedure entrarnolobby(i: integer);
var
  pdata: ansistring;
  u, qt: integer;
begin
  if dbug=1 then debug('Entrando no lobby',i);
  if Lista[i].lobby=false and (Lista[i].sala=-1) then begin
    Lista[i].lobby:=true;
    for u:=0 to Length(Lista)-1 do begin
      if Lista[u].status then
        if Lista[u].canal=Lista[i].canal then
          if Lista[u].lobby=true then
            if i <> u then begin
            pdata:=hextoascii(reversestring2(IntToHex(Lista[i].uid,8)))+hextoascii(reversestring2(IntToHex(i,8)))+#$ff#$ff+wrapper(Lista[i].nick,15)+#$00#$00#$00#$00#$00#$00#$00#$05#$00#$00#$00#$00#$00+
#$00#$00#$00#$E8#$03#$00#$00#$00#$00#$00#$00#$00#$38#$64#$61#$35#$35#$63#$34#$30#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00;
            Lista[u].socket.SendText(EncryptS(Compress(#$46#$00#$03#$01+pdata),Lista[u].key));
          end;
    end;

    qt:=0;
    pdata:='';

  for u:=0 to Length(Lista)-1 do begin
    if Lista[u].status then
      if Lista[u].canal=Lista[i].canal then
        if Lista[u].lobby=true then begin
          qt:=qt+1;                                                                                                 {jogando}
        pdata:=pdata+hextoascii(reversestring2(IntToHex(Lista[u].uid,8)))+hextoascii(reversestring2(IntToHex(u,8)))+#$ff#$ff+wrapper(Lista[u].nick,15)+#$00#$00#$00#$00#$00#$00#$00#$25#$00#$00#$00#$00#$07+
#$01#$80#$39#$E8#$03#$00#$00#$10#$00#$00#$00#$00#$38#$64#$61#$35#$35#$63#$34#$30#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00;
    end;
  end;

  for u:=0 to Length(Lista)-1 do begin
    if Lista[u].status then
      if Lista[u].canal=Lista[i].canal then
        if Lista[u].lobby=true then begin
          Lista[u].socket.SendText(EncryptS(Compress(#$46#$00#$04+chr(qt)+pdata),Lista[u].key));
        end;
  end;


Lista[i].socket.sendtext(EncryptS(Compress(#$47#$00#$00#$00#$FF#$FF),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$F5#$00),Lista[i].key));

  end
  else begin
    Lista[i].socket.close;
  end;
end;

procedure sairdolobby(i: integer);
var
  pdata: ansistring;
  u: integer;
begin
  if dbug=1 then debug('Saindo do lobby',i);
  if Lista[i].lobby=true and (Lista[i].sala=-1) then begin
    for u:=0 to Length(Lista)-1 do begin
      if Lista[u].status then
        if Lista[u].canal=Lista[i].canal then
          if (Lista[u].lobby=true) then begin
            pdata:=hextoascii(reversestring2(IntToHex(Lista[i].uid,8)))+hextoascii(reversestring2(IntToHex(i,8)))+#$11#$00+wrapper(Lista[i].nick,15)+#$00#$00#$00#$00#$00#$00#$00#$25#$00#$00#$00#$00#$1E+
#$00#$80#$39#$E8#$03#$00#$00#$12#$1D#$07#$00#$00#$38#$64#$61#$35#$35#$63#$34#$30#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00;
            Lista[u].socket.SendText(EncryptS(Compress(#$46#$00#$02#$01+pdata),Lista[u].key));
          end;
    end;

    pdata:=EncryptS(Compress(#$F6#$00),Lista[i].key);
    Lista[i].socket.sendtext(pdata);
    Lista[i].lobby:=false;
  end
  else begin
    Lista[i].socket.close;
  end;
end;

procedure chat(data: ansistring; i: Integer);
var
  pdata, mensagem, nick: AnsiString;
  u: integer;
begin
  if dbug=1 then debug('Chat',i);
  nick:=copy(data,10,byte(data[8]));
  mensagem:=copy(data,12+byte(data[8]),byte(data[10+byte(data[8])]));
  if (Lista[i].lobby=true) and (Lista[i].canal<>-1) then begin
    if Lista[i].nick=nick then begin
      if Copy(mensagem,1,1)<>'!' then begin
        for u:=0 to Length(Lista)-1 do begin
          if Lista[u].status=true then
            if Lista[u].canal=Lista[i].canal then
              if (Lista[u].lobby=true) and (Lista[u].sala=-1) then begin
                pdata:=EncryptS(Compress(#$40#$00#$00+chr(Length(nick))+#$00+nick+chr(length(mensagem))+#$00+mensagem),Lista[u].key);
                Lista[u].socket.SendText(pdata);
              end;
            //ainda não envia pra salas e pratice
        end;
      end
      else begin
        pdata:=EncryptS(Compress(#$40#$00#$00+chr(Length(nick))+#$00+nick+chr(length(mensagem))+#$00+mensagem),Lista[i].key);
        Lista[i].socket.SendText(pdata);
        TextColor(12);
        Writeln('[ATENCAO] Comando de GM recebido de: '+Lista[i].login);
        TextColor(7);
        nick:='Servidor';
        if executarcomando(mensagem,i)=1 then begin
          mensagem:='Comando executado com sucesso!';
          TextColor(12);
          Writeln('[ATENCAO] Comando permitido! ('+Lista[i].login+')');
          TextColor(7);
        end
        else begin
          if executarcomando(mensagem,i)=2 then begin
            mensagem:='Comando nao encontrado!';
            TextColor(12);
            Writeln('[ATENCAO] Comando nao encontrado! ('+Lista[i].login+')');
            TextColor(7);
          end
          else begin
            mensagem:='Voce nao possui privilegios para usar esse comando!';
            TextColor(12);
            Writeln('[ATENCAO] Comando nao permitido! ('+Lista[i].login+')');
            TextColor(7);
          end;
        end;
        pdata:=EncryptS(Compress(#$40#$00#$00+chr(Length(nick))+#$00+nick+chr(length(mensagem))+#$00+mensagem),Lista[i].key);
        Lista[i].socket.SendText(pdata);
      end;
    end
    else
      Lista[i].socket.close;
  end
  else
    Lista[i].socket.close;
end;

function executarcomando(comando: AnsiString; i: integer): integer;
var
  s: tstringlist;
  pdata: ansistring;
begin
  MySQL.Connected:=True;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_members where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  if Query.FieldByName('gm').asinteger=1 then begin
    comando:=copy(comando,2,length(comando))+#$20;
    s:=tstringlist.create;
    extractstrings([#$20],[' '],pchar(comando),s);
    case AnsiIndexStr(s.strings[0], ['cookies','item']) of
      0: begin
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add('update py_members set cookies='+QuotedStr(s.Strings[1])+' where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
        Query.ExecSQL;
        enviarcookies(i);
        result:=1;
      end;
      1: begin
        writeln(s.strings[1]);
        pdata:=EncryptS(Compress(#$73#$00#$19#$00#$01#$00+hextoascii(reversestring2(IntToHex(strtoint(s.Strings[1])+1,8)))+hextoascii(reversestring2(IntToHex(strtoint(s.Strings[1]),8)))+#$00#$00#$00#$00#$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
        #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
        #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
        #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
        #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
        #$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key);
        Lista[i].socket.SendText(pdata);
        result:=1;
      end;
    else
      result:=2;
    end;
    s.Free;
  end
  else result:=3;
  Query.Close;
  MySQL.Connected:=false;
end;

procedure pm(data: ansistring; i: integer);
var
  pdata, mensagem, nick: ansistring;
  u: integer;
  enviado: Boolean;
begin
  if dbug=1 then debug('PM',i);
  enviado:=false;
  nick:=copy(data,10,byte(data[8]));
  mensagem:=copy(data,12+byte(data[8]),byte(data[10+byte(data[8])]));
  if (Lista[i].lobby=true) and (Lista[i].canal<>-1) then begin
    for u:=0 to Length(Lista)-1 do begin
      if Lista[u].status=true then
        if Lista[u].canal<>-1 then
          if Lista[u].nick=nick then begin
            pdata:=EncryptS(Compress(#$84#$00#$00+chr(length(Lista[i].nick))+#$00+Lista[i].nick+chr(length(mensagem))+#$00+mensagem),Lista[u].key);
            Lista[u].socket.SendText(pdata);
            pdata:=EncryptS(Compress(#$84#$00#$00+chr(length(Lista[u].nick))+#$00+Lista[u].nick+chr(length(mensagem))+#$00+mensagem),Lista[i].key);
            Lista[i].socket.SendText(pdata);
            enviado:=true;
            break;
          end;
    end;
    if enviado=false then begin
      pdata:=EncryptS(Compress(#$40#$00#$05+chr(length(nick))+#$00+nick+#$00#$00),Lista[i].key);
      Lista[i].socket.SendText(pdata);
    end;
  end
  else
    Lista[i].socket.close;
end;

procedure enviarmascotes(i: integer);
var
  pdata: ansistring;
  quantidade: integer;
begin
  if dbug=1 then debug('Enviando mascotes',i);
  MySQL.Connected:=True;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_mascots where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  quantidade:=0;
  while not Query.eof do begin
    quantidade:=quantidade+1;
    pdata:=pdata+hextoascii(reversestring2(IntToHex(Query.fieldbyname('mid').asinteger,8)))+hextoascii(reversestring2(IntToHex(Query.fieldbyname('mascoteid').asinteger,8)))+wrapper('',35)+hextoascii(reversestring2(IntToHex(Query.fieldbyname('dias').AsInteger,4)))+gerardataatual(Query.fieldbyname('tempo').AsString)+#$00;
    Query.next;
  end;
  pdata:=EncryptS(Compress(#$E1#$00+chr(quantidade)+pdata),Lista[i].key);
  Lista[i].socket.SendText(pdata);
  Query.Close;
  MySQL.Connected:=false;
end;

procedure enviarcaddies(i: integer);
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
    for u:=0 to length(Caddies)-1 do begin
      if Caddies[u].id=Query.fieldbyname('caddieid').asinteger then
        if Caddies[u].preco > 0 then begin
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

procedure enviarpayday(i: Integer);
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

procedure atualizarpayday(data: ansistring; i: integer);
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

procedure pagarcaddie(data: ansistring; i: integer);
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
    for u:=0 to length(Caddies)-1 do begin
      if Caddies[u].id=caddie then begin
        valor:=Caddies[u].preco;
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

procedure atualizar(data: ansistring; i: integer);
var
  pdata: ansistring;
  itensx: array[1..10] of integer;
  u, z, id, pos, posid: integer;
  valido: Boolean;
begin
  writeln(space(stringtohex(data)));
  MySQL.Connected:=True;
  if byte(data[8])=2 then begin
    if dbug=1 then debug('Atualizando itens ativos',i);
    valido:=false;
    pos:=0;
    z:=9;
    while z <= Length(data) do begin
      pos:=pos+1;
      id:=returnsize(Copy(data,z,4))-4;
      for u:=0 to Length(Itens)-1 do begin
        if (Itens[u].id=id) or (id=0) then valido:=true;
      end;
      if valido=false then begin
        Lista[i].socket.Close;
        break;
      end
      else begin
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add('select * from py_itens where itemid = '+QuotedStr(inttostr(id))+' and uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
        Query.Open;
        if (not Query.eof) or (id=0) then begin
          itensx[pos]:=id;
          posid:=Query.fieldbyname('idi').asinteger;
          Query.Close;
          Query.SQL.Clear;
          Query.SQL.Add('update py_mochila set item'+inttostr(pos)+'='+QuotedStr(inttostr(posid))+' where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
          Query.ExecSQL;
        end
        else begin
          Lista[i].socket.close;
          break;
        end;
      end;
      z:=z+4;
    end;
    pdata:=EncryptS(Compress(#$6B#$00#$04#$02+hextoascii(reversestring2(IntToHex(itensx[1],8)))+hextoascii(reversestring2(IntToHex(itensx[2],8)))+hextoascii(reversestring2(IntToHex(itensx[3],8)))+hextoascii(reversestring2(IntToHex(itensx[4],8)))+hextoascii(reversestring2(IntToHex(itensx[5],8)))+hextoascii(reversestring2(IntToHex(itensx[6],8)))+hextoascii(reversestring2(IntToHex(itensx[7],8)))+hextoascii(reversestring2(IntToHex(itensx[8],8)))+hextoascii(reversestring2(IntToHex(itensx[9],8)))+hextoascii(reversestring2(IntToHex(itensx[10],8)))),Lista[i].key);
    Lista[i].socket.SendText(pdata);
  end;
  Query.Close;
  MySQL.Connected:=false;
end;

procedure myroom(i: Integer);
var
  cid: integer;
begin
  if dbug=1 then debug('Acessando My Room',i);
  MySQL.Connected:=True;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_members where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  cid:=Query.fieldbyname('personagemselecionado').asinteger;

{Lista[i].socket.sendtext(EncryptS(Compress(#$6B#$00#$04#$02#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key));}

Lista[i].socket.sendtext(EncryptS(Compress(#$6B#$00#$04#$09+hextoascii(reversestring2(IntToHex(cid,8)))+#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key));

{Lista[i].socket.sendtext(EncryptS(Compress(#$6B#$00#$04#$02#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key));}

//Lista[i].socket.sendtext(EncryptS(Compress(#$70#$01#$00#$00#$00#$00#$4C#$00#$00#$00),Lista[i].key));

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_chars where cid = '+QuotedStr(inttostr(cid))+'');
  Query.Open;
Lista[i].socket.sendtext(EncryptS(Compress(#$68#$01+hextoascii(reversestring2(IntToHex(i,8)))+wrapper(Lista[i].nick,39)+#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$04#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$08#$00+
#$05#$00#$0A#$00#$00#$00#$00#$67#$75#$69#$6C#$64#$6D#$61#$72#$6B#$00#$00#$00#$74#$24#$14#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$8E#$10#$C0#$C3#$57#$62#$69#$C4#$C2#$6C#$20#$3F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$70#$61#$6E#$67#$73#$6B#$75#$72#$61#$6D#$61#$40#$4E#$54#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
hextoascii(reversestring2(IntToHex(Query.fieldbyname('personagem').AsInteger,8)))+hextoascii(reversestring2(IntToHex(cid,8)))+#$00#$04#$00#$08#$00#$00#$00#$00#$00#$44#$00#$08#$00#$64#$00#$08#$00#$84#$00#$08+
#$00#$A4#$00#$08#$00#$00#$00#$00#$00#$E4#$00#$08#$00#$04#$01#$08#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$2D#$01#$01#$00#$00#$00#$03#$00#$65#$2B#$22#$00#$20#$68#$00#$48#$00#$00#$33#$33#$73#$41#$00#$00#$00#$00#$00#$00+
#$48#$41#$00#$00#$18#$43#$00#$64#$2B#$22#$00#$1D#$50#$00#$48#$00#$00#$00#$00#$62#$41#$00#$00#$80#$3F#$9E#$EF#$27+
#$3D#$00#$00#$00#$00#$00#$63#$2B#$22#$00#$14#$00#$00#$48#$00#$00#$C3#$F5#$28#$BF#$00#$00#$80#$3F#$5C#$8F#$72#$41+
#$00#$00#$00#$00#$00),Lista[i].key));
  Query.Close;
  MySQL.Connected:=false;
end;

procedure mainpacket(i: integer);
var
  pdata, datas: ansistring;
  idmascote, diasmascote: integer;
begin
  if dbug=1 then debug('Enviando main packet',i);
  MySQL.Connected:=True;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select mascote from py_members where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  idmascote:=Query.fieldbyname('mascote').asinteger;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_mascots where mid = '+QuotedStr(inttostr(idmascote))+'');
  Query.Open;
  diasmascote:=Query.fieldbyname('dias').asinteger;
  datas:=Query.fieldbyname('tempo').asstring;
  pdata:=EncryptS(Compress(#$44#$00#$00#$06#$00#$37#$32#$36#$2E#$30#$30#$19#$00#$67#$61#$6D#$65#$73#$65#$72#$76#$65#$72#$5F#$52#$65#$6C#$65+
#$61#$73#$65#$5F#$47#$42#$2E#$65#$78#$65#$FF#$FF#$70#$61#$6E#$67#$73#$6B#$75#$72#$61#$6D#$61#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00+wrapper(Lista[i].nick,39)+#$67#$75#$69#$6C#$64#$6D#$61#$72#$6B#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+hextoascii(reversestring2(IntToHex(i,8)))+#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$80#$00#$FF#$FF#$FF#$FF#$FF#$FF#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$70#$61#$6E#$67#$73#$6B#$75#$72#$61#$6D#$61#$40#$4E#$54#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$74#$24#$14#$00#$F8#$00#$00+
#$00#$3E#$00#$00#$00#$56#$15#$00#$00#$DD#$0F#$00#$00#$F9#$14#$8D#$43#$BA#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$55#$9C#$00#$00#$5D#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$1F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$3E+
#$00#$00#$00#$50#$C2#$70#$40#$13#$C4#$4E#$41#$47#$00#$00#$00#$46#$60#$FF#$D3#$3A#$00#$00#$00#$00#$00#$00#$00#$00+
#$7F#$7F#$7F#$7F#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$1D#$00+
#$00#$00#$09#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$E8#$03#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$10#$00#$00#$00#$15#$00#$00#$00#$03#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$23#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00+//caddie selecionado, itens
#$02#$00#$00#$00#$45#$12#$E3#$05#$00#$00#$00#$14#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$0D+
#$75#$00#$01#$00#$00#$00#$08#$C4#$E7#$1D#$00#$00#$00#$00#$48#$00#$2E#$01#$38#$B0#$AA#$0C#$C9#$9D#$82#$7C#$C8#$7F+
#$81#$00#$0F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$01#$00#$00#$E2#$00#$78#$AD#$AA#$0C#$B4#$AF#$AA#$0C#$F8#$E6+
#$79#$00#$FF#$FF#$FF#$FF#$C0#$AF#$AA#$0C#$AB#$85#$40#$00#$7F#$00#$00#$00#$2E#$8F#$AD#$2B#$50#$00#$00#$00#$D8#$6B+
#$02#$15#$00#$00#$00#$00#$20#$C4#$E7#$1D#$D8#$6B#$ED#$15#$98#$AF#$AA#$0C#$D8#$6B#$ED#$15#$50#$00#$00#$00#$DC#$AF+
#$AA#$7F#$7D#$A6#$40#$00#$20#$C4#$E7#$1D#$60#$C7#$E7#$1D#$50#$03#$00#$00#$C8#$6B#$ED#$15#$A8#$D2#$8F#$00#$90#$D2+
#$8F#$00#$0C#$B0#$AA#$0C#$E5#$4E#$5F#$00#$8C#$B0#$AA#$0C#$00#$00#$7F#$00#$FF#$FF#$FF#$FF#$E2#$90#$AD#$2B#$D8#$6B+
#$ED#$15#$04#$6B#$ED#$15#$C8#$6B#$ED#$15#$40#$B0#$AA#$0C#$A8#$D2#$8F#$00#$00#$00#$E2#$00#$48#$00#$2E#$01#$4C#$B0+
#$AA#$0C#$92#$7F#$5F#$00#$90#$D2#$8F#$00#$A2#$90#$01#$00#$68#$AF#$AA#$05#$0F#$00#$00#$00#$B4#$B8#$AA#$0C#$E0#$80+
#$82#$7C#$D0#$9D#$82#$7C#$FF#$FF#$FF#$FF#$C9#$9D#$82#$7C#$BD#$19#$75#$00#$7F#$00#$E2#$00#$00#$00#$00#$00#$60#$C7+
#$E7#$1D#$C0#$B8#$06#$0C#$A1#$64#$5F#$00#$60#$C7#$E7#$1D#$2E#$98#$AD#$2B#$DC#$D2#$8F#$00#$04#$00#$00#$00#$D0#$64+
#$5F#$00#$30#$D2#$8F#$7F#$91#$82#$F2#$52#$00#$00#$00#$00#$84#$B0#$AA#$0C#$8C#$07#$AA#$0C#$04#$00#$00#$00#$48#$EB+
#$7D#$00#$91#$82#$F2#$52#$00#$00#$00#$00#$00#$C7#$E7#$1D#$8A#$91#$6E#$00#$5E#$90#$7F#$2B#$04#$B9#$AA#$0C#$00#$00+
#$00#$00#$0F#$00#$00#$00#$08#$B8#$AA#$0C#$A8#$EB#$7D#$00#$31#$09#$44#$6F#$6C#$66#$69#$6E#$69#$09#$30#$09#$5B#$4E+
#$5F#$4C#$4F#$47#$49#$4E#$5D#$7F#$4C#$6F#$67#$49#$6E#$50#$72#$6F#$63#$65#$73#$73#$20#$09#$20#$43#$4F#$4D#$50#$4C+
#$41#$54#$45#$20#$3A#$20#$47#$55#$49#$44#$28#$31#$30#$37#$29#$2C#$20#$43#$6F#$75#$6E#$74#$7F#$33#$32#$29#$2C#$20+
#$43#$6D#$64#$49#$44#$28#$32#$31#$0A#$0A#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$0B#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$0C#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$0D#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$0E#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$0F+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$10#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$11#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$12#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$13#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$14#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$01#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$02#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$03#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$04#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$05#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$06#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$07#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$08#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$09#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$0A#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$0B#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$0C#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$0D#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$0E#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$0F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$10#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$11#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$12#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$13#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$14#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$04#$28#$ED#$15#$00#$00#$04#$00#$08#$00#$00#$00#$00+
#$00#$44#$00#$08#$00#$64#$00#$08#$00#$84#$00#$08#$00#$A4#$00#$08#$00#$00#$00#$00#$00#$E4#$00#$08#$00#$04#$01#$08+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$07#$00#$00#$00+
#$10#$00#$00#$1C#$03#$00#$00#$22#$00#$00#$00#$00#$00#$02#$1E#$00#$18#$00#$00#$00#$00#$E0#$A5#$3E#$03#$0E#$00#$00+
#$10#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$08#$00#$09#$00#$08#$00#$03#$00#$03#$00#$03#$00#$00#$00#$02#$00#$00+
#$40#$00#$00#$00#$00#$00#$50#$61#$6E#$67#$79#$61#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00+hextoascii(reversestring2(IntToHex(diasmascote,4)))+gerardataatual('')+#$00+
gerardataatual('')+hextoascii(reversestring2(IntToHex(idmascote,8)))+#$FF#$FF#$FF#$FF#$FF#$FF#$00#$00#$00#$00#$00+
#$00#$00#$00#$09#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key);
  Lista[i].socket.sendtext(pdata);
  Query.Close;
  MySQL.Connected:=false;
end;

procedure teste(i: Integer);
var
  pdata: ansistring;
begin
  Lista[i].socket.SendText(encryptS(compress(#$A9#$01#$01#$10#$27#$00#$00),Lista[i].key));

  Lista[i].socket.sendtext(EncryptS(Compress(#$44#$00#$D3#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$44#$00#$D2#$01#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$44#$00#$D2#$03#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$44#$00#$D2#$09#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$44#$00#$D2#$07#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$44#$00#$D2#$0B#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$44#$00#$D2#$0D#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$44#$00#$D2#$12#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$44#$00#$D2#$14#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$1F#$01#$00#$01#$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$95#$01#$00#$12#$00#$00#$00#$00#$00#$59#$01#$00#$00#$91#$00#$00#$00#$BA#$00#$00#$00#$9A#$00#$00#$00#$00#$00#$00+
#$00#$86#$00#$00#$00#$18#$FF#$FF#$FF#$E2#$12#$13#$00#$00#$00#$00#$00#$00#$06#$00#$00#$04#$00#$01#$01#$D4#$00#$00+
#$00#$5C#$00#$00#$00#$6C#$00#$00#$00#$5D#$00#$00#$00#$00#$00#$00#$00#$54#$00#$00#$00#$8E#$FF#$FF#$FF#$E4#$B9#$12+
#$00#$00#$00#$00#$00#$00#$05#$00#$00#$04#$00#$02#$02#$C5#$00#$00#$00#$59#$00#$00#$00#$63#$00#$00#$00#$4B#$00#$00+
#$00#$00#$00#$00#$00#$55#$00#$00#$00#$95#$FF#$FF#$FF#$E9#$06#$0C#$00#$00#$00#$00#$00#$00#$08#$00#$00#$04#$00#$03+
#$03#$B5#$00#$00#$00#$41#$00#$00#$00#$54#$00#$00#$00#$39#$00#$00#$00#$00#$00#$00#$00#$3C#$00#$00#$00#$A9#$FF#$FF+
#$FF#$E9#$B2#$0F#$00#$00#$00#$00#$00#$00#$08#$00#$00#$04#$00#$04#$04#$7E#$00#$00#$00#$3E#$00#$00#$00#$3F#$00#$00+
#$00#$29#$00#$00#$00#$00#$00#$00#$00#$39#$00#$00#$00#$CA#$FF#$FF#$FF#$E7#$7B#$11#$00#$00#$00#$00#$00#$00#$04#$00+
#$00#$04#$00#$05#$05#$16#$01#$00#$00#$7D#$00#$00#$00#$96#$00#$00#$00#$67#$00#$00#$00#$00#$00#$00#$00#$70#$00#$00+
#$00#$5A#$FF#$FF#$FF#$E2#$2D#$16#$00#$00#$00#$00#$00#$00#$08#$00#$00#$04#$00#$06#$06#$DD#$01#$00#$00#$0B#$01#$00+
#$00#$0D#$01#$00#$00#$ED#$00#$00#$00#$00#$00#$00#$00#$E4#$00#$00#$00#$7C#$FF#$FF#$FF#$E7#$BF#$0F#$00#$00#$00#$00+
#$00#$00#$08#$00#$00#$04#$00#$07#$07#$98#$00#$00#$00#$2E#$00#$00#$00#$48#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00+
#$00#$29#$00#$00#$00#$A9#$FF#$FF#$FF#$E4#$7E#$1A#$00#$00#$00#$00#$00#$00#$04#$00#$00#$04#$00#$08#$08#$44#$01#$00+
#$00#$98#$00#$00#$00#$B4#$00#$00#$00#$6E#$00#$00#$00#$00#$00#$00#$00#$8A#$00#$00#$00#$19#$FF#$FF#$FF#$E0#$EF#$1D+
#$00#$00#$00#$00#$00#$00#$02#$00#$00#$04#$00#$09#$09#$A2#$00#$00#$00#$3D#$00#$00#$00#$51#$00#$00#$00#$26#$00#$00+
#$00#$00#$00#$00#$00#$3A#$00#$00#$00#$9F#$FF#$FF#$FF#$E7#$2F#$15#$00#$00#$00#$00#$00#$00#$00#$00#$00#$04#$00#$0A+
#$0A#$9E#$00#$00#$00#$46#$00#$00#$00#$5A#$00#$00#$00#$40#$00#$00#$00#$00#$00#$00#$00#$43#$00#$00#$00#$7E#$FF#$FF+
#$FF#$E2#$B1#$14#$00#$00#$00#$00#$00#$00#$08#$00#$00#$04#$00#$0B#$0B#$E7#$00#$00#$00#$52#$00#$00#$00#$7E#$00#$00+
#$00#$45#$00#$00#$00#$00#$00#$00#$00#$4E#$00#$00#$00#$51#$FF#$FF#$FF#$E0#$E2#$17#$00#$00#$00#$00#$00#$00#$08#$00+
#$00#$04#$00#$0D#$0D#$B1#$02#$00#$00#$55#$01#$00#$00#$6A#$01#$00#$00#$B1#$00#$00#$00#$00#$00#$00#$00#$37#$01#$00+
#$00#$B5#$FE#$FF#$FF#$E9#$FD#$11#$00#$00#$00#$00#$00#$00#$08#$00#$00#$04#$00#$0E#$0E#$B4#$02#$00#$00#$8C#$01#$00+
#$00#$C4#$01#$00#$00#$16#$01#$00#$00#$00#$00#$00#$00#$57#$01#$00#$00#$B5#$FD#$FF#$FF#$DA#$06#$1A#$00#$00#$00#$00+
#$00#$00#$06#$00#$00#$04#$00#$0F#$0F#$D8#$00#$00#$00#$61#$00#$00#$00#$7E#$00#$00#$00#$4B#$00#$00#$00#$00#$00#$00+
#$00#$56#$00#$00#$00#$3C#$FF#$FF#$FF#$DF#$EC#$18#$00#$00#$00#$00#$00#$00#$04#$00#$00#$04#$00#$10#$10#$8C#$00#$00+
#$00#$3E#$00#$00#$00#$4A#$00#$00#$00#$3A#$00#$00#$00#$00#$00#$00#$00#$37#$00#$00#$00#$B3#$FF#$FF#$FF#$E5#$98#$13+
#$00#$00#$00#$00#$00#$00#$02#$00#$00#$04#$00#$12#$12#$2E#$01#$00#$00#$7D#$00#$00#$00#$7D#$00#$00#$00#$3E#$00#$00+
#$00#$00#$00#$00#$00#$73#$00#$00#$00#$D0#$FF#$FF#$FF#$EF#$30#$08#$00#$00#$00#$00#$00#$00#$06#$00#$00#$04#$00#$13+
#$13#$42#$01#$00#$00#$EE#$00#$00#$00#$CE#$00#$00#$00#$99#$00#$00#$00#$00#$00#$00#$00#$BD#$00#$00#$00#$FD#$FE#$FF+
#$FF#$E4#$93#$0A#$00#$00#$00#$00#$00#$00#$00#$00#$00#$04#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$44#$00#$D2#$17#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$44#$00#$D2#$0F#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$44#$00#$D2#$13#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$44#$00#$D2#$1E#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$44#$00#$D2#$19#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$44#$00#$D2#$1B#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$44#$00#$D2#$1D#$00#$00#$00),Lista[i].key));

mainpacket(i);

enviarpersonagens(i);

enviarcaddies(i);

enviarinventorio(i);

enviarmascotes(i);

barradeselecao(i);

criarcanais(i);

Lista[i].socket.sendtext(EncryptS(Compress(#$31#$01#$01#$15#$00#$00#$00#$00#$00#$01#$00#$00#$00#$00#$02#$00#$00#$00#$00#$03#$00#$00#$00#$00#$04#$00#$00#$00+
#$00#$05#$00#$00#$00#$00#$06#$00#$00#$00#$00#$07#$00#$00#$00#$00#$08#$00#$00#$00#$00#$09#$00#$00#$00#$00#$0A#$00+
#$00#$00#$00#$0B#$00#$00#$00#$00#$0C#$00#$00#$00#$00#$0D#$00#$00#$00#$00#$0E#$00#$00#$00#$00#$0F#$00#$00#$00#$00+
#$10#$00#$00#$00#$00#$11#$00#$00#$00#$00#$12#$00#$00#$00#$00#$13#$00#$00#$00#$00#$14#$00#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$1C#$02#$00#$00#$00#$00#$D3#$00#$00#$00#$D3#$00#$00#$00#$01#$39#$00#$40#$6C#$89#$2F#$F6#$01#$00#$00#$00#$00#$01+
#$1F#$00#$40#$6C#$8A#$2F#$F6#$01#$00#$00#$00#$00#$01#$3A#$00#$40#$6C#$8B#$2F#$F6#$01#$00#$00#$00#$00#$01#$3B#$00+
#$40#$6C#$8C#$2F#$F6#$01#$00#$00#$00#$00#$01#$1E#$00#$40#$6C#$8D#$2F#$F6#$01#$00#$00#$00#$00#$01#$1D#$00#$40#$6C+
#$8E#$2F#$F6#$01#$00#$00#$00#$00#$01#$3C#$00#$40#$6C#$8F#$2F#$F6#$01#$00#$00#$00#$00#$01#$3E#$00#$40#$6C#$90#$2F+
#$F6#$01#$00#$00#$00#$00#$01#$3D#$00#$40#$6C#$91#$2F#$F6#$01#$00#$00#$00#$00#$01#$3F#$00#$40#$6C#$92#$2F#$F6#$01+
#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$93#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$94#$2F#$F6#$01#$00#$00+
#$00#$00#$01#$04#$00#$40#$6C#$95#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$96#$2F#$F6#$01#$00#$00#$00#$00+
#$01#$0F#$00#$40#$6C#$97#$2F#$F6#$01#$00#$00#$00#$00#$01#$10#$00#$40#$6C#$98#$2F#$F6#$01#$00#$00#$00#$00#$01#$11+
#$00#$40#$6C#$99#$2F#$F6#$01#$00#$00#$00#$00#$01#$12#$00#$40#$6C#$9A#$2F#$F6#$01#$00#$00#$00#$00#$01#$13#$00#$40+
#$6C#$9B#$2F#$F6#$01#$00#$00#$00#$00#$01#$14#$00#$40#$6C#$9C#$2F#$F6#$01#$00#$00#$00#$00#$01#$15#$00#$40#$6C#$9D+
#$2F#$F6#$01#$00#$00#$00#$00#$01#$16#$00#$40#$6C#$9E#$2F#$F6#$01#$00#$00#$00#$00#$01#$17#$00#$40#$6C#$9F#$2F#$F6+
#$01#$00#$00#$00#$00#$01#$18#$00#$40#$6C#$A0#$2F#$F6#$01#$00#$00#$00#$00#$01#$40#$00#$40#$6C#$A1#$2F#$F6#$01#$00+
#$00#$00#$00#$01#$19#$00#$40#$6C#$A2#$2F#$F6#$01#$00#$00#$00#$00#$01#$1C#$00#$40#$6C#$A3#$2F#$F6#$01#$00#$00#$00+
#$00#$01#$41#$00#$40#$6C#$A4#$2F#$F6#$01#$00#$00#$00#$00#$01#$1B#$00#$40#$6C#$A5#$2F#$F6#$01#$00#$00#$00#$00#$01+
#$42#$00#$40#$6C#$A6#$2F#$F6#$01#$00#$00#$00#$00#$01#$43#$00#$40#$6C#$A7#$2F#$F6#$01#$00#$00#$00#$00#$01#$44#$00+
#$40#$6C#$A8#$2F#$F6#$01#$00#$00#$00#$00#$01#$1A#$00#$40#$6C#$A9#$2F#$F6#$01#$00#$00#$00#$00#$01#$45#$00#$40#$6C+
#$AA#$2F#$F6#$01#$00#$00#$00#$00#$01#$46#$00#$40#$6C#$AB#$2F#$F6#$01#$00#$00#$00#$00#$01#$47#$00#$40#$6C#$AC#$2F+
#$F6#$01#$00#$00#$00#$00#$01#$48#$00#$40#$6C#$AD#$2F#$F6#$01#$00#$00#$00#$00#$01#$49#$00#$40#$6C#$AE#$2F#$F6#$01+
#$00#$00#$00#$00#$01#$0A#$00#$40#$6C#$AF#$2F#$F6#$01#$00#$00#$00#$00#$01#$09#$00#$40#$6C#$B0#$2F#$F6#$01#$00#$00+
#$00#$00#$01#$08#$00#$40#$6C#$B1#$2F#$F6#$01#$00#$00#$00#$00#$01#$07#$00#$40#$6C#$B2#$2F#$F6#$01#$00#$00#$00#$00+
#$01#$06#$00#$40#$6C#$B3#$2F#$F6#$01#$00#$00#$00#$00#$01#$4C#$00#$40#$6C#$B4#$2F#$F6#$01#$00#$00#$00#$00#$01#$4E+
#$00#$40#$6C#$B5#$2F#$F6#$01#$00#$00#$00#$00#$01#$51#$00#$40#$6C#$B6#$2F#$F6#$01#$00#$00#$00#$00#$01#$52#$00#$40+
#$6C#$B7#$2F#$F6#$01#$00#$00#$00#$00#$01#$32#$00#$40#$6C#$B8#$2F#$F6#$01#$00#$00#$00#$00#$01#$35#$00#$40#$6C#$B9+
#$2F#$F6#$01#$00#$00#$00#$00#$01#$0D#$00#$40#$6C#$BA#$2F#$F6#$01#$00#$00#$00#$00#$01#$55#$00#$40#$6C#$BB#$2F#$F6+
#$01#$00#$00#$00#$00#$01#$55#$00#$40#$6C#$BC#$2F#$F6#$01#$00#$00#$00#$00#$01#$55#$00#$40#$6C#$BD#$2F#$F6#$01#$00+
#$00#$00#$00#$01#$05#$00#$40#$6C#$BE#$2F#$F6#$01#$00#$00#$00#$00#$01#$05#$00#$40#$6C#$BF#$2F#$F6#$01#$00#$00#$00+
#$00#$01#$05#$00#$40#$6C#$C0#$2F#$F6#$01#$00#$00#$00#$00#$01#$56#$00#$40#$6C#$C1#$2F#$F6#$01#$00#$00#$00#$00#$01+
#$56#$00#$40#$6C#$C2#$2F#$F6#$01#$00#$00#$00#$00#$01#$56#$00#$40#$6C#$C3#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00+
#$40#$6C#$C4#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$C5#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C+
#$C6#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$C7#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$C8#$2F+
#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$C9#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$CA#$2F#$F6#$01+
#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$CB#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$CC#$2F#$F6#$01#$00#$00+
#$00#$00#$01#$04#$00#$40#$6C#$CD#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$CE#$2F#$F6#$01#$00#$00#$00#$00+
#$01#$04#$00#$40#$6C#$CF#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$D0#$2F#$F6#$01#$00#$00#$00#$00#$01#$04+
#$00#$40#$6C#$D1#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$D2#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40+
#$6C#$D3#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$D4#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$D5+
#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$D6#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$D7#$2F#$F6+
#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$D8#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$D9#$2F#$F6#$01#$00+
#$00#$00#$00#$01#$04#$00#$40#$6C#$DA#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$DB#$2F#$F6#$01#$00#$00#$00+
#$00#$01#$04#$00#$40#$6C#$DC#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$DD#$2F#$F6#$01#$00#$00#$00#$00#$01+
#$04#$00#$40#$6C#$DE#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$DF#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00+
#$40#$6C#$E0#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$E1#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C+
#$E2#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$E3#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$E4#$2F+
#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$E5#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$E6#$2F#$F6#$01+
#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$E7#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$E8#$2F#$F6#$01#$00#$00+
#$00#$00#$01#$04#$00#$40#$6C#$E9#$2F#$F6#$01#$00#$00#$00#$00#$01#$A0#$00#$40#$6C#$EA#$2F#$F6#$01#$1E#$00#$00#$00+
#$01#$A0#$00#$40#$6C#$AC#$67#$F7#$01#$03#$00#$00#$00#$01#$A0#$00#$40#$6C#$28#$C4#$F8#$01#$05#$00#$00#$00#$01#$A0+
#$00#$40#$6C#$4D#$53#$FD#$01#$07#$00#$00#$00#$01#$A0#$00#$40#$6C#$D7#$96#$05#$02#$0A#$00#$00#$00#$01#$A0#$00#$40+
#$6C#$CC#$BB#$0D#$02#$0F#$00#$00#$00#$01#$A0#$00#$40#$6C#$EB#$2F#$F6#$01#$21#$00#$00#$00#$01#$04#$00#$40#$6C#$EC+
#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$ED#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$EE#$2F#$F6+
#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$EF#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$F0#$2F#$F6#$01#$00+
#$00#$00#$00#$01#$04#$00#$40#$6C#$F1#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$6C#$F2#$2F#$F6#$01#$00#$00#$00+
#$00#$01#$04#$00#$40#$6C#$F3#$2F#$F6#$01#$00#$00#$00#$00#$01#$9A#$00#$40#$6C#$F4#$2F#$F6#$01#$00#$00#$00#$00#$01+
#$98#$00#$40#$6C#$F5#$2F#$F6#$01#$00#$00#$00#$00#$01#$99#$00#$40#$6C#$F6#$2F#$F6#$01#$00#$00#$00#$00#$01#$0B#$00+
#$40#$6C#$F7#$2F#$F6#$01#$00#$00#$00#$00#$01#$20#$00#$40#$6C#$F8#$2F#$F6#$01#$00#$00#$00#$00#$01#$21#$00#$40#$6C+
#$F9#$2F#$F6#$01#$00#$00#$00#$00#$01#$2B#$00#$40#$6C#$FA#$2F#$F6#$01#$00#$00#$00#$00#$01#$22#$00#$40#$6C#$FB#$2F+
#$F6#$01#$00#$00#$00#$00#$01#$23#$00#$40#$6C#$FC#$2F#$F6#$01#$00#$00#$00#$00#$01#$24#$00#$40#$6C#$FD#$2F#$F6#$01+
#$00#$00#$00#$00#$01#$25#$00#$40#$6C#$FE#$2F#$F6#$01#$00#$00#$00#$00#$01#$26#$00#$40#$6C#$FF#$2F#$F6#$01#$00#$00+
#$00#$00#$01#$27#$00#$40#$6C#$00#$30#$F6#$01#$00#$00#$00#$00#$01#$28#$00#$40#$6C#$01#$30#$F6#$01#$00#$00#$00#$00+
#$01#$29#$00#$40#$6C#$02#$30#$F6#$01#$00#$00#$00#$00#$01#$2A#$00#$40#$6C#$03#$30#$F6#$01#$00#$00#$00#$00#$01#$2C+
#$00#$40#$6C#$04#$30#$F6#$01#$00#$00#$00#$00#$01#$2D#$00#$40#$6C#$05#$30#$F6#$01#$00#$00#$00#$00#$01#$2E#$00#$40+
#$6C#$06#$30#$F6#$01#$00#$00#$00#$00#$01#$2F#$00#$40#$6C#$07#$30#$F6#$01#$00#$00#$00#$00#$01#$30#$00#$40#$6C#$08+
#$30#$F6#$01#$00#$00#$00#$00#$01#$31#$00#$40#$6C#$09#$30#$F6#$01#$00#$00#$00#$00#$01#$6D#$00#$40#$6C#$0A#$30#$F6+
#$01#$00#$00#$00#$00#$01#$A1#$00#$40#$6C#$0B#$30#$F6#$01#$00#$00#$00#$00#$01#$4F#$00#$40#$6C#$0C#$30#$F6#$01#$00+
#$00#$00#$00#$01#$70#$00#$40#$6C#$0D#$30#$F6#$01#$00#$00#$00#$00#$01#$71#$00#$40#$6C#$0E#$30#$F6#$01#$00#$00#$00+
#$00#$01#$72#$00#$40#$6C#$0F#$30#$F6#$01#$00#$00#$00#$00#$01#$73#$00#$40#$6C#$10#$30#$F6#$01#$00#$00#$00#$00#$01+
#$74#$00#$40#$6C#$11#$30#$F6#$01#$00#$00#$00#$00#$01#$75#$00#$40#$6C#$12#$30#$F6#$01#$00#$00#$00#$00#$01#$50#$00+
#$40#$6C#$13#$30#$F6#$01#$00#$00#$00#$00#$01#$76#$00#$40#$6C#$14#$30#$F6#$01#$00#$00#$00#$00#$01#$36#$00#$40#$6C+
#$15#$30#$F6#$01#$00#$00#$00#$00#$01#$54#$00#$40#$6C#$16#$30#$F6#$01#$00#$00#$00#$00#$01#$37#$00#$40#$6C#$17#$30+
#$F6#$01#$00#$00#$00#$00#$01#$53#$00#$40#$6C#$18#$30#$F6#$01#$00#$00#$00#$00#$01#$78#$00#$40#$6C#$19#$30#$F6#$01+
#$00#$00#$00#$00#$01#$79#$00#$40#$6C#$1A#$30#$F6#$01#$00#$00#$00#$00#$01#$7A#$00#$40#$6C#$1B#$30#$F6#$01#$00#$00+
#$00#$00#$01#$7B#$00#$40#$6C#$1C#$30#$F6#$01#$00#$00#$00#$00#$01#$7C#$00#$40#$6C#$1D#$30#$F6#$01#$00#$00#$00#$00+
#$01#$7D#$00#$40#$6C#$1E#$30#$F6#$01#$00#$00#$00#$00#$01#$7E#$00#$40#$6C#$1F#$30#$F6#$01#$00#$00#$00#$00#$01#$7F+
#$00#$40#$6C#$20#$30#$F6#$01#$00#$00#$00#$00#$01#$80#$00#$40#$6C#$21#$30#$F6#$01#$00#$00#$00#$00#$01#$8E#$00#$40+
#$6C#$22#$30#$F6#$01#$00#$00#$00#$00#$01#$8F#$00#$40#$6C#$23#$30#$F6#$01#$00#$00#$00#$00#$01#$97#$00#$40#$6C#$24+
#$30#$F6#$01#$00#$00#$00#$00#$01#$90#$00#$40#$6C#$25#$30#$F6#$01#$00#$00#$00#$00#$01#$91#$00#$40#$6C#$26#$30#$F6+
#$01#$00#$00#$00#$00#$01#$92#$00#$40#$6C#$27#$30#$F6#$01#$00#$00#$00#$00#$01#$93#$00#$40#$6C#$28#$30#$F6#$01#$00+
#$00#$00#$00#$01#$94#$00#$40#$6C#$29#$30#$F6#$01#$00#$00#$00#$00#$01#$95#$00#$40#$6C#$2A#$30#$F6#$01#$00#$00#$00+
#$00#$01#$96#$00#$40#$6C#$2B#$30#$F6#$01#$00#$00#$00#$00#$01#$9E#$00#$40#$6C#$2C#$30#$F6#$01#$00#$00#$00#$00#$01+
#$A8#$00#$40#$6C#$2D#$30#$F6#$01#$00#$00#$00#$00#$01#$5E#$00#$40#$6C#$2E#$30#$F6#$01#$00#$00#$00#$00#$01#$5D#$00+
#$40#$6C#$2F#$30#$F6#$01#$00#$00#$00#$00#$01#$61#$00#$40#$6C#$30#$30#$F6#$01#$00#$00#$00#$00#$01#$62#$00#$40#$6C+
#$31#$30#$F6#$01#$00#$00#$00#$00#$01#$63#$00#$40#$6C#$32#$30#$F6#$01#$00#$00#$00#$00#$01#$5F#$00#$40#$6C#$33#$30+
#$F6#$01#$00#$00#$00#$00#$01#$60#$00#$40#$6C#$34#$30#$F6#$01#$00#$00#$00#$00#$01#$65#$00#$40#$6C#$35#$30#$F6#$01+
#$00#$00#$00#$00#$01#$64#$00#$40#$6C#$36#$30#$F6#$01#$00#$00#$00#$00#$01#$66#$00#$40#$6C#$37#$30#$F6#$01#$00#$00+
#$00#$00#$01#$67#$00#$40#$6C#$38#$30#$F6#$01#$00#$00#$00#$00#$01#$68#$00#$40#$6C#$39#$30#$F6#$01#$00#$00#$00#$00+
#$01#$6E#$00#$40#$6C#$3A#$30#$F6#$01#$00#$00#$00#$00#$01#$6F#$00#$40#$6C#$3B#$30#$F6#$01#$00#$00#$00#$00#$01#$59+
#$00#$40#$6C#$3C#$30#$F6#$01#$00#$00#$00#$00#$01#$5B#$00#$40#$6C#$3D#$30#$F6#$01#$00#$00#$00#$00#$01#$9B#$00#$40+
#$6C#$3E#$30#$F6#$01#$00#$00#$00#$00#$01#$9C#$00#$40#$6C#$3F#$30#$F6#$01#$00#$00#$00#$00#$01#$9D#$00#$40#$6C#$40+
#$30#$F6#$01#$00#$00#$00#$00#$01#$4A#$00#$40#$6C#$41#$30#$F6#$01#$00#$00#$00#$00#$01#$81#$00#$40#$6C#$42#$30#$F6+
#$01#$00#$00#$00#$00#$01#$82#$00#$40#$6C#$43#$30#$F6#$01#$00#$00#$00#$00#$01#$83#$00#$40#$6C#$44#$30#$F6#$01#$2C+
#$00#$00#$00#$01#$83#$00#$40#$6C#$B4#$69#$F7#$01#$0A#$00#$00#$00#$01#$84#$00#$40#$6C#$45#$30#$F6#$01#$00#$00#$00+
#$00#$01#$85#$00#$40#$6C#$46#$30#$F6#$01#$00#$00#$00#$00#$01#$86#$00#$40#$6C#$47#$30#$F6#$01#$00#$00#$00#$00#$01+
#$87#$00#$40#$6C#$48#$30#$F6#$01#$00#$00#$00#$00#$01#$88#$00#$40#$6C#$49#$30#$F6#$01#$00#$00#$00#$00#$01#$89#$00+
#$40#$6C#$4A#$30#$F6#$01#$00#$00#$00#$00#$01#$8A#$00#$40#$6C#$4B#$30#$F6#$01#$00#$00#$00#$00#$01#$8B#$00#$40#$6C+
#$4C#$30#$F6#$01#$00#$00#$00#$00#$01#$8C#$00#$40#$6C#$4D#$30#$F6#$01#$00#$00#$00#$00#$01#$8D#$00#$40#$6C#$4E#$30+
#$F6#$01#$00#$00#$00#$00#$01#$9F#$00#$40#$6C#$4F#$30#$F6#$01#$00#$00#$00#$00#$01#$A2#$00#$40#$6C#$50#$30#$F6#$01+
#$00#$00#$00#$00#$01#$A3#$00#$40#$6C#$51#$30#$F6#$01#$00#$00#$00#$00#$01#$A7#$00#$40#$6C#$52#$30#$F6#$01#$00#$00+
#$00#$00#$01#$A4#$00#$40#$6C#$53#$30#$F6#$01#$00#$00#$00#$00#$01#$A5#$00#$40#$6C#$54#$30#$F6#$01#$00#$00#$00#$00+
#$01#$A6#$00#$40#$6C#$55#$30#$F6#$01#$00#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$1D#$02#$00#$00#$00#$00#$A6#$00#$00#$00#$12#$00#$00#$00#$01#$01#$00#$80#$78#$27#$AB#$61#$01#$03#$00#$00#$00#$01+
#$00#$00#$00#$C2#$01#$80#$74#$39#$00#$40#$6C#$89#$2F#$F6#$01#$00#$00#$00#$00#$01#$01#$00#$00#$4C#$28#$AB#$61#$01+
#$03#$00#$00#$00#$09#$00#$00#$00#$C4#$02#$80#$74#$1F#$00#$40#$6C#$8A#$2F#$F6#$01#$00#$00#$00#$00#$C3#$02#$80#$74+
#$1F#$00#$40#$6C#$8A#$2F#$F6#$01#$00#$00#$00#$00#$C2#$02#$80#$74#$1F#$00#$40#$6C#$8A#$2F#$F6#$01#$00#$00#$00#$00+
#$C1#$02#$80#$74#$1F#$00#$40#$6C#$8A#$2F#$F6#$01#$00#$00#$00#$00#$C0#$02#$80#$74#$1F#$00#$40#$6C#$8A#$2F#$F6#$01+
#$00#$00#$00#$00#$BF#$02#$80#$74#$1F#$00#$40#$6C#$8A#$2F#$F6#$01#$00#$00#$00#$00#$BE#$02#$80#$74#$1F#$00#$40#$6C+
#$8A#$2F#$F6#$01#$00#$00#$00#$00#$BD#$02#$80#$74#$1F#$00#$40#$6C#$8A#$2F#$F6#$01#$00#$00#$00#$00#$BC#$02#$80#$74+
#$1F#$00#$40#$6C#$8A#$2F#$F6#$01#$00#$00#$00#$00#$01#$02#$00#$00#$4C#$29#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00+
#$00#$CD#$02#$80#$74#$3A#$00#$40#$6C#$8B#$2F#$F6#$01#$00#$00#$00#$00#$CC#$02#$80#$74#$3A#$00#$40#$6C#$8B#$2F#$F6+
#$01#$00#$00#$00#$00#$CB#$02#$80#$74#$3A#$00#$40#$6C#$8B#$2F#$F6#$01#$00#$00#$00#$00#$CA#$02#$80#$74#$3A#$00#$40+
#$6C#$8B#$2F#$F6#$01#$00#$00#$00#$00#$C9#$02#$80#$74#$3A#$00#$40#$6C#$8B#$2F#$F6#$01#$00#$00#$00#$00#$C8#$02#$80+
#$74#$3A#$00#$40#$6C#$8B#$2F#$F6#$01#$00#$00#$00#$00#$01#$03#$00#$00#$4C#$2A#$AB#$61#$01#$03#$00#$00#$00#$06#$00+
#$00#$00#$D6#$02#$80#$74#$3B#$00#$40#$6C#$8C#$2F#$F6#$01#$00#$00#$00#$00#$D5#$02#$80#$74#$3B#$00#$40#$6C#$8C#$2F+
#$F6#$01#$00#$00#$00#$00#$D4#$02#$80#$74#$3B#$00#$40#$6C#$8C#$2F#$F6#$01#$00#$00#$00#$00#$D3#$02#$80#$74#$3B#$00+
#$40#$6C#$8C#$2F#$F6#$01#$00#$00#$00#$00#$D2#$02#$80#$74#$3B#$00#$40#$6C#$8C#$2F#$F6#$01#$00#$00#$00#$00#$D1#$02+
#$80#$74#$3B#$00#$40#$6C#$8C#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$00#$4C#$2B#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$DF#$02#$80#$74#$1E#$00#$40#$6C#$8D#$2F#$F6#$01#$00#$00#$00#$00#$DE#$02#$80#$74#$1E#$00#$40#$6C#$8D+
#$2F#$F6#$01#$00#$00#$00#$00#$DD#$02#$80#$74#$1E#$00#$40#$6C#$8D#$2F#$F6#$01#$00#$00#$00#$00#$DC#$02#$80#$74#$1E+
#$00#$40#$6C#$8D#$2F#$F6#$01#$00#$00#$00#$00#$DB#$02#$80#$74#$1E#$00#$40#$6C#$8D#$2F#$F6#$01#$00#$00#$00#$00#$DA+
#$02#$80#$74#$1E#$00#$40#$6C#$8D#$2F#$F6#$01#$00#$00#$00#$00#$D9#$02#$80#$74#$1E#$00#$40#$6C#$8D#$2F#$F6#$01#$00+
#$00#$00#$00#$D8#$02#$80#$74#$1E#$00#$40#$6C#$8D#$2F#$F6#$01#$00#$00#$00#$00#$D7#$02#$80#$74#$1E#$00#$40#$6C#$8D+
#$2F#$F6#$01#$00#$00#$00#$00#$01#$05#$00#$00#$4C#$2C#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$E8#$02#$80#$74+
#$1D#$00#$40#$6C#$8E#$2F#$F6#$01#$00#$00#$00#$00#$E7#$02#$80#$74#$1D#$00#$40#$6C#$8E#$2F#$F6#$01#$00#$00#$00#$00+
#$E6#$02#$80#$74#$1D#$00#$40#$6C#$8E#$2F#$F6#$01#$00#$00#$00#$00#$E5#$02#$80#$74#$1D#$00#$40#$6C#$8E#$2F#$F6#$01+
#$00#$00#$00#$00#$E4#$02#$80#$74#$1D#$00#$40#$6C#$8E#$2F#$F6#$01#$00#$00#$00#$00#$E3#$02#$80#$74#$1D#$00#$40#$6C+
#$8E#$2F#$F6#$01#$00#$00#$00#$00#$E2#$02#$80#$74#$1D#$00#$40#$6C#$8E#$2F#$F6#$01#$00#$00#$00#$00#$E1#$02#$80#$74+
#$1D#$00#$40#$6C#$8E#$2F#$F6#$01#$00#$00#$00#$00#$E0#$02#$80#$74#$1D#$00#$40#$6C#$8E#$2F#$F6#$01#$00#$00#$00#$00+
#$01#$06#$00#$00#$4C#$2D#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$EE#$02#$80#$74#$3C#$00#$40#$6C#$8F#$2F#$F6+
#$01#$00#$00#$00#$00#$ED#$02#$80#$74#$3C#$00#$40#$6C#$8F#$2F#$F6#$01#$00#$00#$00#$00#$EC#$02#$80#$74#$3C#$00#$40+
#$6C#$8F#$2F#$F6#$01#$00#$00#$00#$00#$EB#$02#$80#$74#$3C#$00#$40#$6C#$8F#$2F#$F6#$01#$00#$00#$00#$00#$EA#$02#$80+
#$74#$3C#$00#$40#$6C#$8F#$2F#$F6#$01#$00#$00#$00#$00#$E9#$02#$80#$74#$3C#$00#$40#$6C#$8F#$2F#$F6#$01#$00#$00#$00+
#$00#$01#$07#$00#$00#$4C#$2E#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$F7#$02#$80#$74#$3E#$00#$40#$6C#$90#$2F+
#$F6#$01#$00#$00#$00#$00#$F6#$02#$80#$74#$3E#$00#$40#$6C#$90#$2F#$F6#$01#$00#$00#$00#$00#$F5#$02#$80#$74#$3E#$00+
#$40#$6C#$90#$2F#$F6#$01#$00#$00#$00#$00#$F4#$02#$80#$74#$3E#$00#$40#$6C#$90#$2F#$F6#$01#$00#$00#$00#$00#$F3#$02+
#$80#$74#$3E#$00#$40#$6C#$90#$2F#$F6#$01#$00#$00#$00#$00#$F2#$02#$80#$74#$3E#$00#$40#$6C#$90#$2F#$F6#$01#$00#$00+
#$00#$00#$F1#$02#$80#$74#$3E#$00#$40#$6C#$90#$2F#$F6#$01#$00#$00#$00#$00#$F0#$02#$80#$74#$3E#$00#$40#$6C#$90#$2F+
#$F6#$01#$00#$00#$00#$00#$EF#$02#$80#$74#$3E#$00#$40#$6C#$90#$2F#$F6#$01#$00#$00#$00#$00#$01#$08#$00#$00#$4C#$2F+
#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$00#$03#$80#$74#$3D#$00#$40#$6C#$91#$2F#$F6#$01#$00#$00#$00#$00#$FF+
#$02#$80#$74#$3D#$00#$40#$6C#$91#$2F#$F6#$01#$00#$00#$00#$00#$FE#$02#$80#$74#$3D#$00#$40#$6C#$91#$2F#$F6#$01#$00+
#$00#$00#$00#$FD#$02#$80#$74#$3D#$00#$40#$6C#$91#$2F#$F6#$01#$00#$00#$00#$00#$FC#$02#$80#$74#$3D#$00#$40#$6C#$91+
#$2F#$F6#$01#$00#$00#$00#$00#$FB#$02#$80#$74#$3D#$00#$40#$6C#$91#$2F#$F6#$01#$00#$00#$00#$00#$FA#$02#$80#$74#$3D+
#$00#$40#$6C#$91#$2F#$F6#$01#$00#$00#$00#$00#$F9#$02#$80#$74#$3D#$00#$40#$6C#$91#$2F#$F6#$01#$00#$00#$00#$00#$F8+
#$02#$80#$74#$3D#$00#$40#$6C#$91#$2F#$F6#$01#$00#$00#$00#$00#$01#$09#$00#$00#$4C#$30#$AB#$61#$01#$03#$00#$00#$00+
#$03#$00#$00#$00#$03#$03#$80#$74#$3F#$00#$40#$6C#$92#$2F#$F6#$01#$00#$00#$00#$00#$02#$03#$80#$74#$3F#$00#$40#$6C+
#$92#$2F#$F6#$01#$00#$00#$00#$00#$01#$03#$80#$74#$3F#$00#$40#$6C#$92#$2F#$F6#$01#$00#$00#$00#$00#$01#$0A#$00#$00+
#$4C#$31#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$0C#$03#$80#$74#$04#$00#$40#$6C#$93#$2F#$F6#$01#$00#$00#$00+
#$00#$0B#$03#$80#$74#$04#$00#$40#$6C#$93#$2F#$F6#$01#$00#$00#$00#$00#$0A#$03#$80#$74#$04#$00#$40#$6C#$93#$2F#$F6+
#$01#$00#$00#$00#$00#$09#$03#$80#$74#$04#$00#$40#$6C#$93#$2F#$F6#$01#$00#$00#$00#$00#$08#$03#$80#$74#$04#$00#$40+
#$6C#$93#$2F#$F6#$01#$00#$00#$00#$00#$07#$03#$80#$74#$04#$00#$40#$6C#$93#$2F#$F6#$01#$00#$00#$00#$00#$06#$03#$80+
#$74#$04#$00#$40#$6C#$93#$2F#$F6#$01#$00#$00#$00#$00#$05#$03#$80#$74#$04#$00#$40#$6C#$93#$2F#$F6#$01#$00#$00#$00+
#$00#$04#$03#$80#$74#$04#$00#$40#$6C#$93#$2F#$F6#$01#$00#$00#$00#$00#$01#$0B#$00#$00#$4C#$32#$AB#$61#$01#$03#$00+
#$00#$00#$09#$00#$00#$00#$15#$03#$80#$74#$04#$00#$40#$6C#$94#$2F#$F6#$01#$00#$00#$00#$00#$14#$03#$80#$74#$04#$00+
#$40#$6C#$94#$2F#$F6#$01#$00#$00#$00#$00#$13#$03#$80#$74#$04#$00#$40#$6C#$94#$2F#$F6#$01#$00#$00#$00#$00#$12#$03+
#$80#$74#$04#$00#$40#$6C#$94#$2F#$F6#$01#$00#$00#$00#$00#$11#$03#$80#$74#$04#$00#$40#$6C#$94#$2F#$F6#$01#$00#$00+
#$00#$00#$10#$03#$80#$74#$04#$00#$40#$6C#$94#$2F#$F6#$01#$00#$00#$00#$00#$0F#$03#$80#$74#$04#$00#$40#$6C#$94#$2F+
#$F6#$01#$00#$00#$00#$00#$0E#$03#$80#$74#$04#$00#$40#$6C#$94#$2F#$F6#$01#$00#$00#$00#$00#$0D#$03#$80#$74#$04#$00+
#$40#$6C#$94#$2F#$F6#$01#$00#$00#$00#$00#$01#$0C#$00#$00#$4C#$33#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$1E+
#$03#$80#$74#$04#$00#$40#$6C#$95#$2F#$F6#$01#$00#$00#$00#$00#$1D#$03#$80#$74#$04#$00#$40#$6C#$95#$2F#$F6#$01#$00+
#$00#$00#$00#$1C#$03#$80#$74#$04#$00#$40#$6C#$95#$2F#$F6#$01#$00#$00#$00#$00#$1B#$03#$80#$74#$04#$00#$40#$6C#$95+
#$2F#$F6#$01#$00#$00#$00#$00#$1A#$03#$80#$74#$04#$00#$40#$6C#$95#$2F#$F6#$01#$00#$00#$00#$00#$19#$03#$80#$74#$04+
#$00#$40#$6C#$95#$2F#$F6#$01#$00#$00#$00#$00#$18#$03#$80#$74#$04#$00#$40#$6C#$95#$2F#$F6#$01#$00#$00#$00#$00#$17+
#$03#$80#$74#$04#$00#$40#$6C#$95#$2F#$F6#$01#$00#$00#$00#$00#$16#$03#$80#$74#$04#$00#$40#$6C#$95#$2F#$F6#$01#$00+
#$00#$00#$00#$01#$0D#$00#$00#$4C#$34#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$27#$03#$80#$74#$04#$00#$40#$6C+
#$96#$2F#$F6#$01#$00#$00#$00#$00#$26#$03#$80#$74#$04#$00#$40#$6C#$96#$2F#$F6#$01#$00#$00#$00#$00#$25#$03#$80#$74+
#$04#$00#$40#$6C#$96#$2F#$F6#$01#$00#$00#$00#$00#$24#$03#$80#$74#$04#$00#$40#$6C#$96#$2F#$F6#$01#$00#$00#$00#$00+
#$23#$03#$80#$74#$04#$00#$40#$6C#$96#$2F#$F6#$01#$00#$00#$00#$00#$22#$03#$80#$74#$04#$00#$40#$6C#$96#$2F#$F6#$01+
#$00#$00#$00#$00#$21#$03#$80#$74#$04#$00#$40#$6C#$96#$2F#$F6#$01#$00#$00#$00#$00#$20#$03#$80#$74#$04#$00#$40#$6C+
#$96#$2F#$F6#$01#$00#$00#$00#$00#$1F#$03#$80#$74#$04#$00#$40#$6C#$96#$2F#$F6#$01#$00#$00#$00#$00#$01#$01#$00#$40+
#$4C#$35#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$30#$03#$80#$74#$0F#$00#$40#$6C#$97#$2F#$F6#$01#$00#$00#$00+
#$00#$2F#$03#$80#$74#$0F#$00#$40#$6C#$97#$2F#$F6#$01#$00#$00#$00#$00#$2E#$03#$80#$74#$0F#$00#$40#$6C#$97#$2F#$F6+
#$01#$00#$00#$00#$00#$2D#$03#$80#$74#$0F#$00#$40#$6C#$97#$2F#$F6#$01#$00#$00#$00#$00#$2C#$03#$80#$74#$0F#$00#$40+
#$6C#$97#$2F#$F6#$01#$00#$00#$00#$00#$2B#$03#$80#$74#$0F#$00#$40#$6C#$97#$2F#$F6#$01#$00#$00#$00#$00#$2A#$03#$80+
#$74#$0F#$00#$40#$6C#$97#$2F#$F6#$01#$00#$00#$00#$00#$29#$03#$80#$74#$0F#$00#$40#$6C#$97#$2F#$F6#$01#$00#$00#$00+
#$00#$28#$03#$80#$74#$0F#$00#$40#$6C#$97#$2F#$F6#$01#$00#$00#$00#$00#$01#$02#$00#$40#$4C#$36#$AB#$61#$01#$03#$00+
#$00#$00#$09#$00#$00#$00#$39#$03#$80#$74#$10#$00#$40#$6C#$98#$2F#$F6#$01#$00#$00#$00#$00#$38#$03#$80#$74#$10#$00+
#$40#$6C#$98#$2F#$F6#$01#$00#$00#$00#$00#$37#$03#$80#$74#$10#$00#$40#$6C#$98#$2F#$F6#$01#$00#$00#$00#$00#$36#$03+
#$80#$74#$10#$00#$40#$6C#$98#$2F#$F6#$01#$00#$00#$00#$00#$35#$03#$80#$74#$10#$00#$40#$6C#$98#$2F#$F6#$01#$00#$00+
#$00#$00#$34#$03#$80#$74#$10#$00#$40#$6C#$98#$2F#$F6#$01#$00#$00#$00#$00#$33#$03#$80#$74#$10#$00#$40#$6C#$98#$2F+
#$F6#$01#$00#$00#$00#$00#$32#$03#$80#$74#$10#$00#$40#$6C#$98#$2F#$F6#$01#$00#$00#$00#$00#$31#$03#$80#$74#$10#$00+
#$40#$6C#$98#$2F#$F6#$01#$00#$00#$00#$00#$01#$03#$00#$40#$4C#$37#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$42+
#$03#$80#$74#$11#$00#$40#$6C#$99#$2F#$F6#$01#$00#$00#$00#$00#$41#$03#$80#$74#$11#$00#$40#$6C#$99#$2F#$F6#$01#$00+
#$00#$00#$00#$40#$03#$80#$74#$11#$00#$40#$6C#$99#$2F#$F6#$01#$00#$00#$00#$00#$3F#$03#$80#$74#$11#$00#$40#$6C#$99+
#$2F#$F6#$01#$00#$00#$00#$00#$3E#$03#$80#$74#$11#$00#$40#$6C#$99#$2F#$F6#$01#$00#$00#$00#$00#$3D#$03#$80#$74#$11+
#$00#$40#$6C#$99#$2F#$F6#$01#$00#$00#$00#$00#$3C#$03#$80#$74#$11#$00#$40#$6C#$99#$2F#$F6#$01#$00#$00#$00#$00#$3B+
#$03#$80#$74#$11#$00#$40#$6C#$99#$2F#$F6#$01#$00#$00#$00#$00#$3A#$03#$80#$74#$11#$00#$40#$6C#$99#$2F#$F6#$01#$00+
#$00#$00#$00#$01#$04#$00#$40#$4C#$38#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$4B#$03#$80#$74#$12#$00#$40#$6C+
#$9A#$2F#$F6#$01#$00#$00#$00#$00#$4A#$03#$80#$74#$12#$00#$40#$6C#$9A#$2F#$F6#$01#$00#$00#$00#$00#$49#$03#$80#$74+
#$12#$00#$40#$6C#$9A#$2F#$F6#$01#$00#$00#$00#$00#$48#$03#$80#$74#$12#$00#$40#$6C#$9A#$2F#$F6#$01#$00#$00#$00#$00+
#$47#$03#$80#$74#$12#$00#$40#$6C#$9A#$2F#$F6#$01#$00#$00#$00#$00#$46#$03#$80#$74#$12#$00#$40#$6C#$9A#$2F#$F6#$01+
#$00#$00#$00#$00#$45#$03#$80#$74#$12#$00#$40#$6C#$9A#$2F#$F6#$01#$00#$00#$00#$00#$44#$03#$80#$74#$12#$00#$40#$6C+
#$9A#$2F#$F6#$01#$00#$00#$00#$00#$43#$03#$80#$74#$12#$00#$40#$6C#$9A#$2F#$F6#$01#$00#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$1D#$02#$00#$00#$00#$00#$94#$00#$00#$00#$12#$00#$00#$00#$01#$05#$00#$40#$4C#$39#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$54#$03#$80#$74#$13#$00#$40#$6C#$9B#$2F#$F6#$01#$00#$00#$00#$00#$53#$03#$80#$74#$13#$00#$40#$6C#$9B+
#$2F#$F6#$01#$00#$00#$00#$00#$52#$03#$80#$74#$13#$00#$40#$6C#$9B#$2F#$F6#$01#$00#$00#$00#$00#$51#$03#$80#$74#$13+
#$00#$40#$6C#$9B#$2F#$F6#$01#$00#$00#$00#$00#$50#$03#$80#$74#$13#$00#$40#$6C#$9B#$2F#$F6#$01#$00#$00#$00#$00#$4F+
#$03#$80#$74#$13#$00#$40#$6C#$9B#$2F#$F6#$01#$00#$00#$00#$00#$4E#$03#$80#$74#$13#$00#$40#$6C#$9B#$2F#$F6#$01#$00+
#$00#$00#$00#$4D#$03#$80#$74#$13#$00#$40#$6C#$9B#$2F#$F6#$01#$00#$00#$00#$00#$4C#$03#$80#$74#$13#$00#$40#$6C#$9B+
#$2F#$F6#$01#$00#$00#$00#$00#$01#$06#$00#$40#$4C#$3A#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$5D#$03#$80#$74+
#$14#$00#$40#$6C#$9C#$2F#$F6#$01#$00#$00#$00#$00#$5C#$03#$80#$74#$14#$00#$40#$6C#$9C#$2F#$F6#$01#$00#$00#$00#$00+
#$5B#$03#$80#$74#$14#$00#$40#$6C#$9C#$2F#$F6#$01#$00#$00#$00#$00#$5A#$03#$80#$74#$14#$00#$40#$6C#$9C#$2F#$F6#$01+
#$00#$00#$00#$00#$59#$03#$80#$74#$14#$00#$40#$6C#$9C#$2F#$F6#$01#$00#$00#$00#$00#$58#$03#$80#$74#$14#$00#$40#$6C+
#$9C#$2F#$F6#$01#$00#$00#$00#$00#$57#$03#$80#$74#$14#$00#$40#$6C#$9C#$2F#$F6#$01#$00#$00#$00#$00#$56#$03#$80#$74+
#$14#$00#$40#$6C#$9C#$2F#$F6#$01#$00#$00#$00#$00#$55#$03#$80#$74#$14#$00#$40#$6C#$9C#$2F#$F6#$01#$00#$00#$00#$00+
#$01#$07#$00#$40#$4C#$3B#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$66#$03#$80#$74#$15#$00#$40#$6C#$9D#$2F#$F6+
#$01#$00#$00#$00#$00#$65#$03#$80#$74#$15#$00#$40#$6C#$9D#$2F#$F6#$01#$00#$00#$00#$00#$64#$03#$80#$74#$15#$00#$40+
#$6C#$9D#$2F#$F6#$01#$00#$00#$00#$00#$63#$03#$80#$74#$15#$00#$40#$6C#$9D#$2F#$F6#$01#$00#$00#$00#$00#$62#$03#$80+
#$74#$15#$00#$40#$6C#$9D#$2F#$F6#$01#$00#$00#$00#$00#$61#$03#$80#$74#$15#$00#$40#$6C#$9D#$2F#$F6#$01#$00#$00#$00+
#$00#$60#$03#$80#$74#$15#$00#$40#$6C#$9D#$2F#$F6#$01#$00#$00#$00#$00#$5F#$03#$80#$74#$15#$00#$40#$6C#$9D#$2F#$F6+
#$01#$00#$00#$00#$00#$5E#$03#$80#$74#$15#$00#$40#$6C#$9D#$2F#$F6#$01#$00#$00#$00#$00#$01#$08#$00#$40#$4C#$3C#$AB+
#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$6F#$03#$80#$74#$16#$00#$40#$6C#$9E#$2F#$F6#$01#$00#$00#$00#$00#$6E#$03+
#$80#$74#$16#$00#$40#$6C#$9E#$2F#$F6#$01#$00#$00#$00#$00#$6D#$03#$80#$74#$16#$00#$40#$6C#$9E#$2F#$F6#$01#$00#$00+
#$00#$00#$6C#$03#$80#$74#$16#$00#$40#$6C#$9E#$2F#$F6#$01#$00#$00#$00#$00#$6B#$03#$80#$74#$16#$00#$40#$6C#$9E#$2F+
#$F6#$01#$00#$00#$00#$00#$6A#$03#$80#$74#$16#$00#$40#$6C#$9E#$2F#$F6#$01#$00#$00#$00#$00#$69#$03#$80#$74#$16#$00+
#$40#$6C#$9E#$2F#$F6#$01#$00#$00#$00#$00#$68#$03#$80#$74#$16#$00#$40#$6C#$9E#$2F#$F6#$01#$00#$00#$00#$00#$67#$03+
#$80#$74#$16#$00#$40#$6C#$9E#$2F#$F6#$01#$00#$00#$00#$00#$01#$09#$00#$40#$4C#$3D#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$78#$03#$80#$74#$17#$00#$40#$6C#$9F#$2F#$F6#$01#$00#$00#$00#$00#$77#$03#$80#$74#$17#$00#$40#$6C#$9F+
#$2F#$F6#$01#$00#$00#$00#$00#$76#$03#$80#$74#$17#$00#$40#$6C#$9F#$2F#$F6#$01#$00#$00#$00#$00#$75#$03#$80#$74#$17+
#$00#$40#$6C#$9F#$2F#$F6#$01#$00#$00#$00#$00#$74#$03#$80#$74#$17#$00#$40#$6C#$9F#$2F#$F6#$01#$00#$00#$00#$00#$73+
#$03#$80#$74#$17#$00#$40#$6C#$9F#$2F#$F6#$01#$00#$00#$00#$00#$72#$03#$80#$74#$17#$00#$40#$6C#$9F#$2F#$F6#$01#$00+
#$00#$00#$00#$71#$03#$80#$74#$17#$00#$40#$6C#$9F#$2F#$F6#$01#$00#$00#$00#$00#$70#$03#$80#$74#$17#$00#$40#$6C#$9F+
#$2F#$F6#$01#$00#$00#$00#$00#$01#$0A#$00#$40#$4C#$3E#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$81#$03#$80#$74+
#$18#$00#$40#$6C#$A0#$2F#$F6#$01#$00#$00#$00#$00#$80#$03#$80#$74#$18#$00#$40#$6C#$A0#$2F#$F6#$01#$00#$00#$00#$00+
#$7F#$03#$80#$74#$18#$00#$40#$6C#$A0#$2F#$F6#$01#$00#$00#$00#$00#$7E#$03#$80#$74#$18#$00#$40#$6C#$A0#$2F#$F6#$01+
#$00#$00#$00#$00#$7D#$03#$80#$74#$18#$00#$40#$6C#$A0#$2F#$F6#$01#$00#$00#$00#$00#$7C#$03#$80#$74#$18#$00#$40#$6C+
#$A0#$2F#$F6#$01#$00#$00#$00#$00#$7B#$03#$80#$74#$18#$00#$40#$6C#$A0#$2F#$F6#$01#$00#$00#$00#$00#$7A#$03#$80#$74+
#$18#$00#$40#$6C#$A0#$2F#$F6#$01#$00#$00#$00#$00#$79#$03#$80#$74#$18#$00#$40#$6C#$A0#$2F#$F6#$01#$00#$00#$00#$00+
#$01#$0B#$00#$40#$4C#$3F#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$8A#$03#$80#$74#$40#$00#$40#$6C#$A1#$2F#$F6+
#$01#$00#$00#$00#$00#$89#$03#$80#$74#$40#$00#$40#$6C#$A1#$2F#$F6#$01#$00#$00#$00#$00#$88#$03#$80#$74#$40#$00#$40+
#$6C#$A1#$2F#$F6#$01#$00#$00#$00#$00#$87#$03#$80#$74#$40#$00#$40#$6C#$A1#$2F#$F6#$01#$00#$00#$00#$00#$86#$03#$80+
#$74#$40#$00#$40#$6C#$A1#$2F#$F6#$01#$00#$00#$00#$00#$85#$03#$80#$74#$40#$00#$40#$6C#$A1#$2F#$F6#$01#$00#$00#$00+
#$00#$84#$03#$80#$74#$40#$00#$40#$6C#$A1#$2F#$F6#$01#$00#$00#$00#$00#$83#$03#$80#$74#$40#$00#$40#$6C#$A1#$2F#$F6+
#$01#$00#$00#$00#$00#$82#$03#$80#$74#$40#$00#$40#$6C#$A1#$2F#$F6#$01#$00#$00#$00#$00#$01#$0C#$00#$40#$4C#$40#$AB+
#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$93#$03#$80#$74#$19#$00#$40#$6C#$A2#$2F#$F6#$01#$00#$00#$00#$00#$92#$03+
#$80#$74#$19#$00#$40#$6C#$A2#$2F#$F6#$01#$00#$00#$00#$00#$91#$03#$80#$74#$19#$00#$40#$6C#$A2#$2F#$F6#$01#$00#$00+
#$00#$00#$90#$03#$80#$74#$19#$00#$40#$6C#$A2#$2F#$F6#$01#$00#$00#$00#$00#$8F#$03#$80#$74#$19#$00#$40#$6C#$A2#$2F+
#$F6#$01#$00#$00#$00#$00#$8E#$03#$80#$74#$19#$00#$40#$6C#$A2#$2F#$F6#$01#$00#$00#$00#$00#$8D#$03#$80#$74#$19#$00+
#$40#$6C#$A2#$2F#$F6#$01#$00#$00#$00#$00#$8C#$03#$80#$74#$19#$00#$40#$6C#$A2#$2F#$F6#$01#$00#$00#$00#$00#$8B#$03+
#$80#$74#$19#$00#$40#$6C#$A2#$2F#$F6#$01#$00#$00#$00#$00#$01#$0D#$00#$40#$4C#$41#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$9C#$03#$80#$74#$1C#$00#$40#$6C#$A3#$2F#$F6#$01#$00#$00#$00#$00#$9B#$03#$80#$74#$1C#$00#$40#$6C#$A3+
#$2F#$F6#$01#$00#$00#$00#$00#$9A#$03#$80#$74#$1C#$00#$40#$6C#$A3#$2F#$F6#$01#$00#$00#$00#$00#$99#$03#$80#$74#$1C+
#$00#$40#$6C#$A3#$2F#$F6#$01#$00#$00#$00#$00#$98#$03#$80#$74#$1C#$00#$40#$6C#$A3#$2F#$F6#$01#$00#$00#$00#$00#$97+
#$03#$80#$74#$1C#$00#$40#$6C#$A3#$2F#$F6#$01#$00#$00#$00#$00#$96#$03#$80#$74#$1C#$00#$40#$6C#$A3#$2F#$F6#$01#$00+
#$00#$00#$00#$95#$03#$80#$74#$1C#$00#$40#$6C#$A3#$2F#$F6#$01#$00#$00#$00#$00#$94#$03#$80#$74#$1C#$00#$40#$6C#$A3+
#$2F#$F6#$01#$00#$00#$00#$00#$01#$0E#$00#$40#$4C#$42#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$A5#$03#$80#$74+
#$41#$00#$40#$6C#$A4#$2F#$F6#$01#$00#$00#$00#$00#$A4#$03#$80#$74#$41#$00#$40#$6C#$A4#$2F#$F6#$01#$00#$00#$00#$00+
#$A3#$03#$80#$74#$41#$00#$40#$6C#$A4#$2F#$F6#$01#$00#$00#$00#$00#$A2#$03#$80#$74#$41#$00#$40#$6C#$A4#$2F#$F6#$01+
#$00#$00#$00#$00#$A1#$03#$80#$74#$41#$00#$40#$6C#$A4#$2F#$F6#$01#$00#$00#$00#$00#$A0#$03#$80#$74#$41#$00#$40#$6C+
#$A4#$2F#$F6#$01#$00#$00#$00#$00#$9F#$03#$80#$74#$41#$00#$40#$6C#$A4#$2F#$F6#$01#$00#$00#$00#$00#$9E#$03#$80#$74+
#$41#$00#$40#$6C#$A4#$2F#$F6#$01#$00#$00#$00#$00#$9D#$03#$80#$74#$41#$00#$40#$6C#$A4#$2F#$F6#$01#$00#$00#$00#$00+
#$01#$0F#$00#$40#$4C#$43#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$AE#$03#$80#$74#$1B#$00#$40#$6C#$A5#$2F#$F6+
#$01#$00#$00#$00#$00#$AD#$03#$80#$74#$1B#$00#$40#$6C#$A5#$2F#$F6#$01#$00#$00#$00#$00#$AC#$03#$80#$74#$1B#$00#$40+
#$6C#$A5#$2F#$F6#$01#$00#$00#$00#$00#$AB#$03#$80#$74#$1B#$00#$40#$6C#$A5#$2F#$F6#$01#$00#$00#$00#$00#$AA#$03#$80+
#$74#$1B#$00#$40#$6C#$A5#$2F#$F6#$01#$00#$00#$00#$00#$A9#$03#$80#$74#$1B#$00#$40#$6C#$A5#$2F#$F6#$01#$00#$00#$00+
#$00#$A8#$03#$80#$74#$1B#$00#$40#$6C#$A5#$2F#$F6#$01#$00#$00#$00#$00#$A7#$03#$80#$74#$1B#$00#$40#$6C#$A5#$2F#$F6+
#$01#$00#$00#$00#$00#$A6#$03#$80#$74#$1B#$00#$40#$6C#$A5#$2F#$F6#$01#$00#$00#$00#$00#$01#$10#$00#$40#$4C#$44#$AB+
#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$B7#$03#$80#$74#$42#$00#$40#$6C#$A6#$2F#$F6#$01#$00#$00#$00#$00#$B6#$03+
#$80#$74#$42#$00#$40#$6C#$A6#$2F#$F6#$01#$00#$00#$00#$00#$B5#$03#$80#$74#$42#$00#$40#$6C#$A6#$2F#$F6#$01#$00#$00+
#$00#$00#$B4#$03#$80#$74#$42#$00#$40#$6C#$A6#$2F#$F6#$01#$00#$00#$00#$00#$B3#$03#$80#$74#$42#$00#$40#$6C#$A6#$2F+
#$F6#$01#$00#$00#$00#$00#$B2#$03#$80#$74#$42#$00#$40#$6C#$A6#$2F#$F6#$01#$00#$00#$00#$00#$B1#$03#$80#$74#$42#$00+
#$40#$6C#$A6#$2F#$F6#$01#$00#$00#$00#$00#$B0#$03#$80#$74#$42#$00#$40#$6C#$A6#$2F#$F6#$01#$00#$00#$00#$00#$AF#$03+
#$80#$74#$42#$00#$40#$6C#$A6#$2F#$F6#$01#$00#$00#$00#$00#$01#$11#$00#$40#$4C#$45#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$C0#$03#$80#$74#$43#$00#$40#$6C#$A7#$2F#$F6#$01#$00#$00#$00#$00#$BF#$03#$80#$74#$43#$00#$40#$6C#$A7+
#$2F#$F6#$01#$00#$00#$00#$00#$BE#$03#$80#$74#$43#$00#$40#$6C#$A7#$2F#$F6#$01#$00#$00#$00#$00#$BD#$03#$80#$74#$43+
#$00#$40#$6C#$A7#$2F#$F6#$01#$00#$00#$00#$00#$BC#$03#$80#$74#$43#$00#$40#$6C#$A7#$2F#$F6#$01#$00#$00#$00#$00#$BB+
#$03#$80#$74#$43#$00#$40#$6C#$A7#$2F#$F6#$01#$00#$00#$00#$00#$BA#$03#$80#$74#$43#$00#$40#$6C#$A7#$2F#$F6#$01#$00+
#$00#$00#$00#$B9#$03#$80#$74#$43#$00#$40#$6C#$A7#$2F#$F6#$01#$00#$00#$00#$00#$B8#$03#$80#$74#$43#$00#$40#$6C#$A7+
#$2F#$F6#$01#$00#$00#$00#$00#$01#$12#$00#$40#$4C#$46#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$C9#$03#$80#$74+
#$44#$00#$40#$6C#$A8#$2F#$F6#$01#$00#$00#$00#$00#$C8#$03#$80#$74#$44#$00#$40#$6C#$A8#$2F#$F6#$01#$00#$00#$00#$00+
#$C7#$03#$80#$74#$44#$00#$40#$6C#$A8#$2F#$F6#$01#$00#$00#$00#$00#$C6#$03#$80#$74#$44#$00#$40#$6C#$A8#$2F#$F6#$01+
#$00#$00#$00#$00#$C5#$03#$80#$74#$44#$00#$40#$6C#$A8#$2F#$F6#$01#$00#$00#$00#$00#$C4#$03#$80#$74#$44#$00#$40#$6C+
#$A8#$2F#$F6#$01#$00#$00#$00#$00#$C3#$03#$80#$74#$44#$00#$40#$6C#$A8#$2F#$F6#$01#$00#$00#$00#$00#$C2#$03#$80#$74+
#$44#$00#$40#$6C#$A8#$2F#$F6#$01#$00#$00#$00#$00#$C1#$03#$80#$74#$44#$00#$40#$6C#$A8#$2F#$F6#$01#$00#$00#$00#$00+
#$01#$13#$00#$40#$4C#$47#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$D2#$03#$80#$74#$1A#$00#$40#$6C#$A9#$2F#$F6+
#$01#$00#$00#$00#$00#$D1#$03#$80#$74#$1A#$00#$40#$6C#$A9#$2F#$F6#$01#$00#$00#$00#$00#$D0#$03#$80#$74#$1A#$00#$40+
#$6C#$A9#$2F#$F6#$01#$00#$00#$00#$00#$CF#$03#$80#$74#$1A#$00#$40#$6C#$A9#$2F#$F6#$01#$00#$00#$00#$00#$CE#$03#$80+
#$74#$1A#$00#$40#$6C#$A9#$2F#$F6#$01#$00#$00#$00#$00#$CD#$03#$80#$74#$1A#$00#$40#$6C#$A9#$2F#$F6#$01#$00#$00#$00+
#$00#$CC#$03#$80#$74#$1A#$00#$40#$6C#$A9#$2F#$F6#$01#$00#$00#$00#$00#$CB#$03#$80#$74#$1A#$00#$40#$6C#$A9#$2F#$F6+
#$01#$00#$00#$00#$00#$CA#$03#$80#$74#$1A#$00#$40#$6C#$A9#$2F#$F6#$01#$00#$00#$00#$00#$01#$14#$00#$40#$4C#$48#$AB+
#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$DB#$03#$80#$74#$45#$00#$40#$6C#$AA#$2F#$F6#$01#$00#$00#$00#$00#$DA#$03+
#$80#$74#$45#$00#$40#$6C#$AA#$2F#$F6#$01#$00#$00#$00#$00#$D9#$03#$80#$74#$45#$00#$40#$6C#$AA#$2F#$F6#$01#$00#$00+
#$00#$00#$D8#$03#$80#$74#$45#$00#$40#$6C#$AA#$2F#$F6#$01#$00#$00#$00#$00#$D7#$03#$80#$74#$45#$00#$40#$6C#$AA#$2F+
#$F6#$01#$00#$00#$00#$00#$D6#$03#$80#$74#$45#$00#$40#$6C#$AA#$2F#$F6#$01#$00#$00#$00#$00#$D5#$03#$80#$74#$45#$00+
#$40#$6C#$AA#$2F#$F6#$01#$00#$00#$00#$00#$D4#$03#$80#$74#$45#$00#$40#$6C#$AA#$2F#$F6#$01#$00#$00#$00#$00#$D3#$03+
#$80#$74#$45#$00#$40#$6C#$AA#$2F#$F6#$01#$00#$00#$00#$00#$01#$15#$00#$40#$4C#$49#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$E4#$03#$80#$74#$46#$00#$40#$6C#$AB#$2F#$F6#$01#$00#$00#$00#$00#$E3#$03#$80#$74#$46#$00#$40#$6C#$AB+
#$2F#$F6#$01#$00#$00#$00#$00#$E2#$03#$80#$74#$46#$00#$40#$6C#$AB#$2F#$F6#$01#$00#$00#$00#$00#$E1#$03#$80#$74#$46+
#$00#$40#$6C#$AB#$2F#$F6#$01#$00#$00#$00#$00#$E0#$03#$80#$74#$46#$00#$40#$6C#$AB#$2F#$F6#$01#$00#$00#$00#$00#$DF+
#$03#$80#$74#$46#$00#$40#$6C#$AB#$2F#$F6#$01#$00#$00#$00#$00#$DE#$03#$80#$74#$46#$00#$40#$6C#$AB#$2F#$F6#$01#$00+
#$00#$00#$00#$DD#$03#$80#$74#$46#$00#$40#$6C#$AB#$2F#$F6#$01#$00#$00#$00#$00#$DC#$03#$80#$74#$46#$00#$40#$6C#$AB+
#$2F#$F6#$01#$00#$00#$00#$00#$01#$16#$00#$40#$4C#$4A#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$ED#$03#$80#$74+
#$47#$00#$40#$6C#$AC#$2F#$F6#$01#$00#$00#$00#$00#$EC#$03#$80#$74#$47#$00#$40#$6C#$AC#$2F#$F6#$01#$00#$00#$00#$00+
#$EB#$03#$80#$74#$47#$00#$40#$6C#$AC#$2F#$F6#$01#$00#$00#$00#$00#$EA#$03#$80#$74#$47#$00#$40#$6C#$AC#$2F#$F6#$01+
#$00#$00#$00#$00#$E9#$03#$80#$74#$47#$00#$40#$6C#$AC#$2F#$F6#$01#$00#$00#$00#$00#$E8#$03#$80#$74#$47#$00#$40#$6C+
#$AC#$2F#$F6#$01#$00#$00#$00#$00#$E7#$03#$80#$74#$47#$00#$40#$6C#$AC#$2F#$F6#$01#$00#$00#$00#$00#$E6#$03#$80#$74+
#$47#$00#$40#$6C#$AC#$2F#$F6#$01#$00#$00#$00#$00#$E5#$03#$80#$74#$47#$00#$40#$6C#$AC#$2F#$F6#$01#$00#$00#$00#$00),Lista[i].key));


Lista[i].socket.sendtext(EncryptS(Compress(#$1D#$02#$00#$00#$00#$00#$82#$00#$00#$00#$12#$00#$00#$00#$01#$17#$00#$40#$4C#$4B#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$F6#$03#$80#$74#$48#$00#$40#$6C#$AD#$2F#$F6#$01#$00#$00#$00#$00#$F5#$03#$80#$74#$48#$00#$40#$6C#$AD+
#$2F#$F6#$01#$00#$00#$00#$00#$F4#$03#$80#$74#$48#$00#$40#$6C#$AD#$2F#$F6#$01#$00#$00#$00#$00#$F3#$03#$80#$74#$48+
#$00#$40#$6C#$AD#$2F#$F6#$01#$00#$00#$00#$00#$F2#$03#$80#$74#$48#$00#$40#$6C#$AD#$2F#$F6#$01#$00#$00#$00#$00#$F1+
#$03#$80#$74#$48#$00#$40#$6C#$AD#$2F#$F6#$01#$00#$00#$00#$00#$F0#$03#$80#$74#$48#$00#$40#$6C#$AD#$2F#$F6#$01#$00+
#$00#$00#$00#$EF#$03#$80#$74#$48#$00#$40#$6C#$AD#$2F#$F6#$01#$00#$00#$00#$00#$EE#$03#$80#$74#$48#$00#$40#$6C#$AD+
#$2F#$F6#$01#$00#$00#$00#$00#$01#$18#$00#$40#$4C#$4C#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$FF#$03#$80#$74+
#$49#$00#$40#$6C#$AE#$2F#$F6#$01#$00#$00#$00#$00#$FE#$03#$80#$74#$49#$00#$40#$6C#$AE#$2F#$F6#$01#$00#$00#$00#$00+
#$FD#$03#$80#$74#$49#$00#$40#$6C#$AE#$2F#$F6#$01#$00#$00#$00#$00#$FC#$03#$80#$74#$49#$00#$40#$6C#$AE#$2F#$F6#$01+
#$00#$00#$00#$00#$FB#$03#$80#$74#$49#$00#$40#$6C#$AE#$2F#$F6#$01#$00#$00#$00#$00#$FA#$03#$80#$74#$49#$00#$40#$6C+
#$AE#$2F#$F6#$01#$00#$00#$00#$00#$F9#$03#$80#$74#$49#$00#$40#$6C#$AE#$2F#$F6#$01#$00#$00#$00#$00#$F8#$03#$80#$74+
#$49#$00#$40#$6C#$AE#$2F#$F6#$01#$00#$00#$00#$00#$F7#$03#$80#$74#$49#$00#$40#$6C#$AE#$2F#$F6#$01#$00#$00#$00#$00+
#$01#$01#$00#$80#$4C#$4D#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$24#$04#$80#$74#$0A#$00#$40#$6C#$AF#$2F#$F6+
#$01#$00#$00#$00#$00#$23#$04#$80#$74#$0A#$00#$40#$6C#$AF#$2F#$F6#$01#$00#$00#$00#$00#$22#$04#$80#$74#$0A#$00#$40+
#$6C#$AF#$2F#$F6#$01#$00#$00#$00#$00#$21#$04#$80#$74#$0A#$00#$40#$6C#$AF#$2F#$F6#$01#$00#$00#$00#$00#$20#$04#$80+
#$74#$0A#$00#$40#$6C#$AF#$2F#$F6#$01#$00#$00#$00#$00#$1F#$04#$80#$74#$0A#$00#$40#$6C#$AF#$2F#$F6#$01#$00#$00#$00+
#$00#$1E#$04#$80#$74#$0A#$00#$40#$6C#$AF#$2F#$F6#$01#$00#$00#$00#$00#$1D#$04#$80#$74#$0A#$00#$40#$6C#$AF#$2F#$F6+
#$01#$00#$00#$00#$00#$1C#$04#$80#$74#$0A#$00#$40#$6C#$AF#$2F#$F6#$01#$00#$00#$00#$00#$01#$02#$00#$80#$4C#$4E#$AB+
#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$2D#$04#$80#$74#$09#$00#$40#$6C#$B0#$2F#$F6#$01#$00#$00#$00#$00#$2C#$04+
#$80#$74#$09#$00#$40#$6C#$B0#$2F#$F6#$01#$00#$00#$00#$00#$2B#$04#$80#$74#$09#$00#$40#$6C#$B0#$2F#$F6#$01#$00#$00+
#$00#$00#$2A#$04#$80#$74#$09#$00#$40#$6C#$B0#$2F#$F6#$01#$00#$00#$00#$00#$29#$04#$80#$74#$09#$00#$40#$6C#$B0#$2F+
#$F6#$01#$00#$00#$00#$00#$28#$04#$80#$74#$09#$00#$40#$6C#$B0#$2F#$F6#$01#$00#$00#$00#$00#$27#$04#$80#$74#$09#$00+
#$40#$6C#$B0#$2F#$F6#$01#$00#$00#$00#$00#$26#$04#$80#$74#$09#$00#$40#$6C#$B0#$2F#$F6#$01#$00#$00#$00#$00#$25#$04+
#$80#$74#$09#$00#$40#$6C#$B0#$2F#$F6#$01#$00#$00#$00#$00#$01#$03#$00#$80#$4C#$4F#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$36#$04#$80#$74#$08#$00#$40#$6C#$B1#$2F#$F6#$01#$00#$00#$00#$00#$35#$04#$80#$74#$08#$00#$40#$6C#$B1+
#$2F#$F6#$01#$00#$00#$00#$00#$34#$04#$80#$74#$08#$00#$40#$6C#$B1#$2F#$F6#$01#$00#$00#$00#$00#$33#$04#$80#$74#$08+
#$00#$40#$6C#$B1#$2F#$F6#$01#$00#$00#$00#$00#$32#$04#$80#$74#$08#$00#$40#$6C#$B1#$2F#$F6#$01#$00#$00#$00#$00#$31+
#$04#$80#$74#$08#$00#$40#$6C#$B1#$2F#$F6#$01#$00#$00#$00#$00#$30#$04#$80#$74#$08#$00#$40#$6C#$B1#$2F#$F6#$01#$00+
#$00#$00#$00#$2F#$04#$80#$74#$08#$00#$40#$6C#$B1#$2F#$F6#$01#$00#$00#$00#$00#$2E#$04#$80#$74#$08#$00#$40#$6C#$B1+
#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$80#$4C#$50#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$3F#$04#$80#$74+
#$07#$00#$40#$6C#$B2#$2F#$F6#$01#$00#$00#$00#$00#$3E#$04#$80#$74#$07#$00#$40#$6C#$B2#$2F#$F6#$01#$00#$00#$00#$00+
#$3D#$04#$80#$74#$07#$00#$40#$6C#$B2#$2F#$F6#$01#$00#$00#$00#$00#$3C#$04#$80#$74#$07#$00#$40#$6C#$B2#$2F#$F6#$01+
#$00#$00#$00#$00#$3B#$04#$80#$74#$07#$00#$40#$6C#$B2#$2F#$F6#$01#$00#$00#$00#$00#$3A#$04#$80#$74#$07#$00#$40#$6C+
#$B2#$2F#$F6#$01#$00#$00#$00#$00#$39#$04#$80#$74#$07#$00#$40#$6C#$B2#$2F#$F6#$01#$00#$00#$00#$00#$38#$04#$80#$74+
#$07#$00#$40#$6C#$B2#$2F#$F6#$01#$00#$00#$00#$00#$37#$04#$80#$74#$07#$00#$40#$6C#$B2#$2F#$F6#$01#$00#$00#$00#$00+
#$01#$05#$00#$80#$4C#$51#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$48#$04#$80#$74#$06#$00#$40#$6C#$B3#$2F#$F6+
#$01#$00#$00#$00#$00#$47#$04#$80#$74#$06#$00#$40#$6C#$B3#$2F#$F6#$01#$00#$00#$00#$00#$46#$04#$80#$74#$06#$00#$40+
#$6C#$B3#$2F#$F6#$01#$00#$00#$00#$00#$45#$04#$80#$74#$06#$00#$40#$6C#$B3#$2F#$F6#$01#$00#$00#$00#$00#$44#$04#$80+
#$74#$06#$00#$40#$6C#$B3#$2F#$F6#$01#$00#$00#$00#$00#$43#$04#$80#$74#$06#$00#$40#$6C#$B3#$2F#$F6#$01#$00#$00#$00+
#$00#$42#$04#$80#$74#$06#$00#$40#$6C#$B3#$2F#$F6#$01#$00#$00#$00#$00#$41#$04#$80#$74#$06#$00#$40#$6C#$B3#$2F#$F6+
#$01#$00#$00#$00#$00#$40#$04#$80#$74#$06#$00#$40#$6C#$B3#$2F#$F6#$01#$00#$00#$00#$00#$01#$06#$00#$80#$4C#$52#$AB+
#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$51#$04#$80#$74#$4C#$00#$40#$6C#$B4#$2F#$F6#$01#$00#$00#$00#$00#$50#$04+
#$80#$74#$4C#$00#$40#$6C#$B4#$2F#$F6#$01#$00#$00#$00#$00#$4F#$04#$80#$74#$4C#$00#$40#$6C#$B4#$2F#$F6#$01#$00#$00+
#$00#$00#$4E#$04#$80#$74#$4C#$00#$40#$6C#$B4#$2F#$F6#$01#$00#$00#$00#$00#$4D#$04#$80#$74#$4C#$00#$40#$6C#$B4#$2F+
#$F6#$01#$00#$00#$00#$00#$4C#$04#$80#$74#$4C#$00#$40#$6C#$B4#$2F#$F6#$01#$00#$00#$00#$00#$4B#$04#$80#$74#$4C#$00+
#$40#$6C#$B4#$2F#$F6#$01#$00#$00#$00#$00#$4A#$04#$80#$74#$4C#$00#$40#$6C#$B4#$2F#$F6#$01#$00#$00#$00#$00#$49#$04+
#$80#$74#$4C#$00#$40#$6C#$B4#$2F#$F6#$01#$00#$00#$00#$00#$01#$07#$00#$80#$4C#$53#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$63#$04#$80#$74#$4E#$00#$40#$6C#$B5#$2F#$F6#$01#$00#$00#$00#$00#$62#$04#$80#$74#$4E#$00#$40#$6C#$B5+
#$2F#$F6#$01#$00#$00#$00#$00#$61#$04#$80#$74#$4E#$00#$40#$6C#$B5#$2F#$F6#$01#$00#$00#$00#$00#$60#$04#$80#$74#$4E+
#$00#$40#$6C#$B5#$2F#$F6#$01#$00#$00#$00#$00#$5F#$04#$80#$74#$4E#$00#$40#$6C#$B5#$2F#$F6#$01#$00#$00#$00#$00#$5E+
#$04#$80#$74#$4E#$00#$40#$6C#$B5#$2F#$F6#$01#$00#$00#$00#$00#$5D#$04#$80#$74#$4E#$00#$40#$6C#$B5#$2F#$F6#$01#$00+
#$00#$00#$00#$5C#$04#$80#$74#$4E#$00#$40#$6C#$B5#$2F#$F6#$01#$00#$00#$00#$00#$5B#$04#$80#$74#$4E#$00#$40#$6C#$B5+
#$2F#$F6#$01#$00#$00#$00#$00#$01#$08#$00#$80#$4C#$54#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$7E#$04#$80#$74+
#$51#$00#$40#$6C#$B6#$2F#$F6#$01#$00#$00#$00#$00#$7D#$04#$80#$74#$51#$00#$40#$6C#$B6#$2F#$F6#$01#$00#$00#$00#$00+
#$7C#$04#$80#$74#$51#$00#$40#$6C#$B6#$2F#$F6#$01#$00#$00#$00#$00#$7B#$04#$80#$74#$51#$00#$40#$6C#$B6#$2F#$F6#$01+
#$00#$00#$00#$00#$7A#$04#$80#$74#$51#$00#$40#$6C#$B6#$2F#$F6#$01#$00#$00#$00#$00#$79#$04#$80#$74#$51#$00#$40#$6C+
#$B6#$2F#$F6#$01#$00#$00#$00#$00#$78#$04#$80#$74#$51#$00#$40#$6C#$B6#$2F#$F6#$01#$00#$00#$00#$00#$77#$04#$80#$74+
#$51#$00#$40#$6C#$B6#$2F#$F6#$01#$00#$00#$00#$00#$76#$04#$80#$74#$51#$00#$40#$6C#$B6#$2F#$F6#$01#$00#$00#$00#$00+
#$01#$09#$00#$80#$4C#$55#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$87#$04#$80#$74#$52#$00#$40#$6C#$B7#$2F#$F6+
#$01#$00#$00#$00#$00#$86#$04#$80#$74#$52#$00#$40#$6C#$B7#$2F#$F6#$01#$00#$00#$00#$00#$85#$04#$80#$74#$52#$00#$40+
#$6C#$B7#$2F#$F6#$01#$00#$00#$00#$00#$84#$04#$80#$74#$52#$00#$40#$6C#$B7#$2F#$F6#$01#$00#$00#$00#$00#$83#$04#$80+
#$74#$52#$00#$40#$6C#$B7#$2F#$F6#$01#$00#$00#$00#$00#$82#$04#$80#$74#$52#$00#$40#$6C#$B7#$2F#$F6#$01#$00#$00#$00+
#$00#$81#$04#$80#$74#$52#$00#$40#$6C#$B7#$2F#$F6#$01#$00#$00#$00#$00#$80#$04#$80#$74#$52#$00#$40#$6C#$B7#$2F#$F6+
#$01#$00#$00#$00#$00#$7F#$04#$80#$74#$52#$00#$40#$6C#$B7#$2F#$F6#$01#$00#$00#$00#$00#$01#$0A#$00#$80#$4C#$56#$AB+
#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$90#$04#$80#$74#$32#$00#$40#$6C#$B8#$2F#$F6#$01#$00#$00#$00#$00#$8F#$04+
#$80#$74#$32#$00#$40#$6C#$B8#$2F#$F6#$01#$00#$00#$00#$00#$8E#$04#$80#$74#$32#$00#$40#$6C#$B8#$2F#$F6#$01#$00#$00+
#$00#$00#$8D#$04#$80#$74#$32#$00#$40#$6C#$B8#$2F#$F6#$01#$00#$00#$00#$00#$8C#$04#$80#$74#$32#$00#$40#$6C#$B8#$2F+
#$F6#$01#$00#$00#$00#$00#$8B#$04#$80#$74#$32#$00#$40#$6C#$B8#$2F#$F6#$01#$00#$00#$00#$00#$8A#$04#$80#$74#$32#$00+
#$40#$6C#$B8#$2F#$F6#$01#$00#$00#$00#$00#$89#$04#$80#$74#$32#$00#$40#$6C#$B8#$2F#$F6#$01#$00#$00#$00#$00#$88#$04+
#$80#$74#$32#$00#$40#$6C#$B8#$2F#$F6#$01#$00#$00#$00#$00#$01#$0B#$00#$80#$4C#$57#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$25#$06#$80#$74#$35#$00#$40#$6C#$B9#$2F#$F6#$01#$00#$00#$00#$00#$26#$06#$80#$74#$35#$00#$40#$6C#$B9+
#$2F#$F6#$01#$00#$00#$00#$00#$27#$06#$80#$74#$35#$00#$40#$6C#$B9#$2F#$F6#$01#$00#$00#$00#$00#$28#$06#$80#$74#$35+
#$00#$40#$6C#$B9#$2F#$F6#$01#$00#$00#$00#$00#$29#$06#$80#$74#$35#$00#$40#$6C#$B9#$2F#$F6#$01#$00#$00#$00#$00#$2A+
#$06#$80#$74#$35#$00#$40#$6C#$B9#$2F#$F6#$01#$00#$00#$00#$00#$2B#$06#$80#$74#$35#$00#$40#$6C#$B9#$2F#$F6#$01#$00+
#$00#$00#$00#$2C#$06#$80#$74#$35#$00#$40#$6C#$B9#$2F#$F6#$01#$00#$00#$00#$00#$2D#$06#$80#$74#$35#$00#$40#$6C#$B9+
#$2F#$F6#$01#$00#$00#$00#$00#$01#$0C#$00#$80#$4C#$58#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$C6#$04#$80#$74+
#$0D#$00#$40#$6C#$BA#$2F#$F6#$01#$00#$00#$00#$00#$C5#$04#$80#$74#$0D#$00#$40#$6C#$BA#$2F#$F6#$01#$00#$00#$00#$00+
#$C4#$04#$80#$74#$0D#$00#$40#$6C#$BA#$2F#$F6#$01#$00#$00#$00#$00#$C3#$04#$80#$74#$0D#$00#$40#$6C#$BA#$2F#$F6#$01+
#$00#$00#$00#$00#$C2#$04#$80#$74#$0D#$00#$40#$6C#$BA#$2F#$F6#$01#$00#$00#$00#$00#$C1#$04#$80#$74#$0D#$00#$40#$6C+
#$BA#$2F#$F6#$01#$00#$00#$00#$00#$C0#$04#$80#$74#$0D#$00#$40#$6C#$BA#$2F#$F6#$01#$00#$00#$00#$00#$BF#$04#$80#$74+
#$0D#$00#$40#$6C#$BA#$2F#$F6#$01#$00#$00#$00#$00#$BE#$04#$80#$74#$0D#$00#$40#$6C#$BA#$2F#$F6#$01#$00#$00#$00#$00+
#$01#$0D#$00#$80#$4C#$59#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$D8#$04#$80#$74#$55#$00#$40#$6C#$BB#$2F#$F6+
#$01#$00#$00#$00#$00#$D7#$04#$80#$74#$55#$00#$40#$6C#$BB#$2F#$F6#$01#$00#$00#$00#$00#$D6#$04#$80#$74#$55#$00#$40+
#$6C#$BB#$2F#$F6#$01#$00#$00#$00#$00#$D5#$04#$80#$74#$55#$00#$40#$6C#$BB#$2F#$F6#$01#$00#$00#$00#$00#$D4#$04#$80+
#$74#$55#$00#$40#$6C#$BB#$2F#$F6#$01#$00#$00#$00#$00#$D3#$04#$80#$74#$55#$00#$40#$6C#$BB#$2F#$F6#$01#$00#$00#$00+
#$00#$01#$0E#$00#$80#$4C#$5A#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$D2#$04#$80#$74#$55#$00#$40#$6C#$BC#$2F+
#$F6#$01#$00#$00#$00#$00#$D1#$04#$80#$74#$55#$00#$40#$6C#$BC#$2F#$F6#$01#$00#$00#$00#$00#$D0#$04#$80#$74#$55#$00+
#$40#$6C#$BC#$2F#$F6#$01#$00#$00#$00#$00#$CF#$04#$80#$74#$55#$00#$40#$6C#$BC#$2F#$F6#$01#$00#$00#$00#$00#$CE#$04+
#$80#$74#$55#$00#$40#$6C#$BC#$2F#$F6#$01#$00#$00#$00#$00#$CD#$04#$80#$74#$55#$00#$40#$6C#$BC#$2F#$F6#$01#$00#$00+
#$00#$00#$01#$0F#$00#$80#$4C#$5B#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$CC#$04#$80#$74#$55#$00#$40#$6C#$BD+
#$2F#$F6#$01#$00#$00#$00#$00#$CB#$04#$80#$74#$55#$00#$40#$6C#$BD#$2F#$F6#$01#$00#$00#$00#$00#$CA#$04#$80#$74#$55+
#$00#$40#$6C#$BD#$2F#$F6#$01#$00#$00#$00#$00#$C9#$04#$80#$74#$55#$00#$40#$6C#$BD#$2F#$F6#$01#$00#$00#$00#$00#$C8+
#$04#$80#$74#$55#$00#$40#$6C#$BD#$2F#$F6#$01#$00#$00#$00#$00#$C7#$04#$80#$74#$55#$00#$40#$6C#$BD#$2F#$F6#$01#$00+
#$00#$00#$00#$01#$10#$00#$80#$4C#$5C#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$EA#$04#$80#$74#$05#$00#$40#$6C+
#$BE#$2F#$F6#$01#$00#$00#$00#$00#$E9#$04#$80#$74#$05#$00#$40#$6C#$BE#$2F#$F6#$01#$00#$00#$00#$00#$E8#$04#$80#$74+
#$05#$00#$40#$6C#$BE#$2F#$F6#$01#$00#$00#$00#$00#$E7#$04#$80#$74#$05#$00#$40#$6C#$BE#$2F#$F6#$01#$00#$00#$00#$00+
#$E6#$04#$80#$74#$05#$00#$40#$6C#$BE#$2F#$F6#$01#$00#$00#$00#$00#$E5#$04#$80#$74#$05#$00#$40#$6C#$BE#$2F#$F6#$01+
#$00#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$1D#$02#$00#$00#$00#$00#$70#$00#$00#$00#$12#$00#$00#$00#$01#$11#$00#$80#$4C#$5D#$AB#$61#$01#$03#$00#$00#$00#$06+
#$00#$00#$00#$E4#$04#$80#$74#$05#$00#$40#$6C#$BF#$2F#$F6#$01#$00#$00#$00#$00#$E3#$04#$80#$74#$05#$00#$40#$6C#$BF+
#$2F#$F6#$01#$00#$00#$00#$00#$E2#$04#$80#$74#$05#$00#$40#$6C#$BF#$2F#$F6#$01#$00#$00#$00#$00#$E1#$04#$80#$74#$05+
#$00#$40#$6C#$BF#$2F#$F6#$01#$00#$00#$00#$00#$E0#$04#$80#$74#$05#$00#$40#$6C#$BF#$2F#$F6#$01#$00#$00#$00#$00#$DF+
#$04#$80#$74#$05#$00#$40#$6C#$BF#$2F#$F6#$01#$00#$00#$00#$00#$01#$12#$00#$80#$4C#$5E#$AB#$61#$01#$03#$00#$00#$00+
#$06#$00#$00#$00#$DE#$04#$80#$74#$05#$00#$40#$6C#$C0#$2F#$F6#$01#$00#$00#$00#$00#$DD#$04#$80#$74#$05#$00#$40#$6C+
#$C0#$2F#$F6#$01#$00#$00#$00#$00#$DC#$04#$80#$74#$05#$00#$40#$6C#$C0#$2F#$F6#$01#$00#$00#$00#$00#$DB#$04#$80#$74+
#$05#$00#$40#$6C#$C0#$2F#$F6#$01#$00#$00#$00#$00#$DA#$04#$80#$74#$05#$00#$40#$6C#$C0#$2F#$F6#$01#$00#$00#$00#$00+
#$D9#$04#$80#$74#$05#$00#$40#$6C#$C0#$2F#$F6#$01#$00#$00#$00#$00#$01#$13#$00#$80#$4C#$5F#$AB#$61#$01#$03#$00#$00+
#$00#$06#$00#$00#$00#$FC#$04#$80#$74#$56#$00#$40#$6C#$C1#$2F#$F6#$01#$00#$00#$00#$00#$FB#$04#$80#$74#$56#$00#$40+
#$6C#$C1#$2F#$F6#$01#$00#$00#$00#$00#$FA#$04#$80#$74#$56#$00#$40#$6C#$C1#$2F#$F6#$01#$00#$00#$00#$00#$F9#$04#$80+
#$74#$56#$00#$40#$6C#$C1#$2F#$F6#$01#$00#$00#$00#$00#$F8#$04#$80#$74#$56#$00#$40#$6C#$C1#$2F#$F6#$01#$00#$00#$00+
#$00#$F7#$04#$80#$74#$56#$00#$40#$6C#$C1#$2F#$F6#$01#$00#$00#$00#$00#$01#$14#$00#$80#$4C#$60#$AB#$61#$01#$03#$00+
#$00#$00#$06#$00#$00#$00#$F6#$04#$80#$74#$56#$00#$40#$6C#$C2#$2F#$F6#$01#$00#$00#$00#$00#$F5#$04#$80#$74#$56#$00+
#$40#$6C#$C2#$2F#$F6#$01#$00#$00#$00#$00#$F4#$04#$80#$74#$56#$00#$40#$6C#$C2#$2F#$F6#$01#$00#$00#$00#$00#$F3#$04+
#$80#$74#$56#$00#$40#$6C#$C2#$2F#$F6#$01#$00#$00#$00#$00#$F2#$04#$80#$74#$56#$00#$40#$6C#$C2#$2F#$F6#$01#$00#$00+
#$00#$00#$F1#$04#$80#$74#$56#$00#$40#$6C#$C2#$2F#$F6#$01#$00#$00#$00#$00#$01#$15#$00#$80#$4C#$61#$AB#$61#$01#$03+
#$00#$00#$00#$06#$00#$00#$00#$F0#$04#$80#$74#$56#$00#$40#$6C#$C3#$2F#$F6#$01#$00#$00#$00#$00#$EF#$04#$80#$74#$56+
#$00#$40#$6C#$C3#$2F#$F6#$01#$00#$00#$00#$00#$EE#$04#$80#$74#$56#$00#$40#$6C#$C3#$2F#$F6#$01#$00#$00#$00#$00#$ED+
#$04#$80#$74#$56#$00#$40#$6C#$C3#$2F#$F6#$01#$00#$00#$00#$00#$EC#$04#$80#$74#$56#$00#$40#$6C#$C3#$2F#$F6#$01#$00+
#$00#$00#$00#$EB#$04#$80#$74#$56#$00#$40#$6C#$C3#$2F#$F6#$01#$00#$00#$00#$00#$01#$16#$00#$80#$4C#$62#$AB#$61#$01+
#$03#$00#$00#$00#$09#$00#$00#$00#$05#$05#$80#$74#$04#$00#$40#$6C#$C4#$2F#$F6#$01#$00#$00#$00#$00#$04#$05#$80#$74+
#$04#$00#$40#$6C#$C5#$2F#$F6#$01#$00#$00#$00#$00#$03#$05#$80#$74#$04#$00#$40#$6C#$C6#$2F#$F6#$01#$00#$00#$00#$00+
#$02#$05#$80#$74#$04#$00#$40#$6C#$C7#$2F#$F6#$01#$00#$00#$00#$00#$01#$05#$80#$74#$04#$00#$40#$6C#$C8#$2F#$F6#$01+
#$00#$00#$00#$00#$00#$05#$80#$74#$04#$00#$40#$6C#$C9#$2F#$F6#$01#$00#$00#$00#$00#$FF#$04#$80#$74#$04#$00#$40#$6C+
#$CA#$2F#$F6#$01#$00#$00#$00#$00#$FE#$04#$80#$74#$04#$00#$40#$6C#$CB#$2F#$F6#$01#$00#$00#$00#$00#$FD#$04#$80#$74+
#$04#$00#$40#$6C#$CC#$2F#$F6#$01#$00#$00#$00#$00#$01#$17#$00#$80#$4C#$63#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00+
#$00#$10#$05#$80#$74#$04#$00#$40#$6C#$CD#$2F#$F6#$01#$00#$00#$00#$00#$0F#$05#$80#$74#$04#$00#$40#$6C#$CE#$2F#$F6+
#$01#$00#$00#$00#$00#$0E#$05#$80#$74#$04#$00#$40#$6C#$CF#$2F#$F6#$01#$00#$00#$00#$00#$0D#$05#$80#$74#$04#$00#$40+
#$6C#$D0#$2F#$F6#$01#$00#$00#$00#$00#$0C#$05#$80#$74#$04#$00#$40#$6C#$D1#$2F#$F6#$01#$00#$00#$00#$00#$0B#$05#$80+
#$74#$04#$00#$40#$6C#$D2#$2F#$F6#$01#$00#$00#$00#$00#$01#$18#$00#$80#$4C#$64#$AB#$61#$01#$03#$00#$00#$00#$05#$00+
#$00#$00#$0A#$05#$80#$74#$04#$00#$40#$6C#$D3#$2F#$F6#$01#$00#$00#$00#$00#$09#$05#$80#$74#$04#$00#$40#$6C#$D4#$2F+
#$F6#$01#$00#$00#$00#$00#$08#$05#$80#$74#$04#$00#$40#$6C#$D5#$2F#$F6#$01#$00#$00#$00#$00#$07#$05#$80#$74#$04#$00+
#$40#$6C#$D6#$2F#$F6#$01#$00#$00#$00#$00#$06#$05#$80#$74#$04#$00#$40#$6C#$D7#$2F#$F6#$01#$00#$00#$00#$00#$01#$19+
#$00#$80#$4C#$65#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$2E#$06#$80#$74#$04#$00#$40#$6C#$D8#$2F#$F6#$01#$00+
#$00#$00#$00#$2F#$06#$80#$74#$04#$00#$40#$6C#$D9#$2F#$F6#$01#$00#$00#$00#$00#$30#$06#$80#$74#$04#$00#$40#$6C#$DA+
#$2F#$F6#$01#$00#$00#$00#$00#$31#$06#$80#$74#$04#$00#$40#$6C#$DB#$2F#$F6#$01#$00#$00#$00#$00#$32#$06#$80#$74#$04+
#$00#$40#$6C#$DC#$2F#$F6#$01#$00#$00#$00#$00#$34#$06#$80#$74#$04#$00#$40#$6C#$DD#$2F#$F6#$01#$00#$00#$00#$00#$01+
#$1A#$00#$80#$4C#$66#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$1B#$04#$80#$74#$04#$00#$40#$6C#$DE#$2F#$F6#$01+
#$00#$00#$00#$00#$1A#$04#$80#$74#$04#$00#$40#$6C#$DF#$2F#$F6#$01#$00#$00#$00#$00#$19#$04#$80#$74#$04#$00#$40#$6C+
#$E0#$2F#$F6#$01#$00#$00#$00#$00#$18#$04#$80#$74#$04#$00#$40#$6C#$E1#$2F#$F6#$01#$00#$00#$00#$00#$17#$04#$80#$74+
#$04#$00#$40#$6C#$E2#$2F#$F6#$01#$00#$00#$00#$00#$16#$04#$80#$74#$04#$00#$40#$6C#$E3#$2F#$F6#$01#$00#$00#$00#$00+
#$01#$1B#$00#$80#$4C#$67#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$15#$04#$80#$74#$04#$00#$40#$6C#$E4#$2F#$F6+
#$01#$00#$00#$00#$00#$14#$04#$80#$74#$04#$00#$40#$6C#$E5#$2F#$F6#$01#$00#$00#$00#$00#$13#$04#$80#$74#$04#$00#$40+
#$6C#$E6#$2F#$F6#$01#$00#$00#$00#$00#$12#$04#$80#$74#$04#$00#$40#$6C#$E7#$2F#$F6#$01#$00#$00#$00#$00#$11#$04#$80+
#$74#$04#$00#$40#$6C#$E8#$2F#$F6#$01#$00#$00#$00#$00#$10#$04#$80#$74#$04#$00#$40#$6C#$E9#$2F#$F6#$01#$00#$00#$00+
#$00#$01#$1C#$00#$80#$4C#$68#$AB#$61#$01#$04#$00#$00#$00#$06#$00#$00#$00#$1F#$07#$80#$74#$A0#$00#$40#$6C#$AC#$67+
#$F7#$01#$2C#$BE#$94#$52#$20#$07#$80#$74#$A0#$00#$40#$6C#$28#$C4#$F8#$01#$D4#$49#$97#$52#$21#$07#$80#$74#$A0#$00+
#$40#$6C#$4D#$53#$FD#$01#$AD#$30#$9F#$52#$22#$07#$80#$74#$A0#$00#$40#$6C#$D7#$96#$05#$02#$C4#$68#$AC#$52#$23#$07+
#$80#$74#$A0#$00#$40#$6C#$CC#$BB#$0D#$02#$55#$3F#$B8#$52#$24#$07#$80#$74#$A0#$00#$40#$6C#$EA#$2F#$F6#$01#$39#$4D+
#$EA#$52#$01#$1D#$00#$80#$4C#$69#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$25#$07#$80#$74#$A0#$00#$40#$6C#$EB+
#$2F#$F6#$01#$00#$00#$00#$00#$26#$07#$80#$74#$A0#$00#$40#$6C#$EB#$2F#$F6#$01#$00#$00#$00#$00#$27#$07#$80#$74#$A0+
#$00#$40#$6C#$EB#$2F#$F6#$01#$00#$00#$00#$00#$28#$07#$80#$74#$A0#$00#$40#$6C#$EB#$2F#$F6#$01#$00#$00#$00#$00#$29+
#$07#$80#$74#$A0#$00#$40#$6C#$EB#$2F#$F6#$01#$00#$00#$00#$00#$2A#$07#$80#$74#$A0#$00#$40#$6C#$EB#$2F#$F6#$01#$00+
#$00#$00#$00#$01#$1E#$00#$80#$4C#$6A#$AB#$61#$01#$03#$00#$00#$00#$08#$00#$00#$00#$34#$07#$80#$74#$04#$00#$40#$6C+
#$EC#$2F#$F6#$01#$00#$00#$00#$00#$35#$07#$80#$74#$04#$00#$40#$6C#$ED#$2F#$F6#$01#$00#$00#$00#$00#$36#$07#$80#$74+
#$04#$00#$40#$6C#$EE#$2F#$F6#$01#$00#$00#$00#$00#$37#$07#$80#$74#$04#$00#$40#$6C#$EF#$2F#$F6#$01#$00#$00#$00#$00+
#$38#$07#$80#$74#$04#$00#$40#$6C#$F0#$2F#$F6#$01#$00#$00#$00#$00#$39#$07#$80#$74#$04#$00#$40#$6C#$F1#$2F#$F6#$01+
#$00#$00#$00#$00#$3A#$07#$80#$74#$04#$00#$40#$6C#$F2#$2F#$F6#$01#$00#$00#$00#$00#$3B#$07#$80#$74#$04#$00#$40#$6C+
#$F3#$2F#$F6#$01#$00#$00#$00#$00#$01#$1F#$00#$80#$4C#$6B#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$3C#$07#$80+
#$74#$9A#$00#$40#$6C#$F4#$2F#$F6#$01#$00#$00#$00#$00#$3D#$07#$80#$74#$9A#$00#$40#$6C#$F4#$2F#$F6#$01#$00#$00#$00+
#$00#$3E#$07#$80#$74#$9A#$00#$40#$6C#$F4#$2F#$F6#$01#$00#$00#$00#$00#$3F#$07#$80#$74#$9A#$00#$40#$6C#$F4#$2F#$F6+
#$01#$00#$00#$00#$00#$40#$07#$80#$74#$9A#$00#$40#$6C#$F4#$2F#$F6#$01#$00#$00#$00#$00#$41#$07#$80#$74#$9A#$00#$40+
#$6C#$F4#$2F#$F6#$01#$00#$00#$00#$00#$42#$07#$80#$74#$9A#$00#$40#$6C#$F4#$2F#$F6#$01#$00#$00#$00#$00#$43#$07#$80+
#$74#$9A#$00#$40#$6C#$F4#$2F#$F6#$01#$00#$00#$00#$00#$44#$07#$80#$74#$9A#$00#$40#$6C#$F4#$2F#$F6#$01#$00#$00#$00+
#$00#$01#$20#$00#$80#$4C#$6C#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$45#$07#$80#$74#$98#$00#$40#$6C#$F5#$2F+
#$F6#$01#$00#$00#$00#$00#$46#$07#$80#$74#$98#$00#$40#$6C#$F5#$2F#$F6#$01#$00#$00#$00#$00#$47#$07#$80#$74#$98#$00+
#$40#$6C#$F5#$2F#$F6#$01#$00#$00#$00#$00#$48#$07#$80#$74#$98#$00#$40#$6C#$F5#$2F#$F6#$01#$00#$00#$00#$00#$49#$07+
#$80#$74#$98#$00#$40#$6C#$F5#$2F#$F6#$01#$00#$00#$00#$00#$4A#$07#$80#$74#$98#$00#$40#$6C#$F5#$2F#$F6#$01#$00#$00+
#$00#$00#$4B#$07#$80#$74#$98#$00#$40#$6C#$F5#$2F#$F6#$01#$00#$00#$00#$00#$4C#$07#$80#$74#$98#$00#$40#$6C#$F5#$2F+
#$F6#$01#$00#$00#$00#$00#$4D#$07#$80#$74#$98#$00#$40#$6C#$F5#$2F#$F6#$01#$00#$00#$00#$00#$01#$21#$00#$80#$4C#$6D+
#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$4E#$07#$80#$74#$99#$00#$40#$6C#$F6#$2F#$F6#$01#$00#$00#$00#$00#$4F+
#$07#$80#$74#$99#$00#$40#$6C#$F6#$2F#$F6#$01#$00#$00#$00#$00#$50#$07#$80#$74#$99#$00#$40#$6C#$F6#$2F#$F6#$01#$00+
#$00#$00#$00#$51#$07#$80#$74#$99#$00#$40#$6C#$F6#$2F#$F6#$01#$00#$00#$00#$00#$52#$07#$80#$74#$99#$00#$40#$6C#$F6+
#$2F#$F6#$01#$00#$00#$00#$00#$53#$07#$80#$74#$99#$00#$40#$6C#$F6#$2F#$F6#$01#$00#$00#$00#$00#$54#$07#$80#$74#$99+
#$00#$40#$6C#$F6#$2F#$F6#$01#$00#$00#$00#$00#$55#$07#$80#$74#$99#$00#$40#$6C#$F6#$2F#$F6#$01#$00#$00#$00#$00#$56+
#$07#$80#$74#$99#$00#$40#$6C#$F6#$2F#$F6#$01#$00#$00#$00#$00#$01#$22#$00#$80#$4C#$6E#$AB#$61#$01#$03#$00#$00#$00+
#$09#$00#$00#$00#$CF#$07#$80#$74#$0B#$00#$40#$6C#$F7#$2F#$F6#$01#$00#$00#$00#$00#$D0#$07#$80#$74#$0B#$00#$40#$6C+
#$F7#$2F#$F6#$01#$00#$00#$00#$00#$D1#$07#$80#$74#$0B#$00#$40#$6C#$F7#$2F#$F6#$01#$00#$00#$00#$00#$D2#$07#$80#$74+
#$0B#$00#$40#$6C#$F7#$2F#$F6#$01#$00#$00#$00#$00#$D3#$07#$80#$74#$0B#$00#$40#$6C#$F7#$2F#$F6#$01#$00#$00#$00#$00+
#$D4#$07#$80#$74#$0B#$00#$40#$6C#$F7#$2F#$F6#$01#$00#$00#$00#$00#$D5#$07#$80#$74#$0B#$00#$40#$6C#$F7#$2F#$F6#$01+
#$00#$00#$00#$00#$D6#$07#$80#$74#$0B#$00#$40#$6C#$F7#$2F#$F6#$01#$00#$00#$00#$00#$D7#$07#$80#$74#$0B#$00#$40#$6C+
#$F7#$2F#$F6#$01#$00#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$1D#$02#$00#$00#$00#$00#$5E#$00#$00#$00#$12#$00#$00#$00#$01#$01#$00#$C0#$4C#$6F#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$19#$05#$80#$74#$20#$00#$40#$6C#$F8#$2F#$F6#$01#$00#$00#$00#$00#$18#$05#$80#$74#$20#$00#$40#$6C#$F8+
#$2F#$F6#$01#$00#$00#$00#$00#$17#$05#$80#$74#$20#$00#$40#$6C#$F8#$2F#$F6#$01#$00#$00#$00#$00#$16#$05#$80#$74#$20+
#$00#$40#$6C#$F8#$2F#$F6#$01#$00#$00#$00#$00#$15#$05#$80#$74#$20#$00#$40#$6C#$F8#$2F#$F6#$01#$00#$00#$00#$00#$14+
#$05#$80#$74#$20#$00#$40#$6C#$F8#$2F#$F6#$01#$00#$00#$00#$00#$13#$05#$80#$74#$20#$00#$40#$6C#$F8#$2F#$F6#$01#$00+
#$00#$00#$00#$12#$05#$80#$74#$20#$00#$40#$6C#$F8#$2F#$F6#$01#$00#$00#$00#$00#$11#$05#$80#$74#$20#$00#$40#$6C#$F8+
#$2F#$F6#$01#$00#$00#$00#$00#$01#$02#$00#$C0#$4C#$70#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$22#$05#$80#$74+
#$21#$00#$40#$6C#$F9#$2F#$F6#$01#$00#$00#$00#$00#$21#$05#$80#$74#$21#$00#$40#$6C#$F9#$2F#$F6#$01#$00#$00#$00#$00+
#$20#$05#$80#$74#$21#$00#$40#$6C#$F9#$2F#$F6#$01#$00#$00#$00#$00#$1F#$05#$80#$74#$21#$00#$40#$6C#$F9#$2F#$F6#$01+
#$00#$00#$00#$00#$1E#$05#$80#$74#$21#$00#$40#$6C#$F9#$2F#$F6#$01#$00#$00#$00#$00#$1D#$05#$80#$74#$21#$00#$40#$6C+
#$F9#$2F#$F6#$01#$00#$00#$00#$00#$1C#$05#$80#$74#$21#$00#$40#$6C#$F9#$2F#$F6#$01#$00#$00#$00#$00#$1B#$05#$80#$74+
#$21#$00#$40#$6C#$F9#$2F#$F6#$01#$00#$00#$00#$00#$1A#$05#$80#$74#$21#$00#$40#$6C#$F9#$2F#$F6#$01#$00#$00#$00#$00+
#$01#$03#$00#$C0#$4C#$71#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$2B#$05#$80#$74#$2B#$00#$40#$6C#$FA#$2F#$F6+
#$01#$00#$00#$00#$00#$2A#$05#$80#$74#$2B#$00#$40#$6C#$FA#$2F#$F6#$01#$00#$00#$00#$00#$29#$05#$80#$74#$2B#$00#$40+
#$6C#$FA#$2F#$F6#$01#$00#$00#$00#$00#$28#$05#$80#$74#$2B#$00#$40#$6C#$FA#$2F#$F6#$01#$00#$00#$00#$00#$27#$05#$80+
#$74#$2B#$00#$40#$6C#$FA#$2F#$F6#$01#$00#$00#$00#$00#$26#$05#$80#$74#$2B#$00#$40#$6C#$FA#$2F#$F6#$01#$00#$00#$00+
#$00#$25#$05#$80#$74#$2B#$00#$40#$6C#$FA#$2F#$F6#$01#$00#$00#$00#$00#$24#$05#$80#$74#$2B#$00#$40#$6C#$FA#$2F#$F6+
#$01#$00#$00#$00#$00#$23#$05#$80#$74#$2B#$00#$40#$6C#$FA#$2F#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$C0#$4C#$72#$AB+
#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$34#$05#$80#$74#$22#$00#$40#$6C#$FB#$2F#$F6#$01#$00#$00#$00#$00#$33#$05+
#$80#$74#$22#$00#$40#$6C#$FB#$2F#$F6#$01#$00#$00#$00#$00#$32#$05#$80#$74#$22#$00#$40#$6C#$FB#$2F#$F6#$01#$00#$00+
#$00#$00#$31#$05#$80#$74#$22#$00#$40#$6C#$FB#$2F#$F6#$01#$00#$00#$00#$00#$30#$05#$80#$74#$22#$00#$40#$6C#$FB#$2F+
#$F6#$01#$00#$00#$00#$00#$2F#$05#$80#$74#$22#$00#$40#$6C#$FB#$2F#$F6#$01#$00#$00#$00#$00#$2E#$05#$80#$74#$22#$00+
#$40#$6C#$FB#$2F#$F6#$01#$00#$00#$00#$00#$2D#$05#$80#$74#$22#$00#$40#$6C#$FB#$2F#$F6#$01#$00#$00#$00#$00#$2C#$05+
#$80#$74#$22#$00#$40#$6C#$FB#$2F#$F6#$01#$00#$00#$00#$00#$01#$05#$00#$C0#$4C#$73#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$3D#$05#$80#$74#$23#$00#$40#$6C#$FC#$2F#$F6#$01#$00#$00#$00#$00#$3C#$05#$80#$74#$23#$00#$40#$6C#$FC+
#$2F#$F6#$01#$00#$00#$00#$00#$3B#$05#$80#$74#$23#$00#$40#$6C#$FC#$2F#$F6#$01#$00#$00#$00#$00#$3A#$05#$80#$74#$23+
#$00#$40#$6C#$FC#$2F#$F6#$01#$00#$00#$00#$00#$39#$05#$80#$74#$23#$00#$40#$6C#$FC#$2F#$F6#$01#$00#$00#$00#$00#$38+
#$05#$80#$74#$23#$00#$40#$6C#$FC#$2F#$F6#$01#$00#$00#$00#$00#$37#$05#$80#$74#$23#$00#$40#$6C#$FC#$2F#$F6#$01#$00+
#$00#$00#$00#$36#$05#$80#$74#$23#$00#$40#$6C#$FC#$2F#$F6#$01#$00#$00#$00#$00#$35#$05#$80#$74#$23#$00#$40#$6C#$FC+
#$2F#$F6#$01#$00#$00#$00#$00#$01#$06#$00#$C0#$4C#$74#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$46#$05#$80#$74+
#$24#$00#$40#$6C#$FD#$2F#$F6#$01#$00#$00#$00#$00#$45#$05#$80#$74#$24#$00#$40#$6C#$FD#$2F#$F6#$01#$00#$00#$00#$00+
#$44#$05#$80#$74#$24#$00#$40#$6C#$FD#$2F#$F6#$01#$00#$00#$00#$00#$43#$05#$80#$74#$24#$00#$40#$6C#$FD#$2F#$F6#$01+
#$00#$00#$00#$00#$42#$05#$80#$74#$24#$00#$40#$6C#$FD#$2F#$F6#$01#$00#$00#$00#$00#$41#$05#$80#$74#$24#$00#$40#$6C+
#$FD#$2F#$F6#$01#$00#$00#$00#$00#$40#$05#$80#$74#$24#$00#$40#$6C#$FD#$2F#$F6#$01#$00#$00#$00#$00#$3F#$05#$80#$74+
#$24#$00#$40#$6C#$FD#$2F#$F6#$01#$00#$00#$00#$00#$3E#$05#$80#$74#$24#$00#$40#$6C#$FD#$2F#$F6#$01#$00#$00#$00#$00+
#$01#$07#$00#$C0#$4C#$75#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$4F#$05#$80#$74#$25#$00#$40#$6C#$FE#$2F#$F6+
#$01#$00#$00#$00#$00#$4E#$05#$80#$74#$25#$00#$40#$6C#$FE#$2F#$F6#$01#$00#$00#$00#$00#$4D#$05#$80#$74#$25#$00#$40+
#$6C#$FE#$2F#$F6#$01#$00#$00#$00#$00#$4C#$05#$80#$74#$25#$00#$40#$6C#$FE#$2F#$F6#$01#$00#$00#$00#$00#$4B#$05#$80+
#$74#$25#$00#$40#$6C#$FE#$2F#$F6#$01#$00#$00#$00#$00#$4A#$05#$80#$74#$25#$00#$40#$6C#$FE#$2F#$F6#$01#$00#$00#$00+
#$00#$49#$05#$80#$74#$25#$00#$40#$6C#$FE#$2F#$F6#$01#$00#$00#$00#$00#$48#$05#$80#$74#$25#$00#$40#$6C#$FE#$2F#$F6+
#$01#$00#$00#$00#$00#$47#$05#$80#$74#$25#$00#$40#$6C#$FE#$2F#$F6#$01#$00#$00#$00#$00#$01#$08#$00#$C0#$4C#$76#$AB+
#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$58#$05#$80#$74#$26#$00#$40#$6C#$FF#$2F#$F6#$01#$00#$00#$00#$00#$57#$05+
#$80#$74#$26#$00#$40#$6C#$FF#$2F#$F6#$01#$00#$00#$00#$00#$56#$05#$80#$74#$26#$00#$40#$6C#$FF#$2F#$F6#$01#$00#$00+
#$00#$00#$55#$05#$80#$74#$26#$00#$40#$6C#$FF#$2F#$F6#$01#$00#$00#$00#$00#$54#$05#$80#$74#$26#$00#$40#$6C#$FF#$2F+
#$F6#$01#$00#$00#$00#$00#$53#$05#$80#$74#$26#$00#$40#$6C#$FF#$2F#$F6#$01#$00#$00#$00#$00#$52#$05#$80#$74#$26#$00+
#$40#$6C#$FF#$2F#$F6#$01#$00#$00#$00#$00#$51#$05#$80#$74#$26#$00#$40#$6C#$FF#$2F#$F6#$01#$00#$00#$00#$00#$50#$05+
#$80#$74#$26#$00#$40#$6C#$FF#$2F#$F6#$01#$00#$00#$00#$00#$01#$09#$00#$C0#$4C#$77#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$61#$05#$80#$74#$27#$00#$40#$6C#$00#$30#$F6#$01#$00#$00#$00#$00#$60#$05#$80#$74#$27#$00#$40#$6C#$00+
#$30#$F6#$01#$00#$00#$00#$00#$5F#$05#$80#$74#$27#$00#$40#$6C#$00#$30#$F6#$01#$00#$00#$00#$00#$5E#$05#$80#$74#$27+
#$00#$40#$6C#$00#$30#$F6#$01#$00#$00#$00#$00#$5D#$05#$80#$74#$27#$00#$40#$6C#$00#$30#$F6#$01#$00#$00#$00#$00#$5C+
#$05#$80#$74#$27#$00#$40#$6C#$00#$30#$F6#$01#$00#$00#$00#$00#$5B#$05#$80#$74#$27#$00#$40#$6C#$00#$30#$F6#$01#$00+
#$00#$00#$00#$5A#$05#$80#$74#$27#$00#$40#$6C#$00#$30#$F6#$01#$00#$00#$00#$00#$59#$05#$80#$74#$27#$00#$40#$6C#$00+
#$30#$F6#$01#$00#$00#$00#$00#$01#$0A#$00#$C0#$4C#$78#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$6A#$05#$80#$74+
#$28#$00#$40#$6C#$01#$30#$F6#$01#$00#$00#$00#$00#$69#$05#$80#$74#$28#$00#$40#$6C#$01#$30#$F6#$01#$00#$00#$00#$00+
#$68#$05#$80#$74#$28#$00#$40#$6C#$01#$30#$F6#$01#$00#$00#$00#$00#$67#$05#$80#$74#$28#$00#$40#$6C#$01#$30#$F6#$01+
#$00#$00#$00#$00#$66#$05#$80#$74#$28#$00#$40#$6C#$01#$30#$F6#$01#$00#$00#$00#$00#$65#$05#$80#$74#$28#$00#$40#$6C+
#$01#$30#$F6#$01#$00#$00#$00#$00#$64#$05#$80#$74#$28#$00#$40#$6C#$01#$30#$F6#$01#$00#$00#$00#$00#$63#$05#$80#$74+
#$28#$00#$40#$6C#$01#$30#$F6#$01#$00#$00#$00#$00#$62#$05#$80#$74#$28#$00#$40#$6C#$01#$30#$F6#$01#$00#$00#$00#$00+
#$01#$0B#$00#$C0#$4C#$79#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$73#$05#$80#$74#$29#$00#$40#$6C#$02#$30#$F6+
#$01#$00#$00#$00#$00#$72#$05#$80#$74#$29#$00#$40#$6C#$02#$30#$F6#$01#$00#$00#$00#$00#$71#$05#$80#$74#$29#$00#$40+
#$6C#$02#$30#$F6#$01#$00#$00#$00#$00#$70#$05#$80#$74#$29#$00#$40#$6C#$02#$30#$F6#$01#$00#$00#$00#$00#$6F#$05#$80+
#$74#$29#$00#$40#$6C#$02#$30#$F6#$01#$00#$00#$00#$00#$6E#$05#$80#$74#$29#$00#$40#$6C#$02#$30#$F6#$01#$00#$00#$00+
#$00#$6D#$05#$80#$74#$29#$00#$40#$6C#$02#$30#$F6#$01#$00#$00#$00#$00#$6C#$05#$80#$74#$29#$00#$40#$6C#$02#$30#$F6+
#$01#$00#$00#$00#$00#$6B#$05#$80#$74#$29#$00#$40#$6C#$02#$30#$F6#$01#$00#$00#$00#$00#$01#$0C#$00#$C0#$4C#$7A#$AB+
#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$7C#$05#$80#$74#$2A#$00#$40#$6C#$03#$30#$F6#$01#$00#$00#$00#$00#$7B#$05+
#$80#$74#$2A#$00#$40#$6C#$03#$30#$F6#$01#$00#$00#$00#$00#$7A#$05#$80#$74#$2A#$00#$40#$6C#$03#$30#$F6#$01#$00#$00+
#$00#$00#$79#$05#$80#$74#$2A#$00#$40#$6C#$03#$30#$F6#$01#$00#$00#$00#$00#$78#$05#$80#$74#$2A#$00#$40#$6C#$03#$30+
#$F6#$01#$00#$00#$00#$00#$77#$05#$80#$74#$2A#$00#$40#$6C#$03#$30#$F6#$01#$00#$00#$00#$00#$76#$05#$80#$74#$2A#$00+
#$40#$6C#$03#$30#$F6#$01#$00#$00#$00#$00#$75#$05#$80#$74#$2A#$00#$40#$6C#$03#$30#$F6#$01#$00#$00#$00#$00#$74#$05+
#$80#$74#$2A#$00#$40#$6C#$03#$30#$F6#$01#$00#$00#$00#$00#$01#$0D#$00#$C0#$4C#$7B#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$85#$05#$80#$74#$2C#$00#$40#$6C#$04#$30#$F6#$01#$00#$00#$00#$00#$84#$05#$80#$74#$2C#$00#$40#$6C#$04+
#$30#$F6#$01#$00#$00#$00#$00#$83#$05#$80#$74#$2C#$00#$40#$6C#$04#$30#$F6#$01#$00#$00#$00#$00#$82#$05#$80#$74#$2C+
#$00#$40#$6C#$04#$30#$F6#$01#$00#$00#$00#$00#$81#$05#$80#$74#$2C#$00#$40#$6C#$04#$30#$F6#$01#$00#$00#$00#$00#$80+
#$05#$80#$74#$2C#$00#$40#$6C#$04#$30#$F6#$01#$00#$00#$00#$00#$7F#$05#$80#$74#$2C#$00#$40#$6C#$04#$30#$F6#$01#$00+
#$00#$00#$00#$7E#$05#$80#$74#$2C#$00#$40#$6C#$04#$30#$F6#$01#$00#$00#$00#$00#$7D#$05#$80#$74#$2C#$00#$40#$6C#$04+
#$30#$F6#$01#$00#$00#$00#$00#$01#$0E#$00#$C0#$4C#$7C#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$8E#$05#$80#$74+
#$2D#$00#$40#$6C#$05#$30#$F6#$01#$00#$00#$00#$00#$8D#$05#$80#$74#$2D#$00#$40#$6C#$05#$30#$F6#$01#$00#$00#$00#$00+
#$8C#$05#$80#$74#$2D#$00#$40#$6C#$05#$30#$F6#$01#$00#$00#$00#$00#$8B#$05#$80#$74#$2D#$00#$40#$6C#$05#$30#$F6#$01+
#$00#$00#$00#$00#$8A#$05#$80#$74#$2D#$00#$40#$6C#$05#$30#$F6#$01#$00#$00#$00#$00#$89#$05#$80#$74#$2D#$00#$40#$6C+
#$05#$30#$F6#$01#$00#$00#$00#$00#$88#$05#$80#$74#$2D#$00#$40#$6C#$05#$30#$F6#$01#$00#$00#$00#$00#$87#$05#$80#$74+
#$2D#$00#$40#$6C#$05#$30#$F6#$01#$00#$00#$00#$00#$86#$05#$80#$74#$2D#$00#$40#$6C#$05#$30#$F6#$01#$00#$00#$00#$00+
#$01#$0F#$00#$C0#$4C#$7D#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$97#$05#$80#$74#$2E#$00#$40#$6C#$06#$30#$F6+
#$01#$00#$00#$00#$00#$96#$05#$80#$74#$2E#$00#$40#$6C#$06#$30#$F6#$01#$00#$00#$00#$00#$95#$05#$80#$74#$2E#$00#$40+
#$6C#$06#$30#$F6#$01#$00#$00#$00#$00#$94#$05#$80#$74#$2E#$00#$40#$6C#$06#$30#$F6#$01#$00#$00#$00#$00#$93#$05#$80+
#$74#$2E#$00#$40#$6C#$06#$30#$F6#$01#$00#$00#$00#$00#$92#$05#$80#$74#$2E#$00#$40#$6C#$06#$30#$F6#$01#$00#$00#$00+
#$00#$91#$05#$80#$74#$2E#$00#$40#$6C#$06#$30#$F6#$01#$00#$00#$00#$00#$90#$05#$80#$74#$2E#$00#$40#$6C#$06#$30#$F6+
#$01#$00#$00#$00#$00#$8F#$05#$80#$74#$2E#$00#$40#$6C#$06#$30#$F6#$01#$00#$00#$00#$00#$01#$10#$00#$C0#$4C#$7E#$AB+
#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$A0#$05#$80#$74#$2F#$00#$40#$6C#$07#$30#$F6#$01#$00#$00#$00#$00#$9F#$05+
#$80#$74#$2F#$00#$40#$6C#$07#$30#$F6#$01#$00#$00#$00#$00#$9E#$05#$80#$74#$2F#$00#$40#$6C#$07#$30#$F6#$01#$00#$00+
#$00#$00#$9D#$05#$80#$74#$2F#$00#$40#$6C#$07#$30#$F6#$01#$00#$00#$00#$00#$9C#$05#$80#$74#$2F#$00#$40#$6C#$07#$30+
#$F6#$01#$00#$00#$00#$00#$9B#$05#$80#$74#$2F#$00#$40#$6C#$07#$30#$F6#$01#$00#$00#$00#$00#$9A#$05#$80#$74#$2F#$00+
#$40#$6C#$07#$30#$F6#$01#$00#$00#$00#$00#$99#$05#$80#$74#$2F#$00#$40#$6C#$07#$30#$F6#$01#$00#$00#$00#$00#$98#$05+
#$80#$74#$2F#$00#$40#$6C#$07#$30#$F6#$01#$00#$00#$00#$00#$01#$11#$00#$C0#$4C#$7F#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$A9#$05#$80#$74#$30#$00#$40#$6C#$08#$30#$F6#$01#$00#$00#$00#$00#$A8#$05#$80#$74#$30#$00#$40#$6C#$08+
#$30#$F6#$01#$00#$00#$00#$00#$A7#$05#$80#$74#$30#$00#$40#$6C#$08#$30#$F6#$01#$00#$00#$00#$00#$A6#$05#$80#$74#$30+
#$00#$40#$6C#$08#$30#$F6#$01#$00#$00#$00#$00#$A5#$05#$80#$74#$30#$00#$40#$6C#$08#$30#$F6#$01#$00#$00#$00#$00#$A4+
#$05#$80#$74#$30#$00#$40#$6C#$08#$30#$F6#$01#$00#$00#$00#$00#$A3#$05#$80#$74#$30#$00#$40#$6C#$08#$30#$F6#$01#$00+
#$00#$00#$00#$A2#$05#$80#$74#$30#$00#$40#$6C#$08#$30#$F6#$01#$00#$00#$00#$00#$A1#$05#$80#$74#$30#$00#$40#$6C#$08+
#$30#$F6#$01#$00#$00#$00#$00#$01#$12#$00#$C0#$4C#$80#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$B2#$05#$80#$74+
#$31#$00#$40#$6C#$09#$30#$F6#$01#$00#$00#$00#$00#$B1#$05#$80#$74#$31#$00#$40#$6C#$09#$30#$F6#$01#$00#$00#$00#$00+
#$B0#$05#$80#$74#$31#$00#$40#$6C#$09#$30#$F6#$01#$00#$00#$00#$00#$AF#$05#$80#$74#$31#$00#$40#$6C#$09#$30#$F6#$01+
#$00#$00#$00#$00#$AE#$05#$80#$74#$31#$00#$40#$6C#$09#$30#$F6#$01#$00#$00#$00#$00#$AD#$05#$80#$74#$31#$00#$40#$6C+
#$09#$30#$F6#$01#$00#$00#$00#$00#$AC#$05#$80#$74#$31#$00#$40#$6C#$09#$30#$F6#$01#$00#$00#$00#$00#$AB#$05#$80#$74+
#$31#$00#$40#$6C#$09#$30#$F6#$01#$00#$00#$00#$00#$AA#$05#$80#$74#$31#$00#$40#$6C#$09#$30#$F6#$01#$00#$00#$00#$00),Lista[i].key));


Lista[i].socket.sendtext(EncryptS(Compress(#$1D#$02#$00#$00#$00#$00#$4C#$00#$00#$00#$12#$00#$00#$00#$01#$13#$00#$C0#$4C#$81#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$24#$06#$80#$74#$6D#$00#$40#$6C#$0A#$30#$F6#$01#$00#$00#$00#$00#$23#$06#$80#$74#$6D#$00#$40#$6C#$0A+
#$30#$F6#$01#$00#$00#$00#$00#$22#$06#$80#$74#$6D#$00#$40#$6C#$0A#$30#$F6#$01#$00#$00#$00#$00#$21#$06#$80#$74#$6D+
#$00#$40#$6C#$0A#$30#$F6#$01#$00#$00#$00#$00#$20#$06#$80#$74#$6D#$00#$40#$6C#$0A#$30#$F6#$01#$00#$00#$00#$00#$1F+
#$06#$80#$74#$6D#$00#$40#$6C#$0A#$30#$F6#$01#$00#$00#$00#$00#$1E#$06#$80#$74#$6D#$00#$40#$6C#$0A#$30#$F6#$01#$00+
#$00#$00#$00#$1D#$06#$80#$74#$6D#$00#$40#$6C#$0A#$30#$F6#$01#$00#$00#$00#$00#$1C#$06#$80#$74#$6D#$00#$40#$6C#$0A+
#$30#$F6#$01#$00#$00#$00#$00#$01#$14#$00#$C0#$4C#$82#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$E1#$07#$80#$74+
#$A1#$00#$40#$6C#$0B#$30#$F6#$01#$00#$00#$00#$00#$E2#$07#$80#$74#$A1#$00#$40#$6C#$0B#$30#$F6#$01#$00#$00#$00#$00+
#$E3#$07#$80#$74#$A1#$00#$40#$6C#$0B#$30#$F6#$01#$00#$00#$00#$00#$E4#$07#$80#$74#$A1#$00#$40#$6C#$0B#$30#$F6#$01+
#$00#$00#$00#$00#$E5#$07#$80#$74#$A1#$00#$40#$6C#$0B#$30#$F6#$01#$00#$00#$00#$00#$E6#$07#$80#$74#$A1#$00#$40#$6C+
#$0B#$30#$F6#$01#$00#$00#$00#$00#$E7#$07#$80#$74#$A1#$00#$40#$6C#$0B#$30#$F6#$01#$00#$00#$00#$00#$E8#$07#$80#$74+
#$A1#$00#$40#$6C#$0B#$30#$F6#$01#$00#$00#$00#$00#$E9#$07#$80#$74#$A1#$00#$40#$6C#$0B#$30#$F6#$01#$00#$00#$00#$00+
#$01#$01#$00#$00#$4D#$83#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$6C#$04#$80#$74#$4F#$00#$40#$6C#$0C#$30#$F6+
#$01#$00#$00#$00#$00#$6B#$04#$80#$74#$4F#$00#$40#$6C#$0C#$30#$F6#$01#$00#$00#$00#$00#$6A#$04#$80#$74#$4F#$00#$40+
#$6C#$0C#$30#$F6#$01#$00#$00#$00#$00#$69#$04#$80#$74#$4F#$00#$40#$6C#$0C#$30#$F6#$01#$00#$00#$00#$00#$68#$04#$80+
#$74#$4F#$00#$40#$6C#$0C#$30#$F6#$01#$00#$00#$00#$00#$67#$04#$80#$74#$4F#$00#$40#$6C#$0C#$30#$F6#$01#$00#$00#$00+
#$00#$66#$04#$80#$74#$4F#$00#$40#$6C#$0C#$30#$F6#$01#$00#$00#$00#$00#$65#$04#$80#$74#$4F#$00#$40#$6C#$0C#$30#$F6+
#$01#$00#$00#$00#$00#$64#$04#$80#$74#$4F#$00#$40#$6C#$0C#$30#$F6#$01#$00#$00#$00#$00#$01#$02#$00#$00#$4D#$84#$AB+
#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$35#$06#$80#$74#$70#$00#$40#$6C#$0D#$30#$F6#$01#$00#$00#$00#$00#$36#$06+
#$80#$74#$70#$00#$40#$6C#$0D#$30#$F6#$01#$00#$00#$00#$00#$37#$06#$80#$74#$70#$00#$40#$6C#$0D#$30#$F6#$01#$00#$00+
#$00#$00#$38#$06#$80#$74#$70#$00#$40#$6C#$0D#$30#$F6#$01#$00#$00#$00#$00#$39#$06#$80#$74#$70#$00#$40#$6C#$0D#$30+
#$F6#$01#$00#$00#$00#$00#$3A#$06#$80#$74#$70#$00#$40#$6C#$0D#$30#$F6#$01#$00#$00#$00#$00#$3B#$06#$80#$74#$70#$00+
#$40#$6C#$0D#$30#$F6#$01#$00#$00#$00#$00#$3C#$06#$80#$74#$70#$00#$40#$6C#$0D#$30#$F6#$01#$00#$00#$00#$00#$3D#$06+
#$80#$74#$70#$00#$40#$6C#$0D#$30#$F6#$01#$00#$00#$00#$00#$01#$03#$00#$00#$4D#$85#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$3E#$06#$80#$74#$71#$00#$40#$6C#$0E#$30#$F6#$01#$00#$00#$00#$00#$3F#$06#$80#$74#$71#$00#$40#$6C#$0E+
#$30#$F6#$01#$00#$00#$00#$00#$40#$06#$80#$74#$71#$00#$40#$6C#$0E#$30#$F6#$01#$00#$00#$00#$00#$41#$06#$80#$74#$71+
#$00#$40#$6C#$0E#$30#$F6#$01#$00#$00#$00#$00#$42#$06#$80#$74#$71#$00#$40#$6C#$0E#$30#$F6#$01#$00#$00#$00#$00#$43+
#$06#$80#$74#$71#$00#$40#$6C#$0E#$30#$F6#$01#$00#$00#$00#$00#$44#$06#$80#$74#$71#$00#$40#$6C#$0E#$30#$F6#$01#$00+
#$00#$00#$00#$45#$06#$80#$74#$71#$00#$40#$6C#$0E#$30#$F6#$01#$00#$00#$00#$00#$46#$06#$80#$74#$71#$00#$40#$6C#$0E+
#$30#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$00#$4D#$86#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$47#$06#$80#$74+
#$72#$00#$40#$6C#$0F#$30#$F6#$01#$00#$00#$00#$00#$48#$06#$80#$74#$72#$00#$40#$6C#$0F#$30#$F6#$01#$00#$00#$00#$00+
#$49#$06#$80#$74#$72#$00#$40#$6C#$0F#$30#$F6#$01#$00#$00#$00#$00#$4A#$06#$80#$74#$72#$00#$40#$6C#$0F#$30#$F6#$01+
#$00#$00#$00#$00#$4B#$06#$80#$74#$72#$00#$40#$6C#$0F#$30#$F6#$01#$00#$00#$00#$00#$4C#$06#$80#$74#$72#$00#$40#$6C+
#$0F#$30#$F6#$01#$00#$00#$00#$00#$4D#$06#$80#$74#$72#$00#$40#$6C#$0F#$30#$F6#$01#$00#$00#$00#$00#$4E#$06#$80#$74+
#$72#$00#$40#$6C#$0F#$30#$F6#$01#$00#$00#$00#$00#$4F#$06#$80#$74#$72#$00#$40#$6C#$0F#$30#$F6#$01#$00#$00#$00#$00+
#$01#$05#$00#$00#$4D#$87#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$50#$06#$80#$74#$73#$00#$40#$6C#$10#$30#$F6+
#$01#$00#$00#$00#$00#$51#$06#$80#$74#$73#$00#$40#$6C#$10#$30#$F6#$01#$00#$00#$00#$00#$52#$06#$80#$74#$73#$00#$40+
#$6C#$10#$30#$F6#$01#$00#$00#$00#$00#$53#$06#$80#$74#$73#$00#$40#$6C#$10#$30#$F6#$01#$00#$00#$00#$00#$54#$06#$80+
#$74#$73#$00#$40#$6C#$10#$30#$F6#$01#$00#$00#$00#$00#$55#$06#$80#$74#$73#$00#$40#$6C#$10#$30#$F6#$01#$00#$00#$00+
#$00#$56#$06#$80#$74#$73#$00#$40#$6C#$10#$30#$F6#$01#$00#$00#$00#$00#$57#$06#$80#$74#$73#$00#$40#$6C#$10#$30#$F6+
#$01#$00#$00#$00#$00#$58#$06#$80#$74#$73#$00#$40#$6C#$10#$30#$F6#$01#$00#$00#$00#$00#$01#$06#$00#$00#$4D#$88#$AB+
#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$59#$06#$80#$74#$74#$00#$40#$6C#$11#$30#$F6#$01#$00#$00#$00#$00#$5A#$06+
#$80#$74#$74#$00#$40#$6C#$11#$30#$F6#$01#$00#$00#$00#$00#$5B#$06#$80#$74#$74#$00#$40#$6C#$11#$30#$F6#$01#$00#$00+
#$00#$00#$5C#$06#$80#$74#$74#$00#$40#$6C#$11#$30#$F6#$01#$00#$00#$00#$00#$5D#$06#$80#$74#$74#$00#$40#$6C#$11#$30+
#$F6#$01#$00#$00#$00#$00#$5E#$06#$80#$74#$74#$00#$40#$6C#$11#$30#$F6#$01#$00#$00#$00#$00#$01#$07#$00#$00#$4D#$89+
#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$5F#$06#$80#$74#$75#$00#$40#$6C#$12#$30#$F6#$01#$00#$00#$00#$00#$60+
#$06#$80#$74#$75#$00#$40#$6C#$12#$30#$F6#$01#$00#$00#$00#$00#$61#$06#$80#$74#$75#$00#$40#$6C#$12#$30#$F6#$01#$00+
#$00#$00#$00#$62#$06#$80#$74#$75#$00#$40#$6C#$12#$30#$F6#$01#$00#$00#$00#$00#$63#$06#$80#$74#$75#$00#$40#$6C#$12+
#$30#$F6#$01#$00#$00#$00#$00#$64#$06#$80#$74#$75#$00#$40#$6C#$12#$30#$F6#$01#$00#$00#$00#$00#$65#$06#$80#$74#$75+
#$00#$40#$6C#$12#$30#$F6#$01#$00#$00#$00#$00#$66#$06#$80#$74#$75#$00#$40#$6C#$12#$30#$F6#$01#$00#$00#$00#$00#$67+
#$06#$80#$74#$75#$00#$40#$6C#$12#$30#$F6#$01#$00#$00#$00#$00#$01#$08#$00#$00#$4D#$8A#$AB#$61#$01#$03#$00#$00#$00+
#$09#$00#$00#$00#$75#$04#$80#$74#$50#$00#$40#$6C#$13#$30#$F6#$01#$00#$00#$00#$00#$74#$04#$80#$74#$50#$00#$40#$6C+
#$13#$30#$F6#$01#$00#$00#$00#$00#$73#$04#$80#$74#$50#$00#$40#$6C#$13#$30#$F6#$01#$00#$00#$00#$00#$72#$04#$80#$74+
#$50#$00#$40#$6C#$13#$30#$F6#$01#$00#$00#$00#$00#$71#$04#$80#$74#$50#$00#$40#$6C#$13#$30#$F6#$01#$00#$00#$00#$00+
#$70#$04#$80#$74#$50#$00#$40#$6C#$13#$30#$F6#$01#$00#$00#$00#$00#$6F#$04#$80#$74#$50#$00#$40#$6C#$13#$30#$F6#$01+
#$00#$00#$00#$00#$6E#$04#$80#$74#$50#$00#$40#$6C#$13#$30#$F6#$01#$00#$00#$00#$00#$6D#$04#$80#$74#$50#$00#$40#$6C+
#$13#$30#$F6#$01#$00#$00#$00#$00#$01#$09#$00#$00#$4D#$8B#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$68#$06#$80+
#$74#$76#$00#$40#$6C#$14#$30#$F6#$01#$00#$00#$00#$00#$69#$06#$80#$74#$76#$00#$40#$6C#$14#$30#$F6#$01#$00#$00#$00+
#$00#$6A#$06#$80#$74#$76#$00#$40#$6C#$14#$30#$F6#$01#$00#$00#$00#$00#$6B#$06#$80#$74#$76#$00#$40#$6C#$14#$30#$F6+
#$01#$00#$00#$00#$00#$6C#$06#$80#$74#$76#$00#$40#$6C#$14#$30#$F6#$01#$00#$00#$00#$00#$6D#$06#$80#$74#$76#$00#$40+
#$6C#$14#$30#$F6#$01#$00#$00#$00#$00#$6E#$06#$80#$74#$76#$00#$40#$6C#$14#$30#$F6#$01#$00#$00#$00#$00#$6F#$06#$80+
#$74#$76#$00#$40#$6C#$14#$30#$F6#$01#$00#$00#$00#$00#$70#$06#$80#$74#$76#$00#$40#$6C#$14#$30#$F6#$01#$00#$00#$00+
#$00#$01#$0A#$00#$00#$4D#$8C#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$AB#$04#$80#$74#$36#$00#$40#$6C#$15#$30+
#$F6#$01#$00#$00#$00#$00#$AA#$04#$80#$74#$36#$00#$40#$6C#$15#$30#$F6#$01#$00#$00#$00#$00#$A9#$04#$80#$74#$36#$00+
#$40#$6C#$15#$30#$F6#$01#$00#$00#$00#$00#$A8#$04#$80#$74#$36#$00#$40#$6C#$15#$30#$F6#$01#$00#$00#$00#$00#$A7#$04+
#$80#$74#$36#$00#$40#$6C#$15#$30#$F6#$01#$00#$00#$00#$00#$A6#$04#$80#$74#$36#$00#$40#$6C#$15#$30#$F6#$01#$00#$00+
#$00#$00#$A5#$04#$80#$74#$36#$00#$40#$6C#$15#$30#$F6#$01#$00#$00#$00#$00#$A4#$04#$80#$74#$36#$00#$40#$6C#$15#$30+
#$F6#$01#$00#$00#$00#$00#$A3#$04#$80#$74#$36#$00#$40#$6C#$15#$30#$F6#$01#$00#$00#$00#$00#$01#$0B#$00#$00#$4D#$8D+
#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$B4#$04#$80#$74#$54#$00#$40#$6C#$16#$30#$F6#$01#$00#$00#$00#$00#$B3+
#$04#$80#$74#$54#$00#$40#$6C#$16#$30#$F6#$01#$00#$00#$00#$00#$B2#$04#$80#$74#$54#$00#$40#$6C#$16#$30#$F6#$01#$00+
#$00#$00#$00#$B1#$04#$80#$74#$54#$00#$40#$6C#$16#$30#$F6#$01#$00#$00#$00#$00#$B0#$04#$80#$74#$54#$00#$40#$6C#$16+
#$30#$F6#$01#$00#$00#$00#$00#$AF#$04#$80#$74#$54#$00#$40#$6C#$16#$30#$F6#$01#$00#$00#$00#$00#$AE#$04#$80#$74#$54+
#$00#$40#$6C#$16#$30#$F6#$01#$00#$00#$00#$00#$AD#$04#$80#$74#$54#$00#$40#$6C#$16#$30#$F6#$01#$00#$00#$00#$00#$AC+
#$04#$80#$74#$54#$00#$40#$6C#$16#$30#$F6#$01#$00#$00#$00#$00#$01#$0C#$00#$00#$4D#$8E#$AB#$61#$01#$03#$00#$00#$00+
#$09#$00#$00#$00#$BD#$04#$80#$74#$37#$00#$40#$6C#$17#$30#$F6#$01#$00#$00#$00#$00#$BC#$04#$80#$74#$37#$00#$40#$6C+
#$17#$30#$F6#$01#$00#$00#$00#$00#$BB#$04#$80#$74#$37#$00#$40#$6C#$17#$30#$F6#$01#$00#$00#$00#$00#$BA#$04#$80#$74+
#$37#$00#$40#$6C#$17#$30#$F6#$01#$00#$00#$00#$00#$B9#$04#$80#$74#$37#$00#$40#$6C#$17#$30#$F6#$01#$00#$00#$00#$00+
#$B8#$04#$80#$74#$37#$00#$40#$6C#$17#$30#$F6#$01#$00#$00#$00#$00#$B7#$04#$80#$74#$37#$00#$40#$6C#$17#$30#$F6#$01+
#$00#$00#$00#$00#$B6#$04#$80#$74#$37#$00#$40#$6C#$17#$30#$F6#$01#$00#$00#$00#$00#$B5#$04#$80#$74#$37#$00#$40#$6C+
#$17#$30#$F6#$01#$00#$00#$00#$00#$01#$0E#$00#$00#$4D#$8F#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$A2#$04#$80+
#$74#$53#$00#$40#$6C#$18#$30#$F6#$01#$00#$00#$00#$00#$A1#$04#$80#$74#$53#$00#$40#$6C#$18#$30#$F6#$01#$00#$00#$00+
#$00#$A0#$04#$80#$74#$53#$00#$40#$6C#$18#$30#$F6#$01#$00#$00#$00#$00#$9F#$04#$80#$74#$53#$00#$40#$6C#$18#$30#$F6+
#$01#$00#$00#$00#$00#$9E#$04#$80#$74#$53#$00#$40#$6C#$18#$30#$F6#$01#$00#$00#$00#$00#$9D#$04#$80#$74#$53#$00#$40+
#$6C#$18#$30#$F6#$01#$00#$00#$00#$00#$9C#$04#$80#$74#$53#$00#$40#$6C#$18#$30#$F6#$01#$00#$00#$00#$00#$9B#$04#$80+
#$74#$53#$00#$40#$6C#$18#$30#$F6#$01#$00#$00#$00#$00#$9A#$04#$80#$74#$53#$00#$40#$6C#$18#$30#$F6#$01#$00#$00#$00+
#$00#$01#$0F#$00#$00#$4D#$90#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$71#$06#$80#$74#$78#$00#$40#$6C#$19#$30+
#$F6#$01#$00#$00#$00#$00#$72#$06#$80#$74#$78#$00#$40#$6C#$19#$30#$F6#$01#$00#$00#$00#$00#$73#$06#$80#$74#$78#$00+
#$40#$6C#$19#$30#$F6#$01#$00#$00#$00#$00#$74#$06#$80#$74#$78#$00#$40#$6C#$19#$30#$F6#$01#$00#$00#$00#$00#$75#$06+
#$80#$74#$78#$00#$40#$6C#$19#$30#$F6#$01#$00#$00#$00#$00#$76#$06#$80#$74#$78#$00#$40#$6C#$19#$30#$F6#$01#$00#$00+
#$00#$00#$77#$06#$80#$74#$78#$00#$40#$6C#$19#$30#$F6#$01#$00#$00#$00#$00#$78#$06#$80#$74#$78#$00#$40#$6C#$19#$30+
#$F6#$01#$00#$00#$00#$00#$79#$06#$80#$74#$78#$00#$40#$6C#$19#$30#$F6#$01#$00#$00#$00#$00#$01#$10#$00#$00#$4D#$91+
#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$7A#$06#$80#$74#$79#$00#$40#$6C#$1A#$30#$F6#$01#$00#$00#$00#$00#$7B+
#$06#$80#$74#$79#$00#$40#$6C#$1A#$30#$F6#$01#$00#$00#$00#$00#$7C#$06#$80#$74#$79#$00#$40#$6C#$1A#$30#$F6#$01#$00+
#$00#$00#$00#$7D#$06#$80#$74#$79#$00#$40#$6C#$1A#$30#$F6#$01#$00#$00#$00#$00#$7E#$06#$80#$74#$79#$00#$40#$6C#$1A+
#$30#$F6#$01#$00#$00#$00#$00#$7F#$06#$80#$74#$79#$00#$40#$6C#$1A#$30#$F6#$01#$00#$00#$00#$00#$01#$11#$00#$00#$4D+
#$92#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$80#$06#$80#$74#$7A#$00#$40#$6C#$1B#$30#$F6#$01#$00#$00#$00#$00+
#$81#$06#$80#$74#$7A#$00#$40#$6C#$1B#$30#$F6#$01#$00#$00#$00#$00#$82#$06#$80#$74#$7A#$00#$40#$6C#$1B#$30#$F6#$01+
#$00#$00#$00#$00#$83#$06#$80#$74#$7A#$00#$40#$6C#$1B#$30#$F6#$01#$00#$00#$00#$00#$84#$06#$80#$74#$7A#$00#$40#$6C+
#$1B#$30#$F6#$01#$00#$00#$00#$00#$85#$06#$80#$74#$7A#$00#$40#$6C#$1B#$30#$F6#$01#$00#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$1D#$02#$00#$00#$00#$00#$3A#$00#$00#$00#$12#$00#$00#$00#$01#$12#$00#$00#$4D#$93#$AB#$61#$01#$03#$00#$00#$00#$06+
#$00#$00#$00#$86#$06#$80#$74#$7B#$00#$40#$6C#$1C#$30#$F6#$01#$00#$00#$00#$00#$87#$06#$80#$74#$7B#$00#$40#$6C#$1C+
#$30#$F6#$01#$00#$00#$00#$00#$88#$06#$80#$74#$7B#$00#$40#$6C#$1C#$30#$F6#$01#$00#$00#$00#$00#$89#$06#$80#$74#$7B+
#$00#$40#$6C#$1C#$30#$F6#$01#$00#$00#$00#$00#$8A#$06#$80#$74#$7B#$00#$40#$6C#$1C#$30#$F6#$01#$00#$00#$00#$00#$8B+
#$06#$80#$74#$7B#$00#$40#$6C#$1C#$30#$F6#$01#$00#$00#$00#$00#$01#$13#$00#$00#$4D#$94#$AB#$61#$01#$03#$00#$00#$00+
#$09#$00#$00#$00#$92#$06#$80#$74#$7C#$00#$40#$6C#$1D#$30#$F6#$01#$00#$00#$00#$00#$93#$06#$80#$74#$7C#$00#$40#$6C+
#$1D#$30#$F6#$01#$00#$00#$00#$00#$94#$06#$80#$74#$7C#$00#$40#$6C#$1D#$30#$F6#$01#$00#$00#$00#$00#$95#$06#$80#$74+
#$7C#$00#$40#$6C#$1D#$30#$F6#$01#$00#$00#$00#$00#$96#$06#$80#$74#$7C#$00#$40#$6C#$1D#$30#$F6#$01#$00#$00#$00#$00+
#$97#$06#$80#$74#$7C#$00#$40#$6C#$1D#$30#$F6#$01#$00#$00#$00#$00#$98#$06#$80#$74#$7C#$00#$40#$6C#$1D#$30#$F6#$01+
#$00#$00#$00#$00#$99#$06#$80#$74#$7C#$00#$40#$6C#$1D#$30#$F6#$01#$00#$00#$00#$00#$9A#$06#$80#$74#$7C#$00#$40#$6C+
#$1D#$30#$F6#$01#$00#$00#$00#$00#$01#$14#$00#$00#$4D#$95#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$9B#$06#$80+
#$74#$7D#$00#$40#$6C#$1E#$30#$F6#$01#$00#$00#$00#$00#$9C#$06#$80#$74#$7D#$00#$40#$6C#$1E#$30#$F6#$01#$00#$00#$00+
#$00#$9D#$06#$80#$74#$7D#$00#$40#$6C#$1E#$30#$F6#$01#$00#$00#$00#$00#$9E#$06#$80#$74#$7D#$00#$40#$6C#$1E#$30#$F6+
#$01#$00#$00#$00#$00#$9F#$06#$80#$74#$7D#$00#$40#$6C#$1E#$30#$F6#$01#$00#$00#$00#$00#$A0#$06#$80#$74#$7D#$00#$40+
#$6C#$1E#$30#$F6#$01#$00#$00#$00#$00#$01#$15#$00#$00#$4D#$96#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$A1#$06+
#$80#$74#$7E#$00#$40#$6C#$1F#$30#$F6#$01#$00#$00#$00#$00#$A2#$06#$80#$74#$7E#$00#$40#$6C#$1F#$30#$F6#$01#$00#$00+
#$00#$00#$A3#$06#$80#$74#$7E#$00#$40#$6C#$1F#$30#$F6#$01#$00#$00#$00#$00#$A4#$06#$80#$74#$7E#$00#$40#$6C#$1F#$30+
#$F6#$01#$00#$00#$00#$00#$A5#$06#$80#$74#$7E#$00#$40#$6C#$1F#$30#$F6#$01#$00#$00#$00#$00#$A6#$06#$80#$74#$7E#$00+
#$40#$6C#$1F#$30#$F6#$01#$00#$00#$00#$00#$01#$16#$00#$00#$4D#$97#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$A7+
#$06#$80#$74#$7F#$00#$40#$6C#$20#$30#$F6#$01#$00#$00#$00#$00#$A8#$06#$80#$74#$7F#$00#$40#$6C#$20#$30#$F6#$01#$00+
#$00#$00#$00#$A9#$06#$80#$74#$7F#$00#$40#$6C#$20#$30#$F6#$01#$00#$00#$00#$00#$AA#$06#$80#$74#$7F#$00#$40#$6C#$20+
#$30#$F6#$01#$00#$00#$00#$00#$AB#$06#$80#$74#$7F#$00#$40#$6C#$20#$30#$F6#$01#$00#$00#$00#$00#$AC#$06#$80#$74#$7F+
#$00#$40#$6C#$20#$30#$F6#$01#$00#$00#$00#$00#$01#$17#$00#$00#$4D#$98#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00+
#$AD#$06#$80#$74#$80#$00#$40#$6C#$21#$30#$F6#$01#$00#$00#$00#$00#$AE#$06#$80#$74#$80#$00#$40#$6C#$21#$30#$F6#$01+
#$00#$00#$00#$00#$AF#$06#$80#$74#$80#$00#$40#$6C#$21#$30#$F6#$01#$00#$00#$00#$00#$B0#$06#$80#$74#$80#$00#$40#$6C+
#$21#$30#$F6#$01#$00#$00#$00#$00#$B1#$06#$80#$74#$80#$00#$40#$6C#$21#$30#$F6#$01#$00#$00#$00#$00#$B2#$06#$80#$74+
#$80#$00#$40#$6C#$21#$30#$F6#$01#$00#$00#$00#$00#$01#$1A#$00#$00#$4D#$99#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00+
#$00#$63#$07#$80#$74#$8E#$00#$40#$6C#$22#$30#$F6#$01#$00#$00#$00#$00#$64#$07#$80#$74#$8E#$00#$40#$6C#$22#$30#$F6+
#$01#$00#$00#$00#$00#$65#$07#$80#$74#$8E#$00#$40#$6C#$22#$30#$F6#$01#$00#$00#$00#$00#$66#$07#$80#$74#$8E#$00#$40+
#$6C#$22#$30#$F6#$01#$00#$00#$00#$00#$67#$07#$80#$74#$8E#$00#$40#$6C#$22#$30#$F6#$01#$00#$00#$00#$00#$68#$07#$80+
#$74#$8E#$00#$40#$6C#$22#$30#$F6#$01#$00#$00#$00#$00#$69#$07#$80#$74#$8E#$00#$40#$6C#$22#$30#$F6#$01#$00#$00#$00+
#$00#$6A#$07#$80#$74#$8E#$00#$40#$6C#$22#$30#$F6#$01#$00#$00#$00#$00#$6B#$07#$80#$74#$8E#$00#$40#$6C#$22#$30#$F6+
#$01#$00#$00#$00#$00#$01#$1B#$00#$00#$4D#$9A#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$6C#$07#$80#$74#$8F#$00+
#$40#$6C#$23#$30#$F6#$01#$00#$00#$00#$00#$6D#$07#$80#$74#$8F#$00#$40#$6C#$23#$30#$F6#$01#$00#$00#$00#$00#$6E#$07+
#$80#$74#$8F#$00#$40#$6C#$23#$30#$F6#$01#$00#$00#$00#$00#$6F#$07#$80#$74#$8F#$00#$40#$6C#$23#$30#$F6#$01#$00#$00+
#$00#$00#$70#$07#$80#$74#$8F#$00#$40#$6C#$23#$30#$F6#$01#$00#$00#$00#$00#$71#$07#$80#$74#$8F#$00#$40#$6C#$23#$30+
#$F6#$01#$00#$00#$00#$00#$72#$07#$80#$74#$8F#$00#$40#$6C#$23#$30#$F6#$01#$00#$00#$00#$00#$73#$07#$80#$74#$8F#$00+
#$40#$6C#$23#$30#$F6#$01#$00#$00#$00#$00#$74#$07#$80#$74#$8F#$00#$40#$6C#$23#$30#$F6#$01#$00#$00#$00#$00#$01#$1C+
#$00#$00#$4D#$9B#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$75#$07#$80#$74#$97#$00#$40#$6C#$24#$30#$F6#$01#$00+
#$00#$00#$00#$76#$07#$80#$74#$97#$00#$40#$6C#$24#$30#$F6#$01#$00#$00#$00#$00#$77#$07#$80#$74#$97#$00#$40#$6C#$24+
#$30#$F6#$01#$00#$00#$00#$00#$78#$07#$80#$74#$97#$00#$40#$6C#$24#$30#$F6#$01#$00#$00#$00#$00#$79#$07#$80#$74#$97+
#$00#$40#$6C#$24#$30#$F6#$01#$00#$00#$00#$00#$7A#$07#$80#$74#$97#$00#$40#$6C#$24#$30#$F6#$01#$00#$00#$00#$00#$7B+
#$07#$80#$74#$97#$00#$40#$6C#$24#$30#$F6#$01#$00#$00#$00#$00#$7C#$07#$80#$74#$97#$00#$40#$6C#$24#$30#$F6#$01#$00+
#$00#$00#$00#$7D#$07#$80#$74#$97#$00#$40#$6C#$24#$30#$F6#$01#$00#$00#$00#$00#$01#$1D#$00#$00#$4D#$9C#$AB#$61#$01+
#$03#$00#$00#$00#$09#$00#$00#$00#$7E#$07#$80#$74#$90#$00#$40#$6C#$25#$30#$F6#$01#$00#$00#$00#$00#$7F#$07#$80#$74+
#$90#$00#$40#$6C#$25#$30#$F6#$01#$00#$00#$00#$00#$80#$07#$80#$74#$90#$00#$40#$6C#$25#$30#$F6#$01#$00#$00#$00#$00+
#$81#$07#$80#$74#$90#$00#$40#$6C#$25#$30#$F6#$01#$00#$00#$00#$00#$82#$07#$80#$74#$90#$00#$40#$6C#$25#$30#$F6#$01+
#$00#$00#$00#$00#$83#$07#$80#$74#$90#$00#$40#$6C#$25#$30#$F6#$01#$00#$00#$00#$00#$84#$07#$80#$74#$90#$00#$40#$6C+
#$25#$30#$F6#$01#$00#$00#$00#$00#$85#$07#$80#$74#$90#$00#$40#$6C#$25#$30#$F6#$01#$00#$00#$00#$00#$86#$07#$80#$74+
#$90#$00#$40#$6C#$25#$30#$F6#$01#$00#$00#$00#$00#$01#$1E#$00#$00#$4D#$9D#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00+
#$00#$87#$07#$80#$74#$91#$00#$40#$6C#$26#$30#$F6#$01#$00#$00#$00#$00#$88#$07#$80#$74#$91#$00#$40#$6C#$26#$30#$F6+
#$01#$00#$00#$00#$00#$89#$07#$80#$74#$91#$00#$40#$6C#$26#$30#$F6#$01#$00#$00#$00#$00#$8A#$07#$80#$74#$91#$00#$40+
#$6C#$26#$30#$F6#$01#$00#$00#$00#$00#$8B#$07#$80#$74#$91#$00#$40#$6C#$26#$30#$F6#$01#$00#$00#$00#$00#$8C#$07#$80+
#$74#$91#$00#$40#$6C#$26#$30#$F6#$01#$00#$00#$00#$00#$8D#$07#$80#$74#$91#$00#$40#$6C#$26#$30#$F6#$01#$00#$00#$00+
#$00#$8E#$07#$80#$74#$91#$00#$40#$6C#$26#$30#$F6#$01#$00#$00#$00#$00#$8F#$07#$80#$74#$91#$00#$40#$6C#$26#$30#$F6+
#$01#$00#$00#$00#$00#$01#$1F#$00#$00#$4D#$9E#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$90#$07#$80#$74#$92#$00+
#$40#$6C#$27#$30#$F6#$01#$00#$00#$00#$00#$91#$07#$80#$74#$92#$00#$40#$6C#$27#$30#$F6#$01#$00#$00#$00#$00#$92#$07+
#$80#$74#$92#$00#$40#$6C#$27#$30#$F6#$01#$00#$00#$00#$00#$93#$07#$80#$74#$92#$00#$40#$6C#$27#$30#$F6#$01#$00#$00+
#$00#$00#$94#$07#$80#$74#$92#$00#$40#$6C#$27#$30#$F6#$01#$00#$00#$00#$00#$95#$07#$80#$74#$92#$00#$40#$6C#$27#$30+
#$F6#$01#$00#$00#$00#$00#$96#$07#$80#$74#$92#$00#$40#$6C#$27#$30#$F6#$01#$00#$00#$00#$00#$97#$07#$80#$74#$92#$00+
#$40#$6C#$27#$30#$F6#$01#$00#$00#$00#$00#$98#$07#$80#$74#$92#$00#$40#$6C#$27#$30#$F6#$01#$00#$00#$00#$00#$01#$20+
#$00#$00#$4D#$9F#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$99#$07#$80#$74#$93#$00#$40#$6C#$28#$30#$F6#$01#$00+
#$00#$00#$00#$9A#$07#$80#$74#$93#$00#$40#$6C#$28#$30#$F6#$01#$00#$00#$00#$00#$9B#$07#$80#$74#$93#$00#$40#$6C#$28+
#$30#$F6#$01#$00#$00#$00#$00#$9C#$07#$80#$74#$93#$00#$40#$6C#$28#$30#$F6#$01#$00#$00#$00#$00#$9D#$07#$80#$74#$93+
#$00#$40#$6C#$28#$30#$F6#$01#$00#$00#$00#$00#$9E#$07#$80#$74#$93#$00#$40#$6C#$28#$30#$F6#$01#$00#$00#$00#$00#$9F+
#$07#$80#$74#$93#$00#$40#$6C#$28#$30#$F6#$01#$00#$00#$00#$00#$A0#$07#$80#$74#$93#$00#$40#$6C#$28#$30#$F6#$01#$00+
#$00#$00#$00#$A1#$07#$80#$74#$93#$00#$40#$6C#$28#$30#$F6#$01#$00#$00#$00#$00#$01#$21#$00#$00#$4D#$A0#$AB#$61#$01+
#$03#$00#$00#$00#$09#$00#$00#$00#$A2#$07#$80#$74#$94#$00#$40#$6C#$29#$30#$F6#$01#$00#$00#$00#$00#$A3#$07#$80#$74+
#$94#$00#$40#$6C#$29#$30#$F6#$01#$00#$00#$00#$00#$A4#$07#$80#$74#$94#$00#$40#$6C#$29#$30#$F6#$01#$00#$00#$00#$00+
#$A5#$07#$80#$74#$94#$00#$40#$6C#$29#$30#$F6#$01#$00#$00#$00#$00#$A6#$07#$80#$74#$94#$00#$40#$6C#$29#$30#$F6#$01+
#$00#$00#$00#$00#$A7#$07#$80#$74#$94#$00#$40#$6C#$29#$30#$F6#$01#$00#$00#$00#$00#$A8#$07#$80#$74#$94#$00#$40#$6C+
#$29#$30#$F6#$01#$00#$00#$00#$00#$A9#$07#$80#$74#$94#$00#$40#$6C#$29#$30#$F6#$01#$00#$00#$00#$00#$AA#$07#$80#$74+
#$94#$00#$40#$6C#$29#$30#$F6#$01#$00#$00#$00#$00#$01#$22#$00#$00#$4D#$A1#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00+
#$00#$AB#$07#$80#$74#$95#$00#$40#$6C#$2A#$30#$F6#$01#$00#$00#$00#$00#$AC#$07#$80#$74#$95#$00#$40#$6C#$2A#$30#$F6+
#$01#$00#$00#$00#$00#$AD#$07#$80#$74#$95#$00#$40#$6C#$2A#$30#$F6#$01#$00#$00#$00#$00#$AE#$07#$80#$74#$95#$00#$40+
#$6C#$2A#$30#$F6#$01#$00#$00#$00#$00#$AF#$07#$80#$74#$95#$00#$40#$6C#$2A#$30#$F6#$01#$00#$00#$00#$00#$B0#$07#$80+
#$74#$95#$00#$40#$6C#$2A#$30#$F6#$01#$00#$00#$00#$00#$B1#$07#$80#$74#$95#$00#$40#$6C#$2A#$30#$F6#$01#$00#$00#$00+
#$00#$B2#$07#$80#$74#$95#$00#$40#$6C#$2A#$30#$F6#$01#$00#$00#$00#$00#$B3#$07#$80#$74#$95#$00#$40#$6C#$2A#$30#$F6+
#$01#$00#$00#$00#$00#$01#$24#$00#$00#$4D#$A2#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$BD#$07#$80#$74#$96#$00+
#$40#$6C#$2B#$30#$F6#$01#$00#$00#$00#$00#$BE#$07#$80#$74#$96#$00#$40#$6C#$2B#$30#$F6#$01#$00#$00#$00#$00#$BF#$07+
#$80#$74#$96#$00#$40#$6C#$2B#$30#$F6#$01#$00#$00#$00#$00#$C0#$07#$80#$74#$96#$00#$40#$6C#$2B#$30#$F6#$01#$00#$00+
#$00#$00#$C1#$07#$80#$74#$96#$00#$40#$6C#$2B#$30#$F6#$01#$00#$00#$00#$00#$C2#$07#$80#$74#$96#$00#$40#$6C#$2B#$30+
#$F6#$01#$00#$00#$00#$00#$C3#$07#$80#$74#$96#$00#$40#$6C#$2B#$30#$F6#$01#$00#$00#$00#$00#$C4#$07#$80#$74#$96#$00+
#$40#$6C#$2B#$30#$F6#$01#$00#$00#$00#$00#$C5#$07#$80#$74#$96#$00#$40#$6C#$2B#$30#$F6#$01#$00#$00#$00#$00#$01#$25+
#$00#$00#$4D#$A3#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$C6#$07#$80#$74#$9E#$00#$40#$6C#$2C#$30#$F6#$01#$00+
#$00#$00#$00#$C7#$07#$80#$74#$9E#$00#$40#$6C#$2C#$30#$F6#$01#$00#$00#$00#$00#$C8#$07#$80#$74#$9E#$00#$40#$6C#$2C+
#$30#$F6#$01#$00#$00#$00#$00#$C9#$07#$80#$74#$9E#$00#$40#$6C#$2C#$30#$F6#$01#$00#$00#$00#$00#$CA#$07#$80#$74#$9E+
#$00#$40#$6C#$2C#$30#$F6#$01#$00#$00#$00#$00#$CB#$07#$80#$74#$9E#$00#$40#$6C#$2C#$30#$F6#$01#$00#$00#$00#$00#$CC+
#$07#$80#$74#$9E#$00#$40#$6C#$2C#$30#$F6#$01#$00#$00#$00#$00#$CD#$07#$80#$74#$9E#$00#$40#$6C#$2C#$30#$F6#$01#$00+
#$00#$00#$00#$CE#$07#$80#$74#$9E#$00#$40#$6C#$2C#$30#$F6#$01#$00#$00#$00#$00#$01#$26#$00#$00#$4D#$A4#$AB#$61#$01+
#$03#$00#$00#$00#$06#$00#$00#$00#$1D#$08#$80#$74#$A8#$00#$40#$6C#$2D#$30#$F6#$01#$00#$00#$00#$00#$1E#$08#$80#$74+
#$A8#$00#$40#$6C#$2D#$30#$F6#$01#$00#$00#$00#$00#$1F#$08#$80#$74#$A8#$00#$40#$6C#$2D#$30#$F6#$01#$00#$00#$00#$00+
#$20#$08#$80#$74#$A8#$00#$40#$6C#$2D#$30#$F6#$01#$00#$00#$00#$00#$21#$08#$80#$74#$A8#$00#$40#$6C#$2D#$30#$F6#$01+
#$00#$00#$00#$00#$22#$08#$80#$74#$A8#$00#$40#$6C#$2D#$30#$F6#$01#$00#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$1D#$02#$00#$00#$00#$00#$28#$00#$00#$00#$12#$00#$00#$00#$01#$01#$00#$40#$4D#$A5#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$B3#$05#$80#$74#$5E#$00#$40#$6C#$2E#$30#$F6#$01#$00#$00#$00#$00#$B4#$05#$80#$74#$5E#$00#$40#$6C#$2E+
#$30#$F6#$01#$00#$00#$00#$00#$B5#$05#$80#$74#$5E#$00#$40#$6C#$2E#$30#$F6#$01#$00#$00#$00#$00#$B6#$05#$80#$74#$5E+
#$00#$40#$6C#$2E#$30#$F6#$01#$00#$00#$00#$00#$B7#$05#$80#$74#$5E#$00#$40#$6C#$2E#$30#$F6#$01#$00#$00#$00#$00#$B8+
#$05#$80#$74#$5E#$00#$40#$6C#$2E#$30#$F6#$01#$00#$00#$00#$00#$B9#$05#$80#$74#$5E#$00#$40#$6C#$2E#$30#$F6#$01#$00+
#$00#$00#$00#$BA#$05#$80#$74#$5E#$00#$40#$6C#$2E#$30#$F6#$01#$00#$00#$00#$00#$BB#$05#$80#$74#$5E#$00#$40#$6C#$2E+
#$30#$F6#$01#$00#$00#$00#$00#$01#$02#$00#$40#$4D#$A6#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$BC#$05#$80#$74+
#$5D#$00#$40#$6C#$2F#$30#$F6#$01#$00#$00#$00#$00#$BD#$05#$80#$74#$5D#$00#$40#$6C#$2F#$30#$F6#$01#$00#$00#$00#$00+
#$BE#$05#$80#$74#$5D#$00#$40#$6C#$2F#$30#$F6#$01#$00#$00#$00#$00#$BF#$05#$80#$74#$5D#$00#$40#$6C#$2F#$30#$F6#$01+
#$00#$00#$00#$00#$C0#$05#$80#$74#$5D#$00#$40#$6C#$2F#$30#$F6#$01#$00#$00#$00#$00#$C1#$05#$80#$74#$5D#$00#$40#$6C+
#$2F#$30#$F6#$01#$00#$00#$00#$00#$C2#$05#$80#$74#$5D#$00#$40#$6C#$2F#$30#$F6#$01#$00#$00#$00#$00#$C3#$05#$80#$74+
#$5D#$00#$40#$6C#$2F#$30#$F6#$01#$00#$00#$00#$00#$C4#$05#$80#$74#$5D#$00#$40#$6C#$2F#$30#$F6#$01#$00#$00#$00#$00+
#$01#$03#$00#$40#$4D#$A7#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$C5#$05#$80#$74#$61#$00#$40#$6C#$30#$30#$F6+
#$01#$00#$00#$00#$00#$C6#$05#$80#$74#$61#$00#$40#$6C#$30#$30#$F6#$01#$00#$00#$00#$00#$C7#$05#$80#$74#$61#$00#$40+
#$6C#$30#$30#$F6#$01#$00#$00#$00#$00#$C8#$05#$80#$74#$61#$00#$40#$6C#$30#$30#$F6#$01#$00#$00#$00#$00#$C9#$05#$80+
#$74#$61#$00#$40#$6C#$30#$30#$F6#$01#$00#$00#$00#$00#$CA#$05#$80#$74#$61#$00#$40#$6C#$30#$30#$F6#$01#$00#$00#$00+
#$00#$CB#$05#$80#$74#$61#$00#$40#$6C#$30#$30#$F6#$01#$00#$00#$00#$00#$CC#$05#$80#$74#$61#$00#$40#$6C#$30#$30#$F6+
#$01#$00#$00#$00#$00#$CD#$05#$80#$74#$61#$00#$40#$6C#$30#$30#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$40#$4D#$A8#$AB+
#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$CE#$05#$80#$74#$62#$00#$40#$6C#$31#$30#$F6#$01#$00#$00#$00#$00#$CF#$05+
#$80#$74#$62#$00#$40#$6C#$31#$30#$F6#$01#$00#$00#$00#$00#$D0#$05#$80#$74#$62#$00#$40#$6C#$31#$30#$F6#$01#$00#$00+
#$00#$00#$D1#$05#$80#$74#$62#$00#$40#$6C#$31#$30#$F6#$01#$00#$00#$00#$00#$D2#$05#$80#$74#$62#$00#$40#$6C#$31#$30+
#$F6#$01#$00#$00#$00#$00#$D3#$05#$80#$74#$62#$00#$40#$6C#$31#$30#$F6#$01#$00#$00#$00#$00#$D4#$05#$80#$74#$62#$00+
#$40#$6C#$31#$30#$F6#$01#$00#$00#$00#$00#$D5#$05#$80#$74#$62#$00#$40#$6C#$31#$30#$F6#$01#$00#$00#$00#$00#$D6#$05+
#$80#$74#$62#$00#$40#$6C#$31#$30#$F6#$01#$00#$00#$00#$00#$01#$05#$00#$40#$4D#$A9#$AB#$61#$01#$03#$00#$00#$00#$09+
#$00#$00#$00#$D7#$05#$80#$74#$63#$00#$40#$6C#$32#$30#$F6#$01#$00#$00#$00#$00#$D8#$05#$80#$74#$63#$00#$40#$6C#$32+
#$30#$F6#$01#$00#$00#$00#$00#$D9#$05#$80#$74#$63#$00#$40#$6C#$32#$30#$F6#$01#$00#$00#$00#$00#$DA#$05#$80#$74#$63+
#$00#$40#$6C#$32#$30#$F6#$01#$00#$00#$00#$00#$DB#$05#$80#$74#$63#$00#$40#$6C#$32#$30#$F6#$01#$00#$00#$00#$00#$DC+
#$05#$80#$74#$63#$00#$40#$6C#$32#$30#$F6#$01#$00#$00#$00#$00#$DD#$05#$80#$74#$63#$00#$40#$6C#$32#$30#$F6#$01#$00+
#$00#$00#$00#$DE#$05#$80#$74#$63#$00#$40#$6C#$32#$30#$F6#$01#$00#$00#$00#$00#$DF#$05#$80#$74#$63#$00#$40#$6C#$32+
#$30#$F6#$01#$00#$00#$00#$00#$01#$06#$00#$40#$4D#$AA#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$E0#$05#$80#$74+
#$5F#$00#$40#$6C#$33#$30#$F6#$01#$00#$00#$00#$00#$E1#$05#$80#$74#$5F#$00#$40#$6C#$33#$30#$F6#$01#$00#$00#$00#$00+
#$E2#$05#$80#$74#$5F#$00#$40#$6C#$33#$30#$F6#$01#$00#$00#$00#$00#$E3#$05#$80#$74#$5F#$00#$40#$6C#$33#$30#$F6#$01+
#$00#$00#$00#$00#$E4#$05#$80#$74#$5F#$00#$40#$6C#$33#$30#$F6#$01#$00#$00#$00#$00#$E5#$05#$80#$74#$5F#$00#$40#$6C+
#$33#$30#$F6#$01#$00#$00#$00#$00#$01#$07#$00#$40#$4D#$AB#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$E6#$05#$80+
#$74#$60#$00#$40#$6C#$34#$30#$F6#$01#$00#$00#$00#$00#$E7#$05#$80#$74#$60#$00#$40#$6C#$34#$30#$F6#$01#$00#$00#$00+
#$00#$E8#$05#$80#$74#$60#$00#$40#$6C#$34#$30#$F6#$01#$00#$00#$00#$00#$E9#$05#$80#$74#$60#$00#$40#$6C#$34#$30#$F6+
#$01#$00#$00#$00#$00#$EA#$05#$80#$74#$60#$00#$40#$6C#$34#$30#$F6#$01#$00#$00#$00#$00#$EB#$05#$80#$74#$60#$00#$40+
#$6C#$34#$30#$F6#$01#$00#$00#$00#$00#$01#$08#$00#$40#$4D#$AC#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$EC#$05+
#$80#$74#$65#$00#$40#$6C#$35#$30#$F6#$01#$00#$00#$00#$00#$ED#$05#$80#$74#$65#$00#$40#$6C#$35#$30#$F6#$01#$00#$00+
#$00#$00#$EE#$05#$80#$74#$65#$00#$40#$6C#$35#$30#$F6#$01#$00#$00#$00#$00#$EF#$05#$80#$74#$65#$00#$40#$6C#$35#$30+
#$F6#$01#$00#$00#$00#$00#$F0#$05#$80#$74#$65#$00#$40#$6C#$35#$30#$F6#$01#$00#$00#$00#$00#$F1#$05#$80#$74#$65#$00+
#$40#$6C#$35#$30#$F6#$01#$00#$00#$00#$00#$F2#$05#$80#$74#$65#$00#$40#$6C#$35#$30#$F6#$01#$00#$00#$00#$00#$F3#$05+
#$80#$74#$65#$00#$40#$6C#$35#$30#$F6#$01#$00#$00#$00#$00#$F4#$05#$80#$74#$65#$00#$40#$6C#$35#$30#$F6#$01#$00#$00+
#$00#$00#$01#$09#$00#$40#$4D#$AD#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$F5#$05#$80#$74#$64#$00#$40#$6C#$36+
#$30#$F6#$01#$00#$00#$00#$00#$F6#$05#$80#$74#$64#$00#$40#$6C#$36#$30#$F6#$01#$00#$00#$00#$00#$F7#$05#$80#$74#$64+
#$00#$40#$6C#$36#$30#$F6#$01#$00#$00#$00#$00#$F8#$05#$80#$74#$64#$00#$40#$6C#$36#$30#$F6#$01#$00#$00#$00#$00#$F9+
#$05#$80#$74#$64#$00#$40#$6C#$36#$30#$F6#$01#$00#$00#$00#$00#$FA#$05#$80#$74#$64#$00#$40#$6C#$36#$30#$F6#$01#$00+
#$00#$00#$00#$FB#$05#$80#$74#$64#$00#$40#$6C#$36#$30#$F6#$01#$00#$00#$00#$00#$FC#$05#$80#$74#$64#$00#$40#$6C#$36+
#$30#$F6#$01#$00#$00#$00#$00#$FD#$05#$80#$74#$64#$00#$40#$6C#$36#$30#$F6#$01#$00#$00#$00#$00#$01#$0A#$00#$40#$4D+
#$AE#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$FE#$05#$80#$74#$66#$00#$40#$6C#$37#$30#$F6#$01#$00#$00#$00#$00+
#$FF#$05#$80#$74#$66#$00#$40#$6C#$37#$30#$F6#$01#$00#$00#$00#$00#$00#$06#$80#$74#$66#$00#$40#$6C#$37#$30#$F6#$01+
#$00#$00#$00#$00#$01#$06#$80#$74#$66#$00#$40#$6C#$37#$30#$F6#$01#$00#$00#$00#$00#$02#$06#$80#$74#$66#$00#$40#$6C+
#$37#$30#$F6#$01#$00#$00#$00#$00#$03#$06#$80#$74#$66#$00#$40#$6C#$37#$30#$F6#$01#$00#$00#$00#$00#$01#$0B#$00#$40+
#$4D#$AF#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$04#$06#$80#$74#$67#$00#$40#$6C#$38#$30#$F6#$01#$00#$00#$00+
#$00#$05#$06#$80#$74#$67#$00#$40#$6C#$38#$30#$F6#$01#$00#$00#$00#$00#$06#$06#$80#$74#$67#$00#$40#$6C#$38#$30#$F6+
#$01#$00#$00#$00#$00#$07#$06#$80#$74#$67#$00#$40#$6C#$38#$30#$F6#$01#$00#$00#$00#$00#$08#$06#$80#$74#$67#$00#$40+
#$6C#$38#$30#$F6#$01#$00#$00#$00#$00#$09#$06#$80#$74#$67#$00#$40#$6C#$38#$30#$F6#$01#$00#$00#$00#$00#$01#$0C#$00+
#$40#$4D#$B0#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$0A#$06#$80#$74#$68#$00#$40#$6C#$39#$30#$F6#$01#$00#$00+
#$00#$00#$0B#$06#$80#$74#$68#$00#$40#$6C#$39#$30#$F6#$01#$00#$00#$00#$00#$0C#$06#$80#$74#$68#$00#$40#$6C#$39#$30+
#$F6#$01#$00#$00#$00#$00#$0D#$06#$80#$74#$68#$00#$40#$6C#$39#$30#$F6#$01#$00#$00#$00#$00#$0E#$06#$80#$74#$68#$00+
#$40#$6C#$39#$30#$F6#$01#$00#$00#$00#$00#$0F#$06#$80#$74#$68#$00#$40#$6C#$39#$30#$F6#$01#$00#$00#$00#$00#$01#$0D+
#$00#$40#$4D#$B1#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$13#$07#$80#$74#$6E#$00#$40#$6C#$3A#$30#$F6#$01#$00+
#$00#$00#$00#$14#$07#$80#$74#$6E#$00#$40#$6C#$3A#$30#$F6#$01#$00#$00#$00#$00#$15#$07#$80#$74#$6E#$00#$40#$6C#$3A+
#$30#$F6#$01#$00#$00#$00#$00#$16#$07#$80#$74#$6E#$00#$40#$6C#$3A#$30#$F6#$01#$00#$00#$00#$00#$17#$07#$80#$74#$6E+
#$00#$40#$6C#$3A#$30#$F6#$01#$00#$00#$00#$00#$18#$07#$80#$74#$6E#$00#$40#$6C#$3A#$30#$F6#$01#$00#$00#$00#$00#$01+
#$0E#$00#$40#$4D#$B2#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$19#$07#$80#$74#$6F#$00#$40#$6C#$3B#$30#$F6#$01+
#$00#$00#$00#$00#$1A#$07#$80#$74#$6F#$00#$40#$6C#$3B#$30#$F6#$01#$00#$00#$00#$00#$1B#$07#$80#$74#$6F#$00#$40#$6C+
#$3B#$30#$F6#$01#$00#$00#$00#$00#$1C#$07#$80#$74#$6F#$00#$40#$6C#$3B#$30#$F6#$01#$00#$00#$00#$00#$1D#$07#$80#$74+
#$6F#$00#$40#$6C#$3B#$30#$F6#$01#$00#$00#$00#$00#$1E#$07#$80#$74#$6F#$00#$40#$6C#$3B#$30#$F6#$01#$00#$00#$00#$00+
#$01#$0F#$00#$40#$4D#$B3#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$10#$06#$80#$74#$59#$00#$40#$6C#$3C#$30#$F6+
#$01#$00#$00#$00#$00#$11#$06#$80#$74#$59#$00#$40#$6C#$3C#$30#$F6#$01#$00#$00#$00#$00#$12#$06#$80#$74#$59#$00#$40+
#$6C#$3C#$30#$F6#$01#$00#$00#$00#$00#$13#$06#$80#$74#$59#$00#$40#$6C#$3C#$30#$F6#$01#$00#$00#$00#$00#$14#$06#$80+
#$74#$59#$00#$40#$6C#$3C#$30#$F6#$01#$00#$00#$00#$00#$15#$06#$80#$74#$59#$00#$40#$6C#$3C#$30#$F6#$01#$00#$00#$00+
#$00#$01#$10#$00#$40#$4D#$B4#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$16#$06#$80#$74#$5B#$00#$40#$6C#$3D#$30+
#$F6#$01#$00#$00#$00#$00#$17#$06#$80#$74#$5B#$00#$40#$6C#$3D#$30#$F6#$01#$00#$00#$00#$00#$18#$06#$80#$74#$5B#$00+
#$40#$6C#$3D#$30#$F6#$01#$00#$00#$00#$00#$19#$06#$80#$74#$5B#$00#$40#$6C#$3D#$30#$F6#$01#$00#$00#$00#$00#$1A#$06+
#$80#$74#$5B#$00#$40#$6C#$3D#$30#$F6#$01#$00#$00#$00#$00#$1B#$06#$80#$74#$5B#$00#$40#$6C#$3D#$30#$F6#$01#$00#$00+
#$00#$00#$01#$11#$00#$40#$4D#$B5#$AB#$61#$01#$03#$00#$00#$00#$03#$00#$00#$00#$D8#$07#$80#$74#$9B#$00#$40#$6C#$3E+
#$30#$F6#$01#$00#$00#$00#$00#$D9#$07#$80#$74#$9B#$00#$40#$6C#$3E#$30#$F6#$01#$00#$00#$00#$00#$DA#$07#$80#$74#$9B+
#$00#$40#$6C#$3E#$30#$F6#$01#$00#$00#$00#$00#$01#$12#$00#$40#$4D#$B6#$AB#$61#$01#$03#$00#$00#$00#$03#$00#$00#$00+
#$DB#$07#$80#$74#$9C#$00#$40#$6C#$3F#$30#$F6#$01#$00#$00#$00#$00#$DC#$07#$80#$74#$9C#$00#$40#$6C#$3F#$30#$F6#$01+
#$00#$00#$00#$00#$DD#$07#$80#$74#$9C#$00#$40#$6C#$3F#$30#$F6#$01#$00#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$1D#$02#$00#$00#$00#$00#$16#$00#$00#$00#$12#$00#$00#$00#$01#$13#$00#$40#$4D#$B7#$AB#$61#$01#$03#$00#$00#$00#$03+
#$00#$00#$00#$DE#$07#$80#$74#$9D#$00#$40#$6C#$40#$30#$F6#$01#$00#$00#$00#$00#$DF#$07#$80#$74#$9D#$00#$40#$6C#$40+
#$30#$F6#$01#$00#$00#$00#$00#$E0#$07#$80#$74#$9D#$00#$40#$6C#$40#$30#$F6#$01#$00#$00#$00#$00#$01#$01#$00#$80#$4D+
#$B8#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$08#$04#$80#$74#$4A#$00#$40#$6C#$41#$30#$F6#$01#$00#$00#$00#$00+
#$07#$04#$80#$74#$4A#$00#$40#$6C#$41#$30#$F6#$01#$00#$00#$00#$00#$06#$04#$80#$74#$4A#$00#$40#$6C#$41#$30#$F6#$01+
#$00#$00#$00#$00#$05#$04#$80#$74#$4A#$00#$40#$6C#$41#$30#$F6#$01#$00#$00#$00#$00#$04#$04#$80#$74#$4A#$00#$40#$6C+
#$41#$30#$F6#$01#$00#$00#$00#$00#$03#$04#$80#$74#$4A#$00#$40#$6C#$41#$30#$F6#$01#$00#$00#$00#$00#$02#$04#$80#$74+
#$4A#$00#$40#$6C#$41#$30#$F6#$01#$00#$00#$00#$00#$01#$04#$80#$74#$4A#$00#$40#$6C#$41#$30#$F6#$01#$00#$00#$00#$00+
#$00#$04#$80#$74#$4A#$00#$40#$6C#$41#$30#$F6#$01#$00#$00#$00#$00#$01#$02#$00#$80#$4D#$B9#$AB#$61#$01#$03#$00#$00+
#$00#$06#$00#$00#$00#$B3#$06#$80#$74#$81#$00#$40#$6C#$42#$30#$F6#$01#$00#$00#$00#$00#$B4#$06#$80#$74#$81#$00#$40+
#$6C#$42#$30#$F6#$01#$00#$00#$00#$00#$B5#$06#$80#$74#$81#$00#$40#$6C#$42#$30#$F6#$01#$00#$00#$00#$00#$B6#$06#$80+
#$74#$81#$00#$40#$6C#$42#$30#$F6#$01#$00#$00#$00#$00#$B7#$06#$80#$74#$81#$00#$40#$6C#$42#$30#$F6#$01#$00#$00#$00+
#$00#$B8#$06#$80#$74#$81#$00#$40#$6C#$42#$30#$F6#$01#$00#$00#$00#$00#$01#$03#$00#$80#$4D#$BA#$AB#$61#$01#$03#$00+
#$00#$00#$09#$00#$00#$00#$B9#$06#$80#$74#$82#$00#$40#$6C#$43#$30#$F6#$01#$00#$00#$00#$00#$BA#$06#$80#$74#$82#$00+
#$40#$6C#$43#$30#$F6#$01#$00#$00#$00#$00#$BB#$06#$80#$74#$82#$00#$40#$6C#$43#$30#$F6#$01#$00#$00#$00#$00#$BC#$06+
#$80#$74#$82#$00#$40#$6C#$43#$30#$F6#$01#$00#$00#$00#$00#$BD#$06#$80#$74#$82#$00#$40#$6C#$43#$30#$F6#$01#$00#$00+
#$00#$00#$BE#$06#$80#$74#$82#$00#$40#$6C#$43#$30#$F6#$01#$00#$00#$00#$00#$BF#$06#$80#$74#$82#$00#$40#$6C#$43#$30+
#$F6#$01#$00#$00#$00#$00#$C0#$06#$80#$74#$82#$00#$40#$6C#$43#$30#$F6#$01#$00#$00#$00#$00#$C1#$06#$80#$74#$82#$00+
#$40#$6C#$43#$30#$F6#$01#$00#$00#$00#$00#$01#$04#$00#$80#$4D#$BB#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$C2+
#$06#$80#$74#$83#$00#$40#$6C#$B4#$69#$F7#$01#$04#$C0#$94#$52#$C3#$06#$80#$74#$83#$00#$40#$6C#$44#$30#$F6#$01#$00+
#$00#$00#$00#$C4#$06#$80#$74#$83#$00#$40#$6C#$44#$30#$F6#$01#$00#$00#$00#$00#$C5#$06#$80#$74#$83#$00#$40#$6C#$44+
#$30#$F6#$01#$00#$00#$00#$00#$C6#$06#$80#$74#$83#$00#$40#$6C#$44#$30#$F6#$01#$00#$00#$00#$00#$C7#$06#$80#$74#$83+
#$00#$40#$6C#$44#$30#$F6#$01#$00#$00#$00#$00#$C8#$06#$80#$74#$83#$00#$40#$6C#$44#$30#$F6#$01#$00#$00#$00#$00#$C9+
#$06#$80#$74#$83#$00#$40#$6C#$44#$30#$F6#$01#$00#$00#$00#$00#$CA#$06#$80#$74#$83#$00#$40#$6C#$44#$30#$F6#$01#$00+
#$00#$00#$00#$01#$05#$00#$80#$4D#$BC#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$CB#$06#$80#$74#$84#$00#$40#$6C+
#$45#$30#$F6#$01#$00#$00#$00#$00#$CC#$06#$80#$74#$84#$00#$40#$6C#$45#$30#$F6#$01#$00#$00#$00#$00#$CD#$06#$80#$74+
#$84#$00#$40#$6C#$45#$30#$F6#$01#$00#$00#$00#$00#$CE#$06#$80#$74#$84#$00#$40#$6C#$45#$30#$F6#$01#$00#$00#$00#$00+
#$CF#$06#$80#$74#$84#$00#$40#$6C#$45#$30#$F6#$01#$00#$00#$00#$00#$D0#$06#$80#$74#$84#$00#$40#$6C#$45#$30#$F6#$01+
#$00#$00#$00#$00#$D1#$06#$80#$74#$84#$00#$40#$6C#$45#$30#$F6#$01#$00#$00#$00#$00#$D2#$06#$80#$74#$84#$00#$40#$6C+
#$45#$30#$F6#$01#$00#$00#$00#$00#$D3#$06#$80#$74#$84#$00#$40#$6C#$45#$30#$F6#$01#$00#$00#$00#$00#$01#$06#$00#$80+
#$4D#$BD#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$D4#$06#$80#$74#$85#$00#$40#$6C#$46#$30#$F6#$01#$00#$00#$00+
#$00#$D5#$06#$80#$74#$85#$00#$40#$6C#$46#$30#$F6#$01#$00#$00#$00#$00#$D6#$06#$80#$74#$85#$00#$40#$6C#$46#$30#$F6+
#$01#$00#$00#$00#$00#$D7#$06#$80#$74#$85#$00#$40#$6C#$46#$30#$F6#$01#$00#$00#$00#$00#$D8#$06#$80#$74#$85#$00#$40+
#$6C#$46#$30#$F6#$01#$00#$00#$00#$00#$D9#$06#$80#$74#$85#$00#$40#$6C#$46#$30#$F6#$01#$00#$00#$00#$00#$DA#$06#$80+
#$74#$85#$00#$40#$6C#$46#$30#$F6#$01#$00#$00#$00#$00#$DB#$06#$80#$74#$85#$00#$40#$6C#$46#$30#$F6#$01#$00#$00#$00+
#$00#$DC#$06#$80#$74#$85#$00#$40#$6C#$46#$30#$F6#$01#$00#$00#$00#$00#$01#$07#$00#$80#$4D#$BE#$AB#$61#$01#$03#$00+
#$00#$00#$09#$00#$00#$00#$DD#$06#$80#$74#$86#$00#$40#$6C#$47#$30#$F6#$01#$00#$00#$00#$00#$DE#$06#$80#$74#$86#$00+
#$40#$6C#$47#$30#$F6#$01#$00#$00#$00#$00#$DF#$06#$80#$74#$86#$00#$40#$6C#$47#$30#$F6#$01#$00#$00#$00#$00#$E0#$06+
#$80#$74#$86#$00#$40#$6C#$47#$30#$F6#$01#$00#$00#$00#$00#$E1#$06#$80#$74#$86#$00#$40#$6C#$47#$30#$F6#$01#$00#$00+
#$00#$00#$E2#$06#$80#$74#$86#$00#$40#$6C#$47#$30#$F6#$01#$00#$00#$00#$00#$E3#$06#$80#$74#$86#$00#$40#$6C#$47#$30+
#$F6#$01#$00#$00#$00#$00#$E4#$06#$80#$74#$86#$00#$40#$6C#$47#$30#$F6#$01#$00#$00#$00#$00#$E5#$06#$80#$74#$86#$00+
#$40#$6C#$47#$30#$F6#$01#$00#$00#$00#$00#$01#$08#$00#$80#$4D#$BF#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$E6+
#$06#$80#$74#$87#$00#$40#$6C#$48#$30#$F6#$01#$00#$00#$00#$00#$E7#$06#$80#$74#$87#$00#$40#$6C#$48#$30#$F6#$01#$00+
#$00#$00#$00#$E8#$06#$80#$74#$87#$00#$40#$6C#$48#$30#$F6#$01#$00#$00#$00#$00#$E9#$06#$80#$74#$87#$00#$40#$6C#$48+
#$30#$F6#$01#$00#$00#$00#$00#$EA#$06#$80#$74#$87#$00#$40#$6C#$48#$30#$F6#$01#$00#$00#$00#$00#$EB#$06#$80#$74#$87+
#$00#$40#$6C#$48#$30#$F6#$01#$00#$00#$00#$00#$01#$09#$00#$80#$4D#$C0#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00+
#$EC#$06#$80#$74#$88#$00#$40#$6C#$49#$30#$F6#$01#$00#$00#$00#$00#$ED#$06#$80#$74#$88#$00#$40#$6C#$49#$30#$F6#$01+
#$00#$00#$00#$00#$EE#$06#$80#$74#$88#$00#$40#$6C#$49#$30#$F6#$01#$00#$00#$00#$00#$EF#$06#$80#$74#$88#$00#$40#$6C+
#$49#$30#$F6#$01#$00#$00#$00#$00#$F0#$06#$80#$74#$88#$00#$40#$6C#$49#$30#$F6#$01#$00#$00#$00#$00#$F1#$06#$80#$74+
#$88#$00#$40#$6C#$49#$30#$F6#$01#$00#$00#$00#$00#$01#$0A#$00#$80#$4D#$C1#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00+
#$00#$F2#$06#$80#$74#$89#$00#$40#$6C#$4A#$30#$F6#$01#$00#$00#$00#$00#$F3#$06#$80#$74#$89#$00#$40#$6C#$4A#$30#$F6+
#$01#$00#$00#$00#$00#$F4#$06#$80#$74#$89#$00#$40#$6C#$4A#$30#$F6#$01#$00#$00#$00#$00#$F5#$06#$80#$74#$89#$00#$40+
#$6C#$4A#$30#$F6#$01#$00#$00#$00#$00#$F6#$06#$80#$74#$89#$00#$40#$6C#$4A#$30#$F6#$01#$00#$00#$00#$00#$F7#$06#$80+
#$74#$89#$00#$40#$6C#$4A#$30#$F6#$01#$00#$00#$00#$00#$F8#$06#$80#$74#$89#$00#$40#$6C#$4A#$30#$F6#$01#$00#$00#$00+
#$00#$F9#$06#$80#$74#$89#$00#$40#$6C#$4A#$30#$F6#$01#$00#$00#$00#$00#$FA#$06#$80#$74#$89#$00#$40#$6C#$4A#$30#$F6+
#$01#$00#$00#$00#$00#$01#$0B#$00#$80#$4D#$C2#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$FB#$06#$80#$74#$8A#$00+
#$40#$6C#$4B#$30#$F6#$01#$00#$00#$00#$00#$FC#$06#$80#$74#$8A#$00#$40#$6C#$4B#$30#$F6#$01#$00#$00#$00#$00#$FD#$06+
#$80#$74#$8A#$00#$40#$6C#$4B#$30#$F6#$01#$00#$00#$00#$00#$FE#$06#$80#$74#$8A#$00#$40#$6C#$4B#$30#$F6#$01#$00#$00+
#$00#$00#$FF#$06#$80#$74#$8A#$00#$40#$6C#$4B#$30#$F6#$01#$00#$00#$00#$00#$00#$07#$80#$74#$8A#$00#$40#$6C#$4B#$30+
#$F6#$01#$00#$00#$00#$00#$01#$0C#$00#$80#$4D#$C3#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$01#$07#$80#$74#$8B+
#$00#$40#$6C#$4C#$30#$F6#$01#$00#$00#$00#$00#$02#$07#$80#$74#$8B#$00#$40#$6C#$4C#$30#$F6#$01#$00#$00#$00#$00#$03+
#$07#$80#$74#$8B#$00#$40#$6C#$4C#$30#$F6#$01#$00#$00#$00#$00#$04#$07#$80#$74#$8B#$00#$40#$6C#$4C#$30#$F6#$01#$00+
#$00#$00#$00#$05#$07#$80#$74#$8B#$00#$40#$6C#$4C#$30#$F6#$01#$00#$00#$00#$00#$06#$07#$80#$74#$8B#$00#$40#$6C#$4C+
#$30#$F6#$01#$00#$00#$00#$00#$01#$0D#$00#$80#$4D#$C4#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$07#$07#$80#$74+
#$8C#$00#$40#$6C#$4D#$30#$F6#$01#$00#$00#$00#$00#$08#$07#$80#$74#$8C#$00#$40#$6C#$4D#$30#$F6#$01#$00#$00#$00#$00+
#$09#$07#$80#$74#$8C#$00#$40#$6C#$4D#$30#$F6#$01#$00#$00#$00#$00#$0A#$07#$80#$74#$8C#$00#$40#$6C#$4D#$30#$F6#$01+
#$00#$00#$00#$00#$0B#$07#$80#$74#$8C#$00#$40#$6C#$4D#$30#$F6#$01#$00#$00#$00#$00#$0C#$07#$80#$74#$8C#$00#$40#$6C+
#$4D#$30#$F6#$01#$00#$00#$00#$00#$01#$0E#$00#$80#$4D#$C5#$AB#$61#$01#$03#$00#$00#$00#$06#$00#$00#$00#$0D#$07#$80+
#$74#$8D#$00#$40#$6C#$4E#$30#$F6#$01#$00#$00#$00#$00#$0E#$07#$80#$74#$8D#$00#$40#$6C#$4E#$30#$F6#$01#$00#$00#$00+
#$00#$0F#$07#$80#$74#$8D#$00#$40#$6C#$4E#$30#$F6#$01#$00#$00#$00#$00#$10#$07#$80#$74#$8D#$00#$40#$6C#$4E#$30#$F6+
#$01#$00#$00#$00#$00#$11#$07#$80#$74#$8D#$00#$40#$6C#$4E#$30#$F6#$01#$00#$00#$00#$00#$12#$07#$80#$74#$8D#$00#$40+
#$6C#$4E#$30#$F6#$01#$00#$00#$00#$00#$01#$0F#$00#$80#$4D#$C6#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$2B#$07+
#$80#$74#$9F#$00#$40#$6C#$4F#$30#$F6#$01#$00#$00#$00#$00#$2C#$07#$80#$74#$9F#$00#$40#$6C#$4F#$30#$F6#$01#$00#$00+
#$00#$00#$2D#$07#$80#$74#$9F#$00#$40#$6C#$4F#$30#$F6#$01#$00#$00#$00#$00#$2E#$07#$80#$74#$9F#$00#$40#$6C#$4F#$30+
#$F6#$01#$00#$00#$00#$00#$2F#$07#$80#$74#$9F#$00#$40#$6C#$4F#$30#$F6#$01#$00#$00#$00#$00#$30#$07#$80#$74#$9F#$00+
#$40#$6C#$4F#$30#$F6#$01#$00#$00#$00#$00#$31#$07#$80#$74#$9F#$00#$40#$6C#$4F#$30#$F6#$01#$00#$00#$00#$00#$32#$07+
#$80#$74#$9F#$00#$40#$6C#$4F#$30#$F6#$01#$00#$00#$00#$00#$33#$07#$80#$74#$9F#$00#$40#$6C#$4F#$30#$F6#$01#$00#$00+
#$00#$00#$01#$10#$00#$80#$4D#$C7#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$F3#$07#$80#$74#$A2#$00#$40#$6C#$50+
#$30#$F6#$01#$00#$00#$00#$00#$F4#$07#$80#$74#$A2#$00#$40#$6C#$50#$30#$F6#$01#$00#$00#$00#$00#$F5#$07#$80#$74#$A2+
#$00#$40#$6C#$50#$30#$F6#$01#$00#$00#$00#$00#$F6#$07#$80#$74#$A2#$00#$40#$6C#$50#$30#$F6#$01#$00#$00#$00#$00#$F7+
#$07#$80#$74#$A2#$00#$40#$6C#$50#$30#$F6#$01#$00#$00#$00#$00#$F8#$07#$80#$74#$A2#$00#$40#$6C#$50#$30#$F6#$01#$00+
#$00#$00#$00#$F9#$07#$80#$74#$A2#$00#$40#$6C#$50#$30#$F6#$01#$00#$00#$00#$00#$FA#$07#$80#$74#$A2#$00#$40#$6C#$50+
#$30#$F6#$01#$00#$00#$00#$00#$FB#$07#$80#$74#$A2#$00#$40#$6C#$50#$30#$F6#$01#$00#$00#$00#$00#$01#$11#$00#$80#$4D+
#$C8#$AB#$61#$01#$03#$00#$00#$00#$09#$00#$00#$00#$FC#$07#$80#$74#$A3#$00#$40#$6C#$51#$30#$F6#$01#$00#$00#$00#$00+
#$FD#$07#$80#$74#$A3#$00#$40#$6C#$51#$30#$F6#$01#$00#$00#$00#$00#$FE#$07#$80#$74#$A3#$00#$40#$6C#$51#$30#$F6#$01+
#$00#$00#$00#$00#$FF#$07#$80#$74#$A3#$00#$40#$6C#$51#$30#$F6#$01#$00#$00#$00#$00#$00#$08#$80#$74#$A3#$00#$40#$6C+
#$51#$30#$F6#$01#$00#$00#$00#$00#$01#$08#$80#$74#$A3#$00#$40#$6C#$51#$30#$F6#$01#$00#$00#$00#$00#$02#$08#$80#$74+
#$A3#$00#$40#$6C#$51#$30#$F6#$01#$00#$00#$00#$00#$03#$08#$80#$74#$A3#$00#$40#$6C#$51#$30#$F6#$01#$00#$00#$00#$00+
#$04#$08#$80#$74#$A3#$00#$40#$6C#$51#$30#$F6#$01#$00#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$1D#$02#$00#$00#$00#$00#$04#$00#$00#$00#$04#$00#$00#$00#$01#$12#$00#$80#$4D#$C9#$AB#$61#$01#$03#$00#$00#$00#$05+
#$00#$00#$00#$05#$08#$80#$74#$A7#$00#$40#$6C#$52#$30#$F6#$01#$00#$00#$00#$00#$06#$08#$80#$74#$A7#$00#$40#$6C#$52+
#$30#$F6#$01#$00#$00#$00#$00#$07#$08#$80#$74#$A7#$00#$40#$6C#$52#$30#$F6#$01#$00#$00#$00#$00#$08#$08#$80#$74#$A7+
#$00#$40#$6C#$52#$30#$F6#$01#$00#$00#$00#$00#$09#$08#$80#$74#$A7#$00#$40#$6C#$52#$30#$F6#$01#$00#$00#$00#$00#$01+
#$13#$00#$80#$4D#$CA#$AB#$61#$01#$03#$00#$00#$00#$05#$00#$00#$00#$0A#$08#$80#$74#$A4#$00#$40#$6C#$53#$30#$F6#$01+
#$00#$00#$00#$00#$0B#$08#$80#$74#$A4#$00#$40#$6C#$53#$30#$F6#$01#$00#$00#$00#$00#$0C#$08#$80#$74#$A4#$00#$40#$6C+
#$53#$30#$F6#$01#$00#$00#$00#$00#$0D#$08#$80#$74#$A4#$00#$40#$6C#$53#$30#$F6#$01#$00#$00#$00#$00#$0E#$08#$80#$74+
#$A4#$00#$40#$6C#$53#$30#$F6#$01#$00#$00#$00#$00#$01#$14#$00#$80#$4D#$CB#$AB#$61#$01#$03#$00#$00#$00#$07#$00#$00+
#$00#$0F#$08#$80#$74#$A5#$00#$40#$6C#$54#$30#$F6#$01#$00#$00#$00#$00#$10#$08#$80#$74#$A5#$00#$40#$6C#$54#$30#$F6+
#$01#$00#$00#$00#$00#$11#$08#$80#$74#$A5#$00#$40#$6C#$54#$30#$F6#$01#$00#$00#$00#$00#$12#$08#$80#$74#$A5#$00#$40+
#$6C#$54#$30#$F6#$01#$00#$00#$00#$00#$13#$08#$80#$74#$A5#$00#$40#$6C#$54#$30#$F6#$01#$00#$00#$00#$00#$14#$08#$80+
#$74#$A5#$00#$40#$6C#$54#$30#$F6#$01#$00#$00#$00#$00#$15#$08#$80#$74#$A5#$00#$40#$6C#$54#$30#$F6#$01#$00#$00#$00+
#$00#$01#$15#$00#$80#$4D#$CC#$AB#$61#$01#$03#$00#$00#$00#$07#$00#$00#$00#$16#$08#$80#$74#$A6#$00#$40#$6C#$55#$30+
#$F6#$01#$00#$00#$00#$00#$17#$08#$80#$74#$A6#$00#$40#$6C#$55#$30#$F6#$01#$00#$00#$00#$00#$18#$08#$80#$74#$A6#$00+
#$40#$6C#$55#$30#$F6#$01#$00#$00#$00#$00#$19#$08#$80#$74#$A6#$00#$40#$6C#$55#$30#$F6#$01#$00#$00#$00#$00#$1A#$08+
#$80#$74#$A6#$00#$40#$6C#$55#$30#$F6#$01#$00#$00#$00#$00#$1B#$08#$80#$74#$A6#$00#$40#$6C#$55#$30#$F6#$01#$00#$00+
#$00#$00#$1C#$08#$80#$74#$A6#$00#$40#$6C#$55#$30#$F6#$01#$00#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$F1#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$35#$01),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$38#$01#$00#$00#$00#$00#$03#$00#$24#$29#$8C#$00#$01#$00#$C0#$7C#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$01#$00#$DB#$99#$8C#$00#$02#$00#$C0#$7C#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$01#$00#$0C#$29#$8C#$00#$03#$00#$C0#$7C#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$01#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$36#$01),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$81#$01#$00#$00#$00#$00#$00),Lista[i].key));

  enviarcookies(i);

Lista[i].socket.sendtext(EncryptS(Compress(#$69#$01#$05#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$69#$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$B4#$00#$05#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$B4#$00#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$58#$01#$00#$74#$24#$14#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7F#$7F#$7F#$7F#$7F#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$0F#$02#$00#$00#$00#$00#$0A#$00#$00#$00#$75#$0B#$48#$03#$40#$53#$47#$49#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$0A#$00#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$0B#$00#$00#$18#$00#$03#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF#$00#$00#$00#$00#$30#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$BA#$BF#$47#$03#$40#$53#$47#$49#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$22#$00#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$25#$00#$00#$18#$00#$03#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF#$00#$00#$00#$00#$30#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$5E#$8B#$46#$03#$40#$53#$47#$49#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$7F#$00#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$08#$02#$00#$1A#$00#$01#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF#$00#$00#$00#$00#$30#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$3C#$46#$46#$03#$40#$53#$47#$49#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$95#$00#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$09#$00#$00#$18#$00#$03#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF#$00#$00#$00#$00#$30#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$79#$5D#$45#$03#$40#$53#$47#$49#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$D9#$00#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$2E#$00#$00#$18#$00#$03#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF#$00#$00#$00#$00#$30#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$5A#$22#$45#$03#$40#$53#$47#$49#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$ED#$00#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$05#$00#$00#$18#$00#$03#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF#$00#$00#$00#$00#$30#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$1E#$A7#$44#$03#$40#$53#$47#$49#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$10#$01#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$04#$00#$00#$18#$00#$03#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF#$00#$00#$00#$00#$30#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$95#$65#$44#$03#$40#$53#$47#$49#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$23#$01#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$25#$00#$00#$18#$00#$03#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF#$00#$00#$00#$00#$30#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$2C#$EC#$43#$03#$40#$53#$47#$49#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$40#$01#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$10#$00#$00#$18#$00#$03#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF#$00#$00#$00#$00#$30#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$B8#$81#$43#$03#$40#$53#$47#$49#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$54#$01#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$10#$00#$00#$18#$00#$03#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF#$00#$00#$00#$00#$30#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key));

Lista[i].socket.sendtext(EncryptS(Compress(#$FC#$00#$01#$4D#$53#$4E#$5F#$31#$00#$00#$00#$50#$7E#$D2#$1B#$00#$00#$00#$00#$00#$60#$00#$00#$50#$7E#$D2#$1B#$58#$7E#$D2#$1B#$78#$01#$E2#$00#$00#$00#$00#$00#$00#$60#$00#$00#$F7#$04#$00#$00#$88#$13#$00#$00#$3A#$02#$00#$00#$32+
#$31#$36#$2E#$34#$2E#$32#$30#$35#$2E#$31#$36#$32#$00#$D1#$02#$04#$00#$D0#$1E#$00#$00#$00#$10#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key));

  enviarpayday(i);
end;

procedure x2(i: integer);
begin
Lista[i].socket.SendText(encryptS(compress(#$0E#$01#$00#$00#$00#$00#$6B#$75#$72#$61#$6D#$61#$72#$75#$78#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$6E#$61#$6F#$71#$75#$65#$72#$6F#$62#$61#$6E#$31#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$DA#$40#$14#$00#$00#$00+
#$00#$00#$4B#$75#$72#$61#$6D#$61#$2D#$42#$52#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$73#$6F#$6E#$65+
#$78#$61#$31#$35#$39#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$B9#$B4#$10#$00#$00#$00#$00#$00#$6E#$69+
#$6E#$6A#$61#$79#$28#$65#$34#$29#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$64#$65#$62#$75#$67#$32#$31#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$3B#$13#$14#$00#$00#$00#$00#$00#$6E#$61#$72#$75#$74#$6F+
#$77#$28#$65#$31#$31#$29#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$64#$65#$62#$75#$67#$39#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$F7#$0C#$14#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key));

enviardiasonline(i);
end;

procedure teste4(i: integer);
begin
  Lista[i].socket.sendtext(EncryptS(Compress(#$2B#$01#$01#$00#$00#$00#$74#$24#$14#$00#$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00),Lista[i].key));
end;

procedure teste5(i: integer);
begin
  Lista[i].socket.sendtext(EncryptS(Compress(#$6B#$00#$04#$02#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key));
end;

procedure teste6(i: integer);
var
  cid, perso: Integer;
begin
  if dbug=1 then debug('Acessando My Room',i);
  MySQL.Connected:=True;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_members where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  cid:=Query.fieldbyname('personagemselecionado').asinteger;
  
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_chars where cid = '+QuotedStr(inttostr(cid))+'');
  Query.Open;

  Lista[i].socket.sendtext(EncryptS(Compress(#$6B#$00#$04#$09+hextoascii(reversestring2(IntToHex(cid,8)))+#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key));
  //Lista[i].socket.sendtext(EncryptS(Compress(#$6B#$00#$04#$02#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
//#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key));
  //Lista[i].socket.sendtext(EncryptS(Compress(#$70#$01#$00#$00#$00#$00#$4C#$00#$00#$00),Lista[i].key));

  //10 02 é o mail
  Lista[i].socket.sendtext(EncryptS(Compress(#$10#$02#$00#$00#$00#$00#$01#$00#$00#$00#$03#$00#$00#$00#$14#$00#$00#$00#$5E#$8B#$46#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$0D#$00#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$08#$02#$00#$1A#$00+
#$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$3C#$46#$46#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$23#$00#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$09#$00#$00#$18#$00+
#$03#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$79#$5D#$45#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$67#$00#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$2E#$00#$00#$18#$00+
#$03#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$5A#$22#$45#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$7B#$00#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$05#$00#$00#$18#$00+
#$03#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$1E#$A7#$44#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$9E#$00#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$04#$00#$00#$18#$00+
#$03#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$95#$65#$44#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$B1#$00#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$25#$00#$00#$18#$00+
#$03#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$2C#$EC#$43#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$CE#$00#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$10#$00#$00#$18#$00+
#$03#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$B8#$81#$43#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$E2#$00#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$10#$00#$00#$18#$00+
#$03#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$69#$3F#$43#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FA#$00#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$11#$00#$00#$18#$00+
#$03#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$61#$0C#$42#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$72#$01#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$09#$00#$00#$18#$00+
#$03#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$0D#$C9#$41#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$8B#$01#$00#$00#$00#$02#$00#$00#$00#$FF#$FF#$FF#$FF#$0F#$00#$00#$1A#$00+
#$05#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$C1#$C8#$41#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$8B#$01#$00#$00#$00#$02#$00#$00#$00#$FF#$FF#$FF#$FF#$04#$00#$00#$18#$00+
#$0A#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$77#$C8#$41#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$8B#$01#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$11#$00#$00#$1A#$00+
#$3C#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$AD#$5C#$41#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$B8#$01#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$08#$02#$00#$1A#$00+
#$01#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$08#$9D#$40#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FD#$01#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$07#$00#$00#$18#$00+
#$03#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$AA#$D9#$3F#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$2E#$02#$00#$00#$00#$02#$00#$00#$00#$FF#$FF#$FF#$FF#$04#$00#$00#$18#$00+
#$05#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$36#$D9#$3F#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$2F#$02#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$27#$00#$00#$18#$00+
#$03#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$33#$39#$3B#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$24#$03#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$06#$00#$00#$18#$00+
#$03#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$4A#$A8#$38#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$9D#$03#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$09#$00#$00#$18#$00+
#$03#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$F8#$2A#$38#$03#$40#$53#$47#$49#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$B3#$03#$00#$00#$00#$01#$00#$00#$00#$FF#$FF#$FF#$FF#$0E#$00#$00#$18#$00+
#$03#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$FF#$FF#$FF#$FF+
#$00#$00#$00#$00#$30#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key));


  Lista[i].socket.sendtext(EncryptS(Compress(#$68#$01#$C0#$00#$00#$00+hextoascii(reversestring2(IntToHex(i,8)))+wrapper(Lista[i].nick,39)+#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$04#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$08#$00+
#$05#$00#$0A#$00#$00#$00#$00#$67#$75#$69#$6C#$64#$6D#$61#$72#$6B#$00#$00#$00#$74#$24#$14#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$87#$F4#$7F#$C2#$10#$84#$B3#$C3#$48#$13#$62#$BE#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$70#$61#$6E#$67#$73#$6B#$75#$72#$61#$6D#$61#$40#$4E#$54#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
hextoascii(reversestring2(IntToHex(Query.fieldbyname('personagem').AsInteger,8)))+hextoascii(reversestring2(IntToHex(cid,8)))+#$00#$04#$00#$08#$00#$00#$00#$00#$00#$44#$00#$08#$12#$60#$00#$08#$00#$84#$00#$08+
#$0F#$A0#$00#$08#$00#$00#$00#$00#$00#$E4#$00#$08#$00#$00#$01#$08#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$8D#$24#$04#$06+
#$00#$00#$00#$00#$C4#$41#$04#$06#$00#$00#$00#$00#$00#$00#$00#$00#$F9#$24#$04#$06#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00+
#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key));

  {Lista[i].socket.sendtext(EncryptS(Compress(#$2D#$01#$01#$00#$00#$00#$03#$00#$65#$2B#$22#$00#$20#$68#$00#$48#$00#$00#$33#$33#$73#$41#$00#$00#$00#$00#$00#$00+
#$48#$41#$00#$00#$18#$43#$00#$64#$2B#$22#$00#$1D#$50#$00#$48#$00#$00#$00#$00#$62#$41#$00#$00#$80#$3F#$9E#$EF#$27+
#$3D#$00#$00#$00#$00#$00#$63#$2B#$22#$00#$14#$00#$00#$48#$00#$00#$C3#$F5#$28#$BF#$00#$00#$80#$3F#$5C#$8F#$72#$41+
#$00#$00#$00#$00#$00),Lista[i].key)); }
  Query.Close;
  MySQL.Connected:=false;
end;

end.

