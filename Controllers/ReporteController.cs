using Microsoft.AspNetCore.Mvc;
using SistemaPrestamosAPI.Repositories;

namespace SistemaPrestamosAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ReporteController : ControllerBase
    {
        private readonly ReporteRepository _reporteRepository;

        public ReporteController(ReporteRepository reporteRepository)
        {
            _reporteRepository = reporteRepository;
        }

        [HttpGet("{numero}")]
        public async Task<IActionResult> ObtenerReporte(int numero)
        {
            try
            {
                var resultado = await _reporteRepository.ObtenerReporte(numero);
                return Ok(resultado);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }
    }
}