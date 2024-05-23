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
	ID_registro INT PRIMARY KEY IDENTITY(1,1) not null,
    ID_usuario_emisor INT FOREIGN KEY REFERENCES Usuario(ID_usuario) not null,
    ID_usuario_receptor INT FOREIGN KEY REFERENCES Usuario(ID_usuario) not null,
    Mensaje VARCHAR(MAX) not null,
    Fecha_envio DATETIME not null,
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
    Fecha_inicio DATE not null,
    Fecha_fin DATE not null,
    Estatus BIT not null,
    Comprobante_ruta NVARCHAR(255),
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
    ID_usuario int FOREIGN KEY REFERENCES Usuario(ID_usuario) not null,
    Fecha_inicio DATE not null,
    Fecha_vencimiento DATE not null,
    Estatus BIT not null,
	CONSTRAINT PK_estado_membresia PRIMARY KEY (ID_membresia, ID_usuario, Fecha_inicio)
);

exec sp_help EstadoMembresia;

CREATE TABLE QuejasSugerencias (
    ID_queja_sug INT PRIMARY KEY IDENTITY(1,1) not null,
    Nombre VARCHAR(50),
    Correo NVARCHAR(320),
    Descripcion NVARCHAR(500) not null,
    Fecha DATETIME not null,
);