DECLARE @primerafecha DATE;
DECLARE @ultimafecha DATE;
DECLARE @Jueves int;
SET @Jueves=0;
SET @primerafecha='2023-07-06';
SET @ultimafecha='2023-07-27';

WHILE (@primerafecha <= @ultimafecha)
BEGIN
	PRINT @Primerafecha;
	EXEC sp_AgregarEmpleado @primerafecha;
	EXEC sp_BorrarEmpleado @primerafecha;
	EXEC sp_AsociacionEmpleadoDeducciones @primerafecha;
	EXEC sp_MarcaDeAsistencia @primerafecha;
	EXEC sp_TipoJornadaProximaSemana @primerafecha;

	IF(DATEPART(WEEKDAY, @primerafecha)=4 AND @Jueves>0)
	BEGIN
		DECLARE @Variable int;
		SET @Variable=1;
		DECLARE @Valor int;
		While (SELECT ValorDocuIdentidad from Empleado where Id=@Variable) is not null
			BEGIN
			SET @Valor=(SELECT ValorDocuIdentidad from Empleado where Id=@Variable);
			EXEC sp_CalculoSemanalEmp @primerafecha,@Valor,0
			SET @Variable=@Variable+1;
			END
			SET @Variable=0;
			SET @Jueves=@Jueves+1;
	END
	IF(DATEPART(WEEKDAY, @primerafecha)=4 AND @Jueves=0)
	BEGIN
		SET @Jueves=@Jueves+1;
	END
	SET @primerafecha = dateadd(day, 1 , @primerafecha);
END
