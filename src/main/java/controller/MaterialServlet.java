package controller;

import dao.MaterialDAO;
import dao.SemanaDAO;
import dao.UsuarioDAO;
import filter.RoleFilter;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class MaterialServlet extends HttpServlet {

    private final MaterialDAO materialDAO = new MaterialDAO();
    private final SemanaDAO   semanaDAO   = new SemanaDAO();
    private final UsuarioDAO  usuarioDAO  = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String nombre      = req.getParameter("nombre");
        String semanaIdStr = req.getParameter("semanaId");
        String usuarioIdStr = req.getParameter("usuarioId");
        String tipo        = req.getParameter("tipo");
        String fechaDesde  = req.getParameter("fechaDesde");
        String fechaHasta  = req.getParameter("fechaHasta");

        Integer semanaId  = parseIntOrNull(semanaIdStr);
        Integer usuarioId = parseIntOrNull(usuarioIdStr);

        req.setAttribute("materiales",      materialDAO.buscar(nombre, semanaId, usuarioId, tipo, fechaDesde, fechaHasta));
        req.setAttribute("semanas",         semanaDAO.listarTodas());
        req.setAttribute("usuarios",        RoleFilter.esAdmin(req) ? usuarioDAO.listarTodos() : java.util.List.of());
        req.setAttribute("filtroNombre",    nombre);
        req.setAttribute("filtroSemanaId",  semanaIdStr);
        req.setAttribute("filtroUsuarioId", usuarioIdStr);
        req.setAttribute("filtroTipo",      tipo);
        req.setAttribute("filtroFechaDesde",fechaDesde);
        req.setAttribute("filtroFechaHasta",fechaHasta);

        req.getRequestDispatcher("/WEB-INF/views/materiales.jsp").forward(req, resp);
    }

    private Integer parseIntOrNull(String v) {
        if (v == null || v.isBlank()) return null;
        try { return Integer.parseInt(v.trim()); } catch (NumberFormatException e) { return null; }
    }
}
