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

<%-- LOADER --%>
<div id="pokemon-loader">
    <div class="loader-pokeball"></div>
    <div class="loader-text">CARGANDO MÓDULOS<br>...</div>
</div>

<jsp:include page="sidebar.jsp"/>

<div class="main-content" id="mainContent">
    <header class="topbar">
        <button class="sidebar-toggle" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
        <div class="topbar-title">
            <h1 style="font-family:'Press Start 2P',monospace;font-size:.7rem;color:#FFDE00;text-shadow:2px 2px 0 #EE1515;">
                ⚡ SELECCIONA UN MÓDULO
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

        <%-- Toasts --%>
        <c:if test="${not empty param.exito}">
            <div class="toast toast-success" id="toastMsg"><i class="fas fa-check-circle"></i>
                <c:choose>
                    <c:when test="${param.exito eq 'semana_creada'}">¡Semana creada!</c:when>
                    <c:when test="${param.exito eq 'semana_actualizada'}">¡Semana actualizada!</c:when>
                    <c:when test="${param.exito eq 'semana_eliminada'}">Semana eliminada.</c:when>
                    <c:otherwise>¡Listo!</c:otherwise>
                </c:choose>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="toast toast-error" id="toastMsg"><i class="fas fa-times-circle"></i>
                <c:choose>
                    <c:when test="${param.error eq 'sin_permiso'}">Sin permisos.</c:when>
                    <c:when test="${param.error eq 'numero_duplicado'}">Número duplicado.</c:when>
                    <c:otherwise>Error.</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <%-- Header --%>
        <div class="poke-section-header">
            <div class="poke-section-title">🎮 CARTAS DEL CURSO</div>
            <p class="poke-section-sub">Haz clic en una carta para revelar el contenido de la semana</p>
            <c:if test="${not empty sessionScope.usuario and sessionScope.usuario.admin}">
                <button class="btn-primary" onclick="abrirModal('modalCrear')">
                    <i class="fas fa-plus"></i> Nueva Semana
                </button>
            </c:if>
        </div>

        <%-- GRID DE CARTAS --%>
        <c:choose>
            <c:when test="${empty semanas}">
                <div class="poke-empty">
                    <span class="poke-empty-icon">🃏</span>
                    <h3>SIN CARTAS AÚN</h3>
                    <p>El administrador no ha creado semanas todavía.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="pokemon-card-grid">
                    <c:forEach var="semana" items="${semanas}" varStatus="st">

                    <%-- Escena (perspective) --%>
                    <div class="pcard-scene">
                        <div class="pcard-wrapper">

                            <%-- ── FRENTE: dorso de carta ── --%>
                            <div class="pcard-front">
                                <div class="pcard-front-logo">
                                    <%-- Ícono Pokébola SVG --%>
                                    <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
                                        <circle cx="50" cy="50" r="48" fill="none" stroke="rgba(255,255,255,0.3)" stroke-width="2"/>
                                        <path d="M2,50 Q2,20 20,10 Q38,2 50,2 Q62,2 80,10 Q98,20 98,50 Z" fill="rgba(255,255,255,0.15)"/>
                                        <rect x="2" y="44" width="96" height="12" fill="rgba(0,0,0,0.5)"/>
                                        <circle cx="50" cy="50" r="12" fill="white" stroke="rgba(0,0,0,0.4)" stroke-width="2"/>
                                        <circle cx="50" cy="50" r="7" fill="rgba(200,200,200,0.8)"/>
                                    </svg>
                                </div>
                                <div class="pcard-front-label">ARQUITECTURA</div>
                                <div class="pcard-front-num">${semana.numeroFormateado}</div>
                                <div class="pcard-front-hint">Clic para revelar</div>
                            </div>

                            <%-- ── REVERSO: carta Pokémon TCG ── --%>
                            <div class="pcard-back">

                                <%-- Encabezado --%>
                                <div class="pcard-header">
                                    <span class="pcard-header-name">${semana.titulo}</span>
                                    <span class="pcard-header-hp">S${semana.numero < 10 ? '0' : ''}${semana.numero}</span>
                                </div>

                                <%-- Ilustración --%>
                                <div class="pcard-illustration">
                                    <div class="pcard-illus-content">
                                        <span class="pcard-illus-num">${semana.numero}</span>
                                        <span class="pcard-illus-label">SEMANA</span>
                                    </div>
                                </div>

                                <%-- Tipo y materiales --%>
                                <div class="pcard-type-bar">
                                    <span class="pcard-type-badge">⚡ ARQ</span>
                                    <span class="pcard-mat-count">
                                        <i class="fas fa-file"></i> ${semana.cantidadMateriales}
                                    </span>
                                </div>

                                <%-- Descripción --%>
                                <div class="pcard-desc-box">
                                    <div class="pcard-title-text">${semana.titulo}</div>
                                    <div class="pcard-desc-text">
                                        <c:choose>
                                            <c:when test="${not empty semana.descripcion}">${semana.descripcion}</c:when>
                                            <c:otherwise>Contenido de la semana ${semana.numero} del curso de Arquitectura de Software.</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <%-- Botón entrar --%>
                                <div class="pcard-btn-wrap">
                                    <a href="${pageContext.request.contextPath}/semanas?id=${semana.id}"
                                       class="pcard-enter-btn">
                                        ▶ ENTRAR A LA SEMANA
                                    </a>
                                </div>

                                <%-- Pie --%>
                                <div class="pcard-footer">
                                    <span class="pcard-footer-set">UPLA 2026-I</span>
                                    <span class="pcard-footer-rarity">★</span>
                                </div>

                            </div><%-- /pcard-back --%>
                        </div><%-- /pcard-wrapper --%>

                        <%-- Botones admin --%>
                        <c:if test="${not empty sessionScope.usuario and sessionScope.usuario.admin}">
                        <div class="pcard-admin-actions">
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

                    </div><%-- /pcard-scene --%>
                    </c:forEach>
                </div><%-- /pokemon-card-grid --%>
            </c:otherwise>
        </c:choose>

    </div>
</div>

<%-- MODALES ADMIN --%>
<c:if test="${not empty sessionScope.usuario and sessionScope.usuario.admin}">
<div class="modal-overlay" id="modalCrear">
    <div class="modal">
        <div class="modal-header">
            <h3><i class="fas fa-plus-circle"></i> Nueva Semana</h3>
            <button class="modal-close" onclick="cerrarModal('modalCrear')"><i class="fas fa-times"></i></button>
        </div>
        <form action="${pageContext.request.contextPath}/semanas" method="post">
            <input type="hidden" name="accion" value="crear">
            <div class="modal-body">
                <div class="form-group"><label>Número *</label><input type="number" name="numero" min="1" max="20" required class="form-input"></div>
                <div class="form-group"><label>Título *</label><input type="text" name="titulo" required class="form-input" maxlength="200"></div>
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

<div class="modal-overlay" id="modalEliminar">
    <div class="modal modal-sm">
        <div class="modal-header modal-header-danger">
            <h3><i class="fas fa-exclamation-triangle"></i> Eliminar</h3>
            <button class="modal-close" onclick="cerrarModal('modalEliminar')"><i class="fas fa-times"></i></button>
        </div>
        <form action="${pageContext.request.contextPath}/semanas" method="post">
            <input type="hidden" name="accion" value="eliminar">
            <input type="hidden" name="id" id="deleteSemanaId">
            <div class="modal-body">
                <p>¿Eliminar <strong id="deleteSemananombre"></strong>?</p>
                <p class="text-danger"><i class="fas fa-exclamation-circle"></i> Se eliminarán todos sus materiales.</p>
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
