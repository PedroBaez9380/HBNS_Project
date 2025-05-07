function login() {
    var userData = {
        ID_usuario: $("#usuario").val(),
        Contrasena: $("#contrasena").val()
    };

    fetch("https://localhost:7131/Login/Listar", {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(userData)
    })
    .then(response => {
        if (!response.ok) {
            // Leer el cuerpo de la respuesta JSON para obtener el mensaje de error
            return response.json().then(errorData => {
                throw new Error(errorData.message || 'Error al iniciar sesión');
            });
        }
        return response.json();
    })
    .then(result => {
        if (result.success) {
            if(!result.estado){
                alert("Usuario deshabilitado administrativamente")
                return;
            }
            alert("¡Inicio de sesión exitoso!");
            console.log(result);
            localStorage.setItem('accessToken', result.accessToken);
            var accessToken = result.accessToken;
            window.location.href = "funciones.html?id=" + $("#usuario").val();
        } else {
            alert(result.message); // Aquí ya se muestra el mensaje de la API
        }
    })
    .catch(error => {
        alert(error.message); // Aquí se mostrarán errores de red o errores específicos de la API
    });
}

$("#form-login").submit(function (event) {
    console.log("Formulario enviado");
    if ($("#usuario").val() === "" || $("#contrasena").val() === "") {
        alert("Favor de ingresar sus credenciales");
        event.preventDefault();
        event.stopPropagation();
    } else {
        if (!this.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
        } else {
            login();
            event.preventDefault();
            this.classList.remove('was-validated');
        }
        this.classList.add('was-validated');
    }
});