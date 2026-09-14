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

public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
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
            String respuestaAuth = SupabaseConfig.signIn(correo.trim(), contrasena);
            JsonObject jsonAuth  = JsonParser.parseString(respuestaAuth).getAsJsonObject();

            if (jsonAuth.has("error") || !jsonAuth.has("access_token")) {
                String msg = jsonAuth.has("error_description")
                        ? jsonAuth.get("error_description").getAsString()
                        : "Credenciales incorrectas. Verifica tu correo y contraseña.";
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

            LOGGER.info("Login intento - authId=" + authId + " email=" + email);

            Usuario usuario = usuarioDAO.upsertDesdeAuth(authId, email, nombre);
            LOGGER.info("upsertDesdeAuth resultado: " + (usuario != null ? usuario.getId() : "NULL"));

            // Fallback: si upsert falla, buscar por correo
            if (usuario == null) {
                LOGGER.warning("upsertDesdeAuth falló para authId=" + authId + ", buscando por correo...");
                usuario = usuarioDAO.buscarPorCorreo(email);
                LOGGER.info("buscarPorCorreo resultado: " + (usuario != null ? usuario.getId() : "NULL"));
                // Si existe por correo, actualizar su auth_id
                if (usuario != null) {
                    usuarioDAO.actualizarAuthId(usuario.getId(), authId);
                    usuario.setAuthId(authId);
                    LOGGER.info("Usuario encontrado por correo, auth_id actualizado.");
                }
            }

            if (usuario == null) {
                req.setAttribute("error", "Error al recuperar datos del usuario. Intenta de nuevo.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }

            if (!usuario.isActivo()) {
                req.setAttribute("error", "Tu cuenta está desactivada. Contacta al administrador.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession(true);
            session.setAttribute("usuario", usuario);
            session.setAttribute("accessToken", accessToken);
            session.setMaxInactiveInterval(3600);

            String urlOriginal = (String) session.getAttribute("urlOriginal");
            if (urlOriginal != null && !urlOriginal.contains("/login")) {
                session.removeAttribute("urlOriginal");
                resp.sendRedirect(urlOriginal);
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error en login", e);
            req.setAttribute("error", "Error del servidor. Intenta nuevamente.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }
}
