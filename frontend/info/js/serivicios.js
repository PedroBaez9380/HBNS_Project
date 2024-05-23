$(document).ready(function() {
    traerClase();

    $('#lstClases').change(function() {
        var seleccionado = $(this).val();
        traerHorarios(seleccionado);
    });
});

function traerHorarios(seleccionado) {
    $.ajax({
        url: "https://localhost:7131/Horariosxclase/TraerHorarios/" + seleccionado,
        type: 'GET',
        dataType: 'json',
        crossDomain: true
    }).done(function (result) {
        $('#horario-lunes').empty();
        $('#horario-martes').empty();
        $('#horario-miercoles').empty();
        $('#horario-jueves').empty();
        $('#horario-viernes').empty();
        $('#horario-sabado').empty();
        console.log(result.result.horarios)
        result.result.horarios.forEach(function(horario) {
            switch (horario.iD_dia) {
                case 1:
                    $('#horario-lunes').append('<p>' + horario.nomenclatura + ': ' + horario.hora_inicio + ' - ' + horario.hora_final + '</p>');
                    break;
                case 2:
                    $('#horario-martes').append('<p>' + horario.nomenclatura + ': ' + horario.hora_inicio + ' - ' + horario.hora_final + '</p>');
                    break;
                case 3:
                    $('#horario-miercoles').append('<p>' + horario.nomenclatura + ': ' + horario.hora_inicio + ' - ' + horario.hora_final + '</p>');
                    break;
                case 4:
                    $('#horario-jueves').append('<p>' + horario.nomenclatura + ': ' + horario.hora_inicio + ' - ' + horario.hora_final + '</p>');
                    break;
                case 5:
                    $('#horario-viernes').append('<p>' + horario.nomenclatura + ': ' + horario.hora_inicio + ' - ' + horario.hora_final + '</p>');
                    break;
                case 6:
                    $('#horario-sabado').append('<p>' + horario.nomenclatura + ': ' + horario.hora_inicio + ' - ' + horario.hora_final + '</p>');
                    break;
                default:
                    break;
            }
        });
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer las clases: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}

function traerClase() {
    $.ajax({
        url: "https://localhost:7131/Clases/Traer",
        type: 'GET',
        dataType: 'json',
        crossDomain: true
    }).done(function (result) {
        var opciones = '<option selected value="0">Seleccionar opción</option>';
        result.clases.forEach(function(item) {
            opciones += '<option value="' + item.ID_clase + '">' + item.Nombre + '</option>';
        });
        $('#lstClases').each(function() {
            if ($(this).children('option').length === 1) {
                $(this).html(opciones);
            }
        });
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer las clases: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}
