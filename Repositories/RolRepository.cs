using SistemaPrestamosAPI.Data;
using System.Data;

namespace SistemaPrestamosAPI.Repositories
{
    public class RolRepository
    {
        private readonly StoredProcedureExecutor _executor;

        public RolRepository(StoredProcedureExecutor executor)
        {
            _executor = executor;
        }

        public async Task<DataTable> ConsultarRoles()
        {
            return await _executor.ExecuteDataTableAsync(
                "sp_ConsultarRoles");
        }
    }
}