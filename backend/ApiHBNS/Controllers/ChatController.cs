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
    [Route("Chats")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class ChatConroller : ControllerBase
    {

        [HttpGet]
        [Route("Traer/{ID_usuario}/{ID_usuario_seleccionado}")]
        public IActionResult ObtenerUsuarios(int? ID_usuario, int? ID_usuario_seleccionado)
        {
            try
            {
                List<Parametro> parametros = new List<Parametro>
                {
                    new Parametro("@Option", "SELECT"),
                    new Parametro("@ID_usuario_actual", @ID_usuario.ToString()),
                    new Parametro("@ID_usuario_seleccionado", ID_usuario_seleccionado.ToString())
                };

                DataTable tMensajes = DBDatos.Listar("GestionChat", parametros);

                var MensajesList = new List<Dictionary<string, object>>();
                foreach (DataRow row in tMensajes.Rows)
                {
                    var dict = new Dictionary<string, object>();
                    foreach (DataColumn col in tMensajes.Columns)
                    {
                        dict[col.ColumnName] = row[col];
                    }
                    MensajesList.Add(dict);
                }

                string jsonUsuarios = JsonSerializer.Serialize(MensajesList);

                return Ok(new { Mensajes = MensajesList });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno del servidor: {ex.Message}");
            }
        }

        [HttpPost]
        [Route("Guardar")]
        public dynamic GuardarMensaje(Chat Chat)
        {
            try
            {
                List<Parametro> parametros = new List<Parametro>
                {
                    new Parametro("@Option", "INSERT"),
                    new Parametro("@ID_usuario_actual", Chat.ID_usuario_actual.ToString()),
                    new Parametro("@ID_usuario_seleccionado", Chat.ID_usuario_seleccionado.ToString()),
                    new Parametro("@Mensaje", Chat.Mensaje),
                    new Parametro("@Fecha_envio", Chat.Fecha_envio)
                };

                dynamic result = DBDatos.Ejecutar("GestionChat", parametros);

                if (result.exito)
                {
                    return new
                    {
                        success = true,
                        message = "Mensaje guardado exitosamente",
                        
                    };
                }
                else
                {
                    return new
                    {
                        success = false,
                        message = "Hubo un error al enviar el Mensaje",
                        
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
    }
}

