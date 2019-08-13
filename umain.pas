unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  ExtCtrls, Windows, LCLIntf, myUtils in 'c:\lazarus\fpc\3.0.4\source\Import\myutils.pas';

type

  { TfrmMain }

  TfrmMain = class(TForm)
    Button1: TButton;
    cmdUpdate: TButton;
    cmdCarico: TButton;
    cmdDatasheet: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure cmdUpdateClick(Sender: TObject);
    procedure cmdDatasheetClick(Sender: TObject);
    procedure cmdCaricoClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  frmMain: TfrmMain;

implementation

uses
    uDM1, uCarico, uMainGrid;

{$R *.lfm}

{ TfrmMain }
function OpenFileDoc(Doc: String): Boolean;
var
  ws: WideString;
begin
  Result := False;
  if Doc = '' then Exit;
  ws := UTF8Decode(doc);
  Result := ShellExecuteW(0, 'open', PWideChar(ws), nil, nil, SW_SHOWNORMAL) > 32;
end;

procedure TfrmMain.cmdCaricoClick(Sender: TObject);
begin

  dm1.C1.Transaction.CommitRetaining;
  //with DM1.MainQry do
  //begin
  //     Active:= False;
  //     sql.Text:= 'select * from items;';
  //end;

  frmCarico:= TfrmCarico.Create(self);
  frmCarico.ShowModal;

end;

procedure TfrmMain.FormClick(Sender: TObject);
begin

end;

procedure TfrmMain.cmdDatasheetClick(Sender: TObject);
begin

  dm1.C1.Transaction.CommitRetaining;
  frmDatasheet:= TfrmDatasheet.Create(self);
  frmDatasheet.ShowModal;




end;

procedure TfrmMain.cmdUpdateClick(Sender: TObject);
begin
  with dm1 do
  begin
    MainTrns.Active:= True;
    c1.ExecuteDirect('update farmaci set utile = utile - (julianday(' +
      QuotedStr(FormatDateTime('yyyy-mm-dd', now)) + ') - julianday(ultimo_agg))' +
      ' * consumo, ultimo_agg = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', now)) +
      ' where ifnull(consumo, 0) <> 0;');
    MainTrns.Commit;
  end;

  //OpenDocument(AppPath + 'richiesta.txt' );
  OpenFileDoc(AppPath + 'richiesta.txt' );



{  with dm1.SvcQry do
  begin
    Active:= False;
    SQL.Clear;
    sql.Append('select id, etichetta, utile, julianday(ultimo_agg), julianday(' +
      QuotedStr(FormatDateTime('yyyy-mm-dd', now)) + '), utile - (julianday(' +
      QuotedStr(FormatDateTime('yyyy-mm-dd', now)) + ') - julianday(ultimo_agg)) * consumo as residuo');
    SQL.Append('from farmaci where consumo is not null;');
    Active:=True;
  end;
  DBGrid1.Columns[1].Width:= 50;
  DBGrid1.Columns[2].Width:= 50;
  DBGrid1.Columns[3].Width:= 50;
  DBGrid1.Columns[4].Width:= 50;
  DBGrid1.Columns[5].Width:= 50;
}

end;

procedure TfrmMain.Button1Click(Sender: TObject);

begin

//OpenDocument(AppPath + 'richiesta.txt' );
//OpenFileDoc(AppPath + 'richiesta.txt' );

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
     if FindCmdLineSwitch('u') then
     begin
        Application.ShowMainForm:= False;
        Beep(1000, 400);
        cmdUpdateClick(self);
        Timer1.Enabled:= True;
     end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin

end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  frmMain.Close;
end;

end.

