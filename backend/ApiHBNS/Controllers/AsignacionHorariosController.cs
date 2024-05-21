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
    [Route("AsignacionHorarios")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class AsignacionHorariosConroller : ControllerBase
    {
        [HttpGet]
        [Route("Traer/{ID_usuario}")]
        public IActionResult ObtenerUsuarios(int ID_usuario)
        {
            try
            {

                List<Parametro> parametros = new List<Parametro>
                {
                    new Parametro("@Option", "SELECT"),
                    new Parametro("@ID_usuario", @ID_usuario.ToString())
                };

                DataTable tAsignacionUsuario = DBDatos.Listar("GestionAsignacionesHorarios", parametros);

                var ClasesList = new List<Dictionary<string, object>>();
                foreach (DataRow row in tAsignacionUsuario.Rows)
                {
                    var dict = new Dictionary<string, object>();
                    foreach (DataColumn col in tAsignacionUsuario.Columns)
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

        [HttpPost]
        [Route("Guardar")]
        public dynamic GuardarAsignacionHorario(AsignacionHorarios AsignacionHorarios)
        {
            string idHorarios = string.Join(",", AsignacionHorarios.ID_horarios);

            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("@Option", AsignacionHorarios.Option.ToString()),
                new Parametro("@ID_usuario", AsignacionHorarios.ID_usuario.ToString()),
                new Parametro("@ID_horarios", idHorarios)
            };

            dynamic result = DBDatos.Ejecutar("GestionAsignacionesHorarios", parametros);

            return new
            {
                success = result.exito.ToString(),
                message = result.mensaje,
                result = ""
            };
        }
    }
}

