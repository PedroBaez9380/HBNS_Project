function crearQuejaSugerencia() {
    var formattedDate = new Date().toISOString().slice(0, 10);
    $.ajax({
        url: "https://localhost:7131/QuejasSugerencias/Guardar",
        type: 'POST',
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        
        data: JSON.stringify({
            "nombre": $("#nombre").val(),
            "correo": $("#email").val(),
            "descripcion": $("#descripcion").val(),
            "fecha": formattedDate
        }),
        crossDomain: true
    }).done(function (result) {
        alert("Gracias por tus comentarios!");
        console.log(result);
        $("#form-quejas-sugerencias")[0].reset();
        
    }).fail(function (xhr, status, error) {
        alert(error)
    });
}

$("#form-quejas-sugerencias").submit(function (event) {
    if ($("#descripcion").val() === "") {
        alert("Favor de agregar una descripcion")
        event.preventDefault()
        event.stopPropagation()
    } else {
        if (!this.checkValidity()) {
            event.preventDefault()
            event.stopPropagation()
        } else {
            crearQuejaSugerencia();
            event.preventDefault();
            ("#form-quejas-sugerencias").classList.remove('was-validated')
        }
        this.classList.add('was-validated')
    }
    
});

