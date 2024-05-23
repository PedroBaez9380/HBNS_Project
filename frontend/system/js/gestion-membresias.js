$(document).ready(function() {
    $('#boton-guardar').attr('disabled', true);
    $('#boton-eliminar').attr('disabled', true);
    $('#boton-modificacion').attr('disabled', true);
    

    traerTodasMembresias();

    $('#boton-nuevo').click(function() {
        resetearCampos();
        habilitarCampos()
        $('#boton-guardar').attr('disabled', false);
        $('#boton-nuevo').attr('disabled', true);
        $('#boton-modificacion').attr('disabled', true);
        $('#boton-eliminar').attr('disabled', true);
    });

    $('#boton-guardar').click(function() {
        
        if ($("#ID-membresia").val() === "" ){
            option = "Guardar"
            typemod = 'POST'
            ID = null;
        } else {
            option = "Actualizar"
            typemod = 'PUT'
            ID = $("#ID-membresia").val();
        }
        $.ajax({
            url: "https://localhost:7131/Membresias/"+ option,
            type: typemod,
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify({
                "iD_membresia": ID,
                "nomenclatura": $("#nomenclatura").val(),
                "descripcion": $("#descripcion").val(),
                "costo": $("#costo").val(),
                "duracion": $("#duracion").val()
                }),
            crossDomain: true
        }).done(function (result) {
            console.log(result);
            resetearCampos();

            alert("Guardado exitoso!");
            traerTodasMembresias()

            $('#boton-guardar').attr('disabled', true);
            $('#boton-nuevo').attr('disabled', false);
            $('#boton-modificacion').attr('disabled', true);
            $('#boton-eliminar').attr('disabled', true);
            

        }).fail(function (xhr, status, error) {
            alert("Hubo un problema al guardar: " + error + "\nStatus: " + status);
            console.error(xhr);
        });
        
    });

    $('#tabla-cuerpo').on('click', 'tr', function() {
        desHabilitarCampos()
        var idMembresia = $(this).find('td:eq(0)').text().trim();
        var nomenclatura = $(this).find('td:eq(1)').text().trim();
        var descripcion = $(this).find('td:eq(2)').text().trim();
        var costo = $(this).find('td:eq(3)').text().trim();
        var duracion = $(this).find('td:eq(4)').text().trim();
        $('#ID-membresia').val(idMembresia);
        $('#nomenclatura').val(nomenclatura);
        $('#descripcion').val(descripcion);
        $('#costo').val(costo);
        $('#duracion').val(duracion);
            
        $('#boton-eliminar').attr('disabled', false);
        $('#boton-guardar').attr('disabled', true);
        $('#boton-nuevo').attr('disabled', false);
        $('#boton-modificacion').attr('disabled', false);
        
    });

    $('#boton-eliminar').click(function() {
        $.ajax({
            url: "https://localhost:7131/Membresias/Borrar",
            type: 'DELETE',
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify({
                "iD_membresia": $("#ID-membresia").val(),
            }),
            crossDomain: true
        }).done(function (result) {
            console.log(result);
            traerTodasMembresias()
            resetearCampos();
            alert("Borrado exitoso!");
            $('#boton-guardar').attr('disabled', true);
            $('#boton-nuevo').attr('disabled', false);
            $('#boton-eliminar').attr('disabled', true);
            $('#boton-modificacion').attr('disabled', true);
            

        }).fail(function (xhr, status, error) {
            alert("Hubo un problema al guardar: " + error + "\nStatus: " + status);
            console.error(xhr);
        });
        
    });

    $('#boton-modificacion').click(function() {
        habilitarCampos()
        $('#boton-guardar').attr('disabled', false);
        $('#boton-nuevo').attr('disabled', true);
        $('#boton-eliminar').attr('disabled', true);
        $('#boton-modificacion').attr('disabled', true);
    });
    
});

function traerTodasMembresias() {
    $.ajax({
        url: "https://localhost:7131/Membresias/Traer",
        type: 'GET',
        dataType: 'json',
        crossDomain: true
    }).done(function (result) {
        construirTabla(result.result.membresias);
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer los horarios: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}

function construirTabla(membresias) {
    var tablaCuerpo = $('#tabla-cuerpo');

    tablaCuerpo.empty();

    membresias.forEach(function(membresia) {
        var fila = '<tr>' +
            '<td>' + membresia.iD_membresia + '</td>' +
            '<td>' + membresia.nomenclatura + '</td>' +
            '<td>' + membresia.descripcion + '</td>' +
            '<td>' + membresia.costo + '</td>' +
            '<td>' + membresia.duracion + '</td>' +
            '</tr>';

        tablaCuerpo.append(fila);
    });
}




function habilitarCampos(){
    $('#nomenclatura').removeAttr('disabled');
    $('#descripcion').removeAttr('disabled');
    $('#costo').removeAttr('disabled');
    $('#duracion').removeAttr('disabled');
}

function desHabilitarCampos(){
    $('#nomenclatura').attr('disabled', true);
    $('#descripcion').attr('disabled', true);
    $('#costo').attr('disabled', true);
    $('#duracion').attr('disabled', true);
}

function resetearCampos(){
    $('#ID-membresia').val("");
    $('#nomenclatura').val("");
    $('#descripcion').val("");
    $('#costo').val("");
    $('#duracion').val("");
}