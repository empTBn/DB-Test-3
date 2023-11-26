CREATE OR ALTER PROCEDURE sp_MarcaDeAsistencia
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
            FechaEntrada Date,
            FechaSalida Date,
            HoraEntrada Time,
            HoraSalida Time
        );

        INSERT INTO @xmlTable 
        SELECT ValorTipoDocumento,
               FechaEntrada,
               FechaSalida,
               HoraEntrada,
               HoraSalida
        FROM OPENXML(@hDoc, 'Operacion/FechaOperacion/MarcasAsistencia/MarcaDeAsistencia') 
        WITH  
        (   Fecha date '../../@Fecha',
            ValorTipoDocumento int '@ValorTipoDocumento',
            FechaEntrada Date '@HoraEntrada',
            FechaSalida Date '@HoraSalida',
            HoraEntrada Time '@HoraEntrada',
            HoraSalida Time '@HoraSalida'
        )
        WHERE @fecha = Fecha;  

        INSERT INTO dbo.MarcaDeAsistencia
        SELECT ValorTipoDocumento,
               FechaEntrada,
               FechaSalida,
               HoraEntrada,
               HoraSalida,
               1
        FROM @xmlTable;  

        -- Log the success event
        INSERT INTO dbo.EventLog 
        VALUES(
            'MARCA DE ASISTENCIA PROCEDURE SUCCESS',
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
            'MARCA DE ASISTENCIA PROCEDURE ERROR',
			0,
            (SELECT @@SERVERNAME),
            GETDATE()
        );

        -- Re-throw the error
        THROW;
    END CATCH
END;
