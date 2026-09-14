package controller;

import config.SupabaseConfig;
import dao.MaterialDAO;
import dao.SemanaDAO;
import filter.RoleFilter;
import model.Material;
import model.Semana;
import model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@MultipartConfig(maxFileSize = 52_428_800, maxRequestSize = 55_000_000, fileSizeThreshold = 1_048_576)
public class UploadServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(UploadServlet.class.getName());
    private static final long MAX_SIZE = 52_428_800L;
    private static final Set<String> EXTENSIONES_OK = new HashSet<>(Arrays.asList(
        "pdf","jpg","jpeg","png","gif","doc","docx","xls","xlsx","ppt","pptx","txt","zip"
    ));

    private final MaterialDAO materialDAO = new MaterialDAO();
    private final SemanaDAO   semanaDAO   = new SemanaDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        Usuario usuario   = RoleFilter.getUsuarioSesion(req);
        String semanaIdStr = req.getParameter("semanaId");
        String descripcion = req.getParameter("descripcion");

        if (semanaIdStr == null || semanaIdStr.isBlank()) {
            redirigirError(resp, req, null, "Debes seleccionar una semana."); return;
        }

        int semanaId;
        try { semanaId = Integer.parseInt(semanaIdStr.trim()); }
        catch (NumberFormatException e) { redirigirError(resp, req, null, "Semana inválida."); return; }

        Semana semana = semanaDAO.buscarPorId(semanaId);
        if (semana == null) { redirigirError(resp, req, null, "La semana no existe."); return; }

        Part filePart = req.getPart("archivo");
        if (filePart == null || filePart.getSize() == 0) {
            redirigirError(resp, req, semanaId, "No se seleccionó ningún archivo."); return;
        }
        if (filePart.getSize() > MAX_SIZE) {
            redirigirError(resp, req, semanaId, "El archivo supera 50 MB."); return;
        }

        String nombreOriginal = obtenerNombreArchivo(filePart);
        if (nombreOriginal == null || nombreOriginal.isBlank()) {
            redirigirError(resp, req, semanaId, "Nombre de archivo inválido."); return;
        }

        String extension = obtenerExtension(nombreOriginal);
        if (!EXTENSIONES_OK.contains(extension.toLowerCase())) {
            redirigirError(resp, req, semanaId, "Tipo de archivo no permitido: ." + extension); return;
        }

        String mimeType    = filePart.getContentType() != null ? filePart.getContentType() : "application/octet-stream";
        String nombreUnico = UUID.randomUUID().toString().replace("-", "") + "." + extension;
        String storagePath = SupabaseConfig.buildStoragePath(semana.getNumero(), nombreUnico);

        try (InputStream is = filePart.getInputStream()) {
            SupabaseConfig.uploadFile(storagePath, is, mimeType, nombreUnico);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error subiendo a Storage", e);
            redirigirError(resp, req, semanaId, "Error al subir el archivo. Intenta nuevamente."); return;
        }

        Material m = new Material();
        m.setSemanaId(semanaId);
        m.setUsuarioId(usuario.getId());
        m.setNombre(nombreUnico);
        m.setNombreOriginal(nombreOriginal);
        m.setExtension(extension);
        m.setMimeType(mimeType);
        m.setTipo(Material.detectarTipo(extension));
        m.setTamano(filePart.getSize());
        m.setStoragePath(storagePath);
        m.setUrl(SupabaseConfig.getPublicUrl(storagePath));
        m.setDescripcion(descripcion != null ? descripcion.trim() : "");

        int id = materialDAO.insertar(m);
        if (id <= 0) {
            try { SupabaseConfig.deleteFile(storagePath); } catch (Exception ignored) {}
            redirigirError(resp, req, semanaId, "Error al registrar el material."); return;
        }

        resp.sendRedirect(req.getContextPath() + "/semanas?id=" + semanaId + "&exito=archivo_subido");
    }

    private String obtenerNombreArchivo(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null) return null;
        for (String token : header.split(";")) {
            if (token.trim().startsWith("filename")) {
                String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                int slash = Math.max(name.lastIndexOf('/'), name.lastIndexOf('\\'));
                return slash >= 0 ? name.substring(slash + 1) : name;
            }
        }
        return null;
    }

    private String obtenerExtension(String name) {
        int p = name.lastIndexOf('.');
        if (p < 0 || p == name.length() - 1) return "";
        return name.substring(p + 1).toLowerCase();
    }

    private void redirigirError(HttpServletResponse resp, HttpServletRequest req,
                                Integer semanaId, String msg) throws IOException {
        String enc = URLEncoder.encode(msg, StandardCharsets.UTF_8);
        if (semanaId != null) resp.sendRedirect(req.getContextPath() + "/semanas?id=" + semanaId + "&error=" + enc);
        else                  resp.sendRedirect(req.getContextPath() + "/semanas?error=" + enc);
    }
}
