using Microsoft.Data.SqlClient;
using System.Data;

namespace SistemaPrestamosAPI.Data
{
    public class StoredProcedureExecutor
    {
        private readonly DatabaseConnection _databaseConnection;

        public StoredProcedureExecutor(DatabaseConnection databaseConnection)
        {
            _databaseConnection = databaseConnection;
        }

        public async Task<DataTable> ExecuteDataTableAsync(
            string procedureName,
            List<SqlParameter>? parameters = null)
        {
            using var connection = _databaseConnection.GetConnection();
            using var command = new SqlCommand(procedureName, connection);

            command.CommandType = CommandType.StoredProcedure;

            if (parameters != null)
            {
                command.Parameters.AddRange(parameters.ToArray());
            }

            await connection.OpenAsync();

            using var reader = await command.ExecuteReaderAsync();

            var table = new DataTable();
            table.Load(reader);

            return table;
        }

        public async Task<int> ExecuteNonQueryAsync(
            string procedureName,
            List<SqlParameter>? parameters = null)
        {
            using var connection = _databaseConnection.GetConnection();
            using var command = new SqlCommand(procedureName, connection);

            command.CommandType = CommandType.StoredProcedure;

            if (parameters != null)
            {
                command.Parameters.AddRange(parameters.ToArray());
            }

            await connection.OpenAsync();

            return await command.ExecuteNonQueryAsync();
        }
    }
}