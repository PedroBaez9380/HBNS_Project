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
    [Route("DiaSemana")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class DiaSemanaController : ControllerBase
    {
        [HttpGet]
        [Route("Traer")]
        public IActionResult ObtenerDiaSemana()
        {
            try
            {
                DataTable tDiasSemana = DBDatos.Listar("TraerDiaSemana");

                var DiasList = new List<Dictionary<string, object>>();
                foreach (DataRow row in tDiasSemana.Rows)
                {
                    var dict = new Dictionary<string, object>();
                    foreach (DataColumn col in tDiasSemana.Columns)
                    {
                        dict[col.ColumnName] = row[col];
                    }
                    DiasList.Add(dict);
                }

                string jsonUsuarios = JsonSerializer.Serialize(DiasList);

                return Ok(new { Dias = DiasList });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno del servidor: {ex.Message}");
            }
        }

        
    }
}

