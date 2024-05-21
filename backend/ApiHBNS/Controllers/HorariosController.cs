using Microsoft.AspNetCore.Mvc;
using ApiHBNS.Recursos;
using ApiHBNS.Models;
using System.Data;
using System.Web.Http.Cors;
using System.Text.Json;


namespace ApiHBNS.Controllers
{
    [ApiController]
    [Route("Horarios")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class HorariosController : ControllerBase
    {


        [HttpGet]
        [Route("Traer")]
        public dynamic listarHorarios()
        {
            List<Parametro> parametros = new List<Parametro>
                {
                    new Parametro("@Option", "SELECT"),
                }; 

            DataTable tNomenclaturaHorarios = DBDatos.Listar("GestionHorarios", parametros);

            // Funcion para convertir la DataTable a una lista de diccionarios
            var HorariosList = new List<Dictionary<string, object>>();
            foreach (DataRow row in tNomenclaturaHorarios.Rows)
            {
                var dict = new Dictionary<string, object>();
                foreach (DataColumn col in tNomenclaturaHorarios.Columns)
                {
                    dict[col.ColumnName] = row[col];
                }
                HorariosList.Add(dict);
            }

            string jsonNomenclaturaHorario = JsonSerializer.Serialize(HorariosList);

            return new
            {
                success = true,
                message = "exito",
                result = new
                {
                    Horario = JsonSerializer.Deserialize<List<Horarios>>(jsonNomenclaturaHorario)
                }
            };
        }
        [HttpPost]
        [Route("Guardar")]
        public dynamic GuardarHorario(Horarios Horarios)
        {

            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("@Option", "INSERT"),
                new Parametro("@ID_clase", Horarios.ID_clase.ToString()),
                new Parametro("@Nomenclatura", Horarios.Nomenclatura.ToString()),
                new Parametro("@Hora_inicio", Horarios.Hora_inicio.ToString()),
                new Parametro("@Hora_final", Horarios.Hora_final.ToString()),
                new Parametro("@ID_dia", Horarios.ID_dia.ToString()),
            };

            dynamic result = DBDatos.Ejecutar("GestionHorarios", parametros);

            return new
            {
                success = result.exito.ToString(),
                message = result.mensaje,
                result = ""
            };
        }

        [HttpPut]
        [Route("Actualizar")]
        public dynamic ActualizarHorario(Horarios Horarios)
        {
            List<Parametro> parametros = new List<Parametro>
        {
            new Parametro("@Option", "UPDATE"),
            new Parametro("@ID_horario", Horarios.ID_horario.ToString()), 
            new Parametro("@ID_clase", Horarios.ID_clase.ToString()),
            new Parametro("@Nomenclatura", Horarios.Nomenclatura.ToString()),
            new Parametro("@Hora_inicio", Horarios.Hora_inicio.ToString()),
            new Parametro("@Hora_final", Horarios.Hora_final.ToString()),
            new Parametro("@ID_dia", Horarios.ID_dia.ToString()),
        };

            dynamic result = DBDatos.Ejecutar("GestionHorarios", parametros);

            return new
            {
                success = result.exito.ToString(),
                message = result.mensaje,
                result = ""
            };
        }


        [HttpDelete]
        [Route("Borrar")]
        public dynamic BorrarHorario(Horarios Horarios)
        {
            List<Parametro> parametros = new List<Parametro>
        {
            new Parametro("@Option", "DELETE"),
            new Parametro("@ID_horario", Horarios.ID_horario.ToString()),
        };

            dynamic result = DBDatos.Ejecutar("GestionHorarios", parametros);

            return new
            {
                success = result.exito.ToString(),
                message = result.mensaje,
                result = ""
            };
        }

    }
}

