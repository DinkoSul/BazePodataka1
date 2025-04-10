CREATE NONCLUSTERED INDEX IX_Datum_Izdavanja
ON Racun(DatumIzdavanja);

GO
DROP INDEX IX_Datum_Izdavanja ON Racun

GO         
SET STATISTICS IO ON;  
GO  
SELECT DatumIzdavanja FROM Racun WHERE DatumIzdavanja BETWEEN '20010702' AND '20010702 23:59:59'
GO  
SET STATISTICS IO OFF;  
GO 

--ukljuèivanje ostalih stupaca
CREATE NONCLUSTERED INDEX IX_Datum_Izdavanja
ON Racun(DatumIzdavanja)
INCLUDE (BrojRacuna)
GO

SELECT 
    o.name AS TableName,
    i.name AS IndexName,
    i.index_id,
    ps.index_type_desc,
    ps.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('dbo.Racun'), NULL, NULL, 'DETAILED') AS ps
JOIN sys.indexes AS i 
    ON ps.object_id = i.object_id AND ps.index_id = i.index_id
JOIN sys.objects AS o 
    ON i.object_id = o.object_id
WHERE o.type = 'U';

DBCC IND('AdventureWorksOBP', 'Racun', -1);

/*
Optimizirajte upit: SELECT DatumIzdavanja FROM Racun WHERE DatumIzdavanja BETWEEN '20010702' AND '20010702 23:59:59' 
* Koliko stranica je pregledao RDBMS?
* Napravite indeks koji optimizira upit
* Koliko sad stranica pregled RDBMS?
* Uklonite indeks
*/
CREATE NONCLUSTERED INDEX IX_Datum_Izdavanja
ON Racun(DatumIzdavanja);

GO
DROP INDEX IX_Datum_Izdavanja ON Racun
GO         
SET STATISTICS IO ON;  
GO  
SELECT DatumIzdavanja FROM Racun WHERE DatumIzdavanja BETWEEN '20010702' AND '20010702 23:59:59'
GO  
SET STATISTICS IO OFF;  
GO 

 SELECT IDRacun, DatumIzdavanja FROM Racun WHERE DatumIzdavanja BETWEEN '20010702' AND '20010702 23:59:59'

 --Transakcije
/* Napravite tablicu Osoba. Pokrenite transakciju i umetnite 3 zapisa u Osoba. 
Probajte dohvatiti podatke iz tablice. 
Odustanite od transakcije. 
Probajte dohvatiti podatke iz tablice.
*/
GO
CREATE TABLE Osoba (
IDOsoba INT PRIMARY KEY IDENTITY,
Ime NVARCHAR(15),
Prezime NVARCHAR(35)
);

GO
BEGIN TRANSACTION
INSERT INTO Osoba (Ime, Prezime) VALUES ('Marta', 'Miriæ')
INSERT INTO Osoba (Ime, Prezime) VALUES ('Iva', 'Iviæ')
INSERT INTO Osoba (Ime, Prezime) VALUES ('Boris', 'Biliæ')

PRINT '-- Ispis osoba nakon unosa u tablicu  unutar transakcije--'
SELECT * FROM Osoba

ROLLBACK

PRINT '-- Ispis osoba nakon odustajanja --'
SELECT * FROM Osoba

--2. Riješite zadatak 1, ali umjesto odustajanja potvrdite transakciju.
GO
BEGIN TRANSACTION
INSERT INTO Osoba (Ime, Prezime) VALUES ('Marta', 'Miriæ')
INSERT INTO Osoba (Ime, Prezime) VALUES ('Iva', 'Iviæ')
INSERT INTO Osoba (Ime, Prezime) VALUES ('Boris', 'Biliæ')
COMMIT


/*3. U transakciji umetnite 1 zapis u Osoba i postavite kontrolnu toèku. 
Umetnite još 1 zapis. Na kraju odustanite od transakcije. Što je u tablici?*/
GO
BEGIN TRANSACTION
INSERT INTO Osoba (Ime, Prezime) VALUES ('Barica', 'Aniæ')
SAVE TRAN KontrolnaTocka
PRINT @@TRANCOUNT
INSERT INTO Osoba (Ime, Prezime) VALUES ('Marko', 'Aniæ')
ROLLBACK TRANSACTION
PRINT @@TRANCOUNT

/*4. U transakciji umetnite 1 zapis u Osoba i postavite kontrolnu toèku. 
Umetnite još 1 zapis. Na kraju potvrdite transakciju. Što je u tablici?
*/
GO
BEGIN TRANSACTION
INSERT INTO Osoba (Ime, Prezime) VALUES ('Barica', 'Aniæ')
SAVE TRAN KontrolnaTocka
INSERT INTO Osoba (Ime, Prezime) VALUES ('Marko', 'Aniæ')
COMMIT

SELECT * FROM Osoba

/*
5. U transakciji umetnite 1 zapis u Osoba i postavite kontrolnu toèku. Umetnite još 1 zapis i postavite kontrolnu toèku. Na kraju odustanite od transakcije.
6. U transakciji umetnite 1 zapis u Osoba i postavite kontrolnu toèku. Umetnite još 1 zapis i postavite kontrolnu toèku. Na kraju potvrdite transakciju.
7. U transakciji umetnite 1 zapis u Osoba i postavite kontrolnu toèku. Umetnite još 1 zapis i vratite se na kontrolnu toèku. Na kraju odustanite od transakcije.
8. U transakciji umetnite 1 zapis u Osoba i postavite kontrolnu toèku. ,Umetnite još 1 zapis i vratite se na kontrolnu toèku. Na kraju potvrdite transakciju.

*/