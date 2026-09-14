package controller;

import dao.MaterialDAO;
import dao.UsuarioDAO;
import filter.RoleFilter;
import model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class PerfilServlet extends HttpServlet {

    private final UsuarioDAO  usuarioDAO  = new UsuarioDAO();
    private final MaterialDAO materialDAO = new MaterialDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Usuario usuario = RoleFilter.getUsuarioSesion(req);
        Usuario fresco  = usuarioDAO.buscarPorId(usuario.getId());
        if (fresco != null) {
            HttpSession session = req.getSession(false);
            if (session != null) session.setAttribute("usuario", fresco);
            usuario = fresco;
        }

        List<?> mis = materialDAO.listarPorUsuario(usuario.getId());
        req.setAttribute("usuarioPerfil",   usuario);
        req.setAttribute("misMateriales",   mis);
        req.setAttribute("totalMateriales", mis.size());
        req.getRequestDispatcher("/WEB-INF/views/perfil.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if ("actualizar".equals(req.getParameter("accion"))) {
            Usuario usuario = RoleFilter.getUsuarioSesion(req);
            String nombre = req.getParameter("nombre");
            if (nombre == null || nombre.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/perfil?error=nombre_requerido"); return;
            }
            usuario.setNombre(nombre.trim());
            boolean ok = usuarioDAO.actualizar(usuario);
            if (ok) {
                HttpSession session = req.getSession(false);
                if (session != null) session.setAttribute("usuario", usuario);
            }
            resp.sendRedirect(req.getContextPath() + "/perfil?exito=" + (ok ? "nombre_actualizado" : "error_actualizar"));
        } else {
            resp.sendRedirect(req.getContextPath() + "/perfil");
        }
    }
}
