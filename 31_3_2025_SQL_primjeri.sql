SELECT Ime AS KupacIme, Prezime AS KupacPrezime FROM Kupac
SELECT Ime AS 'Kupac Ime', Prezime AS 'Kupac Prezime' FROM Kupac
SELECT Ime AS "Kupac Ime", Prezime AS "Kupac Prezime" FROM Kupac


SELECT Ime + ' ' + Prezime AS KupacPunoIme FROM Kupac
SELECT Prezime + ' ' + Ime AS KupacPunoIme FROM Kupac

SELECT DISTINCT Ime AS KupacIme FROM Kupac
SELECT DISTINCT Ime, Prezime FROM Kupac

/*
Dohvatiti iz tablice Kupac:

Imena i prezimena osoba �ije ime po�inje s "Ki"
Imena i prezimena osoba koji imaju primarni klju� izme�u 15530 i 15535. Prvi stupac preimenovati u "Ime", drugi u "Prezime"
Jedan stupac PunoIme koji se sastoji od spojenog prezimena i imena za sve osobe.�
Ime, Prezime, PunoIme, te email adresu
Jedinstvena imena
Jedinstvena prezimena
Jedinstvena imena i prezimena
*/

SELECT Ime AS 'Kupac Ime',
Prezime AS "Kupac Prezime"
 FROM Kupac WHERE Ime LIKE 'Ki%'

SELECT Ime AS Ime,
Prezime AS Prezime
FROM Kupac WHERE IDKupac BETWEEN 15530 AND 15535

SELECT Prezime + ' ' + Ime AS PunoIme FROM Kupac

SELECT Ime AS Ime, Prezime AS Prezime, Prezime + ' ' + Ime AS PunoIme, Email AS email FROM Kupac

SELECT DISTINCT Ime FROM Kupac
SELECT DISTINCT Prezime FROM Kupac
SELECT DISTINCT Ime, Prezime FROM Kupac

---nastavak

SELECT Ime AS Ime,
Prezime AS KupacPrezime
FROM Kupac WHERE IDKupac BETWEEN 15530 AND 15535 ORDER BY Ime ASC, KupacPrezime DESC

/*
Dohvatiti iz tablice Kupac:

a) Imena i prezimena osoba �ije ime po�inje s "Kat", sortirane prema imenu uzlazno pa prema prezimenu uzlazno
b) Imena i prezimena osoba �ije ime po�inje s "Kat", sortirane prema imenu uzlazno pa prema prezimenu silazno
c) Imena i prezimena osoba koji imaju primarni klju� izme�u 18150 i 18155. Prvi stupac preimenovati u "Ime", drugi u "Prezime". Sortirati prema stupcu Prezime silazno.
d) Jedan stupac PunoIme koji se sastoji od spojenog prezimena i imena za sve osobe. Sortirati uzlazno.
e) Jedan stupac PunoIme koji se sastoji od spojenog prezimena i imena za sve osobe. Sortirati silazno.

*/

SELECT Ime, Prezime FROM Kupac WHERE Ime='Kat%' ORDER BY Ime, Prezime
SELECT Ime, Prezime FROM Kupac WHERE Ime='Kat%' ORDER BY Ime, Prezime DESC
SELECT Ime AS Ime,
Prezime AS Prezime
FROM Kupac WHERE IDKupac BETWEEN 18150 AND 18155 ORDER BY Prezime DESC
SELECT Prezime + ' ' + Ime AS PunoIme FROM Kupac ORDER BY PunoIme
SELECT Prezime + ' ' + Ime AS PunoIme FROM Kupac ORDER BY PunoIme DESC

---
SELECT TOP (5) * FROM Kupac
SELECT TOP (1) PERCENT * FROM Kupac

/*
Dohvatiti iz tablice Kupac:

a)Prvih 5 redaka iz tablice
b)Imena i prezimena zadnjih 5 redaka iz tablice
c)Polovicu prvih osoba koje se zovu "Jack"
d)Samo prezimena polovice prvih osoba koje se zovu "Jack"
*/

SELECT TOP(5) * FROM Kupac ORDER BY IDKupac ASC;
SELECT TOP(5) IDKupac, Ime, Prezime FROM Kupac ORDER BY IDKupac DESC;
SELECT TOP(50) PERCENT * FROM Kupac WHERE Ime = 'Jack' ORDER BY IDKupac ASC;
SELECT TOP(50) PERCENT Prezime FROM Kupac WHERE Ime='Jack' ORDER BY IDKupac ASC; 

INSERT INTO Kupac (Ime, Prezime, Email, Telefon, GradID)
	VALUES ('Jura', 'Juri�', 'jura@jurino.com', NULL, 3)

SELECT TOP(5) * FROM Kupac ORDER BY IDKupac DESC;

INSERT INTO Kupac VALUES ('Mara1', 'Markovic1', 'mara@murino.com', NULL, 3)
DBCC CHECKIDENT ('Kupac', NORESEED)
DBCC CHECKIDENT ('Kupac', RESEED, 19979)

DELETE FROM Kupac WHERE IDKupac=20001;
select IDENT_CURRENT('Kupac') 

/*
Umetnite dr�avu Madagaskar.
Umetnite grad Buenos Aires u Argentinu. Pazite na redoslijed!
Umetnite proizvod "Sony Player" cijene 985,50 eura. Potkategorija je "Playeri", kategorija "Razno". Podatke koji nisu zadani izmislite.
Umetnite kupca Josipu Josi� iz Gospi�a s emailom josipa@gmail.com i bez telefona.
Umetnite kreditnu karticu po izboru.

Napravite tablicu KupacVIP sa stupcima ime i prezime. Umetnite u nju sve kupce koji se zove Karen, Mary ili Jimmy.
*/

INSERT INTO Drzava VALUES ('Madagaskar')
INSERT INTO Drzava VALUES ('Argentina')
INSERT INTO Grad (Naziv, DrzavaID) 
SELECT 'Buenos Aires', IDDrzava FROM Drzava WHERE Naziv='Argentina'


INSERT INTO Kategorija(Naziv) VALUES ('Razno')
INSERT INTO Potkategorija(Naziv, KategorijaID)
SELECT 'Playeri', IDKategorija FROM Kategorija WHERE Naziv='Razno'


INSERT INTO Proizvod([Naziv]
      ,[BrojProizvoda]
      ,[Boja]
      ,[MinimalnaKolicinaNaSkladistu]
      ,[CijenaBezPDV]
      ,[PotkategorijaID]) 
SELECT 'Sony Player','XX-2221', 'Crna', 0, 5, IDPotkategorija FROM Potkategorija WHERE Naziv='Playeri'


CREATE TABLE KupacVIP (
    Ime NVARCHAR(50) NOT NULL,
    Prezime NVARCHAR(50) NOT NULL,
);

INSERT INTO KupacVIP (Ime, Prezime)
SELECT Ime, Prezime FROM Kupac WHERE Ime IN('Karen', 'Mary', 'Jimmy')