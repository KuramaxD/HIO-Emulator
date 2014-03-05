unit Unit1;

(*

Unit que contém o programa.

Organizado por:
Felipe de Souza Camargo(Kurama)

Sobre o funcionamento do código:
São funções para tratamento dos pacotes do PangYa que auxiliam
o programador a trabalhar e interpretar os pacotes.

Referências:
Sem referências no momento

*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, crypts, XPMan;

type
  Tfrmain = class(TForm)
    pages: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Button1: TButton;
    TabSheet2: TTabSheet;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Memo5: TMemo;
    Memo6: TMemo;
    Memo7: TMemo;
    Memo8: TMemo;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    chk1: TCheckBox;
    TabSheet3: TTabSheet;
    Memo9: TMemo;
    Memo10: TMemo;
    Memo11: TMemo;
    Memo12: TMemo;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label12: TLabel;
    Button3: TButton;
    CheckBox1: TCheckBox;
    xpmnfst1: TXPManifest;
    procedure Memo1Change(Sender: TObject);
    procedure Memo3Change(Sender: TObject);
    procedure Memo5Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmain: Tfrmain;

implementation

{$R *.dfm}

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

function addchar(txt: ansistring): string;
var
  i: integer;
begin
  i := 3;
  result := copy(txt,0,2);
  while i <= length(txt) do begin
    result := result + '#$' +copy(txt,i,2);
    i := i+2;
  end;
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

function returnsize(what: ansistring): integer;
var
  ix: integer;
begin
asm
  mov eax, what
  mov ecx, dword [eax]
  mov dword ptr ds:[ix], ecx
end;
  result:=ix+3;
end;

function hextoascii(data: ansistring): ansistring;
function hextoint(hex: ansistring): integer;
begin
  result := strtoint('$' + hex);
end;
var
  i : integer;
begin
try
  result := '';
  data := stringreplace(data,' ','',[rfreplaceall]);
  for i := 1 to length(data) do begin
    if i mod 2 <> 0 then
      result := result + chr(hextoint(copy(data,i,2)));
  end;
except
end;
end;

procedure Tfrmain.Memo1Change(Sender: TObject);
var
  data, data2: ansistring;
  i: integer;
begin
  data:=hextoascii(memo1.text);
  i:=1;
    while i <= length(data) do begin
      if data[i]=#$00 then begin
        data2:=data2+'.';
      end
      else begin
        data2:=data2+data[i];
    end;
    i:=i+1;
  end;
  memo2.text:=data2;
end;

procedure Tfrmain.Memo3Change(Sender: TObject);
var
  data, data2: ansistring;
  i: integer;
begin
  data:=hextoascii(memo3.text);
  i:=1;
    while i <= length(data) do begin
      if data[i]=#$00 then begin
        data2:=data2+'.';
      end
      else begin
        data2:=data2+data[i];
    end;
    i:=i+1;
  end;
  memo4.text:=data2;
end;

procedure Tfrmain.Memo5Change(Sender: TObject);
var
  data, data2: ansistring;
  i: integer;
begin
  data:=hextoascii(memo5.text);
  i:=1;
    while i <= length(data) do begin
      if data[i]=#$00 then begin
        data2:=data2+'.';
      end
      else begin
        data2:=data2+data[i];
    end;
    i:=i+1;
  end;
  memo6.text:=data2;
end;

procedure Tfrmain.Button2Click(Sender: TObject);
var
  continue: boolean;
  size, packetid, i: integer;
  buff, buffdiv, buffdec, bd: ansistring;
begin
try
  buff:=hextoascii(memo5.text);
  continue:=true;
  while continue=true do begin
    size:=returnsize(buff[2]+buff[3]);
    if size>length(buff) then begin
      memo7.lines.add('packet cortado: ');
      memo7.lines.add(space(stringtohex(Copy(buff,1,size))));
      break;
    end;
    if size<=length(buff) then begin
      buffdiv:=copy(buff,1,size);
      delete(buff,1,size);
      buffdec:=decompress(decrypt(buffdiv,strtoint('$'+edit1.text)));
      packetid:=returnsize(buffdec[1]+buffdec[2])-3;
      memo7.lines.add('packet id: '+inttostr(packetid));
      if chk1.Checked=true then
        memo7.lines.add('#$'+(addchar(stringtohex(buffdec))))
      else
        memo7.lines.add(space(stringtohex(buffdec)));
      Memo7.lines.add('sleep(100);');
      memo8.lines.add('packet id: '+inttostr(packetid));
      i:=1;
      while i <= length(buffdec) do begin
        if buffdec[i]=#$00 then begin
          bd:=bd+'.';
        end
        else begin
          bd:=bd+buffdec[i];
        end;
        i:=i+1;
      end;
      memo8.lines.add(bd);
      bd:='';
    end;
  end;
except
end;
end;

procedure Tfrmain.Button1Click(Sender: TObject);
begin
try
  memo3.lines.add(space(stringtohex(DecryptS(hextoascii(memo1.text),strtoint('$'+edit2.text)))))
except
end;
end;

procedure Tfrmain.Button3Click(Sender: TObject);
var
  continue: boolean;
  size, i: integer;
  buff, buffdiv, buffdec, bd: ansistring;
begin
try
  buff:=hextoascii(memo9.text);
  continue:=true;
  while continue=true do begin
    size:=returnsize(buff[2]+buff[3]);
    if size>length(buff) then begin
      memo11.lines.add('packet cortado: ');
      memo11.lines.add(space(stringtohex(Copy(buff,1,size))));
      break;
    end;
    if size<=length(buff) then begin
      buffdiv:=copy(buff,1,size);
      delete(buff,1,size);
      buffdec:=buffdiv;
      memo11.lines.add('');
      if checkbox1.Checked=true then
        memo11.lines.add('#$'+(addchar(stringtohex(buffdec))))
      else
        memo11.lines.add(space(stringtohex(buffdec)));
      memo12.lines.add('');
      i:=1;
      while i <= length(buffdec) do begin
        if buffdec[i]=#$00 then begin
          bd:=bd+'.';
        end
        else begin
          bd:=bd+buffdec[i];
        end;
        i:=i+1;
      end;
      memo12.lines.add(bd);
      bd:='';
    end;
  end;
except
end;
end;

procedure Tfrmain.btn1Click(Sender: TObject);
begin
  memo3.lines.add(space(stringtohex(decompress(hextoascii(memo1.text)))))
end;

end.
