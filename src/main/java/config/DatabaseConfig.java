package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Conexión a PostgreSQL de Supabase.
 *
 * Variables de entorno requeridas:
 *   SUPABASE_DB_HOST     - ej: db.xxxx.supabase.co
 *   SUPABASE_DB_PORT     - por defecto 5432
 *   SUPABASE_DB_NAME     - por defecto postgres
 *   SUPABASE_DB_USER     - por defecto postgres
 *   SUPABASE_DB_PASSWORD - contraseña de la BD
 */
public class DatabaseConfig {

    private static final Logger LOGGER = Logger.getLogger(DatabaseConfig.class.getName());

    private static final String HOST     = getEnv("SUPABASE_DB_HOST",     "db.YOUR_PROJECT_REF.supabase.co");
    private static final String PORT     = getEnv("SUPABASE_DB_PORT",     "5432");
    private static final String DB_NAME  = getEnv("SUPABASE_DB_NAME",     "postgres");
    private static final String USER     = getEnv("SUPABASE_DB_USER",     "postgres");
    private static final String PASSWORD = getEnv("SUPABASE_DB_PASSWORD", "");

    private static final String JDBC_URL =
            "jdbc:postgresql://" + HOST + ":" + PORT + "/" + DB_NAME + "?sslmode=require";

    static {
        try {
            Class.forName("org.postgresql.Driver");
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
            LOGGER.log(Level.SEVERE, "Fallo al probar conexión a la BD", e);
            return false;
        }
    }

    private static String getEnv(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value == null || value.isBlank()) value = System.getProperty(key, defaultValue);
        return value;
    }
}
