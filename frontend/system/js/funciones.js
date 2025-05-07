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

                // Adjuntar evento de clic a los botones dentro de '.texto-funcion'
                $('#contenedor-funciones').on('click', '.texto-funcion button', function(e) {
                    // Evitar el comportamiento predeterminado del botón
                    e.preventDefault();

                    // Obtener la URL de destino del atributo 'id' del botón
                    var destinationUrl = $(this).attr('id');

                    // Construir la nueva URL con el userId como parámetro
                    var newUrl = destinationUrl + '?id=' + userId;

                    // Redirigir a la nueva URL
                    window.location.href = newUrl;
                });
            } else {
                console.log("No se encontraron funciones.");
                
            }
        },
        error: function(jqXHR, textStatus, errorThrown) {
            console.error('Error:', jqXHR, textStatus, errorThrown);
            // Verifica si la respuesta de la API contiene el mensaje específico
            if (jqXHR.responseText === "No se encontraron roles asignados para el usuario.") {
                alert("No se encontraron roles asignados para el usuario.");
            } else {
                // Muestra un mensaje de error más general o el detalle del error
                alert("Ocurrió un error al obtener las funciones: " + (jqXHR.responseText || textStatus || errorThrown));
            }
        }
    
    });
});
