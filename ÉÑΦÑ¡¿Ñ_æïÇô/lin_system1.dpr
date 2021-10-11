program lin_system1;

uses
  Forms,
  linear_system1 in 'linear_system1.pas' {frm_lin_system},
  system_surface in 'system_surface.pas' {Solutions: TFrame},
  lin_system1_about in 'lin_system1_about.pas' {frm_about};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Système Linéaire';
  Application.CreateForm(Tfrm_lin_system, frm_lin_system);
  Application.CreateForm(Tfrm_about, frm_about);
  Application.Run;
end.
