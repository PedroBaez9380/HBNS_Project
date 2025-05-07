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


