unit funcoes;

interface

uses SysUtils, windows, forms, colors, Classes;

function memorystreamtostring(m: TMemoryStream): ansistring;
function gerardataatual(datax: ansistring): AnsiString;
function converterdata(data: AnsiString): AnsiString;
procedure debug(txt: ansistring; i: integer);
function wrapper(data: AnsiString; tamanho: Integer): ansistring;
function returnsize(what: ansistring): integer;
function stringtohex(data: ansistring): ansistring;
function space(txt: ansistring): string;
function gerarcodigo(): string;
function reversestring2(s: string ): string;
function hextoascii(data: ansistring): ansistring;
function arraytostring(const a: array of char): ansistring;
procedure delay(dwmilliseconds: longint);

implementation

function memorystreamtostring(m: TMemoryStream): ansistring;
begin
  setstring(result, pansichar(m.memory), m.size);
end;

function gerardataatual(datax: ansistring): AnsiString;
var
  s: tstringlist;
  data, hora: TDateTime;
  datas, horas: ansistring;
begin
  if length(datax)>0 then begin
    s:=tstringlist.Create;
    extractstrings([#$20],[' '],pchar(datax),s);
    datas:=s.Strings[0];
    horas:=s.Strings[1];
    s.clear;
    extractstrings(['/'],[' '],pchar(datas),s);
    result:=hextoascii(reversestring2(IntToHex(StrToInt(s.Strings[2]),4)))+hextoascii(reversestring2(IntToHex(strtoint(s.strings[1]),8)))+hextoascii(reversestring2(IntToHex(StrToInt(s.Strings[0]),4)));
    s.clear;
    extractstrings([':'],[' '],pchar(horas),s);
    result:=result+hextoascii(reversestring2(IntToHex(StrToInt(s.Strings[0]),4)))+hextoascii(reversestring2(IntToHex(StrToInt(s.Strings[1]),4)))+hextoascii(reversestring2(IntToHex(StrToInt(s.Strings[2]),4)))+#$00#$00;
    s.free;
  end
  else begin
    data:=date;
    hora:=time;
    datas:=datetimetostr(data);
    horas:=TimeToStr(hora);
    s:=tstringlist.Create;
    extractstrings(['/'],[' '],pchar(datas),s);
    result:=hextoascii(reversestring2(IntToHex(StrToInt(s.Strings[2]),4)))+hextoascii(reversestring2(IntToHex(strtoint(s.strings[1]),8)))+hextoascii(reversestring2(IntToHex(StrToInt(s.Strings[0]),4)));
    s.clear;
    extractstrings([':'],[' '],pchar(horas),s);
    result:=result+hextoascii(reversestring2(IntToHex(StrToInt(s.Strings[0]),4)))+hextoascii(reversestring2(IntToHex(StrToInt(s.Strings[1]),4)))+hextoascii(reversestring2(IntToHex(StrToInt(s.Strings[2]),4)))+#$00#$00;
    s.free;
  end;
end;

function converterdata(data: AnsiString): AnsiString;
begin
  result:=Copy(data,7,4)+'-'+Copy(data,4,2)+'-'+Copy(data,1,2);
end;

procedure debug(txt: ansistring; i: integer);
begin
  textcolor(11);
  Writeln('[DEBUG_S] '+txt+' ('+inttostr(i)+')');
  textcolor(7);
end;

function wrapper(data: AnsiString; tamanho: Integer): ansistring;
var
  i: Integer;
  wrap: AnsiString;
begin
  wrap:='';
  for i:=1 to tamanho do begin
    if i<=Length(data) then
      wrap:=wrap+data[i]
    else
      wrap:=wrap+#$00;
  end;
  result:=wrap;
end;

function returnsize(what: ansistring): integer;
var
  ix: integer;
begin
asm
  mov eax, what
  mov ecx, dword [eax]
  mov dword ptr ds:[ix], ecx
end;
  result:=ix+4;
end;

function stringtohex(data: ansistring): ansistring;
var
  i, i2: integer;
  s: string;
begin
  i2 := 1;
  for i := 1 to length(data) do begin
    inc(i2);
    if i2 = 2 then begin
      s  := s + '';
      i2 := 1;
    end;
    s := s + inttohex(ord(data[i]), 2);
  end;
  result := s;
end;

function space(txt: ansistring): string;
var
  i: integer;
begin
  i := 3;
  result := copy(txt,0,2);
  while i <= length(txt) do begin
    result := result + ' ' +copy(txt,i,2);
    i := i+2;
  end;
end;

function gerarcodigo(): string;
const
  minc='abcdefg';
  numc='1234567890';
var
  p, q: integer;
  char, senha: ansistring;
  min, num: boolean;
begin
  char:='';
  min:= true;
  num:= true;
  if min then char:=char+minc;
  if num then char:=char+numc;
  for p:=1 to 7 do begin
    randomize;
    q:=random(length(char))+1;
    senha:=senha+char[q];
  end;
  result:=senha;
end;

function reversestring2(s: string ): string;
var
  i  : integer;
  s2 : string;
begin
  s2 := '';
  i:=0;
  while i <= length(s) do begin
    s2:=s[ i-1] + s[ i] + s2;
  i:=i+2;
  end;
  result:=copy(s2,1,length(s2)-2);
end;

function hextoascii(data: ansistring): ansistring;
function hextoint(hex: ansistring): integer;
begin
  result := strtoint('$' + hex);
end;
var
  i : integer;
begin
  result := '';
  data := stringreplace(data,' ','',[rfreplaceall]);
  for i := 1 to length(data) do begin
    if i mod 2 <> 0 then
      result := result + chr(hextoint(copy(data,i,2)));
  end;
end;

function arraytostring(const a: array of char): ansistring;
begin
  setstring(result, pchar(@a[0]), length(a));
end;

procedure delay(dwmilliseconds: longint);
var
  istart, istop: dword;
begin
  istart:=gettickcount;
  repeat
	  istop := gettickcount;
	  application.processmessages;
	  sleep(1);
  until (istop - istart) >= dwmilliseconds;
end;

end.
