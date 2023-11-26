DROP TABLE Usuario;
DROP TABLE Empleado;
DROP TABLE MarcaDeAsistencia;
DROP TABLE TipoDocuIdentidad;
DROP TABLE TipoDeJornada;
DROP TABLE TipoJornadaProximaSemana;
DROP TABLE Puesto;
DROP TABLE Departamento;
DROP TABLE Feriado;
DROP TABLE AsociacionEmpleadoDeducciones;
DROP TABLE TipoDeMovimiento;
DROP TABLE Movimientos;
DROP TABLE TipoDeDeduccion;
DROP TABLE EmpleadoPorSemana;
DROP TABLE EmpleadoPorMes;
DROP TABLE TipoEvento;
DROP TABLE DBErrors;
DROP TABLE EventLog;


--Creation of Tables
CREATE TABLE Usuario(
id INT IDENTITY (1, 1) PRIMARY KEY,
UserName VARCHAR(64), 
Tipo int,
Password VARCHAR (64),
Activo bit
);
CREATE TABLE Empleado(
id INT IDENTITY (1, 1) PRIMARY KEY,
Nombre VARCHAR(64),
TipoDocuIdentidad int,
ValorDocuIdentidad int,
IdDepartamento int,
IdPuesto int,
Usuario VARCHAR(64),
Password VARCHAR (64),
Activo bit
);
CREATE TABLE MarcaDeAsistencia(
id INT IDENTITY (1, 1) PRIMARY KEY, 
ValorTipoDocumento int,
FechaEntrada Date,
FechaSalida Date,
HoraEntrada Time,
HoraSalida Time,
Activo bit
);
CREATE TABLE TipoDocuIdentidad(
id INT IDENTITY (1, 1) PRIMARY KEY, 
Nombre VARCHAR(128),
Activado bit
);
CREATE TABLE TipoDeJornada(
id INT IDENTITY (1, 1) PRIMARY KEY, 
Nombre VARCHAR(128),
HoraInicio time,
HoraFin time,
Activado bit
);
CREATE TABLE Puesto(
id INT IDENTITY (1, 1) PRIMARY KEY, 
Nombre VARCHAR(128),
SalarioXHora INT,
Activado bit	
);
CREATE TABLE Departamento(
id INT IDENTITY (1, 1) PRIMARY KEY, 
Nombre VARCHAR(128),
Activado bit
);
CREATE TABLE TipoDeDeduccion(
id INT IDENTITY (1, 1) PRIMARY KEY, 
Nombre VARCHAR(128),
Obligatorio VARCHAR(128),
Porcentual VARCHAR(128),
Valor Float,
Activado bit
);
CREATE TABLE Feriado(
id INT IDENTITY (1, 1) PRIMARY KEY, 
Nombre VARCHAR(128),
Fecha date,
Activado bit
);
CREATE TABLE TipoDeMovimiento(
id INT IDENTITY (1, 1) PRIMARY KEY, 
Nombre VARCHAR(128),
Activado bit
);
CREATE TABLE TipoJornadaProximaSemana(
id INT IDENTITY (1, 1) PRIMARY KEY, 
ValorTipoDocumento int,
IdTipoJornada int,
Activado bit
);

CREATE TABLE TipoEvento(
id INT IDENTITY (1, 1) PRIMARY KEY, 
Nombre VARCHAR(128),
Activado bit
);
CREATE TABLE AsociacionEmpleadoDeducciones(
IdTipoDeduccion int,
ValorTipoDocumento int,
Monto int,
Activado bit
);
CREATE TABLE EmpleadoPorSemana(
id int IDENTITY(1,1) NOT NULL PRIMARY KEY, 
ValorTipoDocumento int,
FechaInicio Date,
FechaFin Date,
Deducciones int,
SalarioNeto int,
SalarioBruto int,
DeduccionesFijas int,
DeduccionPorc int,
HorasNormales int,
HorasExtras int,
HorasDoble int,
HoraExtraDoble int
);
CREATE TABLE EmpleadoPorMes(
id int IDENTITY(1,1) NOT NULL PRIMARY KEY, 
ValorTipoDocumento int,
FechaMes Date,
Deducciones int,
SalarioNeto int,
SalarioBruto int,
DeduccionesFijas int,
DeduccionPorc int,
HorasNormales int,
HorasExtras int,
HorasDoble int,
HoraExtraDoble int
);
CREATE TABLE Movimientos(
id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
IdTipoMoviento int,
Fecha Date,
ValorDocId int,
Monto Float
);

CREATE TABLE EventLog (
 id int IDENTITY(1,1) NOT NULL PRIMARY KEY, 
 LogDescription varchar(2000) NOT NULL, 
 PostIdUser INT NOT NULL, 
 PostIP varchar(64) NOT NULL, 
 PostTime datetime NOT NULL
); 
CREATE TABLE DBErrors(
 [ErrorID] [int] IDENTITY(1,1) NOT NULL,
 [UserName] [varchar](100) NULL,
 [ErrorNumber] [int] NULL,
 [ErrorState] [int] NULL,
 [ErrorSeverity] [int] NULL,
 [ErrorLine] [int] NULL,
 [ErrorProcedure] [varchar](max) NULL,
 [ErrorMessage] [varchar](max) NULL,
 [ErrorDateTime] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY] 