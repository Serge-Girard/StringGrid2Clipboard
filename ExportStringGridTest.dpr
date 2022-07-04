program ExportStringGridTest;

uses
  System.StartUpCopy,
  FMX.Forms,
  ExportStringGridMain in 'ExportStringGridMain.pas' {FormTest},
  FMX.StringGridHelper in 'FMX.StringGridHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormTest, FormTest);
  Application.Run;
end.
