CREATE VIEW main as
select ID, etichetta, princ_attivo, dosaggio, qta_conf, consumo, utile, liv_guardia, Ultimo_agg
, case when consumo is not null then (utile / consumo) else null end as autonomia
, case when consumo is not null then date(utile / consumo + julianday(ultimo_agg) + 0.5) else null end as data_esaurim
from farmaci
order by Etichetta
/* main(ID,etichetta,princ_attivo,dosaggio,qta_conf,consumo,utile,liv_guardia,Ultimo_agg,autonomia,data_esaurim) */;
CREATE TRIGGER tr_update_frm_grid
 instead of update of utile on main
when (old.utile <> new.utile)
begin
 update farmaci set utile = new.utile where ID = new.ID;
end;
