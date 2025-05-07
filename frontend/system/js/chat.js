$(document).ready(function() {

    $.ajax({
        url: "https://localhost:7131/Usuarios/TraerTodosUsuarios",
        type: 'GET',
        dataType: 'json',
        crossDomain: true
    }).done(function (result) {
         result.usuarios.forEach(function(usuario) {
            var ID_usuario = usuario.ID_usuario;
            var Nombre = usuario.Nombre;
            var Apellido = usuario.Apellido;
            const id = new URL(window.location.href).searchParams.get('id'); // Obtiene el valor del parámetro 'id'

            if (ID_usuario != id){
                $('#usuarios-traer').append(`
                    <button data-id="${ID_usuario}" class="boton-usuario">${Nombre} ${Apellido}</button>
                `);    
            }
            
        });
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer los usuarios: " + error + "\nStatus: " + status);
        console.error(xhr);
    });

    
    $(document).on('click', '.boton-usuario', function() {

        // 2. Remover la clase de selección de todos los botones dentro de #usuarios-traer
        $('#usuarios-traer button').removeClass('seleccionado');

        // 3. Agregar una clase al botón clickeado para cambiar su color
        $(this).addClass('seleccionado');

        var id_seleccionado = $(this).attr('data-id');
        var nombre_seleccionado = $(this).text();
        traerMensajes(id_seleccionado, nombre_seleccionado);
        $('#mensaje-escribir').removeAttr('disabled')
        $('#mensaje-escribir').val('')
        $('#btn-enviar').removeAttr('disabled')
        
    });

    $(document).on('click', '#btn-enviar', function() {
        var mensajevacio = $('#mensaje-escribir').val();
        if (mensajevacio == ''){
            return;
        }
        const urlParams = new URLSearchParams(window.location.search);
        const id_actual = urlParams.get('id');
        var id_seleccionado = $('#usuario-actual').attr('data-id');

        // Obtener la fecha y hora actual
        const fecha_actual = new Date();

        const year = fecha_actual.getFullYear();
        const month = (fecha_actual.getMonth() + 1).toString().padStart(2, '0');
        const day = fecha_actual.getDate().toString().padStart(2, '0');
        const hours = fecha_actual.getHours().toString().padStart(2, '0');
        const minutes = fecha_actual.getMinutes().toString().padStart(2, '0');
        const seconds = fecha_actual.getSeconds().toString().padStart(2, '0');

        const fecha_hora_actual_string = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    
        $.ajax({
            url: "https://localhost:7131/Chats/Guardar",
            type: 'POST',
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify({
                "iD_usuario_actual": id_actual,
                "iD_usuario_seleccionado": id_seleccionado,
                "mensaje": $("#mensaje-escribir").val(),
                "fecha_envio": fecha_hora_actual_string
            }),
            crossDomain: true
        }).done(function (result) {
            nombre_seleccionado = $('#usuario-actual').text();
            id_seleccionado = $('#usuario-actual').attr('data-id');
            traerMensajes(id_seleccionado, nombre_seleccionado)
            $('#mensaje-escribir').val('');
            
            
        }).fail(function (xhr, status, error) {
            alert("Hubo un problema al mandar el mensaje: " + error + "\nStatus: " + status);
            console.error(xhr);
        });
    });

    $('#buscar-usuarios').on('input', function() {
        var textoBusqueda = $(this).val().toLowerCase();
        
        $('#usuarios-traer button').each(function() {
            var textoBoton = $(this).text().toLowerCase();
            
            if (textoBoton.includes(textoBusqueda)) {
                $(this).show();
            } else {
                $(this).hide();
            }
        });
        
        // Si no hay texto de búsqueda, mostrar todos los botones
        if (textoBusqueda === '') {
            $('#usuarios-traer button').show();
        }
    });
    

});

// Traer los mensajes 
function traerMensajes(id_seleccionado, nombre_seleccionado) {
    const urlParams = new URLSearchParams(window.location.search);
    const id_actual = urlParams.get('id');
    
    $.ajax({
        url: "https://localhost:7131/Chats/Traer/" + id_actual + "/" + id_seleccionado,
        type: 'GET',
        dataType: 'json',
        crossDomain: true
    }).done(function (result) {
        actualizarInterfazMensajes(result.mensajes, nombre_seleccionado, id_seleccionado);
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer los mensajes: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}

// Actualizar automáticamente los mensajes
function actualizarMensajesAutomaticamente() {
    const urlParams = new URLSearchParams(window.location.search);
    const id_actual = urlParams.get('id');
    const id_seleccionado = $('#usuario-actual').attr('data-id');
    
    // Verificar si se ha seleccionado un chat específico
    if (id_seleccionado) {
        const nombre_seleccionado = $('#usuario-actual').text();

        // Llamar a la función para traer los mensajes del servidor
        traerMensajes(id_seleccionado, nombre_seleccionado);
    } else {
        console.log("No se ha seleccionado un chat específico.");
    }
}


setInterval(actualizarMensajesAutomaticamente, 5000); // Con esto se llama la funcion cada 5 segundos


function actualizarInterfazMensajes(mensajes, nombre_seleccionado, id_seleccionado) {
    $('#todos-mensajes').empty();
    $('#usuario-actual').text(nombre_seleccionado);
    $('#usuario-actual').attr('data-id', id_seleccionado);

    mensajes.forEach(function(mensaje) {
        var Mensaje_var = mensaje.Mensaje;
        var Fecha_envio_var = mensaje.Fecha_envio;
        var TipoMensaje_var = mensaje.TipoMensaje;

        const fecha_envio_iso = Fecha_envio_var;
        const fecha_envio = new Date(fecha_envio_iso);
        const dia = fecha_envio.getDate();
        const hora = fecha_envio.getHours();
        const minutos = fecha_envio.getMinutes();
        const fecha_hora_formateada = `${dia}/${fecha_envio.getMonth() + 1}/${fecha_envio.getFullYear()} ${hora}:${minutos}`;
        
        if (TipoMensaje_var === 'Enviado'){
            $('#todos-mensajes').append(`
                <div class="mensaje-emisor">
                    <div class="mensaje">
                        ${Mensaje_var}
                    </div>
                    
                    <div class="hora-fecha">
                        ${fecha_hora_formateada}
                    </div>
                </div>
            `);  
        } else if (TipoMensaje_var === 'Recibido'){
            $('#todos-mensajes').append(`
                <div class="mensaje-receptor">
                    <div class="mensaje">
                        ${Mensaje_var}
                    </div>
                    
                    <div class="hora-fecha">
                        ${fecha_hora_formateada}
                    </div>
                </div>
            `);  
        } else {
            alert("Hubo un problema al cargar un mensaje");
        }
    });
    $('#todos-mensajes').scrollTop($('#todos-mensajes')[0].scrollHeight);
}

