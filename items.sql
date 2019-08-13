CREATE VIEW items as
select distinct ID, item, qta_conf from (select ID, etichetta as item
, qta_conf from farmaci union select ID, princ_attivo as item
, qta_conf from farmaci where case when princ_attivo is null then ''
else princ_attivo end <> '') order by item
/* items(ID,item,qta_conf) */;
