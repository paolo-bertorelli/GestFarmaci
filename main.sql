CREATE VIEW main as
select *
, case when consumo is not null then (utile / consumo) else null end as autonomia
, case when consumo is not null then date(utile / consumo + julianday(ultimo_agg) + 0.5) else null end as data_esaurim
from farmaci
order by Etichetta
/* main(ID,etichetta,princ_attivo,dosaggio,qta_conf,consumo,utile,liv_guardia,Ultimo_agg,autonomia,data_esaurim) */;
