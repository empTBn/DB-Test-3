USE [Tarea3]
GO

-- Drop the existing procedure if needed
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MostrarEmpleado]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_MostrarEmpleado]
GO

-- Create the new procedure
CREATE PROCEDURE [dbo].[sp_MostrarEmpleado]
    @output INT OUT -- Código de salida
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare a table variable to store the selected data
    DECLARE @MostrarEmpleado TABLE (
        Nombre VARCHAR(64),
        ValorDocuIdentidad INT,
        IdDepartamento INT,
        IdPuesto INT
    )

    BEGIN TRY
        -- Insert data into the table variable
        INSERT INTO @MostrarEmpleado
        SELECT E.Nombre, E.ValorDocuIdentidad, E.IdDepartamento, E.IdPuesto
        FROM Empleado E
        WHERE E.Activo = 1

        -- Select data from the table variable and order it by Nombre
        SELECT *
        FROM @MostrarEmpleado
        ORDER BY Nombre

        SET @output = 1; -- Indicate success
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            INSERT INTO dbo.DBErrors VALUES (
                SUSER_SNAME(),
                ERROR_NUMBER(),
                ERROR_STATE(),
                ERROR_SEVERITY(),
                ERROR_LINE(),
                ERROR_PROCEDURE(),
                ERROR_MESSAGE(),
                GETDATE()
            );
        END
        SET @output = 0; -- Indicate an error
    END CATCH

    SET NOCOUNT OFF;
END;
