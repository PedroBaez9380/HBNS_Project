$(document).ready(function() {
    
    $('#boton-guardar').attr('disabled', true);
    $('#boton-eliminar').attr('disabled', true);
    limpiarCampos();
    
    traerTodosHorarios();
    
    $('#boton-nuevo').click(function() {
        habilitarCampos()
        traerDiaSemana()
        traerClase()
        $('#boton-guardar').attr('disabled', false);
        $('#boton-nuevo').attr('disabled', true);
    });

    $('#boton-guardar').click(function() {
        if ($("#ID_horario").val().trim() === "" ){
            option = "Guardar"
            typemod = 'POST'
            ID = null;
        } else {
            option = "Actualizar"
            typemod = 'PUT'
            ID = $("#ID_horario").val();
        }
        $.ajax({
            url: "https://localhost:7131/Horarios/"+ option,
            type: typemod,
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify({
                "iD_horario": ID,
                "iD_clase": $("#lstClasesDeHorario").val(),
                "nomenclatura": $("#Nomenclatura").val(),
                "hora_inicio": $("#Hora_inicio").val(),
                "hora_final": $("#Hora_final").val(),
                "iD_dia": $("#lstDiasDeHorario").val()
            }),
            crossDomain: true
        }).done(function (result) {
            console.log(result);
            traerTodosHorarios()
            resetearCampos();
            alert("Guardado exitoso!");
            

        }).fail(function (xhr, status, error) {
            alert("Hubo un problema al guardar: " + error + "\nStatus: " + status);
            console.error(xhr);
        });
        $('#boton-guardar').attr('disabled', true);
        $('#boton-nuevo').attr('disabled', false);
        $('#boton-eliminar').attr('disabled', true);
    });

    $('#boton-eliminar').click(function() {
        $.ajax({
            url: "https://localhost:7131/Horarios/Borrar",
            type: 'DELETE',
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify({
                "iD_horario": $("#ID_horario").val(),
            }),
            crossDomain: true
        }).done(function (result) {
            console.log(result);
            traerTodosHorarios()
            resetearCampos();
            alert("Borrado exitoso!");
            

        }).fail(function (xhr, status, error) {
            alert("Hubo un problema al guardar: " + error + "\nStatus: " + status);
            console.error(xhr);
        });
        $('#boton-guardar').attr('disabled', true);
        $('#boton-nuevo').attr('disabled', false);
        $('#boton-eliminar').attr('disabled', true);
    });

    
    $('#tabla-cuerpo').on('click', 'tr', function() {
        var idHorario = $(this).find('td:eq(0)').text().trim();
        var nomenclatura = $(this).find('td:eq(1)').text().trim();
        var hora = $(this).find('td:eq(2)').text().trim();
        var clase = $(this).find('td:eq(3)').text().trim();
        var dia = $(this).find('td:eq(4)').text().trim();
        

        var horasSeparadas = hora.split(' - ');
        var horaInicio = horasSeparadas[0];
        var horaFinal = horasSeparadas[1];
        traerDiaSemana()
        traerClase()

        setTimeout(function() {
            $('#ID_horario').val(idHorario);
            $('#Nomenclatura').val(nomenclatura);
            $('#Hora_inicio').val(horaInicio);
            $('#Hora_final').val(horaFinal);
            $('#lstClasesDeHorario option').each(function() {
                if ($(this).text().trim() === clase) {
                    $(this).prop('selected', true);
                }
            });
            $('#lstDiasDeHorario option').each(function() {
                if ($(this).text().trim() === dia) {
                    $(this).prop('selected', true);
                }
            });
            habilitarCampos()
        }, 100); // 100 milisegundos de espera

        $('#boton-eliminar').attr('disabled', false);
        $('#boton-guardar').attr('disabled', false);
        $('#boton-nuevo').attr('disabled', true);
        
    });
    
    
    
});



function traerTodosHorarios() {
    $.ajax({
        url: "https://localhost:7131/Horarios/Traer",
        type: 'GET',
        dataType: 'json',
        crossDomain: true
    }).done(function (result) {

        construirTabla(result.result.horario);
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer los horarios: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}

function construirTabla(horarios) {
    var tablaCuerpo = $('#tabla-cuerpo');

    tablaCuerpo.empty();

    horarios.forEach(function(horario) {
        var fila = '<tr>' +
            '<td>' + horario.iD_horario + '</td>' +
            '<td>' + horario.nomenclatura + '</td>' +
            '<td>' + horario.hora_inicio + ' - ' + horario.hora_final + '</td>' +
            '<td>' + horario.nombreClase + '</td>' +
            '<td>' + horario.descripcionDia + '</td>' +
            '</tr>';

        // Agregar la fila al cuerpo de la tabla
        tablaCuerpo.append(fila);
    });
}


function traerDiaSemana() {
    $.ajax({
        url: "https://localhost:7131/DiaSemana/Traer",
        type: 'GET',
        dataType: 'json',
        crossDomain: true
    }).done(function (result) {
        var opciones = '<option selected value="0">Seleccionar opción</option>';
        result.dias.forEach(function(item) {
            opciones += '<option value="' + item.ID_dia + '">' + item.Descripcion + '</option>';
        });

        $('#lstDiasDeHorario').each(function() {
            if ($(this).children('option').length === 1) {
                $(this).html(opciones);
            }
        });
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer los dias: " + error + "\nStatus: " + status);
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

        $('#lstClasesDeHorario').each(function() {
            if ($(this).children('option').length === 1) {
                $(this).html(opciones);
            }
        });
    }).fail(function (xhr, status, error) {
        alert("Hubo un problema al traer las clases: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
}

function habilitarCampos(){
    $('#Nomenclatura').removeAttr('disabled');
    $('#Hora_inicio').removeAttr('disabled');
    $('#Hora_final').removeAttr('disabled');
    $('#lstClasesDeHorario').removeAttr('disabled');
    $('#lstDiasDeHorario').removeAttr('disabled');
}

function limpiarCampos(){
    $('#Nomenclatura').attr('disabled', true);
    $('#Hora_inicio').attr('disabled', true);
    $('#Hora_final').attr('disabled', true);
    $('#lstClasesDeHorario').attr('disabled', true);
    $('#lstDiasDeHorario').attr('disabled', true);

    $('#Nomenclatura').val("");
    $('#Hora_inicio').val("");
    $('#Hora_final').val("");
    $('#lstClasesDeHorario').val("");
    $('#lstDiasDeHorario').val("");
}