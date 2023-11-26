CREATE OR ALTER PROCEDURE sp_BorrarEmpleado
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
		DECLARE @Contador int;
		SET @Contador=0;
        DECLARE @xmlTable TABLE(
			id INT IDENTITY (1, 1),
            ValorTipoDocumento int
        );
		
        INSERT INTO @xmlTable 
        SELECT ValorTipoDocumento
        FROM OPENXML(@hDoc, 'Operacion/FechaOperacion/EliminarEmpleados/EliminarEmpleado') 
        WITH  
        (   Fecha date '../../@Fecha',
            ValorTipoDocumento int '@ValorTipoDocumento'
        )
        WHERE @fecha = Fecha;  
		WHILE EXISTS (SELECT ValorTipoDocumento FROM @xmlTable Where id=@Contador)
		BEGIN
        UPDATE dbo.Empleado
        SET Activo = 0
        WHERE [Empleado].[ValorDocuIdentidad] = (SELECT ValorTipoDocumento FROM @xmlTable WHERE id=@Contador) AND [Empleado].Activo=1;
		SET @Contador=@Contador+1;
		END
        -- Log the success event
        INSERT INTO dbo.EventLog 
        VALUES(
            'BORRAR EMPLEADO PROCEDURE SUCCESS',
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
            'BORRAR EMPLEADO PROCEDURE ERROR',
			0,
            (SELECT @@SERVERNAME),
            GETDATE()
        );

        -- Re-throw the error
        THROW;
    END CATCH
END;
