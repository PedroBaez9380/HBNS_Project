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
    [Route("EstadoMembresia")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class EstadoMembresiaController : ControllerBase
    {
        [HttpGet]
        [Route("Traer/{ID_usuario}")]
        public IActionResult ObtenerEstadoMembresia(int ID_usuario)
        {
            try
            {

                List<Parametro> parametros = new List<Parametro>
                {
                    new Parametro("@Option", "SELECT"),
                    new Parametro("@ID_usuario", @ID_usuario.ToString())
                };

        DataTable tAsignacionMembresia = DBDatos.Listar("TraerInfoMembresia", parametros);

                var AsignacionesList = new List<Dictionary<string, object>>();
                foreach (DataRow row in tAsignacionMembresia.Rows)
                {
                    var dict = new Dictionary<string, object>();
                    foreach (DataColumn col in tAsignacionMembresia.Columns)
                    {
                        dict[col.ColumnName] = row[col];
                    }
                    AsignacionesList.Add(dict);
                }

                string jsonUsuarios = JsonSerializer.Serialize(AsignacionesList);

                return Ok(new { Asignacion = AsignacionesList });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno del servidor: {ex.Message}");
            }
        }

        [HttpPut]
        [Route("Actualizar")]
        public dynamic GuardarEstadoMembresia(EstadoMembresia EstadoMembresia)
        {

            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("@Option", "UPDATE"),
                new Parametro("@ID_usuario", EstadoMembresia.ID_usuario.ToString()),
                new Parametro("@ID_membresia", EstadoMembresia.ID_membresia.ToString()),
                new Parametro("@Fecha_inicio", EstadoMembresia.Fecha_inicio.ToString()),
                new Parametro("@Estatus", EstadoMembresia.Estatus.ToString())
            };

            dynamic result = DBDatos.Ejecutar("TraerInfoMembresia", parametros);

            return new
            {
                success = result.exito.ToString(),
                result = ""
            };
        }
    }
}

