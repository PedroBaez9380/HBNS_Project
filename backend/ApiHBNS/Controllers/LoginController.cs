using Microsoft.AspNetCore.Mvc;
using ApiHBNS.Recursos;
using ApiHBNS.Models;
using System.Data;
using System.Web.Http.Cors;

namespace ApiHBNS.Controllers
{
    [ApiController]
    [Route("Login")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class LoginController : ControllerBase
    {
        [HttpPost]
        [Route("Listar")]
        public IActionResult ListarLogin(Login login)
        {
            // Verificar las credenciales del usuario y obtener su ID y estado
            var resultadoVerificacion = VerificarCredencialesConEstado(login);

            if (resultadoVerificacion != null && resultadoVerificacion.UserId != -1)
            {
                // Inicio de sesión exitoso
                return Ok(new { success = true, message = "Inicio de sesión exitoso", userId = resultadoVerificacion.UserId, estado = resultadoVerificacion.Estado });
            }
            else
            {
                // Devolver respuesta de error si las credenciales son incorrectas o el usuario está inactivo
                return Unauthorized(new { success = false, message = "Credenciales incorrectas o usuario inactivo" });
            }
        }

        public class ResultadoVerificacionLogin
        {
            public int UserId { get; set; }
            public bool Estado { get; set; }
        }

        private ResultadoVerificacionLogin VerificarCredencialesConEstado(Login login)
        {
            try
            {
                DataTable resultado = DBDatos.Listar("ObtenerLogin", new List<Parametro>
                {
                    new Parametro("@ID_usuario", login.ID_usuario.ToString()),
                    new Parametro("@Contrasena", login.Contrasena)
                });

                if (resultado != null && resultado.Rows.Count > 0)
                {
                    // Usuario autenticado
                    return new ResultadoVerificacionLogin
                    {
                        UserId = Convert.ToInt32(resultado.Rows[0]["ID_usuario"]),
                        Estado = Convert.ToBoolean(resultado.Rows[0]["Estado"])
                    };
                }
                else
                {
                    // Credenciales incorrectas o usuario no encontrado
                    return null;
                }
            }
            catch (Exception ex)
            {
                // Manejar el error de la base de datos
                Console.Error.WriteLine($"Error al verificar credenciales: {ex.Message}");
                return null; // O lanzar la excepción según tu manejo de errores
            }
        }
    }
}