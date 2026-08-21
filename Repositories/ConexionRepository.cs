using Microsoft.Data.SqlClient;
using SistemaPrestamosAPI.Data;

namespace SistemaPrestamosAPI.Repositories
{
    public class ConexionRepository
    {
        private readonly DatabaseConnection _databaseConnection;

        public ConexionRepository(DatabaseConnection databaseConnection)
        {
            _databaseConnection = databaseConnection;
        }

        public async Task<string> ProbarConexion()
        {
            using var connection = _databaseConnection.GetConnection();

            await connection.OpenAsync();

            return "Conexión exitosa con SQL Server.";
        }
    }
}