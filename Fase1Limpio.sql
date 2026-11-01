-- ============================================================================
-- PROYECTO CREDICORE - FASE 1: CIMIENTOS DE TITANIO
-- Autor: William Marvin Barreno Say
-- Motor: Microsoft SQL Server
-- Descripción: Creación de BD, Esquemas lógicos, Tablas y Restricciones
-- ============================================================================

USE master;


-- 1. CREACIÓN DE LA BASE DE DATOS
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'CrediCoreDB')
BEGIN
    CREATE DATABASE CrediCoreDB;
END;


USE CrediCoreDB;


-- 2. CREACIÓN DE ESQUEMAS DE SEGURIDAD LÓGICA
IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = N'Operaciones')
BEGIN
    EXEC('CREATE SCHEMA Operaciones;');
END;


IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = N'Garantias')
BEGIN
    EXEC('CREATE SCHEMA Garantias;');
END;


-- 3. LIMPIEZA DE TABLAS PREVIAS (Para ejecuciones idempotentes)
IF OBJECT_ID('Operaciones.Creditos', 'U') IS NOT NULL DROP TABLE Operaciones.Creditos;
IF OBJECT_ID('Garantias.Vehiculos', 'U') IS NOT NULL DROP TABLE Garantias.Vehiculos;
IF OBJECT_ID('Operaciones.Clientes', 'U') IS NOT NULL DROP TABLE Operaciones.Clientes;


-- 4. TABLA: Operaciones.Clientes
CREATE TABLE Operaciones.Clientes (
    IdCliente INT IDENTITY(1,1) NOT NULL,
    DPI VARCHAR(13) NOT NULL,
    Nombres VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    Telefono VARCHAR(15) NULL,
    Correo VARCHAR(150) NULL,
    
    -- Restricciones de Clave e Integridad
    CONSTRAINT PK_Clientes PRIMARY KEY (IdCliente),
    CONSTRAINT UQ_Clientes_DPI UNIQUE (DPI),
    CONSTRAINT CK_Clientes_DPI_Formato CHECK (LEN(DPI) = 13 AND DPI NOT LIKE '%[^0-9]%')
);


-- 5. TABLA: Garantias.Vehiculos
CREATE TABLE Garantias.Vehiculos (
    IdVehiculo INT IDENTITY(1,1) NOT NULL,
    Marca VARCHAR(50) NOT NULL,
    Modelo VARCHAR(50) NOT NULL,
    Anio INT NOT NULL,
    Color VARCHAR(30) NOT NULL,
    NumeroTituloPropiedad VARCHAR(50) NOT NULL,
    Placa VARCHAR(15) NOT NULL,
    NumeroChasis VARCHAR(30) NOT NULL,
    
    -- Restricciones de Clave e Integridad
    CONSTRAINT PK_Vehiculos PRIMARY KEY (IdVehiculo),
    CONSTRAINT UQ_Vehiculos_Titulo UNIQUE (NumeroTituloPropiedad),
    CONSTRAINT UQ_Vehiculos_PlacaChasis UNIQUE (Placa, NumeroChasis),
    
    -- Regla de Negocio: Antigüedad máxima permitida (No menores al año 2011)
    CONSTRAINT CK_Vehiculos_AnioPermitido CHECK (Anio >= 2011)
);


-- 6. TABLA: Operaciones.Creditos
CREATE TABLE Operaciones.Creditos (
    IdCredito INT IDENTITY(1,1) NOT NULL,
    IdCliente INT NOT NULL,
    IdVehiculo INT NOT NULL,
    MontoOtorgado DECIMAL(18,2) NOT NULL,
    TasaInteresMensual DECIMAL(5,2) NOT NULL,
    Estado VARCHAR(20) NOT NULL CONSTRAINT DF_Creditos_Estado DEFAULT 'Activo',
    FechaDesembolso DATETIME2(0) NOT NULL CONSTRAINT DF_Creditos_FechaDesembolso DEFAULT GETDATE(),
    
    -- Restricciones de Clave e Integridad
    CONSTRAINT PK_Creditos PRIMARY KEY (IdCredito),
    
    -- Reglas de Negocio Financieras
    CONSTRAINT CK_Creditos_MontoMinimo CHECK (MontoOtorgado > 1000.00),
    CONSTRAINT CK_Creditos_TasaInteresNoNegativa CHECK (TasaInteresMensual >= 0.00)
);
