-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------Comandos definiciones de datos en tablas-----------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO Rol (Descripcion) VALUES 
('Maestro'),
('Alumno'),
('Administrador de usuarios'),
('Administrador de roles'),
('Coordinador académico'),
('Administrador académico'),
('Compras'),
('Administrador de Compras'),
('Ventas'),
('Administrador de ventas'),
('Finanzas'),
('Administrador de Finanzas'),
('Reporte de finanzas');

INSERT INTO DiaSemana (ID_dia, Descripcion) VALUES 
(1, 'Lunes'),
(2, 'Martes'),
(3, 'Miercoles'),
(4, 'Jueves'),
(5, 'Viernes'),
(6, 'Sabado'),
(7, 'Domingo')

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------stored procedures-------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------y triggers-----------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[ObtenerQuejasSugerencias]
AS
BEGIN
    SELECT * FROM QuejasSugerencias;
END
GO


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



CREATE PROCEDURE [dbo].[ObtenerRolesPorUsuario]
    @ID_usuario INT
AS
BEGIN
    SELECT ID_Rol from AsignacionRol WHERE ID_usuario = @ID_usuario
END


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
                SELECT *
                FROM Usuario
                WHERE ID_usuario = @ID_usuario;
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

CREATE PROCEDURE [dbo].[TraerTodosUsuarios]
AS
BEGIN
    SELECT U.*, TU.Descripcion AS TipoUsuarioDescripcion
    FROM Usuario U
    LEFT JOIN TipoUsuario TU ON U.ID_tipo_usuario = TU.ID_tipo_usuario;
END

CREATE PROCEDURE [dbo].[TraerDiaSemana]
AS
BEGIN
	SELECT * FROM DiaSemana
END

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

CREATE TRIGGER [dbo].[ActualizarEstadoMembresia]
ON Usuario
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ID_usuario INT, @ID_membresia INT, @FechaInicio DATETIME, @FechaVencimiento DATETIME, @Status NVARCHAR(20), @Duracion INT;

    SELECT @ID_usuario = ID_usuario, @ID_membresia = ID_membresia FROM inserted;

    SELECT @Duracion = Duracion FROM Membresia WHERE ID_membresia = @ID_membresia;

    -- Insertar un nuevo registro en EstadoMembresia
    INSERT INTO EstadoMembresia (ID_usuario, ID_membresia, Fecha_inicio, Fecha_vencimiento, Estatus)
    VALUES (@ID_usuario, @ID_membresia, GETDATE(), DATEADD(day, @Duracion, GETDATE()), '0');
    
    -- Insertar un segundo registro para el segundo periodo de membresía
    INSERT INTO EstadoMembresia (ID_usuario, ID_membresia, Fecha_inicio, Fecha_vencimiento, Estatus)
    VALUES (@ID_usuario, @ID_membresia, DATEADD(day, @Duracion, GETDATE()), DATEADD(day, @Duracion * 2, GETDATE()), '0');
END;

CREATE PROCEDURE [dbo].[TraerInfoMembresia]
    @Option VARCHAR(10),
    @ID_usuario INT,
	@ID_membresia INT = null,
	@Fecha_inicio DATE = null,
    @Estatus BIT = NULL
AS
BEGIN
    IF @Option = 'SELECT'
	BEGIN
		SELECT TOP 2 EM.*, M.Nomenclatura AS TipoMembresia
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
drop procedure TraerInfoMembresia
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------Comandos temporales-----------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

exec sp_help EstadoSueldo;

Create database HBNSdb;

drop database HBNSdb

INSERT INTO QuejasSugerencias (Nombre, Correo, Descripcion, Fecha)
VALUES ('Pedro', 'pedro@baez.com', 'No me gustó', '2024-04-04');

INSERT INTO TipoUsuario VALUES ('AdminRintaro')

INSERT INTO Usuario (ID_tipo_usuario, Contrasena, Nombre, Apellido, Telefono, Correo, Fecha_registro, Fecha_nacimiento, ID_membresia, Estado )
VALUES (1, 'pedrito01', 'Pedro Alberto', 'Baez Najera', 8128644703, 'pedro.baeznjr@uanl.edu.mx', '2024-05-19', '2004-04-27', NULL, 1);

INSERT INTO Usuario (ID_tipo_usuario, Contrasena, Nombre, Apellido, Telefono, Correo, Fecha_registro, Fecha_nacimiento, ID_membresia, Estado )
VALUES (1, 'zac', 'Pedro Alberto', 'Baez Najera', 8128644703, 'pedro.baeznjr@uanl.edu.mx', '2024-05-19', '2004-04-27', NULL, 1);

INSERT INTO AsignacionRol VALUES (1,2), (2,3), (2,4), (2,5), (2,6), (2,7), (2,8), (2,9), (2,10), (2,11), (2,12), (2,13)

INSERT INTO AsignacionHorario VALUES (1,18), (1,12)


INSERT INTO Clase VALUES ('HipHop')
INSERT INTO Horario VALUES (1, 'HipHopM8-9', '8:00', '9:00', 1)

DELETE FROM AsignacionHorario WHERE ID_usuario = 1 AND ID_horario = 1

select * from AsignacionHorario
select * from Horario
select * from clase

select * from Rol

select * from AsignacionRol

select * from usuario

select * from TipoUsuario

EXEC GestionUsuario 'INSERT', NULL, 1, 'zac', 'Pedro Alberto', 'Baez Najera', '8128644703', 'pedro.baeznjr@uanl.edu.mx', '2024-05-19', '2004-04-27', NULL, 1

EXEC GestionUsuario 'SELECT', NULL;

EXEC GestionTipoUsuario 'SELECT'

select * from RegistroChat

INSERT INTO RegistroChat VALUES (2,1, 'Hola, como estas?', GETDATE())
INSERT INTO RegistroChat VALUES (1,2, 'Bien bien, como estas tu?', GETDATE())
INSERT INTO RegistroChat VALUES (2,1, 'Bien tambien, gracias', GETDATE())

INSERT INTO RegistroChat VALUES (1,2, 'Parece que si', GETDATE())

select * from Rol

select * from usuario

select * from membresia

select * from EstadoMembresia

INSERT INTO Membresia VALUES ('HIPHOP', 'Membresia de HipHop 3 clases a la semana', 130.50, 10)

UPDATE Usuario SET ID_membresia = 1003 WHERE ID_usuario = 12;

EXEC TraerInfoMembresia 'SELECT',12,1003,'2024-05-22'

INSERT INTO EstadoMembresia VALUES (1003,12, '2024-06-21', '2024-07-01', 0);
