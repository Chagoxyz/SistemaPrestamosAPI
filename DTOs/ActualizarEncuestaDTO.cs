namespace SistemaPrestamosAPI.DTOs
{
    public class ActualizarEncuestaDTO : CrearEncuestaDTO
    {
        public int IdEncuesta { get; set; }
        public int? IdUsuarioAuditoria { get; set; }
    }
}