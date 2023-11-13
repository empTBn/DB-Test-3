CREATE OR ALTER PROCEDURE sp_CalculoSemanalEmp
	@Fecha DATE,
	@ValorDocId int
AS
	DECLARE @primerafecha DATE;
	DECLARE @HorasTrabajadas int;
	DECLARE @HorasNormales int;
	DECLARE @HorasExtra int;
	DECLARE @HorasDoble int;
	DECLARE @HorasExtraDoble int;
	DECLARE @SalarioBruto int;
	DECLARE @Deducciones int;
	DECLARE @SalarioXHora int;
	DECLARE @idPuesto int;
	DECLARE @HoraInicio time;
	DECLARE @HoraFin time;

	SET @idPuesto=(Select idPuesto FROM Empleado Where ValorDocuIdentidad=@ValorDocId );
	SET @SalarioXHora=(Select SalarioXHora FROM Puesto WHERE id=@idPuesto);


	SET @primerafecha=@Fecha;
	SET @primerafecha = dateadd(day, -6 , @primerafecha);
	WHILE (@primerafecha <= @Fecha)
		BEGIN
			SET @HoraInicio=(SELECT HoraEntrada FROM MarcaDeAsistencia WHERE FechaEntrada=@primerafecha AND ValorTipoDocumento=@ValorDocId);
			SET @HoraFin=(SELECT HoraSalida FROM MarcaDeAsistencia WHERE FechaEntrada=@primerafecha AND ValorTipoDocumento=@ValorDocId);
			SET @HorasTrabajadas=@HorasTrabajadas+DATEDIFF(HOUR,@HoraInicio,@HoraFin);
			IF EXISTS (SELECT 1 FROM Feriado WHERE @primerafecha=@Fecha)
			   --Es un feriado
			   BEGIN
					IF(@HorasTrabajadas>8)
						BEGIN
							SET @HorasExtraDoble=@HorasExtraDoble+(@HorasTrabajadas-8);
							SET @HorasTrabajadas=@HorasTrabajadas-(@HorasTrabajadas-8);
							SET @HorasDoble=@HorasDoble+@HorasTrabajadas;
						END
						ELSE
							BEGIN
								SET @HorasDoble=@HorasDoble+@HorasTrabajadas;
							END

			   END
			IF (DATEPART(WEEKDAY, @primerafecha)=7)
			   --Es un Domingo
			   BEGIN
					IF(@HorasTrabajadas>8)
						BEGIN
							SET @HorasExtraDoble=@HorasExtraDoble+(@HorasTrabajadas-8);
							SET @HorasTrabajadas=@HorasTrabajadas-(@HorasTrabajadas-8);
							SET @HorasDoble=@HorasDoble+@HorasTrabajadas;
						END
						ELSE
							BEGIN
								SET @HorasDoble=@HorasDoble+@HorasTrabajadas;
							END
			   END
			IF NOT EXISTS (SELECT 1 FROM Feriado WHERE @primerafecha=@Fecha) AND NOT (DATEPART(WEEKDAY, @primerafecha)=7)
				BEGIN
					IF(@HorasTrabajadas>8)
						BEGIN
							SET @HorasExtra=@HorasExtra+(@HorasTrabajadas-8);
							SET @HorasTrabajadas=@HorasTrabajadas-(@HorasTrabajadas-8);
							SET @HorasNormales=@HorasNormales+@HorasTrabajadas;
						END
						ELSE
							BEGIN
								SET @HorasNormales=@HorasNormales+@HorasTrabajadas;
							END
				END
		END
	--Todas las horas trabajadas fueron calculadas
	SET @SalarioBruto=(@HorasNormales*@SalarioXHora)+
					  (@HorasDoble*(@SalarioXHora*2))+
					  (@HorasExtra*(@SalarioXHora*1.5))+
					  (@HorasExtraDoble*(@SalarioXHora*3));


