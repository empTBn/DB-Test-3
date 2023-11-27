CREATE or ALTER   PROCEDURE [dbo].sp_AgregarEmpleadoIndividual
	@ValorDocId int, -- Valor documento de identidad
	@TipoValorDocId VARCHAR(128), --Tipo de documento
    @Nombre VARCHAR(128), -- Nombre del Empleado a agregar
	@Username varchar(128),
    @Password varchar(128),  -- Precio del articulo
    @Departamento VARCHAR(128),
	@Puesto VARCHAR(128),
    @output INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
	DECLARE @Mensaje varchar(64);

        -- Try inicial;
        

        -- Check if an article with the same name already exists
        IF EXISTS (SELECT 1 FROM dbo.Empleado A WHERE A.Nombre = @Nombre AND A.Activo=1)
        BEGIN	
			SET @Mensaje='ADD EMPLEADO PROCEDURE FAILURE, Reason: Name already exists'
			      
			SET @output = 2;  -- El codigo de resultado es 0 porque solo se modifica si se rechaza el 
        END
		IF EXISTS (SELECT 1 FROM dbo.Empleado A WHERE A.Usuario = @Username AND A.Activo=1)
        BEGIN	
			SET @Mensaje='ADD EMPLEADO PROCEDURE FAILURE, Reason: Usuario already exists'
		      
			SET @output = 2;  -- El codigo de resultado es 0 porque solo se modifica si se rechaza el 
        END

		IF EXISTS (SELECT 1 FROM dbo.Empleado A WHERE A.ValorDocuIdentidad = @ValorDocId AND A.Activo=1)
        BEGIN
			
			SET @Mensaje='ADD EMPLEADO PROCEDURE FAILURE, Reason: Valor de documento de identidad already exists'
			
			SET @output = 2;  -- El codigo de resultado es 2 porque solo se modifica si se rechaza el 
		END

		IF NOT EXISTS (SELECT 1 FROM Departamento A WHERE A.Nombre = @Departamento)
        BEGIN
			
			SET @Mensaje='ADD EMPLEADO PROCEDURE FAILURE, Reason: Departamento doesnt exists'
			SET @output = 1;  -- El codigo de resultado es 0 porque solo se modifica si se rechaza el 
			RETURN;
		END
		IF NOT EXISTS (SELECT 1 FROM Puesto A WHERE A.Nombre = @Puesto)
        BEGIN
			
			SET @Mensaje='ADD EMPLEADO PROCEDURE FAILURE, Reason: Puesto doesnt exists'
			SET @output = 1;  -- El codigo de resultado es 0 porque solo se modifica si se rechaza el 
			RETURN;
		END
		IF @output=0
		BEGIN
			INSERT
			INTO Empleado
			SELECT
				@Nombre,
				(SELECT id FROM TipoDocuIdentidad where Nombre=@TipoValorDocId),
				@ValorDocId,
				(SELECT id FROM Departamento where Nombre=@Departamento),
				(SELECT id FROM Puesto where Nombre=@Puesto),
				@Username,
				@Password,
				1
			SET @Mensaje='ADD EMPLEADO PROCEDURE SUCCESS, Reason: Puesto doesnt exists'
			SET @output=0
			Return;
		END
		INSERT INTO dbo.EventLog VALUES(
				@Mensaje,
				(SELECT top (1) PostIdUser FROM EventLog ORDER BY id DESC),
				(SELECT @@SERVERNAME),
				GETDATE()
		);	
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
        END;
    END CATCH;

    SET NOCOUNT OFF;
END;
