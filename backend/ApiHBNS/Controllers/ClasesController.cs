using Microsoft.AspNetCore.Mvc;
using ApiHBNS.Recursos;
using System.Data;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Web.Http.Cors;
using ApiHBNS.Models;

namespace ApiHBNS.Controllers
{
    [ApiController]
    [Route("Clases")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class ClasesController : ControllerBase
    {
        [HttpGet]
        [Route("Traer")]
        public IActionResult ObtenerClases()
        {
            try
            {
                List<Parametro> parametros = new List<Parametro>
                {
                    new Parametro("@Option", "SELECT"),
                };

                DataTable tClases = DBDatos.Listar("GestionClases", parametros);

                var ClasesList = new List<Dictionary<string, object>>();
                foreach (DataRow row in tClases.Rows)
                {
                    var dict = new Dictionary<string, object>();
                    foreach (DataColumn col in tClases.Columns)
                    {
                        dict[col.ColumnName] = row[col];
                    }
                    ClasesList.Add(dict);
                }

                string jsonUsuarios = JsonSerializer.Serialize(ClasesList);

                return Ok(new { Clases = ClasesList });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno del servidor: {ex.Message}");
            }
        }

        
    }
}

