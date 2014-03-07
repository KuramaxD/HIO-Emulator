unit iff;

interface

uses Windows, SysUtils, colors, funcoes, Classes, StrUtils;

type
TCaddies = record
  id: integer;
  nome: AnsiString;
  preco: integer;
end;

type
TItens = record
  id: integer;
  nome: AnsiString;
end;

type
TMascotes = record
  id: integer;
  nome: AnsiString;
  slot: integer;
end;

var
  Caddies: array of TCaddies;
  Itens: array of TItens;
  Mascotes: array of TMascotes;

procedure loadiffs();
procedure loadcaddieiff();
procedure loaditemiff();
procedure loadmascotsiff();

implementation

procedure loadcaddieiff();
var
  themstream : TMemoryStream;
  iff, nome: ansistring;
  istart, i, len: integer;
begin
  if fileexists('data\caddie.iff') then begin
    themstream:=TMemoryStream.Create;
    themstream.loadfromfile('data\caddie.iff');
    iff:=memorystreamtostring(themstream);
    themstream.free;
    istart:=13;
    while istart <= Length(iff) do begin
      len:=Length(Caddies);
      SetLength(Caddies,len+1);
      Caddies[len].id:=returnsize(Copy(iff,istart,4))-4;
      for i:=istart to istart+40 do begin
        if iff[i+4] <> #$00 then
          nome:=nome+iff[i+4]
        else Break;
      end;
      Caddies[len].nome:=nome;
      Caddies[len].preco:=returnsize(Copy(iff,istart+148,4))-4;
      nome:='';
      istart:=istart+208;
    end;
    TextColor(14);
    Writeln('[IFF_S] Caddie.iff carregado ('+inttostr(Length(caddies))+' Caddies encontrados!)');
    TextColor(7);
  end
  else begin
    TextColor(12);
    Writeln('[IFF_S] Caddie.iff nao encontrado');
    TextColor(7);
  end;
end;

procedure loaditemiff();
var
  themstream : TMemoryStream;
  iff, nome: ansistring;
  istart, i, len: integer;
begin
  if fileexists('data\item.iff') then begin
    themstream:=TMemoryStream.Create;
    themstream.loadfromfile('data\item.iff');
    iff:=memorystreamtostring(themstream);
    themstream.free;
    istart:=13;
    while istart <= Length(iff) do begin
      len:=Length(Itens);
      SetLength(Itens,len+1);
      Itens[len].id:=returnsize(Copy(iff,istart,4))-4;
      for i:=istart to istart+40 do begin
        if iff[i+4] <> #$00 then
          nome:=nome+iff[i+4]
        else Break;
      end;
      Itens[len].nome:=nome;
      nome:='';
      istart:=istart+208;
    end;
    TextColor(14);
    Writeln('[IFF_S] Item.iff carregado ('+inttostr(Length(itens))+' Itens encontrados!)');
    TextColor(7);
  end
  else begin
    TextColor(12);
    Writeln('[IFF_S] Item.iff nao encontrado');
    TextColor(7);
  end;
end;

procedure loadmascotsiff();
var
  themstream : TMemoryStream;
  iff, nome: ansistring;
  istart, i, len: integer;
begin
  if fileexists('data\mascots.iff') then begin
    themstream:=TMemoryStream.Create;
    themstream.loadfromfile('data\mascots.iff');
    iff:=memorystreamtostring(themstream);
    themstream.free;
    istart:=13;
    while istart <= Length(iff) do begin
      len:=Length(Mascotes);
      SetLength(Mascotes,len+1);
      Mascotes[len].id:=returnsize(Copy(iff,istart,4))-4;
      for i:=istart to istart+40 do begin
        if iff[i+4] <> #$00 then
          nome:=nome+iff[i+4]
        else Break;
      end;
      Mascotes[len].nome:=nome;
      Mascotes[len].slot:=returnsize(Copy(iff,istart+88,2))-4;
      nome:='';
      istart:=istart+264;
    end;
    TextColor(14);
    Writeln('[IFF_S] Mascots.iff carregado ('+inttostr(Length(Mascotes))+' Mascotes encontrados!)');
    TextColor(7);
  end
  else begin
    TextColor(12);
    Writeln('[IFF_S] Mascots.iff nao encontrado');
    TextColor(7);
  end;
end;

procedure loadiffs();
begin
  loadmascotsiff;
  loaditemiff;
  loadcaddieiff;
end;

end.
