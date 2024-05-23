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
    [Route("Sueldos")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class SueldosController : ControllerBase
    {
        [HttpGet]
        [Route("TraerTodos")]
        public IActionResult ObtenerSueldos()
        {
            try
            {

                List<Parametro> parametros = new List<Parametro>
                {
                    new Parametro("@Option", "SELECTALL"),
                };

                DataTable tSueldos = DBDatos.Listar("GestionSueldos", parametros);

                var SueldosList = new List<Dictionary<string, object>>();
                foreach (DataRow row in tSueldos.Rows)
                {
                    var dict = new Dictionary<string, object>();
                    foreach (DataColumn col in tSueldos.Columns)
                    {
                        dict[col.ColumnName] = row[col];
                    }
                    SueldosList.Add(dict);
                }

                string jsonUsuarios = JsonSerializer.Serialize(SueldosList);

                return Ok(new { Sueldos = SueldosList });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno del servidor: {ex.Message}");
            }
        }

        [HttpGet]
        [Route("Traer/{ID_usuario}")]
        public IActionResult ObtenerSueldos(int ID_usuario)
        {
            try
            {

                List<Parametro> parametros = new List<Parametro>
                {
                    new Parametro("@Option", "SELECT"),
                    new Parametro("@ID_usuario", @ID_usuario.ToString())
                };

                DataTable tSueldoUsuario = DBDatos.Listar("GestionSueldos", parametros);

                var SueldoUsuarioList = new List<Dictionary<string, object>>();
                foreach (DataRow row in tSueldoUsuario.Rows)
                {
                    var dict = new Dictionary<string, object>();
                    foreach (DataColumn col in tSueldoUsuario.Columns)
                    {
                        dict[col.ColumnName] = row[col];
                    }
                    SueldoUsuarioList.Add(dict);
                }

                string jsonUsuarios = JsonSerializer.Serialize(SueldoUsuarioList);

                return Ok(new { RegistroSueldos = SueldoUsuarioList });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno del servidor: {ex.Message}");
            }
        }

        [HttpPost]
        [Route("Guardar")]
        public dynamic GuardarSueldo(Sueldos Sueldos)
        {

            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("@Option", "INSERT"),
                new Parametro("@Cantidad", Sueldos.Cantidad_pagar.ToString()),
                new Parametro("@ID_usuario", Sueldos.ID_usuario.ToString())
            };

            dynamic result = DBDatos.Ejecutar("GestionSueldos", parametros);

            return new
            {
                success = result.exito.ToString(),
                result = ""
            };
        }

        [HttpPut]
        [Route("Actualizar")]
        public dynamic EditarSueldo(Sueldos Sueldos)
        {

            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("@Option", "UPDATE"),
                new Parametro("@ID_estado_sueldo", Sueldos.ID_estado_sueldo.ToString()),
                new Parametro("@Comprobante_ruta", Sueldos.Comprobante_ruta.ToString()),
            };

            dynamic result = DBDatos.Ejecutar("GestionSueldos", parametros);

            return new
            {
                success = result.exito.ToString(),
                result = ""
            };
        }
    }
}

