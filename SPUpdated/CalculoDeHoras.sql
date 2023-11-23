CREATE OR ALTER PROCEDURE sp_CalculoSemanalEmp
	@Fecha DATE,
	@ValorDocId int,
	@TipoDeMes bit
AS
	DECLARE @primerafecha DATE;
	DECLARE @HorasTrabajadas int;
	DECLARE @HorasNormales int;
	DECLARE @HorasExtra int;
	DECLARE @HorasDoble int;
	DECLARE @HorasExtraDoble int;
	DECLARE @SalarioBruto int;
	DECLARE @SalarioNeto int;
	DECLARE @Deducciones int;
	DECLARE @IdDeduccion int;
	DECLARE @SalarioXHora int;
	DECLARE @idPuesto int;
	DECLARE @HoraInicio time;
	DECLARE @HoraFin time;
	DECLARE @FechaInicio Date;
	DECLARE @FechaFin Date;
	
	DECLARE @SumaFijos int;  -- Guardar la suma de las deducciones fijas
	DECLARE @SumaPorc Float; -- deducciones porcentuales

	SET @idPuesto=(Select idPuesto FROM Empleado Where ValorDocuIdentidad=@ValorDocId );
	SET @SalarioXHora=(Select SalarioXHora FROM Puesto WHERE id=@idPuesto);
	PRINT @SalarioXHora;
	SET @HorasTrabajadas=0;
	SET @HorasTrabajadas=0;
	SET @HorasExtra=0;
	SET @HorasExtraDoble=0;
	SET @HorasDoble=0;
	SET @HorasNormales=0;
	SET @SumaFijos=0;
	SET @SumaPorc=0;
	Set @Deducciones=0
	SET @primerafecha=@Fecha;
	SET @FechaFin=@Fecha;
	SET @primerafecha = dateadd(day, -6 , @primerafecha);
	SET @FechaInicio=@primerafecha
	WHILE (@primerafecha <= @Fecha)
		BEGIN
			IF NOT EXISTS (SELECT HoraEntrada FROM MarcaDeAsistencia WHERE FechaEntrada=@primerafecha AND ValorTipoDocumento=@ValorDocId)
				BEGIN
				SET @primerafecha = dateadd(day, 1 , @primerafecha);
				END
				ELSE
				BEGIN
			SET @HoraInicio=(SELECT HoraEntrada FROM MarcaDeAsistencia WHERE FechaEntrada=@primerafecha AND ValorTipoDocumento=@ValorDocId);

			SET @HoraFin=(SELECT HoraSalida FROM MarcaDeAsistencia WHERE FechaEntrada=@primerafecha AND ValorTipoDocumento=@ValorDocId);

			SET @HorasTrabajadas=(@HorasTrabajadas+(DATEDIFF(hour, @HoraInicio, @HoraFin)));
			IF (@HorasTrabajadas<0)
				BEGIN
				SET @HorasTrabajadas=(24+@HorasTrabajadas);
				END
			print @primerafecha
			IF EXISTS (SELECT 1 FROM Feriado WHERE Fecha=@primerafecha)
			   --Es un feriado
			   BEGIN
					IF(@HorasTrabajadas>8)
						BEGIN
							SET @HorasExtraDoble=@HorasExtraDoble+(@HorasTrabajadas-8);
							SET @HorasDoble=@HorasDoble+8;
							SET @HorasTrabajadas=0;
						END
						ELSE
							BEGIN
								SET @HorasDoble=@HorasDoble+@HorasTrabajadas;
								SET @HorasTrabajadas=0;
							END

			   END
			IF (DATEPART(WEEKDAY, @primerafecha)=7)
			   --Es un Domingo
			   BEGIN
					IF(@HorasTrabajadas>8)
						BEGIN
							Print 'Hora extra doble domingo'
							print @HorasTrabajadas
							SET @HorasExtraDoble=@HorasExtraDoble+(@HorasTrabajadas-8);
							SET @HorasDoble=@HorasDoble+8;
							SET @HorasTrabajadas=0;
						END
						ELSE
							BEGIN
								Print 'Hora doble domingo'
								print @HorasTrabajadas
								SET @HorasDoble=@HorasDoble+@HorasTrabajadas;
								SET @HorasTrabajadas=0;
							END
			   END
			IF NOT EXISTS (SELECT 1 FROM Feriado WHERE Fecha=@primerafecha) AND NOT (DATEPART(WEEKDAY, @primerafecha)=7)
				BEGIN
					IF(@HorasTrabajadas>8)
						BEGIN
							
							SET @HorasExtra=@HorasExtra+(@HorasTrabajadas-8);
							SET @HorasNormales=@HorasNormales+8;
							SET @HorasTrabajadas=0;
						END
						ELSE
							BEGIN
								SET @HorasNormales=@HorasNormales+@HorasTrabajadas;
								SET @HorasTrabajadas=0;
							END
				END
			SET @primerafecha = dateadd(day, 1 , @primerafecha);
			
			END
		END
	--Todas las horas trabajadas fueron calculadas
	SET @SalarioBruto=(@HorasNormales*@SalarioXHora)+
					  (@HorasDoble*(@SalarioXHora*2))+
					  (@HorasExtra*(@SalarioXHora*1.5))+
					  (@HorasExtraDoble*(@SalarioXHora*3));

	--Deducciones fijas totales--
	SET @SumaFijos= (SELECT Sum(MONTO) 
	FROM AsociacionEmpleadoDeducciones 
	WHERE ([IdTipoDeduccion]=4 or [IdTipoDeduccion]=5 or [IdTipoDeduccion]=6) AND [ValorTipoDocumento]=@ValorDocId)

	--Deducciones Porcentuales totales --
	if exists (Select idTipoDeduccion from AsociacionEmpleadoDeducciones where ValorTipoDocumento=@ValorDocId AND IdTipoDeduccion=1)
		BEGIN
			SET @SumaPorc= @SumaPorc+9.5
		END
	if exists (Select idTipoDeduccion from AsociacionEmpleadoDeducciones where ValorTipoDocumento=@ValorDocId AND IdTipoDeduccion=2)
		BEGIN
			SET @SumaPorc= @SumaPorc+5
		END
	if exists (Select idTipoDeduccion from AsociacionEmpleadoDeducciones where ValorTipoDocumento=@ValorDocId AND IdTipoDeduccion=1)
		BEGIN
			SET @SumaPorc= @SumaPorc+4.17
		END
	SET @SumaPorc=(@SalarioBruto*(@SumaPorc/100))



	IF (@TipoDeMes=1)
	BEGIN
		SET @SumaFijos=@SumaFijos/5
	END
	ELSE
	BEGIN
		SET @SumaFijos=@SumaFijos/4
	END
	PRINT @SumaFijos;
	IF (@SumaFijos IS NULL)
		BEGIN
		SET @SumaFijos=0;
		END
	IF (@SalarioBruto=0)
		BEGIN
		SET @SumaFijos=0;
		END
	SET @Deducciones=@SumaFijos+@SumaPorc

	SET @SalarioNeto=@SalarioBruto-@Deducciones


	INSERT INTO EmpleadoPorSemana
	 SELECT	@ValorDocId,
			@FechaInicio,
			@FechaFin,
			@Deducciones,
			@SalarioNeto,
			@SalarioBruto,
			@SumaFijos,
			@SumaPorc,
			@HorasNormales,
			@HorasExtra,
			@HorasDoble,
			@HorasExtraDoble



