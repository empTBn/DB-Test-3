CREATE OR ALTER PROCEDURE sp_CalculoMensual
	@Mes DATE,
	@Fecha DATE,
	@ValorDocId int
AS
	DECLARE @HorasNormales int;
	DECLARE @HorasExtra int;
	DECLARE @HorasDoble int;
	DECLARE @HorasExtraDoble int;
	DECLARE @SalarioBruto int;
	DECLARE @SalarioNeto int;
	DECLARE @DeduccionesT int;
	DECLARE @DeduccionesF int;
	DECLARE @DeduccionesP int;

	SET @HorasNormales= (SELECT Sum(HorasNormales) 
	FROM EmpleadoPorSemana
	WHERE (ValorTipoDocumento=@ValorDocId) AND (SELECT DATEPART(MONTH,FechaInicio))=(SELECT DATEPART(MONTH,@Mes)))

	SET @HorasExtra= (SELECT Sum(HorasExtras) 
	FROM EmpleadoPorSemana
	WHERE (ValorTipoDocumento=@ValorDocId) AND (SELECT DATEPART(MONTH,FechaInicio))=(SELECT DATEPART(MONTH,@Mes)))

	SET @HorasDoble= (SELECT Sum(HorasDoble) 
	FROM EmpleadoPorSemana 
	WHERE (ValorTipoDocumento=@ValorDocId) AND (SELECT DATEPART(MONTH,FechaInicio))=(SELECT DATEPART(MONTH,@Mes)))

	SET @HorasExtraDoble= (SELECT Sum(HoraExtraDoble) 
	FROM EmpleadoPorSemana 
	WHERE (ValorTipoDocumento=@ValorDocId) AND (SELECT DATEPART(MONTH,FechaInicio))=(SELECT DATEPART(MONTH,@Mes)))

	SET @SalarioBruto= (SELECT Sum(SalarioBruto) 
	FROM EmpleadoPorSemana
	WHERE (ValorTipoDocumento=@ValorDocId) AND (SELECT DATEPART(MONTH,FechaInicio))=(SELECT DATEPART(MONTH,@Mes)))

	SET @SalarioNeto= (SELECT Sum(SalarioNeto) 
	FROM EmpleadoPorSemana
	WHERE (ValorTipoDocumento=@ValorDocId) AND (SELECT DATEPART(MONTH,FechaInicio))=(SELECT DATEPART(MONTH,@Mes)))

	SET @DeduccionesP= (SELECT Sum(DeduccionPorc) 
	FROM EmpleadoPorSemana
	WHERE (ValorTipoDocumento=@ValorDocId) AND (SELECT DATEPART(MONTH,FechaInicio))=(SELECT DATEPART(MONTH,@Mes)))

	SET @DeduccionesF= (SELECT Sum(DeduccionesFijas) 
	FROM EmpleadoPorSemana 
	WHERE (ValorTipoDocumento=@ValorDocId) AND (SELECT DATEPART(MONTH,FechaInicio))=(SELECT DATEPART(MONTH,@Mes)))

	SET @DeduccionesT= (SELECT Sum(Deducciones) 
	FROM EmpleadoPorSemana 
	WHERE (ValorTipoDocumento=@ValorDocId) AND (SELECT DATEPART(MONTH,FechaInicio))=(SELECT DATEPART(MONTH,@Mes)))

	INSERT INTO EmpleadoPorMes
		SELECT	@ValorDocId,
				@Fecha,
				@DeduccionesT,
				@SalarioNeto,
				@SalarioBruto,
				@DeduccionesF,
				@DeduccionesP,
				@HorasNormales,
				@HorasExtra,
				@HorasDoble,
				@HorasExtraDoble
