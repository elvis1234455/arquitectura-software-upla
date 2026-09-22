<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Materiales — Arquitectura de Software | UPLA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/materiales.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<div class="main-content" id="mainContent">

    <header class="topbar">
        <button class="sidebar-toggle" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
        <div class="topbar-title"><h1><i class="fas fa-folder-open"></i> Materiales</h1></div>
        <div class="topbar-user">
            <c:choose>
                <c:when test="${not empty sessionScope.usuario}">
                    <span class="user-greeting">Hola, <strong>${sessionScope.usuario.nombre}</strong></span>
                </c:when>
                <c:otherwise>
                    <span class="user-greeting" style="color:#64748B;"><i class="fas fa-eye"></i> Modo lectura</span>
                </c:otherwise>
            </c:choose>
        </div>
    </header>

    <div class="page-content">

        <c:if test="${not empty param.exito}">
            <div class="toast toast-success" id="toastMsg"><i class="fas fa-check-circle"></i> Material eliminado.</div>
        </c:if>

        <!-- Filtros rápidos por tipo -->
        <div class="quick-filters">
            <a href="${pageContext.request.contextPath}/materiales" class="qfilter ${empty filtroTipo ? 'active' : ''}">
                <i class="fas fa-th"></i> Todos
            </a>
            <a href="?tipo=PDF"        class="qfilter ${filtroTipo eq 'PDF'         ? 'active' : ''}"><i class="fas fa-file-pdf"></i> PDF</a>
            <a href="?tipo=IMAGE"      class="qfilter ${filtroTipo eq 'IMAGE'       ? 'active' : ''}"><i class="fas fa-file-image"></i> Imágenes</a>
            <a href="?tipo=WORD"       class="qfilter ${filtroTipo eq 'WORD'        ? 'active' : ''}"><i class="fas fa-file-word"></i> Word</a>
            <a href="?tipo=EXCEL"      class="qfilter ${filtroTipo eq 'EXCEL'       ? 'active' : ''}"><i class="fas fa-file-excel"></i> Excel</a>
            <a href="?tipo=POWERPOINT" class="qfilter ${filtroTipo eq 'POWERPOINT'  ? 'active' : ''}"><i class="fas fa-file-powerpoint"></i> PowerPoint</a>
        </div>

        <!-- Búsqueda avanzada -->
        <div class="search-panel">
            <form action="${pageContext.request.contextPath}/materiales" method="get">
                <div class="search-grid">
                    <div class="form-group">
                        <label><i class="fas fa-search"></i> Nombre</label>
                        <input type="text" name="nombre" class="form-input" placeholder="Buscar..." value="${filtroNombre}">
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-calendar-week"></i> Semana</label>
                        <select name="semanaId" class="form-select">
                            <option value="">Todas las semanas</option>
                            <c:forEach var="s" items="${semanas}">
                                <option value="${s.id}" ${filtroSemanaId eq s.id.toString() ? 'selected' : ''}>
                                    ${s.numeroFormateado} — ${s.titulo}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-file"></i> Tipo</label>
                        <select name="tipo" class="form-select">
                            <option value="">Todos</option>
                            <option value="PDF"        ${filtroTipo eq 'PDF'         ? 'selected':''}>PDF</option>
                            <option value="IMAGE"      ${filtroTipo eq 'IMAGE'       ? 'selected':''}>Imagen</option>
                            <option value="WORD"       ${filtroTipo eq 'WORD'        ? 'selected':''}>Word</option>
                            <option value="EXCEL"      ${filtroTipo eq 'EXCEL'       ? 'selected':''}>Excel</option>
                            <option value="POWERPOINT" ${filtroTipo eq 'POWERPOINT'  ? 'selected':''}>PowerPoint</option>
                            <option value="TEXT"       ${filtroTipo eq 'TEXT'        ? 'selected':''}>Texto</option>
                            <option value="ZIP"        ${filtroTipo eq 'ZIP'         ? 'selected':''}>ZIP</option>
                        </select>
                    </div>
                    <div class="form-group"><label>Desde</label><input type="date" name="fechaDesde" class="form-input" value="${filtroFechaDesde}"></div>
                    <div class="form-group"><label>Hasta</label><input type="date" name="fechaHasta" class="form-input" value="${filtroFechaHasta}"></div>
                    <div class="form-group form-group-actions">
                        <button type="submit" class="btn-primary"><i class="fas fa-search"></i> Buscar</button>
                        <a href="${pageContext.request.contextPath}/materiales" class="btn-secondary"><i class="fas fa-times"></i> Limpiar</a>
                    </div>
                </div>
            </form>
        </div>

        <div class="results-header">
            <span><i class="fas fa-list"></i> ${materiales.size()} resultado(s)</span>
            <%-- Indicador de modo lectura para visitantes --%>
            <c:if test="${empty sessionScope.usuario}">
                <span style="font-size:.78rem;color:#64748B;">
                    <i class="fas fa-eye"></i> Modo lectura —
                    <a href="${pageContext.request.contextPath}/login" style="color:#38BDF8;">Iniciar sesión como admin</a>
                </span>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${empty materiales}">
                <div class="empty-state">
                    <i class="fas fa-search"></i>
                    <h3>Sin resultados</h3>
                    <p>No se encontraron materiales con los filtros aplicados.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="material-table-wrapper">
                    <table class="material-table">
                        <thead>
                            <tr>
                                <th>Archivo</th><th>Tipo</th><th>Semana</th>
                                <th>Subido por</th><th>Tamaño</th><th>Fecha</th><th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="m" items="${materiales}">
                            <tr>
                                <td class="td-file">
                                    <div class="file-cell">
                                        <div class="file-icon-sm ${m.colorClase}"><i class="fas ${m.iconoClase}"></i></div>
                                        <div>
                                            <span class="file-name">${m.nombreOriginal}</span>
                                            <c:if test="${not empty m.descripcion}"><span class="file-desc">${m.descripcion}</span></c:if>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge badge-type">${m.extension.toUpperCase()}</span></td>
                                <td><a href="${pageContext.request.contextPath}/semanas?id=${m.semanaId}" class="semana-link">Semana ${m.numeroSemana}</a></td>
                                <td>${m.nombreUsuario}</td>
                                <td>${m.tamanoFormateado}</td>
                                <td>${m.fechaSubidaStr}</td>
                                <td class="td-actions">
                                    <%-- Descarga disponible para todos --%>
                                    <a href="${pageContext.request.contextPath}/download?id=${m.id}"
                                       class="btn-icon btn-download" title="Descargar">
                                        <i class="fas fa-download"></i>
                                    </a>
                                    <%-- Eliminar solo para ADMIN --%>
                                    <c:if test="${not empty sessionScope.usuario and sessionScope.usuario.admin}">
                                    <form action="${pageContext.request.contextPath}/deleteMaterial"
                                          method="post" class="inline-form"
                                          onsubmit="return confirm('¿Eliminar ${m.nombreOriginal}?')">
                                        <input type="hidden" name="id" value="${m.id}">
                                        <input type="hidden" name="origen" value="materiales">
                                        <button type="submit" class="btn-icon btn-delete" title="Eliminar">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                    </c:if>
                                </td>
                            </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
