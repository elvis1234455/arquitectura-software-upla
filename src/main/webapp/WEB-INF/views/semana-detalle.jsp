<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${semana.numeroFormateado} — EduPlatform</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/semanas.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/materiales.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<div class="main-content" id="mainContent">

    <header class="topbar">
        <button class="sidebar-toggle" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
        <div class="topbar-title">
            <a href="${pageContext.request.contextPath}/semanas" class="topbar-back"><i class="fas fa-arrow-left"></i></a>
            <h1><i class="fas fa-calendar-week"></i> ${semana.numeroFormateado}</h1>
        </div>
        <div class="topbar-user"><span class="user-greeting">Hola, <strong>${sessionScope.usuario.nombre}</strong></span></div>
    </header>

    <div class="page-content">

        <c:if test="${not empty param.exito}">
            <div class="toast toast-success" id="toastMsg"><i class="fas fa-check-circle"></i>
                <c:choose>
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
                    <c:otherwise>${param.error}</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- Banner de la semana -->
        <div class="semana-detail-banner">
            <div class="semana-detail-num">${semana.numeroFormateado}</div>
            <div class="semana-detail-info">
                <h2>${semana.titulo}</h2>
                <p>${semana.descripcion}</p>
                <div class="semana-detail-meta">
                    <span><i class="fas fa-file-alt"></i> ${semana.cantidadMateriales} materiales</span>
                    <c:if test="${not empty semana.fechaCreacion}">
                        <span><i class="fas fa-calendar"></i> ${semana.fechaCreacionStr}</span>
                    </c:if>
                </div>
            </div>
        </div>

        <c:if test="${not empty semana.contenido}">
        <div class="semana-contenido-card">
            <div class="semana-contenido-header"><i class="fas fa-list-ul"></i> Contenido de la semana</div>
            <p>${semana.contenido}</p>
        </div>
        </c:if>

        <div class="detalle-grid">

            <!-- Formulario de subida -->
            <div class="upload-panel">
                <div class="panel-header"><i class="fas fa-cloud-upload-alt"></i> Subir Material</div>
                <form action="${pageContext.request.contextPath}/upload" method="post" enctype="multipart/form-data" id="uploadForm">
                    <input type="hidden" name="semanaId" value="${semana.id}">

                    <div class="upload-dropzone" id="dropzone" onclick="document.getElementById('archivoInput').click()">
                        <i class="fas fa-cloud-upload-alt upload-icon"></i>
                        <p class="upload-text">Arrastra tu archivo aquí</p>
                        <p class="upload-subtext">o haz clic para seleccionar</p>
                        <span class="upload-types">PDF · Word · Excel · PPT · Imagen · ZIP · TXT</span>
                        <input type="file" id="archivoInput" name="archivo" class="upload-input" required
                               accept=".pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.jpg,.jpeg,.png,.gif,.txt,.zip">
                    </div>

                    <div class="file-preview" id="filePreview" style="display:none">
                        <div class="file-preview-icon" id="previewIcon"><i class="fas fa-file"></i></div>
                        <div class="file-preview-info">
                            <span class="file-preview-name" id="previewName"></span>
                            <span class="file-preview-size" id="previewSize"></span>
                        </div>
                        <button type="button" class="file-preview-remove" onclick="resetUpload()"><i class="fas fa-times"></i></button>
                    </div>

                    <div class="form-group mt-2">
                        <label>Descripción (opcional)</label>
                        <textarea name="descripcion" rows="2" class="form-textarea" placeholder="Breve descripción del material..."></textarea>
                    </div>

                    <div class="upload-progress" id="uploadProgress" style="display:none">
                        <div class="progress-bar-track"><div class="progress-bar-fill" id="progressFill"></div></div>
                        <span id="progressText">Subiendo...</span>
                    </div>

                    <button type="submit" class="btn-upload" id="btnUpload">
                        <i class="fas fa-upload"></i> Subir Archivo
                    </button>
                </form>
                <p class="upload-note"><i class="fas fa-info-circle"></i> Tamaño máximo: 50 MB</p>
            </div>

            <!-- Lista de materiales -->
            <div class="materiales-panel">
                <div class="panel-header"><i class="fas fa-paperclip"></i> Materiales (${semana.cantidadMateriales})</div>

                <c:choose>
                    <c:when test="${empty materiales}">
                        <div class="empty-state-sm">
                            <i class="fas fa-folder-open"></i>
                            <p>No hay materiales aún. ¡Sé el primero en subir algo!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="material-list">
                            <c:forEach var="m" items="${materiales}">
                            <div class="material-item">
                                <div class="material-icon ${m.colorClase}"><i class="fas ${m.iconoClase}"></i></div>
                                <div class="material-info">
                                    <span class="material-name" title="${m.nombreOriginal}">${m.nombreOriginal}</span>
                                    <div class="material-meta">
                                        <span class="material-type">${m.extension.toUpperCase()}</span>
                                        <span>${m.tamanoFormateado}</span>
                                        <span><i class="fas fa-user"></i> ${m.nombreUsuario}</span>
                                        <span><i class="fas fa-calendar"></i> ${m.fechaSubidaStr}</span>
                                    </div>
                                    <c:if test="${not empty m.descripcion}"><p class="material-desc">${m.descripcion}</p></c:if>
                                </div>
                                <div class="material-actions">
                                    <a href="${pageContext.request.contextPath}/download?id=${m.id}" class="btn-icon btn-download" title="Descargar">
                                        <i class="fas fa-download"></i>
                                    </a>
                                    <c:if test="${sessionScope.usuario.admin or sessionScope.usuario.id eq m.usuarioId}">
                                    <form action="${pageContext.request.contextPath}/deleteMaterial" method="post" class="inline-form"
                                          onsubmit="return confirm('¿Eliminar este material?')">
                                        <input type="hidden" name="id" value="${m.id}">
                                        <input type="hidden" name="origen" value="semana">
                                        <button type="submit" class="btn-icon btn-delete" title="Eliminar"><i class="fas fa-trash"></i></button>
                                    </form>
                                    </c:if>
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
<script src="${pageContext.request.contextPath}/js/materiales.js"></script>
</body>
</html>
