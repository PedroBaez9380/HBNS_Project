$(document).ready(function() {
    $('#id-usuario').on('keydown', function(e) {
        if (e.which === 13) { // Código de tecla 13 es Enter
            var userID = $('#id-usuario').val()

            e.preventDefault();
            $('.check').removeAttr('disabled');
            $.ajax({
                url: "https://localhost:7131/Roles/Traer/" + userID,
                type: 'GET',
                dataType: 'json',
                crossDomain: true
            }).done(function (result) {
                result.mensajes.forEach(function(mensaje) {
                    var ID_rol = mensaje.ID_rol 

                    var checkbox = document.querySelector(`#roles input[type="checkbox"][value="${ID_rol}"]`);
                    if (checkbox) {
                      checkbox.checked = true;
                    }
                    
                });
                $('#boton-guardar').attr('disabled', false);
            }).fail(function (xhr, status, error) {
                alert("Hubo un problema al traer los roles: " + error + "\nStatus: " + status);
                console.error(xhr);
            });
    
            
        }
    });

    $('#boton-guardar').click(function() {
        const ValoresCheck = ObtenerChecks();

        $.ajax({
            url: "https://localhost:7131/Roles/Guardar",
            type: 'POST',
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify({
                "iD_usuario": $('#id-usuario').val(),
                "iD_rol": ValoresCheck
                
            }),
            crossDomain: true
        }).done(function (result) {
            alert("Guardado exitoso!");
            $('.check').attr('disabled', true);

            //Desactivar los checks
            document.querySelectorAll('#roles input[type="checkbox"]').forEach(checkbox => checkbox.checked = false);


        }).fail(function (xhr, status, error) {
            alert("Hubo un problema al guardar: " + error + "\nStatus: " + status);
            console.error(xhr);
        });
        $('#boton-guardar').attr('disabled', true);
        $('#boton-nuevo').attr('disabled', false);
        $('#boton-eliminar').attr('disabled', true);
    });
});

function ObtenerChecks() {
    const checkboxes = document.querySelectorAll('#roles input[type="checkbox"]');
    let valorescheck = [];
    checkboxes.forEach(checkbox => {
      if (checkbox.checked) {
        valorescheck.push(checkbox.value);
      }
    });
    return valorescheck.join(",");
}


