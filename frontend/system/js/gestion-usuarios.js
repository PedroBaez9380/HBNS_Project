$(document).ready(function() {
    traerUsuarios();
    traerTiposUsuario()
    deshabilitarCamposUsuario();
    $('#boton-guardar').attr('disabled', true);
    $('#boton-modificacion').attr('disabled', true);

    $('#boton-guardar').click(function() {
        if ($("#lstEstado").val() === "1") {
            var estado_var = true
        } else if ($("#lstEstado").val() === "0") {
            var estado_var = false
        }

        if ($("#N-usuario").text() === "" ){
            option = "Guardar"
            typemod = 'POST'
            var fechaActual = obtenerFechaActual();
            ID = null;
        } else {
            option = "Actualizar"
            typemod = 'PUT'
            ID = $("#N-usuario").text();
            var fechaActual = null;
        }
        $.ajax({
            url: "https://localhost:7131/Usuarios/"+ option,
            type: typemod,
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify({
                "iD_usuario": ID,
                "contrasena": $("#contrasena").val(),
                "iD_tipo_usuario": $("#lstTipoUsuario").val(),
                "nombre": $("#nombre").val(),
                "apellido": $("#apellido").val(),
                "telefono": $("#telefono").val(),
                "correo": $("#correo").val(),
                "fecha_registro": fechaActual,
                "fecha_nacimiento": $("#fecha-nacimiento").val(),
                "estado": estado_var
            }),
            crossDomain: true
        }).done(function (result) {
            console.log(result);
            limpiarCamposUsuario()
            deshabilitarCamposUsuario()
            traerUsuarios()
            alert("Guardado exitoso!");
            

        }).fail(function (xhr, status, error) {
            alert("Hubo un problema al guardar: " + error + "\nStatus: " + status);
            console.error(xhr);
        });
        $('#boton-guardar').attr('disabled', true);
        $('#boton-nuevo').attr('disabled', false);
        $('#boton-modifiacion').attr('disabled', true);
    });

    $('#boton-nuevo').click(function() {
        habilitarCamposUsuario()
        limpiarCamposUsuario() 
        $('#boton-guardar').attr('disabled', false);
        $('#boton-nuevo').attr('disabled', true);
        $('#boton-modificacion').attr('disabled', true);
    });

    $('#boton-modificacion').click(function() {
        habilitarCamposUsuario()
        $('#boton-guardar').attr('disabled', false);
        $('#boton-nuevo').attr('disabled', true);
        $('#boton-modificacion').attr('disabled', true);
    });


    $('#tabla-cuerpo').on('click', 'tr', function() {
        
        $('#boton-guardar').attr('disabled', true);
        $('#boton-nuevo').attr('disabled', false);
        $('#boton-modificacion').attr('disabled', false);
        var id_usuario = $(this).find('td:eq(0)').text().trim();
        var tipo_usuario = $(this).find('td:eq(1)').attr('data-id');
        var nombre = $(this).find('td:eq(2)').text().trim();
        var apellido = $(this).find('td:eq(3)').text().trim();
        var telefono = $(this).find('td:eq(4)').text().trim();
        var correo = $(this).find('td:eq(5)').text().trim();
        var fecha_registro = $(this).find('td:eq(6)').text().trim();
        var fecha_nacimiento = $(this).find('td:eq(7)').text().trim();
        var contrasena = $(this).find('td:eq(8)').text().trim();
        var estado = $(this).find('td:eq(9)').attr('data-id');


        $('#N-usuario').text(id_usuario);
        $('#contrasena').val(contrasena);
        $('#lstTipoUsuario').val(tipo_usuario);
        $('#nombre').val(nombre);
        $('#apellido').val(apellido);
        $('#telefono').val(telefono);
        $('#correo').val(correo);
        $('#fecha-registro').val(fecha_registro);
        $('#fecha-nacimiento').val(fecha_nacimiento);
        $('#lstEstado').val(estado);
        
        deshabilitarCamposUsuario();
        
    });

    $('#buscarUsuario').on('input', function() {
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

function traerUsuarios() {
    $('#tabla-usuarios tbody').empty();
    $.ajax({
        url: "https://localhost:7131/Usuarios/TraerTodosUsuarios",
        type: 'GET',
        dataType: 'json',
        crossDomain: true
    }).done(function (result) {
         result.usuarios.forEach(function(usuario) {
            var ID_usuario = usuario.ID_usuario;
            var ID_TipoUsuario = usuario.ID_tipo_usuario;
            var TipoUsuario = usuario.TipoUsuarioDescripcion;
            var Nombre = usuario.Nombre;
            var Apellido = usuario.Apellido;
            var Correo = usuario.Correo;
            var Telefono = usuario.Telefono
            var Fecha_registro = usuario.Fecha_registro.substring(0, 10);
            var Fecha_nacimiento = usuario.Fecha_nacimiento.substring(0, 10);
            var Contrasena = usuario.Contrasena
            var Estado;
            if (usuario.Estado) {
                Estado = 'Activo';
                id_estado = '1';
            } else {
                Estado = 'Inactivo';
                id_estado = '0'
            }
            $('#tabla-usuarios tbody').append(`
                <tr>
                    <td>${ID_usuario}</td>
                    <td data-id="${ID_TipoUsuario}">${TipoUsuario}</td>
                    <td>${Nombre}</td>
                    <td>${Apellido}</td>
                    <td>${Telefono}</td>
                    <td>${Correo}</td>
                    <td>${Fecha_registro}</td>
                    <td>${Fecha_nacimiento}</td>
                    <td>${Contrasena}</td>
                    <td data-id="${id_estado}">${Estado}</td>
                </tr>
            `);    
        });
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer los usuarios: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}

function traerTiposUsuario() {
    $.ajax({
        url: "https://localhost:7131/TipoUsuarios/TraerTodos",
        type: 'GET',
        dataType: 'json',
        crossDomain: true
    }).done(function (result) {
         result.result.tiposUsuario.forEach(function(tiposUsuario) {
            $('#lstTipoUsuario').append(`
                <option value="${tiposUsuario.iD_tipo_usuario}">${tiposUsuario.descripcion}</option>
            `);    
        });
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer los tipos de usuario: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}

function habilitarCamposUsuario() {
    $('#contrasena').removeAttr('disabled');
    $('#lstTipoUsuario').removeAttr('disabled');
    $('#nombre').removeAttr('disabled');
    $('#apellido').removeAttr('disabled');
    $('#telefono').removeAttr('disabled');
    $('#correo').removeAttr('disabled');
    $('#fecha-nacimiento').removeAttr('disabled');
    $('#lstEstado').removeAttr('disabled');
}

function deshabilitarCamposUsuario() {
    $('#contrasena').attr('disabled', true);
    $('#lstTipoUsuario').attr('disabled', true);
    $('#nombre').attr('disabled', true);
    $('#apellido').attr('disabled', true);
    $('#telefono').attr('disabled', true);
    $('#correo').attr('disabled', true);
    $('#fecha-nacimiento').attr('disabled', true);
    $('#lstEstado').attr('disabled', true);
}

function obtenerFechaActual() {
    const fecha = new Date();
    const year = fecha.getFullYear();
    let month = fecha.getMonth() + 1;
    let day = fecha.getDate();

    if (month < 10) {
        month = '0' + month;
    }
    if (day < 10) {
        day = '0' + day;
    }

    const fechaFormateada = `${year}-${month}-${day}`;
    return fechaFormateada;
}

function limpiarCamposUsuario() {
    $('#N-usuario').text("");
    $('#contrasena').val("");
    $('#lstTipoUsuario').val("default");
    $('#nombre').val("");
    $('#apellido').val("");
    $('#telefono').val("");
    $('#correo').val("");
    $('#fecha-registro').val("");
    $('#fecha-nacimiento').val("");
    $('#lstEstado').val("default");
}
