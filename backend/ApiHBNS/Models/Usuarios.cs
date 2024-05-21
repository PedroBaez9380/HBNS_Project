namespace ApiHBNS.Models
{
    public class Usuarios
    {
        public string Option { get; set; }
        public int? ID_usuario { get; set; }
        public int? ID_tipo_usuario { get; set; }
        public string? Contrasena { get; set; }
        public string? Nombre { get; set; }
        public string? Apellido { get; set; }
        public string? Telefono { get; set; } 
        public string? Correo { get; set; }
        public string? Fecha_registro { get; set; }
        public string? Fecha_nacimiento { get; set; }
        public int? ID_membresia { get; set; }
        public bool? Estado { get; set; }
    }
}


