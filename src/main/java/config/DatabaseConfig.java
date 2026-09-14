package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Conexión a PostgreSQL de Supabase usando el Connection Pooler (puerto 6543).
 * El pooler funciona tanto localmente como desde Render/cloud.
 *
 * Variables de entorno:
 *   SUPABASE_DB_HOST     - pooler host (ej: aws-0-ca-central-1.pooler.supabase.com)
 *   SUPABASE_DB_PORT     - 6543 (pooler) o 5432 (directo)
 *   SUPABASE_DB_NAME     - postgres
 *   SUPABASE_DB_USER     - postgres.xsiqrqctvqxnilqblvaq
 *   SUPABASE_DB_PASSWORD - contraseña del proyecto
 */
public class DatabaseConfig {

    private static final Logger LOGGER = Logger.getLogger(DatabaseConfig.class.getName());

    // Pooler de Supabase — funciona desde cualquier red incluyendo Render
    private static final String HOST     = getEnv("SUPABASE_DB_HOST",
            "aws-0-ca-central-1.pooler.supabase.com");
    private static final String PORT     = getEnv("SUPABASE_DB_PORT",     "6543");
    private static final String DB_NAME  = getEnv("SUPABASE_DB_NAME",     "postgres");
    private static final String USER     = getEnv("SUPABASE_DB_USER",
            "postgres.xsiqrqctvqxnilqblvaq");
    private static final String PASSWORD = getEnv("SUPABASE_DB_PASSWORD", "");

    private static final String JDBC_URL =
            "jdbc:postgresql://" + HOST + ":" + PORT + "/" + DB_NAME
            + "?sslmode=require";

    static {
        try {
            Class.forName("org.postgresql.Driver");
            LOGGER.info("PostgreSQL Driver cargado. URL: " + JDBC_URL.replace(PASSWORD, "***"));
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Driver PostgreSQL no encontrado", e);
            throw new ExceptionInInitializerError(e);
        }
    }

    private DatabaseConfig() {}

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, USER, PASSWORD);
    }

    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Fallo al probar conexión: " + e.getMessage(), e);
            return false;
        }
    }

    private static String getEnv(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value == null || value.isBlank()) value = System.getProperty(key, defaultValue);
        return value;
    }
}
