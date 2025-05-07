$(document).ready(function() {

    $('#pagar-membresia-actual').attr('disabled', true)
    $('#pagar-membresia-siguiente').attr('disabled', true)

    $('#id-usuario').on('keydown', function(e) {
        if (e.which === 13) { // Código de tecla 13 es Enter
            e.preventDefault();
            userID = $('#id-usuario').val()
            

            $.ajax({
                url: "https://localhost:7131/Usuarios/Traer/" + userID,
                type: 'GET',
                dataType: 'json',
                crossDomain: true
            }).done(function (result) {
                

                if (result.usuarios && result.usuarios.length > 0) {
                    var nombreUsuario = result.usuarios[0].Nombre + ' ' + result.usuarios[0].Apellido;
                    $('#nombre-usuario').val(nombreUsuario);
                    ;
                } else {
                    alert("No se encontró el usuario");
                }
            }).fail(function (xhr, status, error) {
                alert("Hubo un problema al traer el usuario: " + error + "\nStatus: " + status);
                console.error(xhr);
            });
            pintarCampos();
            traerdatos(userID)

            setTimeout(function() {
                if ($('#estatus-membresia-actual').text().trim() == 'No pagado') {
                    $('#pagar-membresia-actual').attr('disabled', false);
                }
                if ($('#estatus-membresia-siguiente').text().trim() == 'No pagado') {
                    $('#pagar-membresia-siguiente').attr('disabled', false)
                }
            }, 100); // 100 milisegundos de espera
            
        }
        
        
    });

    $('#pagar-membresia-actual').on('click', function() {
        if (confirm("¿Está seguro de que desea pagar la membresía actual?")) {
            var tipoMembresia = $('#tipo-membresia').attr('data-id');
            var fechaInicio = $('#fecha-inicio-actual').text().split('/').reverse().join('-');
            var estatus = true;
            
            pagarMembresia(tipoMembresia, fechaInicio, estatus);
            pintarCampos()
            window.location.reload(true);
        }
        
    });

    $('#pagar-membresia-siguiente').on('click', function() {
        if (confirm("¿Está seguro de que desea pagar la membresía siguiente?")) {
            var tipoMembresia = $('#tipo-membresia-siguiente').attr('data-id');
            var fechaInicio = $('#fecha-inicio-siguiente').text().split('/').reverse().join('-');
            var estatus = true;
            
            pagarMembresia(tipoMembresia, fechaInicio, estatus);
            pintarCampos()
            window.location.reload(true);
        }
        
    });
    
});

function traerdatos(userID) {
    $.ajax({
        url: "https://localhost:7131/EstadoMembresia/Traer/" + userID,
        type: 'GET',
        dataType: 'json',
        crossDomain: true
    }).done(function (result) {
        if (result.asignacion.length > 0) {
            var membresiaReciente = result.asignacion[1];
            $("#tipo-membresia").text(membresiaReciente.TipoMembresia);
            $("#fecha-inicio-actual").text(new Date(membresiaReciente.Fecha_inicio).toLocaleDateString());
            $("#fecha-vencimiento-actual").text(new Date(membresiaReciente.Fecha_vencimiento).toLocaleDateString());
            $("#cantidad-pagar-actual").text(membresiaReciente.CostoMembresia);
            $("#estatus-membresia-actual").text(membresiaReciente.Estatus ? "Pagado" : "No pagado");
            $("#tipo-membresia").attr('data-id', membresiaReciente.ID_membresia)

            if (result.asignacion.length > 1) {
                var membresiaSiguiente = result.asignacion[0];
                $("#tipo-membresia-siguiente").text(membresiaSiguiente.TipoMembresia);
                $("#fecha-inicio-siguiente").text(new Date(membresiaSiguiente.Fecha_inicio).toLocaleDateString());
                $("#fecha-vencimiento-siguiente").text(new Date(membresiaSiguiente.Fecha_vencimiento).toLocaleDateString());
                $("#cantidad-pagar-siguiente").text(membresiaReciente.CostoMembresia);
                $("#estatus-membresia-siguiente").text(membresiaSiguiente.Estatus ? "Pagado" : "No pagado");

                $("#tipo-membresia-siguiente").attr('data-id', membresiaSiguiente.ID_membresia)
            } else {
                $(".membresia-abajo").hide();
            }
        } else {
            alert("El usuario no cuenta con membresias activas");
                window.location.reload(true);
                return;
        }
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer las membresias: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}

function pagarMembresia(tipoMembresia, fechaInicio, estatus) {
    $.ajax({
        url: "https://localhost:7131/EstadoMembresia/Actualizar",
        type: 'PUT',
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        data: JSON.stringify({
            "iD_membresia": tipoMembresia,
            "iD_usuario": $("#id-usuario").val(),
            "fecha_inicio": fechaInicio,
            "estatus": estatus
        }),
        crossDomain: true
    }).done(function (result) {
        userID = $('#id-usuario').val()
        traerdatos(userID);
        console.log(result);
        resetearCampos();
        alert("Pago exitoso!");
        $('#pagar-membresia-actual').attr('disabled', true)
        $('#pagar-membresia-siguiente').attr('disabled', true)
        
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al pagar: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}

function resetearCampos() {
    $("#id-usuario").val("");
    $("#nombre-usuario").val("");
}

function convertirFecha(fecha) {
    var partes = fecha.split('/');
    return partes[2] + '-' + partes[1] + '-' + partes[0];
}

function pintarCampos() {
    setTimeout(function() {
        var estatusActual = $('#estatus-membresia-actual').text().trim();
        var estatusSiguiente = $('#estatus-membresia-siguiente').text().trim();
        
    
        function asignarColorFondo(estatus, elemento) {
            if (estatus === 'No pagado') {
                elemento.css('background-color', '#ffcccc');
            } else if (estatus === 'Pagado') {
                elemento.css('background-color', '#ccffcc');
            }
        }

        asignarColorFondo(estatusActual, $('#estatus-membresia-actual'));
        asignarColorFondo(estatusSiguiente, $('#estatus-membresia-siguiente'));
    }, 100); // 100 milisegundos de espera
}

function limpiarCampos() {
    $("#tipo-membresia").text('');
    $("#fecha-inicio-actual").text('');
    $("#fecha-vencimiento-actual").text('');
    $("#estatus-membresia-actual").text('');

    $("#tipo-membresia-siguiente").text('');
    $("#fecha-inicio-siguiente").text('');
    $("#fecha-vencimiento-siguiente").text('');
    $("#estatus-membresia-siguiente").text('');
}