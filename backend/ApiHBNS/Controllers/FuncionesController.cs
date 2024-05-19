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
using System.Collections.Generic;

namespace ApiHBNS.Controllers
{
    [ApiController]
    [Route("Funciones")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class FuncionesController : ControllerBase
    {
        [HttpGet]
        [Route("ObtenerFunciones/{ID_usuario}")]
        public IActionResult ObtenerFunciones(int ID_usuario)
        {
            try
            {
                // Obtener los roles asignados al usuario desde la base de datos
                List<string> roles = ObtenerRolesUsuario(ID_usuario);

                // Verificar si el usuario tiene roles asignados
                if (roles.Count == 0)
                {
                    return NotFound("No se encontraron roles asignados para el usuario.");
                }

                // Diccionario que asocia roles con sus respectivas funciones (como HTML en este caso)
                var funcionesPorRol = new Dictionary<string, List<string>>
                {
                    {
                        "1", new List<string>
                        {
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-chat.png"" alt=""Admin-usuarios"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""chat.html"">Chat</a>
                                </div>
                            </div>",
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-horario.png"" alt=""Horario"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""horario.html"">Tu horario</a>
                                </div>
                            </div>",
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-perfil.png"" alt=""Perfil"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""perfil.html"">Tu perfil</a>
                                </div>
                            </div>"

                        }
                    },
                    {
                        "2", new List<string>
                        {
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-chat.png"" alt=""Admin-usuarios"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""chat.html"">Chat</a>
                                </div>
                            </div>",
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-horario.png"" alt=""Horario"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""horario.html"">Tu horario</a>
                                </div>
                            </div>",
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-perfil.png"" alt=""Perfil"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""perfil.html"">Tu perfil</a>
                                </div>
                            </div>",
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-informacion-membresia.png"" alt=""Estatus-membresia"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""info-membresia.html"">Informacion de membresia</a>
                                </div>
                            </div>"
                        }
                    },
                    {
                        "3", new List<string>
                        {
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-gestion-usuarios.png"" alt=""Gestion-usuarios"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""gestion-usuarios.html"">Gestion de usuarios</a>
                                </div>
                            </div>",
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-tipo-usuario.png"" alt=""Tipo-usuario"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""tipo-usuario.html"">Gestion de tipo de usuario</a>
                                </div>
                            </div>"
                        }
                    },
                    {
                        "4", new List<string>
                        {
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-asignacion-roles.png"" alt=""Asign-roles"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""asignacion-roles.html"">Asignacion de roles</a>
                                </div>
                            </div>"
                        }
                    },
                    {
                        "5", new List<string>
                        {
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-asignacion-horarios.png"" alt=""Asign-horarios"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""asignacion-horarios.html"">Asignacion de horarios</a>
                                </div>
                            </div>",
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-chat.png"" alt=""Admin-usuarios"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""chat.html"">Chat</a>
                                </div>
                            </div>"
                        }
                    },
                    {
                        "6", new List<string>
                        {
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-gestion-horarios.png"" alt=""Gestion-horarios"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""gestion-horarios.html"">Gestion de horarios</a>
                                </div>
                            </div>"
                        }
                    },
                    {
                        "7", new List<string>
                        {
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-compra-articulos.png"" alt=""Compra-articulos"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""compra-articulos.html"">Compra de articulos</a>
                                </div>
                            </div>",
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-gestion-stock.png"" alt=""Gestion-stock"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""gestion-stock.html"">Gestion de stock</a>
                                </div>
                            </div>"
                        }
                    },
                    {
                        "8", new List<string>
                        {
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-gestion-articulos.png"" alt=""Gestion-articulos"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""gestion-articulos.html"">Gestion de articulos</a>
                                </div>
                            </div>",
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-gestion-compras.png"" alt=""Gestion-compras"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""gestion-compras.html"">Gestion de compras</a>
                                </div>
                            </div>"

                        }
                    },
                    {
                        "9", new List<string>
                        {
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-venta-articulos.png"" alt=""logo-venta-articulos"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""venta-articulos.html"">Venta de articulos</a>
                                </div>
                            </div>"
                        }
                    },
                    {
                        "10", new List<string>
                        {
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-gestion-ventas.png"" alt=""Gestion-ventas"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""gestion-ventas.html"">Gestion de ventas</a>
                                </div>
                            </div>"
                        }
                    },
                    {
                        "11", new List<string>
                        {
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-pago-membresias.png"" alt=""Pagos-membresias"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""pago-membresias.html"">Pago de membresias</a>
                                </div>
                            </div>",
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-pago-sueldos.png"" alt=""Pagos-sueldos"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""pago-sueldo.html"">Pago de sueldos</a>
                                </div>
                            </div>"
                        }
                    },
                    {
                        "12", new List<string>
                        {
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-asignacion-membresias.png"" alt=""Asign-membresias"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""asignacion-membresias.html"">Asignacion de membresias</a>
                                </div>
                            </div>",
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-asignacion-sueldo.png"" alt=""Asign-sueldos"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""asignacion-sueldos.html"">Asignacion de sueldos</a>
                                </div>
                            </div>",
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-gestion-membresias.png"" alt=""Gestion-membresias"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""gestion-membresias.html"">Gestion de membresias</a>
                                </div>
                            </div>",
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-reporte-membresias.png"" alt=""Reporte-membresias"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""reporte-membresias.html"">Reporte de membresias</a>
                                </div>
                            </div>",
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-reporte-sueldos.png"" alt=""Reporte-sueldos"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""reporte-sueldos.html"">Reporte de sueldos</a>
                                </div>
                            </div>"
                        }
                    },
                    {
                        "13", new List<string>
                        {
                            @"
                            <div class=""row justify-content-center"">
                                <div class=""col-lg-1 col-sm-12 imagen-funcion d-flex align-items-center justify-content-center"">
                                    <img src=""../images/imagenes-funciones/logo-reportes.png"" alt=""Reporte-general"">
                                </div>
                                <div class=""col-lg-4 col-sm-12 d-flex align-items-center texto-funcion"">
                                    <a href=""reporte-general.html"">Reporte general</a>
                                </div>
                            </div>"
                        }
                    }
                };

                List<string> funciones = new List<string>();
                foreach (string rol in roles)
                {
                    if (funcionesPorRol.ContainsKey(rol))
                    {
                        funciones.AddRange(funcionesPorRol[rol]);
                    }
                }

                return Ok(new { funciones });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno del servidor: {ex.Message}");
            }
        }

        // Método para obtener los roles asignados a un usuario desde la base de datos
        private List<string> ObtenerRolesUsuario(int ID_usuario)
        {
            List<string> roles = new List<string>();

            try
            {
                DataTable resultado = DBDatos.Listar("ObtenerRolesPorUsuario", new List<Parametro>
                {
                    new Parametro("@ID_usuario", ID_usuario.ToString())
                });

                // Verificar si se encontraron roles
                if (resultado != null && resultado.Rows.Count > 0)
                {
                    // Agregar cada rol a la lista
                    foreach (DataRow fila in resultado.Rows)
                    {
                        roles.Add(fila["ID_Rol"].ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al obtener roles del usuario: {ex.Message}");
            }

            return roles;
        }
    }
}

