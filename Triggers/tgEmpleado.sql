IF OBJECT_ID('dbo.tgEmpleado', 'TR') IS NOT NULL
    DROP TRIGGER dbo.tgEmpleado;
GO

CREATE TRIGGER tgEmpleado
ON dbo.Empleado
AFTER INSERT
AS 
BEGIN
    DECLARE @IdEmpleado INT;

    -- Get IdEmpleado del nuevo empleado insertado
    SELECT @IdEmpleado = ValorDocuIdentidad
    FROM INSERTED;

    -- Inserta asociacion obligatoria por ley
    INSERT INTO dbo.AsociacionEmpleadoDeducciones (IdTipoDeduccion, ValorTipoDocumento, Monto, Activado)
    VALUES (1, @IdEmpleado, 0.095, 1);

	-- Inserta asociacion aporte CCSS
    INSERT INTO dbo.AsociacionEmpleadoDeducciones (IdTipoDeduccion, ValorTipoDocumento, Monto, Activado)
    VALUES (3, @IdEmpleado, 0.0417, 1);
END;
