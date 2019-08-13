unit uCarico;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, DBCtrls, DBGrids,
  StdCtrls, MaskEdit, ComCtrls, sqldb;

type

  { TfrmCarico }

  TfrmCarico = class(TForm)
    cmdCanc: TButton;
    cmdSave: TButton;
    cbCaricaFarmaco: TDBLookupComboBox;
    Label4: TLabel;
    tQtaCar: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    tQtaScar: TEdit;
    txID: TDBText;
    dsOrig: TDataSource;
    procedure Button1Click(Sender: TObject);
    procedure cbCaricaFarmacoChange(Sender: TObject);
    procedure cbCaricaFarmacoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmdCancClick(Sender: TObject);
    procedure cbCaricaFarmacoClick(Sender: TObject);
    procedure cmdSaveClick(Sender: TObject);
    procedure dsOrigDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure tQtaCarKeyPress(Sender: TObject; var Key: char);
  private

  public

  end;

var
  frmCarico: TfrmCarico;

implementation

uses
    uDM1;

{$R *.lfm}

{ TfrmCarico }

procedure TfrmCarico.FormCreate(Sender: TObject);
begin
  DM1.MainTrns.Active:=True;
end;

procedure TfrmCarico.FormShow(Sender: TObject);
begin

  with DM1.SvcQry do
  begin
       Active:= False;
       SQL.Clear;
       SQL.Append('select * from items;');
       Active:= True;
  end;

  with cbCaricaFarmaco do
  begin
    if Items.Count > 0 then
       ItemIndex:=0;
    SetFocus;
  end;

end;

procedure TfrmCarico.Label2Click(Sender: TObject);
begin

end;


procedure TfrmCarico.tQtaCarKeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in [#8, #18, #45, #48, #49, #50, #51, #52, #53, #54, #55, #56, #57]) then
     Key:=#0;
end;

procedure TfrmCarico.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TfrmCarico.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin

  tQtaCar.Clear;
  if DM1.MainTrns.Active then
    DM1.MainTrns.Commit;
  with DM1.SvcQry do
  begin
    //ApplyUpdates(0);
    Active:= False;
    SQL.Clear;
  end;
   //DM1.MainQry.Refresh;

end;

procedure TfrmCarico.cbCaricaFarmacoClick(Sender: TObject);
begin
end;

procedure TfrmCarico.cmdCancClick(Sender: TObject);
begin

     frmCarico.Close;
end;

procedure TfrmCarico.Button1Click(Sender: TObject);
begin

end;

procedure TfrmCarico.cbCaricaFarmacoChange(Sender: TObject);
begin
  cmdSave.Enabled:= True;
end;

procedure TfrmCarico.cbCaricaFarmacoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 27 then
     cmdCancClick(cbCaricaFarmaco) ;
end;

procedure TfrmCarico.cmdSaveClick(Sender: TObject);
begin

  try
     if DM1.C1.Transaction.Active then
       with DM1.C1 do
       begin
         //DM1.MainTrns.Active:=True;
         if tQtaScar.Text = '' then
           ExecuteDirect(Format('update farmaci set utile = utile + %s where ID = %s',
             [inttostr(strtoint(tQtaCar.Text) * DM1.SvcQry.FieldValues['qta_conf'])
             , txID.Caption]))
         else
           //ExecuteDirect(Format('update farmaci set utile = utile - %s, ultimo_agg = '
           //  + '%s where ID = %s',
           //  [tQtaScar.Text, QuotedStr(FormatDateTime('yyyy-mm-dd', now)), txID.Caption]));
           ExecuteDirect(Format('update farmaci set utile = utile - %s where ID = %s',
             [tQtaScar.Text, txID.Caption]));
         //DM1.MainTrns.Commit;
         //DM1.C1.Transaction.Commit;
       end
     else
         ShowMessage('Dataset di sola lettura!');
   except
     on E: EDatabaseError do
     begin
       DM1.MainTrns.RollbackRetaining;
       //DM1.C1.Transaction.Rollback;
       ShowMessage('Errore aggiornando quantità: ' + E.Message);
     end;
  end;
  cmdSave.Enabled:= False;
  cbCaricaFarmaco.SetFocus;

end;

procedure TfrmCarico.dsOrigDataChange(Sender: TObject; Field: TField);
begin

end;

end.

