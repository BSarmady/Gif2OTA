program Gif2OTA;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'OTA Reader V1.0';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
