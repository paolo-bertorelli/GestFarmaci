unit uDM1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, sqldb;

type

  { TDM1 }

  TDM1 = class(TDataModule)
    C1: TSQLite3Connection;
    MainQry: TSQLQuery;
    MainTrns: TSQLTransaction;
    SvcQry: TSQLQuery;
  private

  public

  end;

var
  DM1: TDM1;

implementation

{$R *.lfm}

end.

