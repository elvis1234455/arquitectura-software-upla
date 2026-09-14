package model;

import java.time.LocalDateTime;

public class Semana {
    private int id;
    private int numero;
    private String titulo;
    private String descripcion;
    private String contenido;
    private int cantidadMateriales;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaActualizacion;

    public Semana() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getNumero() { return numero; }
    public void setNumero(int numero) { this.numero = numero; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public String getContenido() { return contenido; }
    public void setContenido(String contenido) { this.contenido = contenido; }

    public int getCantidadMateriales() { return cantidadMateriales; }
    public void setCantidadMateriales(int cantidadMateriales) { this.cantidadMateriales = cantidadMateriales; }

    public LocalDateTime getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(LocalDateTime fechaCreacion) { this.fechaCreacion = fechaCreacion; }

    public LocalDateTime getFechaActualizacion() { return fechaActualizacion; }
    public void setFechaActualizacion(LocalDateTime fechaActualizacion) { this.fechaActualizacion = fechaActualizacion; }

    public String getNumeroFormateado() {
        return String.format("Semana %02d", numero);
    }

    public String getFechaCreacionStr() {
        if (fechaCreacion == null) return "-";
        return String.format("%02d/%02d/%04d",
                fechaCreacion.getDayOfMonth(),
                fechaCreacion.getMonthValue(),
                fechaCreacion.getYear());
    }
}
