namespace SistemaPrestamosAPI.DTOs
{
    public class CatalogoMantenimientoDTO
    {
        public string? Nombre { get; set; }

        public int? Meses { get; set; }

        public decimal? Minimo { get; set; }

        public decimal? Maximo { get; set; }

        public string? Descripcion { get; set; }

        public bool? TienePrestamosPrevios { get; set; }

        public bool? HaMorado { get; set; }
    }
}