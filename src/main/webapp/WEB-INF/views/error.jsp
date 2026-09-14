<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error — EduPlatform</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        body{display:flex;align-items:center;justify-content:center;min-height:100vh;background:#0F172A;font-family:'Segoe UI',sans-serif}
        .error-box{text-align:center;color:#F8FAFC;padding:3rem}
        .error-code{font-size:6rem;font-weight:800;color:#2563EB;line-height:1}
        .error-msg{font-size:1.5rem;margin:1rem 0}
        .error-desc{color:#94A3B8;margin-bottom:2rem}
        .btn-back{background:#2563EB;color:#fff;padding:.75rem 2rem;border-radius:.5rem;text-decoration:none;font-weight:600;display:inline-flex;gap:.5rem;align-items:center;transition:.25s ease}
        .btn-back:hover{background:#1d4ed8}
    </style>
</head>
<body>
<div class="error-box">
    <div class="error-code">
        <c:choose>
            <c:when test="${pageContext.errorData.statusCode eq 404}">404</c:when>
            <c:when test="${pageContext.errorData.statusCode eq 403}">403</c:when>
            <c:otherwise>${pageContext.errorData.statusCode}</c:otherwise>
        </c:choose>
    </div>
    <div class="error-msg">
        <c:choose>
            <c:when test="${pageContext.errorData.statusCode eq 404}"><i class="fas fa-search"></i> Página no encontrada</c:when>
            <c:when test="${pageContext.errorData.statusCode eq 403}"><i class="fas fa-lock"></i> Acceso denegado</c:when>
            <c:otherwise><i class="fas fa-exclamation-triangle"></i> Error del servidor</c:otherwise>
        </c:choose>
    </div>
    <p class="error-desc">
        <c:choose>
            <c:when test="${pageContext.errorData.statusCode eq 404}">La página que buscas no existe o fue movida.</c:when>
            <c:when test="${pageContext.errorData.statusCode eq 403}">No tienes permisos para acceder a este recurso.</c:when>
            <c:otherwise>Ocurrió un error interno. Por favor intenta más tarde.</c:otherwise>
        </c:choose>
    </p>
    <a href="${pageContext.request.contextPath}/dashboard" class="btn-back"><i class="fas fa-home"></i> Volver al inicio</a>
</div>
</body>
</html>
