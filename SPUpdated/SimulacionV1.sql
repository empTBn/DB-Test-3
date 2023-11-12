DECLARE @primerafecha DATE;
DECLARE @ultimafecha DATE;

SET @primerafecha='2023-07-06';
SET @ultimafecha='2023-07-13';

WHILE (@primerafecha <= @ultimafecha)
BEGIN
	PRINT @Primerafecha;
	EXEC sp_AgregarEmpleado @primerafecha;
	EXEC sp_BorrarEmpleado @primerafecha;
	EXEC sp_AsociacionEmpleadoDeducciones @primerafecha;
	EXEC sp_MarcaDeAsistencia @primerafecha;
	EXEC sp_TipoJornadaProximaSemana @primerafecha;

	SET @primerafecha = dateadd(day, 1 , @primerafecha);
END