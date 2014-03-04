unit ChecarLogin;

(*

Unit que contém a lógica para login.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
Serve para checar tudo sobre a conta que esta tentando logar
e decidir o que fazer.

Referências:
Sem referências no momento

*)

interface

uses Windows, SysUtils, ScktComp, colors, funcoes, crypts, SenhaIncorreta, UsuarioBanido,
UsuarioLogado, DadosPessoais, Servidores, CriarMacros, Codigo1, PrimeiroLogin;

procedure LxChecarLogin(data: AnsiString; i: integer);

implementation

uses main, sockets, database;

procedure LxChecarLogin(data: AnsiString; i: integer);
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
          Px0F(i);
        end
        else begin
          Px10(i);
          Px06(i);
          Px02(i);
          Px01d(i);
        end;
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add('update py_members set loginstatus = 1 where uid = '+QuotedStr(inttostr(Lista[i].uid))+'');
        Query.ExecSQL;
      end
      else begin
        Px01l(i);
        TextColor(12);
        Writeln('[SERVER_S] Usuario ja logado');
        TextColor(7);
      end;
    end
    else begin
      TextColor(12);
      Writeln('[SERVER_S] Login nao permitido');
      TextColor(7);
      Px01b(i);
    end;
  end
  else begin
    Px01s(i);
    TextColor(12);
    Writeln('[SERVER_S] Login nao permitido');
    TextColor(7);
  end;
  Query.Close;
  MySQL.Connected:=false;
end;

end.
