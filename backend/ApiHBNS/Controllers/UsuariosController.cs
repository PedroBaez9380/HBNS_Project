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
    [Route("Usuarios")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class UsuariosConroller : ControllerBase
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

                DataTable tUsuario = DBDatos.Listar("GestionUsuario", parametros);

                var usuariosList = new List<Dictionary<string, object>>();
                foreach (DataRow row in tUsuario.Rows)
                {
                    var dict = new Dictionary<string, object>();
                    foreach (DataColumn col in tUsuario.Columns)
                    {
                        dict[col.ColumnName] = row[col];
                    }
                    usuariosList.Add(dict);
                }

                string jsonUsuarios = JsonSerializer.Serialize(usuariosList);

                return Ok(new { Usuarios = usuariosList });
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

