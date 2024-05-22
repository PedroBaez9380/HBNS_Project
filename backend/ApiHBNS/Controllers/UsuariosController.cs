using Microsoft.AspNetCore.Mvc;
using ApiHBNS.Recursos;
using System.Data;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Web.Http.Cors;
using ApiHBNS.Models;
using static System.Runtime.InteropServices.JavaScript.JSType;
using System.Globalization;

namespace ApiHBNS.Controllers
{
    [ApiController]
    [Route("Usuarios")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class UsuariosConroller : ControllerBase
    {

        [HttpGet]
        [Route("Traer/{ID_usuario}")]
        public IActionResult ObtenerUsuarios(int? ID_usuario)
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

        [HttpGet]
        [Route("TraerTodosUsuarios")]
        public IActionResult ObtenerTodosUsuarios()
        {
            try
            {

                DataTable tUsuario = DBDatos.Listar("TraerTodosUsuarios");

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
        public dynamic GuardarUsuario(Usuarios Usuarios)
        {
            try
            {
                List<Parametro> parametros = new List<Parametro>
        {
            new Parametro("@Option", "INSERT"),
            new Parametro("@ID_tipo_usuario", Usuarios.ID_tipo_usuario.ToString()),
            new Parametro("@Contrasena", Usuarios.Contrasena),
            new Parametro("@Nombre", Usuarios.Nombre),
            new Parametro("@Apellido", Usuarios.Apellido),
            new Parametro("@Telefono", Usuarios.Telefono),
            new Parametro("@Correo", Usuarios.Correo),
            new Parametro("@Fecha_registro", Usuarios.Fecha_registro),
            new Parametro("@Fecha_nacimiento", Usuarios.Fecha_nacimiento),
            new Parametro("@ID_membresia", Usuarios.ID_membresia?.ToString()),
            new Parametro("@Estado", Usuarios.Estado.ToString()),
        };

                dynamic result = DBDatos.Ejecutar("GestionUsuario", parametros);

                if (result.exito)
                {
                    return new
                    {
                        success = true,
                        message = "Usuario guardado exitosamente",
                        result = result
                    };
                }
                else
                {
                    return new
                    {
                        success = false,
                        message = "Hubo un error al guardar el usuario",
                        result = result
                    };
                }
            }
            catch (Exception ex)
            {
                return new
                {
                    success = false,
                    message = "Hubo un error interno al procesar la solicitud",
                    error = ex.Message
                };
            }
        }


        [HttpPut]
        [Route("Actualizar")]
        public dynamic ActualizarUsuario(Usuarios Usuarios)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("@Option", "UPDATE"),
                new Parametro("@ID_usuario", Usuarios.ID_usuario.ToString()),
                new Parametro("@ID_tipo_usuario", Usuarios.ID_tipo_usuario.ToString()),
                new Parametro("@Contrasena", Usuarios.Contrasena),
                new Parametro("@Nombre", Usuarios.Nombre),
                new Parametro("@Apellido", Usuarios.Apellido),
                new Parametro("@Telefono", Usuarios.Telefono),
                new Parametro("@Correo", Usuarios.Correo),
                new Parametro("@Fecha_nacimiento", Usuarios.Fecha_nacimiento),
                new Parametro("@ID_membresia", Usuarios.ID_membresia?.ToString()),
                new Parametro("@Estado", Usuarios.Estado.ToString()),
            };

            dynamic result = DBDatos.Ejecutar("GestionUsuario", parametros);

            return new
            {
                success = result.exito.ToString(),
                message = result.mensaje,
                result = ""
            };
        }

        //Usuario no tiene DELETE, solo se desactiva administrativamente con el campo Estado

    }
}

