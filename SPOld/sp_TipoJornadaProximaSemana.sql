CREATE OR ALTER PROCEDURE sp_TipoJornadaProximaSemana 
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
		   IdTipoJornada int
);
INSERT 
INTO @xmlTable 
	SELECT ValorTipoDocumento,
		   IdTipoJornada
FROM 
	OPENXML(@hDoc, 'Operacion/FechaOperacion/JornadasProximaSemana/TipoJornadaProximaSemana') 
WITH  
(	Fecha date '../../@Fecha',
	ValorTipoDocumento int '@ValorTipoDocumento' ,
	IdTipoJornada int '@IdTipoJornada' 
 )WHERE @fecha = Fecha;  
INSERT 
	INTO dbo.TipoJornadaProximaSemana
	SELECT ValorTipoDocumento,
		   IdTipoJornada,
		   1
	FROM @xmlTable;  
EXEC sp_xml_removedocument @hDoc