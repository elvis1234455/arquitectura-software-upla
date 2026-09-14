package dao;

import config.DatabaseConfig;
import model.Semana;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SemanaDAO {

    private static final Logger LOGGER = Logger.getLogger(SemanaDAO.class.getName());

    public int insertar(Semana semana) {
        String sql = "INSERT INTO semanas (numero, titulo, descripcion, contenido, fecha_creacion, fecha_actualizacion) VALUES (?, ?, ?, ?, NOW(), NOW()) RETURNING id";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, semana.getNumero());
            ps.setString(2, semana.getTitulo());
            ps.setString(3, semana.getDescripcion());
            ps.setString(4, semana.getContenido());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al insertar semana", e);
        }
        return -1;
    }

    public List<Semana> listarTodas() {
        String sql = "SELECT s.*, COALESCE(COUNT(m.id), 0) AS cantidad_materiales FROM semanas s LEFT JOIN materiales m ON m.semana_id = s.id GROUP BY s.id ORDER BY s.numero ASC";
        List<Semana> lista = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar semanas", e);
        }
        return lista;
    }

    public Semana buscarPorId(int id) {
        String sql = "SELECT s.*, COALESCE(COUNT(m.id), 0) AS cantidad_materiales FROM semanas s LEFT JOIN materiales m ON m.semana_id = s.id WHERE s.id = ? GROUP BY s.id";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al buscar semana por id", e);
        }
        return null;
    }

    public int contarTodas() {
        String sql = "SELECT COUNT(*) FROM semanas";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al contar semanas", e);
        }
        return 0;
    }

    public boolean actualizar(Semana semana) {
        String sql = "UPDATE semanas SET numero = ?, titulo = ?, descripcion = ?, contenido = ?, fecha_actualizacion = NOW() WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, semana.getNumero());
            ps.setString(2, semana.getTitulo());
            ps.setString(3, semana.getDescripcion());
            ps.setString(4, semana.getContenido());
            ps.setInt(5, semana.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al actualizar semana", e);
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM semanas WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al eliminar semana", e);
            return false;
        }
    }

    public boolean existeNumero(int numero) {
        String sql = "SELECT 1 FROM semanas WHERE numero = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, numero);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al verificar numero", e);
        }
        return false;
    }

    public boolean existeNumeroExcluyendo(int numero, int excludeId) {
        String sql = "SELECT 1 FROM semanas WHERE numero = ? AND id <> ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, numero);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al verificar numero excluyendo", e);
        }
        return false;
    }

    private Semana mapear(ResultSet rs) throws SQLException {
        Semana s = new Semana();
        s.setId(rs.getInt("id"));
        s.setNumero(rs.getInt("numero"));
        s.setTitulo(rs.getString("titulo"));
        s.setDescripcion(rs.getString("descripcion"));
        s.setContenido(rs.getString("contenido"));
        try { s.setCantidadMateriales(rs.getInt("cantidad_materiales")); } catch (SQLException ignored) {}
        Timestamp tc = rs.getTimestamp("fecha_creacion");
        if (tc != null) s.setFechaCreacion(tc.toLocalDateTime());
        Timestamp ta = rs.getTimestamp("fecha_actualizacion");
        if (ta != null) s.setFechaActualizacion(ta.toLocalDateTime());
        return s;
    }
}
