using System;

namespace ApiHBNS.Models
{
    public class Horarios
    {
        public int? ID_horario { get; set; }
        public int? ID_clase { get; set; }
        public string? Nomenclatura { get; set; }
        public string? Hora_inicio { get; set; }
        public string? Hora_final { get; set; }
        public int? ID_dia { get; set; }

        public string? DescripcionDia { get; set; }
        public string? NombreClase { get; set; }
    }
}
