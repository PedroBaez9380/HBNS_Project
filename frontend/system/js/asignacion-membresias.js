$(document).ready(function() {
    traerAsignaciones()
    traerNomenclaturaMembresia()
    $('#boton-guardar').attr('disabled', true);
    $('#boton-eliminar').attr('disabled', true);

    $('#id-usuario').on('keydown', function(e) {
        if (e.which === 13) { // Código de tecla 13 es Enter
            e.preventDefault();
            var idUsuarioBuscado = parseInt($("#id-usuario").val()); // Convertir a entero
            $.ajax({
                url: "https://localhost:7131/Usuarios/TraerTodosUsuarios",
                type: 'GET',
                dataType: 'json',
                crossDomain: true
            }).done(function (result) {
                var usuarios = result.usuarios;
                var usuarioEncontrado = usuarios.find(function(usuario) {
                    return usuario.ID_usuario === idUsuarioBuscado;
                });
                if (usuarioEncontrado) {
                    // Si se encontró el usuario, continuar con la búsqueda de asignaciones
                    $.ajax({
                        url: "https://localhost:7131/AsignacionMembresias/Traer",
                        type: 'GET',
                        dataType: 'json',
                        crossDomain: true
                    }).done(function (result) {
                        var asignaciones = result.asignaciones;
                        var asignacionEncontrada = asignaciones.find(function(asignacion) {
                            return asignacion.ID_usuario === idUsuarioBuscado;
                        });
                        if (asignacionEncontrada) {
                            // Si se encontró la asignación, actualizar el select
                            var idMembresia = asignacionEncontrada.ID_membresia;
                            $('#lstMembresias').val(idMembresia);
                            $('#lstMembresias').attr('disabled', false);
                            $('#boton-eliminar').attr('disabled', false);
                            $('#boton-guardar').attr('disabled', false);
                        } else {
                            // Si no se encontró la asignación, mostrar mensaje y habilitar controles
                            alert("El usuario " + idUsuarioBuscado + " no tiene asignada una membresía");
                            $('#lstMembresias').val("0");
                            $('#lstMembresias').attr('disabled', false);
                            $('#boton-eliminar').attr('disabled', false);
                            $('#boton-guardar').attr('disabled', false);
                        }
                    }).fail(function (xhr, status, error) {
                        alert("Hubo un problema al traer las asignaciones: " + error + "\nStatus: " + status);
                        console.error(xhr);
                    });
                } else {
                    // Si no se encontró el usuario, mostrar mensaje
                    alert("No se encontró ningún usuario con el ID proporcionado: " + idUsuarioBuscado);
                }
            }).fail(function (xhr, status, error) {
                alert("Hubo un problema al verificar el usuario: " + error + "\nStatus: " + status);
                console.error(xhr);
            });
        }
    });

    $('#boton-guardar').on('click', function() {
        if ($('#lstMembresias').val() == 0) {
            alert("Seleccione una membresia");
        } else {
            $.ajax({
                url: "https://localhost:7131/AsignacionMembresias/Guardar",
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                dataType: 'json',
                data: JSON.stringify({
                    "ID_usuario": $("#id-usuario").val(),
                    "ID_membresia": $('#lstMembresias').val()
                }),
                crossDomain: true
            }).done(function (result) {
                console.log(result);
                alert("Guardado exitoso!");
                $('#boton-guardar').attr('disabled', true);
                $('#boton-eliminar').attr('disabled', true);
                $('#boton-nuevo').attr('disabled', false);
                $('#lstMembresias').attr('disabled', true);
                $('#id-usuario').val("");
                $('#lstMembresias').val("0");
                traerAsignaciones()
                
            }).fail(function (xhr, status, error) {
                alert("Hubo un problema al guardar: " + error + "\nStatus: " + status);
                console.error(xhr);
            });
        }

        
    });

    $('#boton-eliminar').on('click', function() {

        $.ajax({
            url: "https://localhost:7131/AsignacionMembresias/Eliminar",
            type: 'POST',
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify({
                "ID_usuario": $("#id-usuario").val(),
            }),
            crossDomain: true
        }).done(function (result) {
            console.log(result);
            alert("Borrado exitoso!");
            $('#boton-guardar').attr('disabled', true);
            $('#boton-eliminar').attr('disabled', true);
            $('#boton-nuevo').attr('disabled', false);
            $('#id-usuario').val("");
            $('#lstMembresias').val("0");
            $('#lstMembresias').attr('disabled', true);
            traerAsignaciones()
            
        }).fail(function (xhr, status, error) {
            alert("Hubo un problema al Borrar: " + error + "\nStatus: " + status);
            console.error(xhr);
        });
    });
});

function traerNomenclaturaMembresia() {
    $.ajax({
        url: "https://localhost:7131/Membresias/Traer",
        type: 'GET',
        dataType: 'json',
        crossDomain: true
    }).done(function (result) {
        var opciones = '<option selected value="0">Seleccionar opción</option>';
        result.result.membresias.forEach(function(membresia) {
            opciones += '<option value="' + membresia.iD_membresia + '">' + membresia.nomenclatura + '</option>';
        });

        $('#lstMembresias').each(function() {
            if ($(this).children('option').length === 1) {
                $(this).html(opciones);
            }
        });
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer las nomenclaturas: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}


function traerAsignaciones() {

    $('#tabla-cuerpo').empty();

    $.ajax({
        url: "https://localhost:7131/AsignacionMembresias/Traer",
        type: 'GET',
        dataType: 'json',
        crossDomain: true
    }).done(function (result) {
        result.asignaciones.forEach(function(asignacion) {
            var ID_usuario = asignacion.ID_usuario;
            var ID_membresia = asignacion.ID_membresia;
            var nomenclatura = asignacion.Nomenclatura;
            var descripcion = asignacion.descripcion;

            // Agregar filas al tbody correcto
            $('#tabla-cuerpo').append(`
                <tr>
                    <td>${ID_usuario}</td>
                    <td>${ID_membresia}</td>
                    <td>${nomenclatura}</td>
                    <td>${descripcion}</td>
                </tr>
            `);    
        });
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer las asignaciones: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}
