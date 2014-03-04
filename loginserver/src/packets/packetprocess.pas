unit packetprocess;

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts;

procedure checarlogin(data: AnsiString; i: integer);
procedure senhaincorreta(i: Integer);
procedure banido(i: Integer);
procedure primeirologin(i: integer);
procedure checarnick(data: ansistring; i: integer);
procedure nickdisponivel(i: Integer);
procedure nickindisponivel(i: Integer);
procedure salvarnick(data: ansistring; i: integer);
procedure terminarprimeirologin(data: ansistring; i: integer);
procedure codigo1(i: Integer);
procedure codigo2(i: Integer);
procedure criarmacros(i: Integer);
procedure servidores(i: Integer);
procedure dadospessoais(i: integer);
procedure usuariologado(i: integer);

implementation

uses main, sockets, database;

procedure senhaincorreta(i: Integer);
var
  pdata: ansistring;
begin
  pdata:=EncryptS(Compress(#$01#$00#$E2#$61#$D2#$4D#$00#$1B#$00#$49#$6E#$63#$6F#$72#$72#$65#$63#$74#$20#$6C#$6F#$67#$69#$6E#$20#$63#$72#$65#$64#$65#$6E#$74#$69#$61#$6C#$73#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key);
  Lista[i].socket.SendText(pdata);
end;

procedure banido(i: Integer);
var
  pdata: ansistring;
begin
  pdata:=EncryptS(Compress(#$01#$00#$E2#$F4#$D1#$4D#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key);
  Lista[i].socket.SendText(pdata);
end;

procedure primeirologin(i: integer);
var
  pdata: ansistring;
begin
  pdata:=EncryptS(Compress(#$0F#$00#$00+chr(Length(Lista[i].login))+#$00+Lista[i].login+#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key);
  Lista[i].socket.SendText(pdata);
  pdata:=EncryptS(Compress(#$01#$00#$D8#$FF#$FF#$FF#$FF#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00),Lista[i].key);
  Lista[i].socket.SendText(pdata);
end;

procedure nickdisponivel(i: Integer);
var
  pdata: ansistring;
begin
  pdata:=EncryptS(Compress(#$0E#$00#$00#$00#$00#$00+chr(length(Lista[i].nick))+#$00+Lista[i].nick),Lista[i].key);
  Lista[i].socket.SendText(pdata);
end;

procedure nickindisponivel(i: Integer);
var
  pdata: ansistring;
begin
  pdata:=EncryptS(Compress(#$0E#$00#$0B#$00#$00#$00#$21#$D2#$4D#$00),Lista[i].key);
  Lista[i].socket.SendText(pdata);
end;

procedure salvarnick(data: ansistring; i: integer);
var
  pdata, nick: ansistring;
begin
  nick:=copy(data,10,byte(data[8]));
  Lista[i].nick:=nick;
  pdata:=EncryptS(Compress(#$01#$00#$D9#$00#$00),Lista[i].key);
  Lista[i].socket.sendtext(pdata);
end;

procedure checarnick(data: ansistring; i: integer);
var
  nick: ansistring;
begin
  nick:=copy(data,10,byte(data[8]));
  MySQL.Connected:=true;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_members where nick = '+QuotedStr(nick)+'');
  Query.Open;
  if Query.isempty then begin
    Lista[i].nick:=nick;
    nickdisponivel(i);
  end
  else begin
    nickindisponivel(i);
  end;
  Query.Close;
  MySQL.Connected:=false;
end;

procedure codigo1(i: Integer);
var
  pdata: AnsiString;
begin
  Lista[i].codigo1:=gerarcodigo;
  MySQL.Connected:=true;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('update py_members set codigo1 = '+QuotedStr(Lista[i].codigo1)+' where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.ExecSQL;
  pdata:=EncryptS(Compress(#$10#$00+chr(Length(Lista[i].codigo1))+#$00+Lista[i].codigo1),Lista[i].key);
  Lista[i].socket.SendText(pdata);
  MySQL.Connected:=false;
end;

procedure codigo2(i: Integer);
var
  pdata: AnsiString;
begin
  Lista[i].codigo2:=gerarcodigo;
  MySQL.Connected:=true;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('update py_members set codigo2 = '+QuotedStr(Lista[i].codigo2)+' where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.ExecSQL;
  pdata:=EncryptS(Compress(#$03#$00#$00#$00#$00#$00+chr(Length(Lista[i].codigo2))+#$00+Lista[i].codigo2),Lista[i].key);
  Lista[i].socket.SendText(pdata);
  MySQL.Connected:=false;
end;

procedure terminarprimeirologin(data: ansistring; i: integer);
var
  pdata: ansistring;
  personagem, cabelo, cid: integer;
begin
  personagem:=returnsize(copy(data,8,4))-4;
  cabelo:=returnsize(copy(data,12,2))-4;
  MySQL.Connected:=true;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('update py_members set nick = '+QuotedStr(Lista[i].nick)+' where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.ExecSQL;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('insert into py_chars (uid, personagem, cabelo) values ('+QuotedStr(inttostr(Lista[i].uid))+','+QuotedStr(inttostr(personagem))+','+QuotedStr(inttostr(cabelo))+')');
  Query.ExecSQL;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('update py_members set firstset = 1 where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.ExecSQL;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('insert into py_macros (uid) values ('+QuotedStr(inttostr(Lista[i].uid))+')');
  Query.ExecSQL;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_chars where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  cid:=Query.fieldbyName('cid').AsInteger;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('update py_members set personagemselecionado = '+QuotedStr(inttostr(cid))+' where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.ExecSQL;
  pdata:=EncryptS(Compress(#$11#$00#$00),Lista[i].key);
  codigo1(i);
  criarmacros(i);
  servidores(i);
  dadospessoais(i);
  MySQL.Connected:=false;
end;

procedure criarmacros(i: Integer);
var
  pdata: AnsiString;
  u: integer;
begin
  MySQL.Connected:=true;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_macros where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
  Query.Open;
  pdata:='';
  for u:=1 to 9 do begin
    pdata:=pdata+wrapper(Query.FieldByName('macro'+inttostr(u)).AsString,64);
  end;
  pdata:=EncryptS(Compress(#$06#$00+pdata),Lista[i].key);
  Lista[i].socket.SendText(pdata);
  Query.Close;
  MySQL.Connected:=false;
end;

procedure dadospessoais(i: integer);
var
  pdata: ansistring;
begin
  pdata:=EncryptS(Compress(#$01#$00#$00+chr(length(Lista[i].login))+#$00+Lista[i].login+hextoascii(reversestring(inttohex(Lista[i].uid,8)))+#$00#$00#$00#$00#$1A#$00#$00#$00#$00#$00#$00#$00#$00#$00+chr(length(Lista[i].nick))+#$00+Lista[i].nick+#$00#$00),Lista[i].key);
  Lista[i].socket.SendText(pdata);
  pdata:=EncryptS(Compress(#$03#$09#$00#$00),Lista[i].key);
  Lista[i].socket.SendText(pdata);
end;

procedure servidores(i: Integer);
var
  pdata: AnsiString;
  qt: integer;
begin
  qt:=0;
  MySQL.Connected:=true;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_servers');
  Query.Open;
  while not Query.eof do begin
    qt:=qt+1;
    pdata:=pdata+wrapper(Query.FieldByName('nome').AsString,40)+hextoascii(reversestring(IntToHex(Query.FieldByName('sid').AsInteger,8)))+#$40#$06#$00#$00#$F0#$00#$00#$00+wrapper(Query.FieldByName('ip').AsString,18)+hextoascii(reversestring(IntToHex(Query.FieldByName('porta').AsInteger,8)))+#$00#$00#$00#$00+hextoascii(reversestring(IntToHex(Query.FieldByName('usuariosonline').AsInteger,8)))+#$00#$00#$00#$00#$64#$00#$00#$00+chr(Query.FieldByName('icone').AsInteger)+#$00;
    Query.Next;
  end;
  pdata:=EncryptS(Compress(#$02#$00+chr(qt)+pdata),Lista[i].key);
  Lista[i].socket.SendText(pdata);
  Query.Close;
  MySQL.Connected:=false;
end;

procedure usuariologado(i: integer);
var
  pdata: ansistring;
begin
  pdata:=EncryptS(Compress(#$01#$00#$E2#$4B#$D2#$4D#$00#$00#$00),Lista[i].key);
  Lista[i].socket.SendText(pdata);
end;

procedure checarlogin(data: AnsiString; i: integer);
var
  login, senha: ansistring;
begin
  login:=copy(data,10,ord(data[8]));
  senha:=lowercase(copy(data,12+ord(data[8]),32));
  Writeln('[SERVER_S] Recebendo pedido de login do usuario: '+login);
  MySQL.Connected:=true;
  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('select * from py_members where login = '+QuotedStr(login)+'');
  Query.Open;
  if UpperCase(senha)=Query.FieldByName('senha').AsString then begin
    if Query.FieldByName('banido').AsInteger=0 then begin
      if (Query.FieldByName('loginstatus').AsInteger=0) and (Query.FieldByName('gamestatus').AsInteger=0) then begin
        Lista[i].login:=login;
        Lista[i].uid:=Query.FieldByName('uid').AsInteger;
        Lista[i].nick:=Query.FieldByName('nick').AsString;
        Writeln('[SERVER_S] Login permitido');
        if Query.FieldByName('firstset').AsInteger=0 then begin
          primeirologin(i);
        end
        else begin
          codigo1(i);
          criarmacros(i);
          servidores(i);
          dadospessoais(i);
        end;
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add('update py_members set loginstatus = 1 where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
        Query.ExecSQL;
      end
      else begin
        usuariologado(i);
        TextColor(12);
        Writeln('[SERVER_S] Usuario ja logado');
        TextColor(7);
      end;
    end
    else begin
      TextColor(12);
      Writeln('[SERVER_S] Login nao permitido');
      TextColor(7);
      banido(i);
    end;
  end
  else begin
    senhaincorreta(i);
    TextColor(12);
    Writeln('[SERVER_S] Login nao permitido');
    TextColor(7);
  end;
  Query.Close;
  MySQL.Connected:=false;
end;

end.
