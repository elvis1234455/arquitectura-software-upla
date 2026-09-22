<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil — Arquitectura de Software | UPLA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/perfil.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/materiales.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pokemon-theme.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<div class="main-content" id="mainContent">

    <header class="topbar">
        <button class="sidebar-toggle" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
        <div class="topbar-title"><h1><i class="fas fa-user-circle"></i> Mi Perfil</h1></div>
    </header>

    <div class="page-content">

        <c:if test="${not empty param.exito}">
            <div class="toast toast-success" id="toastMsg"><i class="fas fa-check-circle"></i>
                <c:choose>
                    <c:when test="${param.exito eq 'nombre_actualizado'}">Nombre actualizado.</c:when>
                    <c:when test="${param.exito eq 'material_eliminado'}">Material eliminado.</c:when>
                    <c:otherwise>Cambios guardados.</c:otherwise>
                </c:choose>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="toast toast-error" id="toastMsg"><i class="fas fa-times-circle"></i>
                <c:choose>
                    <c:when test="${param.error eq 'nombre_requerido'}">El nombre es obligatorio.</c:when>
                    <c:when test="${param.error eq 'sin_permiso'}">Sin permisos para esa acción.</c:when>
                    <c:otherwise>Ocurrió un error.</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <div class="perfil-layout">

            <!-- Columna izquierda: datos del usuario + curso -->
            <div class="perfil-sidebar-col">

                <!-- Tarjeta de usuario -->
                <div class="perfil-card">
                    <div class="perfil-avatar-wrap">
                        <c:choose>
                            <c:when test="${not empty usuarioPerfil.avatarUrl}">
                                <img src="${usuarioPerfil.avatarUrl}" alt="Avatar" class="perfil-avatar-img">
                            </c:when>
                            <c:otherwise>
                                <div class="perfil-avatar-placeholder">
                                    ${usuarioPerfil.nombre.substring(0,1).toUpperCase()}
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h2 class="perfil-nombre">${usuarioPerfil.nombre}</h2>
                    <span class="perfil-rol badge-${usuarioPerfil.rol.toLowerCase()}">${usuarioPerfil.rol}</span>
                    <p class="perfil-correo"><i class="fas fa-envelope"></i> ${usuarioPerfil.correo}</p>

                    <div class="perfil-stats">
                        <div class="pstat">
                            <span class="pstat-val">${totalMateriales}</span>
                            <span class="pstat-label">Archivos subidos</span>
                        </div>
                        <div class="pstat">
                            <span class="pstat-val">
                                <c:choose>
                                    <c:when test="${usuarioPerfil.activo}"><i class="fas fa-circle text-green"></i></c:when>
                                    <c:otherwise><i class="fas fa-circle text-red"></i></c:otherwise>
                                </c:choose>
                            </span>
                            <span class="pstat-label">${usuarioPerfil.activo ? 'Activo' : 'Inactivo'}</span>
                        </div>
                    </div>

                    <c:if test="${not empty usuarioPerfil.fechaCreacion}">
                        <p class="perfil-fecha">
                            <i class="fas fa-calendar-plus"></i> Miembro desde: ${usuarioPerfil.fechaCreacionStr}
                        </p>
                    </c:if>

                    <!-- Editar nombre -->
                    <form action="${pageContext.request.contextPath}/perfil" method="post" class="perfil-edit-form">
                        <input type="hidden" name="accion" value="actualizar">
                        <div class="form-group">
                            <label>Nombre visible</label>
                            <input type="text" name="nombre" class="form-input"
                                   value="${usuarioPerfil.nombre}" required maxlength="100">
                        </div>
                        <button type="submit" class="btn-primary btn-sm">
                            <i class="fas fa-save"></i> Guardar nombre
                        </button>
                    </form>
                </div>

                <!-- Tarjeta de información del curso -->
                <div class="perfil-card" style="margin-top:1.25rem;">
                    <div style="display:flex;align-items:center;gap:.65rem;margin-bottom:1.25rem;padding-bottom:.85rem;border-bottom:1px solid #334155;">
                        <!-- Logo UPLA imagen -->
                        <img src="${pageContext.request.contextPath}/images/upla-logo.png"
                             alt="UPLA" style="width:40px;height:40px;object-fit:contain;border-radius:.4rem;">
                        <div>
                            <div style="font-size:.7rem;color:#64748B;text-transform:uppercase;letter-spacing:.08em;font-weight:700;">UPLA</div>
                            <div style="font-size:.88rem;font-weight:700;color:#F8FAFC;">Arquitectura de Software</div>
                        </div>
                    </div>

                    <div class="curso-info-list">
                        <div class="curso-info-item">
                            <i class="fas fa-hashtag"></i>
                            <div>
                                <span class="ci-label">Código</span>
                                <span class="ci-value">332181</span>
                            </div>
                        </div>
                        <div class="curso-info-item">
                            <i class="fas fa-calendar-alt"></i>
                            <div>
                                <span class="ci-label">Semestre</span>
                                <span class="ci-value">2026-I</span>
                            </div>
                        </div>
                        <div class="curso-info-item">
                            <i class="fas fa-star"></i>
                            <div>
                                <span class="ci-label">Créditos</span>
                                <span class="ci-value">02 créditos</span>
                            </div>
                        </div>
                        <div class="curso-info-item">
                            <i class="fas fa-clock"></i>
                            <div>
                                <span class="ci-label">Horas semanales</span>
                                <span class="ci-value">04 horas (prácticas)</span>
                            </div>
                        </div>
                        <div class="curso-info-item">
                            <i class="fas fa-user-tie"></i>
                            <div>
                                <span class="ci-label">Docente</span>
                                <span class="ci-value">Mg. Raúl Fernández Bejarano</span>
                            </div>
                        </div>
                        <div class="curso-info-item">
                            <i class="fas fa-university"></i>
                            <div>
                                <span class="ci-label">Facultad</span>
                                <span class="ci-value">Ingeniería de Sistemas</span>
                            </div>
                        </div>
                        <div class="curso-info-item">
                            <i class="fas fa-calendar-check"></i>
                            <div>
                                <span class="ci-label">Período</span>
                                <span class="ci-value">Abr – Jul 2026</span>
                            </div>
                        </div>
                        <div class="curso-info-item">
                            <i class="fas fa-layer-group"></i>
                            <div>
                                <span class="ci-label">Semanas</span>
                                <span class="ci-value">16 semanas</span>
                            </div>
                        </div>
                    </div>

                    <!-- Progreso del curso -->
                    <div style="margin-top:1.25rem;padding-top:1rem;border-top:1px solid #334155;">
                        <div style="font-size:.75rem;font-weight:700;color:#64748B;text-transform:uppercase;letter-spacing:.07em;margin-bottom:.75rem;">
                            <i class="fas fa-tasks" style="color:#2563EB;margin-right:.35rem;"></i>Evaluación del Curso
                        </div>
                        <div class="eval-mini">
                            <div class="eval-mini-item">
                                <span>Unidad I</span>
                                <div class="eval-mini-bar"><div style="width:20%;background:#2563EB"></div></div>
                                <span>20%</span>
                            </div>
                            <div class="eval-mini-item">
                                <span>Unidad II</span>
                                <div class="eval-mini-bar"><div style="width:20%;background:#2563EB"></div></div>
                                <span>20%</span>
                            </div>
                            <div class="eval-mini-item">
                                <span>Unidad III</span>
                                <div class="eval-mini-bar"><div style="width:20%;background:#2563EB"></div></div>
                                <span>20%</span>
                            </div>
                            <div class="eval-mini-item">
                                <span>Unidad IV</span>
                                <div class="eval-mini-bar"><div style="width:20%;background:#2563EB"></div></div>
                                <span>20%</span>
                            </div>
                            <div class="eval-mini-item">
                                <span>Eval. Final</span>
                                <div class="eval-mini-bar"><div style="width:20%;background:#38BDF8"></div></div>
                                <span>20%</span>
                            </div>
                        </div>
                        <p style="font-size:.72rem;color:#475569;margin-top:.5rem;text-align:center;">
                            Nota mínima aprobatoria: <strong style="color:#38BDF8">13</strong> (ingresantes 2026-I)
                        </p>
                    </div>
                </div>
            </div>

            <!-- Columna derecha: mis materiales -->
            <div class="mis-materiales">
                <div class="panel-header">
                    <i class="fas fa-history"></i> Mis Materiales Subidos (${totalMateriales})
                </div>
                <c:choose>
                    <c:when test="${empty misMateriales}">
                        <div class="empty-state-sm">
                            <i class="fas fa-folder-open"></i>
                            <p>Aún no has subido ningún material.</p>
                            <a href="${pageContext.request.contextPath}/semanas" class="btn-primary btn-sm">
                                <i class="fas fa-upload"></i> Subir material
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="material-list">
                            <c:forEach var="m" items="${misMateriales}">
                            <div class="material-item">
                                <div class="material-icon ${m.colorClase}"><i class="fas ${m.iconoClase}"></i></div>
                                <div class="material-info">
                                    <span class="material-name">${m.nombreOriginal}</span>
                                    <div class="material-meta">
                                        <span class="material-type">${m.extension.toUpperCase()}</span>
                                        <span>${m.tamanoFormateado}</span>
                                        <span><i class="fas fa-calendar-week"></i> ${m.tituloSemana}</span>
                                        <span><i class="fas fa-calendar"></i> ${m.fechaSubidaStr}</span>
                                    </div>
                                    <c:if test="${not empty m.descripcion}">
                                        <p class="material-desc">${m.descripcion}</p>
                                    </c:if>
                                </div>
                                <div class="material-actions">
                                    <a href="${pageContext.request.contextPath}/download?id=${m.id}"
                                       class="btn-icon btn-download" title="Descargar">
                                        <i class="fas fa-download"></i>
                                    </a>
                                    <form action="${pageContext.request.contextPath}/deleteMaterial"
                                          method="post" class="inline-form"
                                          onsubmit="return confirm('¿Eliminar este material?')">
                                        <input type="hidden" name="id" value="${m.id}">
                                        <input type="hidden" name="origen" value="perfil">
                                        <button type="submit" class="btn-icon btn-delete" title="Eliminar">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script src="${pageContext.request.contextPath}/js/pokemon-app.js"></script>
</body>
</html>
