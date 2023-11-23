IF OBJECT_ID('dbo.tgEmpleado', 'TR') IS NOT NULL
    DROP TRIGGER dbo.tgEmpleado;
GO

CREATE TRIGGER tgEmpleado
ON dbo.Empleado
AFTER INSERT
AS 
BEGIN
    -- Inserta asociaciones para cada empleado insertado
    INSERT INTO dbo.AsociacionEmpleadoDeducciones (IdTipoDeduccion, ValorTipoDocumento, Monto, Activado)
    SELECT 1, ValorDocuIdentidad, 0.095, 1 FROM INSERTED; -- Asociacion obligatoria por ley

    INSERT INTO dbo.AsociacionEmpleadoDeducciones (IdTipoDeduccion, ValorTipoDocumento, Monto, Activado)
    SELECT 3, ValorDocuIdentidad, 0.0417, 1 FROM INSERTED; -- Asociacion aporte CCSS
END;