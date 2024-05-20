$(document).ready(function() {
    var params = new URLSearchParams(window.location.search);
    var userId = params.get('id');

    $('#boton-regresar').click(function(e) {
        console.log('Botón clickeado');
        e.preventDefault();
        // Redirigir a funciones.html con el userId como parámetro
        window.location.href = "funciones.html?id=" + userId;
    });
    
});

        