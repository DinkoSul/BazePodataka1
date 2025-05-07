/*9. Napišite proceduru za brisanje proizvoda. Neka procedura prima 1 parametar, IDProizvod. 
Transakciju vodite izvan procedure. Ispišite uspjeh ili neuspjeh. 
* Pozovite 3 puta proceduru s vrijednostima parametara jednakim 1001, 1002 i 1003. 
* Pozovite 3 puta proceduru s vrijednostima parametara jednakim 1001, 1002 i 777.
*/
GO
CREATE PROCEDURE ObrisiProizvod @IDProizvod INT
AS
BEGIN
	BEGIN TRY
		DELETE FROM Proizvod WHERE IDProizvod = @IDProizvod;
		IF @@ROWCOUNT = 0
			PRINT 'Neuspješno brisanje: Proizvod s ID-em ' + CAST(@IDProizvod as NVARCHAR) + ' ne postoji!'
		ELSE
			PRINT 'Uspješno brisanje: Proizvod s ID-em ' + CAST(@IDProizvod as NVARCHAR) + ' je obrisan!'
	END TRY
	BEGIN CATCH
		PRINT 'Greška pri brisanju prizvoda ' + CAST(@IDProizvod as NVARCHAR)
	END CATCH
END
--Pokretanje transakcije
BEGIN TRAN 
EXEC ObrisiProizvod @IDProizvod = 532
EXEC ObrisiProizvod @IDProizvod = 533
EXEC ObrisiProizvod @IDProizvod = 534
COMMIT

BEGIN TRAN 
EXEC ObrisiProizvod @IDProizvod = 1001
EXEC ObrisiProizvod @IDProizvod = 1002
EXEC ObrisiProizvod @IDProizvod = 777
COMMIT

/*
<note>
  <date>2015-09-01</date>
  <hour>08:30</hour>
  <to>Tove</to>
  <from>Jani</from>
  <body>Don't forget me this weekend!</body>
</note>

<?xml version="1.0"?>
<CAT>
  <Ime>Izzy</Ime>
  <Vrsta>Siamese</Vrsta>
  <AGE>6</AGE>
  <ALTERED>yes</ALTERED>
  <DECLAWED>no</DECLAWED>
  <LICENSE>Izz138bod</LICENSE>
  <OWNER>Colin Wilcox</OWNER>
</CAT>


10. Osigurajte da u tablici Drzava ne mogu postojati dvije države s istim nazivom. 
Napišite proceduru koja prima 1 XML parametar koji sadržava podatke potrebne za umetnuti novu državu i tri njena grada. 
Transakciju vodite unutar procedure. Ispišite uspjeh ili neuspjeh. 
Pozovite proceduru 2 puta s istim XML dokumentom kao parametrom.
*/


GO
CREATE PROCEDURE DodajDrzavuIGradove
    @UnosXMLa XML
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @NazivDrzave NVARCHAR(100);
        DECLARE @IDDrzava INT;

        -- Dohvaæanje naziva države
        SET @NazivDrzave = @UnosXMLa.value('(/podaci/drzava)[1]', 'NVARCHAR(100)');

		 -- Provjeri postoji li država
        IF EXISTS (SELECT 1 FROM Drzava WHERE Naziv = @NazivDrzave)
        BEGIN
            RAISERROR('Država s tim nazivom veæ postoji.', 16, 1);
        END

        -- Umetanje države
        INSERT INTO Drzava (Naziv)
        VALUES (@NazivDrzave);

        SET @IDDrzava = SCOPE_IDENTITY();

        -- Umetanje gradova
        INSERT INTO Grad (Naziv, DrzavaID)
        SELECT
            x.value('.', 'NVARCHAR(100)'),
            @IDDrzava
        FROM @UnosXMLa.nodes('/podaci/grad') AS T(x);

        COMMIT;
        PRINT 'Uspjeh: Država i gradovi su umetnuti.';
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Neuspjeh: Došlo je do greške.';
    END CATCH
END;

DECLARE @xml XML = '
<podaci>
	<drzava>Italija</drzava>
	<grad>Rim</grad>
	<grad>Napulj</grad>
	<grad>Torino</grad>
</podaci>'


EXEC DodajDrzavuIGradove @UnosXMLa = @xml;
EXEC DodajDrzavuIGradove @UnosXMLa = @xml;
GO


/*
11. Unutar vanjske transakcije pozovite prethodnu proceduru s nekim drugim parametrom. 
Nakon toga odustanite od vanjske transakcije. Ispišite uspjeh ili neuspjeh. 
Je li umetanje napravljeno?
*/

DECLARE @xml1 XML = '
<podaci>
	<drzava>Španjolska</drzava>
	<grad>Madrid</grad>
	<grad>Barcelona</grad>
	<grad>Valencia</grad>
</podaci>'


BEGIN TRAN
	BEGIN TRY
		EXEC DodajDrzavuIGradove @UnosXMLa = @xml1;
		ROLLBACK
		PRINT 'Otkazana transkacija';
	END TRY
	BEGIN CATCH
		ROLLBACK;
		PRINT 'Neuspjeh: Došlo je do greške.';
	END CATCH

GO