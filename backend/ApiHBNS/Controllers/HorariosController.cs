using Microsoft.AspNetCore.Mvc;
using ApiHBNS.Recursos;
using ApiHBNS.Models;
using System.Data;
using System.Web.Http.Cors;
using System.Text.Json;


namespace ApiHBNS.Controllers
{
    [ApiController]
    [Route("Horarios")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class HorariosController : ControllerBase
    {


        [HttpGet]
        [Route("Nomenclaturas")]
        public dynamic listarQuejas()
        {
            DataTable tNomenclaturaHorarios = DBDatos.Listar("ObtenerHorarios");

            // Funcion para convertir la DataTable a una lista de diccionarios
            var HorariosList = new List<Dictionary<string, object>>();
            foreach (DataRow row in tNomenclaturaHorarios.Rows)
            {
                var dict = new Dictionary<string, object>();
                foreach (DataColumn col in tNomenclaturaHorarios.Columns)
                {
                    dict[col.ColumnName] = row[col];
                }
                HorariosList.Add(dict);
            }

            string jsonNomenclaturaHorario = JsonSerializer.Serialize(HorariosList);

            return new
            {
                success = true,
                message = "exito",
                result = new
                {
                    Horario = JsonSerializer.Deserialize<List<Horarios>>(jsonNomenclaturaHorario)
                }
            };
        }
    }
}

