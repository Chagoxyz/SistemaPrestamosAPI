using Microsoft.Data.SqlClient;
using SistemaPrestamosAPI.Data;
using SistemaPrestamosAPI.DTOs;
using SistemaPrestamosAPI.Models;
using System.Data;

namespace SistemaPrestamosAPI.Repositories
{
    public class UsuarioRepository
    {
        private readonly DatabaseConnection _databaseConnection;
        private readonly StoredProcedureExecutor _executor;

        public UsuarioRepository(
            DatabaseConnection databaseConnection,
            StoredProcedureExecutor executor)
        {
            _databaseConnection = databaseConnection;
            _executor = executor;
        }

        public async Task<Usuario?> Login(LoginRequestDTO request)
        {
            using var connection = _databaseConnection.GetConnection();
            using var command = new SqlCommand("sp_LoginUsuario", connection);

            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue(
                "@NombreUsuario",
                request.NombreUsuario
            );

            command.Parameters.AddWithValue(
                "@Clave",
                request.Clave
            );

            await connection.OpenAsync();

            using var reader = await command.ExecuteReaderAsync();

            if (await reader.ReadAsync())
            {
                return new Usuario
                {
                    IdUsuario = Convert.ToInt32(reader["IdUsuario"]),
                    Nombre = reader["Nombre"].ToString() ?? "",
                    NombreUsuario = reader["NombreUsuario"].ToString() ?? "",
                    Email = reader["Email"].ToString() ?? "",
                    IdRol = Convert.ToInt32(reader["IdRol"]),
                    Rol = reader["Rol"].ToString() ?? ""
                };
            }

            return null;
        }

        public async Task<DataTable> ConsultarUsuarios()
        {
            return await _executor.ExecuteDataTableAsync(
                "sp_ConsultarUsuarios"
            );
        }

        public async Task<DataTable> CrearUsuario(
            UsuarioRequestDTO usuario,
            int? idUsuarioAuditoria)
        {
            var parametros = new List<SqlParameter>
            {
                new SqlParameter("@Nombre", usuario.Nombre),
                new SqlParameter("@NombreUsuario", usuario.NombreUsuario),
                new SqlParameter("@Email", usuario.Email),
                new SqlParameter("@Clave", usuario.Clave),
                new SqlParameter("@IdRol", usuario.IdRol),

                new SqlParameter(
                    "@IdUsuarioAuditoria",
                    (object?)idUsuarioAuditoria ?? DBNull.Value
                )
            };

            return await _executor.ExecuteDataTableAsync(
                "sp_InsertarUsuario",
                parametros
            );
        }

        public async Task<DataTable> ActualizarUsuario(
            int idUsuario,
            UsuarioRequestDTO usuario,
            int? idUsuarioAuditoria)
        {
            var parametros = new List<SqlParameter>
            {
                new SqlParameter("@IdUsuario", idUsuario),
                new SqlParameter("@Nombre", usuario.Nombre),
                new SqlParameter("@NombreUsuario", usuario.NombreUsuario),
                new SqlParameter("@Email", usuario.Email),
                new SqlParameter("@Clave", usuario.Clave),
                new SqlParameter("@IdRol", usuario.IdRol),

                new SqlParameter(
                    "@IdUsuarioAuditoria",
                    (object?)idUsuarioAuditoria ?? DBNull.Value
                )
            };

            return await _executor.ExecuteDataTableAsync(
                "sp_ActualizarUsuario",
                parametros
            );
        }

        public async Task<DataTable> EliminarUsuario(
            int idUsuario,
            int? idUsuarioAuditoria)
        {
            var parametros = new List<SqlParameter>
            {
                new SqlParameter("@IdUsuario", idUsuario),

                new SqlParameter(
                    "@IdUsuarioAuditoria",
                    (object?)idUsuarioAuditoria ?? DBNull.Value
                )
            };

            return await _executor.ExecuteDataTableAsync(
                "sp_EliminarUsuarioLogico",
                parametros
            );
        }

        public async Task<DataTable> RestaurarUsuario(
            int idUsuario,
            int? idUsuarioAuditoria)
        {
            var parametros = new List<SqlParameter>
            {
                new SqlParameter("@IdUsuario", idUsuario),

                new SqlParameter(
                    "@IdUsuarioAuditoria",
                    (object?)idUsuarioAuditoria ?? DBNull.Value
                )
            };

            return await _executor.ExecuteDataTableAsync(
                "sp_RestaurarUsuario",
                parametros
            );
        }
    }
}