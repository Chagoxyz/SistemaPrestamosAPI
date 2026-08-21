using Microsoft.Data.SqlClient;
using SistemaPrestamosAPI.Data;
using SistemaPrestamosAPI.DTOs;
using System.Data;

namespace SistemaPrestamosAPI.Repositories
{
    public class EncuestaRepository
    {
        private readonly DatabaseConnection _databaseConnection;

        public EncuestaRepository(DatabaseConnection databaseConnection)
        {
            _databaseConnection = databaseConnection;
        }

        public async Task<DataTable> CrearEncuesta(CrearEncuestaDTO request)
        {
            using var connection = _databaseConnection.GetConnection();

            using var command =
                new SqlCommand("sp_CrearEncuestaCompleta", connection);

            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue(
                "@NombreCliente",
                request.NombreCliente
            );

            command.Parameters.AddWithValue(
                "@Email",
                request.Email
            );

            command.Parameters.AddWithValue(
                "@Telefono",
                request.Telefono
            );

            command.Parameters.AddWithValue(
                "@IdGenero",
                request.IdGenero
            );

            command.Parameters.AddWithValue(
                "@IdNivelEducativo",
                request.IdNivelEducativo
            );

            command.Parameters.AddWithValue(
                "@IdRangoIngresos",
                request.IdRangoIngresos
            );

            command.Parameters.AddWithValue(
                "@IdRangoEdad",
                request.IdRangoEdad
            );

            command.Parameters.AddWithValue(
                "@IdCiudad",
                request.IdCiudad
            );

            command.Parameters.AddWithValue(
                "@IdOcupacion",
                request.IdOcupacion
            );

            command.Parameters.AddWithValue(
                "@IdTipoPrestamo",
                request.IdTipoPrestamo
            );

            command.Parameters.AddWithValue(
                "@IdPlazo",
                request.IdPlazo
            );

            command.Parameters.AddWithValue(
                "@IdMontoRango",
                request.IdMontoRango
            );

            command.Parameters.AddWithValue(
                "@IdTasaRango",
                request.IdTasaRango
            );

            command.Parameters.AddWithValue(
                "@IdCapacidadPago",
                request.IdCapacidadPago
            );

            command.Parameters.AddWithValue(
                "@IdHistorial",
                request.IdHistorial
            );

            command.Parameters.AddWithValue(
                "@IdUsuarioCreador",
                (object?)request.IdUsuarioCreador ?? DBNull.Value
            );

            command.Parameters.AddWithValue(
                "@IdentificadorSesion",
                (object?)request.IdentificadorSesion ?? DBNull.Value
            );

            command.Parameters.AddWithValue(
                "@DireccionIP",
                (object?)request.DireccionIP ?? DBNull.Value
            );

            command.Parameters.AddWithValue(
                "@Observacion",
                (object?)request.Observacion ?? DBNull.Value
            );

            var respuestasTable = CrearTablaRespuestas(request.Respuestas);
            var mediosTable = CrearTablaMedios(request.Medios);

            var respuestasParam =
                command.Parameters.AddWithValue(
                    "@Respuestas",
                    respuestasTable
                );

            respuestasParam.SqlDbType = SqlDbType.Structured;
            respuestasParam.TypeName = "TipoRespuestaEncuesta";

            var mediosParam =
                command.Parameters.AddWithValue(
                    "@Medios",
                    mediosTable
                );

            mediosParam.SqlDbType = SqlDbType.Structured;
            mediosParam.TypeName = "TipoMedioEncuesta";

            await connection.OpenAsync();

            using var reader = await command.ExecuteReaderAsync();

            var resultado = new DataTable();
            resultado.Load(reader);

            return resultado;
        }

        public async Task<DataTable> ConsultarEncuestas()
        {
            using var connection = _databaseConnection.GetConnection();

            using var command =
                new SqlCommand("sp_ConsultarEncuestas", connection);

            command.CommandType = CommandType.StoredProcedure;

            await connection.OpenAsync();

            using var reader = await command.ExecuteReaderAsync();

            var resultado = new DataTable();
            resultado.Load(reader);

            return resultado;
        }

        public async Task<List<DataTable>> ConsultarEncuestaPorId(
            int idEncuesta)
        {
            using var connection = _databaseConnection.GetConnection();

            using var command =
                new SqlCommand(
                    "sp_ConsultarEncuestaPorId",
                    connection
                );

            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue(
                "@IdEncuesta",
                idEncuesta
            );

            await connection.OpenAsync();

            using var reader = await command.ExecuteReaderAsync();

            var tablas = new List<DataTable>();

            do
            {
                var tabla = new DataTable();
                tabla.Load(reader);
                tablas.Add(tabla);
            }
            while (
                !reader.IsClosed &&
                await reader.NextResultAsync()
            );

            return tablas;
        }

        public async Task<DataTable> ActualizarEncuesta(
            ActualizarEncuestaDTO request)
        {
            using var connection = _databaseConnection.GetConnection();

            using var command =
                new SqlCommand(
                    "sp_ActualizarEncuestaCompleta",
                    connection
                );

            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue(
                "@IdEncuesta",
                request.IdEncuesta
            );

            command.Parameters.AddWithValue(
                "@NombreCliente",
                request.NombreCliente
            );

            command.Parameters.AddWithValue(
                "@Email",
                request.Email
            );

            command.Parameters.AddWithValue(
                "@Telefono",
                request.Telefono
            );

            command.Parameters.AddWithValue(
                "@IdGenero",
                request.IdGenero
            );

            command.Parameters.AddWithValue(
                "@IdNivelEducativo",
                request.IdNivelEducativo
            );

            command.Parameters.AddWithValue(
                "@IdRangoIngresos",
                request.IdRangoIngresos
            );

            command.Parameters.AddWithValue(
                "@IdRangoEdad",
                request.IdRangoEdad
            );

            command.Parameters.AddWithValue(
                "@IdCiudad",
                request.IdCiudad
            );

            command.Parameters.AddWithValue(
                "@IdOcupacion",
                request.IdOcupacion
            );

            command.Parameters.AddWithValue(
                "@IdTipoPrestamo",
                request.IdTipoPrestamo
            );

            command.Parameters.AddWithValue(
                "@IdPlazo",
                request.IdPlazo
            );

            command.Parameters.AddWithValue(
                "@IdMontoRango",
                request.IdMontoRango
            );

            command.Parameters.AddWithValue(
                "@IdTasaRango",
                request.IdTasaRango
            );

            command.Parameters.AddWithValue(
                "@IdCapacidadPago",
                request.IdCapacidadPago
            );

            command.Parameters.AddWithValue(
                "@IdHistorial",
                request.IdHistorial
            );

            command.Parameters.AddWithValue(
                "@IdUsuarioAuditoria",
                (object?)request.IdUsuarioAuditoria ?? DBNull.Value
            );

            command.Parameters.AddWithValue(
                "@Observacion",
                (object?)request.Observacion ?? DBNull.Value
            );

            var respuestasTable =
                CrearTablaRespuestas(request.Respuestas);

            var mediosTable =
                CrearTablaMedios(request.Medios);

            var respuestasParam =
                command.Parameters.AddWithValue(
                    "@Respuestas",
                    respuestasTable
                );

            respuestasParam.SqlDbType = SqlDbType.Structured;
            respuestasParam.TypeName = "TipoRespuestaEncuesta";

            var mediosParam =
                command.Parameters.AddWithValue(
                    "@Medios",
                    mediosTable
                );

            mediosParam.SqlDbType = SqlDbType.Structured;
            mediosParam.TypeName = "TipoMedioEncuesta";

            await connection.OpenAsync();

            using var reader = await command.ExecuteReaderAsync();

            var resultado = new DataTable();
            resultado.Load(reader);

            return resultado;
        }

        public async Task<DataTable> EliminarEncuestaLogica(
            int idEncuesta,
            int? idUsuario)
        {
            using var connection = _databaseConnection.GetConnection();

            using var command =
                new SqlCommand(
                    "sp_EliminarEncuestaLogica",
                    connection
                );

            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue(
                "@IdEncuesta",
                idEncuesta
            );

            command.Parameters.AddWithValue(
                "@IdUsuario",
                (object?)idUsuario ?? DBNull.Value
            );

            await connection.OpenAsync();

            using var reader = await command.ExecuteReaderAsync();

            var resultado = new DataTable();
            resultado.Load(reader);

            return resultado;
        }

        public async Task<DataTable> RestaurarEncuesta(
            int idEncuesta,
            int? idUsuario)
        {
            using var connection = _databaseConnection.GetConnection();

            using var command =
                new SqlCommand(
                    "sp_RestaurarEncuesta",
                    connection
                );

            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue(
                "@IdEncuesta",
                idEncuesta
            );

            command.Parameters.AddWithValue(
                "@IdUsuario",
                (object?)idUsuario ?? DBNull.Value
            );

            await connection.OpenAsync();

            using var reader = await command.ExecuteReaderAsync();

            var resultado = new DataTable();
            resultado.Load(reader);

            return resultado;
        }

        private DataTable CrearTablaRespuestas(
            IEnumerable<RespuestaEncuestaDTO> respuestas)
        {
            var tabla = new DataTable();

            tabla.Columns.Add(
                "IdPregunta",
                typeof(int)
            );

            tabla.Columns.Add(
                "ValorTexto",
                typeof(string)
            );

            tabla.Columns.Add(
                "ValorEntero",
                typeof(int)
            );

            tabla.Columns.Add(
                "ValorDecimal",
                typeof(decimal)
            );

            foreach (var respuesta in respuestas)
            {
                tabla.Rows.Add(
                    respuesta.IdPregunta,
                    (object?)respuesta.ValorTexto ?? DBNull.Value,
                    (object?)respuesta.ValorEntero ?? DBNull.Value,
                    (object?)respuesta.ValorDecimal ?? DBNull.Value
                );
            }

            return tabla;
        }

        private DataTable CrearTablaMedios(
            IEnumerable<int> medios)
        {
            var tabla = new DataTable();

            tabla.Columns.Add(
                "IdMedio",
                typeof(int)
            );

            foreach (var medio in medios)
            {
                tabla.Rows.Add(medio);
            }

            return tabla;
        }
    }
}