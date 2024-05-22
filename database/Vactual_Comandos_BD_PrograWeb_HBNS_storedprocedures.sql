CREATE TABLE TipoUsuario (
    ID_tipo_usuario INT PRIMARY KEY IDENTITY(1,1) not null,
    Descripcion VARCHAR(50) not null
);

exec sp_help TipoUsuario;

CREATE TABLE Membresia (
    ID_membresia INT PRIMARY KEY IDENTITY(1,1) not null,
    Nomenclatura char(6) not null,
    Descripcion VARCHAR(255) not null,
    Costo DECIMAL(10, 2) not null,
    Duracion INT not null
);

exec sp_help Membresia;

CREATE TABLE Usuario (
    ID_usuario INT PRIMARY KEY IDENTITY(1,1) not null,
    ID_tipo_usuario INT not null,
    Contrasena VARCHAR(100) not null,
	Nombre VARCHAR(50) not null,
    Apellido VARCHAR(50) not null,
    Telefono NVARCHAR(15),
    Correo NVARCHAR(320) not null,
    Fecha_registro DATETIME not null,
    Fecha_nacimiento DATETIME not null,
	ID_membresia INT,
	Estado BIT not null,
    CONSTRAINT FK_TipoUsuario_Usuario FOREIGN KEY (ID_tipo_usuario) REFERENCES TipoUsuario(ID_tipo_usuario) ,
	CONSTRAINT FK_Membresia_Usuario FOREIGN KEY (ID_membresia) REFERENCES Membresia(ID_membresia) 
);

exec sp_help Usuario;

CREATE TABLE Rol (
    ID_Rol INT PRIMARY KEY IDENTITY(1,1) not null,
    Descripcion VARCHAR(255) not null
);

exec sp_help Rol;

CREATE TABLE AsignacionRol (
    ID_usuario INT FOREIGN KEY REFERENCES Usuario(ID_usuario) not null,
    ID_rol INT FOREIGN KEY REFERENCES Rol(ID_rol) not null,
	CONSTRAINT PK_usuario_AsignacionRoles PRIMARY KEY (ID_usuario, ID_rol),
);

exec sp_help AsignacionRol;

CREATE TABLE RegistroChat (
    ID_usuario_emisor INT FOREIGN KEY REFERENCES Usuario(ID_usuario) not null,
    ID_usuario_receptor INT FOREIGN KEY REFERENCES Usuario(ID_usuario) not null,
    Mensaje VARCHAR(MAX) not null,
    Fecha_envio DATETIME not null,
	CONSTRAINT PK_usuarios_chat PRIMARY KEY (ID_usuario_emisor, ID_usuario_receptor),
);

exec sp_help RegistroChat;


CREATE TABLE Producto (
    ID_producto INT PRIMARY KEY IDENTITY(1,1) not null,
    Descripcion VARCHAR(40) not null,
    Precio_venta DECIMAL(10, 2) not null,
    Cantidad INT not null,
	Descuento DECIMAL(3,2),
    Descripcion_larga VARCHAR(MAX)
);

exec sp_help Producto;

CREATE TABLE Compra (
    ID_compra INT PRIMARY KEY IDENTITY(1,1) not null,
    ID_usuario INT not null,
    Fecha DATETIME not null,
    Precio_total DECIMAL(10, 2) not null,
    Total_articulos INT not null,
    CONSTRAINT FK_Usuario_Compras FOREIGN KEY (ID_usuario) REFERENCES Usuario(ID_usuario)
);

exec sp_help Compra;

CREATE TABLE DetalleCompra (
    ID_compra INT FOREIGN KEY REFERENCES Compra(ID_compra) not null,
    ID_producto INT FOREIGN KEY REFERENCES Producto(ID_producto) not null,
    Precio_unitario DECIMAL(10, 2) not null,
    Cantidad INT not null,
	CONSTRAINT PK_detalle_compra PRIMARY KEY (ID_compra, ID_producto),
);

exec sp_help DetalleCompra;

CREATE TABLE Venta (
    ID_venta INT PRIMARY KEY IDENTITY(1,1) not null,
    ID_usuario_empleado INT not null,
    ID_usuario_cliente INT not null,
    Fecha DATETIME not null,
    Precio_total DECIMAL(10, 2) not null,
    Total_articulos INT not null,
    CONSTRAINT FK_UsuarioEmpleado_Ventas FOREIGN KEY (ID_usuario_empleado) REFERENCES Usuario(ID_usuario),
    CONSTRAINT FK_UsuarioCliente_Ventas FOREIGN KEY (ID_usuario_cliente) REFERENCES Usuario(ID_usuario)
);

exec sp_help Venta;

CREATE TABLE DetalleVenta (
    ID_detalleventa INT PRIMARY KEY IDENTITY(1,1) not null,
    ID_venta INT not null,
    ID_producto INT not null,
    Precio_unitario DECIMAL(10, 2) not null,
    Cantidad INT not null,
	Descuento DECIMAL(3,2),
    CONSTRAINT FK_Venta_DetalleVenta FOREIGN KEY (ID_venta) REFERENCES Venta(ID_venta),
    CONSTRAINT FK_Producto_DetalleVenta FOREIGN KEY (ID_producto) REFERENCES Producto(ID_producto)
);

exec sp_help DetalleVenta;

CREATE TABLE Clase (
	ID_clase INT PRIMARY KEY IDENTITY(1,1) not null,
	Nombre VARCHAR(40) not null
);

exec sp_help Clase;

CREATE TABLE DiaSemana (
	ID_dia INT PRIMARY KEY not null,
	Descripcion VARCHAR(20) not null
);

exec sp_help DiaSemana;

CREATE TABLE Horario (
    ID_horario INT PRIMARY KEY IDENTITY(1,1) not null,
    ID_clase INT not null,
    Nomenclatura NVARCHAR(15) UNIQUE not null,
    Hora_inicio TIME not null,
    Hora_final TIME not null,
    ID_dia INT not null,
    CONSTRAINT FK_Clase_Horarios FOREIGN KEY (ID_clase) REFERENCES Clase(ID_clase),
	CONSTRAINT FK_Dia_Horarios FOREIGN KEY (ID_dia) REFERENCES DiaSemana(ID_dia)
);

exec sp_help Horario;

CREATE TABLE EstadoSueldo (
    ID_estado_sueldo INT PRIMARY KEY IDENTITY(1,1) not null,
    Cantidad_pagar DECIMAL(10, 2) not null,
    Fecha_inicio DATETIME not null,
    Fecha_fin DATETIME not null,
    Estatus CHAR(1) not null,
    Comprobante_ruta NVARCHAR(255) not null,
	ID_usuario int not null,
	CONSTRAINT FK_Usuario_Sueldo FOREIGN KEY (ID_usuario) REFERENCES Usuario(ID_usuario),
);

exec sp_help EstadoSueldo;

CREATE TABLE AsignacionHorario (
    ID_usuario INT FOREIGN KEY REFERENCES Usuario(ID_usuario) not null,
    ID_horario INT FOREIGN KEY REFERENCES Horario(ID_horario) not null,
	CONSTRAINT PK_usuario_horario PRIMARY KEY (ID_usuario, ID_horario)
);

exec sp_help AsignacionHorario;

CREATE TABLE MembresiaHorario (
    ID_membresia INT FOREIGN KEY REFERENCES Membresia(ID_membresia) not null,
    ID_horario INT FOREIGN KEY REFERENCES Horario(ID_horario) not null,
    CONSTRAINT PK_membresia_horario PRIMARY KEY (ID_membresia, ID_horario)
);

exec sp_help MembresiaHorario;

CREATE TABLE EstadoMembresia (
    ID_membresia int FOREIGN KEY REFERENCES Membresia(ID_membresia) not null,
    ID_alumno int FOREIGN KEY REFERENCES Usuario(ID_usuario) not null,
    Fecha_inicio DATETIME not null,
    Fecha_vencimiento DATETIME not null,
    Estatus INT not null,
	CONSTRAINT PK_estado_membresia PRIMARY KEY (ID_membresia, ID_alumno)
);

exec sp_help EstadoMembresia;

CREATE TABLE QuejasSugerencias (
    ID_queja_sug INT PRIMARY KEY IDENTITY(1,1) not null,
    Nombre VARCHAR(50),
    Correo NVARCHAR(320),
    Descripcion NVARCHAR(500) not null,
    Fecha DATETIME not null,
);



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
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
