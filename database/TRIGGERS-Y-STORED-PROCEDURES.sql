-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------Usar la BD--------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE HBNSDB
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------Crear stored procedures y triggers-----------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[ObtenerQuejasSugerencias]
AS
BEGIN
    SELECT * FROM QuejasSugerencias;
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE InsertarQuejasSugerencias
(
	@Nombre NVARCHAR(50),
	@Correo NVARCHAR(320),
	@Descripcion NVARCHAR(500),
	@Fecha DATETIME
)
AS
BEGIN
    INSERT INTO [dbo].[QuejasSugerencias]
		([Nombre]
		,[Correo]
		,[Descripcion]
		,[Fecha])
	VALUES
		(@Nombre
		,@Correo
		,@Descripcion
		,@Fecha)
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[ObtenerLogin]
    @ID_usuario INT,
    @Contrasena VARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Usuario WHERE ID_usuario = @ID_usuario AND Contrasena = @Contrasena)
    BEGIN
        -- Devolver el ID de usuario y el resultado 'Entrando' si la autenticación es exitosa
        SELECT ID_usuario, 'Entrando' AS Resultado FROM Usuario WHERE ID_usuario = @ID_usuario;
    END
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GestionRol]
    @Option VARCHAR(10) = NULL,
	@ID_usuario INT ,
    @ID_rol VARCHAR(MAX) = NULL
AS
BEGIN
	IF @Option = 'SELECT'
	BEGIN
		SELECT * FROM AsignacionRol
		WHERE ID_usuario = @ID_usuario;
	END

	IF @Option = 'INSERT'
	BEGIN
		DELETE FROM AsignacionRol
		WHERE ID_usuario = @ID_usuario;

		DECLARE @RolTabla TABLE (ID_rol INT);

		INSERT INTO @RolTabla (ID_rol)
		SELECT CAST(value AS INT) FROM STRING_SPLIT(@ID_rol, ',');

		INSERT INTO AsignacionRol (ID_usuario, ID_rol)
		SELECT @ID_usuario, ID_rol
		FROM @RolTabla;
	END
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[ObtenerRolesPorUsuario]
    @ID_usuario INT
AS
BEGIN
    SELECT ID_Rol from AsignacionRol WHERE ID_usuario = @ID_usuario
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GestionHorarios]
    @Option VARCHAR(10) = NULL,
    @ID_horario INT = NULL,
    @ID_clase INT = NULL,
    @Nomenclatura NVARCHAR(15) = NULL,
    @Hora_inicio TIME = NULL,
    @Hora_final TIME = NULL,
    @ID_dia INT = NULL
AS
BEGIN
    IF @Option = 'SELECT'
    BEGIN
        SELECT
            H.*,
            D.Descripcion AS DescripcionDia, 
            C.Nombre AS NombreClase
        FROM Horario H
        LEFT JOIN DiaSemana D ON H.ID_dia = D.ID_dia
        LEFT JOIN Clase C ON H.ID_clase = C.ID_clase;
    END
    ELSE IF @Option = 'INSERT'
    BEGIN
        INSERT INTO Horario (ID_clase, Nomenclatura, Hora_inicio, Hora_final, ID_dia)
        VALUES (@ID_clase, @Nomenclatura, @Hora_inicio, @Hora_final, @ID_dia);
    END
    ELSE IF @Option = 'UPDATE'
    BEGIN
        UPDATE Horario
        SET ID_clase = @ID_clase,
            Nomenclatura = @Nomenclatura,
            Hora_inicio = @Hora_inicio,
            Hora_final = @Hora_final,
            ID_dia = @ID_dia
        WHERE ID_horario = @ID_horario;
    END
    ELSE IF @Option = 'DELETE'
    BEGIN
        DELETE FROM Horario
        WHERE ID_horario = @ID_horario;
    END
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GestionAsignacionesHorarios]
    @Option VARCHAR(10) = NULL,
    @ID_usuario INT = NULL,
    @ID_horarios VARCHAR(MAX) = NULL
AS
BEGIN
    IF @Option = 'SELECT'
    BEGIN
        SELECT 
            AH.*,
            H.*,
            C.Nombre AS NombreClase,
            DS.Descripcion AS DescripcionDia
        FROM AsignacionHorario AH
        INNER JOIN Horario H ON AH.ID_horario = H.ID_horario
        INNER JOIN Clase C ON H.ID_clase = C.ID_clase
        INNER JOIN DiaSemana DS ON H.ID_dia = DS.ID_dia
        WHERE AH.ID_usuario = @ID_usuario;
    END
    ELSE IF @Option = 'INSERT'
    BEGIN
        DELETE FROM AsignacionHorario
        WHERE ID_usuario = @ID_usuario;

        DECLARE @HorariosTabla TABLE (ID_horario INT);
        INSERT INTO @HorariosTabla (ID_horario)
        SELECT value FROM STRING_SPLIT(@ID_horarios, ',');

        INSERT INTO AsignacionHorario (ID_usuario, ID_horario)
        SELECT @ID_usuario, ID_horario
        FROM @HorariosTabla;
    END
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GestionTipoUsuario]
	@Option VARCHAR(10),
    @ID_tipo_usuario INT = NULL,
	@Descripcion VARCHAR(50) = NULL
AS
BEGIN
	IF @Option = 'SELECT'
            BEGIN
                SELECT *
                FROM TipoUsuario
            END
    ELSE IF @Option = 'INSERT'
    BEGIN
        INSERT INTO TipoUsuario (Descripcion)
        VALUES (@Descripcion);
    END
    ELSE IF @Option = 'UPDATE'
    BEGIN
        UPDATE TipoUsuario
        SET 
            Descripcion = @Descripcion
        WHERE ID_tipo_usuario = @ID_tipo_usuario
    END
	ELSE IF @Option = 'DELETE'
	BEGIN
		DELETE FROM TipoUsuario
		WHERE ID_tipo_usuario = @ID_tipo_usuario
	END
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GestionUsuario]
    @Option VARCHAR(10),
    @ID_usuario INT = NULL,
    @ID_tipo_usuario INT = NULL,
    @Contrasena VARCHAR(100) = NULL,
    @Nombre VARCHAR(50) = NULL,
    @Apellido VARCHAR(50) = NULL,
    @Telefono NVARCHAR(15) = NULL,
    @Correo NVARCHAR(320) = NULL,
    @Fecha_registro DATETIME = NULL,
    @Fecha_nacimiento DATETIME = NULL,
    @ID_membresia INT = NULL,
    @Estado BIT = NULL
AS
BEGIN
    IF @Option = 'SELECT'
        BEGIN
            SELECT Usuario.*, TipoUsuario.descripcion AS TipoUsuarioDescripcion
			FROM Usuario
			JOIN TipoUsuario ON Usuario.ID_tipo_usuario = TipoUsuario.ID_tipo_usuario
			WHERE Usuario.ID_usuario = @ID_usuario;
        END
    ELSE IF @Option = 'INSERT'
    BEGIN
        INSERT INTO Usuario (ID_tipo_usuario, Contrasena, Nombre, Apellido, Telefono, Correo, Fecha_registro, Fecha_nacimiento, ID_membresia, Estado)
        VALUES (@ID_tipo_usuario, @Contrasena, @Nombre, @Apellido, @Telefono, @Correo, @Fecha_registro, @Fecha_nacimiento, @ID_membresia, @Estado);
    END
    ELSE IF @Option = 'UPDATE'
    BEGIN
        UPDATE Usuario
        SET 
            ID_tipo_usuario = @ID_tipo_usuario,
            Contrasena = @Contrasena,
            Nombre = @Nombre,
            Apellido = @Apellido,
            Telefono = @Telefono,
            Correo = @Correo,
            Fecha_nacimiento = @Fecha_nacimiento,
            ID_membresia = @ID_membresia,
            Estado = @Estado
        WHERE ID_usuario = @ID_usuario;
    END
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[TraerTodosUsuarios]
AS
BEGIN
    SELECT U.*, TU.Descripcion AS TipoUsuarioDescripcion
    FROM Usuario U
    LEFT JOIN TipoUsuario TU ON U.ID_tipo_usuario = TU.ID_tipo_usuario;
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[TraerDiaSemana]
AS
BEGIN
	SELECT * FROM DiaSemana
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GestionClases]
    @Option VARCHAR(10) = NULL,
    @ID_clase INT = NULL,
    @Nombre VARCHAR(40) = NULL
AS
BEGIN
    IF @Option = 'SELECT'
    BEGIN
        SELECT *
        FROM Clase;
    END
    ELSE IF @Option = 'INSERT'
    BEGIN
        INSERT INTO Clase (Nombre)
        VALUES (@Nombre);
    END
    ELSE IF @Option = 'UPDATE'
    BEGIN
        UPDATE Clase
        SET Nombre = @Nombre
        WHERE ID_clase = @ID_clase;
    END
    ELSE IF @Option = 'DELETE'
    BEGIN
        DELETE FROM Clase
        WHERE ID_clase = @ID_clase;
    END
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GestionChat]
	@Option VARCHAR(10),
	@ID_usuario_actual INT = null,
	@ID_usuario_seleccionado INT = null,
	@Mensaje VARCHAR(MAX) = null,
	@Fecha_envio DATETIME = null
AS
BEGIN
	IF @Option = 'SELECT'
    BEGIN
        SELECT Mensaje, Fecha_envio, 'Enviado' AS TipoMensaje
        FROM RegistroChat
        WHERE ID_usuario_emisor = @ID_usuario_actual AND ID_usuario_receptor = @ID_usuario_seleccionado
        UNION ALL
        
        SELECT Mensaje, Fecha_envio, 'Recibido' AS TipoMensaje
        FROM RegistroChat
        WHERE ID_usuario_emisor = @ID_usuario_seleccionado AND ID_usuario_receptor = @ID_usuario_actual
        ORDER BY Fecha_envio;
    END
    ELSE IF @Option = 'INSERT'
    BEGIN
        
        INSERT INTO RegistroChat (ID_usuario_emisor, ID_usuario_receptor, Mensaje, Fecha_envio)
        VALUES (@ID_usuario_actual, @ID_usuario_seleccionado, @Mensaje, @Fecha_envio);
    END
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GestionMembresias]
    @Option VARCHAR(10) = NULL,
    @ID_membresia INT = NULL,
    @Nomenclatura char(6) = NULL,
    @Descripcion VARCHAR(255) = NULL,
    @Costo DECIMAL(10,2) = NULL,
    @Duracion INT = NULL
AS
BEGIN
    IF @Option = 'SELECT'
    BEGIN
        SELECT *
        FROM Membresia
    END
    ELSE IF @Option = 'INSERT'
    BEGIN
        INSERT INTO Membresia(Nomenclatura, Descripcion, Costo, Duracion)
        VALUES (@Nomenclatura, @Descripcion, @Costo, @Duracion);
    END
    ELSE IF @Option = 'UPDATE'
    BEGIN
        UPDATE Membresia
        SET Nomenclatura = @Nomenclatura,
            Descripcion = @Descripcion,
            Costo = @Costo,
            Duracion = @Duracion
        WHERE ID_membresia = @ID_membresia;
    END
    ELSE IF @Option = 'DELETE'
    BEGIN
        DELETE FROM Membresia
        WHERE ID_membresia = @ID_membresia;
    END
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GestionAsignacionesMembresias]
    @Option VARCHAR(10) = NULL,
    @ID_usuario INT = NULL,
    @ID_membresia VARCHAR(MAX) = NULL
AS
BEGIN
    IF @Option = 'SELECT'
	BEGIN
		SELECT Us.ID_usuario, Us.ID_membresia, M.Nomenclatura, M.descripcion
		FROM Usuario Us
		INNER JOIN Membresia M ON Us.ID_membresia = M.ID_membresia;
	END

    IF @Option = 'INSERT'
	BEGIN
		UPDATE Usuario
		SET ID_membresia = @ID_membresia
		WHERE ID_usuario = @ID_usuario;
		EXEC ActualizarEstadoMembresia;

	END
	IF @Option = 'DELETE'
	BEGIN
		UPDATE Usuario
		SET ID_membresia = NULL
		WHERE ID_usuario = @ID_usuario;
		DELETE FROM EstadoMembresia
		WHERE ID_usuario = @ID_usuario 
	END
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CREATE TRIGGER [dbo].[ActualizarEstadoMembresia]
--ON Usuario
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;

--    DECLARE @ID_usuario INT, @ID_membresia INT, @FechaInicio DATETIME, @FechaVencimiento DATETIME, @Status NVARCHAR(20), @Duracion INT;

--    SELECT @ID_usuario = ID_usuario, @ID_membresia = ID_membresia FROM inserted;

--    SELECT @Duracion = Duracion FROM Membresia WHERE ID_membresia = @ID_membresia;

--    -- Insertar un nuevo registro en EstadoMembresia
--    INSERT INTO EstadoMembresia (ID_usuario, ID_membresia, Fecha_inicio, Fecha_vencimiento, Estatus)
--    VALUES (@ID_usuario, @ID_membresia, GETDATE(), DATEADD(day, @Duracion, GETDATE()), '0');
    
--    -- Insertar un segundo registro para el segundo periodo de membresía
--    INSERT INTO EstadoMembresia (ID_usuario, ID_membresia, Fecha_inicio, Fecha_vencimiento, Estatus)
--    VALUES (@ID_usuario, @ID_membresia, DATEADD(day, @Duracion, GETDATE()), DATEADD(day, @Duracion * 2, GETDATE()), '0');
--END;

--CREATE TRIGGER [dbo].[ActualizarEstadoMembresia]
--ON Usuario
--AFTER INSERT
--AS
--BEGIN
--    SET NOCOUNT ON;

--    DECLARE @ID_usuario INT, @ID_membresia INT, @FechaInicio DATETIME, @FechaVencimiento DATETIME, @Status NVARCHAR(20), @Duracion INT;

--    SELECT @ID_usuario = ID_usuario, @ID_membresia = ID_membresia FROM inserted;

--    SELECT @Duracion = Duracion FROM Membresia WHERE ID_membresia = @ID_membresia;

--    IF NOT EXISTS (SELECT 1 FROM EstadoMembresia WHERE ID_usuario = @ID_usuario) AND @ID_membresia IS NOT NULL
--    BEGIN
--        -- Si el usuario no tiene una membresía asignada, insertar un nuevo registro en EstadoMembresia
--        INSERT INTO EstadoMembresia (ID_usuario, ID_membresia, Fecha_inicio, Fecha_vencimiento, Estatus)
--        VALUES (@ID_usuario, @ID_membresia, GETDATE(), DATEADD(day, @Duracion, GETDATE()), '0');

--        -- Insertar un segundo registro para el segundo periodo de membresía
--        INSERT INTO EstadoMembresia (ID_usuario, ID_membresia, Fecha_inicio, Fecha_vencimiento, Estatus)
--        VALUES (@ID_usuario, @ID_membresia, DATEADD(day, @Duracion, GETDATE()), DATEADD(day, @Duracion * 2, GETDATE()), '0');
--    END
--END;

CREATE TRIGGER [dbo].[ActualizarEstadoMembresia]
ON Usuario
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ID_usuario INT, @ID_membresia INT, @FechaInicio DATETIME, @FechaVencimiento DATETIME, @Duracion INT;

    SELECT @ID_usuario = ID_usuario, @ID_membresia = ID_membresia FROM inserted;

    -- Solo ejecutar si se ha cambiado el ID_membresia y el nuevo ID_membresia no es nulo
    IF UPDATE(ID_membresia) AND @ID_membresia IS NOT NULL
    BEGIN
        -- Obtener la duración de la nueva membresía
        SELECT @Duracion = Duracion FROM Membresia WHERE ID_membresia = @ID_membresia;

        -- Manejar el cambio de membresía:
        -- 1.  Invalidar la membresía anterior (si existe)
        UPDATE EstadoMembresia
        SET Estatus = '0'  -- O algún valor que indique "inactivo"
        WHERE ID_usuario = @ID_usuario;

        -- 2. Insertar un nuevo registro en EstadoMembresia para la nueva membresía
        INSERT INTO EstadoMembresia (ID_usuario, ID_membresia, Fecha_inicio, Fecha_vencimiento, Estatus)
        VALUES (@ID_usuario, @ID_membresia, GETDATE(), DATEADD(day, @Duracion, GETDATE()), '1');

        -- Insertar un segundo registro para el segundo periodo de membresía
        INSERT INTO EstadoMembresia (ID_usuario, ID_membresia, Fecha_inicio, Fecha_vencimiento, Estatus)
        VALUES (@ID_usuario, @ID_membresia, DATEADD(day, @Duracion, GETDATE()), DATEADD(day, @Duracion * 2, GETDATE()), '0');
    END
END;
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[TraerInfoMembresia]
    @Option VARCHAR(10),
    @ID_usuario INT = null,
	@ID_membresia INT = null,
	@Fecha_inicio DATE = null,
    @Estatus BIT = NULL
AS
BEGIN
	IF @Option = 'SELECTALL'
	BEGIN
		SELECT EM.*, M.Nomenclatura AS TipoMembresia, M.costo AS CostoMembresia
		FROM EstadoMembresia EM
		INNER JOIN Membresia M ON EM.ID_membresia = M.ID_membresia 
		ORDER BY EM.Fecha_inicio DESC 
	END
    IF @Option = 'SELECT'
	BEGIN
		SELECT TOP 2 EM.*, M.Nomenclatura AS TipoMembresia, M.costo AS CostoMembresia
		FROM EstadoMembresia EM
		INNER JOIN Membresia M ON EM.ID_membresia = M.ID_membresia
		WHERE EM.ID_usuario = @ID_usuario
		ORDER BY EM.Fecha_inicio DESC 
	END
	IF @Option = 'UPDATE'
	BEGIN
		UPDATE EstadoMembresia SET Estatus = @Estatus 
		WHERE ID_usuario = @ID_usuario AND
		ID_membresia = @ID_membresia AND
		Fecha_inicio = @Fecha_inicio
	END
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GestionSueldos]
    @Option VARCHAR(10),
	@ID_estado_sueldo int = NULL,
    @Cantidad DECIMAL(10,2) = NULL,
    @Fecha_inicio DATE = NULL,
    @Fecha_fin DATE = NULL,
    @Estatus BIT = NULL,
    @Comprobante_ruta NVARCHAR(255) = NULL,
    @ID_usuario INT = NULL
AS
BEGIN
    IF @Option = 'SELECTALL'
    BEGIN
        SELECT * FROM EstadoSueldo
    END
    IF @Option = 'SELECT'
    BEGIN
        SELECT * FROM EstadoSueldo
        WHERE ID_usuario = @ID_usuario
    END
    IF @Option = 'INSERT'
    BEGIN
        DECLARE @Fecha_inicio_aux DATE
        SET @Fecha_inicio_aux = CONVERT(DATE, GETDATE()) 
        
        SET @Fecha_fin = DATEADD(DAY, 15, @Fecha_inicio_aux)

        INSERT INTO EstadoSueldo (Cantidad_pagar, Fecha_inicio, Fecha_fin, Estatus, ID_usuario)
        VALUES (@Cantidad, @Fecha_inicio_aux, @Fecha_fin, 0, @ID_usuario)
    END
    IF @Option = 'UPDATE'
    BEGIN
        UPDATE EstadoSueldo SET Estatus = 1, Comprobante_ruta = @Comprobante_ruta
        WHERE ID_estado_sueldo = @ID_estado_sueldo
    END
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[Horariosxclase]
    @ID_clase INT
AS
BEGIN
    SELECT * FROM Horario
	WHERE ID_clase = @ID_clase
END

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------