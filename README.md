# EduPlatform — Plataforma Educativa Universitaria

Plataforma web para organizar y compartir los materiales de un curso universitario por semanas. Desarrollada con Java, JSP, Servlets, Maven y Apache Tomcat. Usa PostgreSQL (Supabase) como base de datos, Supabase Auth para autenticación y Supabase Storage para archivos.

---

## Tecnologías

| Tecnología | Uso |
|---|---|
| Java 11 | Lógica del servidor |
| JSP + Servlets | Vistas y controladores (MVC) |
| Maven | Gestión de dependencias y build |
| Apache Tomcat 10 | Servidor de aplicaciones |
| PostgreSQL (Supabase) | Base de datos |
| Supabase Auth | Autenticación de usuarios |
| Supabase Storage | Almacenamiento de archivos |
| HTML5 + CSS3 + JS | Frontend responsive |
| Font Awesome 6 | Iconografía |

---

## Requisitos

- JDK 11 o superior
- Maven 3.6+
- Apache Tomcat 10.x
- Cuenta en [Supabase](https://supabase.com)

---

## Configuración de Supabase

### 1. Base de datos

Ejecuta el archivo `database.sql` en el SQL Editor de tu proyecto Supabase. Este crea las tablas `usuarios`, `semanas` y `materiales`, con índices y datos de ejemplo (16 semanas).

### 2. Storage

- Crea un bucket llamado `materiales` en Supabase Storage.
- Configura las políticas RLS según tu caso (o desactívalas si usas `SERVICE_KEY` solo en el backend).

### 3. Autenticación

- Habilita el proveedor **Email/Password** en Supabase Auth → Providers.
- Crea los usuarios desde el panel de Supabase (Auth → Users).
- Para dar rol de ADMINISTRADOR a un usuario, ejecuta en SQL:
  ```sql
  UPDATE usuarios SET rol = 'ADMINISTRADOR' WHERE correo = 'admin@ejemplo.com';
  ```

---

## Variables de entorno

Configura estas variables en el entorno donde corre Tomcat (o como `-D` en `CATALINA_OPTS`):

| Variable | Descripción |
|---|---|
| `SUPABASE_URL` | URL de tu proyecto, ej: `https://xxxx.supabase.co` |
| `SUPABASE_ANON_KEY` | Clave pública anon/public |
| `SUPABASE_SERVICE_KEY` | **Service Role Key** (solo en backend, nunca en frontend) |
| `SUPABASE_BUCKET` | Nombre del bucket (default: `materiales`) |
| `SUPABASE_DB_HOST` | Host de la BD, ej: `db.xxxx.supabase.co` |
| `SUPABASE_DB_PORT` | Puerto (default: `5432`) |
| `SUPABASE_DB_NAME` | Nombre de la BD (default: `postgres`) |
| `SUPABASE_DB_USER` | Usuario de la BD (default: `postgres`) |
| `SUPABASE_DB_PASSWORD` | Contraseña de la BD de Supabase |

### Forma recomendada — `setenv.sh` / `setenv.bat` de Tomcat

**Linux/Mac** (`$TOMCAT_HOME/bin/setenv.sh`):
```bash
export SUPABASE_URL="https://xxxx.supabase.co"
export SUPABASE_ANON_KEY="eyJ..."
export SUPABASE_SERVICE_KEY="eyJ..."
export SUPABASE_BUCKET="materiales"
export SUPABASE_DB_HOST="db.xxxx.supabase.co"
export SUPABASE_DB_PORT="5432"
export SUPABASE_DB_NAME="postgres"
export SUPABASE_DB_USER="postgres"
export SUPABASE_DB_PASSWORD="tu_password"
```

**Windows** (`%TOMCAT_HOME%\bin\setenv.bat`):
```bat
set SUPABASE_URL=https://xxxx.supabase.co
set SUPABASE_ANON_KEY=eyJ...
set SUPABASE_SERVICE_KEY=eyJ...
set SUPABASE_BUCKET=materiales
set SUPABASE_DB_HOST=db.xxxx.supabase.co
set SUPABASE_DB_PORT=5432
set SUPABASE_DB_NAME=postgres
set SUPABASE_DB_USER=postgres
set SUPABASE_DB_PASSWORD=tu_password
```

---

## Instalación y ejecución

```bash
# 1. Clonar el repositorio
git clone https://github.com/tu-usuario/plataforma-educativa.git
cd plataforma-educativa

# 2. Compilar y empaquetar
mvn clean package

# 3. Copiar el WAR a Tomcat
cp target/plataforma-educativa.war $TOMCAT_HOME/webapps/

# 4. Iniciar Tomcat
$TOMCAT_HOME/bin/startup.sh   # Linux/Mac
# o
%TOMCAT_HOME%\bin\startup.bat # Windows

# 5. Abrir en el navegador
# http://localhost:8080/plataforma-educativa
```

---

## Estructura del proyecto

```
src/
└── main/
    ├── java/
    │   ├── config/       DatabaseConfig.java, SupabaseConfig.java
    │   ├── model/        Usuario.java, Semana.java, Material.java
    │   ├── dao/          UsuarioDAO.java, SemanaDAO.java, MaterialDAO.java
    │   ├── filter/       AuthFilter.java, RoleFilter.java
    │   └── controller/   LoginServlet.java, DashboardServlet.java, SemanaServlet.java,
    │                     MaterialServlet.java, UploadServlet.java, DownloadServlet.java,
    │                     DeleteMaterialServlet.java, UsuarioServlet.java, PerfilServlet.java,
    │                     LogoutServlet.java
    └── webapp/
        ├── WEB-INF/
        │   ├── views/    login.jsp, dashboard.jsp, semanas.jsp, semana-detalle.jsp,
        │   │             materiales.jsp, perfil.jsp, administracion.jsp, error.jsp, sidebar.jsp
        │   └── web.xml
        ├── css/          login.css, dashboard.css, semanas.css, materiales.css,
        │                 perfil.css, admin.css, responsive.css
        ├── js/           app.js, login.js, dashboard.js, semanas.js, materiales.js
        └── images/
```

---

## Roles del sistema

| Rol | Permisos |
|---|---|
| **ADMINISTRADOR** | Todo: crear/editar/eliminar semanas, gestionar usuarios, ver estadísticas, eliminar cualquier material |
| **USUARIO** | Ver semanas, subir materiales, descargar, eliminar solo sus propios archivos, ver perfil |

---

## Flujo de uso

1. El usuario inicia sesión → Supabase Auth valida credenciales
2. El sistema hace upsert del usuario en la tabla `usuarios`
3. Se redirige al **Dashboard** con presentación del curso
4. El usuario navega por **Semanas** y accede al detalle de cada una
5. Puede **subir** archivos (guardados en Supabase Storage, metadatos en PostgreSQL)
6. Puede **descargar** archivos mediante URL firmada (5 min de expiración)
7. Puede **eliminar** solo sus propios archivos (o todos, si es ADMINISTRADOR)

---

## Seguridad

- Las contraseñas son manejadas exclusivamente por Supabase Auth (nunca en PostgreSQL)
- La `SERVICE_KEY` solo reside en el backend (variables de entorno), nunca en JSP ni JS
- El control de permisos se valida en los Servlets del servidor, no solo en el frontend
- Las sesiones expiran en 60 minutos
- Las URLs de descarga son firmadas y expiran en 5 minutos

---

## Licencia

MIT
