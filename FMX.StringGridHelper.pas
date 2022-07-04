unit FMX.StringGridHelper;

interface
uses System.Classes,System.Types, FMX.Grid, FMX.PlatForm;

type
  TStringGrid2Clipboard = class helper for TStringGrid
  private
    function AddStringSeparator(const s : String; const stringseparator : Char) : String;
  public
    function FullGrid2Clipboard(const addheader : boolean = true; const stringseparator : char =#0) : boolean;
    function SelectColumns2Clipboard(var Cols : TArray<integer>; const addheader : boolean = false; const stringseparator : char =#0) : boolean;
    function SelectRows2Clipboard(var Rows : TArray<integer>; const addheader : boolean = false; const stringseparator : char =#0) : boolean;
    function SelectColRows2Clipboard(var Cols,Rows : TArray<integer>; const addheader : boolean = false; const stringseparator : char = #0) : boolean;

    function CellRange2ClipBoard(var Selected : TRect ; const addheader : boolean = false; const stringseparator : char =#0) : boolean;
  end;


implementation

{ TStringGrid2Clipboard }

 /// <summary> Fonction privée permettant d'encadre la chaine par le séparateur défini
 /// </summary>
 /// <param name="s">La chaine à encadrer
 /// </param>
 /// <param name="StringSeparator">Le caractère a utiliser
 /// </param>
 /// <remarks>
 /// Si le caractère de séparation est null retourne la valeur initiale
 /// </remarks>
 /// <returns>La chaine avec sépérateur en début et fin de chaine
 /// </returns>
function TStringGrid2Clipboard.AddStringSeparator(const s: String;
  const stringseparator: Char): String;
begin
result:=s;
if StringSeparator=#0 then exit;
result:=StringSeparator+s+StringSeparator;
end;


 /// <summary> Mets l'ensemble des valeurs des cellules indiquées dans le presse papier
 /// </summary>
 /// <param name="Selected">Le groupe de cellules voulu;
 /// <see cref="TRect" />
 /// exemple : TRect.Create(0,10,4,1,5) les 11 premières cellules, des lignes 1 à 5
 /// attention le StringGrid est en base 0
 /// </param>
 /// <param name="AddHeader">Ajout des entêtes de colonnes (false par défaut)
 /// </param>
 /// </param>
 /// <param name="StringSeparator">Le caractère a utiliser comme séparteur de chaine;
 /// pas de séparateur (#0) par défaut
 /// </param>
 /// <remarks>
 /// retourne false si le presse papier n'est pas utilisable
 /// </remarks>
 /// <returns>True à la fin de l'opération
 /// </returns>
function TStringGrid2Clipboard.CellRange2ClipBoard(var Selected: TRect;
  const addheader: boolean; const stringseparator: char): boolean;
var Clip : IFMXClipboardService;
    ct : String;
    sl: TStringList;
    r,c : word;
    n : word;
begin
result:=false;
if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService,Clip) then
 begin
  sl := TStringList.Create;
  try
   if addheader then
     begin
       ct:='';
       n:=0;
       for c:=Selected.Left to Selected.Right do
        begin
            if n>0 then ct:=ct+#9;
            inc(n);
            ct:=ct+AddStringSeparator(Self.Columns[c].Header,StringSeparator);
        end;
        Sl.Add(ct);
     end;
   for r:=Selected.Top to Selected.Bottom do
    begin
      ct:='';
      n:=0;
      for c:=Selected.Left to Selected.Right do
      begin
         if n>0 then ct:=ct+#9;
         inc(n);
         ct:=ct+AddStringSeparator(Self.Cells[c,r],StringSeparator);
      end;
       Sl.Add(ct);
   end;
   Clip.SetClipboard(sl.Text);
   result:=true;
  finally
    SL.Free;
  end;
 end;
end;

 /// <summary> Mets l'ensemble de la grille dans le presse papier
 /// </summary>
 /// </param>
 /// <param name="AddHeader">Ajout des entêtes de colonnes (True par défaut)
 /// </param>
 /// </param>
 /// <param name="StringSeparator">Le caractère à utiliser comme séparateur de chaine;
 /// pas de séparateur (#0) par défaut
 /// </param>
 /// <remarks>
 /// retourne false si le presse papier n'est pas utilisable
 /// </remarks>
 /// <returns>True à la fin de l'opération
 /// </returns>
function TStringGrid2Clipboard.FullGrid2Clipboard(const addheader: boolean;
  const stringseparator: char): boolean;
var Clip : IFMXClipboardService;
    ct : String;
    sl: TStringList;
    r,c : word;
begin
result:=false;
if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService,Clip) then
 begin
  sl := TStringList.Create;
  try
   if addheader then
     begin
       ct:='';
       for c:=0 to self.ColumnCount-1 do
        begin
          if c>0 then ct:=ct+#9;
          ct:=ct+AddStringSeparator(Self.Columns[c].Header,StringSeparator);
        end;
        Sl.Add(ct);
     end;
   for r := 0 to Self.RowCount-1 do
    begin
      ct:='';
      for c := 0 to Self.ColumnCount-1 do
      begin
       if c>0 then ct:=ct+#9;
       ct:=ct+AddStringSeparator(Self.Cells[c,r],StringSeparator);
      end;
       Sl.Add(ct);
   end;
   Clip.SetClipboard(sl.Text);
   result:=true;
  finally
    SL.Free;
  end;
 end;
end;

 /// <summary> Mets la sélection des valeurs dans le presse papier
 /// </summary>
 /// <param name="Cols">Les colonnes souhaitées;
 /// <see cref="TArray" />
 /// exemple : TArray.Create([0,1,4,3,5])
 /// Attention les cellules seront prises dans l'ordre de création
 /// </param>
 /// <param name="Rows">Les lignes souhaitées;
 /// <see cref="TArray" />
 /// exemple : TArray.Create([1,4,7,5])
 /// Attention les lignes seront prises dans l'ordre indiquée
 /// </param> /// <param name="AddHeader">Ajout des entêtes de colonnes (false par défaut)
 /// </param>
 /// </param>
 /// <param name="StringSeparator">Le caractère à utiliser comme séparateur de chaine;
 /// pas de séparateur (#0) par défaut
 /// </param>
 /// <remarks>
 /// retourne false si le presse papier n'est pas utilisable
 /// </remarks>
 /// <returns>True à la fin de l'opération
 /// </returns>
function TStringGrid2Clipboard.SelectColRows2Clipboard(var Cols,
  Rows: TArray<integer>; const addheader: boolean;
  const stringseparator: char): boolean;
var Clip : IFMXClipboardService;
    ct : String;
    sl: TStringList;
    r,c: word;
    n : integer;
begin
result:=false;
if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService,Clip) then
 begin
  sl := TStringList.Create;
  try
    if addheader then
     begin
       ct:='';
       n:=0;
       for c in Cols do
        begin
            if n>0 then ct:=ct+#9;
            inc(n);
            ct:=ct+AddStringSeparator(Self.Columns[c].Header,StringSeparator);
        end;
        Sl.Add(ct);
     end;
   for r in rows do
    begin
      ct:='';
      n:=0;
      for c in Cols do
      begin
         if n>0 then ct:=ct+#9;
         inc(n);
         ct:=ct+AddStringSeparator(Self.Cells[c,r],StringSeparator);
      end;
       Sl.Add(ct);
   end;
   Clip.SetClipboard(sl.Text);
   result:=true;
  finally
    SL.Free;
  end;
 end;
end;

 /// <summary> Mets la sélection des valeurs d'un ensemble de colonnes dans le presse papier
 /// </summary>
 /// <param name="Cols">Les colonnes souhaitées;
 /// <see cref="TArray" />
 /// exemple : TArray.Create([0,1,4,3,5])
 /// Attention les cellules seront prises dans l'ordre de création
 /// </param>
 /// </param> /// <param name="AddHeader">Ajout des entêtes de colonnes (false par défaut)
 /// </param>
 /// </param>
 /// <param name="StringSeparator">Le caractère à utiliser comme séparateur de chaine;
 /// pas de séparateur (#0) par défaut
 /// </param>
 /// <remarks>
 /// retourne false si le presse papier n'est pas utilisable
 /// </remarks>
 /// <returns>True à la fin de l'opération
 /// </returns>
function TStringGrid2Clipboard.SelectColumns2Clipboard(
  var Cols: TArray<integer>; const addheader: boolean;
  const stringseparator: char): boolean;
var Clip : IFMXClipboardService;
    ct : String;
    sl: TStringList;
    r,c: word;
    n : integer;
begin
result:=false;
if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService,Clip) then
 begin
  sl := TStringList.Create;
  try
    if addheader then
     begin
       ct:='';
       n:=0;
       for c in Cols do
        begin
            if n>0 then ct:=ct+#9;
            inc(n);
            ct:=ct+AddStringSeparator(Self.Columns[c].Header,StringSeparator);
        end;
        Sl.Add(ct);
     end;
    for r := 0 to Self.RowCount-1 do
    begin
      ct:='';
      n:=0;
      for c in Cols do
      begin
         if n>0 then ct:=ct+#9;
         inc(n);
         ct:=ct+AddStringSeparator(Self.Cells[c,r],StringSeparator);
      end;
       Sl.Add(ct);
   end;
   Clip.SetClipboard(sl.Text);
   result:=true;
  finally
    SL.Free;
  end;
 end;
end;

 /// <summary> Mets la sélection des valeurs des lignes indiquées dans le presse papier
 /// </summary>
 /// <param name="Rows">Les lignes souhaitées;
 /// <see cref="TArray" />
 /// exemple : TArray.Create([1,4,7,5])
 /// Attention les lignes seront prises dans l'ordre indiquée
 /// </param> /// <param name="AddHeader">Ajout des entêtes de colonnes (false par défaut)
 /// </param>
 /// </param>
 /// <param name="StringSeparator">Le caractère à utiliser comme séparateur de chaine;
 /// pas de séparateur (#0) par défaut
 /// </param>
 /// <remarks>
 /// retourne false si le presse papier n'est pas utilisable
 /// </remarks>
 /// <returns>True à la fin de l'opération
 /// </returns>
function TStringGrid2Clipboard.SelectRows2Clipboard(var Rows: TArray<integer>;
  const addheader: boolean; const stringseparator: char): boolean;
var Clip : IFMXClipboardService;
    ct : String;
    sl: TStringList;
    r,c: word;
begin
result:=false;
if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService,Clip) then
 begin
  sl := TStringList.Create;
  try
    if addheader then
     begin
       ct:='';
      for c:=0 to self.ColumnCount-1 do
        begin
            if c>0 then ct:=ct+#9;
            ct:=ct+AddStringSeparator(Self.Columns[c].Header,StringSeparator);
        end;
        Sl.Add(ct);
     end;
    for r in rows do
    begin
      ct:='';
      for c:=0 to self.ColumnCount-1 do
      begin
         if c>0 then ct:=ct+#9;
         ct:=ct+AddStringSeparator(Self.Cells[c,r],StringSeparator);
      end;
       Sl.Add(ct);
   end;
   Clip.SetClipboard(sl.Text);
   result:=true;
  finally
    SL.Free;
  end;
 end;
end;

end.
