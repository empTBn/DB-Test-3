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
	DECLARE @IsDeduccion1 bit;
	DECLARE @IsDeduccion2 bit;
	DECLARE @IsDeduccion3 bit;
	DECLARE @IsDeduccion4 bit;
	DECLARE @IsDeduccion5 bit;
	DECLARE @IsDeduccion6 bit;
	SET @IsDeduccion1=0;
	SET @IsDeduccion2=0;
	SET @IsDeduccion3=0;
	SET @IsDeduccion4=0;
	SET @IsDeduccion5=0;
	SET @IsDeduccion6=0;
	
	DECLARE @SumaFijos int;  -- Guardar la suma de las deducciones fijas
	DECLARE @SumaPorc Float; -- deducciones porcentuales

	SET @idPuesto=(Select idPuesto FROM Empleado Where ValorDocuIdentidad=@ValorDocId );
	SET @SalarioXHora=(Select SalarioXHora FROM Puesto WHERE id=@idPuesto);
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
			SET @HoraInicio=(SELECT TOP 1 HoraEntrada FROM MarcaDeAsistencia WHERE FechaEntrada=@primerafecha AND ValorTipoDocumento=@ValorDocId);
			SET @HoraFin=(SELECT TOP 1HoraSalida FROM MarcaDeAsistencia WHERE FechaEntrada=@primerafecha AND ValorTipoDocumento=@ValorDocId);
			SET @HorasTrabajadas=(@HorasTrabajadas+(DATEDIFF(hour, @HoraInicio, @HoraFin)));
			IF (@HorasTrabajadas<0)
				BEGIN
				SET @HorasTrabajadas=(24+@HorasTrabajadas);
				END
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
							print @HorasTrabajadas
							SET @HorasExtraDoble=@HorasExtraDoble+(@HorasTrabajadas-8);
							SET @HorasDoble=@HorasDoble+8;
							SET @HorasTrabajadas=0;
						END
						ELSE
							BEGIN
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
	if exists (Select idTipoDeduccion from AsociacionEmpleadoDeducciones where ValorTipoDocumento=@ValorDocId AND IdTipoDeduccion=4)
		BEGIN
			SET @IsDeduccion4=1;
		END
	if exists (Select idTipoDeduccion from AsociacionEmpleadoDeducciones where ValorTipoDocumento=@ValorDocId AND IdTipoDeduccion=5)
		BEGIN
			SET @IsDeduccion5=1;
		END
	if exists (Select idTipoDeduccion from AsociacionEmpleadoDeducciones where ValorTipoDocumento=@ValorDocId AND IdTipoDeduccion=6)
		BEGIN
			SET @IsDeduccion6=1;
		END
	--Deducciones Porcentuales totales --
	if exists (Select idTipoDeduccion from AsociacionEmpleadoDeducciones where ValorTipoDocumento=@ValorDocId AND IdTipoDeduccion=1)
		BEGIN
			SET @SumaPorc= @SumaPorc+9.5;
			SET @IsDeduccion1=1;
		END
	if exists (Select idTipoDeduccion from AsociacionEmpleadoDeducciones where ValorTipoDocumento=@ValorDocId AND IdTipoDeduccion=2)
		BEGIN
			SET @SumaPorc= @SumaPorc+5;
			SET @IsDeduccion2=1;
		END
	if exists (Select idTipoDeduccion from AsociacionEmpleadoDeducciones where ValorTipoDocumento=@ValorDocId AND IdTipoDeduccion=1)
		BEGIN
			SET @SumaPorc= @SumaPorc+4.17;
			SET @IsDeduccion3=1;
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
		SET @IsDeduccion4=0;
		SET @IsDeduccion5=0;
		SET @IsDeduccion6=0;
		END
	IF (@SalarioBruto=0)
		BEGIN
		SET @SumaFijos=0;
		SET @IsDeduccion1=0;
		SET @IsDeduccion2=0;
		SET @IsDeduccion3=0;
		SET @IsDeduccion4=0;
		SET @IsDeduccion5=0;
		SET @IsDeduccion6=0;
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

	IF(@HorasNormales>0)
	BEGIN
		INSERT INTO Movimientos
		SELECT
			1,
			@Fecha,
			@ValorDocId,
			(@HorasNormales*@SalarioXHora)
	END
	IF(@HorasExtra>0)
	BEGIN
		INSERT INTO Movimientos
		SELECT
			2,
			@Fecha,
			@ValorDocId,
			(@HorasExtra*@SalarioXHora*1.5)
	END
	IF(@HorasExtraDoble>0)
	BEGIN
		INSERT INTO Movimientos
		SELECT
			3,
			@Fecha,
			@ValorDocId,
			(@HorasExtraDoble*@SalarioXHora*3)
	END
	IF (@IsDeduccion1=1)
	BEGIN
		INSERT INTO Movimientos
		SELECT
			4,
			@Fecha,
			@ValorDocId,
			(@SalarioBruto*9.5)/100
	END

	IF (@IsDeduccion2=1)
	BEGIN
	INSERT INTO Movimientos
		SELECT
			5,
			@Fecha,
			@ValorDocId,
			(@SalarioBruto*5)/100
	END

	IF (@IsDeduccion3=1)
	BEGIN
	INSERT INTO Movimientos
		SELECT
			4,
			@Fecha,
			@ValorDocId,
			(@SalarioBruto*4.17)/100
	END
	IF (@IsDeduccion4=1)
	BEGIN
	INSERT INTO Movimientos
		SELECT
			5,
			@Fecha,
			@ValorDocId,
			(SELECT monto FROM AsociacionEmpleadoDeducciones WHERE ValorTipoDocumento=@ValorDocId AND IdTipoDeduccion=4)
	END

	IF (@IsDeduccion5=1)
	BEGIN
	INSERT INTO Movimientos
		SELECT
			5,
			@Fecha,
			@ValorDocId,
			(SELECT monto FROM AsociacionEmpleadoDeducciones WHERE ValorTipoDocumento=@ValorDocId AND IdTipoDeduccion=5)
	END

	IF (@IsDeduccion6=1)
	BEGIN
	INSERT INTO Movimientos
		SELECT
			5,
			@Fecha,
			@ValorDocId,
			(SELECT monto FROM AsociacionEmpleadoDeducciones WHERE ValorTipoDocumento=@ValorDocId AND IdTipoDeduccion=6)
	END