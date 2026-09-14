package config;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.apache.hc.client5.http.classic.methods.HttpDelete;
import org.apache.hc.client5.http.classic.methods.HttpGet;
import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.entity.mime.MultipartEntityBuilder;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.CloseableHttpResponse;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.ParseException;
import org.apache.hc.core5.http.io.entity.EntityUtils;
import org.apache.hc.core5.http.io.entity.StringEntity;

import java.io.IOException;
import java.io.InputStream;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Centraliza operaciones con Supabase Auth y Storage.
 *
 * Variables de entorno requeridas:
 *   SUPABASE_URL         - https://xxxx.supabase.co
 *   SUPABASE_ANON_KEY    - clave pública anon
 *   SUPABASE_SERVICE_KEY - Service Role Key (solo backend)
 *   SUPABASE_BUCKET      - nombre del bucket (default: materiales)
 */
public class SupabaseConfig {

    private static final Logger LOGGER = Logger.getLogger(SupabaseConfig.class.getName());

    public static final String SUPABASE_URL  = getEnv("SUPABASE_URL",         "https://YOUR_PROJECT_REF.supabase.co");
    public static final String ANON_KEY      = getEnv("SUPABASE_ANON_KEY",    "YOUR_ANON_KEY");
    public static final String SERVICE_KEY   = getEnv("SUPABASE_SERVICE_KEY", "YOUR_SERVICE_ROLE_KEY");
    public static final String BUCKET        = getEnv("SUPABASE_BUCKET",      "materiales");

    private static final String AUTH_URL    = SUPABASE_URL + "/auth/v1";
    private static final String STORAGE_URL = SUPABASE_URL + "/storage/v1";

    private SupabaseConfig() {}

    // ── Auth ──────────────────────────────────────────────────────────────────

    public static String signIn(String email, String password) throws IOException {
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            HttpPost post = new HttpPost(AUTH_URL + "/token?grant_type=password");
            post.setHeader("apikey", ANON_KEY);
            post.setHeader("Content-Type", "application/json");
            String body = "{\"email\":\"" + escapeJson(email) + "\",\"password\":\"" + escapeJson(password) + "\"}";
            post.setEntity(new StringEntity(body, ContentType.APPLICATION_JSON));
            try (CloseableHttpResponse resp = client.execute(post)) {
                return EntityUtils.toString(resp.getEntity());
            } catch (ParseException e) {
                throw new IOException("Error al parsear respuesta de Auth", e);
            }
        }
    }

    public static String getUser(String accessToken) throws IOException {
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            HttpGet get = new HttpGet(AUTH_URL + "/user");
            get.setHeader("apikey", ANON_KEY);
            get.setHeader("Authorization", "Bearer " + accessToken);
            try (CloseableHttpResponse resp = client.execute(get)) {
                return EntityUtils.toString(resp.getEntity());
            } catch (ParseException e) {
                throw new IOException("Error al parsear usuario", e);
            }
        }
    }

    // ── Storage ───────────────────────────────────────────────────────────────

    public static String uploadFile(String storagePath, InputStream fileStream,
                                    String contentType, String fileName) throws IOException {
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            String url = STORAGE_URL + "/object/" + BUCKET + "/" + storagePath;
            HttpPost post = new HttpPost(url);
            post.setHeader("apikey", SERVICE_KEY);
            post.setHeader("Authorization", "Bearer " + SERVICE_KEY);
            MultipartEntityBuilder builder = MultipartEntityBuilder.create();
            builder.addBinaryBody("file", fileStream, ContentType.create(contentType), fileName);
            post.setEntity(builder.build());
            try (CloseableHttpResponse resp = client.execute(post)) {
                int status = resp.getCode();
                String body = EntityUtils.toString(resp.getEntity());
                if (status >= 200 && status < 300) return body;
                throw new IOException("Error Storage. Status: " + status + " | " + body);
            } catch (ParseException e) {
                throw new IOException("Error al parsear respuesta de Storage", e);
            }
        }
    }

    public static boolean deleteFile(String storagePath) throws IOException {
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            HttpDelete delete = new HttpDelete(STORAGE_URL + "/object/" + BUCKET + "/" + storagePath);
            delete.setHeader("apikey", SERVICE_KEY);
            delete.setHeader("Authorization", "Bearer " + SERVICE_KEY);
            try (CloseableHttpResponse resp = client.execute(delete)) {
                return resp.getCode() >= 200 && resp.getCode() < 300;
            }
        }
    }

    public static String getPublicUrl(String storagePath) {
        return SUPABASE_URL + "/storage/v1/object/public/" + BUCKET + "/" + storagePath;
    }

    public static String createSignedUrl(String storagePath, int expiresInSeconds) throws IOException {
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            String url = STORAGE_URL + "/object/sign/" + BUCKET + "/" + storagePath;
            HttpPost post = new HttpPost(url);
            post.setHeader("apikey", SERVICE_KEY);
            post.setHeader("Authorization", "Bearer " + SERVICE_KEY);
            post.setHeader("Content-Type", "application/json");
            post.setEntity(new StringEntity("{\"expiresIn\":" + expiresInSeconds + "}", ContentType.APPLICATION_JSON));
            try (CloseableHttpResponse resp = client.execute(post)) {
                String responseBody = EntityUtils.toString(resp.getEntity());
                JsonObject json = JsonParser.parseString(responseBody).getAsJsonObject();
                if (json.has("signedURL")) return SUPABASE_URL + json.get("signedURL").getAsString();
                throw new IOException("No se obtuvo signed URL: " + responseBody);
            } catch (ParseException e) {
                throw new IOException("Error al parsear signed URL", e);
            }
        }
    }

    public static String buildStoragePath(int numeroSemana, String nombreArchivo) {
        return String.format("semana-%02d/%s", numeroSemana, nombreArchivo);
    }

    private static String escapeJson(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\").replace("\"", "\\\"")
                    .replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }

    private static String getEnv(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value == null || value.isBlank()) value = System.getProperty(key, defaultValue);
        return value;
    }
}
