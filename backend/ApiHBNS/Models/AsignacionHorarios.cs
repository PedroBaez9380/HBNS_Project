namespace ApiHBNS.Models
{
    public class AsignacionHorarios
    {
        public string Option { get; set; }
        public int ID_usuario { get; set; }
        public List<int> ID_horarios { get; set; }
        public string? DescripcionDia { get; set; }
        public string? NombreClase { get; set; }
    }
}

