using Microsoft.AspNetCore.Mvc;
using SistemaPrestamosAPI.DTOs;
using SistemaPrestamosAPI.Repositories;
using System.Data;

namespace SistemaPrestamosAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsuarioController : ControllerBase
    {
        private readonly UsuarioRepository _usuarioRepository;

        public UsuarioController(UsuarioRepository usuarioRepository)
        {
            _usuarioRepository = usuarioRepository;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequestDTO request)
        {
            var usuario = await _usuarioRepository.Login(request);

            if (usuario == null)
            {
                return Unauthorized(new
                {
                    mensaje = "Usuario o contraseña incorrectos."
                });
            }

            return Ok(usuario);
        }

        [HttpGet]
        public async Task<IActionResult> ConsultarUsuarios()
        {
            var tabla = await _usuarioRepository.ConsultarUsuarios();

            var lista = new List<Dictionary<string, object>>();

            foreach (DataRow fila in tabla.Rows)
            {
                var item = new Dictionary<string, object>();

                foreach (DataColumn columna in tabla.Columns)
                {
                    item[columna.ColumnName] =
                        fila[columna] == DBNull.Value
                            ? ""
                            : fila[columna];
                }

                lista.Add(item);
            }

            return Ok(lista);
        }

        [HttpPost]
        public async Task<IActionResult> CrearUsuario(
            [FromBody] UsuarioRequestDTO usuario)
        {
            try
            {
                int? idUsuarioAuditoria = ObtenerIdUsuarioAuditoria();

                var resultado =
                    await _usuarioRepository.CrearUsuario(
                        usuario,
                        idUsuarioAuditoria
                    );

                return Ok(new
                {
                    mensaje = resultado.Rows[0]["Mensaje"]
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }

        [HttpPut("{idUsuario}")]
        public async Task<IActionResult> ActualizarUsuario(
            int idUsuario,
            [FromBody] UsuarioRequestDTO usuario)
        {
            try
            {
                int? idUsuarioAuditoria = ObtenerIdUsuarioAuditoria();

                var resultado =
                    await _usuarioRepository.ActualizarUsuario(
                        idUsuario,
                        usuario,
                        idUsuarioAuditoria
                    );

                return Ok(new
                {
                    mensaje = resultado.Rows[0]["Mensaje"]
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }

        [HttpDelete("{idUsuario}")]
        public async Task<IActionResult> EliminarUsuario(
            int idUsuario)
        {
            try
            {
                int? idUsuarioAuditoria = ObtenerIdUsuarioAuditoria();

                var resultado =
                    await _usuarioRepository.EliminarUsuario(
                        idUsuario,
                        idUsuarioAuditoria
                    );

                return Ok(new
                {
                    mensaje = resultado.Rows[0]["Mensaje"]
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }

        [HttpPut("restaurar/{idUsuario}")]
        public async Task<IActionResult> RestaurarUsuario(
            int idUsuario)
        {
            try
            {
                int? idUsuarioAuditoria = ObtenerIdUsuarioAuditoria();

                var resultado =
                    await _usuarioRepository.RestaurarUsuario(
                        idUsuario,
                        idUsuarioAuditoria
                    );

                return Ok(new
                {
                    mensaje = resultado.Rows[0]["Mensaje"]
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }

        private int? ObtenerIdUsuarioAuditoria()
        {
            if (Request.Headers.TryGetValue(
                    "X-Usuario-Id",
                    out var valor))
            {
                if (int.TryParse(valor, out int idUsuario))
                {
                    return idUsuario;
                }
            }

            return null;
        }
    }
}