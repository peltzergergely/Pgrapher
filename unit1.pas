unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls, Graphics,
  Dialogs, TAFuncSeries, TASources, TATools, TAAxisSource, TAStyles,
  TATransformations, DBGrids, Menus, StdCtrls, Spin, FileCtrl, Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    saveBtn: TButton;
    Chart1BarSeries1: TBarSeries;
    FileOpen: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    NextBtn: TButton;
    OpenDialog1: TOpenDialog;
    PrevBtn: TButton;
    Chart1: TChart;
    ChartCumulNormDistr: TChart;
    catCumulNormDistrCumulNormDistrAxisTransform1: TCumulNormDistrAxisTransform;
    catCumulNormDistrLinearAxisTransform1: TLinearAxisTransform;
    catCumulNormDistr: TChartAxisTransformations;
    ChartCumulNormDistrLineSeries1: TLineSeries;
    FileMenuItem: TMenuItem;
    Label1: TLabel;
    GrLabel: TLabel;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    SaveDialog1: TSaveDialog;
    SaveFileMenuItem1: TMenuItem;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    //procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure FileOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure PrevBtnClick(Sender: TObject);
    procedure saveBtnClick(Sender: TObject);
    procedure SaveFileMenuItem1Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit1EditingDone(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  scaleSize: integer = 100;
  filename: string = '';
  //filename: string = 'C:\Users\l-gpeltzer\Downloads\reports\ResultFiles\LTC_EOL_MEAS_TEST.csv';
  ROWCOUNTER: integer = 4;
  rowdirection: integer = 1;

implementation

{$R *.frm}

{ TForm1 }

{function CumulNormDistr(x:double) : double;
// Cumulative normal distribution
// x = -INF ... INF --> result = 0 ... 1
begin
  if x > 0 then
    result := (speerf(x/sqrt(2)) + 1) * 0.5
  else if x < 0 then
    result := (1 - speerf(-x/sqrt(2))) * 0.5
  else
    result := 0;
end;}

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

function headersCSV(const filename: string): TStringList;
var
  StrList, tmp: TStringList;
begin
  tmp := TStringList.Create;
  StrList := TStringList.Create;
  StrList.LoadFromFile(FileName);
  tmp.Delimiter := ';';
  tmp.StrictDelimiter := True;
  tmp.DelimitedText := Strlist[0];
  Result := tmp;
end;

function readCSV(const filename: string): TStringList;
var
  strList, tmp, tmp2: TStringList;
  i, j: integer;
  s: string;
begin
  StrList := TStringList.Create;
  tmp := TStringList.Create;
  tmp2 := TStringList.Create;
  StrList.LoadFromFile(FileName);
  tmp.Delimiter := ';';
  tmp.StrictDelimiter := True;
  for i := 0 to StrList.Count - 1 do
  begin
    tmp.DelimitedText := StrList[i];
    if ROWCOUNTER < tmp.Count then
      s := tmp[ROWCOUNTER];
    s := StringReplace(s, ',', '.', [rfReplaceAll]);
    tmp2.add(s);
  end;
  Result := tmp2;
end;

function NormalZ(const X: extended): extended;
{ Returns Z(X) for the Standard Normal Distribution as defined by
  Abramowitz & Stegun. This is the function that defines the Standard
  Normal Distribution Curve.
  Full Accuracy of FPU }
begin
  Result := Exp(-Sqr(X) / 2.0) / Sqrt(2 * Pi);
end;

function NormalP(const A: extended): single;
{Returns P(A) for the Standard Normal Distribution as defined by
  Abramowitz & Stegun. This is the Probability that a value is less
  than A, i.e. Area under the curve defined by NormalZ to the left
  of A.
  Only handles values A >= 0 otherwise exception raised.
  Accuracy: Absolute Error < 7.5e-8 }
const
  B1: extended = 0.319381530;
  B2: extended = -0.356563782;
  B3: extended = 1.781477937;
  B4: extended = -1.821255978;
  B5: extended = 1.330274429;
var
  T: extended;
  T2: extended;
  T4: extended;
begin
  if (A < 0) then
    raise EMathError.Create('Value must be Non-Negative')
  else
  begin
    T := 1 / (1 + 0.2316419 * A);
    T2 := Sqr(T);
    T4 := Sqr(T2);
    Result := 1.0 - NormalZ(A) * (B1 * T + B2 * T2 + B3 * T * T2 + B4 * T4 + B5 * T * T4);
  end;
end;

function NormalDistP(const Mean, StdDev, AVal: extended): single;
{Returns the Probability of (X < AVal) for a Normal Distribution
  with given Mean and Standard Deviation.
  Standard Deviation must be > 0 or function will result in an
  exception.
  Accuracy: Absolute Error < 7.5e-8 }
var
  Z: extended;
  Lower: boolean;
begin
  if (StdDev = 0) or (StdDev < 0) then
    raise EMathError.Create('Standard Deviation must be positive')
  else
  begin
    Z := (AVal - Mean) / StdDev; // Convert to Standard (z) value
    Lower := Z < 0; // If Negative use Symmetry to calculate
    if Lower then
      Z := (Mean - AVal) / StdDev;
    Result := NormalP(Z); // Access function
    if Lower then // If Negative use Symmetry to calculate
      Result := 1.0 - Result;
  end;
end;

function NormalDistQ(const Mean, StdDev, AVal: extended): single;
{ Returns the Probability of (X > AVal) for a Normal Distribution
  with given Mean and Standard Deviation.
  Standard Deviation must be > 0 or function will result in an
  exception.
  Accuracy: Absolute Error < 7.5e-8 }
begin
  Result := 1 - NormalDistP(Mean, StdDev, Aval);
end;

function NormalDistA(const Mean, StdDev, AVal, BVal: extended): single;
{ Returns the Probability of (AVal < X < BVal) for a Normal Distribution
  with given Mean and Standard Deviation.
  Standard Deviation must be > 0 or function will result in an
  exception.
  Accuracy: Absolute Error < 7.5e-8 }
begin
  if (AVal = BVal) then
    Result := 0
  else
  begin
    Result := NormalDistP(Mean, StdDev, BVal) - NormalDistP(Mean, StdDev, AVal);
    if BVal < AVal then
      Result := -1 * Result;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  i, j, numCount, ErrCode: integer;
  s: TListChartSource;
  realarray: array of double;
  devarray: array[1..100] of integer;
  mean_: double;
  stddev_, sigma: double;
  savszel: double;
  interval, minx, maxx, invpietc: double;
  StrList: TStringList;
  ValFloat, min, max: extended;

  function getnormp(i: integer): double;
  var
    x: double;
  begin
    x := (minx + interval / 2 + i * interval - mean_) / sigma; {normalize x}
    Result := invpietc * exp(-0.5 * x * x) / sigma;  {density value at x}
  end;

begin
  //s := ChartCumulNormDistrLineSeries1.ListSource;
  s := Chart1BarSeries1.ListSource;
  s.BeginUpdate;
  memo1.Clear;
  try
    s.Clear;
    // Add random test data as x values --> random values will
    // get sorted in ascending direction automatically.
    s.Sorted := False;
    StrList := TStringList.Create;
    StrList := readCSV(filename);
    memo1.Clear;
    //while strlist[2] and strlist [3] <> numeric increase row and check again               //this is a rogue row that cause a crash, debug!
    while (IsNumeric(StrList[2], True) = False) or (IsNumeric(StrList[3], True) = False) or (ROWCOUNTER = 21) do
    begin
      if rowdirection = 1 then
        NextBtnClick(Self.Button1)
      else
        PrevBtnClick(Self.Button1);
      StrList := readCSV(FileName);
    end;
    GrLabel.Caption := StrList[0];
    label3.Caption := StrList[1];
    label4.Caption := 'Limit HI: ' + strlist[2];
    label5.Caption := 'Limit LO: ' + strlist[3];
    label6.Caption := 'Row: ' + ROWCOUNTER.tostring;
    if (isnumeric(strlist[2], True)) and (isnumeric(strlist[3], True)) then
    begin
      Val(StrList[2], Valfloat, Errcode);
      min := ValFloat;
      Val(StrList[3], ValFloat, errcode);
      max := ValFloat;
    end;
    for i := 0 to 4 do
      StrList.Delete(i);
    numCount := 0;
    Strlist.Delete(1);
    StrList.Sort;
    for i := 0 to StrList.Count - 1 do
    begin
      if IsNumeric(StrList[i], True) then
      begin
        Val(StrList[i], ValFloat, ErrCode);
        s.add(ValFloat, 0);
        memo1.Lines.add(Valfloat.tostring);
        numcount := numcount + 1;
      end;
    end;
    Label1.Caption := numCount.Tostring + ' data';
    if numcount > 10 then
    begin
      SetLength(realarray, s.Count);
      s.Sorted := True;
      for i := 0 to s.Count - 1 do
      begin
        realarray[i] := s.Item[i]^.X;
      end;
      invPiEtc := 1.0 / sqrt(2 * Pi);
      mean_ := mean(realarray);
      stddev_ := stddev(realarray);
      //minx := MinValue(realarray);
      minx := min;
      //maxx := MaxValue(realarray);
      maxx := max;
      savszel := maxx - minx;
      interval := savszel / scaleSize;
      //SetLength(devarray,100);
      //nbrsamps := s.Count;
      sigma := stddev_;
      for j := 1 to scaleSize do
      begin
        devarray[j] := 0;
      end;
      for i := 0 to s.Count - 1 do
      begin
        for j := 1 to scaleSize do
        begin
          if realarray[i] < (minx + (j * interval)) then
          begin
            devarray[j] := devarray[j] + 1;
            break;
          end;
        end;
      end;
      s.Clear;
      s.Sorted := False;
      for i := 1 to scaleSize do
      begin
        s.Add(minx + (interval * i), double(devarray[i]));
      end;
    end;
    s.Sorted := True;
  finally
    s.EndUpdate;
  end;
  form1.Caption := 'Mean= ' + floattostr(mean_) + ' ,MinX= ' + floattostr(minx) + ' ,MaxX= ' + floattostr(maxx);
end;

procedure TForm1.NextBtnClick(Sender: TObject);
begin
  ROWCOUNTER := ROWCOUNTER + 1;
  SpinEdit2.Value := ROWCOUNTER;
  rowdirection := 1;
  FormShow(Self.Button1);
end;

procedure TForm1.PrevBtnClick(Sender: TObject);
begin
  ROWCOUNTER := ROWCOUNTER - 1;
  SpinEdit2.Value := ROWCOUNTER;
  rowdirection := 1;
  FormShow(Self.Button1);
end;

procedure TForm1.saveBtnClick(Sender: TObject);
begin
    if form1.SaveDialog1.Execute then
    begin
     form1.chart1.SaveToBitmapFile(form1.SaveDialog1.FileName);
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  FormShow(Self.Button1);
end;


procedure TForm1.FileOpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    FileName := OpenDialog1.FileName;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.SaveFileMenuItem1Click(Sender: TObject);
begin
  if form1.SaveDialog1.Execute then
  begin
    form1.ChartCumulNormDistr.SaveToBitmapFile(form1.SaveDialog1.FileName);
  end;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  scaleSize := SpinEdit1.Value;
end;

procedure TForm1.SpinEdit1EditingDone(Sender: TObject);
begin
  FormShow(Self.Button1);
end;

procedure TForm1.SpinEdit2Change(Sender: TObject);
begin
  ROWCOUNTER := SpinEdit2.Value;
end;

{procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
end;}
end.
