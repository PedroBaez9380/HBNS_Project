$(document).ready(function() {
    var urlParams = new URLSearchParams(window.location.search);
    var userID = urlParams.get('id');
    traerdatos(userID);

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

            if (result.asignacion.length > 1) {
                var membresiaSiguiente = result.asignacion[0];
                $("#tipo-membresia-siguiente").text(membresiaSiguiente.TipoMembresia);
                $("#fecha-inicio-siguiente").text(new Date(membresiaSiguiente.Fecha_inicio).toLocaleDateString());
                $("#fecha-vencimiento-siguiente").text(new Date(membresiaSiguiente.Fecha_vencimiento).toLocaleDateString());
                $("#cantidad-pagar-siguiente").text(membresiaReciente.CostoMembresia);
                $("#estatus-membresia-siguiente").text(membresiaSiguiente.Estatus ? "Pagado" : "No pagado");
            } else {
                $(".membresia-abajo").hide();
            }
        } else {
            $(".seccion-info-membresia").hide();
        }
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer las membresias: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}

