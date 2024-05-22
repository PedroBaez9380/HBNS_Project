using Microsoft.AspNetCore.Mvc;
using ApiHBNS.Recursos;
using ApiHBNS.Models;
using System.Data;
using System.Web.Http.Cors;
using System.Text.Json;


namespace ApiHBNS.Controllers
{
    [ApiController]
    [Route("Membresias")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class MembresiasController : ControllerBase
    {


        [HttpGet]
        [Route("Traer")]
        public dynamic listarHorarios()
        {
            List<Parametro> parametros = new List<Parametro>
                {
                    new Parametro("@Option", "SELECT"),
                }; 

            DataTable tMembresias = DBDatos.Listar("GestionMembresias", parametros);

            // Funcion para convertir la DataTable a una lista de diccionarios
            var MembresiasList = new List<Dictionary<string, object>>();
            foreach (DataRow row in tMembresias.Rows)
            {
                var dict = new Dictionary<string, object>();
                foreach (DataColumn col in tMembresias.Columns)
                {
                    dict[col.ColumnName] = row[col];
                }
                MembresiasList.Add(dict);
            }

            string jsonNomenclaturaHorario = JsonSerializer.Serialize(MembresiasList);

            return new
            {
                success = true,
                message = "exito",
                result = new
                {
                    Membresias = JsonSerializer.Deserialize<List<Membresias>>(jsonNomenclaturaHorario)
                }
            };
        }
        [HttpPost]
        [Route("Guardar")]
        public dynamic GuardarHorario(Membresias Membresias)
        {

            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("@Option", "INSERT"),
                new Parametro("@ID_membresia", Membresias.ID_membresia.ToString()),
                new Parametro("@Nomenclatura", Membresias.Nomenclatura.ToString()),
                new Parametro("@Descripcion", Membresias.Descripcion.ToString()),
                new Parametro("@Costo", Membresias.Costo.ToString()),
                new Parametro("@Duracion", Membresias.Duracion.ToString()),
            };

            dynamic result = DBDatos.Ejecutar("GestionMembresias", parametros);

            return new
            {
                success = result.exito.ToString(),
                message = result.mensaje,
                result = ""
            };
        }

        [HttpPut]
        [Route("Actualizar")]
        public dynamic ActualizarHorario(Membresias Membresias)
        {
            List<Parametro> parametros = new List<Parametro>
        {
            new Parametro("@Option", "UPDATE"),
            new Parametro("@ID_membresia", Membresias.ID_membresia.ToString()),
            new Parametro("@Nomenclatura", Membresias.Nomenclatura.ToString()),
            new Parametro("@Descripcion", Membresias.Descripcion.ToString()),
            new Parametro("@Costo", Membresias.Costo.ToString()),
            new Parametro("@Duracion", Membresias.Duracion.ToString()),
        };

            dynamic result = DBDatos.Ejecutar("GestionMembresias", parametros);

            return new
            {
                success = result.exito.ToString(),
                message = result.mensaje,
                result = ""
            };
        }


        [HttpDelete]
        [Route("Borrar")]
        public dynamic BorrarHorario(Membresias Membresias)
        {
            List<Parametro> parametros = new List<Parametro>
        {
            new Parametro("@Option", "DELETE"),
            new Parametro("@ID_membresia", Membresias.ID_membresia.ToString())
        };

            dynamic result = DBDatos.Ejecutar("GestionMembresias", parametros);

            return new
            {
                success = result.exito.ToString(),
                message = result.mensaje,
                result = ""
            };
        }

    }
}

