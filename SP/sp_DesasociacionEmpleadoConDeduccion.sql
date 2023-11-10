CREATE OR ALTER PROCEDURE sp_DesasociacionEmpleadoConDeduccion  
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
			ValorTipoDocumento int
);
INSERT 
INTO @xmlTable 
	SELECT idTipoDeduccion int,
		   ValorTipoDocumento int
FROM 
	OPENXML(@hDoc, 'Operacion/FechaOperacion/DesasociacionEmpleadoDeducciones/DesasociacionEmpleadoConDeduccion') 
WITH  
(	Fecha date '../../@Fecha',
	idTipoDeduccion int '@IdTipoDeduccion',
	ValorTipoDocumento int '@ValorTipoDocumento'
 )WHERE @fecha = Fecha;  
UPDATE dbo.AsociacionEmpleadoDeducciones
	SET Activado=0
	WHERE [AsociacionEmpleadoDeducciones].[idTipoDeduccion]=idTipoDeduccion
	AND [AsociacionEmpleadoDeducciones].[ValorTipoDocumento]=ValorTipoDocumento
EXEC sp_xml_removedocument @hDoc