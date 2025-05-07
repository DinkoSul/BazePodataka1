
-- ZADATAK 1:Napišite proceduru koja dohvaća sve retke iz tablice Kupac. Pozovite proceduru. Promijenite proceduru tako da vraća rezultate poredane po imenu pa po prezimenu. Uklonite proceduru.
CREATE PROCEDURE DohvatiKupce
AS
BEGIN
    SELECT * FROM Kupac;
END;
GO

ALTER PROCEDURE DohvatiKupce
AS
BEGIN
    SELECT * FROM Kupac
    ORDER BY Ime, Prezime;
END;
GO

DROP PROCEDURE DohvatiKupce;
GO

-- ZADATAK 2:Napišite proceduru koja dohvaća prvih 10 redaka iz tablice Proizvod, prvih 5 redaka iz tablice KreditnaKartica i zadnja 3 retka iz tablice Racun. Pozovite proceduru. Uklonite proceduru. 
CREATE PROCEDURE DohvatiRazliciteRedke
AS
BEGIN
    SELECT TOP 10 * FROM Proizvod;
    SELECT TOP 5 * FROM KreditnaKartica;
    SELECT * FROM (
        SELECT TOP 3 * FROM Racun ORDER BY ID DESC
    ) AS ZadnjaTri
    ORDER BY ID;
END;
GO

EXEC DohvatiRazliciteRedke;
GO

DROP PROCEDURE DohvatiRazliciteRedke;
GO

-- ZADATAK 3: Napišite proceduru koja prima @ID proizvoda i  vraća samo taj proizvod iz tablice Proizvod.  Uklonite proceduru. 
CREATE PROCEDURE DohvatiProizvodPoIDu
    @ID INT
AS
BEGIN
    SELECT * FROM Proizvod WHERE ID = @ID;
END;
GO

EXEC DohvatiProizvodPoIDu @ID = 1;
EXEC DohvatiProizvodPoIDu 1;
GO

DROP PROCEDURE DohvatiProizvodPoIDu;
GO

-- ZADATAK 4:Napišite proceduru koja prima dvije cijene i vraća nazive i cijene svih proizvoda čija cijena je u zadanom rasponu. Uklonite proceduru.
CREATE PROCEDURE ProizvodiUCjenovnomRasponu
    @MinCijena DECIMAL(10, 2),
    @MaxCijena DECIMAL(10, 2)
AS
BEGIN
    SELECT Naziv, Cijena
    FROM Proizvod
    WHERE Cijena BETWEEN @MinCijena AND @MaxCijena;
END;
GO

EXEC ProizvodiUCjenovnomRasponu @MinCijena = 10, @MaxCijena = 100;
EXEC ProizvodiUCjenovnomRasponu 10, 100;
GO

DROP PROCEDURE ProizvodiUCjenovnomRasponu;
GO

-- ZADATAK 5: Napišite proceduru koja prima četiri parametra potrebna za unos nove kreditne kartice. Neka procedura napravi novi zapis u KreditnaKartica. Neka procedura prije i nakon umetanja dohvati broj zapisa u tablici. Uklonite proceduru. 
CREATE PROCEDURE UnesiKreditnuKarticu
    @BrojKartice NVARCHAR(20),
    @ImeVlasnika NVARCHAR(100),
    @DatumIsteka DATE,
    @CVV NVARCHAR(5)
AS
BEGIN
    DECLARE @Prije INT, @Poslije INT;

    SELECT @Prije = COUNT(*) FROM KreditnaKartica;

    INSERT INTO KreditnaKartica (BrojKartice, ImeVlasnika, DatumIsteka, CVV)
    VALUES (@BrojKartice, @ImeVlasnika, @DatumIsteka, @CVV);

    SELECT @Poslije = COUNT(*) FROM KreditnaKartica;

    SELECT @Prije AS BrojPrije, @Poslije AS BrojPoslije;
END;
GO

EXEC UnesiKreditnuKarticu
    @BrojKartice = '1234-5678-9012-3456',
    @ImeVlasnika = N'Iva Ivić',
    @DatumIsteka = '2027-12-31',
    @CVV = '123';
GO

DROP PROCEDURE UnesiKreditnuKarticu;
GO

-- ZADATAK 6: Napišite proceduru koja prima tri boje i za svaku boju vraća proizvode u njoj. Pozovite proceduru i nakon toga je uklonite.
CREATE PROCEDURE ProizvodiPoBojama
    @Boja1 NVARCHAR(30),
    @Boja2 NVARCHAR(30),
    @Boja3 NVARCHAR(30)
AS
BEGIN
    SELECT * FROM Proizvod WHERE Boja = @Boja1;
    SELECT * FROM Proizvod WHERE Boja = @Boja2;
    SELECT * FROM Proizvod WHERE Boja = @Boja3;
END;
GO

EXEC ProizvodiPoBojama N'Crvena', N'Plava', N'Zelena';
GO

DROP PROCEDURE ProizvodiPoBojama;
GO

-- ZADATAK 7: Napišite proceduru koja prima parametre @IDProizvod i @Boja. Parametar @Boja neka bude izlazni parametar. Neka procedura za zadani proizvod vrati njegovu boju pomoću izlaznog parametra. Pozovite proceduru na oba načina i ispišite vraćenu vrijednost. Uklonite proceduru.

CREATE PROCEDURE DohvatiBojuProizvoda
    @IDProizvod INT,
    @Boja NVARCHAR(30) OUTPUT
AS
BEGIN
    SELECT @Boja = Boja FROM Proizvod WHERE ID = @IDProizvod;
END;
GO

-- Poziv na oba načina:
DECLARE @BojaRez NVARCHAR(30);
EXEC DohvatiBojuProizvoda @IDProizvod = 1, @Boja = @BojaRez OUTPUT;
PRINT 'Boja proizvoda: ' + @BojaRez;

DECLARE @Boja2 NVARCHAR(30);
EXEC DohvatiBojuProizvoda 1, @Boja2 OUTPUT;
PRINT 'Boja proizvoda: ' + @Boja2;
GO

DROP PROCEDURE DohvatiBojuProizvoda;
GO

-- ZADATAK 8: Napišite proceduru koja prima kriterij po kojemu ćete filtrirati prezimena iz tablice Kupac. Neka procedura pomoću izlaznog parametra vrati broj zapisa koji zadovoljavaju zadani kriterij. Neka procedura vrati i sve zapise koji zadovoljavaju kriterij. Pozovite proceduru i ispišite vraćenu vrijednost. Uklonite proceduru.

CREATE PROCEDURE FiltrirajPrezime
    @Kriterij NVARCHAR(50),
    @BrojZadovoljavajucih INT OUTPUT
AS
BEGIN
    SELECT * FROM Kupac WHERE Prezime LIKE @Kriterij;
    SELECT @BrojZadovoljavajucih = COUNT(*) FROM Kupac WHERE Prezime LIKE @Kriterij;
END;
GO

DECLARE @BrojKupaca INT;
EXEC FiltrirajPrezime @Kriterij = N'P%', @BrojZadovoljavajucih = @BrojKupaca OUTPUT;
PRINT 'Broj kupaca koji zadovoljavaju kriterij: ' + CAST(@BrojKupaca AS NVARCHAR);
GO

DROP PROCEDURE FiltrirajPrezime;
GO

-- ZADATAK 9: Napišite proceduru koja za zadanog komercijalistu pomoću izlaznih parametara vraća njegovo ime i prezime te ukupnu količinu izdanih računa.

CREATE PROCEDURE InfoOKomercijalistu
    @IDKomercijalist INT,
    @Ime NVARCHAR(50) OUTPUT,
    @Prezime NVARCHAR(50) OUTPUT,
    @UkupnoRacuna INT OUTPUT
AS
BEGIN
    SELECT @Ime = Ime, @Prezime = Prezime FROM Komercijalist WHERE ID = @IDKomercijalist;
    SELECT @UkupnoRacuna = COUNT(*) FROM Racun WHERE KomercijalistID = @IDKomercijalist;
END;
GO

DECLARE @ImeK NVARCHAR(50), @PrezimeK NVARCHAR(50), @BrojRacuna INT;
EXEC InfoOKomercijalistu 1, @ImeK OUTPUT, @PrezimeK OUTPUT, @BrojRacuna OUTPUT;
PRINT 'Ime: ' + @ImeK + ', Prezime: ' + @PrezimeK + ', Broj računa: ' + CAST(@BrojRacuna AS NVARCHAR);
GO

DROP PROCEDURE InfoOKomercijalistu;
GO
