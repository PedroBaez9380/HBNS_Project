namespace ApiHBNS.Models
{
    public class Sueldos
    {
        public int? ID_estado_sueldo { get; set; }
        public decimal? Cantidad_pagar { get; set; }
        public string? Fecha_inicio { get; set; }
        public string? Fecha_fin { get; set; }
        public bool? Estatus { get; set; }
        public string? Comprobante_ruta {  get; set; }
        public int? ID_usuario { get; set; }
    }
}

