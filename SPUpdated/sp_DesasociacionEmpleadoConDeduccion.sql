CREATE OR ALTER PROCEDURE sp_DesasociacionEmpleadoConDeduccion  
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
            idTipoDeduccion int,
            ValorTipoDocumento int
        );

        INSERT INTO @xmlTable 
        SELECT idTipoDeduccion,
               ValorTipoDocumento
        FROM OPENXML(@hDoc, 'Operacion/FechaOperacion/DesasociacionEmpleadoDeducciones/DesasociacionEmpleadoConDeduccion') 
        WITH  
        (   Fecha date '../../@Fecha',
            idTipoDeduccion int '@IdTipoDeduccion',
            ValorTipoDocumento int '@ValorTipoDocumento'
        )
        WHERE @fecha = Fecha;  

        UPDATE dbo.AsociacionEmpleadoDeducciones
        SET Activado = 0
        WHERE [AsociacionEmpleadoDeducciones].[idTipoDeduccion] = idTipoDeduccion
        AND [AsociacionEmpleadoDeducciones].[ValorTipoDocumento] = ValorTipoDocumento;

        -- Log the success event
        INSERT INTO dbo.EventLog 
        VALUES(
            'DESASOCIACION EMPLEADO CON DEDUCCION PROCEDURE SUCCESS',
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
            'DESASOCIACION EMPLEADO CON DEDUCCION PROCEDURE ERROR',
			0,
            (SELECT @@SERVERNAME),
            GETDATE()
        );

        -- Re-throw the error
        THROW;
    END CATCH
END;
