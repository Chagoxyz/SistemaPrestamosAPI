namespace SistemaPrestamosAPI.DTOs
{
    public class LoginRequestDTO
    {
        public string NombreUsuario { get; set; } = string.Empty;
        public string Clave { get; set; } = string.Empty;
    }
}