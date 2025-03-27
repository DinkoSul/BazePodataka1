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
�ija je ukupna cijena manja od 2 eura
�ija je ukupna cijena ve�a ili jednaka 23000 eura
�ija je koli�ina ve�a ili jednaka 20 i manja ili jednaka 22

*/
SELECT * FROM Stavka WHERE UkupnaCijena<2
SELECT * FROM Stavka WHERE UkupnaCijena>=23000
SELECT * FROM Stavka WHERE Kolicina>=20 AND Kolicina<=22
SELECT * FROM Stavka WHERE Kolicina BETWEEN 20 AND 22
/*
Dohvatiti sve proizvode iz tablice Proizvod:
�ija je boja plava ili crvena
�ija boja nije definirana
�ija je boja srebrna ili nije definirana
�ija je boja definirana
�ija boja nije definirana i cijena je manja od 25 eura
*/
SELECT * FROM Proizvod WHERE Boja IN('Plava', 'Crvena')
SELECT * FROM Proizvod WHERE Boja='Plava' OR Boja='Crvena'

SELECT * FROM Proizvod WHERE Boja IS NULL
SELECT * FROM Proizvod WHERE Boja='Srebrna' OR Boja IS NULL
SELECT * FROM Proizvod WHERE Boja IS NOT NULL
SELECT * FROM Proizvod WHERE Boja IS NULL AND CijenaBezPDV<25 

/*
Dohvatiti sve ra�une iz tablice Racun:
Koji su izdani 14.7.2004.
Koji su izdani 14.7.2004. ili 15.7.2004.
Koji su izdani izme�u 14.7.2004. i 21.7.2004.
*/
SELECT * FROM Racun WHERE DatumIzdavanja='20040714'
SELECT * FROM Racun WHERE DatumIzdavanja='20040714' OR DatumIzdavanja='20040715'
SELECT * FROM Racun WHERE DatumIzdavanja IN ('2004-07-14', '2004-07-15')
SELECT * FROM Racun WHERE DatumIzdavanja BETWEEN'20040714' AND '20040721'

/* DZ
Dohvatiti sve kupce iz tablice Kupac:
�ija je vrijednost primarnog klju�a 10, 25, 74 ili 154
�ije ime zapo�inje slovima "Ki"
�ije prezime zavr�ava slovima "ams"
�ije prezime zapo�inje slovom "D" i prezime sadr�ava string "re"
*/