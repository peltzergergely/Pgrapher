unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TARadialSeries, TASeries, Forms,
  Controls, Graphics, Dialogs, StdCtrls, CSVDocument, strutils, character;

type

  { TForm1 }
  dataArray = array of double;

  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

const
  filename: string = 'C:\Users\l-gpeltzer\Downloads\reports\ResultFiles\LTC_EOL_MEAS_PROTO_0831.csv';
//filename: string = 'C:\Users\l-gpeltzer\Downloads\reports\ResultFiles\normal_test.csv';

implementation

{$R *.frm}

{ TForm1 }
function loadCSV(filename: string): TStringList;
var
  StrList: TStringList;
begin
  StrList := TStringList.Create;
  StrList.LoadFromFile(FileName);
  for i:0 to Strlist.Count -1 do
      StrList[i] := StringReplace(s, ',', '.', [rfReplaceAll]);
  Result := StrList;
end;

function getRow(StrList: TStringList; ROW: integer): TStringList;
var
  tmp: TStringList;
begin
  tmp := TStringList.Create;
  tmp.Delimiter := ';';
  tmp.StrictDelimiter := True;

end;

function csvDelimiter(strList: TStringList; ROW: integer): TStringList;
var
  strList1, tmp, tmp2: TStringList;
  i, j: integer;
  s: string;
begin
  StrList1 := TStringList.Create;
  tmp := TStringList.Create;
  tmp2 := TStringList.Create;
  StrList.LoadFromFile(FileName);
  tmp.Delimiter := ';';
  tmp.StrictDelimiter := True;
  //tmp2.add(Strlist.Count.tostring);}

  {for i := 0 to StrList.Count - 1 do
  begin
    tmp.DelimitedText := StrList[i];
    if row < tmp.Count then
      s := tmp[row];
    s := StringReplace(s, ',', '.', [rfReplaceAll]);
    end;
    tmp2.add(s);
  end;
  Result := tmp2;}
end;

function IsNumeric(Value: string; const AllowFloat: boolean): boolean;
var
  ValueInt: integer;
  ValueFloat: extended;
  ErrCode: integer;
begin
  // Check for integer: Val only accepts integers when passed integer param
  Value := SysUtils.Trim(Value);
  Val(Value, ValueInt, ErrCode);
  Result := ErrCode = 0;      // Val sets error code 0 if OK
  if not Result and AllowFloat then
  begin
    // Check for float: Val accepts floats when passed float param
    Val(Value, ValueFloat, ErrCode);
    Result := ErrCode = 0;    // Val sets error code 0 if OK
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  strList: TStringList;
  i, j, notnum, ROW, errCode: integer;
  s: string;
  Valuefloat: double;
begin
  memo1.Clear;
  notnum := 0;
  row := 6;
  StrList := TStringList.Create;
  //strList := csvDelimiter(filename, 20);
  strList := loadcsv(FileName);
  for i := 0 to StrList.Count - 1 do
  begin
    memo1.Lines.add(StrList[i]);
    //Val(Strlist[i], ValueFloat, errCode);
    {if Isnumeric(StrList[i], True) then
    begin
      Val(StrList[i], ValueFloat, errCode);
      memo1.Lines.add(ValueFloat.tostring);
    end;}
  end;
end;

end.
