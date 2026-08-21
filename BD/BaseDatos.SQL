/*
==============================================================
Proyecto Final - Programación VI
Sistema de Cotización para Préstamos
Base de datos: SistemaPrestamosDB
Versión final ordenada
==============================================================

Orden del script:
1. Creación de base de datos
2. Creación de tablas
3. Índices y restricciones CHECK
4. Datos iniciales
5. Tipos de tabla
6. Procedimientos almacenados generales
7. Procedimientos de seguridad, usuarios, encuesta y auditoría
8. CRUD de catálogos
9. Reportes 01 al 30
10. Consultas de verificación
==============================================================
*/

USE master;
GO

IF DB_ID('SistemaPrestamosDB') IS NOT NULL
BEGIN
    ALTER DATABASE SistemaPrestamosDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SistemaPrestamosDB;
END;
GO

CREATE DATABASE SistemaPrestamosDB;
GO

USE SistemaPrestamosDB;
GO

/* ============================================================
   1. TABLAS DE CATÁLOGO
============================================================ */

CREATE TABLE Genero (
    IdGenero INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE NivelEducativo (
    IdNivelEducativo INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE RangoEdad (
    IdRangoEdad INT IDENTITY(1,1) PRIMARY KEY,
    Minimo INT NOT NULL,
    Maximo INT NOT NULL,
    Descripcion VARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE RangoIngresos (
    IdRangoIngresos INT IDENTITY(1,1) PRIMARY KEY,
    Minimo DECIMAL(10,2) NOT NULL,
    Maximo DECIMAL(10,2) NULL,
    Descripcion VARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE Ciudad (
    IdCiudad INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE Ocupacion (
    IdOcupacion INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE TipoPrestamo (
    IdTipoPrestamo INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE Plazo (
    IdPlazo INT IDENTITY(1,1) PRIMARY KEY,
    Meses INT NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE MontoRango (
    IdMontoRango INT IDENTITY(1,1) PRIMARY KEY,
    Minimo DECIMAL(12,2) NOT NULL,
    Maximo DECIMAL(12,2) NULL,
    Descripcion VARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE TasaInteresRango (
    IdTasaRango INT IDENTITY(1,1) PRIMARY KEY,
    Minimo DECIMAL(5,2) NOT NULL,
    Maximo DECIMAL(5,2) NULL,
    Descripcion VARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE CapacidadPago (
    IdCapacidadPago INT IDENTITY(1,1) PRIMARY KEY,
    Minimo DECIMAL(10,2) NOT NULL,
    Maximo DECIMAL(10,2) NULL,
    Descripcion VARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE HistorialCrediticio (
    IdHistorial INT IDENTITY(1,1) PRIMARY KEY,
    TienePrestamosPrevios BIT NOT NULL,
    HaMorado BIT NOT NULL,
    Descripcion VARCHAR(150) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE MedioContratacion (
    IdMedio INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE MotivoRechazo (
    IdMotivoRechazo INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(200) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

/* ============================================================
   2. SEGURIDAD
============================================================ */

CREATE TABLE Rol (
    IdRol INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE Usuario (
    IdUsuario INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    NombreUsuario VARCHAR(50) NOT NULL UNIQUE,
    Email VARCHAR(150) NOT NULL UNIQUE,
    Clave VARCHAR(255) NOT NULL,
    IdRol INT NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL CONSTRAINT DF_Usuario_FechaCreacion DEFAULT GETDATE(),
    UsuarioCreacion VARCHAR(50) NOT NULL CONSTRAINT DF_Usuario_UsuarioCreacion DEFAULT 'SISTEMA',
    FechaModificacion DATETIME NULL,
    UsuarioModificacion VARCHAR(50) NULL,

    CONSTRAINT FK_Usuario_Rol 
    FOREIGN KEY (IdRol) REFERENCES Rol(IdRol)
);

/* ============================================================
   3. CLIENTE, ENCUESTA, PREGUNTAS Y RESPUESTAS
============================================================ */

CREATE TABLE Cliente (
    IdCliente INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(150) NOT NULL,
    Email VARCHAR(150) NOT NULL,
    Telefono VARCHAR(20) NOT NULL,
    IdGenero INT NOT NULL,
    IdNivelEducativo INT NOT NULL,
    IdRangoIngresos INT NOT NULL,
    IdRangoEdad INT NOT NULL,
    IdCiudad INT NOT NULL,
    IdOcupacion INT NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL CONSTRAINT DF_Cliente_FechaCreacion DEFAULT GETDATE(),
    UsuarioCreacion VARCHAR(50) NOT NULL CONSTRAINT DF_Cliente_UsuarioCreacion DEFAULT 'SISTEMA',
    FechaModificacion DATETIME NULL,
    UsuarioModificacion VARCHAR(50) NULL,

    CONSTRAINT FK_Cliente_Genero FOREIGN KEY (IdGenero) REFERENCES Genero(IdGenero),
    CONSTRAINT FK_Cliente_NivelEducativo FOREIGN KEY (IdNivelEducativo) REFERENCES NivelEducativo(IdNivelEducativo),
    CONSTRAINT FK_Cliente_RangoIngresos FOREIGN KEY (IdRangoIngresos) REFERENCES RangoIngresos(IdRangoIngresos),
    CONSTRAINT FK_Cliente_RangoEdad FOREIGN KEY (IdRangoEdad) REFERENCES RangoEdad(IdRangoEdad),
    CONSTRAINT FK_Cliente_Ciudad FOREIGN KEY (IdCiudad) REFERENCES Ciudad(IdCiudad),
    CONSTRAINT FK_Cliente_Ocupacion FOREIGN KEY (IdOcupacion) REFERENCES Ocupacion(IdOcupacion)
);

CREATE TABLE CategoriaPregunta (
    IdCategoria INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(250) NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE Pregunta (
    IdPregunta INT IDENTITY(1,1) PRIMARY KEY,
    Texto VARCHAR(300) NOT NULL,
    TipoControl VARCHAR(50) NOT NULL,
    IdCategoria INT NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,

    CONSTRAINT FK_Pregunta_Categoria 
    FOREIGN KEY (IdCategoria) REFERENCES CategoriaPregunta(IdCategoria)
);

CREATE TABLE Encuesta (
    IdEncuesta INT IDENTITY(1,1) PRIMARY KEY,
    Fecha DATETIME NOT NULL DEFAULT GETDATE(),
    IdCliente INT NOT NULL,
    IdTipoPrestamo INT NOT NULL,
    IdPlazo INT NOT NULL,
    IdMontoRango INT NOT NULL,
    IdTasaRango INT NOT NULL,
    IdCapacidadPago INT NOT NULL,
    IdHistorial INT NOT NULL,
    IdUsuarioCreador INT NULL,
    IdentificadorSesion VARCHAR(100) NULL,
    DireccionIP VARCHAR(50) NULL,
    Observacion VARCHAR(300) NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL CONSTRAINT DF_Encuesta_FechaCreacion DEFAULT GETDATE(),
    UsuarioCreacion VARCHAR(50) NOT NULL CONSTRAINT DF_Encuesta_UsuarioCreacion DEFAULT 'SISTEMA',
    FechaModificacion DATETIME NULL,
    UsuarioModificacion VARCHAR(50) NULL,

    CONSTRAINT FK_Encuesta_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente),
    CONSTRAINT FK_Encuesta_TipoPrestamo FOREIGN KEY (IdTipoPrestamo) REFERENCES TipoPrestamo(IdTipoPrestamo),
    CONSTRAINT FK_Encuesta_Plazo FOREIGN KEY (IdPlazo) REFERENCES Plazo(IdPlazo),
    CONSTRAINT FK_Encuesta_MontoRango FOREIGN KEY (IdMontoRango) REFERENCES MontoRango(IdMontoRango),
    CONSTRAINT FK_Encuesta_TasaInteresRango FOREIGN KEY (IdTasaRango) REFERENCES TasaInteresRango(IdTasaRango),
    CONSTRAINT FK_Encuesta_CapacidadPago FOREIGN KEY (IdCapacidadPago) REFERENCES CapacidadPago(IdCapacidadPago),
    CONSTRAINT FK_Encuesta_HistorialCrediticio FOREIGN KEY (IdHistorial) REFERENCES HistorialCrediticio(IdHistorial),
    CONSTRAINT FK_Encuesta_UsuarioCreador FOREIGN KEY (IdUsuarioCreador) REFERENCES Usuario(IdUsuario)
);

CREATE TABLE EncuestaMedioContratacion (
    IdEncuestaMedio INT IDENTITY(1,1) PRIMARY KEY,
    IdEncuesta INT NOT NULL,
    IdMedio INT NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL CONSTRAINT DF_EncuestaMedio_FechaCreacion DEFAULT GETDATE(),
    UsuarioCreacion VARCHAR(50) NOT NULL CONSTRAINT DF_EncuestaMedio_UsuarioCreacion DEFAULT 'SISTEMA',
    FechaModificacion DATETIME NULL,
    UsuarioModificacion VARCHAR(50) NULL,

    CONSTRAINT FK_EncuestaMedio_Encuesta FOREIGN KEY (IdEncuesta) REFERENCES Encuesta(IdEncuesta),
    CONSTRAINT FK_EncuestaMedio_Medio FOREIGN KEY (IdMedio) REFERENCES MedioContratacion(IdMedio)
);

CREATE TABLE Respuesta (
    IdRespuesta INT IDENTITY(1,1) PRIMARY KEY,
    IdEncuesta INT NOT NULL,
    IdPregunta INT NOT NULL,
    ValorTexto VARCHAR(300) NULL,
    ValorEntero INT NULL,
    ValorDecimal DECIMAL(12,2) NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL CONSTRAINT DF_Respuesta_FechaCreacion DEFAULT GETDATE(),
    UsuarioCreacion VARCHAR(50) NOT NULL CONSTRAINT DF_Respuesta_UsuarioCreacion DEFAULT 'SISTEMA',
    FechaModificacion DATETIME NULL,
    UsuarioModificacion VARCHAR(50) NULL,

    CONSTRAINT FK_Respuesta_Encuesta FOREIGN KEY (IdEncuesta) REFERENCES Encuesta(IdEncuesta),
    CONSTRAINT FK_Respuesta_Pregunta FOREIGN KEY (IdPregunta) REFERENCES Pregunta(IdPregunta)
);

/* ============================================================
   4. AUDITORÍA
============================================================ */

CREATE TABLE Auditoria (
    IdAuditoria INT IDENTITY(1,1) PRIMARY KEY,
    NombreTabla VARCHAR(100) NOT NULL,
    IdRegistro INT NOT NULL,
    Accion VARCHAR(50) NOT NULL,
    IdUsuario INT NULL,
    Fecha DATETIME NOT NULL DEFAULT GETDATE(),
    Detalle VARCHAR(500) NULL,
    ValorAnterior VARCHAR(MAX) NULL,
    ValorNuevo VARCHAR(MAX) NULL,
    Activo BIT NOT NULL DEFAULT 1,

    CONSTRAINT FK_Auditoria_Usuario 
    FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario)
);

/* ============================================================
   5. ÍNDICES
============================================================ */

CREATE INDEX IX_Cliente_IdGenero ON Cliente(IdGenero);
CREATE INDEX IX_Cliente_IdNivelEducativo ON Cliente(IdNivelEducativo);
CREATE INDEX IX_Cliente_IdRangoIngresos ON Cliente(IdRangoIngresos);
CREATE INDEX IX_Cliente_IdRangoEdad ON Cliente(IdRangoEdad);
CREATE INDEX IX_Cliente_IdCiudad ON Cliente(IdCiudad);
CREATE INDEX IX_Cliente_IdOcupacion ON Cliente(IdOcupacion);

CREATE INDEX IX_Pregunta_IdCategoria ON Pregunta(IdCategoria);

CREATE INDEX IX_Encuesta_IdCliente ON Encuesta(IdCliente);
CREATE INDEX IX_Encuesta_IdTipoPrestamo ON Encuesta(IdTipoPrestamo);
CREATE INDEX IX_Encuesta_IdPlazo ON Encuesta(IdPlazo);
CREATE INDEX IX_Encuesta_IdMontoRango ON Encuesta(IdMontoRango);
CREATE INDEX IX_Encuesta_IdTasaRango ON Encuesta(IdTasaRango);
CREATE INDEX IX_Encuesta_IdCapacidadPago ON Encuesta(IdCapacidadPago);
CREATE INDEX IX_Encuesta_IdHistorial ON Encuesta(IdHistorial);
CREATE INDEX IX_Encuesta_IdUsuarioCreador ON Encuesta(IdUsuarioCreador);

CREATE INDEX IX_EncuestaMedio_IdEncuesta ON EncuestaMedioContratacion(IdEncuesta);
CREATE INDEX IX_EncuestaMedio_IdMedio ON EncuestaMedioContratacion(IdMedio);

CREATE INDEX IX_Respuesta_IdEncuesta ON Respuesta(IdEncuesta);
CREATE INDEX IX_Respuesta_IdPregunta ON Respuesta(IdPregunta);

CREATE INDEX IX_Usuario_IdRol ON Usuario(IdRol);
CREATE INDEX IX_Auditoria_IdUsuario ON Auditoria(IdUsuario);

/* ============================================================
   6. RESTRICCIONES CHECK
============================================================ */

ALTER TABLE RangoEdad
ADD CONSTRAINT CK_RangoEdad_MinMax CHECK (Minimo <= Maximo);

ALTER TABLE RangoIngresos
ADD CONSTRAINT CK_RangoIngresos_MinMax CHECK (Maximo IS NULL OR Minimo <= Maximo);

ALTER TABLE MontoRango
ADD CONSTRAINT CK_MontoRango_MinMax CHECK (Maximo IS NULL OR Minimo <= Maximo);

ALTER TABLE TasaInteresRango
ADD CONSTRAINT CK_TasaInteresRango_MinMax CHECK (Maximo IS NULL OR Minimo <= Maximo);

ALTER TABLE CapacidadPago
ADD CONSTRAINT CK_CapacidadPago_MinMax CHECK (Maximo IS NULL OR Minimo <= Maximo);

ALTER TABLE Plazo
ADD CONSTRAINT CK_Plazo_Meses CHECK (Meses > 0);
GO

/* ============================================================
   7. DATOS INICIALES
============================================================ */

INSERT INTO Rol (Nombre) VALUES
('Administrador'),
('Encuestador'),
('Consultor');

INSERT INTO Usuario (Nombre, NombreUsuario, Email, Clave, IdRol) VALUES
('Administrador General', 'admin', 'admin@sistema.com', '12345', 1),
('Encuestador Principal', 'encuestador', 'encuestador@sistema.com', '12345', 2),
('Consultor Principal', 'consultor', 'consultor@sistema.com', '12345', 3);

INSERT INTO Genero (Nombre) VALUES
('Masculino'),
('Femenino'),
('Otro'),
('Prefiero no decirlo');

INSERT INTO NivelEducativo (Nombre) VALUES
('Primaria'),
('Secundaria'),
('Técnico'),
('Universitario'),
('Posgrado');

INSERT INTO RangoEdad (Minimo, Maximo, Descripcion) VALUES
(18, 25, '18 a 25 años'),
(26, 35, '26 a 35 años'),
(36, 45, '36 a 45 años'),
(46, 60, '46 a 60 años'),
(61, 100, 'Más de 60 años');

INSERT INTO RangoIngresos (Minimo, Maximo, Descripcion) VALUES
(0, 500, 'Menos de $500'),
(501, 1000, '$501 a $1000'),
(1001, 2000, '$1001 a $2000'),
(2001, 3000, '$2001 a $3000'),
(3001, NULL, 'Más de $3000');

INSERT INTO Ciudad (Nombre) VALUES
('San José'),
('Alajuela'),
('Cartago'),
('Heredia'),
('Guanacaste'),
('Puntarenas'),
('Limón');

INSERT INTO Ocupacion (Nombre) VALUES
('Estudiante'),
('Empleado privado'),
('Empleado público'),
('Independiente'),
('Empresario'),
('Desempleado'),
('Pensionado');

INSERT INTO TipoPrestamo (Nombre) VALUES
('Terreno'),
('Vehículo'),
('Estudios'),
('Personal'),
('Remodelación');

INSERT INTO Plazo (Meses) VALUES
(6),
(12),
(24),
(36),
(48),
(60);

INSERT INTO MontoRango (Minimo, Maximo, Descripcion) VALUES
(0, 5000, 'Menos de $5,000'),
(5000, 10000, '$5,000 a $10,000'),
(10001, 15000, '$10,001 a $15,000'),
(15001, NULL, 'Más de $15,000');

INSERT INTO TasaInteresRango (Minimo, Maximo, Descripcion) VALUES
(0, 5, 'Menos del 5%'),
(5, 10, '5% a 10%'),
(10, 15, '10% a 15%'),
(15, NULL, 'Más del 15%');

INSERT INTO CapacidadPago (Minimo, Maximo, Descripcion) VALUES
(0, 100, 'Menos de $100'),
(100, 300, '$100 a $300'),
(301, 500, '$301 a $500'),
(501, NULL, 'Más de $500');

INSERT INTO HistorialCrediticio (TienePrestamosPrevios, HaMorado, Descripcion) VALUES
(0, 0, 'No ha tenido préstamos previos'),
(1, 0, 'Ha tenido préstamos y no ha morado'),
(1, 1, 'Ha tenido préstamos y ha morado'),
(0, 1, 'No ha tenido préstamos, pero reporta morosidad');

INSERT INTO MedioContratacion (Nombre) VALUES
('Aplicación móvil'),
('Página web'),
('Sucursal física'),
('Llamada telefónica'),
('WhatsApp');

INSERT INTO MotivoRechazo (Descripcion) VALUES
('Ingresos insuficientes'),
('Historial crediticio negativo'),
('Documentación incompleta'),
('Capacidad de pago limitada'),
('Información inconsistente');

INSERT INTO CategoriaPregunta (Nombre, Descripcion) VALUES
('Datos generales', 'Información demográfica básica del encuestado'),
('Tipo de préstamo', 'Preferencias sobre la finalidad del préstamo'),
('Monto deseado', 'Rango monetario solicitado por el encuestado'),
('Plazo preferido', 'Tiempo de pago deseado'),
('Tasa aceptable', 'Interés anual que el encuestado estaría dispuesto a aceptar'),
('Capacidad de pago', 'Monto mensual disponible para pagar'),
('Historial crediticio', 'Comportamiento crediticio previo'),
('Medio de contratación', 'Canal preferido para contratar el préstamo');

INSERT INTO Pregunta (Texto, TipoControl, IdCategoria) VALUES
('¿Cuál es su nombre completo?', 'TextBox', 1),
('¿Cuál es su correo electrónico?', 'TextBox', 1),
('¿Cuál es su número de teléfono?', 'TextBox', 1),
('¿Cuál es su género?', 'RadioButtonList', 1),
('¿Cuál es su rango de edad?', 'DropDownList', 1),
('¿Cuál es su nivel educativo?', 'DropDownList', 1),
('¿Cuál es su rango de ingresos mensuales?', 'DropDownList', 1),
('¿En qué ciudad reside?', 'DropDownList', 1),
('¿Cuál es su ocupación actual?', 'DropDownList', 1),
('¿Qué tipo de préstamo desea solicitar?', 'DropDownList', 2),
('¿Cuál es el monto aproximado que desea solicitar?', 'DropDownList', 3),
('¿Cuál es el plazo que prefiere para pagar el préstamo?', 'DropDownList', 4),
('¿Qué tasa de interés anual considera aceptable?', 'DropDownList', 5),
('¿Cuánto podría pagar mensualmente?', 'DropDownList', 6),
('¿Ha tenido préstamos anteriormente?', 'RadioButtonList', 7),
('¿Ha presentado morosidad en algún préstamo anterior?', 'RadioButtonList', 7),
('¿Qué medio prefiere para contratar el préstamo?', 'CheckBoxList', 8),
('¿Solicitaría un préstamo si el trámite fuera completamente digital?', 'RadioButtonList', 8),
('¿Qué factor considera más importante al solicitar un préstamo?', 'DropDownList', 2),
('¿Desea agregar alguna observación adicional?', 'TextBox', 1);
GO

/* ============================================================
   8. TIPOS DE TABLA
============================================================ */

CREATE TYPE TipoRespuestaEncuesta AS TABLE
(
    IdPregunta INT NOT NULL,
    ValorTexto VARCHAR(300) NULL,
    ValorEntero INT NULL,
    ValorDecimal DECIMAL(12,2) NULL
);
GO

CREATE TYPE TipoMedioEncuesta AS TABLE
(
    IdMedio INT NOT NULL
);
GO

/* ============================================================
   9. PROCEDIMIENTOS GENERALES, SEGURIDAD Y AUDITORÍA
============================================================ */

CREATE OR ALTER PROCEDURE sp_LoginUsuario
    @NombreUsuario VARCHAR(50),
    @Clave VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        U.IdUsuario,
        U.Nombre,
        U.NombreUsuario,
        U.Email,
        R.IdRol,
        R.Nombre AS Rol
    FROM Usuario U
    INNER JOIN Rol R ON U.IdRol = R.IdRol
    WHERE 
        U.NombreUsuario = @NombreUsuario
        AND U.Clave = @Clave
        AND U.Activo = 1
        AND R.Activo = 1;
END;
GO

CREATE OR ALTER PROCEDURE sp_RegistrarAuditoria
    @NombreTabla VARCHAR(100),
    @IdRegistro INT,
    @Accion VARCHAR(50),
    @IdUsuario INT = NULL,
    @Detalle VARCHAR(500) = NULL,
    @ValorAnterior VARCHAR(MAX) = NULL,
    @ValorNuevo VARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Auditoria (
        NombreTabla,
        IdRegistro,
        Accion,
        IdUsuario,
        Detalle,
        ValorAnterior,
        ValorNuevo
    )
    VALUES (
        @NombreTabla,
        @IdRegistro,
        @Accion,
        @IdUsuario,
        @Detalle,
        @ValorAnterior,
        @ValorNuevo
    );
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarAuditoria
    @NombreTabla VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        A.IdAuditoria,
        A.NombreTabla,
        A.IdRegistro,
        A.Accion,
        A.IdUsuario,
        U.Nombre AS Usuario,
        A.Fecha,
        A.Detalle,
        A.ValorAnterior,
        A.ValorNuevo
    FROM Auditoria A
    LEFT JOIN Usuario U ON A.IdUsuario = U.IdUsuario
    WHERE 
        A.Activo = 1
        AND (@NombreTabla IS NULL OR A.NombreTabla = @NombreTabla)
    ORDER BY A.Fecha DESC;
END;
GO

CREATE OR ALTER PROCEDURE sp_ContarEncuestasCompletadas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT COUNT(*) AS TotalEncuestasCompletadas
    FROM Encuesta
    WHERE Activo = 1;
END;
GO

/* ============================================================
   10. CONSULTAS DE CATÁLOGOS PARA FORMULARIOS
============================================================ */

CREATE OR ALTER PROCEDURE sp_ConsultarGeneros
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdGenero, Nombre, Activo FROM Genero WHERE Activo = 1 ORDER BY Nombre;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarNivelesEducativos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdNivelEducativo, Nombre, Activo FROM NivelEducativo WHERE Activo = 1 ORDER BY Nombre;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarRangosEdad
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdRangoEdad, Minimo, Maximo, Descripcion, Activo FROM RangoEdad WHERE Activo = 1 ORDER BY Minimo;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarRangosIngresos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdRangoIngresos, Minimo, Maximo, Descripcion, Activo FROM RangoIngresos WHERE Activo = 1 ORDER BY Minimo;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarCiudades
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdCiudad, Nombre, Activo FROM Ciudad WHERE Activo = 1 ORDER BY Nombre;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarOcupaciones
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdOcupacion, Nombre, Activo FROM Ocupacion WHERE Activo = 1 ORDER BY Nombre;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarTiposPrestamo
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdTipoPrestamo, Nombre, Activo FROM TipoPrestamo WHERE Activo = 1 ORDER BY Nombre;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarPlazos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdPlazo, Meses, Activo FROM Plazo WHERE Activo = 1 ORDER BY Meses;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarMontosRango
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdMontoRango, Minimo, Maximo, Descripcion, Activo FROM MontoRango WHERE Activo = 1 ORDER BY Minimo;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarTasasInteresRango
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdTasaRango, Minimo, Maximo, Descripcion, Activo FROM TasaInteresRango WHERE Activo = 1 ORDER BY Minimo;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarCapacidadesPago
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdCapacidadPago, Minimo, Maximo, Descripcion, Activo FROM CapacidadPago WHERE Activo = 1 ORDER BY Minimo;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarHistorialesCrediticios
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdHistorial, TienePrestamosPrevios, HaMorado, Descripcion, Activo FROM HistorialCrediticio WHERE Activo = 1 ORDER BY IdHistorial;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarMediosContratacion
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdMedio, Nombre, Activo FROM MedioContratacion WHERE Activo = 1 ORDER BY Nombre;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarCategoriasPregunta
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdCategoria, Nombre, Descripcion, Activo FROM CategoriaPregunta WHERE Activo = 1 ORDER BY IdCategoria;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarPreguntas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        P.IdPregunta,
        P.Texto,
        P.TipoControl,
        P.IdCategoria,
        C.Nombre AS Categoria,
        P.Activo
    FROM Pregunta P
    INNER JOIN CategoriaPregunta C ON P.IdCategoria = C.IdCategoria
    WHERE P.Activo = 1
    ORDER BY P.IdPregunta;
END;
GO

/* ============================================================
   11. CRUD USUARIOS
============================================================ */

CREATE OR ALTER PROCEDURE sp_ConsultarUsuarios
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        U.IdUsuario,
        U.Nombre,
        U.NombreUsuario,
        U.Email,
        U.IdRol,
        R.Nombre AS Rol,
        U.Activo
    FROM Usuario U
    INNER JOIN Rol R ON U.IdRol = R.IdRol
    WHERE U.Activo = 1
    ORDER BY U.Nombre;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarUsuarioPorId
    @IdUsuario INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        U.IdUsuario,
        U.Nombre,
        U.NombreUsuario,
        U.Email,
        U.IdRol,
        R.Nombre AS Rol,
        U.Activo
    FROM Usuario U
    INNER JOIN Rol R ON U.IdRol = R.IdRol
    WHERE U.IdUsuario = @IdUsuario;
END;
GO





/* ============================================================
   12. PROCEDIMIENTOS DE ENCUESTA
============================================================ */




CREATE OR ALTER PROCEDURE sp_ConsultarEncuestaPorId
    @IdEncuesta INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        E.IdEncuesta,
        E.Fecha,
        E.IdCliente,
        C.Nombre AS Cliente,
        C.Email,
        C.Telefono,
        C.IdGenero,
        C.IdNivelEducativo,
        C.IdRangoIngresos,
        C.IdRangoEdad,
        C.IdCiudad,
        C.IdOcupacion,
        E.IdTipoPrestamo,
        E.IdPlazo,
        E.IdMontoRango,
        E.IdTasaRango,
        E.IdCapacidadPago,
        E.IdHistorial,
        E.IdUsuarioCreador,
        E.IdentificadorSesion,
        E.DireccionIP,
        E.Observacion,
        E.Activo
    FROM Encuesta E
    INNER JOIN Cliente C ON E.IdCliente = C.IdCliente
    WHERE E.IdEncuesta = @IdEncuesta
      AND E.Activo = 1;

    SELECT
        R.IdRespuesta,
        R.IdEncuesta,
        R.IdPregunta,
        P.Texto AS Pregunta,
        R.ValorTexto,
        R.ValorEntero,
        R.ValorDecimal
    FROM Respuesta R
    INNER JOIN Pregunta P ON R.IdPregunta = P.IdPregunta
    WHERE R.IdEncuesta = @IdEncuesta
      AND R.Activo = 1
    ORDER BY R.IdPregunta;

    SELECT
        EMC.IdEncuestaMedio,
        EMC.IdEncuesta,
        EMC.IdMedio,
        MC.Nombre AS MedioContratacion
    FROM EncuestaMedioContratacion EMC
    INNER JOIN MedioContratacion MC ON EMC.IdMedio = MC.IdMedio
    WHERE EMC.IdEncuesta = @IdEncuesta
      AND EMC.Activo = 1;
END;
GO



/* ============================================================
   13. CRUD DE CATÁLOGOS SIMPLES
============================================================ */

/* ============================================================
   CRUD GENERO
============================================================ */

CREATE OR ALTER PROCEDURE sp_InsertarGenero
    @Nombre VARCHAR(50),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Genero (Nombre) VALUES (@Nombre);
        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Genero',
            @IdRegistro = @NuevoId,
            @Accion = 'INSERT',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Creación de género',
            @ValorNuevo = @Nombre;

        COMMIT TRANSACTION;
        SELECT @NuevoId AS IdGenero, 'Género insertado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarGeneroPorId
    @IdGenero INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdGenero, Nombre, Activo
    FROM Genero
    WHERE IdGenero = @IdGenero;
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarGenero
    @IdGenero INT,
    @Nombre VARCHAR(50),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ValorAnterior VARCHAR(MAX);

        SELECT @ValorAnterior = Nombre
        FROM Genero
        WHERE IdGenero = @IdGenero;

        UPDATE Genero
        SET Nombre = @Nombre
        WHERE IdGenero = @IdGenero;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Genero',
            @IdRegistro = @IdGenero,
            @Accion = 'UPDATE',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Actualización de género',
            @ValorAnterior = @ValorAnterior,
            @ValorNuevo = @Nombre;

        COMMIT TRANSACTION;
        SELECT 'Género actualizado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarGeneroLogico
    @IdGenero INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Genero
        SET Activo = 0
        WHERE IdGenero = @IdGenero;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Genero',
            @IdRegistro = @IdGenero,
            @Accion = 'DELETE_LOGICO',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Eliminación lógica de género';

        COMMIT TRANSACTION;
        SELECT 'Género eliminado lógicamente correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarGenero
    @IdGenero INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Genero
        SET Activo = 1
        WHERE IdGenero = @IdGenero;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Genero',
            @IdRegistro = @IdGenero,
            @Accion = 'RESTAURAR',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Restauración de género';

        COMMIT TRANSACTION;
        SELECT 'Género restaurado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

/* ============================================================
   CRUD CIUDAD
============================================================ */

CREATE OR ALTER PROCEDURE sp_InsertarCiudad
    @Nombre VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Ciudad (Nombre) VALUES (@Nombre);
        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Ciudad',
            @IdRegistro = @NuevoId,
            @Accion = 'INSERT',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Creación de ciudad',
            @ValorNuevo = @Nombre;

        COMMIT TRANSACTION;
        SELECT @NuevoId AS IdCiudad, 'Ciudad insertado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarCiudadPorId
    @IdCiudad INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdCiudad, Nombre, Activo
    FROM Ciudad
    WHERE IdCiudad = @IdCiudad;
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarCiudad
    @IdCiudad INT,
    @Nombre VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ValorAnterior VARCHAR(MAX);

        SELECT @ValorAnterior = Nombre
        FROM Ciudad
        WHERE IdCiudad = @IdCiudad;

        UPDATE Ciudad
        SET Nombre = @Nombre
        WHERE IdCiudad = @IdCiudad;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Ciudad',
            @IdRegistro = @IdCiudad,
            @Accion = 'UPDATE',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Actualización de ciudad',
            @ValorAnterior = @ValorAnterior,
            @ValorNuevo = @Nombre;

        COMMIT TRANSACTION;
        SELECT 'Ciudad actualizado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarCiudadLogico
    @IdCiudad INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Ciudad
        SET Activo = 0
        WHERE IdCiudad = @IdCiudad;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Ciudad',
            @IdRegistro = @IdCiudad,
            @Accion = 'DELETE_LOGICO',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Eliminación lógica de ciudad';

        COMMIT TRANSACTION;
        SELECT 'Ciudad eliminado lógicamente correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarCiudad
    @IdCiudad INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Ciudad
        SET Activo = 1
        WHERE IdCiudad = @IdCiudad;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Ciudad',
            @IdRegistro = @IdCiudad,
            @Accion = 'RESTAURAR',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Restauración de ciudad';

        COMMIT TRANSACTION;
        SELECT 'Ciudad restaurado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

/* ============================================================
   CRUD OCUPACION
============================================================ */

CREATE OR ALTER PROCEDURE sp_InsertarOcupacion
    @Nombre VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Ocupacion (Nombre) VALUES (@Nombre);
        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Ocupacion',
            @IdRegistro = @NuevoId,
            @Accion = 'INSERT',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Creación de ocupación',
            @ValorNuevo = @Nombre;

        COMMIT TRANSACTION;
        SELECT @NuevoId AS IdOcupacion, 'Ocupación insertado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarOcupacionPorId
    @IdOcupacion INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdOcupacion, Nombre, Activo
    FROM Ocupacion
    WHERE IdOcupacion = @IdOcupacion;
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarOcupacion
    @IdOcupacion INT,
    @Nombre VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ValorAnterior VARCHAR(MAX);

        SELECT @ValorAnterior = Nombre
        FROM Ocupacion
        WHERE IdOcupacion = @IdOcupacion;

        UPDATE Ocupacion
        SET Nombre = @Nombre
        WHERE IdOcupacion = @IdOcupacion;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Ocupacion',
            @IdRegistro = @IdOcupacion,
            @Accion = 'UPDATE',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Actualización de ocupación',
            @ValorAnterior = @ValorAnterior,
            @ValorNuevo = @Nombre;

        COMMIT TRANSACTION;
        SELECT 'Ocupación actualizado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarOcupacionLogico
    @IdOcupacion INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Ocupacion
        SET Activo = 0
        WHERE IdOcupacion = @IdOcupacion;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Ocupacion',
            @IdRegistro = @IdOcupacion,
            @Accion = 'DELETE_LOGICO',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Eliminación lógica de ocupación';

        COMMIT TRANSACTION;
        SELECT 'Ocupación eliminado lógicamente correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarOcupacion
    @IdOcupacion INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Ocupacion
        SET Activo = 1
        WHERE IdOcupacion = @IdOcupacion;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Ocupacion',
            @IdRegistro = @IdOcupacion,
            @Accion = 'RESTAURAR',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Restauración de ocupación';

        COMMIT TRANSACTION;
        SELECT 'Ocupación restaurado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

/* ============================================================
   CRUD NIVELEDUCATIVO
============================================================ */

CREATE OR ALTER PROCEDURE sp_InsertarNivelEducativo
    @Nombre VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO NivelEducativo (Nombre) VALUES (@Nombre);
        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'NivelEducativo',
            @IdRegistro = @NuevoId,
            @Accion = 'INSERT',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Creación de nivel educativo',
            @ValorNuevo = @Nombre;

        COMMIT TRANSACTION;
        SELECT @NuevoId AS IdNivelEducativo, 'Nivel educativo insertado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarNivelEducativoPorId
    @IdNivelEducativo INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdNivelEducativo, Nombre, Activo
    FROM NivelEducativo
    WHERE IdNivelEducativo = @IdNivelEducativo;
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarNivelEducativo
    @IdNivelEducativo INT,
    @Nombre VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ValorAnterior VARCHAR(MAX);

        SELECT @ValorAnterior = Nombre
        FROM NivelEducativo
        WHERE IdNivelEducativo = @IdNivelEducativo;

        UPDATE NivelEducativo
        SET Nombre = @Nombre
        WHERE IdNivelEducativo = @IdNivelEducativo;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'NivelEducativo',
            @IdRegistro = @IdNivelEducativo,
            @Accion = 'UPDATE',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Actualización de nivel educativo',
            @ValorAnterior = @ValorAnterior,
            @ValorNuevo = @Nombre;

        COMMIT TRANSACTION;
        SELECT 'Nivel educativo actualizado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarNivelEducativoLogico
    @IdNivelEducativo INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE NivelEducativo
        SET Activo = 0
        WHERE IdNivelEducativo = @IdNivelEducativo;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'NivelEducativo',
            @IdRegistro = @IdNivelEducativo,
            @Accion = 'DELETE_LOGICO',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Eliminación lógica de nivel educativo';

        COMMIT TRANSACTION;
        SELECT 'Nivel educativo eliminado lógicamente correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarNivelEducativo
    @IdNivelEducativo INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE NivelEducativo
        SET Activo = 1
        WHERE IdNivelEducativo = @IdNivelEducativo;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'NivelEducativo',
            @IdRegistro = @IdNivelEducativo,
            @Accion = 'RESTAURAR',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Restauración de nivel educativo';

        COMMIT TRANSACTION;
        SELECT 'Nivel educativo restaurado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

/* ============================================================
   CRUD TIPOPRESTAMO
============================================================ */

CREATE OR ALTER PROCEDURE sp_InsertarTipoPrestamo
    @Nombre VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO TipoPrestamo (Nombre) VALUES (@Nombre);
        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'TipoPrestamo',
            @IdRegistro = @NuevoId,
            @Accion = 'INSERT',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Creación de tipo de préstamo',
            @ValorNuevo = @Nombre;

        COMMIT TRANSACTION;
        SELECT @NuevoId AS IdTipoPrestamo, 'Tipo de préstamo insertado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarTipoPrestamoPorId
    @IdTipoPrestamo INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdTipoPrestamo, Nombre, Activo
    FROM TipoPrestamo
    WHERE IdTipoPrestamo = @IdTipoPrestamo;
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarTipoPrestamo
    @IdTipoPrestamo INT,
    @Nombre VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ValorAnterior VARCHAR(MAX);

        SELECT @ValorAnterior = Nombre
        FROM TipoPrestamo
        WHERE IdTipoPrestamo = @IdTipoPrestamo;

        UPDATE TipoPrestamo
        SET Nombre = @Nombre
        WHERE IdTipoPrestamo = @IdTipoPrestamo;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'TipoPrestamo',
            @IdRegistro = @IdTipoPrestamo,
            @Accion = 'UPDATE',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Actualización de tipo de préstamo',
            @ValorAnterior = @ValorAnterior,
            @ValorNuevo = @Nombre;

        COMMIT TRANSACTION;
        SELECT 'Tipo de préstamo actualizado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarTipoPrestamoLogico
    @IdTipoPrestamo INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE TipoPrestamo
        SET Activo = 0
        WHERE IdTipoPrestamo = @IdTipoPrestamo;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'TipoPrestamo',
            @IdRegistro = @IdTipoPrestamo,
            @Accion = 'DELETE_LOGICO',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Eliminación lógica de tipo de préstamo';

        COMMIT TRANSACTION;
        SELECT 'Tipo de préstamo eliminado lógicamente correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarTipoPrestamo
    @IdTipoPrestamo INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE TipoPrestamo
        SET Activo = 1
        WHERE IdTipoPrestamo = @IdTipoPrestamo;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'TipoPrestamo',
            @IdRegistro = @IdTipoPrestamo,
            @Accion = 'RESTAURAR',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Restauración de tipo de préstamo';

        COMMIT TRANSACTION;
        SELECT 'Tipo de préstamo restaurado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

/* ============================================================
   CRUD MEDIOCONTRATACION
============================================================ */

CREATE OR ALTER PROCEDURE sp_InsertarMedioContratacion
    @Nombre VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO MedioContratacion (Nombre) VALUES (@Nombre);
        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'MedioContratacion',
            @IdRegistro = @NuevoId,
            @Accion = 'INSERT',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Creación de medio de contratación',
            @ValorNuevo = @Nombre;

        COMMIT TRANSACTION;
        SELECT @NuevoId AS IdMedio, 'Medio de contratación insertado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarMedioContratacionPorId
    @IdMedio INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdMedio, Nombre, Activo
    FROM MedioContratacion
    WHERE IdMedio = @IdMedio;
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarMedioContratacion
    @IdMedio INT,
    @Nombre VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ValorAnterior VARCHAR(MAX);

        SELECT @ValorAnterior = Nombre
        FROM MedioContratacion
        WHERE IdMedio = @IdMedio;

        UPDATE MedioContratacion
        SET Nombre = @Nombre
        WHERE IdMedio = @IdMedio;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'MedioContratacion',
            @IdRegistro = @IdMedio,
            @Accion = 'UPDATE',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Actualización de medio de contratación',
            @ValorAnterior = @ValorAnterior,
            @ValorNuevo = @Nombre;

        COMMIT TRANSACTION;
        SELECT 'Medio de contratación actualizado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarMedioContratacionLogico
    @IdMedio INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE MedioContratacion
        SET Activo = 0
        WHERE IdMedio = @IdMedio;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'MedioContratacion',
            @IdRegistro = @IdMedio,
            @Accion = 'DELETE_LOGICO',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Eliminación lógica de medio de contratación';

        COMMIT TRANSACTION;
        SELECT 'Medio de contratación eliminado lógicamente correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarMedioContratacion
    @IdMedio INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE MedioContratacion
        SET Activo = 1
        WHERE IdMedio = @IdMedio;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'MedioContratacion',
            @IdRegistro = @IdMedio,
            @Accion = 'RESTAURAR',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Restauración de medio de contratación';

        COMMIT TRANSACTION;
        SELECT 'Medio de contratación restaurado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

/* ============================================================
   14. CRUD DE CATÁLOGOS CON DESCRIPCIÓN
============================================================ */

CREATE OR ALTER PROCEDURE sp_InsertarMotivoRechazo
    @Descripcion VARCHAR(200),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO MotivoRechazo (Descripcion) VALUES (@Descripcion);
        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria 'MotivoRechazo', @NuevoId, 'INSERT', @IdUsuarioAuditoria, 'Creación de motivo de rechazo', NULL, @Descripcion;

        COMMIT TRANSACTION;
        SELECT @NuevoId AS IdMotivoRechazo, 'Motivo de rechazo insertado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarMotivoRechazoPorId
    @IdMotivoRechazo INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdMotivoRechazo, Descripcion, Activo
    FROM MotivoRechazo
    WHERE IdMotivoRechazo = @IdMotivoRechazo;
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarMotivoRechazo
    @IdMotivoRechazo INT,
    @Descripcion VARCHAR(200),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ValorAnterior VARCHAR(MAX);

        SELECT @ValorAnterior = Descripcion
        FROM MotivoRechazo
        WHERE IdMotivoRechazo = @IdMotivoRechazo;

        UPDATE MotivoRechazo
        SET Descripcion = @Descripcion
        WHERE IdMotivoRechazo = @IdMotivoRechazo;

        EXEC sp_RegistrarAuditoria 'MotivoRechazo', @IdMotivoRechazo, 'UPDATE', @IdUsuarioAuditoria, 'Actualización de motivo de rechazo', @ValorAnterior, @Descripcion;

        COMMIT TRANSACTION;
        SELECT 'Motivo de rechazo actualizado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarMotivoRechazoLogico
    @IdMotivoRechazo INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE MotivoRechazo
        SET Activo = 0
        WHERE IdMotivoRechazo = @IdMotivoRechazo;

        EXEC sp_RegistrarAuditoria 'MotivoRechazo', @IdMotivoRechazo, 'DELETE_LOGICO', @IdUsuarioAuditoria, 'Eliminación lógica de motivo de rechazo', NULL, NULL;

        COMMIT TRANSACTION;
        SELECT 'Motivo de rechazo eliminado lógicamente correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarMotivoRechazo
    @IdMotivoRechazo INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE MotivoRechazo
        SET Activo = 1
        WHERE IdMotivoRechazo = @IdMotivoRechazo;

        EXEC sp_RegistrarAuditoria 'MotivoRechazo', @IdMotivoRechazo, 'RESTAURAR', @IdUsuarioAuditoria, 'Restauración de motivo de rechazo', NULL, NULL;

        COMMIT TRANSACTION;
        SELECT 'Motivo de rechazo restaurado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

/* ============================================================
   15. CRUD PLAZO
============================================================ */

CREATE OR ALTER PROCEDURE sp_InsertarPlazo
    @Meses INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Plazo (Meses) VALUES (@Meses);
        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria 'Plazo', @NuevoId, 'INSERT', @IdUsuarioAuditoria, 'Creación de plazo', NULL, @Meses;

        COMMIT TRANSACTION;
        SELECT @NuevoId AS IdPlazo, 'Plazo insertado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarPlazoPorId
    @IdPlazo INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdPlazo, Meses, Activo
    FROM Plazo
    WHERE IdPlazo = @IdPlazo;
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarPlazo
    @IdPlazo INT,
    @Meses INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ValorAnterior VARCHAR(MAX);

        SELECT @ValorAnterior = CAST(Meses AS VARCHAR(20))
        FROM Plazo
        WHERE IdPlazo = @IdPlazo;

        UPDATE Plazo
        SET Meses = @Meses
        WHERE IdPlazo = @IdPlazo;

        EXEC sp_RegistrarAuditoria 'Plazo', @IdPlazo, 'UPDATE', @IdUsuarioAuditoria, 'Actualización de plazo', @ValorAnterior, @Meses;

        COMMIT TRANSACTION;
        SELECT 'Plazo actualizado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarPlazoLogico
    @IdPlazo INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Plazo
        SET Activo = 0
        WHERE IdPlazo = @IdPlazo;

        EXEC sp_RegistrarAuditoria 'Plazo', @IdPlazo, 'DELETE_LOGICO', @IdUsuarioAuditoria, 'Eliminación lógica de plazo', NULL, NULL;

        COMMIT TRANSACTION;
        SELECT 'Plazo eliminado lógicamente correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarPlazo
    @IdPlazo INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Plazo
        SET Activo = 1
        WHERE IdPlazo = @IdPlazo;

        EXEC sp_RegistrarAuditoria 'Plazo', @IdPlazo, 'RESTAURAR', @IdUsuarioAuditoria, 'Restauración de plazo', NULL, NULL;

        COMMIT TRANSACTION;
        SELECT 'Plazo restaurado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

/* ============================================================
   16. CRUD DE CATÁLOGOS CON RANGOS
============================================================ */

/* ============================================================
   CRUD RANGOINGRESOS
============================================================ */

CREATE OR ALTER PROCEDURE sp_InsertarRangoIngresos
    @Minimo DECIMAL(10,2),
    @Maximo DECIMAL(10,2) = NULL,
    @Descripcion VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO RangoIngresos (Minimo, Maximo, Descripcion)
        VALUES (@Minimo, @Maximo, @Descripcion);

        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'RangoIngresos',
            @IdRegistro = @NuevoId,
            @Accion = 'INSERT',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Creación de rango de ingresos',
            @ValorNuevo = @Descripcion;

        COMMIT TRANSACTION;
        SELECT @NuevoId AS IdRangoIngresos, 'Rango de ingresos insertado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarRangoIngresosPorId
    @IdRangoIngresos INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdRangoIngresos, Minimo, Maximo, Descripcion, Activo
    FROM RangoIngresos
    WHERE IdRangoIngresos = @IdRangoIngresos;
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarRangoIngresos
    @IdRangoIngresos INT,
    @Minimo DECIMAL(10,2),
    @Maximo DECIMAL(10,2) = NULL,
    @Descripcion VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ValorAnterior VARCHAR(MAX);

        SELECT @ValorAnterior = Descripcion
        FROM RangoIngresos
        WHERE IdRangoIngresos = @IdRangoIngresos;

        UPDATE RangoIngresos
        SET Minimo = @Minimo,
            Maximo = @Maximo,
            Descripcion = @Descripcion
        WHERE IdRangoIngresos = @IdRangoIngresos;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'RangoIngresos',
            @IdRegistro = @IdRangoIngresos,
            @Accion = 'UPDATE',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Actualización de rango de ingresos',
            @ValorAnterior = @ValorAnterior,
            @ValorNuevo = @Descripcion;

        COMMIT TRANSACTION;
        SELECT 'Rango de ingresos actualizado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarRangoIngresosLogico
    @IdRangoIngresos INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE RangoIngresos
        SET Activo = 0
        WHERE IdRangoIngresos = @IdRangoIngresos;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'RangoIngresos',
            @IdRegistro = @IdRangoIngresos,
            @Accion = 'DELETE_LOGICO',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Eliminación lógica de rango de ingresos';

        COMMIT TRANSACTION;
        SELECT 'Rango de ingresos eliminado lógicamente correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarRangoIngresos
    @IdRangoIngresos INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE RangoIngresos
        SET Activo = 1
        WHERE IdRangoIngresos = @IdRangoIngresos;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'RangoIngresos',
            @IdRegistro = @IdRangoIngresos,
            @Accion = 'RESTAURAR',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Restauración de rango de ingresos';

        COMMIT TRANSACTION;
        SELECT 'Rango de ingresos restaurado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

/* ============================================================
   CRUD MONTORANGO
============================================================ */

CREATE OR ALTER PROCEDURE sp_InsertarMontoRango
    @Minimo DECIMAL(12,2),
    @Maximo DECIMAL(12,2) = NULL,
    @Descripcion VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO MontoRango (Minimo, Maximo, Descripcion)
        VALUES (@Minimo, @Maximo, @Descripcion);

        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'MontoRango',
            @IdRegistro = @NuevoId,
            @Accion = 'INSERT',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Creación de rango de monto',
            @ValorNuevo = @Descripcion;

        COMMIT TRANSACTION;
        SELECT @NuevoId AS IdMontoRango, 'Rango de monto insertado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarMontoRangoPorId
    @IdMontoRango INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdMontoRango, Minimo, Maximo, Descripcion, Activo
    FROM MontoRango
    WHERE IdMontoRango = @IdMontoRango;
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarMontoRango
    @IdMontoRango INT,
    @Minimo DECIMAL(12,2),
    @Maximo DECIMAL(12,2) = NULL,
    @Descripcion VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ValorAnterior VARCHAR(MAX);

        SELECT @ValorAnterior = Descripcion
        FROM MontoRango
        WHERE IdMontoRango = @IdMontoRango;

        UPDATE MontoRango
        SET Minimo = @Minimo,
            Maximo = @Maximo,
            Descripcion = @Descripcion
        WHERE IdMontoRango = @IdMontoRango;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'MontoRango',
            @IdRegistro = @IdMontoRango,
            @Accion = 'UPDATE',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Actualización de rango de monto',
            @ValorAnterior = @ValorAnterior,
            @ValorNuevo = @Descripcion;

        COMMIT TRANSACTION;
        SELECT 'Rango de monto actualizado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarMontoRangoLogico
    @IdMontoRango INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE MontoRango
        SET Activo = 0
        WHERE IdMontoRango = @IdMontoRango;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'MontoRango',
            @IdRegistro = @IdMontoRango,
            @Accion = 'DELETE_LOGICO',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Eliminación lógica de rango de monto';

        COMMIT TRANSACTION;
        SELECT 'Rango de monto eliminado lógicamente correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarMontoRango
    @IdMontoRango INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE MontoRango
        SET Activo = 1
        WHERE IdMontoRango = @IdMontoRango;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'MontoRango',
            @IdRegistro = @IdMontoRango,
            @Accion = 'RESTAURAR',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Restauración de rango de monto';

        COMMIT TRANSACTION;
        SELECT 'Rango de monto restaurado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

/* ============================================================
   CRUD TASAINTERESRANGO
============================================================ */

CREATE OR ALTER PROCEDURE sp_InsertarTasaInteresRango
    @Minimo DECIMAL(5,2),
    @Maximo DECIMAL(5,2) = NULL,
    @Descripcion VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO TasaInteresRango (Minimo, Maximo, Descripcion)
        VALUES (@Minimo, @Maximo, @Descripcion);

        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'TasaInteresRango',
            @IdRegistro = @NuevoId,
            @Accion = 'INSERT',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Creación de rango de tasa',
            @ValorNuevo = @Descripcion;

        COMMIT TRANSACTION;
        SELECT @NuevoId AS IdTasaRango, 'Rango de tasa insertado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarTasaInteresRangoPorId
    @IdTasaRango INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdTasaRango, Minimo, Maximo, Descripcion, Activo
    FROM TasaInteresRango
    WHERE IdTasaRango = @IdTasaRango;
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarTasaInteresRango
    @IdTasaRango INT,
    @Minimo DECIMAL(5,2),
    @Maximo DECIMAL(5,2) = NULL,
    @Descripcion VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ValorAnterior VARCHAR(MAX);

        SELECT @ValorAnterior = Descripcion
        FROM TasaInteresRango
        WHERE IdTasaRango = @IdTasaRango;

        UPDATE TasaInteresRango
        SET Minimo = @Minimo,
            Maximo = @Maximo,
            Descripcion = @Descripcion
        WHERE IdTasaRango = @IdTasaRango;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'TasaInteresRango',
            @IdRegistro = @IdTasaRango,
            @Accion = 'UPDATE',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Actualización de rango de tasa',
            @ValorAnterior = @ValorAnterior,
            @ValorNuevo = @Descripcion;

        COMMIT TRANSACTION;
        SELECT 'Rango de tasa actualizado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarTasaInteresRangoLogico
    @IdTasaRango INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE TasaInteresRango
        SET Activo = 0
        WHERE IdTasaRango = @IdTasaRango;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'TasaInteresRango',
            @IdRegistro = @IdTasaRango,
            @Accion = 'DELETE_LOGICO',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Eliminación lógica de rango de tasa';

        COMMIT TRANSACTION;
        SELECT 'Rango de tasa eliminado lógicamente correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarTasaInteresRango
    @IdTasaRango INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE TasaInteresRango
        SET Activo = 1
        WHERE IdTasaRango = @IdTasaRango;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'TasaInteresRango',
            @IdRegistro = @IdTasaRango,
            @Accion = 'RESTAURAR',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Restauración de rango de tasa';

        COMMIT TRANSACTION;
        SELECT 'Rango de tasa restaurado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

/* ============================================================
   CRUD CAPACIDADPAGO
============================================================ */

CREATE OR ALTER PROCEDURE sp_InsertarCapacidadPago
    @Minimo DECIMAL(10,2),
    @Maximo DECIMAL(10,2) = NULL,
    @Descripcion VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO CapacidadPago (Minimo, Maximo, Descripcion)
        VALUES (@Minimo, @Maximo, @Descripcion);

        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'CapacidadPago',
            @IdRegistro = @NuevoId,
            @Accion = 'INSERT',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Creación de capacidad de pago',
            @ValorNuevo = @Descripcion;

        COMMIT TRANSACTION;
        SELECT @NuevoId AS IdCapacidadPago, 'Capacidad de pago insertado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarCapacidadPagoPorId
    @IdCapacidadPago INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdCapacidadPago, Minimo, Maximo, Descripcion, Activo
    FROM CapacidadPago
    WHERE IdCapacidadPago = @IdCapacidadPago;
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarCapacidadPago
    @IdCapacidadPago INT,
    @Minimo DECIMAL(10,2),
    @Maximo DECIMAL(10,2) = NULL,
    @Descripcion VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ValorAnterior VARCHAR(MAX);

        SELECT @ValorAnterior = Descripcion
        FROM CapacidadPago
        WHERE IdCapacidadPago = @IdCapacidadPago;

        UPDATE CapacidadPago
        SET Minimo = @Minimo,
            Maximo = @Maximo,
            Descripcion = @Descripcion
        WHERE IdCapacidadPago = @IdCapacidadPago;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'CapacidadPago',
            @IdRegistro = @IdCapacidadPago,
            @Accion = 'UPDATE',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Actualización de capacidad de pago',
            @ValorAnterior = @ValorAnterior,
            @ValorNuevo = @Descripcion;

        COMMIT TRANSACTION;
        SELECT 'Capacidad de pago actualizado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarCapacidadPagoLogico
    @IdCapacidadPago INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE CapacidadPago
        SET Activo = 0
        WHERE IdCapacidadPago = @IdCapacidadPago;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'CapacidadPago',
            @IdRegistro = @IdCapacidadPago,
            @Accion = 'DELETE_LOGICO',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Eliminación lógica de capacidad de pago';

        COMMIT TRANSACTION;
        SELECT 'Capacidad de pago eliminado lógicamente correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarCapacidadPago
    @IdCapacidadPago INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE CapacidadPago
        SET Activo = 1
        WHERE IdCapacidadPago = @IdCapacidadPago;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'CapacidadPago',
            @IdRegistro = @IdCapacidadPago,
            @Accion = 'RESTAURAR',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Restauración de capacidad de pago';

        COMMIT TRANSACTION;
        SELECT 'Capacidad de pago restaurado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

/* ============================================================
   CRUD RANGO EDAD
============================================================ */

CREATE OR ALTER PROCEDURE sp_InsertarRangoEdad
    @Minimo INT,
    @Maximo INT,
    @Descripcion VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO RangoEdad (Minimo, Maximo, Descripcion)
        VALUES (@Minimo, @Maximo, @Descripcion);

        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria 'RangoEdad', @NuevoId, 'INSERT', @IdUsuarioAuditoria, 'Creación de rango de edad', NULL, @Descripcion;

        COMMIT TRANSACTION;
        SELECT @NuevoId AS IdRangoEdad, 'Rango de edad insertado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarRangoEdadPorId
    @IdRangoEdad INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdRangoEdad, Minimo, Maximo, Descripcion, Activo
    FROM RangoEdad
    WHERE IdRangoEdad = @IdRangoEdad;
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarRangoEdad
    @IdRangoEdad INT,
    @Minimo INT,
    @Maximo INT,
    @Descripcion VARCHAR(100),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ValorAnterior VARCHAR(MAX);

        SELECT @ValorAnterior = Descripcion
        FROM RangoEdad
        WHERE IdRangoEdad = @IdRangoEdad;

        UPDATE RangoEdad
        SET Minimo = @Minimo,
            Maximo = @Maximo,
            Descripcion = @Descripcion
        WHERE IdRangoEdad = @IdRangoEdad;

        EXEC sp_RegistrarAuditoria 'RangoEdad', @IdRangoEdad, 'UPDATE', @IdUsuarioAuditoria, 'Actualización de rango de edad', @ValorAnterior, @Descripcion;

        COMMIT TRANSACTION;
        SELECT 'Rango de edad actualizado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarRangoEdadLogico
    @IdRangoEdad INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE RangoEdad
        SET Activo = 0
        WHERE IdRangoEdad = @IdRangoEdad;

        EXEC sp_RegistrarAuditoria 'RangoEdad', @IdRangoEdad, 'DELETE_LOGICO', @IdUsuarioAuditoria, 'Eliminación lógica de rango de edad', NULL, NULL;

        COMMIT TRANSACTION;
        SELECT 'Rango de edad eliminado lógicamente correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarRangoEdad
    @IdRangoEdad INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE RangoEdad
        SET Activo = 1
        WHERE IdRangoEdad = @IdRangoEdad;

        EXEC sp_RegistrarAuditoria 'RangoEdad', @IdRangoEdad, 'RESTAURAR', @IdUsuarioAuditoria, 'Restauración de rango de edad', NULL, NULL;

        COMMIT TRANSACTION;
        SELECT 'Rango de edad restaurado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

/* ============================================================
   17. CRUD HISTORIAL CREDITICIO, CATEGORÍAS Y PREGUNTAS
============================================================ */

CREATE OR ALTER PROCEDURE sp_InsertarHistorialCrediticio
    @TienePrestamosPrevios BIT,
    @HaMorado BIT,
    @Descripcion VARCHAR(150),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO HistorialCrediticio (TienePrestamosPrevios, HaMorado, Descripcion)
        VALUES (@TienePrestamosPrevios, @HaMorado, @Descripcion);

        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria 'HistorialCrediticio', @NuevoId, 'INSERT', @IdUsuarioAuditoria, 'Creación de historial crediticio', NULL, @Descripcion;

        COMMIT TRANSACTION;
        SELECT @NuevoId AS IdHistorial, 'Historial crediticio insertado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarHistorialCrediticioPorId
    @IdHistorial INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdHistorial, TienePrestamosPrevios, HaMorado, Descripcion, Activo
    FROM HistorialCrediticio
    WHERE IdHistorial = @IdHistorial;
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarHistorialCrediticio
    @IdHistorial INT,
    @TienePrestamosPrevios BIT,
    @HaMorado BIT,
    @Descripcion VARCHAR(150),
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ValorAnterior VARCHAR(MAX);

        SELECT @ValorAnterior = Descripcion
        FROM HistorialCrediticio
        WHERE IdHistorial = @IdHistorial;

        UPDATE HistorialCrediticio
        SET TienePrestamosPrevios = @TienePrestamosPrevios,
            HaMorado = @HaMorado,
            Descripcion = @Descripcion
        WHERE IdHistorial = @IdHistorial;

        EXEC sp_RegistrarAuditoria 'HistorialCrediticio', @IdHistorial, 'UPDATE', @IdUsuarioAuditoria, 'Actualización de historial crediticio', @ValorAnterior, @Descripcion;

        COMMIT TRANSACTION;
        SELECT 'Historial crediticio actualizado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarHistorialCrediticioLogico
    @IdHistorial INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE HistorialCrediticio
        SET Activo = 0
        WHERE IdHistorial = @IdHistorial;

        EXEC sp_RegistrarAuditoria 'HistorialCrediticio', @IdHistorial, 'DELETE_LOGICO', @IdUsuarioAuditoria, 'Eliminación lógica de historial crediticio', NULL, NULL;

        COMMIT TRANSACTION;
        SELECT 'Historial crediticio eliminado lógicamente correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarHistorialCrediticio
    @IdHistorial INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE HistorialCrediticio
        SET Activo = 1
        WHERE IdHistorial = @IdHistorial;

        EXEC sp_RegistrarAuditoria 'HistorialCrediticio', @IdHistorial, 'RESTAURAR', @IdUsuarioAuditoria, 'Restauración de historial crediticio', NULL, NULL;

        COMMIT TRANSACTION;
        SELECT 'Historial crediticio restaurado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_InsertarCategoriaPregunta
    @Nombre VARCHAR(100),
    @Descripcion VARCHAR(250) = NULL,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO CategoriaPregunta (Nombre, Descripcion)
        VALUES (@Nombre, @Descripcion);

        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria 'CategoriaPregunta', @NuevoId, 'INSERT', @IdUsuarioAuditoria, 'Creación de categoría de pregunta', NULL, @Nombre;

        COMMIT TRANSACTION;
        SELECT @NuevoId AS IdCategoria, 'Categoría insertada correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarCategoriaPreguntaPorId
    @IdCategoria INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdCategoria, Nombre, Descripcion, Activo
    FROM CategoriaPregunta
    WHERE IdCategoria = @IdCategoria;
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarCategoriaPregunta
    @IdCategoria INT,
    @Nombre VARCHAR(100),
    @Descripcion VARCHAR(250) = NULL,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ValorAnterior VARCHAR(MAX);

        SELECT @ValorAnterior = Nombre
        FROM CategoriaPregunta
        WHERE IdCategoria = @IdCategoria;

        UPDATE CategoriaPregunta
        SET Nombre = @Nombre,
            Descripcion = @Descripcion
        WHERE IdCategoria = @IdCategoria;

        EXEC sp_RegistrarAuditoria 'CategoriaPregunta', @IdCategoria, 'UPDATE', @IdUsuarioAuditoria, 'Actualización de categoría de pregunta', @ValorAnterior, @Nombre;

        COMMIT TRANSACTION;
        SELECT 'Categoría actualizada correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarCategoriaPreguntaLogico
    @IdCategoria INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE CategoriaPregunta
        SET Activo = 0
        WHERE IdCategoria = @IdCategoria;

        EXEC sp_RegistrarAuditoria 'CategoriaPregunta', @IdCategoria, 'DELETE_LOGICO', @IdUsuarioAuditoria, 'Eliminación lógica de categoría de pregunta', NULL, NULL;

        COMMIT TRANSACTION;
        SELECT 'Categoría eliminada lógicamente correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarCategoriaPregunta
    @IdCategoria INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE CategoriaPregunta
        SET Activo = 1
        WHERE IdCategoria = @IdCategoria;

        EXEC sp_RegistrarAuditoria 'CategoriaPregunta', @IdCategoria, 'RESTAURAR', @IdUsuarioAuditoria, 'Restauración de categoría de pregunta', NULL, NULL;

        COMMIT TRANSACTION;
        SELECT 'Categoría restaurada correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_InsertarPregunta
    @Texto VARCHAR(300),
    @TipoControl VARCHAR(50),
    @IdCategoria INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Pregunta (Texto, TipoControl, IdCategoria)
        VALUES (@Texto, @TipoControl, @IdCategoria);

        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria 'Pregunta', @NuevoId, 'INSERT', @IdUsuarioAuditoria, 'Creación de pregunta', NULL, @Texto;

        COMMIT TRANSACTION;
        SELECT @NuevoId AS IdPregunta, 'Pregunta insertada correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarPreguntaPorId
    @IdPregunta INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdPregunta, Texto, TipoControl, IdCategoria, Activo
    FROM Pregunta
    WHERE IdPregunta = @IdPregunta;
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarPregunta
    @IdPregunta INT,
    @Texto VARCHAR(300),
    @TipoControl VARCHAR(50),
    @IdCategoria INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ValorAnterior VARCHAR(MAX);

        SELECT @ValorAnterior = Texto
        FROM Pregunta
        WHERE IdPregunta = @IdPregunta;

        UPDATE Pregunta
        SET Texto = @Texto,
            TipoControl = @TipoControl,
            IdCategoria = @IdCategoria
        WHERE IdPregunta = @IdPregunta;

        EXEC sp_RegistrarAuditoria 'Pregunta', @IdPregunta, 'UPDATE', @IdUsuarioAuditoria, 'Actualización de pregunta', @ValorAnterior, @Texto;

        COMMIT TRANSACTION;
        SELECT 'Pregunta actualizada correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarPreguntaLogico
    @IdPregunta INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Pregunta
        SET Activo = 0
        WHERE IdPregunta = @IdPregunta;

        EXEC sp_RegistrarAuditoria 'Pregunta', @IdPregunta, 'DELETE_LOGICO', @IdUsuarioAuditoria, 'Eliminación lógica de pregunta', NULL, NULL;

        COMMIT TRANSACTION;
        SELECT 'Pregunta eliminada lógicamente correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarPregunta
    @IdPregunta INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Pregunta
        SET Activo = 1
        WHERE IdPregunta = @IdPregunta;

        EXEC sp_RegistrarAuditoria 'Pregunta', @IdPregunta, 'RESTAURAR', @IdUsuarioAuditoria, 'Restauración de pregunta', NULL, NULL;

        COMMIT TRANSACTION;
        SELECT 'Pregunta restaurada correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumero, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH
END;
GO
/* ============================================================
   18. Roles
============================================================ */
CREATE OR ALTER PROCEDURE sp_ConsultarRoles
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdRol,
        Nombre,
        Activo
    FROM Rol
    WHERE Activo = 1
    ORDER BY Nombre;
END
GO

/* ============================================================
   19. Usuario CRUD
============================================================ */

CREATE OR ALTER PROCEDURE sp_ConsultarUsuarios
AS
BEGIN
    SELECT 
        u.IdUsuario,
        u.Nombre,
        u.NombreUsuario,
        u.Email,
        u.IdRol,
        r.Nombre AS Rol,
        u.Activo
    FROM Usuario u
    INNER JOIN Rol r ON u.IdRol = r.IdRol
    WHERE u.Activo = 1
    ORDER BY u.Nombre;
END
GO





/* ============================================================
   20. REPORTES 01 AL 30
============================================================ */

-- REPORTE 01: Tipo de préstamo más solicitado por rango de edad
CREATE OR ALTER PROCEDURE sp_ReportePregunta01
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        RE.Descripcion AS RangoEdad,
        TP.Nombre AS TipoPrestamo,
        COUNT(*) AS Cantidad
    FROM Encuesta E
    INNER JOIN Cliente C ON E.IdCliente = C.IdCliente
    INNER JOIN RangoEdad RE ON C.IdRangoEdad = RE.IdRangoEdad
    INNER JOIN TipoPrestamo TP ON E.IdTipoPrestamo = TP.IdTipoPrestamo
    WHERE E.Activo = 1
    GROUP BY RE.Descripcion, TP.Nombre
    ORDER BY RE.Descripcion, Cantidad DESC;
END;
GO

-- REPORTE 02: Plazo más frecuente entre quienes ganan más de $2000
CREATE OR ALTER PROCEDURE sp_ReportePregunta02
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        P.Meses AS PlazoMeses,
        COUNT(*) AS Cantidad
    FROM Encuesta E
    INNER JOIN Cliente C ON E.IdCliente = C.IdCliente
    INNER JOIN RangoIngresos RI ON C.IdRangoIngresos = RI.IdRangoIngresos
    INNER JOIN Plazo P ON E.IdPlazo = P.IdPlazo
    WHERE E.Activo = 1
      AND RI.Minimo > 2000
    GROUP BY P.Meses
    ORDER BY Cantidad DESC;
END;
GO

-- REPORTE 03: Porcentaje que prefiere plazos mayores a 36 meses
CREATE OR ALTER PROCEDURE sp_ReportePregunta03
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        CAST(
            SUM(CASE WHEN P.Meses > 36 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0)
            AS DECIMAL(5,2)
        ) AS PorcentajePlazosMayores36
    FROM Encuesta E
    INNER JOIN Plazo P ON E.IdPlazo = P.IdPlazo
    WHERE E.Activo = 1;
END;
GO

-- REPORTE 04: Monto promedio solicitado por tipo de préstamo
CREATE OR ALTER PROCEDURE sp_ReportePregunta04
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        TP.Nombre AS TipoPrestamo,
        AVG((MR.Minimo + ISNULL(MR.Maximo, MR.Minimo)) / 2) AS MontoPromedioEstimado
    FROM Encuesta E
    INNER JOIN TipoPrestamo TP ON E.IdTipoPrestamo = TP.IdTipoPrestamo
    INNER JOIN MontoRango MR ON E.IdMontoRango = MR.IdMontoRango
    WHERE E.Activo = 1
    GROUP BY TP.Nombre
    ORDER BY MontoPromedioEstimado DESC;
END;
GO

-- REPORTE 05: Personas con ingresos bajos que aceptarían tasa mayor a 10%
CREATE OR ALTER PROCEDURE sp_ReportePregunta05
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        RI.Descripcion AS RangoIngresos,
        TR.Descripcion AS TasaAceptada,
        COUNT(*) AS Cantidad
    FROM Encuesta E
    INNER JOIN Cliente C ON E.IdCliente = C.IdCliente
    INNER JOIN RangoIngresos RI ON C.IdRangoIngresos = RI.IdRangoIngresos
    INNER JOIN TasaInteresRango TR ON E.IdTasaRango = TR.IdTasaRango
    WHERE E.Activo = 1
      AND RI.Maximo <= 1000
      AND TR.Minimo > 10
    GROUP BY RI.Descripcion, TR.Descripcion;
END;
GO

-- REPORTE 06: Relación entre nivel educativo y préstamo para estudios
CREATE OR ALTER PROCEDURE sp_ReportePregunta06
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        NE.Nombre AS NivelEducativo,
        TP.Nombre AS TipoPrestamo,
        COUNT(*) AS Cantidad
    FROM Encuesta E
    INNER JOIN Cliente C ON E.IdCliente = C.IdCliente
    INNER JOIN NivelEducativo NE ON C.IdNivelEducativo = NE.IdNivelEducativo
    INNER JOIN TipoPrestamo TP ON E.IdTipoPrestamo = TP.IdTipoPrestamo
    WHERE E.Activo = 1
      AND TP.Nombre = 'Estudios'
    GROUP BY NE.Nombre, TP.Nombre
    ORDER BY Cantidad DESC;
END;
GO

-- REPORTE 07: Medio de contratación preferido por jóvenes 18-25
CREATE OR ALTER PROCEDURE sp_ReportePregunta07
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        MC.Nombre AS MedioContratacion,
        COUNT(*) AS Cantidad
    FROM Encuesta E
    INNER JOIN Cliente C ON E.IdCliente = C.IdCliente
    INNER JOIN RangoEdad RE ON C.IdRangoEdad = RE.IdRangoEdad
    INNER JOIN EncuestaMedioContratacion EMC ON E.IdEncuesta = EMC.IdEncuesta
    INNER JOIN MedioContratacion MC ON EMC.IdMedio = MC.IdMedio
    WHERE E.Activo = 1
      AND EMC.Activo = 1
      AND RE.Minimo = 18
      AND RE.Maximo = 25
    GROUP BY MC.Nombre
    ORDER BY Cantidad DESC;
END;
GO

-- REPORTE 08: Encuestados con morosidad que aún solicitan préstamos
CREATE OR ALTER PROCEDURE sp_ReportePregunta08
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        HC.Descripcion AS HistorialCrediticio,
        COUNT(*) AS Cantidad
    FROM Encuesta E
    INNER JOIN HistorialCrediticio HC ON E.IdHistorial = HC.IdHistorial
    WHERE E.Activo = 1
      AND HC.HaMorado = 1
    GROUP BY HC.Descripcion;
END;
GO

-- REPORTE 09: Capacidad de pago promedio por rango de edad
CREATE OR ALTER PROCEDURE sp_ReportePregunta09
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        RE.Descripcion AS RangoEdad,
        AVG((CP.Minimo + ISNULL(CP.Maximo, CP.Minimo)) / 2) AS CapacidadPagoPromedio
    FROM Encuesta E
    INNER JOIN Cliente C ON E.IdCliente = C.IdCliente
    INNER JOIN RangoEdad RE ON C.IdRangoEdad = RE.IdRangoEdad
    INNER JOIN CapacidadPago CP ON E.IdCapacidadPago = CP.IdCapacidadPago
    WHERE E.Activo = 1
    GROUP BY RE.Descripcion
    ORDER BY RE.Descripcion;
END;
GO

-- REPORTE 10: Combinación tipo préstamo + plazo más frecuente
CREATE OR ALTER PROCEDURE sp_ReportePregunta10
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        TP.Nombre AS TipoPrestamo,
        P.Meses AS PlazoMeses,
        COUNT(*) AS Cantidad
    FROM Encuesta E
    INNER JOIN TipoPrestamo TP ON E.IdTipoPrestamo = TP.IdTipoPrestamo
    INNER JOIN Plazo P ON E.IdPlazo = P.IdPlazo
    WHERE E.Activo = 1
    GROUP BY TP.Nombre, P.Meses
    ORDER BY Cantidad DESC;
END;
GO

-- REPORTE 11: Tasa de interés promedio aceptada por rango de ingreso
CREATE OR ALTER PROCEDURE sp_ReportePregunta11
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        RI.Descripcion AS RangoIngresos,
        AVG((TR.Minimo + ISNULL(TR.Maximo, TR.Minimo)) / 2) AS TasaPromedioAceptada
    FROM Encuesta E
    INNER JOIN Cliente C ON E.IdCliente = C.IdCliente
    INNER JOIN RangoIngresos RI ON C.IdRangoIngresos = RI.IdRangoIngresos
    INNER JOIN TasaInteresRango TR ON E.IdTasaRango = TR.IdTasaRango
    WHERE E.Activo = 1
    GROUP BY RI.Descripcion
    ORDER BY RI.Descripcion;
END;
GO

-- REPORTE 12: Tipo de préstamo más aceptado entre universitarios
CREATE OR ALTER PROCEDURE sp_ReportePregunta12
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        TP.Nombre AS TipoPrestamo,
        COUNT(*) AS Cantidad
    FROM Encuesta E
    INNER JOIN Cliente C ON E.IdCliente = C.IdCliente
    INNER JOIN NivelEducativo NE ON C.IdNivelEducativo = NE.IdNivelEducativo
    INNER JOIN TipoPrestamo TP ON E.IdTipoPrestamo = TP.IdTipoPrestamo
    WHERE E.Activo = 1
      AND NE.Nombre = 'Universitario'
    GROUP BY TP.Nombre
    ORDER BY Cantidad DESC;
END;
GO

-- REPORTE 13: Cantidad que prefiere pagar menos de $200 mensuales
CREATE OR ALTER PROCEDURE sp_ReportePregunta13
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        COUNT(*) AS CantidadMenos200Mensuales
    FROM Encuesta E
    INNER JOIN CapacidadPago CP ON E.IdCapacidadPago = CP.IdCapacidadPago
    WHERE E.Activo = 1
      AND CP.Minimo < 200;
END;
GO

-- REPORTE 14: Correlación aproximada entre edad y monto solicitado
CREATE OR ALTER PROCEDURE sp_ReportePregunta14
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        RE.Descripcion AS RangoEdad,
        AVG((MR.Minimo + ISNULL(MR.Maximo, MR.Minimo)) / 2) AS MontoPromedioSolicitado
    FROM Encuesta E
    INNER JOIN Cliente C ON E.IdCliente = C.IdCliente
    INNER JOIN RangoEdad RE ON C.IdRangoEdad = RE.IdRangoEdad
    INNER JOIN MontoRango MR ON E.IdMontoRango = MR.IdMontoRango
    WHERE E.Activo = 1
    GROUP BY RE.Descripcion
    ORDER BY RE.Descripcion;
END;
GO

-- REPORTE 15: Rango de ingresos que solicita montos más altos
CREATE OR ALTER PROCEDURE sp_ReportePregunta15
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        RI.Descripcion AS RangoIngresos,
        AVG((MR.Minimo + ISNULL(MR.Maximo, MR.Minimo)) / 2) AS MontoPromedioSolicitado
    FROM Encuesta E
    INNER JOIN Cliente C ON E.IdCliente = C.IdCliente
    INNER JOIN RangoIngresos RI ON C.IdRangoIngresos = RI.IdRangoIngresos
    INNER JOIN MontoRango MR ON E.IdMontoRango = MR.IdMontoRango
    WHERE E.Activo = 1
    GROUP BY RI.Descripcion
    ORDER BY MontoPromedioSolicitado DESC;
END;
GO

-- REPORTE 16: Medio más usado por personas que han morado
CREATE OR ALTER PROCEDURE sp_ReportePregunta16
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        MC.Nombre AS MedioContratacion,
        COUNT(*) AS Cantidad
    FROM Encuesta E
    INNER JOIN HistorialCrediticio HC ON E.IdHistorial = HC.IdHistorial
    INNER JOIN EncuestaMedioContratacion EMC ON E.IdEncuesta = EMC.IdEncuesta
    INNER JOIN MedioContratacion MC ON EMC.IdMedio = MC.IdMedio
    WHERE E.Activo = 1
      AND EMC.Activo = 1
      AND HC.HaMorado = 1
    GROUP BY MC.Nombre
    ORDER BY Cantidad DESC;
END;
GO

-- REPORTE 17: Porcentaje de mujeres que prefieren préstamos personales
CREATE OR ALTER PROCEDURE sp_ReportePregunta17
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        CAST(
            SUM(CASE WHEN TP.Nombre = 'Personal' THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0)
            AS DECIMAL(5,2)
        ) AS PorcentajeMujeresPrestamoPersonal
    FROM Encuesta E
    INNER JOIN Cliente C ON E.IdCliente = C.IdCliente
    INNER JOIN Genero G ON C.IdGenero = G.IdGenero
    INNER JOIN TipoPrestamo TP ON E.IdTipoPrestamo = TP.IdTipoPrestamo
    WHERE E.Activo = 1
      AND G.Nombre = 'Femenino';
END;
GO

-- REPORTE 18: Personas que prefieren plazos menores o iguales a 24 meses
CREATE OR ALTER PROCEDURE sp_ReportePregunta18
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        COUNT(*) AS CantidadPlazoMenorIgual24
    FROM Encuesta E
    INNER JOIN Plazo P ON E.IdPlazo = P.IdPlazo
    WHERE E.Activo = 1
      AND P.Meses <= 24;
END;
GO

-- REPORTE 19: Distribución de montos por tipo de préstamo
CREATE OR ALTER PROCEDURE sp_ReportePregunta19
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        TP.Nombre AS TipoPrestamo,
        MR.Descripcion AS MontoRango,
        COUNT(*) AS Cantidad
    FROM Encuesta E
    INNER JOIN TipoPrestamo TP ON E.IdTipoPrestamo = TP.IdTipoPrestamo
    INNER JOIN MontoRango MR ON E.IdMontoRango = MR.IdMontoRango
    WHERE E.Activo = 1
    GROUP BY TP.Nombre, MR.Descripcion
    ORDER BY TP.Nombre, Cantidad DESC;
END;
GO

-- REPORTE 20: Nivel educativo con mayor morosidad declarada
CREATE OR ALTER PROCEDURE sp_ReportePregunta20
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        NE.Nombre AS NivelEducativo,
        COUNT(*) AS CantidadMorosidad
    FROM Encuesta E
    INNER JOIN Cliente C ON E.IdCliente = C.IdCliente
    INNER JOIN NivelEducativo NE ON C.IdNivelEducativo = NE.IdNivelEducativo
    INNER JOIN HistorialCrediticio HC ON E.IdHistorial = HC.IdHistorial
    WHERE E.Activo = 1
      AND HC.HaMorado = 1
    GROUP BY NE.Nombre
    ORDER BY CantidadMorosidad DESC;
END;
GO

-- REPORTE 21: Aceptación de tasas mayores a 12% si plazo mayor a 36 meses
CREATE OR ALTER PROCEDURE sp_ReportePregunta21
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        COUNT(*) AS CantidadTasaMayor12PlazoMayor36
    FROM Encuesta E
    INNER JOIN TasaInteresRango TR ON E.IdTasaRango = TR.IdTasaRango
    INNER JOIN Plazo P ON E.IdPlazo = P.IdPlazo
    WHERE E.Activo = 1
      AND TR.Minimo > 12
      AND P.Meses > 36;
END;
GO

-- REPORTE 22: Tipo de préstamo más popular entre 30-45 años
CREATE OR ALTER PROCEDURE sp_ReportePregunta22
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        TP.Nombre AS TipoPrestamo,
        COUNT(*) AS Cantidad
    FROM Encuesta E
    INNER JOIN Cliente C ON E.IdCliente = C.IdCliente
    INNER JOIN RangoEdad RE ON C.IdRangoEdad = RE.IdRangoEdad
    INNER JOIN TipoPrestamo TP ON E.IdTipoPrestamo = TP.IdTipoPrestamo
    WHERE E.Activo = 1
      AND RE.Minimo >= 30
      AND RE.Maximo <= 45
    GROUP BY TP.Nombre
    ORDER BY Cantidad DESC;
END;
GO

-- REPORTE 23: Capacidad de pago promedio por nivel educativo
CREATE OR ALTER PROCEDURE sp_ReportePregunta23
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        NE.Nombre AS NivelEducativo,
        AVG((CP.Minimo + ISNULL(CP.Maximo, CP.Minimo)) / 2) AS CapacidadPagoPromedio
    FROM Encuesta E
    INNER JOIN Cliente C ON E.IdCliente = C.IdCliente
    INNER JOIN NivelEducativo NE ON C.IdNivelEducativo = NE.IdNivelEducativo
    INNER JOIN CapacidadPago CP ON E.IdCapacidadPago = CP.IdCapacidadPago
    WHERE E.Activo = 1
    GROUP BY NE.Nombre
    ORDER BY CapacidadPagoPromedio DESC;
END;
GO

-- REPORTE 24: Plazo preferido por quienes tienen morosidad previa
CREATE OR ALTER PROCEDURE sp_ReportePregunta24
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        P.Meses AS PlazoMeses,
        COUNT(*) AS Cantidad
    FROM Encuesta E
    INNER JOIN HistorialCrediticio HC ON E.IdHistorial = HC.IdHistorial
    INNER JOIN Plazo P ON E.IdPlazo = P.IdPlazo
    WHERE E.Activo = 1
      AND HC.HaMorado = 1
    GROUP BY P.Meses
    ORDER BY Cantidad DESC;
END;
GO

-- REPORTE 25: Ingresos altos que prefieren préstamos para vehículos
CREATE OR ALTER PROCEDURE sp_ReportePregunta25
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        RI.Descripcion AS RangoIngresos,
        COUNT(*) AS Cantidad
    FROM Encuesta E
    INNER JOIN Cliente C ON E.IdCliente = C.IdCliente
    INNER JOIN RangoIngresos RI ON C.IdRangoIngresos = RI.IdRangoIngresos
    INNER JOIN TipoPrestamo TP ON E.IdTipoPrestamo = TP.IdTipoPrestamo
    WHERE E.Activo = 1
      AND RI.Minimo > 2000
      AND TP.Nombre = 'Vehículo'
    GROUP BY RI.Descripcion
    ORDER BY Cantidad DESC;
END;
GO

-- REPORTE 26: Combinación monto + plazo más solicitada
CREATE OR ALTER PROCEDURE sp_ReportePregunta26
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        MR.Descripcion AS MontoRango,
        P.Meses AS PlazoMeses,
        COUNT(*) AS Cantidad
    FROM Encuesta E
    INNER JOIN MontoRango MR ON E.IdMontoRango = MR.IdMontoRango
    INNER JOIN Plazo P ON E.IdPlazo = P.IdPlazo
    WHERE E.Activo = 1
    GROUP BY MR.Descripcion, P.Meses
    ORDER BY Cantidad DESC;
END;
GO

-- REPORTE 27: Relación entre tasa aceptable y capacidad de pago
CREATE OR ALTER PROCEDURE sp_ReportePregunta27
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        TR.Descripcion AS TasaAceptable,
        CP.Descripcion AS CapacidadPago,
        COUNT(*) AS Cantidad
    FROM Encuesta E
    INNER JOIN TasaInteresRango TR ON E.IdTasaRango = TR.IdTasaRango
    INNER JOIN CapacidadPago CP ON E.IdCapacidadPago = CP.IdCapacidadPago
    WHERE E.Activo = 1
    GROUP BY TR.Descripcion, CP.Descripcion
    ORDER BY TR.Descripcion, Cantidad DESC;
END;
GO

-- REPORTE 28: Medio preferido por quienes nunca tuvieron préstamos
CREATE OR ALTER PROCEDURE sp_ReportePregunta28
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        MC.Nombre AS MedioContratacion,
        COUNT(*) AS Cantidad
    FROM Encuesta E
    INNER JOIN HistorialCrediticio HC ON E.IdHistorial = HC.IdHistorial
    INNER JOIN EncuestaMedioContratacion EMC ON E.IdEncuesta = EMC.IdEncuesta
    INNER JOIN MedioContratacion MC ON EMC.IdMedio = MC.IdMedio
    WHERE E.Activo = 1
      AND EMC.Activo = 1
      AND HC.TienePrestamosPrevios = 0
    GROUP BY MC.Nombre
    ORDER BY Cantidad DESC;
END;
GO

-- REPORTE 29: Personas que prefieren pagar menos de 12 meses
CREATE OR ALTER PROCEDURE sp_ReportePregunta29
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        COUNT(*) AS CantidadMenos12Meses
    FROM Encuesta E
    INNER JOIN Plazo P ON E.IdPlazo = P.IdPlazo
    WHERE E.Activo = 1
      AND P.Meses < 12;
END;
GO

-- REPORTE 30: Perfil más común edad + ingreso + tipo de préstamo
CREATE OR ALTER PROCEDURE sp_ReportePregunta30
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        RE.Descripcion AS RangoEdad,
        RI.Descripcion AS RangoIngresos,
        TP.Nombre AS TipoPrestamo,
        COUNT(*) AS Cantidad
    FROM Encuesta E
    INNER JOIN Cliente C ON E.IdCliente = C.IdCliente
    INNER JOIN RangoEdad RE ON C.IdRangoEdad = RE.IdRangoEdad
    INNER JOIN RangoIngresos RI ON C.IdRangoIngresos = RI.IdRangoIngresos
    INNER JOIN TipoPrestamo TP ON E.IdTipoPrestamo = TP.IdTipoPrestamo
    WHERE E.Activo = 1
    GROUP BY RE.Descripcion, RI.Descripcion, TP.Nombre
    ORDER BY Cantidad DESC;
END;
GO

/* ============================================================
   19. CONSULTAS DE VERIFICACIÓN FINAL
============================================================ */

SELECT COUNT(*) AS TotalTablas
FROM sys.tables;

SELECT COUNT(*) AS TotalProcedimientos
FROM sys.procedures;

SELECT COUNT(*) AS TotalPreguntas
FROM Pregunta;

SELECT COUNT(*) AS TotalReportes
FROM sys.procedures
WHERE name LIKE 'sp_ReportePregunta%';

SELECT name AS NombreTabla
FROM sys.tables
ORDER BY name;

SELECT name AS NombreProcedimiento
FROM sys.procedures
ORDER BY name;

SELECT 
    fk.name AS NombreRelacion,
    OBJECT_NAME(fk.parent_object_id) AS TablaOrigen,
    OBJECT_NAME(fk.referenced_object_id) AS TablaReferencia
FROM sys.foreign_keys fk
ORDER BY TablaOrigen;
GO


/* ============================================================
   AJUSTES FINALES INTEGRADOS - VERSIÓN DEFINITIVA
   Auditoría, encuestas, eliminación lógica y restauración
============================================================ */

USE SistemaPrestamosDB;
GO

CREATE OR ALTER PROCEDURE sp_CrearUsuario
    @Nombre VARCHAR(100),
    @NombreUsuario VARCHAR(50),
    @Email VARCHAR(150),
    @Clave VARCHAR(255),
    @IdRol INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @UsuarioAuditoria VARCHAR(50);

        SELECT @UsuarioAuditoria = NombreUsuario
        FROM Usuario
        WHERE IdUsuario = @IdUsuarioAuditoria;

        SET @UsuarioAuditoria = ISNULL(@UsuarioAuditoria, 'SISTEMA');

        INSERT INTO Usuario
        (
            Nombre,
            NombreUsuario,
            Email,
            Clave,
            IdRol,
            Activo,
            FechaCreacion,
            UsuarioCreacion
        )
        VALUES
        (
            @Nombre,
            @NombreUsuario,
            @Email,
            @Clave,
            @IdRol,
            1,
            GETDATE(),
            @UsuarioAuditoria
        );

        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Usuario',
            @IdRegistro = @NuevoId,
            @Accion = 'INSERT',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Creación de usuario',
            @ValorNuevo = @NombreUsuario;

        COMMIT TRANSACTION;

        SELECT
            @NuevoId AS IdUsuario,
            'Usuario creado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_InsertarUsuario
    @Nombre VARCHAR(100),
    @NombreUsuario VARCHAR(50),
    @Email VARCHAR(150),
    @Clave VARCHAR(255),
    @IdRol INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @UsuarioAuditoria VARCHAR(50);

        SELECT @UsuarioAuditoria = NombreUsuario
        FROM Usuario
        WHERE IdUsuario = @IdUsuarioAuditoria;

        SET @UsuarioAuditoria = ISNULL(@UsuarioAuditoria, 'SISTEMA');

        INSERT INTO Usuario
        (
            Nombre,
            NombreUsuario,
            Email,
            Clave,
            IdRol,
            Activo,
            FechaCreacion,
            UsuarioCreacion
        )
        VALUES
        (
            @Nombre,
            @NombreUsuario,
            @Email,
            @Clave,
            @IdRol,
            1,
            GETDATE(),
            @UsuarioAuditoria
        );

        DECLARE @NuevoId INT = SCOPE_IDENTITY();

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Usuario',
            @IdRegistro = @NuevoId,
            @Accion = 'INSERT',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Creación de usuario',
            @ValorNuevo = @NombreUsuario;

        COMMIT TRANSACTION;

        SELECT
            @NuevoId AS IdUsuario,
            'Usuario creado correctamente.' AS Mensaje;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarUsuario
    @IdUsuario INT,
    @Nombre VARCHAR(100),
    @NombreUsuario VARCHAR(50),
    @Email VARCHAR(150),
    @Clave VARCHAR(255),
    @IdRol INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ValorAnterior VARCHAR(MAX);
        DECLARE @UsuarioAuditoria VARCHAR(50);

        SELECT @ValorAnterior =
            CONCAT(
                'Nombre: ', Nombre,
                ', Usuario: ', NombreUsuario,
                ', Email: ', Email,
                ', Rol: ', IdRol
            )
        FROM Usuario
        WHERE IdUsuario = @IdUsuario;

        SELECT @UsuarioAuditoria = NombreUsuario
        FROM Usuario
        WHERE IdUsuario = @IdUsuarioAuditoria;

        SET @UsuarioAuditoria = ISNULL(@UsuarioAuditoria, 'SISTEMA');

        UPDATE Usuario
        SET
            Nombre = @Nombre,
            NombreUsuario = @NombreUsuario,
            Email = @Email,
            Clave = @Clave,
            IdRol = @IdRol,
            FechaModificacion = GETDATE(),
            UsuarioModificacion = @UsuarioAuditoria
        WHERE IdUsuario = @IdUsuario;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Usuario',
            @IdRegistro = @IdUsuario,
            @Accion = 'UPDATE',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Actualización de usuario',
            @ValorAnterior = @ValorAnterior,
            @ValorNuevo = @NombreUsuario;

        COMMIT TRANSACTION;

        SELECT 'Usuario actualizado correctamente.' AS Mensaje;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarUsuarioLogico
    @IdUsuario INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @UsuarioAuditoria VARCHAR(50);

        SELECT @UsuarioAuditoria = NombreUsuario
        FROM Usuario
        WHERE IdUsuario = @IdUsuarioAuditoria;

        SET @UsuarioAuditoria = ISNULL(@UsuarioAuditoria, 'SISTEMA');

        UPDATE Usuario
        SET
            Activo = 0,
            FechaModificacion = GETDATE(),
            UsuarioModificacion = @UsuarioAuditoria
        WHERE IdUsuario = @IdUsuario;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Usuario',
            @IdRegistro = @IdUsuario,
            @Accion = 'DELETE_LOGICO',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Eliminación lógica de usuario';

        COMMIT TRANSACTION;

        SELECT 'Usuario eliminado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarUsuario
    @IdUsuario INT,
    @IdUsuarioAuditoria INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @UsuarioAuditoria VARCHAR(50);

        SELECT @UsuarioAuditoria = NombreUsuario
        FROM Usuario
        WHERE IdUsuario = @IdUsuarioAuditoria;

        SET @UsuarioAuditoria = ISNULL(@UsuarioAuditoria, 'SISTEMA');

        UPDATE Usuario
        SET
            Activo = 1,
            FechaModificacion = GETDATE(),
            UsuarioModificacion = @UsuarioAuditoria
        WHERE IdUsuario = @IdUsuario;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Usuario',
            @IdRegistro = @IdUsuario,
            @Accion = 'RESTAURAR',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Restauración de usuario';

        COMMIT TRANSACTION;

        SELECT 'Usuario restaurado correctamente.' AS Mensaje;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_CrearEncuestaCompleta
    @NombreCliente VARCHAR(150),
    @Email VARCHAR(150),
    @Telefono VARCHAR(20),
    @IdGenero INT,
    @IdNivelEducativo INT,
    @IdRangoIngresos INT,
    @IdRangoEdad INT,
    @IdCiudad INT,
    @IdOcupacion INT,
    @IdTipoPrestamo INT,
    @IdPlazo INT,
    @IdMontoRango INT,
    @IdTasaRango INT,
    @IdCapacidadPago INT,
    @IdHistorial INT,
    @IdUsuarioCreador INT = NULL,
    @IdentificadorSesion VARCHAR(100) = NULL,
    @DireccionIP VARCHAR(50) = NULL,
    @Observacion VARCHAR(300) = NULL,
    @Respuestas TipoRespuestaEncuesta READONLY,
    @Medios TipoMedioEncuesta READONLY
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @UsuarioAuditoria VARCHAR(50);

        SELECT @UsuarioAuditoria = NombreUsuario
        FROM Usuario
        WHERE IdUsuario = @IdUsuarioCreador;

        SET @UsuarioAuditoria =
            ISNULL(@UsuarioAuditoria, 'SISTEMA');

        IF @IdentificadorSesion IS NOT NULL
           AND EXISTS
           (
               SELECT 1
               FROM Encuesta
               WHERE IdentificadorSesion = @IdentificadorSesion
                 AND Activo = 1
           )
        BEGIN
            RAISERROR(
                'Ya existe una encuesta registrada desde esta sesión.',
                16,
                1
            );
        END;

        INSERT INTO Cliente
        (
            Nombre,
            Email,
            Telefono,
            IdGenero,
            IdNivelEducativo,
            IdRangoIngresos,
            IdRangoEdad,
            IdCiudad,
            IdOcupacion,
            Activo,
            FechaCreacion,
            UsuarioCreacion
        )
        VALUES
        (
            @NombreCliente,
            @Email,
            @Telefono,
            @IdGenero,
            @IdNivelEducativo,
            @IdRangoIngresos,
            @IdRangoEdad,
            @IdCiudad,
            @IdOcupacion,
            1,
            GETDATE(),
            @UsuarioAuditoria
        );

        DECLARE @IdCliente INT = SCOPE_IDENTITY();

        INSERT INTO Encuesta
        (
            IdCliente,
            IdTipoPrestamo,
            IdPlazo,
            IdMontoRango,
            IdTasaRango,
            IdCapacidadPago,
            IdHistorial,
            IdUsuarioCreador,
            IdentificadorSesion,
            DireccionIP,
            Observacion,
            Activo,
            FechaCreacion,
            UsuarioCreacion
        )
        VALUES
        (
            @IdCliente,
            @IdTipoPrestamo,
            @IdPlazo,
            @IdMontoRango,
            @IdTasaRango,
            @IdCapacidadPago,
            @IdHistorial,
            @IdUsuarioCreador,
            @IdentificadorSesion,
            @DireccionIP,
            @Observacion,
            1,
            GETDATE(),
            @UsuarioAuditoria
        );

        DECLARE @IdEncuesta INT = SCOPE_IDENTITY();

        INSERT INTO Respuesta
        (
            IdEncuesta,
            IdPregunta,
            ValorTexto,
            ValorEntero,
            ValorDecimal,
            Activo,
            FechaCreacion,
            UsuarioCreacion
        )
        SELECT
            @IdEncuesta,
            IdPregunta,
            ValorTexto,
            ValorEntero,
            ValorDecimal,
            1,
            GETDATE(),
            @UsuarioAuditoria
        FROM @Respuestas;

        INSERT INTO EncuestaMedioContratacion
        (
            IdEncuesta,
            IdMedio,
            Activo,
            FechaCreacion,
            UsuarioCreacion
        )
        SELECT
            @IdEncuesta,
            IdMedio,
            1,
            GETDATE(),
            @UsuarioAuditoria
        FROM @Medios;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Encuesta',
            @IdRegistro = @IdEncuesta,
            @Accion = 'INSERT',
            @IdUsuario = @IdUsuarioCreador,
            @Detalle = 'Registro de encuesta completa',
            @ValorNuevo = @NombreCliente;

        COMMIT TRANSACTION;

        SELECT
            @IdEncuesta AS IdEncuesta,
            @IdCliente AS IdCliente,
            'Encuesta registrada correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarEncuestaCompleta
    @IdEncuesta INT,
    @NombreCliente VARCHAR(150),
    @Email VARCHAR(150),
    @Telefono VARCHAR(20),
    @IdGenero INT,
    @IdNivelEducativo INT,
    @IdRangoIngresos INT,
    @IdRangoEdad INT,
    @IdCiudad INT,
    @IdOcupacion INT,
    @IdTipoPrestamo INT,
    @IdPlazo INT,
    @IdMontoRango INT,
    @IdTasaRango INT,
    @IdCapacidadPago INT,
    @IdHistorial INT,
    @IdUsuarioAuditoria INT = NULL,
    @Observacion VARCHAR(300) = NULL,
    @Respuestas TipoRespuestaEncuesta READONLY,
    @Medios TipoMedioEncuesta READONLY
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @IdCliente INT;
        DECLARE @ValorAnterior VARCHAR(MAX);
        DECLARE @UsuarioAuditoria VARCHAR(50);

        SELECT
            @IdCliente = E.IdCliente,
            @ValorAnterior = CONCAT(
                'IdEncuesta: ', E.IdEncuesta,
                ', IdCliente: ', E.IdCliente,
                ', IdTipoPrestamo: ', E.IdTipoPrestamo,
                ', IdPlazo: ', E.IdPlazo
            )
        FROM Encuesta E
        WHERE E.IdEncuesta = @IdEncuesta
          AND E.Activo = 1;

        IF @IdCliente IS NULL
        BEGIN
            RAISERROR(
                'La encuesta indicada no existe o se encuentra eliminada.',
                16,
                1
            );
        END;

        SELECT @UsuarioAuditoria = NombreUsuario
        FROM Usuario
        WHERE IdUsuario = @IdUsuarioAuditoria;

        SET @UsuarioAuditoria =
            ISNULL(@UsuarioAuditoria, 'SISTEMA');

        UPDATE Cliente
        SET
            Nombre = @NombreCliente,
            Email = @Email,
            Telefono = @Telefono,
            IdGenero = @IdGenero,
            IdNivelEducativo = @IdNivelEducativo,
            IdRangoIngresos = @IdRangoIngresos,
            IdRangoEdad = @IdRangoEdad,
            IdCiudad = @IdCiudad,
            IdOcupacion = @IdOcupacion,
            FechaModificacion = GETDATE(),
            UsuarioModificacion = @UsuarioAuditoria
        WHERE IdCliente = @IdCliente;

        UPDATE Encuesta
        SET
            IdTipoPrestamo = @IdTipoPrestamo,
            IdPlazo = @IdPlazo,
            IdMontoRango = @IdMontoRango,
            IdTasaRango = @IdTasaRango,
            IdCapacidadPago = @IdCapacidadPago,
            IdHistorial = @IdHistorial,
            Observacion = @Observacion,
            FechaModificacion = GETDATE(),
            UsuarioModificacion = @UsuarioAuditoria
        WHERE IdEncuesta = @IdEncuesta;

        UPDATE Respuesta
        SET
            Activo = 0,
            FechaModificacion = GETDATE(),
            UsuarioModificacion = @UsuarioAuditoria
        WHERE IdEncuesta = @IdEncuesta;

        INSERT INTO Respuesta
        (
            IdEncuesta,
            IdPregunta,
            ValorTexto,
            ValorEntero,
            ValorDecimal,
            Activo,
            FechaCreacion,
            UsuarioCreacion
        )
        SELECT
            @IdEncuesta,
            IdPregunta,
            ValorTexto,
            ValorEntero,
            ValorDecimal,
            1,
            GETDATE(),
            @UsuarioAuditoria
        FROM @Respuestas;

        UPDATE EncuestaMedioContratacion
        SET
            Activo = 0,
            FechaModificacion = GETDATE(),
            UsuarioModificacion = @UsuarioAuditoria
        WHERE IdEncuesta = @IdEncuesta;

        INSERT INTO EncuestaMedioContratacion
        (
            IdEncuesta,
            IdMedio,
            Activo,
            FechaCreacion,
            UsuarioCreacion
        )
        SELECT
            @IdEncuesta,
            IdMedio,
            1,
            GETDATE(),
            @UsuarioAuditoria
        FROM @Medios;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Encuesta',
            @IdRegistro = @IdEncuesta,
            @Accion = 'UPDATE',
            @IdUsuario = @IdUsuarioAuditoria,
            @Detalle = 'Actualización de encuesta completa',
            @ValorAnterior = @ValorAnterior,
            @ValorNuevo = @NombreCliente;

        COMMIT TRANSACTION;

        SELECT 'Encuesta actualizada correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_EliminarEncuestaLogica
    @IdEncuesta INT,
    @IdUsuario INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @UsuarioAuditoria VARCHAR(50);

        SELECT @UsuarioAuditoria = NombreUsuario
        FROM Usuario
        WHERE IdUsuario = @IdUsuario;

        SET @UsuarioAuditoria =
            ISNULL(@UsuarioAuditoria, 'SISTEMA');

        IF NOT EXISTS (
            SELECT 1
            FROM Encuesta
            WHERE IdEncuesta = @IdEncuesta
              AND Activo = 1
        )
        BEGIN
            RAISERROR(
                'La encuesta no existe o ya se encuentra eliminada.',
                16,
                1
            );
        END;

        UPDATE Encuesta
        SET
            Activo = 0,
            FechaModificacion = GETDATE(),
            UsuarioModificacion = @UsuarioAuditoria
        WHERE IdEncuesta = @IdEncuesta;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Encuesta',
            @IdRegistro = @IdEncuesta,
            @Accion = 'DELETE_LOGICO',
            @IdUsuario = @IdUsuario,
            @Detalle = 'Eliminación lógica de encuesta';

        COMMIT TRANSACTION;

        SELECT
            'Encuesta eliminada correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_RestaurarEncuesta
    @IdEncuesta INT,
    @IdUsuario INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @UsuarioAuditoria VARCHAR(50);

        SELECT @UsuarioAuditoria = NombreUsuario
        FROM Usuario
        WHERE IdUsuario = @IdUsuario;

        SET @UsuarioAuditoria =
            ISNULL(@UsuarioAuditoria, 'SISTEMA');

        IF NOT EXISTS (
            SELECT 1
            FROM Encuesta
            WHERE IdEncuesta = @IdEncuesta
              AND Activo = 0
        )
        BEGIN
            RAISERROR(
                'La encuesta no existe o ya se encuentra activa.',
                16,
                1
            );
        END;

        UPDATE Encuesta
        SET
            Activo = 1,
            FechaModificacion = GETDATE(),
            UsuarioModificacion = @UsuarioAuditoria
        WHERE IdEncuesta = @IdEncuesta;

        EXEC sp_RegistrarAuditoria
            @NombreTabla = 'Encuesta',
            @IdRegistro = @IdEncuesta,
            @Accion = 'RESTORE',
            @IdUsuario = @IdUsuario,
            @Detalle = 'Restauración de encuesta';

        COMMIT TRANSACTION;

        SELECT
            'Encuesta restaurada correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarEncuestas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        E.IdEncuesta,
        E.Fecha,
        C.Nombre AS Cliente,
        C.Email,
        C.Telefono,
        TP.Nombre AS TipoPrestamo,
        P.Meses AS PlazoMeses,
        MR.Descripcion AS MontoSolicitado,
        TR.Descripcion AS TasaAceptable,
        CP.Descripcion AS CapacidadPago,
        HC.Descripcion AS HistorialCrediticio,
        U.Nombre AS UsuarioCreador,
        E.Observacion,
        E.Activo
    FROM Encuesta E
    INNER JOIN Cliente C
        ON E.IdCliente = C.IdCliente
    INNER JOIN TipoPrestamo TP
        ON E.IdTipoPrestamo = TP.IdTipoPrestamo
    INNER JOIN Plazo P
        ON E.IdPlazo = P.IdPlazo
    INNER JOIN MontoRango MR
        ON E.IdMontoRango = MR.IdMontoRango
    INNER JOIN TasaInteresRango TR
        ON E.IdTasaRango = TR.IdTasaRango
    INNER JOIN CapacidadPago CP
        ON E.IdCapacidadPago = CP.IdCapacidadPago
    INNER JOIN HistorialCrediticio HC
        ON E.IdHistorial = HC.IdHistorial
    LEFT JOIN Usuario U
        ON E.IdUsuarioCreador = U.IdUsuario

    ORDER BY E.Fecha DESC;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarGenerosTodos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdGenero,
        Nombre,
        Activo
    FROM Genero
    ORDER BY IdGenero;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarCiudadesTodos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdCiudad,
        Nombre,
        Activo
    FROM Ciudad
    ORDER BY Nombre;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarOcupacionesTodos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdOcupacion,
        Nombre,
        Activo
    FROM Ocupacion
    ORDER BY Nombre;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarNivelesEducativosTodos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdNivelEducativo,
        Nombre,
        Activo
    FROM NivelEducativo
    ORDER BY Nombre;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarTiposPrestamoTodos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdTipoPrestamo,
        Nombre,
        Activo
    FROM TipoPrestamo
    ORDER BY Nombre;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarMediosContratacionTodos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdMedio,
        Nombre,
        Activo
    FROM MedioContratacion
    ORDER BY Nombre;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarPlazosTodos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdPlazo,
        Meses,
        Activo
    FROM Plazo
    ORDER BY Meses;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarRangosEdadTodos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdRangoEdad,
        Minimo,
        Maximo,
        Descripcion,
        Activo
    FROM RangoEdad
    ORDER BY Minimo;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarRangosIngresosTodos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdRangoIngresos,
        Minimo,
        Maximo,
        Descripcion,
        Activo
    FROM RangoIngresos
    ORDER BY Minimo;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarMontosRangoTodos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdMontoRango,
        Minimo,
        Maximo,
        Descripcion,
        Activo
    FROM MontoRango
    ORDER BY Minimo;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarTasasInteresRangoTodos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdTasaRango,
        Minimo,
        Maximo,
        Descripcion,
        Activo
    FROM TasaInteresRango
    ORDER BY Minimo;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarCapacidadesPagoTodos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdCapacidadPago,
        Minimo,
        Maximo,
        Descripcion,
        Activo
    FROM CapacidadPago
    ORDER BY Minimo;
END;
GO

CREATE OR ALTER PROCEDURE sp_ConsultarHistorialesCrediticiosTodos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdHistorial,
        TienePrestamosPrevios,
        HaMorado,
        Descripcion,
        Activo
    FROM HistorialCrediticio
    ORDER BY IdHistorial;
END;
GO


/* ============================================================
   VERIFICACIÓN FINAL
============================================================ */

SELECT DB_NAME() AS BaseActual;

SELECT
    (SELECT COUNT(*) FROM Rol) AS Roles,
    (SELECT COUNT(*) FROM Usuario) AS UsuariosIniciales,
    (SELECT COUNT(*) FROM Pregunta) AS Preguntas,
    (SELECT COUNT(*) FROM Genero) AS Generos,
    (SELECT COUNT(*) FROM TipoPrestamo) AS TiposPrestamo;

SELECT
    CASE
        WHEN (SELECT COUNT(*) FROM Pregunta WHERE Activo = 1) = 20
        THEN 'OK - 20 preguntas activas'
        ELSE 'REVISAR - La cantidad de preguntas activas no es 20'
    END AS EstadoPreguntas;

SELECT
    CASE
        WHEN OBJECT_ID('sp_ReportePregunta01', 'P') IS NOT NULL
         AND OBJECT_ID('sp_ReportePregunta30', 'P') IS NOT NULL
         AND OBJECT_ID('sp_CrearEncuestaCompleta', 'P') IS NOT NULL
         AND OBJECT_ID('sp_ActualizarEncuestaCompleta', 'P') IS NOT NULL
         AND OBJECT_ID('sp_CrearUsuario', 'P') IS NOT NULL
         AND OBJECT_ID('sp_ConsultarGenerosTodos', 'P') IS NOT NULL
        THEN 'OK - Procedimientos principales creados'
        ELSE 'REVISAR - Falta algún procedimiento principal'
    END AS EstadoProcedimientos;

PRINT 'Base de datos SistemaPrestamosDB creada y preparada correctamente.';
GO
