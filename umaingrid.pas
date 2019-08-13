unit uMainGrid;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, DBGrids, DBCtrls,
  StdCtrls;

type

  { TfrmDatasheet }

  TfrmDatasheet = class(TForm)
    cmdCanc: TButton;
    dsMainGrid: TDataSource;
    dgMainGrid: TDBGrid;
    DBNavigator1: TDBNavigator;
    procedure Button1Click(Sender: TObject);
    procedure cmdCancClick(Sender: TObject);
    procedure dgMainGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmDatasheet: TfrmDatasheet;

implementation

{$R *.lfm}

{ TfrmDatasheet }

uses
    udM1;

procedure TfrmDatasheet.FormCreate(Sender: TObject);
begin

end;

procedure TfrmDatasheet.cmdCancClick(Sender: TObject);
begin

   try
     DM1.MainQry.ApplyUpdates(0);
     DM1.C1.Transaction.CommitRetaining;
   except
     on E: EDatabaseError do
     begin
       DM1.MainTrns.RollbackRetaining;
       //DM1.C1.Transaction.Rollback;
       ShowMessage('Errore aggiornando foglio dati: ' + E.Message);
     end;
  end;
  frmDatasheet.Close;

end;

procedure TfrmDatasheet.Button1Click(Sender: TObject);
var
   i: integer;
   s: string;
begin
  for i:= 0 to dgMainGrid.Columns.Count -1 do
    s:= s + IntToStr(i) + ': ' + inttostr(dgMainGrid.Columns[i].Width) + #10;
  ShowMessage(s);

end;

procedure TfrmDatasheet.dgMainGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if key = 27 then
     cmdCancClick(dgMainGrid) ;

end;

procedure TfrmDatasheet.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin

{  if (Sender is TControl) and (TControl(Sender).Tag = 1) then
    if MessageDlg('Farmaci', 'Vuoi salvare le variazioni?', mtConfirmation, mbOKCancel, '') = mrOK then
      cmdCancClick(nil);
  CanClose:= True;
}

end;

procedure TfrmDatasheet.FormShow(Sender: TObject);
begin

    DM1.MainQry.Active:= True;
    with dgMainGrid.Columns do
    begin
      Items[0].Visible:=false;
      Items[1].Width:= 74;
      Items[2].Width:= 156;
      Items[3].Width:= 100;
      Items[4].Width:= 55;
      Items[5].Width:= 60;
      Items[6].Width:= 37;
      Items[7].Width:= 69;
      Items[8].Width:= 90;
      Items[9].Width:= 70;
      Items[10].Width:= 90;
    end;
end;
end.

