namespace SistemaPrestamosAPI.DTOs
{
    public class RespuestaEncuestaDTO
    {
        public int IdPregunta { get; set; }
        public string? ValorTexto { get; set; }
        public int? ValorEntero { get; set; }
        public decimal? ValorDecimal { get; set; }
    }
}