<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio — Arquitectura de Software | UPLA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<div class="main-content" id="mainContent">

    <header class="topbar">
        <button class="sidebar-toggle" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
        <div class="topbar-title">
            <h1><i class="fas fa-home"></i> Inicio del Curso</h1>
        </div>
        <div class="topbar-user">
            <span class="user-greeting">Hola, <strong>${sessionScope.usuario.nombre}</strong></span>
            <div class="user-avatar">
                <c:choose>
                    <c:when test="${not empty sessionScope.usuario.avatarUrl}">
                        <img src="${sessionScope.usuario.avatarUrl}" alt="Avatar">
                    </c:when>
                    <c:otherwise>${sessionScope.usuario.nombre.substring(0,1).toUpperCase()}</c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

    <div class="page-content">

        <!-- Hero del curso con logo UPLA -->
        <section class="course-hero">
            <div class="course-hero-bg"></div>
            <div class="course-hero-content">
                <div class="upla-hero-logo">
                    <img src="https://www.upla.edu.pe/wp-content/uploads/2021/01/logo-upla.png"
                         alt="UPLA" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex'">
                    <div class="upla-logo-fallback" style="display:none">
                        <i class="fas fa-university"></i><span>UPLA</span>
                    </div>
                </div>
                <div class="course-badge">
                    <i class="fas fa-laptop-code"></i>
                    <span>Ingeniería de Sistemas y Computación</span>
                </div>
                <h1 class="course-title">Arquitectura de Software</h1>
                <p class="course-subtitle">Comprende y desarrolla arquitecturas de software utilizando estándares internacionales, POO, frameworks y metodologías modernas.</p>
                <div class="course-meta-pills">
                    <span class="pill"><i class="fas fa-hashtag"></i> Código: 332181</span>
                    <span class="pill"><i class="fas fa-layer-group"></i> Semestre 2026-I</span>
                    <span class="pill"><i class="fas fa-star"></i> 02 Créditos</span>
                    <span class="pill"><i class="fas fa-clock"></i> 04 h/semana</span>
                    <span class="pill"><i class="fas fa-laptop"></i> 04 h prácticas</span>
                </div>
                <a href="${pageContext.request.contextPath}/semanas" class="btn-hero">
                    <i class="fas fa-book-open"></i> Ver Semanas del Curso
                </a>
            </div>
        </section>

        <!-- Estadísticas -->
        <section class="stats-grid">
            <div class="stat-card stat-blue">
                <div class="stat-icon"><i class="fas fa-calendar-week"></i></div>
                <div class="stat-info"><span class="stat-value">${totalSemanas}</span><span class="stat-label">Semanas</span></div>
            </div>
            <div class="stat-card stat-green">
                <div class="stat-icon"><i class="fas fa-file-alt"></i></div>
                <div class="stat-info"><span class="stat-value">${totalMateriales}</span><span class="stat-label">Materiales</span></div>
            </div>
            <div class="stat-card stat-purple">
                <div class="stat-icon"><i class="fas fa-users"></i></div>
                <div class="stat-info"><span class="stat-value">${totalUsuarios}</span><span class="stat-label">Estudiantes</span></div>
            </div>
            <div class="stat-card stat-orange">
                <div class="stat-icon"><i class="fas fa-file-pdf"></i></div>
                <div class="stat-info"><span class="stat-value">${totalPDFs}</span><span class="stat-label">PDFs</span></div>
            </div>
        </section>

        <!-- Descripción + Datos generales -->
        <div class="info-grid">
            <div class="info-card">
                <div class="info-card-header"><i class="fas fa-info-circle"></i><h2>Descripción del Curso</h2></div>
                <div class="info-card-body">
                    <p>La asignatura corresponde a estudios específicos, es de naturaleza práctica, cuyo propósito es comprender y desarrollar una arquitectura de software.</p>
                    <div class="course-detail-grid">
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-user-tie"></i> Docente</span>
                            <span class="detail-value">Mg. Raúl Enrique Fernández Bejarano</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-university"></i> Facultad</span>
                            <span class="detail-value">Facultad de Ingeniería</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-hashtag"></i> Código</span>
                            <span class="detail-value">332181</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-award"></i> Créditos</span>
                            <span class="detail-value">02 créditos</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-calendar"></i> Período</span>
                            <span class="detail-value">2026-I (Abr – Jul 2026)</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-envelope"></i> Correo</span>
                            <span class="detail-value">d.rfernandezb@ms.upla.edu.pe</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-book"></i> Plan</span>
                            <span class="detail-value">2022</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-laptop"></i> Horas práctica</span>
                            <span class="detail-value">04 h/semana</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="info-card">
                <div class="info-card-header"><i class="fas fa-scroll"></i><h2>Sumilla</h2></div>
                <div class="info-card-body">
                    <p>La asignatura permite adquirir las siguientes capacidades:</p>
                    <ul style="color:#CBD5E1;font-size:.88rem;line-height:1.8;padding-left:1.2rem;">
                        <li>Explica los <strong>Fundamentos de la Arquitectura de Software</strong> utilizando estándares internacionales.</li>
                        <li>Crea la arquitectura del software mediante la <strong>POO</strong> para elaborar el modelo arquitectónico.</li>
                        <li>Conoce la <strong>comunicación de arquitecturas</strong> utilizando métodos y técnicas adecuadas.</li>
                        <li>Utiliza los <strong>frameworks de arquitectura de software</strong> con normas internacionales.</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Competencia y logro -->
        <section class="section-card">
            <div class="section-card-header"><i class="fas fa-medal"></i><h2>Competencia General</h2></div>
            <div class="competencias-list">
                <div class="competencia-item">
                    <i class="fas fa-check-circle"></i>
                    <div>
                        <strong>Desarrollo de software y soluciones tecnológicas:</strong>
                        Diseña, implementa y evalúa soluciones de software de manera eficiente y contextualizada, utilizando metodologías de desarrollo, ingeniería de requisitos, arquitectura y estándares de calidad de software.
                    </div>
                </div>
                <div class="competencia-item">
                    <i class="fas fa-check-circle"></i>
                    <div>
                        <strong>Logro general del aprendizaje:</strong>
                        Desarrolla soluciones de software de complejidad media utilizando principios de diseño modular y metodologías ágiles.
                    </div>
                </div>
            </div>
        </section>

        <!-- Unidades del curso -->
        <section class="section-card">
            <div class="section-card-header"><i class="fas fa-layer-group"></i><h2>Contenido del Curso — 4 Unidades</h2></div>
            <div class="unidades-timeline">
                <div class="unidad-item">
                    <div class="unidad-marker">I</div>
                    <div class="unidad-content">
                        <h3>Fundamentos de la Arquitectura de Software y Estándares Internacionales</h3>
                        <p>Semanas 1–4: Introducción a la Arquitectura de Software, Principios y Atributos de Calidad, Estilos y Patrones Arquitectónicos, Documentación y Representación Arquitectónica.</p>
                        <div class="unidad-tags"><span>Semanas 01-04</span><span>Estándares</span><span>Patrones</span><span>25%</span></div>
                    </div>
                </div>
                <div class="unidad-item">
                    <div class="unidad-marker">II</div>
                    <div class="unidad-content">
                        <h3>Modelado de la Arquitectura de Software mediante POO</h3>
                        <p>Semanas 5–8: Principios de POO aplicados a la Arquitectura, Modelado con UML, Diseño de Componentes y Capas, Elaboración y Validación del Modelo Arquitectónico.</p>
                        <div class="unidad-tags"><span>Semanas 05-08</span><span>POO</span><span>UML</span><span>25%</span></div>
                    </div>
                </div>
                <div class="unidad-item">
                    <div class="unidad-marker">III</div>
                    <div class="unidad-content">
                        <h3>Comunicación e Integración de Arquitecturas de Software</h3>
                        <p>Semanas 9–12: Comunicación entre Arquitecturas, Métodos y Tecnologías de Integración, Diseño de Interfaces y Transmisión de Datos, Implementación y Validación.</p>
                        <div class="unidad-tags"><span>Semanas 09-12</span><span>APIs REST</span><span>Microservicios</span><span>25%</span></div>
                    </div>
                </div>
                <div class="unidad-item">
                    <div class="unidad-marker">IV</div>
                    <div class="unidad-content">
                        <h3>Frameworks y Estándares para la Implementación de Arquitecturas</h3>
                        <p>Semanas 13–16: Frameworks de Arquitectura, Normas y Buenas Prácticas, Implementación con Frameworks, Evaluación y Optimización de la Arquitectura.</p>
                        <div class="unidad-tags"><span>Semanas 13-16</span><span>Spring</span><span>TOGAF</span><span>25%</span></div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Evaluación + Bibliografía -->
        <div class="info-grid">
            <section class="section-card">
                <div class="section-card-header"><i class="fas fa-clipboard-check"></i><h2>Sistema de Evaluación</h2></div>
                <div class="evaluacion-list">
                    <div class="evaluacion-item">
                        <span class="eval-label">Unidad I (10%)</span>
                        <div class="eval-bar-wrap"><div class="eval-bar" style="width:20%"></div></div>
                        <span class="eval-pct">20%</span>
                    </div>
                    <div class="evaluacion-item">
                        <span class="eval-label">Unidad II (15%)</span>
                        <div class="eval-bar-wrap"><div class="eval-bar" style="width:20%"></div></div>
                        <span class="eval-pct">20%</span>
                    </div>
                    <div class="evaluacion-item">
                        <span class="eval-label">Unidad III (20%)</span>
                        <div class="eval-bar-wrap"><div class="eval-bar" style="width:20%"></div></div>
                        <span class="eval-pct">20%</span>
                    </div>
                    <div class="evaluacion-item">
                        <span class="eval-label">Unidad IV (25%)</span>
                        <div class="eval-bar-wrap"><div class="eval-bar" style="width:20%"></div></div>
                        <span class="eval-pct">20%</span>
                    </div>
                    <div class="evaluacion-item">
                        <span class="eval-label">Eval. Final (30%)</span>
                        <div class="eval-bar-wrap"><div class="eval-bar" style="width:20%"></div></div>
                        <span class="eval-pct">20%</span>
                    </div>
                </div>
                <div style="padding:.75rem 1.5rem 1.25rem;font-size:.82rem;color:#64748B;">
                    NF = (P1+P2+P3+P4+EDF) / 5 &nbsp;|&nbsp; Nota mínima aprobatoria: <strong style="color:#38BDF8">13</strong> (ingresantes 2026-I)
                </div>
            </section>

            <section class="section-card">
                <div class="section-card-header"><i class="fas fa-book"></i><h2>Bibliografía Principal</h2></div>
                <div class="biblio-list">
                    <div class="biblio-item">
                        <i class="fas fa-book-open"></i>
                        <div><strong>Software Architecture in Practice</strong><span>Bass, Clements, Kazman — Addison-Wesley, 2021</span></div>
                    </div>
                    <div class="biblio-item">
                        <i class="fas fa-book-open"></i>
                        <div><strong>Fundamentals of Software Architecture</strong><span>Richards & Ford — O'Reilly, 2020</span></div>
                    </div>
                    <div class="biblio-item">
                        <i class="fas fa-book-open"></i>
                        <div><strong>Head First Design Patterns</strong><span>Freeman & Freeman — O'Reilly, 2020</span></div>
                    </div>
                    <div class="biblio-item">
                        <i class="fas fa-book-open"></i>
                        <div><strong>Building Microservices</strong><span>Newman — O'Reilly, 2021</span></div>
                    </div>
                    <div class="biblio-item">
                        <i class="fas fa-book-open"></i>
                        <div><strong>UML Distilled</strong><span>Fowler — Addison-Wesley, 2004</span></div>
                    </div>
                </div>
            </section>
        </div>

        <!-- Preview semanas recientes -->
        <c:if test="${not empty ultimasSemanas}">
        <section class="section-card">
            <div class="section-card-header">
                <i class="fas fa-calendar-alt"></i><h2>Semanas Recientes</h2>
                <a href="${pageContext.request.contextPath}/semanas" class="section-link">Ver todas <i class="fas fa-arrow-right"></i></a>
            </div>
            <div class="semanas-preview-grid">
                <c:forEach var="semana" items="${ultimasSemanas}">
                <div class="semana-preview-card">
                    <div class="semana-preview-num">${semana.numeroFormateado}</div>
                    <h3>${semana.titulo}</h3>
                    <p>${semana.descripcion}</p>
                    <div class="semana-preview-footer">
                        <span><i class="fas fa-file"></i> ${semana.cantidadMateriales} materiales</span>
                        <a href="${pageContext.request.contextPath}/semanas?id=${semana.id}">Ver <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
                </c:forEach>
            </div>
        </section>
        </c:if>

    </div>
</div>

<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
</body>
</html>
