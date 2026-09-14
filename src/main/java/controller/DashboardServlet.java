package controller;

import dao.MaterialDAO;
import dao.SemanaDAO;
import dao.UsuarioDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class DashboardServlet extends HttpServlet {

    private final SemanaDAO   semanaDAO   = new SemanaDAO();
    private final MaterialDAO materialDAO = new MaterialDAO();
    private final UsuarioDAO  usuarioDAO  = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("totalSemanas",    semanaDAO.contarTodas());
        req.setAttribute("totalMateriales", materialDAO.contarTodos());
        req.setAttribute("totalUsuarios",   usuarioDAO.contarTodos());
        req.setAttribute("totalPDFs",       materialDAO.contarPorTipo("PDF"));
        req.setAttribute("totalImagenes",   materialDAO.contarPorTipo("IMAGE"));
        req.setAttribute("totalDocumentos", materialDAO.contarPorTipo("WORD"));
        req.setAttribute("ultimasSemanas",  semanaDAO.listarTodas().stream().limit(3).toList());

        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
    }
}
