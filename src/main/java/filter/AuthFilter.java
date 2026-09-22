package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Usuario;

import java.io.IOException;

/**
 * AuthFilter — Solo protege rutas administrativas/de modificación.
 * Las rutas de lectura (dashboard, semanas, materiales, download) son públicas.
 */
public class AuthFilter implements Filter {

    // Rutas que requieren ser ADMINISTRADOR autenticado
    private static final String[] RUTAS_ADMIN = {
        "/administracion",
        "/upload",
        "/deleteMaterial",
        "/perfil"
    };

    // Rutas completamente públicas (sin login)
    private static final String[] RUTAS_PUBLICAS = {
        "/login",
        "/logout",
        "/css/",
        "/js/",
        "/images/",
        "/dashboard",
        "/semanas",
        "/materiales",
        "/download"
    };

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // Siempre permitir recursos estáticos y rutas públicas
        if (esRutaPublica(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Raíz → redirigir al dashboard (público)
        if (path.equals("/") || path.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        // Rutas admin → requieren sesión de ADMINISTRADOR
        if (esRutaAdmin(path)) {
            HttpSession session = req.getSession(false);
            Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

            if (usuario == null) {
                resp.sendRedirect(req.getContextPath() + "/login?error=requiere_admin");
                return;
            }

            if (!usuario.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/dashboard?error=sin_permiso");
                return;
            }

            if (!usuario.isActivo()) {
                session.invalidate();
                resp.sendRedirect(req.getContextPath() + "/login?error=cuenta_inactiva");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    private boolean esRutaPublica(String path) {
        for (String ruta : RUTAS_PUBLICAS) {
            if (path.startsWith(ruta)) return true;
        }
        return false;
    }

    private boolean esRutaAdmin(String path) {
        for (String ruta : RUTAS_ADMIN) {
            if (path.startsWith(ruta)) return true;
        }
        return false;
    }
}
