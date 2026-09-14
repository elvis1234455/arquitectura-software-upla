<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administración — EduPlatform</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<div class="main-content" id="mainContent">

    <header class="topbar">
        <button class="sidebar-toggle" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
        <div class="topbar-title"><h1><i class="fas fa-cogs"></i> Administración</h1></div>
    </header>

    <div class="page-content">

        <c:if test="${not empty param.exito}">
            <div class="toast toast-success" id="toastMsg"><i class="fas fa-check-circle"></i>
                <c:choose>
                    <c:when test="${param.exito eq 'usuario_actualizado'}">Usuario actualizado.</c:when>
                    <c:when test="${param.exito eq 'usuario_activado'}">Usuario activado.</c:when>
                    <c:when test="${param.exito eq 'usuario_desactivado'}">Usuario desactivado.</c:when>
                    <c:otherwise>Operación realizada.</c:otherwise>
                </c:choose>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="toast toast-error" id="toastMsg"><i class="fas fa-times-circle"></i>
                <c:choose>
                    <c:when test="${param.error eq 'no_auto_degradar'}">No puedes quitarte tus propios privilegios de administrador.</c:when>
                    <c:when test="${param.error eq 'no_auto_desactivar'}">No puedes desactivar tu propia cuenta.</c:when>
                    <c:otherwise>Ocurrió un error.</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- Tabs -->
        <div class="admin-tabs">
            <button class="tab-btn active" onclick="mostrarTab('tabEstadisticas', this)"><i class="fas fa-chart-bar"></i> Estadísticas</button>
            <button class="tab-btn" onclick="mostrarTab('tabUsuarios', this)"><i class="fas fa-users"></i> Usuarios</button>
            <button class="tab-btn" onclick="mostrarTab('tabSemanas', this)"><i class="fas fa-calendar-week"></i> Semanas</button>
        </div>

        <!-- Tab Estadísticas -->
        <div class="tab-content active" id="tabEstadisticas">
            <div class="stats-grid-admin">
                <div class="stat-card-admin stat-blue"><div class="sca-icon"><i class="fas fa-users"></i></div><div class="sca-info"><span class="sca-value">${totalUsuarios}</span><span class="sca-label">Usuarios</span></div></div>
                <div class="stat-card-admin stat-green"><div class="sca-icon"><i class="fas fa-calendar-week"></i></div><div class="sca-info"><span class="sca-value">${totalSemanas}</span><span class="sca-label">Semanas</span></div></div>
                <div class="stat-card-admin stat-purple"><div class="sca-icon"><i class="fas fa-file-alt"></i></div><div class="sca-info"><span class="sca-value">${totalMateriales}</span><span class="sca-label">Materiales</span></div></div>
                <div class="stat-card-admin stat-red"><div class="sca-icon"><i class="fas fa-file-pdf"></i></div><div class="sca-info"><span class="sca-value">${totalPDFs}</span><span class="sca-label">PDFs</span></div></div>
                <div class="stat-card-admin stat-cyan"><div class="sca-icon"><i class="fas fa-file-image"></i></div><div class="sca-info"><span class="sca-value">${totalImagenes}</span><span class="sca-label">Imágenes</span></div></div>
                <div class="stat-card-admin stat-orange"><div class="sca-icon"><i class="fas fa-file-word"></i></div><div class="sca-info"><span class="sca-value">${totalDocumentos}</span><span class="sca-label">Documentos</span></div></div>
            </div>
            <c:if test="${not empty statsMateriales}">
            <div class="section-card">
                <div class="section-card-header"><i class="fas fa-chart-pie"></i><h2>Distribución por tipo</h2></div>
                <div class="tipo-stats">
                    <c:forEach var="entry" items="${statsMateriales}">
                    <div class="tipo-stat-item">
                        <span class="tipo-label">${entry.key}</span>
                        <div class="tipo-bar-wrap"><div class="tipo-bar" style="width:${totalMateriales > 0 ? (entry.value * 100 / totalMateriales) : 0}%"></div></div>
                        <span class="tipo-count">${entry.value}</span>
                    </div>
                    </c:forEach>
                </div>
            </div>
            </c:if>
        </div>

        <!-- Tab Usuarios -->
        <div class="tab-content" id="tabUsuarios">
            <div class="section-header"><h2><i class="fas fa-users"></i> Gestión de Usuarios</h2></div>
            <div class="table-wrapper">
                <table class="admin-table">
                    <thead><tr><th>Usuario</th><th>Correo</th><th>Rol</th><th>Estado</th><th>Registro</th><th>Acciones</th></tr></thead>
                    <tbody>
                        <c:forEach var="u" items="${usuarios}">
                        <tr>
                            <td><div class="user-cell"><div class="user-avatar-sm">${u.nombre.substring(0,1).toUpperCase()}</div><span>${u.nombre}</span></div></td>
                            <td>${u.correo}</td>
                            <td><span class="badge badge-${u.rol.toLowerCase()}">${u.rol}</span></td>
                            <td><span class="badge ${u.activo ? 'badge-activo' : 'badge-inactivo'}">${u.activo ? 'Activo' : 'Inactivo'}</span></td>
                            <td>${u.fechaCreacionStr}</td>
                            <td class="td-actions">
                                <button class="btn-icon btn-edit" title="Editar"
                                    onclick="abrirModalEditarUsuario(${u.id},'${u.nombre}','${u.rol}')">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <form action="${pageContext.request.contextPath}/administracion" method="post" class="inline-form"
                                      onsubmit="return confirm('¿${u.activo ? 'Desactivar' : 'Activar'} a ${u.nombre}?')">
                                    <input type="hidden" name="accion" value="cambiarEstado">
                                    <input type="hidden" name="id" value="${u.id}">
                                    <input type="hidden" name="activo" value="${!u.activo}">
                                    <button type="submit" class="btn-icon ${u.activo ? 'btn-warning' : 'btn-success'}" title="${u.activo ? 'Desactivar' : 'Activar'}">
                                        <i class="fas ${u.activo ? 'fa-user-slash' : 'fa-user-check'}"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Tab Semanas -->
        <div class="tab-content" id="tabSemanas">
            <div class="section-header">
                <h2><i class="fas fa-calendar-week"></i> Gestión de Semanas</h2>
                <a href="${pageContext.request.contextPath}/semanas" class="btn-primary"><i class="fas fa-arrow-right"></i> Ir a Semanas</a>
            </div>
            <div class="table-wrapper">
                <table class="admin-table">
                    <thead><tr><th>Semana</th><th>Título</th><th>Materiales</th><th>Creado</th><th>Acciones</th></tr></thead>
                    <tbody>
                        <c:forEach var="s" items="${semanas}">
                        <tr>
                            <td><strong>${s.numeroFormateado}</strong></td>
                            <td>${s.titulo}</td>
                            <td><span class="badge badge-neutral">${s.cantidadMateriales}</span></td>
                            <td>${s.fechaCreacionStr}</td>
                            <td class="td-actions">
                                <a href="${pageContext.request.contextPath}/semanas?id=${s.id}" class="btn-icon btn-view" title="Ver"><i class="fas fa-eye"></i></a>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>

<!-- Modal: Editar Usuario -->
<div class="modal-overlay" id="modalEditarUsuario">
    <div class="modal modal-sm">
        <div class="modal-header">
            <h3><i class="fas fa-user-edit"></i> Editar Usuario</h3>
            <button class="modal-close" onclick="cerrarModal('modalEditarUsuario')"><i class="fas fa-times"></i></button>
        </div>
        <form action="${pageContext.request.contextPath}/administracion" method="post">
            <input type="hidden" name="accion" value="editarUsuario">
            <input type="hidden" name="id" id="editUserId">
            <div class="modal-body">
                <div class="form-group"><label>Nombre</label><input type="text" name="nombre" id="editUserName" class="form-input" required maxlength="100"></div>
                <div class="form-group">
                    <label>Rol</label>
                    <select name="rol" id="editUserRol" class="form-select">
                        <option value="USUARIO">USUARIO</option>
                        <option value="ADMINISTRADOR">ADMINISTRADOR</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="cerrarModal('modalEditarUsuario')">Cancelar</button>
                <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Guardar</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script>
function mostrarTab(tabId, btn) {
    document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.getElementById(tabId).classList.add('active');
    btn.classList.add('active');
}
function abrirModalEditarUsuario(id, nombre, rol) {
    document.getElementById('editUserId').value   = id;
    document.getElementById('editUserName').value = nombre;
    document.getElementById('editUserRol').value  = rol;
    abrirModal('modalEditarUsuario');
}
</script>
</body>
</html>
