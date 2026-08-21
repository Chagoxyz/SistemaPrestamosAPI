using SistemaPrestamosAPI.Data;
using System.Data;

namespace SistemaPrestamosAPI.Repositories
{
    public class ReporteRepository
    {
        private readonly StoredProcedureExecutor _executor;

        public ReporteRepository(StoredProcedureExecutor executor)
        {
            _executor = executor;
        }

        public async Task<List<Dictionary<string, object>>> ObtenerReporte(int numero)
        {
            if (numero < 1 || numero > 30)
            {
                throw new ArgumentException("El número de reporte debe estar entre 1 y 30.");
            }

            string procedimiento = $"sp_ReportePregunta{numero.ToString("D2")}";

            var tabla = await _executor.ExecuteDataTableAsync(procedimiento);

            var lista = new List<Dictionary<string, object>>();

            foreach (DataRow fila in tabla.Rows)
            {
                var item = new Dictionary<string, object>();

                foreach (DataColumn columna in tabla.Columns)
                {
                    item[columna.ColumnName] = fila[columna] == DBNull.Value ? "" : fila[columna];
                }

                lista.Add(item);
            }

            return lista;
        }
    }
}