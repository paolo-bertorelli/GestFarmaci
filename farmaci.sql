CREATE TABLE Farmaci ( ID INTEGER PRIMARY KEY AUTOINCREMENT , etichetta varchar(50) NOT NULL, princ_attivo varchar(50)  ,   dosaggio varchar(20) NULL,    qta_conf INT NOT NULL, consumo INT, utile INT, liv_guardia INT, Ultimo_agg varchar(10) );
CREATE UNIQUE INDEX "IX_Farmaci" ON "Farmaci" (
	"ID"
);
