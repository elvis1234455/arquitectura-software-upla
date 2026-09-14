package model;

import java.time.LocalDateTime;

public class Material {
    private int id;
    private int semanaId;
    private int usuarioId;
    private String nombre;
    private String nombreOriginal;
    private String tipo;
    private String extension;
    private String mimeType;
    private long tamano;
    private String storagePath;
    private String url;
    private String descripcion;
    private LocalDateTime fechaSubida;

    // Campos de JOIN
    private String nombreUsuario;
    private String correoUsuario;
    private int numeroSemana;
    private String tituloSemana;

    public Material() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getSemanaId() { return semanaId; }
    public void setSemanaId(int semanaId) { this.semanaId = semanaId; }

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getNombreOriginal() { return nombreOriginal; }
    public void setNombreOriginal(String nombreOriginal) { this.nombreOriginal = nombreOriginal; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public String getExtension() { return extension; }
    public void setExtension(String extension) { this.extension = extension; }

    public String getMimeType() { return mimeType; }
    public void setMimeType(String mimeType) { this.mimeType = mimeType; }

    public long getTamano() { return tamano; }
    public void setTamano(long tamano) { this.tamano = tamano; }

    public String getStoragePath() { return storagePath; }
    public void setStoragePath(String storagePath) { this.storagePath = storagePath; }

    public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public LocalDateTime getFechaSubida() { return fechaSubida; }
    public void setFechaSubida(LocalDateTime fechaSubida) { this.fechaSubida = fechaSubida; }

    public String getNombreUsuario() { return nombreUsuario; }
    public void setNombreUsuario(String nombreUsuario) { this.nombreUsuario = nombreUsuario; }

    public String getCorreoUsuario() { return correoUsuario; }
    public void setCorreoUsuario(String correoUsuario) { this.correoUsuario = correoUsuario; }

    public int getNumeroSemana() { return numeroSemana; }
    public void setNumeroSemana(int numeroSemana) { this.numeroSemana = numeroSemana; }

    public String getTituloSemana() { return tituloSemana; }
    public void setTituloSemana(String tituloSemana) { this.tituloSemana = tituloSemana; }

    public String getTamanoFormateado() {
        if (tamano < 1024) return tamano + " B";
        if (tamano < 1024 * 1024) return String.format("%.1f KB", tamano / 1024.0);
        return String.format("%.1f MB", tamano / (1024.0 * 1024));
    }

    public String getFechaSubidaStr() {
        if (fechaSubida == null) return "-";
        return String.format("%02d/%02d/%04d",
                fechaSubida.getDayOfMonth(),
                fechaSubida.getMonthValue(),
                fechaSubida.getYear());
    }

    public String getIconoClase() {
        if (tipo == null) return "fa-file";
        return switch (tipo.toUpperCase()) {
            case "PDF"        -> "fa-file-pdf";
            case "IMAGE"      -> "fa-file-image";
            case "WORD"       -> "fa-file-word";
            case "EXCEL"      -> "fa-file-excel";
            case "POWERPOINT" -> "fa-file-powerpoint";
            case "ZIP"        -> "fa-file-archive";
            case "TEXT"       -> "fa-file-alt";
            default           -> "fa-file";
        };
    }

    public String getColorClase() {
        if (tipo == null) return "type-other";
        return switch (tipo.toUpperCase()) {
            case "PDF"        -> "type-pdf";
            case "IMAGE"      -> "type-image";
            case "WORD"       -> "type-word";
            case "EXCEL"      -> "type-excel";
            case "POWERPOINT" -> "type-ppt";
            case "ZIP"        -> "type-zip";
            default           -> "type-other";
        };
    }

    public static String detectarTipo(String extension) {
        if (extension == null) return "OTHER";
        return switch (extension.toLowerCase()) {
            case "pdf"                          -> "PDF";
            case "jpg", "jpeg", "png", "gif",
                 "webp", "bmp"                  -> "IMAGE";
            case "doc", "docx"                  -> "WORD";
            case "xls", "xlsx"                  -> "EXCEL";
            case "ppt", "pptx"                  -> "POWERPOINT";
            case "txt"                          -> "TEXT";
            case "zip", "rar", "7z"             -> "ZIP";
            default                             -> "OTHER";
        };
    }
}
