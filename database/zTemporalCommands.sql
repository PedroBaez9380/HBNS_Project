INSERT INTO Membresia (Nomenclatura, Descripcion, Costo, Duracion) VALUES
('GOLD', 'Membresia Oro', 100.00, 30),
('SILVER', 'Membresia Plata', 75.00, 30),
('BRONZE', 'Membresia Bronce', 50.00, 30),
('1MES', '1 Mes', 200.00, 30),
('3MES', '3 Meses', 500.00, 90);

-- Insertando datos en RegistroChat
INSERT INTO RegistroChat (ID_usuario_emisor, ID_usuario_receptor, Mensaje, Fecha_envio) VALUES
(1, 2, 'Hola, ¿cómo estás?', GETDATE()),
(2, 1, 'Muy bien, ¡gracias!', GETDATE()),
(1, 2, 'Tengo una pregunta sobre la clase.', GETDATE()),
(2,1, 'Claro, ¿qué necesitas?', GETDATE());

-- Insertando datos en Producto
INSERT INTO Producto (Descripcion, Precio_venta, Cantidad, Descuento, Descripcion_larga) VALUES
('Proteína en Polvo', 25.99, 100, 0.05, 'Proteína de alta calidad para el crecimiento muscular.'),
('Tapete de Yoga', 15.50, 50, 0.00, 'Tapete de yoga antideslizante para entrenamientos cómodos.'),
('Mancuernas - 5lb', 10.00, 80, 0.00, 'Juego de mancuernas de 5lb para entrenamiento de fuerza.'),
('Camiseta', 19.99, 60, 0.10, 'Camiseta deportiva.'),
('Botella de Agua', 12.99, 120, 0.00, 'Botella de agua reutilizable.');

-- Insertando datos en Compra
INSERT INTO Compra (ID_usuario, Fecha, Precio_total, Total_articulos) VALUES
(1, GETDATE(), 150.00, 3),
(2, GETDATE(), 200.00, 2);

-- Insertando datos en DetalleCompra
INSERT INTO DetalleCompra (ID_compra, ID_producto, Precio_unitario, Cantidad) VALUES
(1, 1, 25.99, 2),
(1, 2, 15.50, 1),
(2, 3, 10.00, 5),
(2, 4, 19.99, 5);

-- Insertando datos en Venta
INSERT INTO Venta (ID_usuario_empleado, ID_usuario_cliente, Fecha, Precio_total, Total_articulos) VALUES
(1, 2, GETDATE(), 50.00, 2),
(1, 2, GETDATE(), 100.00, 3);

-- Insertando datos en DetalleVenta
INSERT INTO DetalleVenta (ID_venta, ID_producto, Precio_unitario, Cantidad, Descuento) VALUES
(1, 2, 15.50, 1, 0.00),
(1, 3, 10.00, 1, 0.00),
(2, 1, 25.99, 1, 0.05),
(2, 4, 19.99, 2, 0.10);

-- Insertando datos en EstadoSueldo
INSERT INTO EstadoSueldo (Cantidad_pagar, Fecha_inicio, Fecha_fin, Estatus, Comprobante_ruta, ID_usuario) VALUES
(1000.00, '2024-01-01', '2024-01-31', 1, 'path/to/comprobante1.pdf', 1),
(1500.00, '2024-02-01', '2024-02-29', 0, 'path/to/comprobante2.pdf', 2);

-- Insertando datos en AsignacionHorario
INSERT INTO AsignacionHorario (ID_usuario, ID_horario) VALUES
(1, 1),
(2, 1);

-- Insertando datos en MembresiaHorario
INSERT INTO MembresiaHorario (ID_membresia, ID_horario) VALUES
(1, 1),
(2, 1);

-- Insertando datos en EstadoMembresia
INSERT INTO EstadoMembresia (ID_membresia, ID_usuario, Fecha_inicio, Fecha_vencimiento, Estatus) VALUES
(1, 2, '2024-01-01', '2024-01-31', 1),
(2, 2, '2024-02-01', '2024-02-28', 0);

-- Insertando datos en QuejasSugerencias
INSERT INTO QuejasSugerencias (Nombre, Correo, Descripcion, Fecha) VALUES
('Juan Dela Cruz', 'juan.delacruz@example.com', 'Me gustaría solicitar más horarios de clase.', GETDATE()),
('Maria Santos', 'maria.santos@example.com', 'Hay un problema con el aire acondicionado en el estudio.', GETDATE());



-----------------------------------------------------------------------------------Datos para tablas--------------------------------------------------------------------------------------------------------------------------


INSERT INTO QuejasSugerencias (Nombre, Correo, Descripcion, Fecha)
VALUES ('Pedro', 'pedro@baez.com', 'No me gustó', '2024-04-04');

select * from AsignacionHorario

select * from Horario

select * from clase

select * from Rol

select * from AsignacionRol

select * from usuario

select * from TipoUsuario

select * from RegistroChat

select * from Rol

select * from usuario

select * from membresia

select * from EstadoMembresia


INSERT INTO RegistroChat VALUES (2,1, 'Hola, como estas?', GETDATE())
INSERT INTO RegistroChat VALUES (1,2, 'Bien bien, como estas tu?', GETDATE())
INSERT INTO RegistroChat VALUES (2,1, 'Bien tambien, gracias', GETDATE())
INSERT INTO RegistroChat VALUES (1,2, '	Que bueno, me alegra', GETDATE())


INSERT INTO Membresia VALUES ('HIPHOP', 'Membresia de HipHop 3 clases a la semana', 130.50, 10)

UPDATE Usuario SET ID_membresia = 1003 WHERE ID_usuario = 12;

EXEC TraerInfoMembresia 'SELECT',12,1003,'2024-05-22'

INSERT INTO EstadoMembresia VALUES (1003,12, '2024-06-21', '2024-07-01', 0);

UPDATE EstadoMembresia SET Estatus = 0

INSERT INTO EstadoSueldo (Cantidad_pagar, Fecha_inicio, Fecha_fin, Estatus, Comprobante_ruta, ID_usuario)
		VALUES (3000.20, '2024-05-15', '2024-05-31', 0, null, 1)

EXEC GestionSueldos 'SELECTALL'

SELECT * FROM EstadoSueldo

UPDATE EstadoSueldo SET Estatus = 0

INSERT INTO EstadoSueldo (Cantidad_pagar, Fecha_inicio, Fecha_fin, Estatus, ID_usuario)
		VALUES (9380, '2024-05-30', '2024-06-15', 0, 12)

		select * from clase


