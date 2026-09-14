package controller;

import config.SupabaseConfig;
import dao.MaterialDAO;
import filter.RoleFilter;
import model.Material;
import model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DeleteMaterialServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DeleteMaterialServlet.class.getName());
    private final MaterialDAO materialDAO = new MaterialDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Usuario usuario = RoleFilter.getUsuarioSesion(req);
        String idParam  = req.getParameter("id");
        String origen   = req.getParameter("origen");

        if (idParam == null || idParam.isBlank()) { redirigir(resp, req, origen, null, "id_requerido"); return; }

        int materialId;
        try { materialId = Integer.parseInt(idParam.trim()); }
        catch (NumberFormatException e) { redirigir(resp, req, origen, null, "id_invalido"); return; }

        Material material = materialDAO.buscarPorId(materialId);
        if (material == null) { redirigir(resp, req, origen, null, "material_no_encontrado"); return; }

        // Validación de permisos en el servidor
        if (!RoleFilter.tienePermiso(req, material.getUsuarioId())) {
            LOGGER.warning("Acceso denegado. Usuario=" + usuario.getId() + " | Dueño=" + material.getUsuarioId());
            redirigir(resp, req, origen, material.getSemanaId(), "sin_permiso"); return;
        }

        try { SupabaseConfig.deleteFile(material.getStoragePath()); }
        catch (Exception e) { LOGGER.log(Level.WARNING, "No se pudo eliminar de Storage", e); }

        boolean ok = materialDAO.eliminar(materialId);
        if (ok) redirigirExito(resp, req, origen, material.getSemanaId());
        else    redirigir(resp, req, origen, material.getSemanaId(), "error_eliminar");
    }

    private void redirigir(HttpServletResponse resp, HttpServletRequest req,
                           String origen, Integer semanaId, String error) throws IOException {
        String base = req.getContextPath();
        if ("perfil".equals(origen))       resp.sendRedirect(base + "/perfil?error=" + error);
        else if ("admin".equals(origen))   resp.sendRedirect(base + "/administracion?error=" + error);
        else if (semanaId != null)         resp.sendRedirect(base + "/semanas?id=" + semanaId + "&error=" + error);
        else                               resp.sendRedirect(base + "/materiales?error=" + error);
    }

    private void redirigirExito(HttpServletResponse resp, HttpServletRequest req,
                                String origen, Integer semanaId) throws IOException {
        String base = req.getContextPath();
        if ("perfil".equals(origen))       resp.sendRedirect(base + "/perfil?exito=material_eliminado");
        else if ("admin".equals(origen))   resp.sendRedirect(base + "/administracion?exito=material_eliminado");
        else if (semanaId != null)         resp.sendRedirect(base + "/semanas?id=" + semanaId + "&exito=material_eliminado");
        else                               resp.sendRedirect(base + "/materiales?exito=material_eliminado");
    }
}
