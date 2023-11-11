CREATE OR ALTER PROCEDURE sp_MarcaDeAsistencia
		@fecha Date
AS

DECLARE @XML AS XML,
        @hDoc AS INT, 
	    @SQL NVARCHAR (MAX)

SET @XML = (SELECT CONVERT(XML, BulkColumn) 
			 AS BulkColumn 
			 FROM OPENROWSET(BULK 'C:\Users\pablo\Downloads\OperacionesV2.xml', SINGLE_BLOB) AS x)
EXEC sp_xml_preparedocument @hDoc
OUTPUT, @XML
DECLARE @xmlTable
TABLE(
		   ValorTipoDocumento int,
		   FechaEntrada Date,
		   FechaSalida Date,
		   HoraEntrada Time,
		   HoraSalida Time
);
INSERT 
INTO @xmlTable 
	SELECT ValorTipoDocumento ,
		   FechaEntrada,
		   FechaSalida,
		   HoraEntrada ,
		   HoraSalida 
FROM 
	OPENXML(@hDoc, 'Operacion/FechaOperacion/MarcasAsistencia/MarcaDeAsistencia') 
WITH  
(	Fecha date '../../@Fecha',
	ValorTipoDocumento int '@ValorTipoDocumento' ,
	FechaEntrada Date '@HoraEntrada',
	FechaSalida Date '@HoraSalida',
	HoraEntrada Time '@HoraEntrada',
	HoraSalida Time '@HoraSalida'
 )WHERE @fecha = Fecha;  
INSERT 
	INTO dbo.MarcaDeAsistencia
	SELECT ValorTipoDocumento,
		   FechaEntrada,
		   FechaSalida,
		   HoraEntrada,
		   HoraSalida,
		   1
	FROM @xmlTable;  
EXEC sp_xml_removedocument @hDoc