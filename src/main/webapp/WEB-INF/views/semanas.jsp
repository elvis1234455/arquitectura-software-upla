<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Semanas — Arquitectura de Software | UPLA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pokemon-theme.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body class="pokemon-page">

<%-- ═══ LOADER POKÉMON ═════════════════════════════════════════ --%>
<div id="pokemon-loader">
    <div class="loader-pokeball"></div>
    <div class="loader-text">
        ¡Cargando Módulos!<br>
        <span class="loader-dots">...</span>
    </div>
</div>

<jsp:include page="sidebar.jsp"/>

<div class="main-content" id="mainContent">

    <header class="topbar">
        <button class="sidebar-toggle" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
        <div class="topbar-title">
            <h1 style="font-family:'Press Start 2P',monospace;font-size:.75rem;color:#FFDE00;text-shadow:2px 2px 0 #EE1515;">
                ⚡ SEMANAS DEL CURSO
            </h1>
        </div>
        <div class="topbar-user">
            <c:choose>
                <c:when test="${not empty sessionScope.usuario}">
                    <span class="user-greeting">Hola, <strong>${sessionScope.usuario.nombre}</strong></span>
                </c:when>
                <c:otherwise>
                    <span class="user-greeting" style="color:#64748B;font-size:.78rem;">
                        <i class="fas fa-eye"></i> Modo lectura
                    </span>
                </c:otherwise>
            </c:choose>
        </div>
    </header>

    <div class="page-content">

        <%-- Mensajes --%>
        <c:if test="${not empty param.exito}">
            <div class="toast toast-success" id="toastMsg"><i class="fas fa-check-circle"></i>
                <c:choose>
                    <c:when test="${param.exito eq 'semana_creada'}">¡Semana creada!</c:when>
                    <c:when test="${param.exito eq 'semana_actualizada'}">¡Semana actualizada!</c:when>
                    <c:when test="${param.exito eq 'semana_eliminada'}">Semana eliminada.</c:when>
                    <c:when test="${param.exito eq 'archivo_subido'}">¡Archivo subido!</c:when>
                    <c:when test="${param.exito eq 'material_eliminado'}">Material eliminado.</c:when>
                    <c:otherwise>¡Operación exitosa!</c:otherwise>
                </c:choose>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="toast toast-error" id="toastMsg"><i class="fas fa-times-circle"></i>
                <c:choose>
                    <c:when test="${param.error eq 'sin_permiso'}">Sin permisos.</c:when>
                    <c:when test="${param.error eq 'numero_duplicado'}">Número de semana duplicado.</c:when>
                    <c:otherwise>Error inesperado.</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <%-- Header de sección --%>
        <div class="poke-section-header">
            <div class="poke-section-title">
                🎮 SELECCIONA UN MÓDULO
            </div>
            <p class="poke-section-sub">
                Pasa el cursor sobre una Pokébola para descubrir el contenido de cada semana
            </p>
            <c:if test="${not empty sessionScope.usuario and sessionScope.usuario.admin}">
                <button class="btn-primary" onclick="abrirModal('modalCrear')">
                    <i class="fas fa-plus"></i> + Nueva Semana
                </button>
            </c:if>
        </div>

        <%-- ═══ GRID DE POKÉBOLAS ════════════════════════════════ --%>
        <c:choose>
            <c:when test="${empty semanas}">
                <div class="poke-empty">
                    <span class="poke-empty-ball">⚪</span>
                    <h3>NO HAY SEMANAS AÚN</h3>
                    <p>El administrador no ha creado semanas todavía.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="pokeball-grid">
                    <c:forEach var="semana" items="${semanas}" varStatus="st">
                    <div class="pokeball-wrapper" data-semana-id="${semana.id}">

                        <%-- ── INNER (contenedor 3D) ── --%>
                        <div class="pokeball-inner">

                            <%-- ── FRENTE — Pokébola ── --%>
                            <div class="pokeball-front">
                                <%-- Mitad superior roja --%>
                                <div class="pf-top">
                                    <div class="pf-semana-num">
                                        SEMANA<br>${semana.numero}
                                    </div>
                                </div>

                                <%-- Franja central negra --%>
                                <div class="pf-band">
                                    <span class="pf-count">
                                        <i class="fas fa-file"></i> ${semana.cantidadMateriales}
                                    </span>
                                </div>

                                <%-- Botón central blanco --%>
                                <div class="pf-button"></div>

                                <%-- Reflejo de luz --%>
                                <div class="pf-shine"></div>

                                <%-- Mitad inferior blanca --%>
                                <div class="pf-bottom">
                                    <div class="pf-hint">¡Pasa el cursor!</div>
                                </div>
                            </div>

                            <%-- ── REVERSO — Info de semana ── --%>
                            <div class="pokeball-back">
                                <div class="pb-num">— SEMANA ${semana.numero} —</div>
                                <div class="pb-title">${semana.titulo}</div>
                                <div class="pb-desc">${semana.descripcion}</div>
                                <a href="${pageContext.request.contextPath}/semanas?id=${semana.id}"
                                   class="pb-btn">
                                    ▶ ENTRAR
                                </a>
                            </div>

                        </div><%-- /pokeball-inner --%>

                        <%-- Botones admin debajo de la pokébola --%>
                        <c:if test="${not empty sessionScope.usuario and sessionScope.usuario.admin}">
                        <div class="pokeball-admin-actions">
                            <button class="btn-icon btn-edit" title="Editar"
                                onclick="event.stopPropagation();abrirModalEditar(${semana.id},${semana.numero},'${semana.titulo}','${semana.descripcion}','${semana.contenido}')">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn-icon btn-delete" title="Eliminar"
                                onclick="event.stopPropagation();confirmarEliminarSemana(${semana.id},'${semana.titulo}')">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                        </c:if>

                    </div><%-- /pokeball-wrapper --%>
                    </c:forEach>
                </div><%-- /pokeball-grid --%>
            </c:otherwise>
        </c:choose>

    </div><%-- /page-content --%>
</div><%-- /main-content --%>

<%-- ═══ MODALES ADMIN ═══════════════════════════════════════════ --%>
<c:if test="${not empty sessionScope.usuario and sessionScope.usuario.admin}">

<%-- Modal Crear --%>
<div class="modal-overlay" id="modalCrear">
    <div class="modal">
        <div class="modal-header">
            <h3><i class="fas fa-plus-circle"></i> Nueva Semana</h3>
            <button class="modal-close" onclick="cerrarModal('modalCrear')"><i class="fas fa-times"></i></button>
        </div>
        <form action="${pageContext.request.contextPath}/semanas" method="post">
            <input type="hidden" name="accion" value="crear">
            <div class="modal-body">
                <div class="form-group"><label>Número *</label><input type="number" name="numero" min="1" max="20" required class="form-input" placeholder="Ej: 1"></div>
                <div class="form-group"><label>Título *</label><input type="text" name="titulo" required class="form-input" maxlength="200" placeholder="Título de la semana"></div>
                <div class="form-group"><label>Descripción</label><textarea name="descripcion" rows="3" class="form-textarea" placeholder="Breve descripción..."></textarea></div>
                <div class="form-group"><label>Contenido</label><textarea name="contenido" rows="3" class="form-textarea" placeholder="Temas y actividades..."></textarea></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="cerrarModal('modalCrear')">Cancelar</button>
                <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Crear</button>
            </div>
        </form>
    </div>
</div>

<%-- Modal Editar --%>
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
                <div class="form-group"><label>Número *</label><input type="number" name="numero" id="editNumero" min="1" max="20" required class="form-input"></div>
                <div class="form-group"><label>Título *</label><input type="text" name="titulo" id="editTitulo" required class="form-input" maxlength="200"></div>
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

<%-- Modal Eliminar --%>
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
                <p>¿Eliminar <strong id="deleteSemananombre"></strong>?</p>
                <p class="text-danger"><i class="fas fa-exclamation-circle"></i> Se eliminarán todos sus materiales. No se puede deshacer.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="cerrarModal('modalEliminar')">Cancelar</button>
                <button type="submit" class="btn-danger"><i class="fas fa-trash"></i> Eliminar</button>
            </div>
        </form>
    </div>
</div>

</c:if>

<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script src="${pageContext.request.contextPath}/js/semanas.js"></script>
<script src="${pageContext.request.contextPath}/js/pokemon-app.js"></script>
</body>
</html>
