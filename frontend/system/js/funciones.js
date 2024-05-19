$(document).ready(function() {
    const params = new URLSearchParams(window.location.search);
    var userId = params.get('id');    
    $.ajax({
        url: `https://localhost:7131/Funciones/ObtenerFunciones/${userId}`,
        method: 'GET',
        success: function(data) {
            if (data.funciones && data.funciones.length > 0) {
                data.funciones.forEach(function(funcion) {
                    // Eliminar \r\n del contenido HTML
                    funcion = funcion.replace(/\r\n/g, '');

                    $('#contenedor-funciones').append(funcion);
                });
            } else {
                console.log("No se encontraron funciones.");
            }
        },
        error: function(error) {
            console.error('Error:', error);
        }
    });
});
