using Microsoft.AspNetCore.Mvc;
using SistemaPrestamosAPI.Repositories;

namespace SistemaPrestamosAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ConexionController : ControllerBase
    {
        private readonly ConexionRepository _conexionRepository;

        public ConexionController(ConexionRepository conexionRepository)
        {
            _conexionRepository = conexionRepository;
        }

        [HttpGet("probar")]
        public async Task<IActionResult> ProbarConexion()
        {
            var resultado = await _conexionRepository.ProbarConexion();

            return Ok(new
            {
                mensaje = resultado
            });
        }
    }
}