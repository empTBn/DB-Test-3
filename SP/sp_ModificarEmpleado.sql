CREATE or ALTER     PROCEDURE [dbo].[SP_ModificarEmpleado]
	@NombreE VARCHAR(128), -- Nombre del Empleado a agregar
	@ValorDocId int, -- Valor documento de identidad
	@TipoValorDocId VARCHAR(128), --Tipo de documento
    @NombreS VARCHAR(128), -- Nombre del Empleado a agregar
	@Username varchar(128),
	@Password varchar(128),
    @Departamento VARCHAR(128),
	@Puesto VARCHAR(128),
    @output INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @Mensaje varchar(64);
	SET @output=0;
    BEGIN TRY
        -- Try inicial;
        

        -- Check if an Empleado with the same name doesnt  exists
        IF NOT EXISTS (SELECT 1 FROM dbo.Empleado A WHERE A.Nombre = @NombreE AND A.Activo=1)
        BEGIN		
			SET @Mensaje='MODIFY PROCEDURE FAILURE, Reason: Name doesnt exists' 
			SET @output = 2;  -- El codigo de resultado es 0 porque solo se modifica si se rechaza el 
        END
		IF NOT EXISTS (SELECT 1 FROM dbo.Departamento A WHERE A.Nombre = @Departamento)
        BEGIN
			SET @Mensaje='MODIFY ARTICULO PROCEDURE FAILURE, Reason: Departamento doesnt exists' 
			SET @output = 1;  -- El codigo de resultado es 0 porque solo se modifica si se rechaza el 
		END
		IF NOT EXISTS (SELECT 1 FROM dbo.Puesto A WHERE A.Nombre = @Puesto)
        BEGIN
			SET @Mensaje='MODIFY ARTICULO PROCEDURE FAILURE, Reason: Puesto doesnt exists' 
			SET @output = 1;  -- El codigo de resultado es 0 porque solo se modifica si se rechaza el 
		END
		IF NOT EXISTS (SELECT 1 FROM dbo.TipoDocuIdentidad A WHERE A.Nombre = @TipoValorDocId)
        BEGIN
			SET @Mensaje='MODIFY ARTICULO PROCEDURE FAILURE, Reason: Tipo de documento de identidad doesnt exists' 
			SET @output = 1;  -- El codigo de resultado es 0 porque solo se modifica si se rechaza el 
		END
		IF EXISTS (SELECT 1 FROM dbo.Empleado A WHERE A.Nombre = @NombreS AND A.Activo=1)
        BEGIN		
			SET @Mensaje='MODIFY PROCEDURE FAILURE, Reason: Name to be modify already exists'   
			SET @output = 3;  -- El codigo de resultado es 0 porque solo se modifica si se rechaza el 
        END
		IF EXISTS (SELECT 1 FROM dbo.Empleado A WHERE A.Usuario = @Username AND A.Activo=1)
        BEGIN		
			SET @Mensaje='MODIFY PROCEDURE FAILURE, Reason: Usuario to be modify already exists'   
			SET @output = 3;  -- El codigo de resultado es 0 porque solo se modifica si se rechaza el 
        END
		IF EXISTS (SELECT 1 FROM dbo.Empleado A WHERE A.ValorDocuIdentidad = @ValorDocId AND A.Activo=1)
        BEGIN		
			SET @Mensaje='MODIFY PROCEDURE FAILURE, Reason: Valor del documento de identidad to be modify already exists'  
			SET @output = 4;  -- El codigo de resultado es 0 porque solo se modifica si se rechaza el 
        END
		IF @output=0
		BEGIN
			SET @Mensaje='MODIFY PROCEDURE SUCCESS'  
			UPDATE Empleado
			SET 
				ValorDocuIdentidad=@ValorDocId,
				TipoDocuIdentidad=(Select id FROM TipoDocuIdentidad WHERE Nombre=@TipoValorDocId),
				Nombre=@NombreS,
				IdDepartamento=(Select id FROM Departamento WHERE Nombre=@Departamento),
				IdPuesto=(Select id FROM Puesto WHERE Nombre=@Puesto),
				Usuario=@Username,
				Password=@Password
			WHERE Nombre=@NombreE
			SET @output=0
		END
		INSERT INTO dbo.EventLog VALUES(
				@Mensaje,
				(SELECT top (1) PostIdUser FROM EventLog ORDER BY id DESC),
				(SELECT @@SERVERNAME),
				GETDATE()
		); 
    END TRY
    BEGIN CATCH
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