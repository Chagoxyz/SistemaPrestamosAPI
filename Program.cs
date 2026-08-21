using SistemaPrestamosAPI.Data;
using SistemaPrestamosAPI.Repositories;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddScoped<DatabaseConnection>();
builder.Services.AddScoped<ConexionRepository>();
builder.Services.AddScoped<UsuarioRepository>();
builder.Services.AddScoped<StoredProcedureExecutor>();
builder.Services.AddScoped<CatalogoRepository>();
builder.Services.AddScoped<EncuestaRepository>();
builder.Services.AddScoped<ReporteRepository>();
builder.Services.AddScoped<RolRepository>();
builder.Services.AddScoped<GraficoRepository>();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();

    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "API v1");
        c.RoutePrefix = string.Empty;
    });
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();



