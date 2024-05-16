 // Obtenemos el texto de los elementos con los IDs especificados
 var estatusActual = $('#estatus-membresia-actual').text().trim();
 var estatusSiguiente = $('#estatus-membresia-siguiente').text().trim();
 
 // Función para asignar el color de fondo según el estatus
 function asignarColorFondo(estatus, elemento) {
     if (estatus === 'No pagado') {
         elemento.css('background-color', '#ffcccc');
     } else if (estatus === 'Pagado') {
         elemento.css('background-color', '#ccffcc');
     }
 }

 // Llamamos a la función para ambos elementos
 asignarColorFondo(estatusActual, $('#estatus-membresia-actual'));
 asignarColorFondo(estatusSiguiente, $('#estatus-membresia-siguiente'));