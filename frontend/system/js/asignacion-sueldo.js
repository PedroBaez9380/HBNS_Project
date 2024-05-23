$(document).ready(function() {
    traerSueldos();

    $('#tabla-cuerpo').on('click', 'tr', function() {
        
        $('#boton-guardar').attr('disabled', true);
        $('#boton-nuevo').attr('disabled', false);
        $('#boton-modificacion').attr('disabled', false);
        desHabilitarCampos()

        var estatus = $(this).find('td:eq(5)').attr('data-id');

        $('#ID').val($(this).find('td:eq(0)').text().trim());
        $('#ID_usuario').val($(this).find('td:eq(1)').text().trim());
        $('#cantidad').val($(this).find('td:eq(2)').text().trim());
        $('#fecha_inicio').val($(this).find('td:eq(3)').text().trim());
        $('#fecha_fin').val($(this).find('td:eq(4)').text().trim());
        $('#lstEstatus').val(estatus);
        $('#ruta').val($(this).find('td:eq(6)').text().trim());
     
    });

    $('#boton-nuevo').click(function() {
        $('#ID_usuario').attr('disabled', false);
        $('#cantidad').attr('disabled', false);
        $('#lstEstado').attr('disabled', false);
        limpiarCampos() 
        $('#boton-guardar').attr('disabled', false);
        $('#boton-nuevo').attr('disabled', true);
        $('#boton-modificacion').attr('disabled', true);
    });

    $('#boton-modificacion').click(function() {
        if ($('#lstEstatus').val() == 1) {
            alert("No se puede modificar un pago realizado");
        } else {
            $('#lstEstatus').attr('disabled', false);
            $('#ruta').attr('disabled', false);
            $('#boton-guardar').attr('disabled', false);
            $('#boton-nuevo').attr('disabled', true);
            $('#boton-modificacion').attr('disabled', true);
        }
    });

    $('#boton-guardar').click(function() {
        if ($("#lstEstatus").val() === "1") {
            var estado_var = true
        } else if ($("#lstEstatus").val() === "0") {
            var estado_var = false
        }

        if ($("#ID").val() === "" ){
            option = "Guardar"
            typemod = 'POST'
            iD_usuario = $("#ID_usuario").val()
            ctd_pagar = $("#cantidad").val()
            ID = null;
            comprbante_ruta = null

        } else {
            option = "Actualizar"
            typemod = 'PUT'
            iD_usuario = null
            ctd_pagar = null
            ID = $("#ID").val()
            comprbante_ruta = $("#ruta").val()
        }
        $.ajax({
            url: "https://localhost:7131/Sueldos/"+ option,
            type: typemod,
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify({
                "iD_usuario": iD_usuario,
                "Cantidad_pagar": ctd_pagar,
                "iD_estado_sueldo": ID,
                "Comprobante_ruta": comprbante_ruta
            }),
            crossDomain: true
        }).done(function (result) {
            console.log(result);
            limpiarCampos()
            desHabilitarCampos()
            traerSueldos()
            alert("Guardado exitoso!");
            

        }).fail(function (xhr, status, error) {
            alert("Hubo un problema al guardar: " + error + "\nStatus: " + status);
            console.error(xhr);
        });
        $('#boton-guardar').attr('disabled', true);
        $('#boton-nuevo').attr('disabled', false);
        $('#boton-modifiacion').attr('disabled', true);
    });

    $('#buscar-sueldos').on('input', function() {
        var textoBusqueda = $(this).val().toLowerCase();
        
        $('#tabla-cuerpo tr').each(function() {
            var coincide = false;
            $(this).find('td').each(function() {
                if ($(this).text().toLowerCase().includes(textoBusqueda)) {
                    coincide = true;
                    return false; 
                }
            });
            if (coincide) {
                $(this).show();
            } else {
                $(this).hide();
            }
        });
    });
});

function desHabilitarCampos() {
    $('#ID').attr('disabled', true);
    $('#ID_usuario').attr('disabled', true);
    $('#cantidad').attr('disabled', true);
    $('#fecha_inicio').attr('disabled', true);
    $('#fecha_fin').attr('disabled', true);
    $('#lstEstatus').attr('disabled', true);
    $('#ruta').attr('disabled', true);

}

function limpiarCampos() {
    $('#ID').val('');
    $('#ID_usuario').val('');
    $('#cantidad').val('');
    $('#fecha_inicio').val('');
    $('#fecha_fin').val('');
    $('#lstEstatus').val('default')
    $('#ruta').val('');

}



function traerSueldos() {
    $('#tabla-sueldos tbody').empty();
    $.ajax({
        url: "https://localhost:7131/Sueldos/TraerTodos",
        type: 'GET',
        dataType: 'json',
        crossDomain: true
    }).done(function (result) {
         result.sueldos.forEach(function(sueldo) {
            var ID_estado_sueldo = sueldo.ID_estado_sueldo;
            var Cantidad_pagar = sueldo.Cantidad_pagar;
            var Fecha_inicio = sueldo.Fecha_inicio;
            var Fecha_fin = sueldo.Fecha_fin;

            if (sueldo.Estatus) {
                Estado = 'Pagado';
                id_estado = '1';
            } else {
                Estado = 'Sin pagar';
                id_estado = '0'
            }

            var Estatus = Estado;

            var Comprobante_ruta; 

            if (sueldo.Comprobante_ruta === undefined || sueldo.Comprobante_ruta === null || Object.keys(sueldo.Comprobante_ruta).length === 0) {
                Comprobante_ruta = 'N/A'; 
            } else {
                Comprobante_ruta = sueldo.Comprobante_ruta; 
            }
            
            var ID_usuario = sueldo.ID_usuario
            var Fecha_inicio = new Date(sueldo.Fecha_inicio);
            var Fecha_fin = new Date(sueldo.Fecha_fin);

            var formattedFecha_inicio = `${Fecha_inicio.getFullYear()}-${('0' + (Fecha_inicio.getMonth()+1)).slice(-2)}-${('0' + Fecha_inicio.getDate()).slice(-2)}`;
            var formattedFecha_fin = `${Fecha_fin.getFullYear()}-${('0' + (Fecha_fin.getMonth()+1)).slice(-2)}-${('0' + Fecha_fin.getDate()).slice(-2)}`;

            if (sueldo.Comprobante_ruta === undefined || sueldo.Comprobante_ruta === null || Object.keys(sueldo.Comprobante_ruta).length === 0) {
                $('#tabla-sueldos tbody').append(`
                <tr>
                    <td>${ID_estado_sueldo}</td>
                    <td>${ID_usuario}</td>
                    <td>${Cantidad_pagar}</td>
                    <td>${formattedFecha_inicio}</td>
                    <td>${formattedFecha_fin}</td>
                    <td data-id="${id_estado}">${Estatus}</td>
                    <td></td>
                </tr>
            `);    
            } else {
                $('#tabla-sueldos tbody').append(`
                <tr>
                    <td>${ID_estado_sueldo}</td>
                    <td>${ID_usuario}</td>
                    <td>${Cantidad_pagar}</td>
                    <td>${formattedFecha_inicio}</td>
                    <td>${formattedFecha_fin}</td>
                    <td data-id="${id_estado}">${Estatus}</td>
                    <td><a href="${Comprobante_ruta}">${Comprobante_ruta}</a></td>
                </tr>
            `);    
            }
           
        });
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer los sueldos: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}