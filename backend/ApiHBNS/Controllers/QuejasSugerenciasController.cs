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
    [Route("QuejasSugerencias")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class QuejasSugerenciasController : ControllerBase
    {
        [HttpGet]
        [Route("Listar")]
        public dynamic listarQuejas()
        {
            DataTable tQuejasSugerencias = DBDatos.Listar("ObtenerQuejasSugerencias");

            // Funcion para convertir la DataTable a una lista de diccionarios
            var quejasList = new List<Dictionary<string, object>>();
            foreach (DataRow row in tQuejasSugerencias.Rows)
            {
                var dict = new Dictionary<string, object>();
                foreach (DataColumn col in tQuejasSugerencias.Columns)
                {
                    dict[col.ColumnName] = row[col];
                }
                quejasList.Add(dict);
            }

            string jsonQuejaSugerencia = JsonSerializer.Serialize(quejasList);

            return new
            {
                success = true,
                message = "exito",
                result = new
                {
                    QuejaSugerencia = JsonSerializer.Deserialize<List<QuejasSugerencias>>(jsonQuejaSugerencia)
                }
            };
        }


        [HttpPost]
        [Route("Guardar")]
        public dynamic GuardarQuejas(QuejasSugerencias QuejasSugerencias)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("@Nombre", QuejasSugerencias.Nombre),
                new Parametro("@Correo", QuejasSugerencias.Correo),
                new Parametro("@Descripcion", QuejasSugerencias.Descripcion),
                new Parametro("@Fecha", QuejasSugerencias.Fecha)



            };

            dynamic result = DBDatos.Ejecutar("InsertarQuejasSugerencias", parametros);

            return new
            {
                success = result.exito,
                message = result.mensaje,
                result = ""
            };

        }

        //[HttpDelete]
        //[Route("Eliminar")]
        //public dynamic EliminarQuejas()
        //{

        //}
    }
}
