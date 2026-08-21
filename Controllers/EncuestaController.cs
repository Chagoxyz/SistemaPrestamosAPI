using Microsoft.AspNetCore.Mvc;
using SistemaPrestamosAPI.DTOs;
using SistemaPrestamosAPI.Repositories;
using System.Data;

namespace SistemaPrestamosAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EncuestaController : ControllerBase
    {
        private readonly EncuestaRepository _encuestaRepository;

        public EncuestaController(
            EncuestaRepository encuestaRepository)
        {
            _encuestaRepository = encuestaRepository;
        }

        [HttpPost]
        public async Task<IActionResult> CrearEncuesta(
            [FromBody] CrearEncuestaDTO request)
        {
            try
            {
                int? idUsuario =
                    ObtenerIdUsuarioAuditoria();

                if (idUsuario.HasValue)
                {
                    request.IdUsuarioCreador =
                        idUsuario.Value;
                }

                var resultado =
                    await _encuestaRepository.CrearEncuesta(request);

                if (resultado.Rows.Count == 0)
                {
                    return BadRequest(new
                    {
                        mensaje =
                            "No se pudo registrar la encuesta."
                    });
                }

                var fila = resultado.Rows[0];

                return Ok(new
                {
                    idEncuesta = fila["IdEncuesta"],
                    idCliente = fila["IdCliente"],
                    mensaje = fila["Mensaje"]
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

        [HttpGet]
        public async Task<IActionResult> ConsultarEncuestas()
        {
            try
            {
                var resultado =
                    await _encuestaRepository.ConsultarEncuestas();

                var lista =
                    new List<Dictionary<string, object>>();

                foreach (DataRow fila in resultado.Rows)
                {
                    var item =
                        new Dictionary<string, object>();

                    foreach (
                        DataColumn columna
                        in resultado.Columns)
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
            catch (Exception ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }

        [HttpGet("{idEncuesta}")]
        public async Task<IActionResult> ConsultarEncuestaPorId(
            int idEncuesta)
        {
            try
            {
                var tablas =
                    await _encuestaRepository
                        .ConsultarEncuestaPorId(idEncuesta);

                if (
                    tablas.Count == 0 ||
                    tablas[0].Rows.Count == 0)
                {
                    return NotFound(new
                    {
                        mensaje =
                            "No se encontró la encuesta solicitada."
                    });
                }

                var encuesta =
                    ConvertirFila(tablas[0].Rows[0]);

                var respuestas =
                    tablas.Count > 1
                        ? ConvertirTabla(tablas[1])
                        : new List<
                            Dictionary<string, object>>();

                var medios =
                    tablas.Count > 2
                        ? ConvertirTabla(tablas[2])
                        : new List<
                            Dictionary<string, object>>();

                return Ok(new
                {
                    encuesta,
                    respuestas,
                    medios
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

        [HttpPut("{idEncuesta}")]
        public async Task<IActionResult> ActualizarEncuesta(
            int idEncuesta,
            [FromBody] ActualizarEncuestaDTO request)
        {
            try
            {
                request.IdEncuesta = idEncuesta;

                request.IdUsuarioAuditoria =
                    ObtenerIdUsuarioAuditoria();

                var resultado =
                    await _encuestaRepository
                        .ActualizarEncuesta(request);

                if (resultado.Rows.Count == 0)
                {
                    return BadRequest(new
                    {
                        mensaje =
                            "No se pudo actualizar la encuesta."
                    });
                }

                return Ok(new
                {
                    mensaje =
                        resultado.Rows[0]["Mensaje"]
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

        [HttpDelete("{idEncuesta}")]
        public async Task<IActionResult> EliminarEncuestaLogica(
            int idEncuesta)
        {
            try
            {
                int? idUsuario =
                    ObtenerIdUsuarioAuditoria();

                var resultado =
                    await _encuestaRepository
                        .EliminarEncuestaLogica(
                            idEncuesta,
                            idUsuario
                        );

                if (resultado.Rows.Count == 0)
                {
                    return BadRequest(new
                    {
                        mensaje =
                            "No se pudo eliminar la encuesta."
                    });
                }

                return Ok(new
                {
                    mensaje =
                        resultado.Rows[0]["Mensaje"]
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

        [HttpPut("restaurar/{idEncuesta}")]
        public async Task<IActionResult> RestaurarEncuesta(
            int idEncuesta)
        {
            try
            {
                int? idUsuario =
                    ObtenerIdUsuarioAuditoria();

                var resultado =
                    await _encuestaRepository
                        .RestaurarEncuesta(
                            idEncuesta,
                            idUsuario
                        );

                if (resultado.Rows.Count == 0)
                {
                    return BadRequest(new
                    {
                        mensaje =
                            "No se pudo restaurar la encuesta."
                    });
                }

                return Ok(new
                {
                    mensaje =
                        resultado.Rows[0]["Mensaje"]
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
            if (
                Request.Headers.TryGetValue(
                    "X-Usuario-Id",
                    out var valor)
                &&
                int.TryParse(
                    valor,
                    out int idUsuario))
            {
                return idUsuario;
            }

            return null;
        }

        private Dictionary<string, object> ConvertirFila(
            DataRow fila)
        {
            var item =
                new Dictionary<string, object>();

            foreach (
                DataColumn columna
                in fila.Table.Columns)
            {
                item[columna.ColumnName] =
                    fila[columna] == DBNull.Value
                        ? ""
                        : fila[columna];
            }

            return item;
        }

        private List<Dictionary<string, object>>
            ConvertirTabla(DataTable tabla)
        {
            var lista =
                new List<Dictionary<string, object>>();

            foreach (DataRow fila in tabla.Rows)
            {
                lista.Add(ConvertirFila(fila));
            }

            return lista;
        }
    }
}