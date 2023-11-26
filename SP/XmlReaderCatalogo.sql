
--|XML Reader for TiposdeDocumentodeIdentidad|--
GO
DECLARE @XML AS XML,
        @hDoc AS INT, 
	    @SQL NVARCHAR (MAX)

SET @XML = (SELECT CONVERT(XML, BulkColumn) 
			 AS BulkColumn 
			 FROM OPENROWSET(BULK 'C:\Users\pablo\Downloads\Catalogo.xml', SINGLE_BLOB) AS x)
EXEC sp_xml_preparedocument @hDoc
OUTPUT, @XML
DECLARE @xmlTable
TABLE(
			Id int,
			Nombre VARCHAR (64)
);
INSERT 
INTO @xmlTable 
	SELECT	Id,
			Nombre
FROM 
	OPENXML(@hDoc, 'Catalogos/TiposdeDocumentodeIdentidad/TipoDocuIdentidad') 
WITH  
(	
	Id int '@Id	',
	Nombre varchar(64) '@Nombre'
 );  
INSERT 
	INTO dbo.TipoDocuIdentidad
	SELECT Nombre,
		   1
	FROM @xmlTable;  
EXEC sp_xml_removedocument @hDoc 


--|XML Reader for TiposDeJornadas|--
GO
DECLARE @XML AS XML,
        @hDoc AS INT, 
	    @SQL NVARCHAR (MAX)

SET @XML = (SELECT CONVERT(XML, BulkColumn) 
			 AS BulkColumn 
			 FROM OPENROWSET(BULK 'C:\Users\pablo\Downloads\Catalogo.xml', SINGLE_BLOB) AS x)
EXEC sp_xml_preparedocument @hDoc
OUTPUT, @XML
DECLARE @xmlTable
TABLE(
			Id int,
			Nombre varchar(64),
			HoraInicio Time,
			HoraFin Time
);
INSERT 
INTO @xmlTable 
	SELECT	Id,
			Nombre,
			HoraInicio,
			HoraFin
FROM 
	OPENXML(@hDoc, 'Catalogos/TiposDeJornadas/TipoDeJornada') 
WITH  
(	
	Id int '@Id	',
	Nombre varchar(64) '@Nombre',
	HoraInicio Time '@HoraInicio',
	HoraFin Time '@HoraFin'
 );  
INSERT 
	INTO dbo.TipoDeJornada
	SELECT Nombre,
		   HoraInicio,
		   HoraFin,
		   1
	FROM @xmlTable;  
EXEC sp_xml_removedocument @hDoc 
GO
--|XML Reader for Departamentos|--
GO
DECLARE @XML AS XML,
        @hDoc AS INT, 
	    @SQL NVARCHAR (MAX)

SET @XML = (SELECT CONVERT(XML, BulkColumn) 
			 AS BulkColumn 
			 FROM OPENROWSET(BULK 'C:\Users\pablo\Downloads\Catalogo.xml', SINGLE_BLOB) AS x)
EXEC sp_xml_preparedocument @hDoc
OUTPUT, @XML
DECLARE @xmlTable
TABLE(
			Id int,
			Nombre varchar(64)
			
);
INSERT 
INTO @xmlTable 
	SELECT	Id,
			Nombre
FROM 
	OPENXML(@hDoc, 'Catalogos/Departamentos/Departamento') 
WITH  
(	
	Id int '@Id	',
	Nombre varchar(64) '@Nombre'
 );  
INSERT 
	INTO dbo.Departamento
	SELECT Nombre,
		   1
	FROM @xmlTable;  
EXEC sp_xml_removedocument @hDoc 
GO
--|XML Reader for Puestos|--
GO
DECLARE @XML AS XML,
        @hDoc AS INT, 
	    @SQL NVARCHAR (MAX)

SET @XML = (SELECT CONVERT(XML, BulkColumn) 
			 AS BulkColumn 
			 FROM OPENROWSET(BULK 'C:\Users\pablo\Downloads\Catalogo.xml', SINGLE_BLOB) AS x)
EXEC sp_xml_preparedocument @hDoc
OUTPUT, @XML
DECLARE @xmlTable
TABLE(
			Id int,
			Nombre varchar(64),
			SalarioXHora int
);
INSERT 
INTO @xmlTable 
	SELECT	Id,
			Nombre,
			SalarioXHora
FROM 
	OPENXML(@hDoc, 'Catalogos/Puestos/Puesto') 
WITH  
(	
	Id int '@Id	',
	Nombre varchar(64) '@Nombre',
	SalarioXHora int '@SalarioXHora'
 );  
INSERT 
	INTO dbo.Puesto
	SELECT Nombre,
		   SalarioXHora,
		   1
	FROM @xmlTable;  
EXEC sp_xml_removedocument @hDoc 
GO
--|XML Reader for Feriados|--
GO
DECLARE @XML AS XML,
        @hDoc AS INT, 
	    @SQL NVARCHAR (MAX)

SET @XML = (SELECT CONVERT(XML, BulkColumn) 
			 AS BulkColumn 
			 FROM OPENROWSET(BULK 'C:\Users\pablo\Downloads\Catalogo.xml', SINGLE_BLOB) AS x)
EXEC sp_xml_preparedocument @hDoc
OUTPUT, @XML
DECLARE @xmlTable
TABLE(
			Id int,
			Nombre varchar(64),
			Fecha Date
);
INSERT 
INTO @xmlTable 
	SELECT	Id,
			Nombre,
			Fecha
FROM 
	OPENXML(@hDoc, 'Catalogos/Feriados/Feriado') 
WITH  
(	
	Id int '@Id	',
	Nombre varchar(64) '@Nombre',
	Fecha Date '@Fecha'
 );  
INSERT 
	INTO dbo.Feriado
	SELECT Nombre,
		   Fecha,
		   1
	FROM @xmlTable;  
EXEC sp_xml_removedocument @hDoc 
GO
--|XML Reader for Feriados|--
GO
DECLARE @XML AS XML,
        @hDoc AS INT, 
	    @SQL NVARCHAR (MAX)

SET @XML = (SELECT CONVERT(XML, BulkColumn) 
			 AS BulkColumn 
			 FROM OPENROWSET(BULK 'C:\Users\pablo\Downloads\Catalogo.xml', SINGLE_BLOB) AS x)
EXEC sp_xml_preparedocument @hDoc
OUTPUT, @XML
DECLARE @xmlTable
TABLE(
			Id int,
			Nombre varchar(64)
);
INSERT 
INTO @xmlTable 
	SELECT	Id,
			Nombre
FROM 
	OPENXML(@hDoc, 'Catalogos/TiposDeMovimiento/TipoDeMovimiento') 
WITH  
(	
	Id int '@Id	',
	Nombre varchar(64) '@Nombre'
 );  
INSERT 
	INTO dbo.TipoDeMovimiento
	SELECT Nombre,
		   1
	FROM @xmlTable;  
EXEC sp_xml_removedocument @hDoc 
GO


--|XML Reader for TiposDeDeduccion|--
GO
DECLARE @XML AS XML,
        @hDoc AS INT, 
	    @SQL NVARCHAR (MAX)

SET @XML = (SELECT CONVERT(XML, BulkColumn) 
			 AS BulkColumn 
			 FROM OPENROWSET(BULK 'C:\Users\pablo\Downloads\Catalogo.xml', SINGLE_BLOB) AS x)
EXEC sp_xml_preparedocument @hDoc
OUTPUT, @XML
DECLARE @xmlTable
TABLE(
			Id int,
			Nombre varchar(128),
			Obligatorio varchar(128),
			Porcentual varchar(128),
			Valor float
);
INSERT 
INTO @xmlTable 
	SELECT	Id,
			Nombre,
			Obligatorio,
			Porcentual,
			Valor
FROM 
	OPENXML(@hDoc, 'Catalogos/TiposDeDeduccion/TipoDeDeduccion') 
WITH  
(	
	Id int '@Id	',
	Nombre varchar(128) '@Nombre',
	Obligatorio varchar(128) '@Obligatorio',
	Porcentual varchar(128) '@Porcentual',
	Valor float '@Valor'
 );  
INSERT 
	INTO dbo.TipoDeDeduccion
	SELECT Nombre,
		   Obligatorio,
		   Porcentual,
		   Valor,
		   1
	FROM @xmlTable;  
EXEC sp_xml_removedocument @hDoc 
GO
--|XML Reader for Usuario|--
GO
DECLARE @XML AS XML,
        @hDoc AS INT, 
	    @SQL NVARCHAR (MAX)

SET @XML = (SELECT CONVERT(XML, BulkColumn) 
			 AS BulkColumn 
			 FROM OPENROWSET(BULK 'C:\Users\pablo\Downloads\Catalogo.xml', SINGLE_BLOB) AS x)
EXEC sp_xml_preparedocument @hDoc
OUTPUT, @XML
DECLARE @xmlTable
TABLE(
			UserName VARCHAR(128),
			Tipo int,
			Password VARCHAR (128)
);
INSERT 
INTO @xmlTable 
	SELECT	Username,
			Tipo,
			Password
FROM 
	OPENXML(@hDoc, 'Catalogos/UsuariosAdministradores/Usuario') 
WITH  
(	
	Password varchar(64) '@Pwd',
	Tipo int '@tipo',
	Username varchar(64) '@Username'
	
	
 );  
INSERT 
	INTO dbo.Usuario
	SELECT Username,
		   Tipo,
		   Password,
		   1
	FROM @xmlTable;  
EXEC sp_xml_removedocument @hDoc 
GO
--|XML Reader for TiposdeEvento|--
GO
DECLARE @XML AS XML,
        @hDoc AS INT, 
	    @SQL NVARCHAR (MAX)

SET @XML = (SELECT CONVERT(XML, BulkColumn) 
			 AS BulkColumn 
			 FROM OPENROWSET(BULK 'C:\Users\pablo\Downloads\Catalogo.xml', SINGLE_BLOB) AS x)
EXEC sp_xml_preparedocument @hDoc
OUTPUT, @XML
DECLARE @xmlTable
TABLE(
			Id int,
			Nombre VARCHAR (64)
);
INSERT 
INTO @xmlTable 
	SELECT	Id,
			Nombre
FROM 
	OPENXML(@hDoc, 'Catalogos/TiposdeEvento/TipoEvento') 
WITH  
(	
	Id int '@Id	',
	Nombre varchar(64) '@Nombre'
 );  
INSERT 
	INTO dbo.TipoEvento
	SELECT Nombre,
		   1
	FROM @xmlTable;  
EXEC sp_xml_removedocument @hDoc 
