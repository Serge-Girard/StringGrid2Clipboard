unit ExportStringGridMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, Data.Bind.GenData, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.StdCtrls,
  FMX.Edit, FMX.EditBox, FMX.NumberBox, Data.Bind.Components, Data.Bind.Grid,
  Data.Bind.ObjectScope, FMX.TabControl, FMX.Layouts, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Grid, FMX.StringGridHelper, FMX.Memo,
  System.Generics.Collections, FMX.Objects;

type

  TFormTest = class(TForm)
    StringGrid1: TStringGrid;
    Layout1: TLayout;
    TabControl1: TTabControl;
    StringGrid: TTabItem;
    Memo: TTabItem;
    PrototypeBindSource1: TPrototypeBindSource;
    BindingsList1: TBindingsList;
    LinkGridToDataSourcePrototypeBindSource1: TLinkGridToDataSource;
    btnAll: TButton;
    btnSelCols: TButton;
    btnCellRange: TButton;
    btnSelLignes: TButton;
    btnCells: TButton;
    Memo1: TMemo;
    doAddHeader: TCheckBox;
    CharSeparateur: TEdit;
    ClearEditButton1: TClearEditButton;
    Label2: TLabel;
    rdbRowselected: TRadioButton;
    rdbSelbyCell: TRadioButton;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    btnClear: TButton;
    lblRect: TLabel;
    procedure btnAllClick(Sender: TObject);
    procedure StringGrid1HeaderClick(Column: TColumn);
    procedure StringGrid1DrawColumnHeader(Sender: TObject;
      const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StringGrid1DrawColumnCell(Sender: TObject; const Canvas: TCanvas;
      const Column: TColumn; const Bounds: TRectF; const Row: Integer;
      const Value: TValue; const State: TGridDrawStates);
    procedure btnSelColsClick(Sender: TObject);
    procedure btnSelLignesClick(Sender: TObject);
    procedure btnCellRangeClick(Sender: TObject);
    procedure StringGrid1CellClick(const Column: TColumn; const Row: Integer);
    procedure btnCellsClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure rdbRowselectedChange(Sender: TObject);
  private
    { Déclarations privées }
    Cols : TList<Integer>;
    Rows : TList<Integer>;
    Selected : TRect;
    procedure changeSelected;
  public
    { Déclarations publiques }
  end;

var
  FormTest: TFormTest;

implementation

{$R *.fmx}

// tests des fonctions du helper
procedure TFormTest.btnAllClick(Sender: TObject);
var C : char;
begin
  memo1.Lines.Clear;
  If CharSeparateur.Text.IsEmpty Then c:=#0 else c:=CharSeparateur.Text[1];
  if StringGrid1.FullGrid2Clipboard(DoAddHeader.IsChecked,c) then tabcontrol1.Next();
end;

procedure TFormTest.btnCellRangeClick(Sender: TObject);
var C : char;
    A,B : TArray<Integer>;
begin
  memo1.Lines.Clear;
  If CharSeparateur.Text.IsEmpty Then c:=#0 else c:=CharSeparateur.Text[1];
  A:=Cols.ToArray;
  B:=Rows.ToArray;
  if StringGrid1.SelectColRows2Clipboard(A,B,doAddHeader.IsChecked,c)
     then tabcontrol1.Next();
end;

procedure TFormTest.btnCellsClick(Sender: TObject);
var C : char;
begin
  memo1.Lines.Clear;
  if CharSeparateur.Text.IsEmpty Then c:=#0 else c:=CharSeparateur.Text[1];
  if StringGrid1.CellRange2ClipBoard(Selected,doAddHeader.IsChecked,c)
      then tabcontrol1.Next();
end;

procedure TFormTest.btnSelColsClick(Sender: TObject);
var C : char;
    A : TArray<Integer>;
begin
  memo1.Lines.Clear;
  If CharSeparateur.Text.IsEmpty Then c:=#0 else c:=CharSeparateur.Text[1];
  A:=Cols.ToArray;
  if StringGrid1.SelectColumns2Clipboard(A,doAddHeader.IsChecked,c)
     then tabcontrol1.Next();
end;

procedure TFormTest.btnSelLignesClick(Sender: TObject);
var C : char;
    A : TArray<Integer>;
begin
  memo1.Lines.Clear;
  If CharSeparateur.Text.IsEmpty Then c:=#0 else c:=CharSeparateur.Text[1];
  A:=Rows.ToArray;
  if StringGrid1.SelectRows2Clipboard(A,doAddHeader.IsChecked,c)
     then tabcontrol1.Next();
end;



// Interface utilisateur
procedure TFormTest.changeSelected;
begin
lblRect.Text:=Format('TRect(%d,%d,%d,%d)',
                     [Selected.Left,Selected.Right,
                      Selected.Top,selected.Bottom]);
end;

procedure TFormTest.btnClearClick(Sender: TObject);
begin
Cols.Clear;
Rows.Clear;
Selected:=TRect.Create(-1,-1,-1,-1);
changeSelected;
StringGrid1.Repaint;
end;

procedure TFormTest.FormCreate(Sender: TObject);
begin
    Cols := TList<Integer>.Create;
    Rows := TList<Integer>.Create;
    Selected:=TRect.Create(-1,-1,-1,-1);
end;

procedure TFormTest.FormDestroy(Sender: TObject);
begin
FreeAndNil(Cols);
FreeAndNil(Rows);
end;

procedure TFormTest.rdbRowselectedChange(Sender: TObject);
begin
btnClearClick(Sender);
lblRect.Visible:=rdbSelbyCell.IsChecked;
end;

procedure TFormTest.StringGrid1CellClick(const Column: TColumn;
  const Row: Integer);
begin
if rdbRowselected.IsChecked then
 begin
   if Rows.Contains(Row)
     then Rows.RemoveItem(Row,TDirection.FromBeginning)
     else Rows.Add(Row);
 end
else begin
   if (Column.Index>Selected.Left)
      then begin
         if Selected.left=-1 then Selected.left:=Column.Index
                             else Selected.Right:=Column.Index;
         if Selected.Right=-1 then Selected.Right:=Selected.Left;
      end;
  if (Row>Selected.Top)
     then begin
       if Selected.Top=-1 then Selected.Top:=Row
                          else Selected.Bottom:=Row;
       if Selected.Bottom=-1 then Selected.Bottom:=Selected.Top;
      end;
  if (Column.Index<Selected.Left)
       then begin
         Selected.Left:=-1;
         Selected.Right:=-1;
       end;
  if (Row<Selected.Top)
     then begin
       Selected.Top:=-1;
       Selected.Bottom:=-1;
      end;
end;
ChangeSelected;
StringGrid1.Repaint
end;

procedure TFormTest.StringGrid1DrawColumnCell(Sender: TObject;
  const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF;
  const Row: Integer; const Value: TValue; const State: TGridDrawStates);
var
  aRowColor: TBrush;
  aNewRectF: TRectF;
  aopacity : single;
begin
  aRowColor := TBrush.Create(TBrushKind.Solid, TAlphaColors.Alpha);
  aOpacity:=1;
  aRowColor.Color := TAlphaColors.white;
  if  rdbRowselected.IsChecked
       AND (Cols.Contains(Column.Index) OR Rows.Contains(Row))
    then  begin
          aRowColor.Color := TAlphaColors.Blue;
          if  Rows.Contains(Row) AND Cols.Contains(Column.Index)
           then aOpacity:=0.8
           else aOpacity:=0.5;
    end;
  if rdbSelbyCell.isChecked
   AND (Column.Index>=Selected.Left) AND (Column.Index<=Selected.Right)
   AND (Row>=Selected.Top) AND (Row<=Selected.Bottom)
   then begin
       aRowColor.Color := TAlphaColors.Blue;
       aOpacity:=0.8
    end;


  aNewRectF := Bounds;
  aNewRectF.Inflate(3, 3);
  Canvas.FillRect(aNewRectF, 0, 0, [], aOpacity, aRowColor);
  Column.DefaultDrawCell(Canvas, Bounds, Row, Value, State);

  aRowColor.free;
end;

procedure TFormTest.StringGrid1DrawColumnHeader(Sender: TObject;
  const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF);
var
  aRowColor: TBrush;
begin
  aRowColor := TBrush.Create(TBrushKind.Solid, TAlphaColors.Alpha);

  if Cols.Contains(Column.Index)
    then  aRowColor.Color := TAlphaColors.AliceBlue
    else  aRowColor.Color := TAlphaColors.white;

  Canvas.FillRect(Bounds, 0, 0, [], 1, aRowColor);
  Column.DefaultDrawCell(Canvas, Bounds, 0, Column.Header,[]);

  StringGrid1.InvalidateRect(StringGrid1.CellRect(Column.Index,0));
end;

procedure TFormTest.StringGrid1HeaderClick(Column: TColumn);
begin
if Cols.IndexOf(Column.Index)>-1
  then cols.RemoveItem(Column.Index,TDirection.FromBeginning)
  else Cols.Add(Column.Index);
StringGrid1.Repaint;
end;

end.
