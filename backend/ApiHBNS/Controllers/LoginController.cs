using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using ApiHBNS.Recursos;
using ApiHBNS.Models;
using System.Data;
using System.Web.Http.Cors;
using System.Security.Claims;
using System.Text;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Cryptography;

namespace ApiHBNS.Controllers
{
    [ApiController]
    [Route("Login")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class LoginConroller : ControllerBase
    {
        [HttpPost]
        [Route("Listar")]

        public IActionResult ListarLogin(Login login)
        {
            // Verificar las credenciales del usuario y obtener su ID
            int userId = VerificarCredenciales(login);

            if (userId != -1)
            {
                // Generar token de acceso
                string accessToken = GenerarTokenAcceso(userId);

                // Validar el token JWT
                var tokenHandler = new JwtSecurityTokenHandler();
                var key = Encoding.ASCII.GetBytes("SteinsGate123456789012345678901234567890");

                try
                {
                    tokenHandler.ValidateToken(accessToken, new TokenValidationParameters
                    {
                        ValidateIssuerSigningKey = true,
                        IssuerSigningKey = new SymmetricSecurityKey(key),
                        ValidateIssuer = false,
                        ValidateAudience = false,
                        ClockSkew = TimeSpan.Zero
                    }, out SecurityToken validatedToken);

                    // Si la validación tiene éxito, devolver el token
                    return Ok(new { success = true, message = "Inicio de sesión exitoso", accessToken });
                }
                catch (Exception)
                {
                    // Si la validación falla, devolver un error
                    return Unauthorized(new { success = false, message = "Token no válido" });
                }
            }
            else
            {
                // Devolver respuesta de error si las credenciales son incorrectas
                return Unauthorized(new { success = false, message = "Credenciales incorrectas" });
            }
        }

        private int VerificarCredenciales(Login login)
        {
            // Aquí iría tu lógica para verificar las credenciales, por ejemplo, consultar la base de datos
            // Si las credenciales son válidas, devuelves el ID del usuario; de lo contrario, devuelves -1
            DataTable resultado = DBDatos.Listar("ObtenerLogin", new List<Parametro>
            {
                new Parametro("@ID_usuario", login.ID_usuario.ToString()),
                new Parametro("@Contrasena", login.Contrasena)
            });

            if (resultado != null && resultado.Rows.Count > 0)
            {
                // Usuario autenticado
                return Convert.ToInt32(resultado.Rows[0]["ID_usuario"]);
            }
            else
            {
                // Credenciales incorrectas
                return -1;
            }
        }
        private string GenerarTokenAcceso(int userId)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes("SteinsGate123456789012345678901234567890");
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
            new Claim(ClaimTypes.NameIdentifier, userId.ToString())
                    // Puedes agregar más claims según tus necesidades, como el nombre del usuario, roles, etc.
                }),
                Expires = DateTime.UtcNow.AddHours(1), // Tiempo de expiración del token
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);
            return tokenHandler.WriteToken(token);
        }
    }
}