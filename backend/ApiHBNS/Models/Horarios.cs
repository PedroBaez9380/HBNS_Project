using System;

namespace ApiHBNS.Models
{
    public class Horarios
    {
        public int ID_horario { get; set; }
        public int ID_clase { get; set; }
        public string Nomenclatura { get; set; }
        public TimeSpan Hora_inicio { get; set; }
        public TimeSpan Hora_final { get; set; }
        public int ID_dia { get; set; }
    }
}
