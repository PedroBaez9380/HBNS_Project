$(document).ready(function() {
    traerTiposUsuario()

    $('#boton-nuevo').on('click', function() {
        $('#boton-nuevo').attr('disabled', true)
        $('#boton-eliminar').attr('disabled', true)
        $('#boton-guardar').attr('disabled', false)

        $('#id-tipo').val('')
        $('#descripcion').val('')
        $('#descripcion').attr('disabled', false)
        
    });

    $('#boton-guardar').on('click', function() {
        $.ajax({
            url: "https://localhost:7131/Clases/Guardar",
            type: 'POST',
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify({
                "Nombre": $("#descripcion").val()
            }),
            crossDomain: true
        }).done(function (result) {
            console.log(result);
            alert("Guardado exitoso!");
            $('#boton-nuevo').attr('disabled', false)
            $('#boton-eliminar').attr('disabled', true)
            $('#boton-guardar').attr('disabled', true)

            $('#id-tipo').val('')
            $('#descripcion').val('')
            $('#descripcion').attr('disabled', false)

            traerTiposUsuario()
            
        }).fail(function (xhr, status, error) {
            alert("Hubo un problema al guardar: " + error + "\nStatus: " + status);
            console.error(xhr);
        });
    });

    $('#boton-eliminar').on('click', function() {
        $.ajax({
            url: "https://localhost:7131/Clases/Eliminar",
            type: 'DELETE',
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify({
                "ID_clase": $("#id-tipo").val()
            }),
            crossDomain: true
        }).done(function (result) {
            console.log(result);
            alert("Borrado exitoso!");
            $('#boton-nuevo').attr('disabled', false)
            $('#boton-eliminar').attr('disabled', true)
            $('#boton-guardar').attr('disabled', true)

            $('#id-tipo').val('')
            $('#descripcion').val('')
            $('#id-tipo').attr('disabled', true)
            $('#descripcion').attr('disabled', true)

            traerTiposUsuario()
            
        }).fail(function (xhr, status, error) {
            alert("Hubo un problema al eliminar: " + error + "\nStatus: " + status);
            console.error(xhr);
        });
    });

    $('#tabla-cuerpo').on('click', 'tr', function() {
        
        $('#boton-guardar').attr('disabled', true);
        $('#boton-nuevo').attr('disabled', false);
        $('#boton-eliminar').attr('disabled', false);

        $('#id-tipo').val($(this).find('td:eq(0)').text().trim());
        $('#descripcion').val($(this).find('td:eq(1)').text().trim());

        $('#descripcion').attr('disabled', true);

        
    });

});

function traerTiposUsuario() {
    $('#tabla-cuerpo').empty();
    $.ajax({
        url: "https://localhost:7131/Clases/Traer",
        type: 'GET',
        dataType: 'json',
        crossDomain: true,
        headers: {
            'Content-Type': 'application/json'
        }
    }).done(function (result) {
        result.clases.forEach(function(clase) {
            var ID_clase = clase.ID_clase;
            var nombre = clase.Nombre;
        
            $('#tabla-tipos-usuario tbody').append(`
                <tr>
                    <td>${ID_clase}</td>
                    <td>${nombre}</td>
                </tr>
            `);    
        });
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer los tipos de usuario: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}