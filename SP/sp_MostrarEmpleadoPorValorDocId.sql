CREATE OR ALTER   PROCEDURE [dbo].[sp_MostrarEmpleadoPorValorDocId]
	@ValorDocId int,
    @output INT OUT -- Código de salida
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @MostrarTable TABLE (
      TipoMoviento varchar(64) 
      ,Fecha date
      ,ValorDocId int
      ,Monto int
        
    )

    BEGIN TRY
        -- Insert data into the table variable
        INSERT INTO @MostrarTable
        SELECT 
			(Select Nombre FROM TipoDeMovimiento where id=IdTipoMoviento),
			Fecha,
			@ValorDocId,
			Monto
        FROM Movimientos 
		WHERE ValorDocId=@ValorDocId 
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