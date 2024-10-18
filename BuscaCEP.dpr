program BuscaCEP;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {frmBuscaCEP},
  uCEP in 'uCEP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmBuscaCEP, frmBuscaCEP);
  Application.Run;
end.
