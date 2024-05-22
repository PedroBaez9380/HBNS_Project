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
    [Route("Roles")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class RolesController : ControllerBase
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
                    new Parametro("@ID_usuario", @ID_usuario.ToString()),
                };

                DataTable tRoles = DBDatos.Listar("GestionRol", parametros);

                var RolesList = new List<Dictionary<string, object>>();
                foreach (DataRow row in tRoles.Rows)
                {
                    var dict = new Dictionary<string, object>();
                    foreach (DataColumn col in tRoles.Columns)
                    {
                        dict[col.ColumnName] = row[col];
                    }
                    RolesList.Add(dict);
                }

                string jsonUsuarios = JsonSerializer.Serialize(RolesList);

                return Ok(new { Mensajes = RolesList });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno del servidor: {ex.Message}");
            }
        }


        [HttpPost]
        [Route("Guardar")]
        public dynamic GuardarQuejas(Roles Roles)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("@Option","INSERT"),
                new Parametro("@ID_usuario", Roles.ID_usuario),
                new Parametro("@ID_rol", Roles.ID_rol),
            };

            dynamic result = DBDatos.Ejecutar("GestionRol", parametros);

            return new
            {
                success = result.exito,
                message = result.mensaje,
                result = ""
            };

        }
    }
}
