using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using SistemaPrestamosAPI.DTOs;
using SistemaPrestamosAPI.Repositories;

namespace SistemaPrestamosAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CatalogoController : ControllerBase
    {
        private readonly CatalogoRepository _catalogoRepository;

        public CatalogoController(
            CatalogoRepository catalogoRepository)
        {
            _catalogoRepository = catalogoRepository;
        }

        // =====================================================
        // CONSULTAS
        // =====================================================

        [HttpGet("generos")]
        public async Task<IActionResult> ObtenerGeneros(
            [FromQuery] bool incluirEliminados = false)
        {
            string procedimiento = incluirEliminados
                ? "sp_ConsultarGenerosTodos"
                : "sp_ConsultarGeneros";

            var resultado =
                await _catalogoRepository.ConsultarCatalogo(procedimiento);

            return Ok(resultado);
        }


        [HttpGet("ciudades")]
        public async Task<IActionResult> ObtenerCiudades(
            [FromQuery] bool incluirEliminados = false)
        {
            string procedimiento = incluirEliminados
                ? "sp_ConsultarCiudadesTodos"
                : "sp_ConsultarCiudades";

            var resultado =
                await _catalogoRepository.ConsultarCatalogo(procedimiento);

            return Ok(resultado);
        }


        [HttpGet("ocupaciones")]
        public async Task<IActionResult> ObtenerOcupaciones(
            [FromQuery] bool incluirEliminados = false)
        {
            string procedimiento = incluirEliminados
                ? "sp_ConsultarOcupacionesTodos"
                : "sp_ConsultarOcupaciones";

            var resultado =
                await _catalogoRepository.ConsultarCatalogo(procedimiento);

            return Ok(resultado);
        }


        [HttpGet("niveles-educativos")]
        public async Task<IActionResult> ObtenerNivelesEducativos(
            [FromQuery] bool incluirEliminados = false)
        {
            string procedimiento = incluirEliminados
                ? "sp_ConsultarNivelesEducativosTodos"
                : "sp_ConsultarNivelesEducativos";

            var resultado =
                await _catalogoRepository.ConsultarCatalogo(procedimiento);

            return Ok(resultado);
        }


        [HttpGet("rangos-edad")]
        public async Task<IActionResult> ObtenerRangosEdad(
            [FromQuery] bool incluirEliminados = false)
        {
            string procedimiento = incluirEliminados
                ? "sp_ConsultarRangosEdadTodos"
                : "sp_ConsultarRangosEdad";

            var resultado =
                await _catalogoRepository.ConsultarCatalogo(procedimiento);

            return Ok(resultado);
        }


        [HttpGet("rangos-ingresos")]
        public async Task<IActionResult> ObtenerRangosIngresos(
            [FromQuery] bool incluirEliminados = false)
        {
            string procedimiento = incluirEliminados
                ? "sp_ConsultarRangosIngresosTodos"
                : "sp_ConsultarRangosIngresos";

            var resultado =
                await _catalogoRepository.ConsultarCatalogo(procedimiento);

            return Ok(resultado);
        }


        [HttpGet("tipos-prestamo")]
        public async Task<IActionResult> ObtenerTiposPrestamo(
            [FromQuery] bool incluirEliminados = false)
        {
            string procedimiento = incluirEliminados
                ? "sp_ConsultarTiposPrestamoTodos"
                : "sp_ConsultarTiposPrestamo";

            var resultado =
                await _catalogoRepository.ConsultarCatalogo(procedimiento);

            return Ok(resultado);
        }


        [HttpGet("plazos")]
        public async Task<IActionResult> ObtenerPlazos(
            [FromQuery] bool incluirEliminados = false)
        {
            string procedimiento = incluirEliminados
                ? "sp_ConsultarPlazosTodos"
                : "sp_ConsultarPlazos";

            var resultado =
                await _catalogoRepository.ConsultarCatalogo(procedimiento);

            return Ok(resultado);
        }


        [HttpGet("montos-rango")]
        public async Task<IActionResult> ObtenerMontosRango(
            [FromQuery] bool incluirEliminados = false)
        {
            string procedimiento = incluirEliminados
                ? "sp_ConsultarMontosRangoTodos"
                : "sp_ConsultarMontosRango";

            var resultado =
                await _catalogoRepository.ConsultarCatalogo(procedimiento);

            return Ok(resultado);
        }


        [HttpGet("tasas-interes")]
        public async Task<IActionResult> ObtenerTasasInteres(
            [FromQuery] bool incluirEliminados = false)
        {
            string procedimiento = incluirEliminados
                ? "sp_ConsultarTasasInteresRangoTodos"
                : "sp_ConsultarTasasInteresRango";

            var resultado =
                await _catalogoRepository.ConsultarCatalogo(procedimiento);

            return Ok(resultado);
        }


        [HttpGet("capacidades-pago")]
        public async Task<IActionResult> ObtenerCapacidadesPago(
            [FromQuery] bool incluirEliminados = false)
        {
            string procedimiento = incluirEliminados
                ? "sp_ConsultarCapacidadesPagoTodos"
                : "sp_ConsultarCapacidadesPago";

            var resultado =
                await _catalogoRepository.ConsultarCatalogo(procedimiento);

            return Ok(resultado);
        }


        [HttpGet("historiales-crediticios")]
        public async Task<IActionResult> ObtenerHistorialesCrediticios(
            [FromQuery] bool incluirEliminados = false)
        {
            string procedimiento = incluirEliminados
                ? "sp_ConsultarHistorialesCrediticiosTodos"
                : "sp_ConsultarHistorialesCrediticios";

            var resultado =
                await _catalogoRepository.ConsultarCatalogo(procedimiento);

            return Ok(resultado);
        }


        [HttpGet("medios-contratacion")]
        public async Task<IActionResult> ObtenerMediosContratacion(
            [FromQuery] bool incluirEliminados = false)
        {
            string procedimiento = incluirEliminados
                ? "sp_ConsultarMediosContratacionTodos"
                : "sp_ConsultarMediosContratacion";

            var resultado =
                await _catalogoRepository.ConsultarCatalogo(procedimiento);

            return Ok(resultado);
        }


        // Estos dos los dejamos como estaban porque no forman
        // parte del CRUD que estamos manejando en GestionCRUD.

        [HttpGet("categorias-pregunta")]
        public async Task<IActionResult> ObtenerCategoriasPregunta()
        {
            var resultado =
                await _catalogoRepository.ConsultarCatalogo(
                    "sp_ConsultarCategoriasPregunta"
                );

            return Ok(resultado);
        }


        [HttpGet("preguntas")]
        public async Task<IActionResult> ObtenerPreguntas()
        {
            var resultado =
                await _catalogoRepository.ConsultarCatalogo(
                    "sp_ConsultarPreguntas"
                );

            return Ok(resultado);
        }

        // =====================================================
        // INSERTAR
        // POST api/Catalogo/mantenimiento/genero
        // =====================================================

        [HttpPost("mantenimiento/{catalogo}")]
        public async Task<IActionResult> Insertar(
            string catalogo,
            [FromBody] CatalogoMantenimientoDTO datos)
        {
            try
            {
                int? idUsuario = ObtenerIdUsuarioAuditoria();

                string? procedimiento =
                    ObtenerProcedimientoInsertar(catalogo);

                if (procedimiento == null)
                {
                    return BadRequest(new
                    {
                        mensaje = "Catálogo no válido."
                    });
                }

                var parametros =
                    CrearParametros(
                        catalogo,
                        datos,
                        null,
                        idUsuario
                    );

                var resultado =
                    await _catalogoRepository.EjecutarCatalogo(
                        procedimiento,
                        parametros
                    );

                return ProcesarResultado(resultado);
            }
            catch (Exception ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }

        // =====================================================
        // ACTUALIZAR
        // PUT api/Catalogo/mantenimiento/genero/1
        // =====================================================

        [HttpPut("mantenimiento/{catalogo}/{id}")]
        public async Task<IActionResult> Actualizar(
            string catalogo,
            int id,
            [FromBody] CatalogoMantenimientoDTO datos)
        {
            try
            {
                int? idUsuario = ObtenerIdUsuarioAuditoria();

                string? procedimiento =
                    ObtenerProcedimientoActualizar(catalogo);

                if (procedimiento == null)
                {
                    return BadRequest(new
                    {
                        mensaje = "Catálogo no válido."
                    });
                }

                var parametros =
                    CrearParametros(
                        catalogo,
                        datos,
                        id,
                        idUsuario
                    );

                var resultado =
                    await _catalogoRepository.EjecutarCatalogo(
                        procedimiento,
                        parametros
                    );

                return ProcesarResultado(resultado);
            }
            catch (Exception ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }

        // =====================================================
        // ELIMINAR LÓGICAMENTE
        // DELETE api/Catalogo/mantenimiento/genero/1
        // =====================================================

        [HttpDelete("mantenimiento/{catalogo}/{id}")]
        public async Task<IActionResult> Eliminar(
            string catalogo,
            int id)
        {
            try
            {
                int? idUsuario = ObtenerIdUsuarioAuditoria();

                var configuracion =
                    ObtenerConfiguracionEliminar(catalogo);

                if (configuracion == null)
                {
                    return BadRequest(new
                    {
                        mensaje = "Catálogo no válido."
                    });
                }

                var parametros =
                    new List<SqlParameter>
                    {
                        new SqlParameter(
                            configuracion.Value.ParametroId,
                            id
                        ),

                        new SqlParameter(
                            "@IdUsuarioAuditoria",
                            (object?)idUsuario
                                ?? DBNull.Value
                        )
                    };

                var resultado =
                    await _catalogoRepository.EjecutarCatalogo(
                        configuracion.Value.Procedimiento,
                        parametros
                    );

                return ProcesarResultado(resultado);
            }
            catch (Exception ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }

        // =====================================================
        // RESTAURAR
        // PUT api/Catalogo/restaurar/genero/1
        // =====================================================

        [HttpPut("restaurar/{catalogo}/{id}")]
        public async Task<IActionResult> Restaurar(
            string catalogo,
            int id)
        {
            try
            {
                int? idUsuario = ObtenerIdUsuarioAuditoria();

                var configuracion =
                    ObtenerConfiguracionRestaurar(catalogo);

                if (configuracion == null)
                {
                    return BadRequest(new
                    {
                        mensaje = "Catálogo no válido."
                    });
                }

                var parametros =
                    new List<SqlParameter>
                    {
                        new SqlParameter(
                            configuracion.Value.ParametroId,
                            id
                        ),

                        new SqlParameter(
                            "@IdUsuarioAuditoria",
                            (object?)idUsuario
                                ?? DBNull.Value
                        )
                    };

                var resultado =
                    await _catalogoRepository.EjecutarCatalogo(
                        configuracion.Value.Procedimiento,
                        parametros
                    );

                return ProcesarResultado(resultado);
            }
            catch (Exception ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }

        // =====================================================
        // NOMBRES DE SP - INSERTAR
        // =====================================================

        private string? ObtenerProcedimientoInsertar(
            string catalogo)
        {
            switch (catalogo.ToLower())
            {
                case "genero":
                    return "sp_InsertarGenero";

                case "ciudad":
                    return "sp_InsertarCiudad";

                case "ocupacion":
                    return "sp_InsertarOcupacion";

                case "nivel-educativo":
                    return "sp_InsertarNivelEducativo";

                case "tipo-prestamo":
                    return "sp_InsertarTipoPrestamo";

                case "medio-contratacion":
                    return "sp_InsertarMedioContratacion";

                case "plazo":
                    return "sp_InsertarPlazo";

                case "rango-edad":
                    return "sp_InsertarRangoEdad";

                case "rango-ingresos":
                    return "sp_InsertarRangoIngresos";

                case "monto-rango":
                    return "sp_InsertarMontoRango";

                case "tasa-interes":
                    return "sp_InsertarTasaInteresRango";

                case "capacidad-pago":
                    return "sp_InsertarCapacidadPago";

                case "historial-crediticio":
                    return "sp_InsertarHistorialCrediticio";

                default:
                    return null;
            }
        }

        // =====================================================
        // NOMBRES DE SP - ACTUALIZAR
        // =====================================================

        private string? ObtenerProcedimientoActualizar(
            string catalogo)
        {
            switch (catalogo.ToLower())
            {
                case "genero":
                    return "sp_ActualizarGenero";

                case "ciudad":
                    return "sp_ActualizarCiudad";

                case "ocupacion":
                    return "sp_ActualizarOcupacion";

                case "nivel-educativo":
                    return "sp_ActualizarNivelEducativo";

                case "tipo-prestamo":
                    return "sp_ActualizarTipoPrestamo";

                case "medio-contratacion":
                    return "sp_ActualizarMedioContratacion";

                case "plazo":
                    return "sp_ActualizarPlazo";

                case "rango-edad":
                    return "sp_ActualizarRangoEdad";

                case "rango-ingresos":
                    return "sp_ActualizarRangoIngresos";

                case "monto-rango":
                    return "sp_ActualizarMontoRango";

                case "tasa-interes":
                    return "sp_ActualizarTasaInteresRango";

                case "capacidad-pago":
                    return "sp_ActualizarCapacidadPago";

                case "historial-crediticio":
                    return "sp_ActualizarHistorialCrediticio";

                default:
                    return null;
            }
        }

        // =====================================================
        // CONFIGURACIÓN ELIMINAR
        // =====================================================

        private (string Procedimiento, string ParametroId)?
            ObtenerConfiguracionEliminar(string catalogo)
        {
            switch (catalogo.ToLower())
            {
                case "genero":
                    return (
                        "sp_EliminarGeneroLogico",
                        "@IdGenero"
                    );

                case "ciudad":
                    return (
                        "sp_EliminarCiudadLogico",
                        "@IdCiudad"
                    );

                case "ocupacion":
                    return (
                        "sp_EliminarOcupacionLogico",
                        "@IdOcupacion"
                    );

                case "nivel-educativo":
                    return (
                        "sp_EliminarNivelEducativoLogico",
                        "@IdNivelEducativo"
                    );

                case "tipo-prestamo":
                    return (
                        "sp_EliminarTipoPrestamoLogico",
                        "@IdTipoPrestamo"
                    );

                case "medio-contratacion":
                    return (
                        "sp_EliminarMedioContratacionLogico",
                        "@IdMedio"
                    );

                case "plazo":
                    return (
                        "sp_EliminarPlazoLogico",
                        "@IdPlazo"
                    );

                case "rango-edad":
                    return (
                        "sp_EliminarRangoEdadLogico",
                        "@IdRangoEdad"
                    );

                case "rango-ingresos":
                    return (
                        "sp_EliminarRangoIngresosLogico",
                        "@IdRangoIngresos"
                    );

                case "monto-rango":
                    return (
                        "sp_EliminarMontoRangoLogico",
                        "@IdMontoRango"
                    );

                case "tasa-interes":
                    return (
                        "sp_EliminarTasaInteresRangoLogico",
                        "@IdTasaRango"
                    );

                case "capacidad-pago":
                    return (
                        "sp_EliminarCapacidadPagoLogico",
                        "@IdCapacidadPago"
                    );

                case "historial-crediticio":
                    return (
                        "sp_EliminarHistorialCrediticioLogico",
                        "@IdHistorial"
                    );

                default:
                    return null;
            }
        }

        // =====================================================
        // CONFIGURACIÓN RESTAURAR
        // =====================================================

        private (string Procedimiento, string ParametroId)?
            ObtenerConfiguracionRestaurar(string catalogo)
        {
            switch (catalogo.ToLower())
            {
                case "genero":
                    return (
                        "sp_RestaurarGenero",
                        "@IdGenero"
                    );

                case "ciudad":
                    return (
                        "sp_RestaurarCiudad",
                        "@IdCiudad"
                    );

                case "ocupacion":
                    return (
                        "sp_RestaurarOcupacion",
                        "@IdOcupacion"
                    );

                case "nivel-educativo":
                    return (
                        "sp_RestaurarNivelEducativo",
                        "@IdNivelEducativo"
                    );

                case "tipo-prestamo":
                    return (
                        "sp_RestaurarTipoPrestamo",
                        "@IdTipoPrestamo"
                    );

                case "medio-contratacion":
                    return (
                        "sp_RestaurarMedioContratacion",
                        "@IdMedio"
                    );

                case "plazo":
                    return (
                        "sp_RestaurarPlazo",
                        "@IdPlazo"
                    );

                case "rango-edad":
                    return (
                        "sp_RestaurarRangoEdad",
                        "@IdRangoEdad"
                    );

                case "rango-ingresos":
                    return (
                        "sp_RestaurarRangoIngresos",
                        "@IdRangoIngresos"
                    );

                case "monto-rango":
                    return (
                        "sp_RestaurarMontoRango",
                        "@IdMontoRango"
                    );

                case "tasa-interes":
                    return (
                        "sp_RestaurarTasaInteresRango",
                        "@IdTasaRango"
                    );

                case "capacidad-pago":
                    return (
                        "sp_RestaurarCapacidadPago",
                        "@IdCapacidadPago"
                    );

                case "historial-crediticio":
                    return (
                        "sp_RestaurarHistorialCrediticio",
                        "@IdHistorial"
                    );

                default:
                    return null;
            }
        }

        // =====================================================
        // CREACIÓN DE PARÁMETROS
        // =====================================================

        private List<SqlParameter> CrearParametros(
            string catalogo,
            CatalogoMantenimientoDTO datos,
            int? id,
            int? idUsuario)
        {
            var parametros =
                new List<SqlParameter>();

            switch (catalogo.ToLower())
            {
                // ---------------------------------------------
                // CATÁLOGOS SIMPLES
                // ---------------------------------------------

                case "genero":

                    AgregarId(
                        parametros,
                        "@IdGenero",
                        id
                    );

                    parametros.Add(
                        new SqlParameter(
                            "@Nombre",
                            datos.Nombre ?? ""
                        )
                    );

                    break;

                case "ciudad":

                    AgregarId(
                        parametros,
                        "@IdCiudad",
                        id
                    );

                    parametros.Add(
                        new SqlParameter(
                            "@Nombre",
                            datos.Nombre ?? ""
                        )
                    );

                    break;

                case "ocupacion":

                    AgregarId(
                        parametros,
                        "@IdOcupacion",
                        id
                    );

                    parametros.Add(
                        new SqlParameter(
                            "@Nombre",
                            datos.Nombre ?? ""
                        )
                    );

                    break;

                case "nivel-educativo":

                    AgregarId(
                        parametros,
                        "@IdNivelEducativo",
                        id
                    );

                    parametros.Add(
                        new SqlParameter(
                            "@Nombre",
                            datos.Nombre ?? ""
                        )
                    );

                    break;

                case "tipo-prestamo":

                    AgregarId(
                        parametros,
                        "@IdTipoPrestamo",
                        id
                    );

                    parametros.Add(
                        new SqlParameter(
                            "@Nombre",
                            datos.Nombre ?? ""
                        )
                    );

                    break;

                case "medio-contratacion":

                    AgregarId(
                        parametros,
                        "@IdMedio",
                        id
                    );

                    parametros.Add(
                        new SqlParameter(
                            "@Nombre",
                            datos.Nombre ?? ""
                        )
                    );

                    break;

                // ---------------------------------------------
                // PLAZO
                // ---------------------------------------------

                case "plazo":

                    AgregarId(
                        parametros,
                        "@IdPlazo",
                        id
                    );

                    parametros.Add(
                        new SqlParameter(
                            "@Meses",
                            (object?)datos.Meses
                                ?? DBNull.Value
                        )
                    );

                    break;

                // ---------------------------------------------
                // RANGOS
                // ---------------------------------------------

                case "rango-edad":

                    AgregarId(
                        parametros,
                        "@IdRangoEdad",
                        id
                    );

                    parametros.Add(
                        new SqlParameter(
                            "@Minimo",
                            (object?)datos.Minimo
                                ?? DBNull.Value
                        )
                    );

                    parametros.Add(
                        new SqlParameter(
                            "@Maximo",
                            (object?)datos.Maximo
                                ?? DBNull.Value
                        )
                    );

                    parametros.Add(
                        new SqlParameter(
                            "@Descripcion",
                            datos.Descripcion ?? ""
                        )
                    );

                    break;

                case "rango-ingresos":

                    AgregarId(
                        parametros,
                        "@IdRangoIngresos",
                        id
                    );

                    AgregarParametrosRango(
                        parametros,
                        datos
                    );

                    break;

                case "monto-rango":

                    AgregarId(
                        parametros,
                        "@IdMontoRango",
                        id
                    );

                    AgregarParametrosRango(
                        parametros,
                        datos
                    );

                    break;

                case "tasa-interes":

                    AgregarId(
                        parametros,
                        "@IdTasaRango",
                        id
                    );

                    AgregarParametrosRango(
                        parametros,
                        datos
                    );

                    break;

                case "capacidad-pago":

                    AgregarId(
                        parametros,
                        "@IdCapacidadPago",
                        id
                    );

                    AgregarParametrosRango(
                        parametros,
                        datos
                    );

                    break;

                // ---------------------------------------------
                // HISTORIAL CREDITICIO
                // ---------------------------------------------

                case "historial-crediticio":

                    AgregarId(
                        parametros,
                        "@IdHistorial",
                        id
                    );

                    parametros.Add(
                        new SqlParameter(
                            "@TienePrestamosPrevios",
                            (object?)datos.TienePrestamosPrevios
                                ?? DBNull.Value
                        )
                    );

                    parametros.Add(
                        new SqlParameter(
                            "@HaMorado",
                            (object?)datos.HaMorado
                                ?? DBNull.Value
                        )
                    );

                    parametros.Add(
                        new SqlParameter(
                            "@Descripcion",
                            datos.Descripcion ?? ""
                        )
                    );

                    break;

                default:

                    throw new Exception(
                        "Catálogo no reconocido."
                    );
            }

            parametros.Add(
                new SqlParameter(
                    "@IdUsuarioAuditoria",
                    (object?)idUsuario
                        ?? DBNull.Value
                )
            );

            return parametros;
        }

        private void AgregarParametrosRango(
            List<SqlParameter> parametros,
            CatalogoMantenimientoDTO datos)
        {
            parametros.Add(
                new SqlParameter(
                    "@Minimo",
                    (object?)datos.Minimo
                        ?? DBNull.Value
                )
            );

            parametros.Add(
                new SqlParameter(
                    "@Maximo",
                    (object?)datos.Maximo
                        ?? DBNull.Value
                )
            );

            parametros.Add(
                new SqlParameter(
                    "@Descripcion",
                    datos.Descripcion ?? ""
                )
            );
        }

        private void AgregarId(
            List<SqlParameter> parametros,
            string nombreParametro,
            int? id)
        {
            if (id.HasValue)
            {
                parametros.Add(
                    new SqlParameter(
                        nombreParametro,
                        id.Value
                    )
                );
            }
        }

        // =====================================================
        // AUDITORÍA
        // =====================================================

        private int? ObtenerIdUsuarioAuditoria()
        {
            if (
                Request.Headers.TryGetValue(
                    "X-Usuario-Id",
                    out var valor
                )
                &&
                int.TryParse(
                    valor,
                    out int idUsuario
                )
            )
            {
                return idUsuario;
            }

            return null;
        }

        // =====================================================
        // RESPUESTA
        // =====================================================

        private IActionResult ProcesarResultado(
            List<Dictionary<string, object>> resultado)
        {
            if (resultado.Count == 0)
            {
                return Ok(new
                {
                    mensaje = "Operación realizada correctamente."
                });
            }

            if (resultado[0].ContainsKey("ErrorMensaje"))
            {
                return BadRequest(new
                {
                    errorNumero =
                        resultado[0].ContainsKey("ErrorNumero")
                            ? resultado[0]["ErrorNumero"]
                            : "",

                    errorMensaje =
                        resultado[0]["ErrorMensaje"]
                });
            }

            return Ok(resultado);
        }
    }
}