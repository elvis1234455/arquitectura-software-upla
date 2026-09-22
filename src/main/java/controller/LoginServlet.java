package controller;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import config.SupabaseConfig;
import dao.UsuarioDAO;
import model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * LoginServlet — Solo acepta ADMINISTRADORES.
 * Los usuarios comunes acceden directamente sin login.
 */
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Si ya hay sesión de admin activa, redirigir al dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            Usuario u = (Usuario) session.getAttribute("usuario");
            if (u.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
                return;
            }
        }
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String correo     = req.getParameter("correo");
        String contrasena = req.getParameter("contrasena");

        if (correo == null || correo.isBlank() || contrasena == null || contrasena.isBlank()) {
            req.setAttribute("error", "Ingresa tu correo y contraseña.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        try {
            // 1. Autenticar con Supabase Auth
            String respuestaAuth = SupabaseConfig.signIn(correo.trim(), contrasena);
            JsonObject jsonAuth  = JsonParser.parseString(respuestaAuth).getAsJsonObject();

            if (jsonAuth.has("error") || !jsonAuth.has("access_token")) {
                String msg = jsonAuth.has("error_description")
                        ? jsonAuth.get("error_description").getAsString()
                        : "Credenciales incorrectas.";
                req.setAttribute("error", msg);
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }

            String accessToken   = jsonAuth.get("access_token").getAsString();
            String respuestaUser = SupabaseConfig.getUser(accessToken);
            JsonObject jsonUser  = JsonParser.parseString(respuestaUser).getAsJsonObject();

            String authId = jsonUser.get("id").getAsString();
            String email  = jsonUser.get("email").getAsString();
            String nombre = email.split("@")[0];
            if (jsonUser.has("user_metadata")) {
                JsonObject meta = jsonUser.getAsJsonObject("user_metadata");
                if (meta.has("full_name") && !meta.get("full_name").isJsonNull())
                    nombre = meta.get("full_name").getAsString();
                else if (meta.has("name") && !meta.get("name").isJsonNull())
                    nombre = meta.get("name").getAsString();
            }

            LOGGER.info("Login intento admin - authId=" + authId + " email=" + email);

            // 2. Buscar usuario en BD
            Usuario usuario = usuarioDAO.upsertDesdeAuth(authId, email, nombre);

            // Fallback por correo
            if (usuario == null) {
                LOGGER.warning("upsertDesdeAuth nulo, buscando por correo: " + email);
                usuario = usuarioDAO.buscarPorCorreo(email);
                if (usuario != null) {
                    usuarioDAO.actualizarAuthId(usuario.getId(), authId);
                }
            }

            if (usuario == null) {
                req.setAttribute("error", "No se encontró el usuario en el sistema.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }

            // 3. VERIFICAR QUE SEA ADMINISTRADOR — solo admins pueden entrar
            if (!usuario.isAdmin()) {
                req.setAttribute("error", "Acceso denegado. Solo los administradores pueden iniciar sesión.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }

            // 4. Verificar que esté activo
            if (!usuario.isActivo()) {
                req.setAttribute("error", "Tu cuenta está desactivada. Contacta al administrador.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }

            // 5. Crear sesión para el administrador
            HttpSession session = req.getSession(true);
            session.setAttribute("usuario", usuario);
            session.setAttribute("accessToken", accessToken);
            session.setMaxInactiveInterval(3600);

            LOGGER.info("Admin autenticado: " + email);
            resp.sendRedirect(req.getContextPath() + "/dashboard");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error en login admin: " + e.getClass().getName() + " - " + e.getMessage(), e);
            // Mostrar mensaje más descriptivo
            String errorMsg = "Error del servidor: " + e.getMessage();
            if (e.getMessage() != null && e.getMessage().contains("Connection")) {
                errorMsg = "Error de conexión a la base de datos. Intenta nuevamente.";
            } else if (e.getMessage() != null && e.getMessage().contains("password")) {
                errorMsg = "Error de autenticación con la base de datos.";
            }
            req.setAttribute("error", errorMsg);
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }
}
