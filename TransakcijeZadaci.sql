GO
CREATE PROCEDURE ObrisiProizvod
    @IDProizvod INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Proizvod WHERE IDProizvod = @IDProizvod;

        IF @@ROWCOUNT = 0
            PRINT 'Neuspjeh: Proizvod s ID-em ' + CAST(@IDProizvod AS NVARCHAR) + ' ne postoji.';
        ELSE
            PRINT 'Uspjeh: Proizvod s ID-em ' + CAST(@IDProizvod AS NVARCHAR) + ' je obrisan.';
    END TRY
    BEGIN CATCH
        PRINT 'Greška pri brisanju proizvoda s ID-em ' + CAST(@IDProizvod AS NVARCHAR);
    END CATCH
END;

BEGIN TRANSACTION;

EXEC ObrisiProizvod @IDProizvod = 1001;
EXEC ObrisiProizvod @IDProizvod = 1002;
EXEC ObrisiProizvod @IDProizvod = 1003;

COMMIT;



-----------------------------------------


GO
CREATE PROCEDURE DodajDrzavuIGradove
    @UnosXMLa XML
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @NazivDrzave NVARCHAR(100);
        DECLARE @IDDrzava INT;

        -- Dohvaćanje naziva države
        SET @NazivDrzave = @UnosXMLa.value('(/podaci/drzava)[1]', 'NVARCHAR(100)');

		 -- Provjeri postoji li država
        IF EXISTS (SELECT 1 FROM Drzava WHERE Naziv = @NazivDrzave)
        BEGIN
            RAISERROR('Država s tim nazivom već postoji.', 16, 1);
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
    <drzava>Hrvatska</drzava>
    <grad>Zagreb</grad>
    <grad>Split</grad>
    <grad>Rijeka</grad>
</podaci>';

EXEC DodajDrzavuIGradove @UnosXMLa = @xml;
EXEC DodajDrzavuIGradove @UnosXMLa = @xml;

GO
---------------------------------------


DECLARE @xml2 XML = '
<podaci>
    <drzava>Srbija</drzava>
    <grad>Beograd</grad>
    <grad>Novi Sad</grad>
    <grad>Niš</grad>
</podaci>';

BEGIN TRANSACTION;

BEGIN TRY
    -- Poziv postojeće procedure
    EXEC DodajDrzavuIGradove @InputXML = @xml2;

    ROLLBACK;
    PRINT 'Neuspjeh: Vanjska transakcija je odustala.';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Neuspjeh: Došlo je do greške u vanjskoj transakciji.';
END CATCH;
