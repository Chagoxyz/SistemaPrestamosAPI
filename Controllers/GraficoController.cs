using Microsoft.AspNetCore.Mvc;
using SistemaPrestamosAPI.Repositories;

namespace SistemaPrestamosAPI.Controllers
{
    [ApiController]
    [Route("api/grafico")]
    public class GraficoController : ControllerBase
    {
        private readonly GraficoRepository _repository;

        public GraficoController(GraficoRepository repository)
        {
            _repository = repository;
        }

        [HttpGet("{idPregunta}")]
        public async Task<IActionResult> Obtener(int idPregunta)
        {
            var tabla = await _repository.ObtenerGrafico(idPregunta);

            var lista = new List<Dictionary<string, object>>();

            foreach (System.Data.DataRow fila in tabla.Rows)
            {
                var objeto = new Dictionary<string, object>();

                foreach (System.Data.DataColumn columna in tabla.Columns)
                {
                    objeto[columna.ColumnName] = fila[columna];
                }

                lista.Add(objeto);
            }

            return Ok(lista);
        }
    }
}