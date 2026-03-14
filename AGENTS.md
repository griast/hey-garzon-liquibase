# AGENTS.md – Liquibase (Hey Garzon)

Este documento orienta a los agentes de IA que trabajan en el módulo de migraciones de base de datos del proyecto **Hey Garzon**.

## Resumen del proyecto

- **Qué es**: Módulo de migraciones con [Liquibase](https://www.liquibase.org/) sobre **PostgreSQL**, integrado con Spring Boot.
- **Stack**: Java 21, Gradle, Spring Boot 4.x, Liquibase, PostgreSQL 14+.
- **Esquema**: `public`.

## Estructura relevante

```
liquibase/
├── src/main/resources/
│   ├── application.yaml              # Conexión BD (DATABASE_*)
│   ├── dbinit/
│   │   └── data.sql                  # Script SQL ejecutado solo con perfil "local"
│   └── db/
│       ├── model.html                # Diagrama ER (Mermaid)
│       └── changelog/
│           ├── db.changelog-master.yaml   # Master (incluye v1, v2, …)
│           └── v1/
│               └── changelog.v1.yaml      # Changesets versión 1.x
├── docker-compose.yaml               # Postgres 16 para desarrollo
├── build.gradle
├── Makefile                          # make show-diagram
└── .cursor/skills/liquibase-change-types/SKILL.md  # Tipos de cambio y rollback
```

- **Perfil `local`**: Con `--spring.profiles.active=local` se ejecuta el script `dbinit/data.sql` tras las migraciones (ver `LocalDataSqlRunner`).

- **Nuevos changelogs**: Añadir includes en `db.changelog-master.yaml` y crear archivos bajo `db/changelog/v{N}/`.
- **Diagrama ER**: Generado/actualizado en `src/main/resources/db/model.html`; ver con `make show-diagram`.

## Convenciones (obligatorias)

Al crear o modificar changesets, respetar siempre:

| Regla | Detalle |
|-------|--------|
| **ID** | `{descripcion}-v{major}.{minor}.{patch}` (único en todo el changelog). |
| **Autor** | Email con dominio `@gmail.com`. |
| **tagDatabase** | Primer cambio del changeset; `tag` igual al ID (o versión acordada). |
| **Rollback** | Incluir sección `rollback` en **cada** changeset. |
| **Nombres** | snake_case; tablas en **singular**. |
| **Claves foráneas** | `fk_{tabla_actual}_{tabla_referenciada}`. |

Tipos de cambio, estructura YAML y patrones de rollback están documentados en **`.cursor/skills/liquibase-change-types/SKILL.md`**. Usar ese skill al escribir o revisar changesets.

## Comandos útiles

- **Migrar**: `./gradlew bootRun` (aplica changelogs al arrancar).
- **Tests**: `./gradlew test`.
- **Recrear BD y migrar**: `./gradlew bootRun --args='--spring.liquibase.dropFirst=true'`.
- **Postgres local**: `docker compose up -d` (puerto 5432, DB `heygarzon`, user/pass `postgres`).
- **Diagrama**: `make show-diagram`.

## Configuración y entorno

- Conexión por defecto: `jdbc:postgresql://localhost:5432/heygarzon` (override con `DATABASE_URL`, `DATABASE_USERNAME`, `DATABASE_PASSWORD`).
- Con Colima/Docker: si falla la conexión a `localhost:5432`, usar la IP de Colima en `DATABASE_URL`, p. ej. `jdbc:postgresql://192.168.64.2:5432/heygarzon` (ver README sección "Postgres Connection Issue").

## Convenciones Java (módulo api)

| Regla | Detalle |
|-------|---------|
| **@AllArgsConstructor** | Utilizar siempre la anotación Lombok `@AllArgsConstructor` en servicios, controllers, use cases, adapters o clases con dependencias inyectadas, para evitar la definición manual de constructores. Excepciones: clases que extiendan excepciones (deben llamar a `super`), records y clases sin campos. |

## Guía para agentes

1. **Nuevos changesets**: Crear en el archivo de changelog correspondiente a la versión (p. ej. `changelog.v1.yaml`), con ID, autor, `tagDatabase`, cambios y **rollback** según el skill de Liquibase.
2. **Nueva versión (v2, v3…)**: Añadir directorio `db/changelog/v{N}/`, crear `changelog.v{N}.yaml` e incluir ese archivo en `db.changelog-master.yaml`.
3. **Consistencia**: No introducir tablas en plural ni FKs que no sigan `fk_{tabla_actual}_{tabla_referenciada}`.
4. **Rollback**: Cada cambio debe poder revertirse; consultar `.cursor/skills/liquibase-change-types/SKILL.md` para el patrón correcto según el tipo de cambio.
5. **Documentación**: Mantener README y, si aplica, `model.html` alineados con nuevas tablas o relaciones.
