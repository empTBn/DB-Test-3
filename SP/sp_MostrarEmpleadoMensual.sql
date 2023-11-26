CREATE OR ALTER   PROCEDURE [dbo].[sp_MostrarEmpleadoMes]
	@ValorDocId int,
    @output INT OUT -- Código de salida
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @MostrarTable TABLE (
		ValorTipoDocumento int,
		FechaMes DATE,
        Deducciones int,
		SalarioNeto int,
		SalarioBruto int,
		DeduccionesFijas int,
		DeduccionesPorc int,
		HorasNormales int,
		HorasExtras int,
		HorasDoble int,
		HoraExtraDoble int
        
    )

    BEGIN TRY
        -- Insert data into the table variable
        INSERT INTO @MostrarTable
        SELECT [ValorTipoDocumento]
			,[FechaMes]
			,[Deducciones]
			,[SalarioNeto]
			,[SalarioBruto]
			,[DeduccionesFijas]
			,[DeduccionPorc]
			,[HorasNormales]
			,[HorasExtras]
			,[HorasDoble]
			,[HoraExtraDoble]
        FROM EmpleadoPorMes 
		WHERE EmpleadoPorMes.ValorTipoDocumento=@ValorDocId

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