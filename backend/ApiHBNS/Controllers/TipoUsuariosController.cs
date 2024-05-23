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
    [Route("TipoUsuarios")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class TipoUsuariosController : ControllerBase
    {

        [HttpGet]
        [Route("TraerTodos")]
        public dynamic listarTipoUsuario()
        {
            List<Parametro> parametros = new List<Parametro>
                {
                    new Parametro("@Option", "SELECT"),
                };

            DataTable tTipoUsuario = DBDatos.Listar("GestionTipoUsuario", parametros);

            var TipoUsuarioList = new List<Dictionary<string, object>>();
            foreach (DataRow row in tTipoUsuario.Rows)
            {
                var dict = new Dictionary<string, object>();
                foreach (DataColumn col in tTipoUsuario.Columns)
                {
                    dict[col.ColumnName] = row[col];
                }
                TipoUsuarioList.Add(dict);
            }

            string jsonTipoUsuario = JsonSerializer.Serialize(TipoUsuarioList);

            return new
            {
                success = true,
                message = "exito",
                result = new
                {
                    TiposUsuario = JsonSerializer.Deserialize<List<TipoUsuarios>>(jsonTipoUsuario)
                }
            };
        }



        [HttpPost]
        [Route("Guardar")]
        public dynamic GuardarTipoUsuario(TipoUsuarios TipoUsuarios)
        {

            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("@Option", "INSERT"),
                new Parametro("Descripcion", TipoUsuarios.Descripcion)

            };

            dynamic result = DBDatos.Ejecutar("GestionTipoUsuario", parametros);

            return new
            {
                success = result.exito.ToString(),
                message = result.mensaje,
                result = ""
            };
        }

        [HttpPut]
        [Route("Actualizar")]
        public dynamic ActualizarTipoUsuario(TipoUsuarios TipoUsuarios)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("@Option", "UPDATE"),
                new Parametro("@ID_tipo_usuario", TipoUsuarios.ID_tipo_usuario.ToString()),
                new Parametro("Descripcion", TipoUsuarios.Descripcion)
            };

            dynamic result = DBDatos.Ejecutar("GestionTipoUsuario", parametros);

            return new
            {
                success = result.exito.ToString(),
                message = result.mensaje,
                result = ""
            };
        }

        [HttpDelete]
        [Route("Eliminar")]
        public dynamic EliminarTipoUsuario(TipoUsuarios TipoUsuarios)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("@Option", "DELETE"),
                new Parametro("@ID_tipo_usuario", TipoUsuarios.ID_tipo_usuario.ToString()),
                new Parametro("Descripcion", TipoUsuarios.Descripcion)
            };

            dynamic result = DBDatos.Ejecutar("GestionTipoUsuario", parametros);

            return new
            {
                success = result.exito.ToString(),
                message = result.mensaje,
                result = ""
            };
        }

    }
}

