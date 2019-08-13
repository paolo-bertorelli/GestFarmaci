program GestFarmaci;

{$mode objfpc}{$H+}

{
select julianday('2019-05-13')-julianday('2018-05-10');
}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Dialogs, uMain, uDM1, uCarico, uMainGrid,
  just1fix in
    'c:\lazarus\fpc\3.0.4\source\Import\just1fix.pas',
  myUtils in
    'c:\lazarus\fpc\3.0.4\source\Import\myutils.pas';

{$R *.res}

begin
  if not AppIsAlreadyRunning('GestFarmaci') then
  begin
    RequireDerivedFormResource:=True;
    Application.Scaled:=True;
    Application.Initialize;
    Application.CreateForm(TDM1, DM1);
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  end
  else
    ShowMessage('DB occupato, update rinviato.');

end.

