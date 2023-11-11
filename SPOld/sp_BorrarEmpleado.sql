CREATE OR ALTER PROCEDURE sp_BorrarEmpleado
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
			ValorTipoDocumento int
);
INSERT 
INTO @xmlTable 
	SELECT	   ValorTipoDocumento
FROM 
	OPENXML(@hDoc, 'Operacion/FechaOperacion/EliminarEmpleados/EliminarEmpleado') 
WITH  
(	Fecha date '../../@Fecha',
	ValorTipoDocumento int '@ValorTipoDocumento'
 )WHERE @fecha = Fecha;  
UPDATE dbo.Empleado
	SET Activo=0
	WHERE [Empleado].[ValorDocuIdentidad]=(Select ValorTipoDocumento FROM @xmlTable)
EXEC sp_xml_removedocument @hDoc