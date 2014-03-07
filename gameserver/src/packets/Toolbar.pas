unit Toolbar;

(*

Unit que cria o pacote da toolbar do PangYa.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Serve para pegar as seleções da toolbar e enviar para o cliente.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure LxEnviarToolbar(i: integer);

implementation

uses main, sockets, database;

procedure LxEnviarToolbar(i: integer);
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

end.
