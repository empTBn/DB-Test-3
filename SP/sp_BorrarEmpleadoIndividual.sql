CREATE or ALTER     PROCEDURE [dbo].[SP_BorrarEmpleadoIndividual]
    @Nombre VARCHAR(128), -- Nombre del Articulo a agregar 
    @output INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @Mensaje varchar(64);
    BEGIN TRY
        -- Try inicial;
        

        -- Check if an article with the same name already exists
        IF NOT EXISTS (SELECT 1 FROM dbo.Empleado A WHERE A.Nombre = @Nombre AND Activo=1)
        BEGIN	
			SET @Mensaje='BORRAR EMPLEADO PROCEDURE SUCCESS'   
			SET @output = 1;  -- El codigo de resultado es 0 porque solo se modifica si se rechaza el 
			RETURN;
        END
		IF EXISTS (SELECT 1 FROM dbo.Empleado A WHERE A.Nombre = @Nombre AND A.Activo=0)
        BEGIN	
			SET @Mensaje='BORRAR EMPLEADO PROCEDURE FAILURE, Reason: Name exists, but it is deleated already'   
			SET @output = 1;  -- El codigo de resultado es 0 porque solo se modifica si se rechaza el 
			RETURN;
        END
		BEGIN
			SET @Mensaje='ADD EMPLEADO PROCEDURE FAILURE, Reason: Name already exists'

			UPDATE Empleado
			SET Activo=0
			WHERE Empleado.Nombre=@Nombre and Empleado.Activo=1
		END
		INSERT INTO dbo.EventLog VALUES(
			@Mensaje,
			(SELECT top (1) PostIdUser FROM EventLog ORDER BY id DESC),
			(SELECT @@SERVERNAME),
			GETDATE()
		);	
    END TRY
    BEGIN CATCH
            

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
    END CATCH;

    SET NOCOUNT OFF;
END;
