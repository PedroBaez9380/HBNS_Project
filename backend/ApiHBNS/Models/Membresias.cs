using System;

namespace ApiHBNS.Models
{
    public class Membresias
    {
        public int? ID_membresia { get; set; }
        public string? Nomenclatura { get; set; }
        public string? Descripcion { get; set; }
        public decimal Costo { get; set; }
        public int? Duracion { get; set; }
        }
}