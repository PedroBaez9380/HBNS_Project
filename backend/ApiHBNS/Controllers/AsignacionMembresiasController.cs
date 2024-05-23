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
    [Route("AsignacionMembresias")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class AsignacionMembresiasController : ControllerBase
    {
        [HttpGet]
        [Route("Traer")]
        public IActionResult ObtenerMembresias()
        {
            try
            {

                List<Parametro> parametros = new List<Parametro>
                {
                    new Parametro("@Option", "SELECT"),
                };

                DataTable tAsignacionMembresia = DBDatos.Listar("GestionAsignacionesMembresias", parametros);

                var MembresiasList = new List<Dictionary<string, object>>();
                foreach (DataRow row in tAsignacionMembresia.Rows)
                {
                    var dict = new Dictionary<string, object>();
                    foreach (DataColumn col in tAsignacionMembresia.Columns)
                    {
                        dict[col.ColumnName] = row[col];
                    }
                    MembresiasList.Add(dict);
                }

                string jsonMembresias = JsonSerializer.Serialize(MembresiasList);

                return Ok(new { Asignaciones = MembresiasList});
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno del servidor: {ex.Message}");
            }
        }

        [HttpPost]
        [Route("Guardar")]
        public dynamic GuardarAsignacionMembresia(AsignacionMembresias AsignacionMembresias)
        {

            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("@Option", "INSERT"),
                new Parametro("@ID_usuario", AsignacionMembresias.ID_usuario.ToString()),
                new Parametro("@ID_membresia", AsignacionMembresias.ID_membresia.ToString())
            };

            dynamic result = DBDatos.Ejecutar("GestionAsignacionesMembresias", parametros);

            return new
            {
                success = result.exito.ToString(),
                message = result.mensaje,
                result = ""
            };
        }

        [HttpPost]
        [Route("Eliminar")]
        public dynamic EliminarAsignacionMembresia(AsignacionMembresias AsignacionMembresias)
        {

            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("@Option", "DELETE"),
                new Parametro("@ID_usuario", AsignacionMembresias.ID_usuario.ToString()),
            };

            dynamic result = DBDatos.Ejecutar("GestionAsignacionesMembresias", parametros);

            return new
            {
                success = result.exito.ToString(),
                message = result.mensaje,
                result = ""
            };
        }
    }
}

