package controller;

import dao.MaterialDAO;
import dao.SemanaDAO;
import dao.UsuarioDAO;
import filter.RoleFilter;
import model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class UsuarioServlet extends HttpServlet {

    private final UsuarioDAO  usuarioDAO  = new UsuarioDAO();
    private final SemanaDAO   semanaDAO   = new SemanaDAO();
    private final MaterialDAO materialDAO = new MaterialDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!RoleFilter.esAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/dashboard?error=sin_permiso"); return;
        }

        req.setAttribute("usuarios",        usuarioDAO.listarTodos());
        req.setAttribute("semanas",         semanaDAO.listarTodas());
        req.setAttribute("statsMateriales", materialDAO.estadisticasPorTipo());
        req.setAttribute("totalUsuarios",   usuarioDAO.contarTodos());
        req.setAttribute("totalSemanas",    semanaDAO.contarTodas());
        req.setAttribute("totalMateriales", materialDAO.contarTodos());
        req.setAttribute("totalPDFs",       materialDAO.contarPorTipo("PDF"));
        req.setAttribute("totalImagenes",   materialDAO.contarPorTipo("IMAGE"));
        req.setAttribute("totalDocumentos", materialDAO.contarPorTipo("WORD") +
                                            materialDAO.contarPorTipo("EXCEL") +
                                            materialDAO.contarPorTipo("POWERPOINT"));

        req.getRequestDispatcher("/WEB-INF/views/administracion.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!RoleFilter.esAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/dashboard?error=sin_permiso"); return;
        }

        String accion = req.getParameter("accion");
        if (accion == null) accion = "";
        switch (accion) {
            case "editarUsuario" -> editarUsuario(req, resp);
            case "cambiarEstado" -> cambiarEstado(req, resp);
            default              -> resp.sendRedirect(req.getContextPath() + "/administracion");
        }
    }

    private void editarUsuario(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int    id     = parseInt(req.getParameter("id"), 0);
        String nombre = trim(req.getParameter("nombre"));
        String rol    = trim(req.getParameter("rol"));

        if (id <= 0 || nombre.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/administracion?error=datos_invalidos"); return;
        }
        if (!rol.equals("ADMINISTRADOR") && !rol.equals("USUARIO")) {
            resp.sendRedirect(req.getContextPath() + "/administracion?error=rol_invalido"); return;
        }
        Usuario sesion = RoleFilter.getUsuarioSesion(req);
        if (sesion != null && sesion.getId() == id && !rol.equals("ADMINISTRADOR")) {
            resp.sendRedirect(req.getContextPath() + "/administracion?error=no_auto_degradar"); return;
        }
        Usuario u = usuarioDAO.buscarPorId(id);
        if (u == null) { resp.sendRedirect(req.getContextPath() + "/administracion?error=usuario_no_encontrado"); return; }
        u.setNombre(nombre);
        u.setRol(rol);
        boolean ok = usuarioDAO.actualizar(u);
        resp.sendRedirect(req.getContextPath() + "/administracion?exito=" + (ok ? "usuario_actualizado" : "error_actualizar"));
    }

    private void cambiarEstado(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int     id     = parseInt(req.getParameter("id"), 0);
        boolean activo = "true".equalsIgnoreCase(req.getParameter("activo"));
        if (id <= 0) { resp.sendRedirect(req.getContextPath() + "/administracion?error=id_invalido"); return; }
        Usuario sesion = RoleFilter.getUsuarioSesion(req);
        if (sesion != null && sesion.getId() == id) {
            resp.sendRedirect(req.getContextPath() + "/administracion?error=no_auto_desactivar"); return;
        }
        boolean ok = usuarioDAO.cambiarEstado(id, activo);
        resp.sendRedirect(req.getContextPath() + "/administracion?exito=" +
                (ok ? (activo ? "usuario_activado" : "usuario_desactivado") : "error_estado"));
    }

    private int parseInt(String v, int def) {
        if (v == null || v.isBlank()) return def;
        try { return Integer.parseInt(v.trim()); } catch (NumberFormatException e) { return def; }
    }
    private String trim(String v) { return v != null ? v.trim() : ""; }
}
