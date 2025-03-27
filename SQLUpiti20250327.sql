--Dohvatite sve retke iz tablice Proizvod
--Dohvatite sve retke iz tablice Drzava
--Dohvatite sve retke iz tablice Grad

SELECT * FROM Proizvod
SELECT * FROM Drzava
SELECT * FROM Grad

/*
Dohvatiti sve kupce iz tablice Kupac:
Koji se zovu Lili
Koji se prezivaju Lee
Koji se zovu Ana i prezivaju Diaz
Koji su iz Osijeka
Koji se zovu Ana ili Tamara
Koji se zovu Ana ili Tamara i iz Osijeka su
Koji se zovu Ana ili Tamara i nisu iz Osijeka
*/
SELECT * FROM Kupac WHERE Ime='Lili'
SELECT * FROM Kupac WHERE Prezime='Lee'
SELECT * FROM Kupac WHERE Ime='Ana' AND Prezime='Diaz'
SELECT * FROM Kupac WHERE Ime='Ana' AND GradID=2
SELECT * FROM Kupac WHERE Ime='Ana' OR Ime='Tamara'
SELECT * FROM Kupac WHERE (Ime='Ana' OR Ime='Tamara') AND GradID=2
SELECT * FROM Kupac WHERE (Ime='Ana' OR Ime='Tamara') AND NOT GradID=2


/*
Dohvatiti sve stavke iz tablice Stavka:
Èija je ukupna cijena manja od 2 eura
Èija je ukupna cijena veæa ili jednaka 23000 eura
Èija je kolièina veæa ili jednaka 20 i manja ili jednaka 22

*/
SELECT * FROM Stavka WHERE UkupnaCijena<2
SELECT * FROM Stavka WHERE UkupnaCijena>=23000
SELECT * FROM Stavka WHERE Kolicina>=20 AND Kolicina<=22
SELECT * FROM Stavka WHERE Kolicina BETWEEN 20 AND 22
/*
Dohvatiti sve proizvode iz tablice Proizvod:
Èija je boja plava ili crvena
Èija boja nije definirana
Èija je boja srebrna ili nije definirana
Èija je boja definirana
Èija boja nije definirana i cijena je manja od 25 eura
*/
SELECT * FROM Proizvod WHERE Boja IN('Plava', 'Crvena')
SELECT * FROM Proizvod WHERE Boja='Plava' OR Boja='Crvena'

SELECT * FROM Proizvod WHERE Boja IS NULL
SELECT * FROM Proizvod WHERE Boja='Srebrna' OR Boja IS NULL
SELECT * FROM Proizvod WHERE Boja IS NOT NULL
SELECT * FROM Proizvod WHERE Boja IS NULL AND CijenaBezPDV<25 

/*
Dohvatiti sve raèune iz tablice Racun:
Koji su izdani 14.7.2004.
Koji su izdani 14.7.2004. ili 15.7.2004.
Koji su izdani izmeðu 14.7.2004. i 21.7.2004.
*/
SELECT * FROM Racun WHERE DatumIzdavanja='20040714'
SELECT * FROM Racun WHERE DatumIzdavanja='20040714' OR DatumIzdavanja='20040715'
SELECT * FROM Racun WHERE DatumIzdavanja IN ('2004-07-14', '2004-07-15')
SELECT * FROM Racun WHERE DatumIzdavanja BETWEEN'20040714' AND '20040721'

/* DZ
Dohvatiti sve kupce iz tablice Kupac:
Èija je vrijednost primarnog kljuèa 10, 25, 74 ili 154
Èije ime zapoèinje slovima "Ki"
Èije prezime završava slovima "ams"
Èije prezime zapoèinje slovom "D" i prezime sadržava string "re"
*/