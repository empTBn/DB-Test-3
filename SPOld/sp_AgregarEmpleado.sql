CREATE OR ALTER PROCEDURE sp_AgregarEmpleado 
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
			Nombre VARCHAR(64),
			idTipoDocumento int,
			ValorTipoDocumento int,
			IdDepartamento int,
			IdPuesto int,
			Usuario varchar (64),
			Password varchar (64)
);
INSERT 
INTO @xmlTable 
	SELECT Nombre,
		   idTipoDocumento,
		   ValorTipoDocumento,
		   IdDepartamento,
		   IdPuesto,
		   Usuario,
		   Password
FROM 
	OPENXML(@hDoc, 'Operacion/FechaOperacion/NuevosEmpleados/NuevoEmpleado') 
WITH  
(	Fecha date '../../@Fecha',
	Nombre VARCHAR(64) '@Nombre',
	idTipoDocumento int '@IdTipoDocumento',
	ValorTipoDocumento int '@ValorTipoDocumento',
	IdDepartamento int '@IdDepartamento',
	IdPuesto int '@IdPuesto',
	Usuario varchar (64) '@Usuario',
	Password varchar (64) '@Password'
 )WHERE @fecha = Fecha;  
INSERT 
	INTO dbo.Empleado
	SELECT Nombre,
		   idTipoDocumento,
		   ValorTipoDocumento,
		   IdDepartamento,
		   IdPuesto,
		   Usuario,
		   Password,
		   1
	FROM @xmlTable;  
EXEC sp_xml_removedocument @hDoc 