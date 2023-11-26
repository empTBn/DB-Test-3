USE [Tarea3]
GO
/****** Object:  StoredProcedure [dbo].[sp_Login]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE or ALTER PROCEDURE [dbo].[sp_Login] 
	@Usuario VARCHAR(64), --Nombre del usuario
	@Password VARCHAR(64), --Contraseña del usuario
	@output INT OUT	-- Codigo de resultado el cual su uso saber si el usuario entra o no
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY

		-- Try inicial;
			SET @output=0;  -- El codigo de resultado es 0 porque solo se modifica si se rechaza el 

			IF EXISTS (SELECT id FROM dbo.Empleado A WHERE A.Usuario=@Usuario AND A.Password=@Password)
			BEGIN
			--En caso de que el usuario y la contraseña y coincidan
			SET @output=1;
			INSERT INTO dbo.EventLog VALUES(
				('LOGIN PROCEDURE SUCCESS'),
				(SELECT id FROM dbo.Empleado A WHERE A.Usuario=@Usuario AND A.Password=@Password),
				(SELECT @@SERVERNAME),
				GETDATE()
		);    
			RETURN;
			END; 
		INSERT INTO dbo.EventLog VALUES(
			('LOGIN PROCEDURE FAILLED'),
			(SELECT id FROM dbo.Empleado A WHERE A.Usuario=@Usuario AND A.Password=@Password),
			(SELECT @@SERVERNAME),
			GETDATE()
		);    
    -- Falta que determine si es admin o empleado
	
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT>0


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

	END CATCH

	SET NOCOUNT OFF;
END;