CREATE OR ALTER PROCEDURE [dbo].[sp_Login] 
    @Usuario VARCHAR(64), --Nombre del usuario
    @Password VARCHAR(64), --Contraseña del usuario
    @output INT OUT	-- Codigo de resultado el cual su uso saber si el usuario entra o no
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        SET @output = 0;  -- El codigo de resultado es 0 porque solo se modifica si se rechaza el 

        IF EXISTS (SELECT id FROM dbo.Empleado A WHERE A.Usuario = @Usuario AND A.Password = @Password)
        BEGIN
            --En caso de que el usuario y la contraseña coincidan
            SET @output = 1;
            INSERT INTO dbo.EventLog VALUES(
                ('LOGIN PROCEDURE EMPLEADO SUCCESS'),
                (SELECT id FROM dbo.Empleado A WHERE A.Usuario = @Usuario AND A.Password = @Password),
                (SELECT @@SERVERNAME),
                GETDATE()
            );
            -- Redirect a admin o empleado basado en la verificacion

		END
		IF EXISTS (SELECT id FROM dbo.Usuario WHERE UserName = @Usuario)
		BEGIN 
			SET @output = 2;
            INSERT INTO dbo.EventLog VALUES(
                ('LOGIN PROCEDURE ADMIN SUCCESS'),
                (SELECT id FROM dbo.Empleado A WHERE A.Usuario = @Usuario AND A.Password = @Password),
                (SELECT @@SERVERNAME),
                GETDATE()
            );
		END
        ELSE
        BEGIN
            INSERT INTO dbo.EventLog VALUES(
                ('LOGIN PROCEDURE FAILED'),
                (SELECT id FROM dbo.Empleado A WHERE A.Usuario = @Usuario AND A.Password = @Password),
                (SELECT @@SERVERNAME),
                GETDATE()
            );
            -- Return some failure status if needed
        END
    
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
    END CATCH

    SET NOCOUNT OFF;
END;
