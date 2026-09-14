# ── Stage 1: Build con Maven ──────────────────────────────────
FROM maven:3.9.8-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
# Descargar dependencias primero (capa cacheada)
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests -B

# ── Stage 2: Runtime con Tomcat ───────────────────────────────
FROM tomcat:10.1.33-jdk17-temurin
LABEL maintainer="UPLA - Arquitectura de Software"

# Eliminar apps por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar el WAR generado como ROOT para que sea la app principal
COPY --from=build /app/target/plataforma-educativa.war \
     /usr/local/tomcat/webapps/ROOT.war

# Copiar configuración de Tomcat si existe
# (server.xml personalizado opcional)

# Puerto que usa Tomcat
EXPOSE 8080

# Iniciar Tomcat
CMD ["catalina.sh", "run"]
