namespace ApiHBNS.Models
{
    public class EstadoMembresia
    {
        public int ID_membresia { get; set; }
        public int ID_usuario { get; set; }
        public string Fecha_inicio { get; set; }
        public string? Fecha_vencimiento { get; set; }
        public bool? Estatus { get; set; }

        public string? TipoMembresia {  get; set; }
    }
}

