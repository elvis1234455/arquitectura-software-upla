<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo">
            <img src="${pageContext.request.contextPath}/images/upla-logo.png"
                 alt="UPLA" style="width:28px;height:28px;object-fit:contain;border-radius:.3rem;">
            <span class="sidebar-brand">Arq. Software</span>
        </div>
        <button class="sidebar-close" onclick="toggleSidebar()"><i class="fas fa-times"></i></button>
    </div>

    <div class="sidebar-user">
        <div class="sidebar-avatar">
            <c:choose>
                <c:when test="${not empty sessionScope.usuario.avatarUrl}">
                    <img src="${sessionScope.usuario.avatarUrl}" alt="Avatar">
                </c:when>
                <c:otherwise>${sessionScope.usuario.nombre.substring(0,1).toUpperCase()}</c:otherwise>
            </c:choose>
        </div>
        <div class="sidebar-user-info">
            <span class="sidebar-user-name">${sessionScope.usuario.nombre}</span>
            <span class="sidebar-user-role badge-${sessionScope.usuario.rol.toLowerCase()}">${sessionScope.usuario.rol}</span>
        </div>
    </div>

    <ul class="sidebar-nav">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                <i class="fas fa-home"></i><span>Inicio</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/semanas" class="nav-link">
                <i class="fas fa-book-open"></i><span>Semanas</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/materiales" class="nav-link">
                <i class="fas fa-folder-open"></i><span>Materiales</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/perfil" class="nav-link">
                <i class="fas fa-user-circle"></i><span>Mi Perfil</span>
            </a>
        </li>
        <c:if test="${sessionScope.usuario.admin}">
        <li class="nav-separator"><span>Administración</span></li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/administracion" class="nav-link">
                <i class="fas fa-cogs"></i><span>Administración</span>
            </a>
        </li>
        </c:if>
    </ul>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link nav-logout">
            <i class="fas fa-sign-out-alt"></i><span>Cerrar Sesión</span>
        </a>
    </div>
</nav>
<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
