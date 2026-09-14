package controller;

import config.SupabaseConfig;
import dao.MaterialDAO;
import model.Material;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DownloadServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DownloadServlet.class.getName());
    private static final int EXPIRACION = 300; // 5 minutos
    private final MaterialDAO materialDAO = new MaterialDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/materiales?error=id_requerido"); return;
        }

        int id;
        try { id = Integer.parseInt(idParam.trim()); }
        catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/materiales?error=id_invalido"); return;
        }

        Material material = materialDAO.buscarPorId(id);
        if (material == null) {
            resp.sendRedirect(req.getContextPath() + "/materiales?error=material_no_encontrado"); return;
        }

        // Usar URL pública directa del bucket (más confiable que signed URLs)
        String downloadUrl = material.getUrl();

        // Si la URL guardada no está, construirla desde el storage path
        if (downloadUrl == null || downloadUrl.isBlank()) {
            downloadUrl = SupabaseConfig.getPublicUrl(material.getStoragePath());
        }

        // Intentar signed URL como alternativa si la pública no funciona
        if (downloadUrl == null || downloadUrl.isBlank()) {
            try {
                downloadUrl = SupabaseConfig.createSignedUrl(material.getStoragePath(), EXPIRACION);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Signed URL también falló", e);
            }
        }

        if (downloadUrl != null && !downloadUrl.isBlank()) {
            resp.sendRedirect(downloadUrl);
        } else {
            LOGGER.severe("No se pudo obtener URL de descarga para material id: " + id);
            resp.sendRedirect(req.getContextPath() +
                    "/semanas?id=" + material.getSemanaId() + "&error=error_descarga");
        }
    }
}
