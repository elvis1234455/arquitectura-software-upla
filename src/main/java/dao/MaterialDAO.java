package dao;

import config.DatabaseConfig;
import model.Material;

import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class MaterialDAO {

    private static final Logger LOGGER = Logger.getLogger(MaterialDAO.class.getName());

    private static final String SELECT_BASE =
        "SELECT m.*, u.nombre AS nombre_usuario, u.correo AS correo_usuario, " +
        "s.numero AS numero_semana, s.titulo AS titulo_semana " +
        "FROM materiales m JOIN usuarios u ON u.id = m.usuario_id JOIN semanas s ON s.id = m.semana_id";

    public int insertar(Material material) {
        String sql = "INSERT INTO materiales (semana_id, usuario_id, nombre, nombre_original, tipo, extension, mime_type, tamano, storage_path, url, descripcion, fecha_subida) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW()) RETURNING id";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, material.getSemanaId());
            ps.setInt(2, material.getUsuarioId());
            ps.setString(3, material.getNombre());
            ps.setString(4, material.getNombreOriginal());
            ps.setString(5, material.getTipo());
            ps.setString(6, material.getExtension());
            ps.setString(7, material.getMimeType());
            ps.setLong(8, material.getTamano());
            ps.setString(9, material.getStoragePath());
            ps.setString(10, material.getUrl());
            ps.setString(11, material.getDescripcion());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al insertar material", e);
        }
        return -1;
    }

    public Material buscarPorId(int id) {
        String sql = SELECT_BASE + " WHERE m.id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al buscar material por id", e);
        }
        return null;
    }

    public List<Material> listarPorSemana(int semanaId) {
        String sql = SELECT_BASE + " WHERE m.semana_id = ? ORDER BY m.fecha_subida DESC";
        List<Material> lista = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, semanaId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar materiales de semana", e);
        }
        return lista;
    }

    public List<Material> listarPorUsuario(int usuarioId) {
        String sql = SELECT_BASE + " WHERE m.usuario_id = ? ORDER BY m.fecha_subida DESC";
        List<Material> lista = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar materiales de usuario", e);
        }
        return lista;
    }

    public List<Material> buscar(String nombre, Integer semanaId, Integer usuarioId,
                                  String tipo, String fechaDesde, String fechaHasta) {
        StringBuilder sql = new StringBuilder(SELECT_BASE + " WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (nombre != null && !nombre.isBlank()) {
            sql.append(" AND LOWER(m.nombre_original) LIKE LOWER(?)");
            params.add("%" + nombre.trim() + "%");
        }
        if (semanaId != null)  { sql.append(" AND m.semana_id = ?");  params.add(semanaId); }
        if (usuarioId != null) { sql.append(" AND m.usuario_id = ?"); params.add(usuarioId); }
        if (tipo != null && !tipo.isBlank()) { sql.append(" AND m.tipo = ?"); params.add(tipo.toUpperCase()); }
        if (fechaDesde != null && !fechaDesde.isBlank()) { sql.append(" AND m.fecha_subida >= ?::date"); params.add(fechaDesde); }
        if (fechaHasta != null && !fechaHasta.isBlank()) { sql.append(" AND m.fecha_subida <= (?::date + INTERVAL '1 day')"); params.add(fechaHasta); }
        sql.append(" ORDER BY m.fecha_subida DESC");
        List<Material> lista = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al buscar materiales", e);
        }
        return lista;
    }

    public List<Material> listarTodos() {
        String sql = SELECT_BASE + " ORDER BY m.fecha_subida DESC";
        List<Material> lista = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar todos los materiales", e);
        }
        return lista;
    }

    public int contarTodos() {
        String sql = "SELECT COUNT(*) FROM materiales";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al contar materiales", e);
        }
        return 0;
    }

    public int contarPorTipo(String tipo) {
        String sql = "SELECT COUNT(*) FROM materiales WHERE tipo = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tipo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al contar por tipo", e);
        }
        return 0;
    }

    public int contarPorUsuario(int usuarioId) {
        String sql = "SELECT COUNT(*) FROM materiales WHERE usuario_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al contar por usuario", e);
        }
        return 0;
    }

    public Map<String, Integer> estadisticasPorTipo() {
        String sql = "SELECT tipo, COUNT(*) AS total FROM materiales GROUP BY tipo ORDER BY total DESC";
        Map<String, Integer> stats = new LinkedHashMap<>();
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) stats.put(rs.getString("tipo"), rs.getInt("total"));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al obtener estadísticas", e);
        }
        return stats;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM materiales WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al eliminar material", e);
            return false;
        }
    }

    public List<String> obtenerStoragePathsPorSemana(int semanaId) {
        String sql = "SELECT storage_path FROM materiales WHERE semana_id = ?";
        List<String> paths = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, semanaId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) paths.add(rs.getString("storage_path"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al obtener paths", e);
        }
        return paths;
    }

    public boolean eliminarPorSemana(int semanaId) {
        String sql = "DELETE FROM materiales WHERE semana_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, semanaId);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al eliminar materiales de semana", e);
            return false;
        }
    }

    private Material mapear(ResultSet rs) throws SQLException {
        Material m = new Material();
        m.setId(rs.getInt("id"));
        m.setSemanaId(rs.getInt("semana_id"));
        m.setUsuarioId(rs.getInt("usuario_id"));
        m.setNombre(rs.getString("nombre"));
        m.setNombreOriginal(rs.getString("nombre_original"));
        m.setTipo(rs.getString("tipo"));
        m.setExtension(rs.getString("extension"));
        m.setMimeType(rs.getString("mime_type"));
        m.setTamano(rs.getLong("tamano"));
        m.setStoragePath(rs.getString("storage_path"));
        m.setUrl(rs.getString("url"));
        m.setDescripcion(rs.getString("descripcion"));
        Timestamp ts = rs.getTimestamp("fecha_subida");
        if (ts != null) m.setFechaSubida(ts.toLocalDateTime());
        m.setNombreUsuario(rs.getString("nombre_usuario"));
        m.setCorreoUsuario(rs.getString("correo_usuario"));
        m.setNumeroSemana(rs.getInt("numero_semana"));
        m.setTituloSemana(rs.getString("titulo_semana"));
        return m;
    }
}
