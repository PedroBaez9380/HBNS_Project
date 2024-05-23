using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.IO;
using System.Threading.Tasks;

namespace YourProject.Controllers
{
    [Route("SubirArchivos")]
    [ApiController]
    public class FileUploadController : ControllerBase
    {
        private readonly IWebHostEnvironment _environment;

        public FileUploadController(IWebHostEnvironment environment)
        {
            _environment = environment;
        }

        [HttpPost("Subir")]
        public async Task<IActionResult> Upload(IFormFile file)
        {
            if (file == null || file.Length == 0)
            {
                return BadRequest("No file uploaded.");
            }

            // Ruta absoluta para guardar los archivos
            var basePath = Path.Combine(_environment.ContentRootPath, "..", "..", "pagos");

            if (!Directory.Exists(basePath))
            {
                Directory.CreateDirectory(basePath);
            }

            // Nombre del archivo en el servidor
            var filePath = Path.Combine(basePath, Path.GetFileName(file.FileName));

            // Guardar el archivo en el servidor
            using (var fileStream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(fileStream);
            }

            // Ruta relativa a devolver en la respuesta
            var relativePath = Path.Combine("..", "..", "pagos", Path.GetFileName(file.FileName));
            return Ok(new { filePath = relativePath });
        }
    }
}



