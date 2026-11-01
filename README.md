# 📊 DB1-CrediCore-2026 - Fase 2: Ingesta Masiva e Inteligencia de Negocios

Este repositorio contiene los artefactos técnicos correspondientes a la Fase 2 del Proyecto CrediCore para el curso de Base de Datos I. El objetivo de esta fase es demostrar el dominio en la ingesta de grandes volúmenes de datos hacia un motor RDBMS (SQL Server 2022) y la posterior generación de reportes de Inteligencia Financiera.

## 🏗️ Entorno de Ejecución
* **Motor de Base de Datos:** SQL Server 2022
* **Infraestructura:** Contenedor Docker alojado en Ubuntu 26.04 LTS (Máquina Virtual VirtualBox).
* **IDE de Administración:** DBeaver 26.1.3
* **Herramientas Ofimáticas:** Microsoft Excel / PowerShell (para generación de Dummy Data y automatización de DML).

## 📂 Estructura de Archivos del Commit

Los siguientes scripts y muestras de datos están incluidos en la entrega:

1. **`creditos_sample.txt`**: Muestra de 10 líneas del archivo plano original de 2,000 registros separado por pipes (`|`).
2. **`Fase2_1_Vehiculos_Lotes.sql`**: Script DML que supera el Error 10738 (límite de 1,000 filas) dividiendo la ingesta de 1,500 vehículos mediante bloques `GO`.
3. **`Fase2_2_Clientes_Excel.sql`**: Resultado de la automatización ofimática mediante la función `=CONCATENAR` para la inserción de 500 clientes.
4. **`Fase2_3_BulkInsert.sql`**: Instrucción nativa para la absorción de los 2,000 créditos desde el contenedor Docker.
5. **`Fase2_4_Consultas_BI.sql`**: Consultas de inteligencia financiera utilizando funciones de agregación (`SUM`, `AVG`, `COUNT`, `MAX`, `MIN`) y filtrado de grupos (`HAVING`).

## 🚀 Instrucciones de Despliegue (Docker)

Para la ejecución del script de `BULK INSERT`, el archivo plano completo debe transferirse previamente al volumen del contenedor de SQL Server utilizando los siguientes comandos desde el host Linux:

```bash
docker exec -it sqlserver2022 mkdir -p /tmp/import
docker cp creditos_2000.txt sqlserver2022:/tmp/import/creditos_2000.txt
docker exec -it sqlserver2022 chmod 777 /tmp/import/creditos_2000.txt
