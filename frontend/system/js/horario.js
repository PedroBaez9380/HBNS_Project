$(document).ready(function() {
    var urlParams = new URLSearchParams(window.location.search);
    var userID = urlParams.get('id');
    
    $.ajax({
        url: "https://localhost:7131/AsignacionHorarios/Traer/" + userID,
        type: 'GET',
        dataType: 'json',
        crossDomain: true
    }).done(function(result) {
        console.log(result);
        result.clases.forEach(function(clase) {
            var horaInicio = clase.Hora_inicio.slice(0, 5); 
            var horaFinal = clase.Hora_final.slice(0, 5); 
            var dia = clase.DescripcionDia;
            var descripcionClase = clase.NombreClase;
            $('#tabla-horario tbody').append(`
                <tr>
                    <th>${horaInicio} - <br> ${horaFinal}</th>
                    <td class="Lunes"></td>
                    <td class="Martes"></td>
                    <td class="Miercoles"></td>
                    <td class="Jueves"></td>
                    <td class="Viernes"></td>
                    <td class="Sabado"></td>
                    <td class="Domingo"></td>
                </tr>
            `);
    
            var cell = $('#tabla-horario tbody tr:last-child .' + dia);
            cell.text(descripcionClase);
        });
    }).fail(function(xhr, status, error) {
        alert("Hubo un problema al traer tu horario: " + error + "\nStatus: " + status);
        console.error(xhr);
    });
    
});

