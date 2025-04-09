--Upit u FROM dijelu je privremena tablica
SELECT Podaci.PotkategorijaID, Podaci.Boja, Podaci.Kolicina
FROM (
    SELECT PotkategorijaID, Boja, COUNT(*) AS Kolicina
    FROM Proizvod
    WHERE PotkategorijaID IS NOT NULL
    GROUP BY PotkategorijaID, Boja
) AS Podaci
WHERE Podaci.Kolicina > 10
ORDER BY Podaci.Kolicina DESC;
--Deklariranje varijable
DECLARE @Ime nvarchar(10)
SET @Ime = 'Ana'
SELECT @Ime
PRINT @Ime

DECLARE @prodano int
SET @prodano = (SELECT SUM(Kolicina) FROM Stavka)
PRINT @prodano

DECLARE @NazivProizvoda nvarchar(50)
DECLARE @BojaProizvoda nvarchar(50)
SELECT 
	@NazivProizvoda = p.Naziv,
	@BojaProizvoda = p.Boja
FROM Proizvod AS p WHERE p.IDProizvod = 741

PRINT @NazivProizvoda
PRINT @BojaProizvoda


DECLARE @ProsjecnaCijena money
SELECT @ProsjecnaCijena = AVG(CijenaBezPDV) 
			FROM Proizvod AS p
SELECT * FROM Proizvod
	WHERE CijenaBezPDV >= @ProsjecnaCijena

--1. Napravite tablicu Polaznik i u nju umetnite nekoliko redaka. Napravite tablicu Zapisnik.
CREATE TABLE Polaznik (
	IDPolaznik INT PRIMARY KEY IDENTITY,
	Ime nvarchar(15),
	Prezime nvarchar(30),
)

INSERT INTO Polaznik (Ime, Prezime) VALUES ('Marko', 'Mari�'),('Iva', 'Ivi�'),('Snje�ka', 'Bijeli�')
INSERT INTO Polaznik (Ime, Prezime) VALUES ('Mario', 'Mihi�')
INSERT INTO Polaznik (Ime, Prezime) VALUES ('Barbara', 'Ani�')
INSERT INTO Polaznik (Ime, Prezime) VALUES ('Marko', 'Bari�')
CREATE TABLE Zapisnik (
	IDZapisa INT PRIMARY KEY IDENTITY,
	Akcija nvarchar(10),
	Detalji nvarchar(50),
	Vrijeme DATETIME DEFAULT GETDATE()
	)

--2. Napravite okida� kojim �ete svako umetanje retka u tablicu Polaznik zapisati u tablicu Zapisnik.�
GO
CREATE TRIGGER trg_AfterInsert_Polaznik
ON Polaznik
AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	INSERT INTO Zapisnik (Akcija, Detalji) 
	VALUES ('Insert', 'Umetnut novi polaznik u tablicu Polaznik.');
END;

--3. Promijenite okida� tako da zapi�e ime, prezime i JMBAG umetnutog polaznika u Zapisnik.
DROP TRIGGER trg_AfterInsert_Polaznik
GO
CREATE TRIGGER trg_AfterInsert_Polaznik
ON Polaznik
AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	INSERT INTO Zapisnik (Akcija, Detalji) 
	SELECT 'Insert', 'Umetnut: ' + Ime + ' ' + Prezime FROM inserted;
END;

--4. Promijenite okida� tako da se ve�e uz sve doga�aje i u Zapisnik zapisuje broj redaka u inserted i deleted tablicama. 
--Umetnite novog polaznika, promijenite svim polaznicima prezime i na kraju obri�ite sve polaznike.
DROP TRIGGER trg_AfterInsert_Polaznik
GO
DROP TRIGGER trg_AfterInsertDelete_Polaznik
GO
CREATE TRIGGER trg_AfterInsertDelete_Polaznik
ON Polaznik
AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @UmetnutiRedak INT = (SELECT COUNT(*) FROM inserted);
	DECLARE @ObrisaniRedak INT = (SELECT COUNT(*) FROM deleted);
	INSERT INTO Zapisnik (Akcija, Detalji) 
	VALUES ('Insert', 'Umetnutih redaka: ' + CAST(@UmetnutiRedak AS nvarchar) + ', Obrisanih redaka: ' 
	+ CAST(@ObrisaniRedak AS nvarchar));
END;


INSERT INTO Polaznik (Ime, Prezime) VALUES ('Ivica', 'Ani�')
UPDATE Polaznik SET Prezime='Test';
DELETE FROM Polaznik;

--5. Promijenite okida� tako da upisuje staru i novu vrijednost promijenjenog prezimena u Zapisnik.



--PROCEDURE
--1. Napi�ite proceduru koja dohva�a sve retke iz tablice Kupac. Pozovite proceduru. 
-- Promijenite proceduru tako da vra�a rezultate poredane po imenu pa po prezimenu. Uklonite proceduru.
GO
CREATE PROCEDURE DohvatiKupce
AS
BEGIN
	SELECT * FROM Kupac;
END;

EXEC DohvatiKupce;

GO
ALTER PROCEDURE DohvatiKupce
AS
BEGIN
	SELECT * FROM Kupac
	ORDER BY Ime, Prezime;
END;
EXEC DohvatiKupce;

GO
DROP PROC DohvatiKupce;


/* 
DZ 
--5. Promijenite okida� tako da upisuje staru i novu vrijednost promijenjenog prezimena u Zapisnik.
--2. Napi�ite proceduru koja dohva�a prvih 10 redaka iz tablice Proizvod, 
--prvih 5 redaka iz tablice KreditnaKartica i zadnja 3 retka iz tablice Racun. 
--Pozovite proceduru. Uklonite proceduru.
5. Napi�ite proceduru koja prima �etiri parametra potrebna za unos nove kreditne kartice. Neka procedura napravi novi zapis u KreditnaKartica. Neka procedura prije i nakon umetanja dohvati broj zapisa u tablici. Pozovite proceduru na oba na�ina. Uklonite proceduru.
6. Napi�ite proceduru koja prima tri boje i za svaku boju vra�a proizvode u njoj. Pozovite proceduru i nakon toga je uklonite.

*/
--3. Napi�ite proceduru koja prima @ID proizvoda i� vra�a samo taj proizvod iz tablice Proizvod. 
--Pozovite proceduru na oba na�ina. Uklonite proceduru.

GO
CREATE PROCEDURE DohvatiProizvodPoID @ID INT
AS
BEGIN
	SELECT * FROM Proizvod WHERE IDProizvod=@ID;
END;

EXEC DohvatiProizvodPoID 4;
EXEC DohvatiProizvodPoID @ID=323;
GO
DROP PROC DohvatiProizvodPoID;
--4. Napi�ite proceduru koja prima dvije cijene i vra�a nazive i cijene svih proizvoda �ija cijena je u zadanom rasponu. 
--Pozovite proceduru na oba na�ina. Uklonite proceduru.

--7. Napi�ite proceduru koja prima parametre @IDProizvod i @Boja. Parametar @Boja neka bude izlazni parametar.
--Neka procedura za zadani proizvod vrati njegovu boju pomo�u izlaznog parametra. Pozovite proceduru na oba na�ina i ispi�ite vra�enu vrijednost. Uklonite proceduru.
GO
CREATE PROCEDURE DohvatiBoju @IDProizvod INT, @Boja nvarchar(20) OUTPUT
AS
BEGIN
	SELECT @Boja = Boja FROM Proizvod WHERE IDProizvod=@IDProizvod;
END;

GO
DECLARE @Boja2 nvarchar(20);
EXEC DohvatiBoju 318, @Boja2 OUTPUT;
PRINT @Boja2
GO
DROP PROC DohvatiBoju;

/* 
DZ 
--5. Promijenite okida� tako da upisuje staru i novu vrijednost promijenjenog prezimena u Zapisnik.
--2. Napi�ite proceduru koja dohva�a prvih 10 redaka iz tablice Proizvod, 
--prvih 5 redaka iz tablice KreditnaKartica i zadnja 3 retka iz tablice Racun. 
--Pozovite proceduru. Uklonite proceduru.
5. Napi�ite proceduru koja prima �etiri parametra potrebna za unos nove kreditne kartice. Neka procedura napravi novi zapis u KreditnaKartica. Neka procedura prije i nakon umetanja dohvati broj zapisa u tablici. Pozovite proceduru na oba na�ina. Uklonite proceduru.
6. Napi�ite proceduru koja prima tri boje i za svaku boju vra�a proizvode u njoj. Pozovite proceduru i nakon toga je uklonite.
8. Napi�ite proceduru koja prima kriterij po kojemu �ete filtrirati prezimena iz tablice Kupac. Neka procedura pomo�u izlaznog parametra vrati broj zapisa koji zadovoljavaju zadani kriterij. Neka procedura vrati i sve zapise koji zadovoljavaju kriterij. Pozovite proceduru i ispi�ite vra�enu vrijednost. Uklonite proceduru.
9. Napi�ite proceduru koja za zadanog komercijalistu pomo�u izlaznih parametara vra�a njegovo ime i prezime te ukupnu koli�inu izdanih ra�una.

*/