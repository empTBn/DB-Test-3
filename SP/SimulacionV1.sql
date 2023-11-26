DECLARE @primerafecha DATE;
DECLARE @FechaMes DATE;
DECLARE @ultimafecha DATE;
DECLARE @Jueves int;
DECLARE @Semana int;
DECLARE @Semana_aux int;
SET @Semana=0;
SET @Semana_aux=0;
SET @Jueves=0;
SET @primerafecha='2023-10-19';
SET @FechaMes='2023-10-06';
SET @ultimafecha='2023-11-30';
WHILE (@primerafecha <= @ultimafecha)
BEGIN
	PRINT @Primerafecha;
	EXEC sp_AgregarEmpleado @primerafecha;
	EXEC sp_BorrarEmpleado @primerafecha;
	EXEC sp_AsociacionEmpleadoDeducciones @primerafecha;
	EXEC sp_DesasociacionEmpleadoConDeduccion @primerafecha;
	EXEC sp_MarcaDeAsistencia @primerafecha;
	EXEC sp_TipoJornadaProximaSemana @primerafecha;

	IF(DATEPART(WEEKDAY, @primerafecha)=4 AND @Jueves>0)
	BEGIN
		DECLARE @Variable int;
		SET @Variable=1;
		IF(@Semana=0)
		BEGIN
			SET @Semana=1
			SET @Semana_aux=0
		END
		IF(@Semana=1)
		BEGIN
			SET @Semana=2
		END
		IF(@Semana=2)
		BEGIN
			SET @Semana=0
			SET @Semana_aux=1
		END
		DECLARE @Valor int;
		While (SELECT ValorDocuIdentidad from Empleado where Id=@Variable AND Activo=1) is not null
			BEGIN
			SET @Valor=(SELECT ValorDocuIdentidad from Empleado where Id=@Variable AND Activo=1);
			EXEC sp_CalculoSemanalEmp @primerafecha,@Valor,@Semana_aux
			SET @Variable=@Variable+1;
			IF((SELECT DATEPART(MONTH,@FechaMes))<(SELECT DATEPART(MONTH,@primerafecha)))
			BEGIN
				EXEC sp_CalculoMensual @FechaMes,@primerafecha,@Valor
			END
			END
			SET @Variable=0;
			SET @Jueves=@Jueves+1;

			
	END
	IF(DATEPART(WEEKDAY, @primerafecha)=4 AND @Jueves=0)
	BEGIN
		SET @Jueves=@Jueves+1;
	END
	IF((SELECT DATEPART(MONTH,@FechaMes))<(SELECT DATEPART(MONTH,@primerafecha))AND DATEPART(WEEKDAY, @primerafecha)=4 AND @Jueves>0)
			BEGIN
				SET @FechaMes= DATEADD(month, 1 , @FechaMes)
			END
	SET @primerafecha = dateadd(day, 1 , @primerafecha);
END
