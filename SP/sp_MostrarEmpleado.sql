CREATE OR ALTER   PROCEDURE [dbo].[sp_MostrarEmpleadoSemanal]
	@ValorDocId int,
    @output INT OUT -- Código de salida
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
	SELECT [ValorTipoDocumento]
      ,[FechaInicio]
      ,[FechaFin]
      ,[Deducciones]
      ,[SalarioNeto]
      ,[SalarioBruto]
      ,[DeduccionesFijas]
      ,[DeduccionPorc]
      ,[HorasNormales]
      ,[HorasExtras]
      ,[HorasDoble]
      ,[HoraExtraDoble] FROM EmpleadoPorSemana
	  WHERE ValorTipoDocumento=@ValorDocId
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
