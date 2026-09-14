package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Usuario;

import java.io.IOException;

public class AuthFilter implements Filter {

    private static final String[] RUTAS_PUBLICAS = { "/login", "/css/", "/js/", "/images/" };

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        if (esRutaPublica(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            String urlOriginal = req.getRequestURI();
            if (req.getQueryString() != null) urlOriginal += "?" + req.getQueryString();
            req.getSession(true).setAttribute("urlOriginal", urlOriginal);
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (!usuario.isActivo()) {
            session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login?error=cuenta_inactiva");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean esRutaPublica(String path) {
        for (String ruta : RUTAS_PUBLICAS) {
            if (path.startsWith(ruta)) return true;
        }
        return false;
    }
}
