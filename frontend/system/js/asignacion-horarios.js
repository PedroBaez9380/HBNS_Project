$(document).ready(function() {
    traerNomenclaturaHorarios();

    $('#boton-mas').on('click', function() {
        $('#contenedor-horarios').append(`
            <div class="contenedor-horario d-flex align-items-center m-3">
                <div class="clase-horario">
                    <p>Nomenclatura de horario:</p> 
                    <select name="lstClases" class="form-select combo-box-nomenclaturas">
                        <option selected value="">Seleccionar opcion</option>
                    </select>                       
                </div>
                <button class="boton-menos">-</button>
            </div>
        `);
        traerNomenclaturaHorarios(); 
    });

    $('#contenedor-horarios').on('click', '.boton-menos', function() {
        $(this).parent().remove();
    });

    $('#boton-guardar').on('click', function() {
        var asignaciones = [];
        $('.combo-box-nomenclaturas').each(function() {
            var ID_horario = $(this).find('option:selected').val();
            if (ID_horario) {
                asignaciones.push(parseInt(ID_horario));
            }
        });

        $.ajax({
            url: "https://localhost:7131/AsignacionHorarios/Guardar",
            type: 'POST',
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify({
                "Option": 'INSERT',
                "ID_usuario": $("#id-usuario").val(),
                "ID_horarios": asignaciones
            }),
            crossDomain: true
        }).done(function (result) {
            console.log(result);
            alert("Guardado exitoso!");

            $('#id-usuario, #nombre-usuario').val('');
            $('#contenedor-horarios').empty();
        }).fail(function (xhr, status, error) {
            alert("Hubo un problema al guardar: " + error + "\nStatus: " + status);
            console.error(xhr);
        });
    });

    $('#id-usuario').on('keydown', function(e) {
        if (e.which === 13) { // Código de tecla 13 es Enter
            e.preventDefault();
            $('#contenedor-horarios').empty();
            $.ajax({
                url: "https://localhost:7131/Usuarios/Traer/" + $(this).val(),
                type: 'GET',
                dataType: 'json',
                crossDomain: true
            }).done(function (result) {
                if (result.usuarios && result.usuarios.length > 0) {
                    var nombreUsuario = result.usuarios[0].Nombre + ' ' + result.usuarios[0].Apellido;
                    $('#nombre-usuario').val(nombreUsuario);
                } else {
                    alert("No se encontró el usuario");
                }
            }).fail(function (xhr, status, error) {
                alert("Hubo un problema al traer el usuario: " + error + "\nStatus: " + status);
                console.error(xhr);
            });

           
            $.ajax({
                url: "https://localhost:7131/AsignacionHorarios/Traer/" + $(this).val(),
                type: 'GET',
                dataType: 'json',
                crossDomain: true
            }).done(function (result) {
                result.usuarios.forEach(function(item, index) {
                    $('#contenedor-horarios').append(`
                        <div class="contenedor-horario d-flex align-items-center m-3">
                            <div class="clase-horario">
                                <p>Nomenclatura de horario:</p> 
                                <select name="lstClases" class="form-select combo-box-nomenclaturas" id="horario-${item.ID_horario}">
                                    <option selected value="${item.ID_horario}"></option>
                                </select>                       
                            </div>
                            <button class="boton-menos">-</button>
                        </div>
                    `);
                });
            
                
                setTimeout(function() {
                    result.usuarios.forEach(function(item, index) {
                        $('#horario-' + item.ID_horario).val(item.ID_horario);
                    });
                }, 100); // 100 milisegundos de espera
            
                traerNomenclaturaHorarios();
            }).fail(function (xhr, status, error) {
                alert("Hubo un problema al traer los horarios: " + error + "\nStatus: " + status);
                console.error(xhr);
            });
            


        }
    });
});

function traerNomenclaturaHorarios() {
    $.ajax({
        url: "https://localhost:7131/Horarios/Traer",
        type: 'GET',
        dataType: 'json',
        crossDomain: true
    }).done(function (result) {
        var opciones = '<option selected value="0">Seleccionar opción</option>';
        result.result.horario.forEach(function(item) {
            opciones += '<option value="' + item.iD_horario + '">' + item.nomenclatura + '</option>';
        });

        $('.combo-box-nomenclaturas').each(function() {
            if ($(this).children('option').length === 1) {
                $(this).html(opciones);
            }
        });
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer las asignaciones: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}



















