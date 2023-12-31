CREATE OR ALTER   PROCEDURE [dbo].[sp_MostrarEmpleado]
    @output INT OUT -- C�digo de salida
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @MostrarTable TABLE (
      Nombre varchar(64)
      ,TipoDocuIdentidad varchar(64)
      ,ValorDocuIdentidad int
      ,Departamento varchar(64)
      ,Puesto varchar(64)
      ,Usuario varchar(64)
      ,Password varchar(64)
        
    )

    BEGIN TRY
        -- Insert data into the table variable
        INSERT INTO @MostrarTable
        SELECT 
			Nombre
			,(SELECT Nombre from TipoDocuIdentidad where Empleado.TipoDocuIdentidad=id)
			,ValorDocuIdentidad
			,(SELECT Nombre from Departamento  where Empleado.IdDepartamento=id)
			,(SELECT Nombre from Puesto  where Empleado.IdPuesto=id)
			,Usuario
			,Password
        FROM Empleado 
		WHERE Activo=1 
		ORDER BY Nombre
        -- Select data from the table variable and order it by Nombre
        SELECT *
        FROM @MostrarTable

        SET @output = 1; -- Indicate success
    END TRY
    BEGIN CATCH
        	IF @@TRANCOUNT>0


		INSERT INTO DBErrors VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
		);
        SET @output = 0; -- Indicate an error
    END CATCH

    SET NOCOUNT OFF;
END;