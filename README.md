# Liquibase - Hey Garzon

Módulo dedicado a la gestión de migraciones de base de datos para el proyecto **Hey Garzon**. Utiliza [Liquibase](https://www.liquibase.org/) integrado con Spring Boot para versionar y aplicar cambios de esquema sobre PostgreSQL.

## Características

- **Migraciones versionadas** en formato YAML
- **Rollback** definido para cada changeset
- **Tags** por versión para rollbacks precisos
- Base de datos: **PostgreSQL**
- Esquema: `public`

## Requisitos

- Java 21
- PostgreSQL 14+ (o compatible)
- Gradle

## Estructura del proyecto

```
liquibase/
├── src/main/resources/
│   ├── application.yaml           # Configuración de conexión
│   ├── dbinit/
│   │   └── data.sql               # Datos iniciales para local (solo con perfil "local")
│   └── db
│       ├── model.html                 # Diagrama ER (Mermaid)
│       └── changelog
│           ├── db.changelog-master.yaml   # Master changelog
│           └── v1
│               └── changelog.v1.yaml      # Cambios versión 1.x
└── build.gradle
```

## Esquema de base de datos (v1)

El changelog actual define las siguientes tablas:

| Tabla        | Descripción                                      |
|--------------|--------------------------------------------------|
| `user`       | Usuarios del sistema (name, email)               |
| `role`       | Roles (ROOT_ADMIN, SALES_AGENT, BUSINESS_ADMIN)  |
| `theme`      | Temas asociados a negocios                       |
| `user_role`  | Relación N:N entre usuario y rol                 |
| `business`   | Negocios (tema, nombre, teléfono, email, logo)   |
| `business_user` | Relación usuario–negocio                      |
| `category`   | Categorías de productos por negocio              |
| `product`    | Productos (nombre, descripción, precio, imagen)  |

Además incluye datos iniciales:
- Roles: `ROOT_ADMIN`, `SALES_AGENT`, `BUSINESS_ADMIN`
- Usuario admin: `user1@gmail.com` con rol `ROOT_ADMIN`

## Configuración

Variables de entorno (con valores por defecto):

| Variable           | Descripción                    | Default                              |
|--------------------|--------------------------------|--------------------------------------|
| `DATABASE_URL`     | JDBC URL de PostgreSQL         | `jdbc:postgresql://localhost:5432/heygarzon` |
| `DATABASE_USERNAME`| Usuario de BD                  | `postgres`                            |
| `DATABASE_PASSWORD`| Contraseña                     | `postgres`                            |
| `LIQUIBASE_DROP_FIRST` | Eliminar y recrear BD antes de migrar | `false`           |

## Uso

### Ejecutar migraciones

Al arrancar la aplicación, Spring Boot aplica automáticamente los changelogs pendientes:

```bash
./gradlew bootRun
```

### Perfil local (datos iniciales)

Con el perfil `local` activo, tras las migraciones se ejecuta el script `src/main/resources/dbinit/data.sql` en la base de datos (útil para datos de desarrollo). Activar con:

```bash
./gradlew bootRun --args='--spring.profiles.active=local'
```

### Ejecutar tests

```bash
./gradlew test
```

### Ejecutar cambios de esquema eliminando la base de datos antes

```bash
./gradlew bootRun --args='--spring.liquibase.dropFirst=true
```

## Convenciones del proyecto

- **IDs de changeset**: `{descripcion}-v{major}.{minor}.{patch}`
- **Autor**: correo con formato `@gmail.com`
- **tagDatabase**: primer cambio en cada changeset, tag igual al ID
- **Rollback**: obligatorio en cada changeset
- **Nombres**: snake_case, tablas en singular
- **Claves foráneas**: `fk_{tabla_actual}_{tabla_referenciada}`

Ver `.cursor/skills/liquibase-change-types/SKILL.md` para detalles completos sobre tipos de cambio y patrones de rollback.

## Diagrama ER

Un diagrama del modelo entidad-relación está disponible en `src/main/resources/db/model.html`.

```bash
make show-diagram
```

## Issues 
### Postgres Connection Issue

```text
FATAL: password authentication failed for user "postgres"
```
When `docker-compose.yaml` and `application.yaml` tienen la misma configuraciones de user, password y database name pero no es posible conectarse mediante `jdbc:postgresql://localhost:5432/postgres` se debe revisar la IP que entrega `colima status`

```bash
➜  liquibase git:(main) ✗ colima status    


INFO[0000] colima is running using macOS Virtualization.Framework 
INFO[0000] arch: aarch64                                
INFO[0000] runtime: docker                              
INFO[0000] mountType: virtiofs                          
INFO[0000] address: 192.168.64.2 ## IP Colima                        
INFO[0000] docker socket: unix:///Users/guspersonal/.colima/default/docker.sock 
INFO[0000] containerd socket: unix:///Users/guspersonal/.colima/default/containerd.sock 
```

Connectar a la instancia de base de datos utilizando `jdbc:postgresql://192.168.64.2:5432/heygarzon`