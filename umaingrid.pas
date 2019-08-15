unit uMainGrid;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, DBGrids, DBCtrls,
  StdCtrls, ExtCtrls;

type

  { TfrmDatasheet }

  TfrmDatasheet = class(TForm)
    btnEdit: TButton;
    btnConf: TButton;
    cmdCanc: TButton;
    dsMainGrid: TDataSource;
    dgMainGrid: TDBGrid;
    procedure btnConfClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cmdCancClick(Sender: TObject);
    procedure dgMainGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure CommitDB(Sender: TObject);

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

  CommitDB(cmdCanc);
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

procedure TfrmDatasheet.btnEditClick(Sender: TObject);
begin

  if dgMainGrid.ReadOnly then
  begin
    with DM1.MainQry do
    begin
      Active:= False;
      SQL.Clear;
      SQL.Append('select *');
      SQL.Append('from farmaci');
      SQL.Append('order by Etichetta;');
      Active:= True;
    end;
    with dgMainGrid.Columns do
    begin
      Items[0].Visible:= False;
      Items[1].Width:= 74;
      Items[2].Width:= 156;
      Items[3].Width:= 100;
      Items[4].Width:= 55;
      Items[5].Width:= 60;
      Items[6].Width:= 37;
      Items[7].Width:= 69;
      Items[8].Width:= 90;
      //Items[9].Width:= 70;
      //Items[10].Width:= 90;
    end;
    dgMainGrid.ReadOnly:=False;
  end;

end;

procedure TfrmDatasheet.btnConfClick(Sender: TObject);
begin

  if (not dgMainGrid.ReadOnly) then
  begin
    CommitDB(Sender);
    with DM1.MainQry do
    begin
      Active:= False;
      SQL.Clear;
      SQL.Append('select *');
      SQL.Append('from main');
      SQL.Append('order by Etichetta;');
      Active:= True;
    end;
    with dgMainGrid.Columns do
    begin
      Items[0].Visible:= False;
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
    dgMainGrid.ReadOnly:=True;
  end;

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

  btnConfClick(frmDatasheet);

end;

procedure TfrmDatasheet.CommitDB(Sender: TObject);
begin

  if (Sender is TControl) and (TControl(Sender).tag in [2, 3]) then //cmdCanc, cmdConf
  begin
    try
      DM1.MainQry.ApplyUpdates(0);
      DM1.C1.Transaction.CommitRetaining;
    except
      on E: EDatabaseError do
      begin
        DM1.MainTrns.RollbackRetaining;
        DM1.C1.Transaction.Rollback;
        ShowMessage('Errore aggiornando foglio dati: ' + E.Message);
      end;
    end;
  end;

end;

end.

