package dao;

import config.DatabaseConfig;
import model.Usuario;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UsuarioDAO {

    private static final Logger LOGGER = Logger.getLogger(UsuarioDAO.class.getName());

    public boolean insertar(Usuario usuario) {
        String sql = "INSERT INTO usuarios (auth_id, nombre, correo, rol, avatar_url, activo, fecha_creacion) VALUES (?::uuid, ?, ?, ?, ?, ?, NOW())";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, usuario.getAuthId());
            ps.setString(2, usuario.getNombre());
            ps.setString(3, usuario.getCorreo());
            ps.setString(4, usuario.getRol() != null ? usuario.getRol() : "USUARIO");
            ps.setString(5, usuario.getAvatarUrl());
            ps.setBoolean(6, true);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al insertar usuario", e);
            return false;
        }
    }

    public Usuario buscarPorAuthId(String authId) {
        String sql = "SELECT * FROM usuarios WHERE auth_id = ?::uuid";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, authId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al buscar por authId", e);
        }
        return null;
    }

    public Usuario buscarPorCorreo(String correo) {
        String sql = "SELECT * FROM usuarios WHERE correo = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, correo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al buscar por correo", e);
        }
        return null;
    }

    public boolean actualizarAuthId(int id, String authId) {
        String sql = "UPDATE usuarios SET auth_id = ?::uuid WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, authId);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error al actualizar auth_id", e);
            return false;
        }
    }

    public Usuario buscarPorId(int id) {
        String sql = "SELECT * FROM usuarios WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al buscar por id", e);
        }
        return null;
    }

    public List<Usuario> listarTodos() {
        String sql = "SELECT * FROM usuarios ORDER BY fecha_creacion DESC";
        List<Usuario> lista = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar usuarios", e);
        }
        return lista;
    }

    public int contarTodos() {
        String sql = "SELECT COUNT(*) FROM usuarios";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al contar usuarios", e);
        }
        return 0;
    }

    public boolean actualizar(Usuario usuario) {
        String sql = "UPDATE usuarios SET nombre = ?, rol = ?, avatar_url = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getRol());
            ps.setString(3, usuario.getAvatarUrl());
            ps.setInt(4, usuario.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al actualizar usuario", e);
            return false;
        }
    }

    public boolean cambiarEstado(int id, boolean activo) {
        String sql = "UPDATE usuarios SET activo = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, activo);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al cambiar estado", e);
            return false;
        }
    }

    public Usuario upsertDesdeAuth(String authId, String correo, String nombre) {
        // Primero intentar encontrar por auth_id
        Usuario existente = buscarPorAuthId(authId);
        if (existente != null) {
            LOGGER.info("Usuario encontrado por authId: " + existente.getId());
            return existente;
        }
        // Intentar encontrar por correo
        Usuario porCorreo = buscarPorCorreo(correo);
        if (porCorreo != null) {
            LOGGER.info("Usuario encontrado por correo: " + porCorreo.getId() + ", actualizando authId");
            actualizarAuthId(porCorreo.getId(), authId);
            return porCorreo;
        }
        // Crear nuevo
        LOGGER.info("Creando nuevo usuario: " + correo);
        Usuario nuevo = new Usuario();
        nuevo.setAuthId(authId);
        nuevo.setCorreo(correo);
        nuevo.setNombre(nombre != null && !nombre.isBlank() ? nombre : correo.split("@")[0]);
        nuevo.setRol("USUARIO");
        nuevo.setActivo(true);
        if (insertar(nuevo)) return buscarPorCorreo(correo);
        LOGGER.severe("No se pudo insertar el usuario: " + correo);
        return null;
    }

    private Usuario mapear(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setId(rs.getInt("id"));
        u.setAuthId(rs.getString("auth_id"));
        u.setNombre(rs.getString("nombre"));
        u.setCorreo(rs.getString("correo"));
        u.setRol(rs.getString("rol"));
        u.setAvatarUrl(rs.getString("avatar_url"));
        u.setActivo(rs.getBoolean("activo"));
        Timestamp ts = rs.getTimestamp("fecha_creacion");
        if (ts != null) u.setFechaCreacion(ts.toLocalDateTime());
        return u;
    }
}
