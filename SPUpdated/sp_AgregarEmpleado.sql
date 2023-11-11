CREATE OR ALTER PROCEDURE sp_AgregarEmpleado 
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
            Nombre VARCHAR(64),
            idTipoDocumento int,
            ValorTipoDocumento int,
            IdDepartamento int,
            IdPuesto int,
            Usuario varchar (64),
            Password varchar (64)
        );

        INSERT INTO @xmlTable 
        SELECT Nombre,
               idTipoDocumento,
               ValorTipoDocumento,
               IdDepartamento,
               IdPuesto,
               Usuario,
               Password
        FROM OPENXML(@hDoc, 'Operacion/FechaOperacion/NuevosEmpleados/NuevoEmpleado') 
        WITH  
        (   Fecha date '../../@Fecha',
            Nombre VARCHAR(64) '@Nombre',
            idTipoDocumento int '@IdTipoDocumento',
            ValorTipoDocumento int '@ValorTipoDocumento',
            IdDepartamento int '@IdDepartamento',
            IdPuesto int '@IdPuesto',
            Usuario varchar (64) '@Usuario',
            Password varchar (64) '@Password'
        )
        WHERE @fecha = Fecha;  

        INSERT INTO dbo.Empleado
        SELECT Nombre,
               idTipoDocumento,
               ValorTipoDocumento,
               IdDepartamento,
               IdPuesto,
               Usuario,
               Password,
               1
        FROM @xmlTable; 

        INSERT INTO dbo.EventLog VALUES(
            'ADD EMPLEADO PROCEDURE SUCCESS',
			'USER: #',
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

        -- Re-throw the error
        THROW;
    END CATCH
END;
