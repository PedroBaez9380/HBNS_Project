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
    [Route("Horariosxclase")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class HorarioxclaseController : ControllerBase
    {

        [HttpGet]
        [Route("TraerHorarios/{ID_clase}")]
        public dynamic listarTipoUsuario(int ID_clase)
        {
            List<Parametro> parametros = new List<Parametro>
                {
                    new Parametro("@ID_clase", ID_clase.ToString()),
                };

            DataTable tHorariosxclase = DBDatos.Listar("Horariosxclase", parametros);

            var HorarioxClaseList = new List<Dictionary<string, object>>();
            foreach (DataRow row in tHorariosxclase.Rows)
            {
                var dict = new Dictionary<string, object>();
                foreach (DataColumn col in tHorariosxclase.Columns)
                {
                    dict[col.ColumnName] = row[col];
                }
                HorarioxClaseList.Add(dict);
            }

            string jsonHorarioxClase = JsonSerializer.Serialize(HorarioxClaseList);

            return new
            {
                success = true,
                message = "exito",
                result = new
                {
                    Horarios = JsonSerializer.Deserialize<List<HorariosxClase>>(jsonHorarioxClase)
                }
            };
        }




    }
}

