package model;

import java.time.LocalDateTime;

public class Usuario {
    private int id;
    private String authId;
    private String nombre;
    private String correo;
    private String rol;
    private String avatarUrl;
    private boolean activo;
    private LocalDateTime fechaCreacion;

    public Usuario() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getAuthId() { return authId; }
    public void setAuthId(String authId) { this.authId = authId; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public boolean isActivo() { return activo; }
    public void setActivo(boolean activo) { this.activo = activo; }

    public LocalDateTime getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(LocalDateTime fechaCreacion) { this.fechaCreacion = fechaCreacion; }

    public boolean isAdmin() {
        return "ADMINISTRADOR".equalsIgnoreCase(this.rol);
    }

    public String getFechaCreacionStr() {
        if (fechaCreacion == null) return "-";
        return String.format("%02d/%02d/%04d",
                fechaCreacion.getDayOfMonth(),
                fechaCreacion.getMonthValue(),
                fechaCreacion.getYear());
    }
}
