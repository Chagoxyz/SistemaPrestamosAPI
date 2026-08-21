using Microsoft.Data.SqlClient;
using SistemaPrestamosAPI.Data;
using System.Data;

namespace SistemaPrestamosAPI.Repositories
{
    public class CatalogoRepository
    {
        private readonly StoredProcedureExecutor _executor;

        public CatalogoRepository(
            StoredProcedureExecutor executor)
        {
            _executor = executor;
        }

        public async Task<List<Dictionary<string, object>>>
            ConsultarCatalogo(string procedimiento)
        {
            var tabla =
                await _executor.ExecuteDataTableAsync(
                    procedimiento
                );

            return ConvertirTabla(tabla);
        }

        public async Task<List<Dictionary<string, object>>>
            EjecutarCatalogo(
                string procedimiento,
                List<SqlParameter> parametros)
        {
            var tabla =
                await _executor.ExecuteDataTableAsync(
                    procedimiento,
                    parametros
                );

            return ConvertirTabla(tabla);
        }

        private List<Dictionary<string, object>>
            ConvertirTabla(DataTable tabla)
        {
            var lista =
                new List<Dictionary<string, object>>();

            foreach (DataRow fila in tabla.Rows)
            {
                var item =
                    new Dictionary<string, object>();

                foreach (DataColumn columna in tabla.Columns)
                {
                    item[columna.ColumnName] =
                        fila[columna] == DBNull.Value
                            ? ""
                            : fila[columna];
                }

                lista.Add(item);
            }

            return lista;
        }
    }
}