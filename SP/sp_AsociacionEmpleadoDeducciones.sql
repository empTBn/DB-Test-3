CREATE OR ALTER PROCEDURE sp_AsociacionEmpleadoDeducciones 
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
			idTipoDeduccion int,
			ValorTipoDocumento int,
			Monto int
);
INSERT 
INTO @xmlTable 
	SELECT idTipoDeduccion int,
		   ValorTipoDocumento int,
		   Monto int
FROM 
	OPENXML(@hDoc, 'Operacion/FechaOperacion/AsociacionEmpleadoDeducciones/AsociacionEmpleadoConDeduccion') 
WITH  
(	Fecha date '../../@Fecha',
	idTipoDeduccion int '@IdTipoDeduccion',
	ValorTipoDocumento int '@ValorTipoDocumento',
	Monto int '@Monto'
 )WHERE @fecha = Fecha;  
INSERT 
	INTO dbo.AsociacionEmpleadoDeducciones
	SELECT idTipoDeduccion,
		   ValorTipoDocumento,
		   Monto,
		   1
	FROM @xmlTable;  
EXEC sp_xml_removedocument @hDoc