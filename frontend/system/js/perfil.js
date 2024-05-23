$(document).ready(function() {
    var urlParams = new URLSearchParams(window.location.search);
    var userID = urlParams.get('id');

    $.ajax({
        url: "https://localhost:7131/Usuarios/Traer/" + userID,
        type: 'GET',
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        crossDomain: true
    }).done(function (result) {
        $('#Nombre').text(result.usuarios[0].Nombre + " " + result.usuarios[0].Apellido)
        $('#TipoUsuario').text(result.usuarios[0].TipoUsuarioDescripcion)
        $('#Telefono').text(result.usuarios[0].Telefono)
        $('#Correo').text(result.usuarios[0].Correo)
        $('#N-usuario').text(result.usuarios[0].ID_usuario)

    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer tus datos: " + error + "\nStatus: " + status);
        console.error(xhr);
    });

    
});