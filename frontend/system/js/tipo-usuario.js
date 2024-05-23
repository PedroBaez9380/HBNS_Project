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
            url: "https://localhost:7131/TipoUsuarios/Guardar",
            type: 'POST',
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify({
                "descripcion": $("#descripcion").val()
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
            url: "https://localhost:7131/TipoUsuarios/Eliminar",
            type: 'DELETE',
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify({
                "ID_tipo_usuario": $("#id-tipo").val()
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
        $('#boton-modificacion').attr('disabled', false);

        $('#id-tipo').val($(this).find('td:eq(0)').text().trim());
        $('#descripcion').val($(this).find('td:eq(1)').text().trim());

        
    });

});

function traerTiposUsuario() {
    $('#tabla-cuerpo').empty();
    $.ajax({
        url: "https://localhost:7131/TipoUsuarios/TraerTodos",
        type: 'GET',
        dataType: 'json',
        crossDomain: true,
        headers: {
            'Content-Type': 'application/json'
        }
    }).done(function (result) {
         result.result.tiposUsuario.forEach(function(TipoUsuarios) {
            var ID_tipo_usuario = TipoUsuarios.iD_tipo_usuario;
            var descripcion = TipoUsuarios.descripcion;
        
            $('#tabla-tipos-usuario tbody').append(`
                <tr>
                    <td>${ID_tipo_usuario}</td>
                    <td>${descripcion}</td>
                </tr>
            `);    
        });
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer los tipos de usuario: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}