using SistemaPrestamosAPI.Data;
using System.Data;

namespace SistemaPrestamosAPI.Repositories
{
    public class GraficoRepository
    {
        private readonly StoredProcedureExecutor _executor;

        public GraficoRepository(StoredProcedureExecutor executor)
        {
            _executor = executor;
        }

        public async Task<DataTable> ObtenerGrafico(int idPregunta)
        {
            if (idPregunta < 1 || idPregunta > 30)
            {
                throw new ArgumentException("El número de pregunta debe estar entre 1 y 30.");
            }

            string sp = $"sp_ReportePregunta{idPregunta.ToString("D2")}";

            return await _executor.ExecuteDataTableAsync(sp);
        }
    }
}