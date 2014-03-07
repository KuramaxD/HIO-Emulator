unit SelecionarCanal;

(*

Unit que contém a lógica para quem selecionou um canal.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Serve para checar se o usuário pode ou não entrar no canal escolhido.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure LxEntrarCanal(data: ansistring; i: integer);

implementation

uses main, sockets, database;

procedure LxEntrarCanal(data: ansistring; i: integer);
var
  pdata: ansistring;
  canalselecionado, diasmarcados, itemdehoje, quantidade, u, conectados: integer;
begin
  canalselecionado:=Byte(data[8]);
  debug('Selecionando canal: '+inttostr(canalselecionado),i);
  if canalselecionado<=length(main.Canais) then begin
    conectados:=0;
    if dbug=1 then debug('Canal aceito',i);
    for u:=0 to Length(Lista)-1 do begin
      if Lista[u].status=true then
        if Lista[u].canal=canalselecionado then
          conectados:=conectados+1;
    end;
    if conectados <= main.Canais[canalselecionado].maxusuarios then begin
      Lista[i].canal:=canalselecionado;
      pdata:=EncryptS(Compress(#$4E#$00#$01),Lista[i].key);
      Lista[i].socket.sendtext(pdata);
      MySQL.Connected:=True;
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('select * from py_members where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
      Query.Open;
      if Query.FieldByName('calendario').AsInteger=0 then begin
        if dbug=1 then debug('Criando calendario',i);
        diasmarcados:=Query.FieldByName('diasmarcados').AsInteger;
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add('select * from py_calendario where data = CURDATE()');
        Query.Open;
        itemdehoje:=Query.fieldbyname('item').asinteger;
        quantidade:=Query.fieldbyname('quantidade').asinteger;
        pdata:=encryptS(compress(#$47#$02#$00#$00#$00#$00#$00+hextoascii(reversestring2(IntToHex(itemdehoje,8)))+hextoascii(reversestring2(IntToHex(quantidade,8)))+#$00#$00#$00#$00#$00#$00#$00#$00+hextoascii(reversestring2(IntToHex(diasmarcados,8)))),Lista[i].key);
        Lista[i].socket.SendText(pdata);
      end;
      Query.Close;
      MySQL.Connected:=false;
    end
    else begin
      pdata:=EncryptS(Compress(#$4E#$00#$02),Lista[i].key);
      Lista[i].socket.sendtext(pdata);
    end;
  end
  else begin
    if dbug=1 then debug('Canal invalido',i);
    Lista[i].socket.close;
  end;
end;

end.
