<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Semanas — Arquitectura de Software | UPLA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/semanas.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<div class="main-content" id="mainContent">

    <header class="topbar">
        <button class="sidebar-toggle" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
        <div class="topbar-title"><h1><i class="fas fa-book-open"></i> Semanas del Curso</h1></div>
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

        <%-- Mensajes --%>
        <c:if test="${not empty param.exito}">
            <div class="toast toast-success" id="toastMsg"><i class="fas fa-check-circle"></i>
                <c:choose>
                    <c:when test="${param.exito eq 'semana_creada'}">Semana creada correctamente.</c:when>
                    <c:when test="${param.exito eq 'semana_actualizada'}">Semana actualizada.</c:when>
                    <c:when test="${param.exito eq 'semana_eliminada'}">Semana eliminada.</c:when>
                    <c:when test="${param.exito eq 'archivo_subido'}">Archivo subido correctamente.</c:when>
                    <c:when test="${param.exito eq 'material_eliminado'}">Material eliminado.</c:when>
                    <c:otherwise>Operación realizada.</c:otherwise>
                </c:choose>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="toast toast-error" id="toastMsg"><i class="fas fa-times-circle"></i>
                <c:choose>
                    <c:when test="${param.error eq 'sin_permiso'}">Sin permisos para esa acción.</c:when>
                    <c:when test="${param.error eq 'numero_duplicado'}">Ya existe una semana con ese número.</c:when>
                    <c:otherwise>Ocurrió un error.</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <div class="section-header">
            <div>
                <h2>Semanas del Curso</h2>
                <p>Selecciona una semana para ver sus materiales.</p>
            </div>
            <%-- Botón crear solo para ADMIN --%>
            <c:if test="${not empty sessionScope.usuario and sessionScope.usuario.admin}">
                <button class="btn-primary" onclick="abrirModal('modalCrear')">
                    <i class="fas fa-plus"></i> Nueva Semana
                </button>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${empty semanas}">
                <div class="empty-state">
                    <i class="fas fa-calendar-times"></i>
                    <h3>No hay semanas aún</h3>
                    <p>El administrador aún no ha creado semanas para este curso.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="semanas-grid">
                    <c:forEach var="semana" items="${semanas}" varStatus="st">
                    <div class="semana-card" style="animation-delay:${st.index * 50}ms">
                        <div class="semana-card-header">
                            <span class="semana-number">${semana.numeroFormateado}</span>
                            <span class="semana-material-count"><i class="fas fa-file"></i> ${semana.cantidadMateriales}</span>
                        </div>
                        <div class="semana-card-body">
                            <h3 class="semana-titulo">${semana.titulo}</h3>
                            <p class="semana-desc">${semana.descripcion}</p>
                        </div>
                        <div class="semana-card-footer">
                            <a href="${pageContext.request.contextPath}/semanas?id=${semana.id}" class="btn-ver-semana">
                                <i class="fas fa-eye"></i> Ver semana
                            </a>
                            <%-- Botones editar/eliminar solo para ADMIN --%>
                            <c:if test="${not empty sessionScope.usuario and sessionScope.usuario.admin}">
                            <div class="admin-actions">
                                <button class="btn-icon btn-edit" title="Editar"
                                    onclick="abrirModalEditar(${semana.id},${semana.numero},'${semana.titulo}','${semana.descripcion}','${semana.contenido}')">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button class="btn-icon btn-delete" title="Eliminar"
                                    onclick="confirmarEliminarSemana(${semana.id},'${semana.titulo}')">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                            </c:if>
                        </div>
                    </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%-- Modales solo para ADMIN --%>
<c:if test="${not empty sessionScope.usuario and sessionScope.usuario.admin}">
<!-- Modal Crear Semana -->
<div class="modal-overlay" id="modalCrear">
    <div class="modal">
        <div class="modal-header">
            <h3><i class="fas fa-plus-circle"></i> Nueva Semana</h3>
            <button class="modal-close" onclick="cerrarModal('modalCrear')"><i class="fas fa-times"></i></button>
        </div>
        <form action="${pageContext.request.contextPath}/semanas" method="post">
            <input type="hidden" name="accion" value="crear">
            <div class="modal-body">
                <div class="form-group"><label>Número <span class="required">*</span></label><input type="number" name="numero" min="1" max="20" required class="form-input"></div>
                <div class="form-group"><label>Título <span class="required">*</span></label><input type="text" name="titulo" required class="form-input" maxlength="200"></div>
                <div class="form-group"><label>Descripción</label><textarea name="descripcion" rows="3" class="form-textarea"></textarea></div>
                <div class="form-group"><label>Contenido</label><textarea name="contenido" rows="3" class="form-textarea"></textarea></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="cerrarModal('modalCrear')">Cancelar</button>
                <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Crear</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Editar Semana -->
<div class="modal-overlay" id="modalEditar">
    <div class="modal">
        <div class="modal-header">
            <h3><i class="fas fa-edit"></i> Editar Semana</h3>
            <button class="modal-close" onclick="cerrarModal('modalEditar')"><i class="fas fa-times"></i></button>
        </div>
        <form action="${pageContext.request.contextPath}/semanas" method="post">
            <input type="hidden" name="accion" value="editar">
            <input type="hidden" name="id" id="editSemanaId">
            <div class="modal-body">
                <div class="form-group"><label>Número <span class="required">*</span></label><input type="number" name="numero" id="editNumero" min="1" max="20" required class="form-input"></div>
                <div class="form-group"><label>Título <span class="required">*</span></label><input type="text" name="titulo" id="editTitulo" required class="form-input" maxlength="200"></div>
                <div class="form-group"><label>Descripción</label><textarea name="descripcion" id="editDescripcion" rows="3" class="form-textarea"></textarea></div>
                <div class="form-group"><label>Contenido</label><textarea name="contenido" id="editContenido" rows="3" class="form-textarea"></textarea></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="cerrarModal('modalEditar')">Cancelar</button>
                <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Guardar</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Eliminar Semana -->
<div class="modal-overlay" id="modalEliminar">
    <div class="modal modal-sm">
        <div class="modal-header modal-header-danger">
            <h3><i class="fas fa-exclamation-triangle"></i> Eliminar Semana</h3>
            <button class="modal-close" onclick="cerrarModal('modalEliminar')"><i class="fas fa-times"></i></button>
        </div>
        <form action="${pageContext.request.contextPath}/semanas" method="post">
            <input type="hidden" name="accion" value="eliminar">
            <input type="hidden" name="id" id="deleteSemanaId">
            <div class="modal-body">
                <p>¿Estás seguro de eliminar <strong id="deleteSemananombre"></strong>?</p>
                <p class="text-danger"><i class="fas fa-exclamation-circle"></i> Se eliminarán todos sus materiales. Esta acción no se puede deshacer.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="cerrarModal('modalEliminar')">Cancelar</button>
                <button type="submit" class="btn-danger"><i class="fas fa-trash"></i> Sí, eliminar</button>
            </div>
        </form>
    </div>
</div>
</c:if>

<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script src="${pageContext.request.contextPath}/js/semanas.js"></script>
</body>
</html>
