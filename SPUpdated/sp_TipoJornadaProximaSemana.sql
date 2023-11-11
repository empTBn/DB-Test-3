CREATE OR ALTER PROCEDURE sp_TipoJornadaProximaSemana 
    @fecha Date
AS
BEGIN
    BEGIN TRY
        DECLARE @XML AS XML,
                @hDoc AS INT, 
                @SQL NVARCHAR (MAX)

        SET @XML = (SELECT CONVERT(XML, BulkColumn) 
                     AS BulkColumn 
                     FROM OPENROWSET(BULK 'C:\Users\pablo\Downloads\OperacionesV2.xml', SINGLE_BLOB) AS x)
        EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

        DECLARE @xmlTable TABLE(
            ValorTipoDocumento int,
            IdTipoJornada int
        );

        INSERT INTO @xmlTable 
        SELECT ValorTipoDocumento,
               IdTipoJornada
        FROM OPENXML(@hDoc, 'Operacion/FechaOperacion/JornadasProximaSemana/TipoJornadaProximaSemana') 
        WITH  
        (   Fecha date '../../@Fecha',
            ValorTipoDocumento int '@ValorTipoDocumento',
            IdTipoJornada int '@IdTipoJornada'
        )
        WHERE @fecha = Fecha;  

        INSERT INTO dbo.TipoJornadaProximaSemana
        SELECT ValorTipoDocumento,
               IdTipoJornada,
               1
        FROM @xmlTable;  

        -- Log the success event
        INSERT INTO dbo.EventLog 
        VALUES(
            'TIPO JORNADA PROXIMA SEMANA PROCEDURE SUCCESS',
			0,
            (SELECT @@SERVERNAME),
            GETDATE()
        );

        EXEC sp_xml_removedocument @hDoc;
    END TRY
    BEGIN CATCH
        -- Log the error details into the dbo.DBErrors table
        INSERT INTO dbo.DBErrors 
        VALUES (
            SUSER_SNAME(),
            ERROR_NUMBER(),
            ERROR_STATE(),
            ERROR_SEVERITY(),
            ERROR_LINE(),
            ERROR_PROCEDURE(),
            ERROR_MESSAGE(),
            GETDATE()
        );

        -- Log the error event
        INSERT INTO dbo.EventLog 
        VALUES(
            'TIPO JORNADA PROXIMA SEMANA PROCEDURE ERROR',
			0,
            (SELECT @@SERVERNAME),
            GETDATE()
        );

        -- Re-throw the error
        THROW;
    END CATCH
END;
