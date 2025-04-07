SELECT DISTINCT p.Naziv 
FROM Stavka AS s
INNER JOIN Proizvod as p
on p.IDProizvod = s.ProizvodID
WHERE s.Kolicina > 35

--1. Ispi�ite sve boje proizvoda i pokraj svake napi�ite koliko proizvoda ima tu boju.
SELECT 
Boja, COUNT(*) AS BrojProizvoda
FROM Proizvod
GROUP BY Boja


SELECT 
Boja, PotkategorijaID, COUNT(*) AS Kolicina
FROM Proizvod
GROUP BY Boja, PotkategorijaID
ORDER BY Boja, PotkategorijaID


--2. Promijenite prethodni upit tako da sortirate padaju�e prema broju proizvoda.
SELECT 
Boja, COUNT(*) AS BrojProizvoda
FROM Proizvod
GROUP BY Boja
ORDER BY BrojProizvoda DESC

--3. Promijenite prethodni upit tako da isklju�ite nedefiniranu boju.
SELECT 
Boja, COUNT(*) AS BrojProizvoda
FROM Proizvod
WHERE Boja IS NOT NULL
GROUP BY Boja
ORDER BY BrojProizvoda DESC

--4. Ispi�ite koliko proizvoda svake boje ima u svakoj od potkategorija. Sortirajte prema potkategoriji i prema boji.
SELECT PotkategorijaID,Boja, COUNT(*) AS BrojProizvoda 
FROM Proizvod
WHERE PotkategorijaID IS NOT NULL
GROUP BY PotkategorijaID, Boja
ORDER BY PotkategorijaID, Boja



--5. Promijenite prethodni upit tako da ispi�ete 10 podkategorija i boja s najvi�e proizvoda.
SELECT TOP 10 PotkategorijaID,Boja, COUNT(*) AS BrojProizvoda 
FROM Proizvod
WHERE PotkategorijaID IS NOT NULL
GROUP BY PotkategorijaID, Boja
ORDER BY BrojProizvoda DESC

--6. Promijenite prethodni upit tako da umjesto ID potkategorije ispi�ete njen naziv.
SELECT pk.Naziv, p.Boja, COUNT(*) AS BrojProizvoda 
FROM Proizvod AS p
INNER JOIN Potkategorija AS pk ON pk.IDPotkategorija=p.PotkategorijaID
GROUP BY pk.Naziv, p.Boja
ORDER BY BrojProizvoda DESC
/*
DZ:
7. Ispi�ite nazive svih kategorija i pokraj svake napi�ite koliko potkategorija je u njoj.
8. Ispi�ite nazive svih kategorija i pokraj svake napi�ite koliko proizvoda je u njoj.
9. Ispi�ite sve razli�ite cijene proizvoda i napi�ite koliko proizvoda ima svaku cijenu.
10.Ispi�ite koliko je ra�una izdano koje godine.
11. Ispi�ite brojeve svih ra�une izdane kupcu 377 i pokraj svakog ispi�ite ukupnu cijenu po svim stavkama.
12. Ispi�ite nazive svih potkategorija koje sadr�avaju vi�e od 10 proizvoda.
13. Ispi�ite ukupno zara�ene iznose i broj prodanih primjeraka za svaki od ikad prodanih proizvoda.
14. Ispi�ite ukupno zara�ene iznose za svaki od proizvoda koji je prodan u vi�e od 2000 primjeraka.
15. Ispi�ite ukupno zara�ene iznose za svaki od proizvoda koji je prodan u vi�e od 2.000 primjeraka ili je zaradio vi�e od 2.000.000 dolara.

*/


--Ispi�ite sve boje koje imaju vi�e od 40 proizvoda.
SELECT 
	Boja, COUNT(*) AS BrojProizvoda
FROM Proizvod
WHERE Boja IS NOT NULL
GROUP BY Boja
HAVING COUNT(*) >40

SELECT 
		Naziv,
		Boja,
		CijenaBezPDV
FROM Proizvod
WHERE CijenaBezPDV > 
	(SELECT AVG(CijenaBezPDV) 
	 FROM Proizvod)
ORDER BY 
		CijenaBezPDV DESC

--primjer Konstantni upit - vra�a jednu vrijednost
SELECT Naziv,
		(
			SELECT COUNT(*) 
			FROM Proizvod
		) AS BrojProizvoda
	FROM Proizvod

--primjer Korelirani upit 
SELECT TOP 5 Naziv,
	(
		SELECT SUM(s.Kolicina) 
		FROM Stavka AS s
	WHERE s.ProizvodID =p.IDProizvod
	) AS Prodano
	FROM Proizvod AS p
	ORDER BY Prodano DESC

	--konstantni
	SELECT 
		Naziv
	FROM Proizvod
	WHERE CijenaBezPDV > 
	(
		SELECT AVG(CijenaBezPDV) 
		FROM Proizvod
	)

	--korelirani
		SELECT *
	FROM Kupac AS k
	WHERE 
	(
		SELECT COUNT(*) 
		FROM Racun AS r
 		WHERE r.KupacID =	k.IDKupac
	) >= 27

	--Konstantni s operatorom IN:
	SELECT *
	FROM Proizvod AS p
	WHERE IDProizvod IN 
	(
		SELECT DISTINCT 	
		s.ProizvodID
		FROM Stavka AS s
	)

	--Korelirani s operatorom EXISTS: 
	SELECT *
	FROM Proizvod AS p
	WHERE EXISTS
	(
		SELECT * 
		FROM Stavka AS s
	WHERE s.ProizvodID =p.IDProizvod
	)

--Ispi�ite sve potkategorije i za svaku ispi�ite broj proizvoda u njoj.
  
  --upit koji ispisuje broj proizvoda po IDPotkategorije
  (SELECT COUNT(*)
  FROM Proizvod WHERE PotkategorijaID=2)

  SELECT Naziv, (SELECT COUNT(*)
  FROM Proizvod AS p WHERE p.PotkategorijaID=pk.IDPotkategorija) AS BrojProizvoda
  FROM Potkategorija AS pk
  ORDER BY BrojProizvoda DESC

  --Ispi�ite sve proizvode i pokraj svakog ispi�ite zara�eni iznos, od najboljih prema lo�ijim.
  (SELECT SUM(UkupnaCijena) FROM Stavka WHERE ProizvodID=776)

  SELECT Naziv, (SELECT SUM(UkupnaCijena) FROM Stavka AS s WHERE s.ProizvodID=p.IDProizvod) AS BrojProizvoda
  FROM Proizvod AS p
  ORDER BY Naziv
  /*
1. Ispi�ite sve potkategorije i za svaku ispi�ite broj proizvoda u njoj.
2. Rije�ite prethodni zadatak pomo�u spajanja.
3. Ispi�ite sve kategorije i za svaku ispi�ite broj proizvoda u njoj.
4. Ispi�ite sve proizvode i pokraj svakog ispi�ite zara�eni iznos, od najboljih prema lo�ijim.
5. Dohvatite sve proizvode, uz svaki proizvod ispi�ite prosje�nu cijenu svih proizvoda te razliku prosje�ne cijene svih proizvoda i cijene tog proizvoda. U obzir uzmite samo proizvode s cijenom ve�om od nule.
6. Dohvatite imena i prezimena 5 komercijalista koji su izdali najvi�e ra�una.
7. Dohvatite imena i prezimena 5 najboljih komercijalista po broju realiziranih ra�una te uz svakog dohvatite i iznos prodane robe.
8. Dohvatite sve boje proizvoda. Uz svaku boju pomo�u podupita dohvatite broj proizvoda u toj boji.
9. Dohvatite imena i prezimena svih kupaca iz Frankfurta i uz svakog ispi�ite broj ra�una koje je platio karticom, od vi�eg prema ni�em.
10. Vratite sve proizvode �ija je cijena pet ili vi�e puta ve�a od prosjeka.
11. Vratite sve proizvode koji su prodavani, ali u koli�ini manjoj od 5.
12. Vratite sve proizvode koji nikad nisu prodani:
* Pomo�u IN ili NOT IN
* Pomo�u EXISTS ili NOT EXISTS
* Pomo�u spajanja
13. Vratite koli�inu zara�enog novca za svaku boju proizvoda.
14. Vratite koli�inu zara�enog novca za svaku boju proizvoda, ali samo za one boje koje su zaradile vi�e od 20.000.000.
15. Vratiti sve proizvode koji imaju dodijeljenu potkategoriju i koji su prodani u koli�ini ve�oj od 5000. Uz svaki proizvod vratiti prodanu koli�inu i naziv kategorije.
*/



SELECT Podaci.PotkategorijaID, Podaci.Boja, Podaci.Kolicina
FROM (
    SELECT PotkategorijaID, Boja, COUNT(*) AS Kolicina
    FROM Proizvod
    WHERE PotkategorijaID IS NOT NULL
    GROUP BY PotkategorijaID, Boja
) AS Podaci
WHERE Podaci.Kolicina > 10
ORDER BY Podaci.Kolicina DESC;



