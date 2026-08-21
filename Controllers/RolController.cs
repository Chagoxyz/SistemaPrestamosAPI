using Microsoft.AspNetCore.Mvc;
using SistemaPrestamosAPI.Repositories;
using System.Data;

namespace SistemaPrestamosAPI.Controllers
{
    [ApiController]
    [Route("api/roles")]
    public class RolController : ControllerBase
    {
        private readonly RolRepository _repository;

        public RolController(RolRepository repository)
        {
            _repository = repository;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var tabla = await _repository.ConsultarRoles();

            var lista = tabla.AsEnumerable()
                .Select(r => new
                {
                    IdRol = Convert.ToInt32(r["IdRol"]),
                    Nombre = r["Nombre"].ToString(),
                    Activo = Convert.ToBoolean(r["Activo"])
                });

            return Ok(lista);
        }
    }
}