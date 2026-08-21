namespace SistemaPrestamosAPI.DTOs
{
    public class UsuarioRequestDTO
    {
        public string Nombre { get; set; } = string.Empty;
        public string NombreUsuario { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Clave { get; set; } = string.Empty;
        public int IdRol { get; set; }
    }
}