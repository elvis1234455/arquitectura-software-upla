package controller;

import config.SupabaseConfig;
import dao.MaterialDAO;
import dao.SemanaDAO;
import filter.RoleFilter;
import model.Semana;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class SemanaServlet extends HttpServlet {

    private final SemanaDAO   semanaDAO   = new SemanaDAO();
    private final MaterialDAO materialDAO = new MaterialDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam != null) {
            mostrarDetalle(idParam, req, resp);
        } else {
            req.setAttribute("semanas", semanaDAO.listarTodas());
            req.getRequestDispatcher("/WEB-INF/views/semanas.jsp").forward(req, resp);
        }
    }

    private void mostrarDetalle(String idParam, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(idParam);
            Semana semana = semanaDAO.buscarPorId(id);
            if (semana == null) { resp.sendRedirect(req.getContextPath() + "/semanas?error=no_encontrada"); return; }
            req.setAttribute("semana", semana);
            req.setAttribute("materiales", materialDAO.listarPorSemana(id));
            req.getRequestDispatcher("/WEB-INF/views/semana-detalle.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/semanas?error=id_invalido");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!RoleFilter.esAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/dashboard?error=sin_permiso");
            return;
        }

        String accion = req.getParameter("accion");
        if (accion == null) accion = "";
        switch (accion) {
            case "crear"    -> crearSemana(req, resp);
            case "editar"   -> editarSemana(req, resp);
            case "eliminar" -> eliminarSemana(req, resp);
            default         -> resp.sendRedirect(req.getContextPath() + "/semanas");
        }
    }

    private void crearSemana(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        int    numero     = parseInt(req.getParameter("numero"), 0);
        String titulo     = trim(req.getParameter("titulo"));
        String descripcion = trim(req.getParameter("descripcion"));
        String contenido   = trim(req.getParameter("contenido"));

        if (numero <= 0 || titulo.isEmpty()) {
            req.setAttribute("semanas", semanaDAO.listarTodas());
            req.setAttribute("error", "El número y título son obligatorios.");
            req.getRequestDispatcher("/WEB-INF/views/semanas.jsp").forward(req, resp);
            return;
        }
        if (semanaDAO.existeNumero(numero)) {
            req.setAttribute("semanas", semanaDAO.listarTodas());
            req.setAttribute("error", "Ya existe la Semana " + numero + ".");
            req.getRequestDispatcher("/WEB-INF/views/semanas.jsp").forward(req, resp);
            return;
        }

        Semana s = new Semana();
        s.setNumero(numero); s.setTitulo(titulo); s.setDescripcion(descripcion); s.setContenido(contenido);
        int id = semanaDAO.insertar(s);
        resp.sendRedirect(req.getContextPath() + "/semanas?exito=" + (id > 0 ? "semana_creada" : "error_crear"));
    }

    private void editarSemana(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int    id         = parseInt(req.getParameter("id"), 0);
        int    numero     = parseInt(req.getParameter("numero"), 0);
        String titulo     = trim(req.getParameter("titulo"));
        String descripcion = trim(req.getParameter("descripcion"));
        String contenido   = trim(req.getParameter("contenido"));

        if (id <= 0 || numero <= 0 || titulo.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/semanas?error=datos_invalidos"); return;
        }
        if (semanaDAO.existeNumeroExcluyendo(numero, id)) {
            resp.sendRedirect(req.getContextPath() + "/semanas?error=numero_duplicado"); return;
        }
        Semana s = new Semana();
        s.setId(id); s.setNumero(numero); s.setTitulo(titulo); s.setDescripcion(descripcion); s.setContenido(contenido);
        boolean ok = semanaDAO.actualizar(s);
        resp.sendRedirect(req.getContextPath() + "/semanas?exito=" + (ok ? "semana_actualizada" : "error_actualizar"));
    }

    private void eliminarSemana(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = parseInt(req.getParameter("id"), 0);
        if (id <= 0) { resp.sendRedirect(req.getContextPath() + "/semanas?error=id_invalido"); return; }

        List<String> paths = materialDAO.obtenerStoragePathsPorSemana(id);
        for (String path : paths) {
            try { SupabaseConfig.deleteFile(path); }
            catch (Exception e) { getServletContext().log("No se pudo eliminar de Storage: " + path, e); }
        }
        materialDAO.eliminarPorSemana(id);
        boolean ok = semanaDAO.eliminar(id);
        resp.sendRedirect(req.getContextPath() + "/semanas?exito=" + (ok ? "semana_eliminada" : "error_eliminar"));
    }

    private int parseInt(String v, int def) {
        if (v == null || v.isBlank()) return def;
        try { return Integer.parseInt(v.trim()); } catch (NumberFormatException e) { return def; }
    }

    private String trim(String v) { return v != null ? v.trim() : ""; }
}
