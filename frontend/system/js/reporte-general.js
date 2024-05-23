$(document).ready(function() {
    $('#tabla-cuerpo').empty();
    traerEstadosMembresias()
    traerSueldos()

});

function traerEstadosMembresias() {
    
    $.ajax({
        url: "https://localhost:7131/EstadoMembresia/TraerTodos",
        type: 'GET',
        dataType: 'json',
        crossDomain: true,
        headers: {
            'Content-Type': 'application/json'
        }
    }).done(function (result) {
        result.asignaciones.forEach(function(asignacion) {
            const ID_usuario = asignacion.ID_usuario
            const Cantidad = asignacion.CostoMembresia
            const fechaInicio = asignacion.Fecha_inicio;
            const fechaVencimiento = asignacion.Fecha_vencimiento;
            const Fecha = formatearFecha(fechaInicio, fechaVencimiento);
            if (asignacion.Estatus){
                var Estatus = "Pagado"
            } else {
                var Estatus = "Sin pagar"
            }
            


            $('#tabla-reporte tbody').append(`
                <tr>
                    <td>Membresia</td>
                    <td>Usuario: ${ID_usuario}</td>
                    <td>${Cantidad}</td>
                    <td>${Fecha}</td>
                    <td>${Estatus}</td>
                </tr>
            `);    
        });
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer los tipos de usuario: " + error + "\nStatus: " + status);
        console.error(xhr);
    });



    
}

function formatearFecha(fechaInicio, fechaVencimiento) {
    const fechaInicioFormatted = new Date(fechaInicio).toLocaleDateString();
    const fechaVencimientoFormatted = new Date(fechaVencimiento).toLocaleDateString();
    return `${fechaInicioFormatted} - ${fechaVencimientoFormatted}`;
}


function traerSueldos() {
    $.ajax({
        url: "https://localhost:7131/Sueldos/TraerTodos",
        type: 'GET',
        dataType: 'json',
        crossDomain: true,
        headers: {
            'Content-Type': 'application/json'
        }
    }).done(function (result) {
        result.sueldos.forEach(function(sueldo) {
            const ID_estado_sueldo = sueldo.ID_estado_sueldo
            const Cantidad = sueldo.Cantidad_pagar
            const fechaInicio = sueldo.Fecha_inicio;
            const fechaVencimiento = sueldo.Fecha_fin;
            const Fecha = formatearFecha(fechaInicio, fechaVencimiento);
            if (sueldo.Estatus){
                var Estatus = "Pagado"
            } else {
                var Estatus = "Sin pagar"
            }
            


            $('#tabla-reporte tbody').append(`
                <tr>
                    <td>Sueldo</td>
                    <td>Usuario: ${ID_estado_sueldo}</td>
                    <td>${Cantidad}</td>
                    <td>${Fecha}</td>
                    <td>${Estatus}</td>
                </tr>
            `);    
        });
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer los tipos de usuario: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}