namespace SistemaPrestamosAPI.DTOs
{
    public class CrearEncuestaDTO
    {
        public string NombreCliente { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Telefono { get; set; } = string.Empty;

        public int IdGenero { get; set; }
        public int IdNivelEducativo { get; set; }
        public int IdRangoIngresos { get; set; }
        public int IdRangoEdad { get; set; }
        public int IdCiudad { get; set; }
        public int IdOcupacion { get; set; }

        public int IdTipoPrestamo { get; set; }
        public int IdPlazo { get; set; }
        public int IdMontoRango { get; set; }
        public int IdTasaRango { get; set; }
        public int IdCapacidadPago { get; set; }
        public int IdHistorial { get; set; }

        public int? IdUsuarioCreador { get; set; }
        public string? IdentificadorSesion { get; set; }
        public string? DireccionIP { get; set; }
        public string? Observacion { get; set; }

        public List<RespuestaEncuestaDTO> Respuestas { get; set; } = new();
        public List<int> Medios { get; set; } = new();
    }
}