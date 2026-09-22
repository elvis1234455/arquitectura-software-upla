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

    <%-- Mostrar info de usuario si hay sesión, sino mostrar "Visitante" --%>
    <div class="sidebar-user">
        <div class="sidebar-avatar">
            <c:choose>
                <c:when test="${not empty sessionScope.usuario and not empty sessionScope.usuario.avatarUrl}">
                    <img src="${sessionScope.usuario.avatarUrl}" alt="Avatar">
                </c:when>
                <c:when test="${not empty sessionScope.usuario}">
                    ${sessionScope.usuario.nombre.substring(0,1).toUpperCase()}
                </c:when>
                <c:otherwise>
                    <i class="fas fa-user" style="font-size:.9rem;color:#94A3B8;"></i>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="sidebar-user-info">
            <c:choose>
                <c:when test="${not empty sessionScope.usuario}">
                    <span class="sidebar-user-name">${sessionScope.usuario.nombre}</span>
                    <span class="sidebar-user-role badge-${sessionScope.usuario.rol.toLowerCase()}">
                        ${sessionScope.usuario.rol}
                    </span>
                </c:when>
                <c:otherwise>
                    <span class="sidebar-user-name">Visitante</span>
                    <span class="sidebar-user-role" style="font-size:.7rem;color:#64748B;">Modo lectura</span>
                </c:otherwise>
            </c:choose>
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

        <%-- Opciones solo para ADMIN autenticado --%>
        <c:if test="${not empty sessionScope.usuario and sessionScope.usuario.admin}">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/perfil" class="nav-link">
                    <i class="fas fa-user-circle"></i><span>Mi Perfil</span>
                </a>
            </li>
            <li class="nav-separator"><span>Administración</span></li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/administracion" class="nav-link">
                    <i class="fas fa-cogs"></i><span>Administración</span>
                </a>
            </li>
        </c:if>
    </ul>

    <div class="sidebar-footer">
        <c:choose>
            <c:when test="${not empty sessionScope.usuario and sessionScope.usuario.admin}">
                <%-- Admin: mostrar cerrar sesión --%>
                <a href="${pageContext.request.contextPath}/logout" class="nav-link nav-logout">
                    <i class="fas fa-sign-out-alt"></i><span>Cerrar Sesión</span>
                </a>
            </c:when>
            <c:otherwise>
                <%-- Visitante: mostrar botón "Iniciar sesión como admin" --%>
                <a href="${pageContext.request.contextPath}/login" class="btn-admin-login">
                    <i class="fas fa-shield-alt"></i>
                    <span>Iniciar sesión como admin</span>
                </a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>
<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

<style>
.btn-admin-login {
    display: flex;
    align-items: center;
    gap: .65rem;
    padding: .7rem 1rem;
    margin: .25rem .5rem;
    background: rgba(27,126,194,.15);
    border: 1px solid rgba(27,126,194,.3);
    border-radius: .6rem;
    color: #38BDF8;
    text-decoration: none;
    font-size: .85rem;
    font-weight: 600;
    transition: .25s ease;
}
.btn-admin-login:hover {
    background: rgba(27,126,194,.3);
    color: #fff;
    transform: translateX(3px);
}
.btn-admin-login i { font-size: .9rem; }
</style>
