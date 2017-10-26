object Form1: TForm1
  Left = 495
  Height = 601
  Top = 250
  Width = 975
  Caption = 'Form1'
  ClientHeight = 601
  ClientWidth = 975
  OnCreate = FormCreate
  LCLVersion = '6.1'
  object Chart1: TChart
    Left = 0
    Height = 496
    Top = 104
    Width = 840
    AntialiasingMode = amOn
    AxisList = <    
      item
        Intervals.Count = 15
        Intervals.MaxLength = 100
        MarginsForMarks = False
        Minors = <>
        Title.LabelFont.Orientation = 900
      end    
      item
        Alignment = calBottom
        AtDataOnly = True
        Minors = <>
      end>
    BackColor = clWhite
    Foot.Brush.Color = clBtnFace
    Foot.Font.Color = clBlue
    Title.Brush.Color = clBtnFace
    Title.Font.Color = clBlue
    Title.Text.Strings = (
      'TAChart'
    )
    object ChartCumulNormDistrLineSeries1: TLineSeries
      Marks.Clipped = False
      LinePen.Color = clBlue
      LinePen.JoinStyle = pjsBevel
      LinePen.Width = 3
    end
    object Chart1BarSeries1: TBarSeries
      BarBrush.Color = clRed
    end
  end
  object Memo1: TMemo
    Left = 840
    Height = 592
    Top = 8
    Width = 128
    Lines.Strings = (
      'Data Set'
    )
    ScrollBars = ssAutoBoth
    TabOrder = 1
  end
  object Button1: TButton
    Left = 144
    Height = 23
    Top = 10
    Width = 83
    Caption = 'Start'
    OnClick = Button1Click
    TabOrder = 2
  end
  object Label1: TLabel
    Left = 760
    Height = 21
    Top = 12
    Width = 66
    Alignment = taRightJustify
    Caption = 'Data Pool'
    Font.Height = -16
    ParentColor = False
    ParentFont = False
  end
  object SpinEdit1: TSpinEdit
    Left = 776
    Height = 23
    Top = 56
    Width = 50
    MinValue = 5
    OnChange = SpinEdit1Change
    OnEditingDone = SpinEdit1EditingDone
    TabOrder = 3
    Value = 100
  end
  object GrLabel: TLabel
    Left = 32
    Height = 28
    Top = 48
    Width = 113
    Caption = 'Group Name'
    Font.Height = -20
    ParentColor = False
    ParentFont = False
  end
  object NextBtn: TButton
    Left = 352
    Height = 25
    Top = 8
    Width = 75
    Caption = 'NextBtn'
    OnClick = NextBtnClick
    TabOrder = 4
  end
  object PrevBtn: TButton
    Left = 280
    Height = 25
    Top = 8
    Width = 75
    Caption = 'PrevBtn'
    OnClick = PrevBtnClick
    TabOrder = 5
  end
  object Label3: TLabel
    Left = 32
    Height = 23
    Top = 77
    Width = 80
    Caption = 'Test Name'
    Font.Height = -17
    ParentColor = False
    ParentFont = False
  end
  object Label4: TLabel
    Left = 479
    Height = 28
    Top = 48
    Width = 34
    Caption = 'Min'
    Font.Height = -20
    ParentColor = False
    ParentFont = False
  end
  object Label5: TLabel
    Left = 480
    Height = 28
    Top = 72
    Width = 37
    Caption = 'Max'
    Font.Height = -20
    ParentColor = False
    ParentFont = False
  end
  object Label6: TLabel
    Left = 689
    Height = 15
    Top = 78
    Width = 51
    Caption = 'Row num'
    ParentColor = False
  end
  object SpinEdit2: TSpinEdit
    Left = 688
    Height = 23
    Top = 56
    Width = 50
    MaxValue = 500
    OnChange = SpinEdit2Change
    TabOrder = 6
    Value = 4
  end
  object FileOpen: TButton
    Left = 32
    Height = 23
    Top = 10
    Width = 75
    Caption = 'Open'
    OnClick = FileOpenClick
    TabOrder = 7
  end
  object Label2: TLabel
    Left = 776
    Height = 15
    Top = 78
    Width = 47
    Caption = 'Divisions'
    ParentColor = False
  end
  object saveBtn: TButton
    Left = 504
    Height = 25
    Top = 10
    Width = 75
    Caption = 'Save'
    OnClick = saveBtnClick
    TabOrder = 8
  end
  object OpenDialog1: TOpenDialog
    Filter = 'CSV files|*.csv'
    InitialDir = 'C:\Users\l-gpeltzer\Downloads\reports\ResultFiles'
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    Left = 180
    Top = 48
  end
end
