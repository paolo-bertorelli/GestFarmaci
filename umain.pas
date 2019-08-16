unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  ExtCtrls, Windows, LCLIntf, RichMemo, myUtils, variants;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    Button1: TButton;
    cmdUpdate: TButton;
    cmdCarico: TButton;
    cmdDatasheet: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Notebook1: TNotebook;
    rmOrdine: TRichMemo;
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
var
  strm: TFileStream;
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

  with dm1.SvcQry do
  begin
    Active:= False;
    SQL.Clear;
    SQL.Append('Select etichetta, princ_attivo, data_esaurim');
    SQL.Append('from ordinare');
    SQL.Append('order by etichetta;');
    Active:= True;
    while not EOF do
    begin
       rmOrdine.Lines.Append(Format('%s - %s - %s', [VarToStr(FieldValues['etichetta']),
         VarToStr(FieldValues['princ_attivo']), VarToStrDef(FieldValues['data_esaurim'], '')]));
       Next;
    end;
    Active:= False;
  end;

  if rmOrdine.Lines.Count > 0 then
  begin
     strm:= TFileStream.Create(AppPath + 'richiesta.rtf', fmOpenWrite);
     rmOrdine.SaveRichText(strm);
     strm.Free;
     OpenFileDoc(AppPath + 'richiesta.rtf');
     rmOrdine.Clear;
  end;

  //OpenDocument(AppPath + 'richiesta.txt' );
  //OpenFileDoc(AppPath + 'richiesta.txt' );

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

