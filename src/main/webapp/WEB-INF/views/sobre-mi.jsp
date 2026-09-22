<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sobre mí — Elvis Ramirez Ore | UPLA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* ══ SOBRE MÍ — Página completa ══════════════════════════════ */
        .sm-hero {
            background: linear-gradient(135deg, #0F172A 0%, #1B2E4A 50%, #0F172A 100%);
            border: 1px solid rgba(27,126,194,.25);
            border-radius: 1.5rem;
            padding: 2.5rem 2.5rem 2rem;
            display: flex;
            align-items: center;
            gap: 2rem;
            margin-bottom: 1.5rem;
            position: relative;
            overflow: hidden;
        }
        .sm-hero::before {
            content: '';
            position: absolute; top:0; left:0; right:0; height:4px;
            background: linear-gradient(90deg, #1B7EC2, #38BDF8, #1B7EC2);
        }
        .sm-hero::after {
            content: '';
            position: absolute; right:-40px; top:-40px;
            width: 200px; height: 200px;
            border-radius: 50%;
            background: rgba(27,126,194,.06);
        }
        .sm-avatar-big {
            width: 100px; height: 100px;
            border-radius: 50%;
            background: linear-gradient(135deg, #1B7EC2, #38BDF8);
            display: flex; align-items: center; justify-content: center;
            font-size: 2.4rem; font-weight: 900; color: #fff;
            flex-shrink: 0;
            box-shadow: 0 0 0 4px rgba(27,126,194,.25), 0 12px 32px rgba(27,126,194,.35);
            position: relative; z-index: 1;
        }
        .sm-hero-info { flex: 1; position: relative; z-index: 1; }
        .sm-hero-name {
            font-size: 2rem; font-weight: 900; color: #F8FAFC;
            margin-bottom: .4rem; line-height: 1.2;
        }
        .sm-hero-badges {
            display: flex; flex-wrap: wrap; gap: .5rem;
            margin-bottom: .75rem;
        }
        .sm-badge {
            display: inline-flex; align-items: center; gap: .35rem;
            font-size: .78rem; font-weight: 700;
            padding: .3rem .85rem; border-radius: 2rem;
        }
        .sm-badge-code {
            background: rgba(27,126,194,.2);
            border: 1px solid rgba(27,126,194,.4);
            color: #38BDF8;
        }
        .sm-badge-carrera {
            background: rgba(168,85,247,.15);
            border: 1px solid rgba(168,85,247,.3);
            color: #c084fc;
        }
        .sm-badge-upla {
            background: rgba(34,197,94,.12);
            border: 1px solid rgba(34,197,94,.3);
            color: #4ade80;
        }
        .sm-hero-loc {
            font-size: .85rem; color: #64748B;
            display: flex; align-items: center; gap: .5rem;
        }
        .sm-hero-loc i { color: #1B7EC2; }

        /* Secciones */
        .sm-section {
            background: #1E293B;
            border: 1px solid #334155;
            border-radius: 1.25rem;
            margin-bottom: 1.25rem;
            overflow: hidden;
        }
        .sm-section-header {
            display: flex; align-items: center; gap: .65rem;
            padding: 1.1rem 1.5rem;
            border-bottom: 1px solid #334155;
            background: rgba(255,255,255,.02);
        }
        .sm-section-header i { color: #1B7EC2; font-size: 1.1rem; }
        .sm-section-header h2 { font-size: 1rem; font-weight: 700; color: #F8FAFC; }
        .sm-section-body { padding: 1.5rem; }
        .sm-section-body p {
            color: #CBD5E1; line-height: 1.8; font-size: .92rem;
            margin-bottom: 1rem;
        }
        .sm-section-body p:last-child { margin-bottom: 0; }

        /* Tags de tecnologías */
        .sm-tech-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: .75rem;
            padding: 1.5rem;
        }
        .sm-tech-item {
            display: flex; align-items: center; gap: .75rem;
            background: rgba(255,255,255,.03);
            border: 1px solid #334155;
            border-radius: .75rem;
            padding: .85rem 1rem;
            transition: .25s ease;
        }
        .sm-tech-item:hover {
            border-color: rgba(27,126,194,.4);
            background: rgba(27,126,194,.06);
            transform: translateY(-2px);
        }
        .sm-tech-icon {
            width: 36px; height: 36px;
            border-radius: .5rem;
            display: flex; align-items: center; justify-content: center;
            font-size: 1rem; flex-shrink: 0;
        }
        .sm-tech-name { font-size: .85rem; font-weight: 600; color: #F8FAFC; }
        .sm-tech-desc { font-size: .72rem; color: #64748B; margin-top: .1rem; }

        .ti-java    { background:rgba(249,115,22,.2);  color:#fb923c; }
        .ti-db      { background:rgba(34,197,94,.2);   color:#4ade80; }
        .ti-devops  { background:rgba(37,99,235,.2);   color:#60A5FA; }
        .ti-uml     { background:rgba(168,85,247,.2);  color:#c084fc; }
        .ti-mobile  { background:rgba(20,184,166,.2);  color:#2dd4bf; }
        .ti-net     { background:rgba(245,158,11,.2);  color:#fbbf24; }
        .ti-linux   { background:rgba(239,68,68,.2);   color:#f87171; }
        .ti-sql     { background:rgba(14,165,233,.2);  color:#38bdf8; }

        /* Intereses */
        .sm-interests {
            display: flex; flex-wrap: wrap; gap: .65rem;
            padding: 1.25rem 1.5rem;
        }
        .sm-interest {
            display: inline-flex; align-items: center; gap: .4rem;
            background: rgba(27,126,194,.1);
            border: 1px solid rgba(27,126,194,.25);
            color: #94A3B8;
            font-size: .82rem; font-weight: 500;
            padding: .4rem 1rem; border-radius: 2rem;
        }
        .sm-interest i { color: #38BDF8; font-size: .8rem; }

        /* Contacto / info */
        .sm-info-grid {
            display: grid; grid-template-columns: 1fr 1fr;
            gap: .75rem; padding: 1.5rem;
        }
        .sm-info-item {
            display: flex; align-items: flex-start; gap: .75rem;
            background: rgba(255,255,255,.03);
            border: 1px solid #334155;
            border-radius: .75rem;
            padding: .85rem 1rem;
        }
        .sm-info-item i { color: #1B7EC2; font-size: 1rem; margin-top: .1rem; flex-shrink:0; }
        .sm-info-label { font-size: .72rem; color: #64748B; text-transform: uppercase; letter-spacing:.05em; font-weight:700; }
        .sm-info-value { font-size: .88rem; color: #F8FAFC; font-weight: 600; margin-top: .1rem; }

        @media(max-width:768px) {
            .sm-hero { flex-direction:column; text-align:center; }
            .sm-hero-badges { justify-content:center; }
            .sm-hero-loc { justify-content:center; }
            .sm-hero-name { font-size:1.5rem; }
            .sm-tech-grid { grid-template-columns: 1fr 1fr; }
            .sm-info-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<div class="main-content" id="mainContent">

    <header class="topbar">
        <button class="sidebar-toggle" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
        <div class="topbar-title"><h1><i class="fas fa-user-circle"></i> Sobre mí</h1></div>
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

        <!-- ── Hero ─────────────────────────────────────────────── -->
        <div class="sm-hero">
            <div class="sm-avatar-big">ER</div>
            <div class="sm-hero-info">
                <div class="sm-hero-name">Elvis Ramirez Ore</div>
                <div class="sm-hero-badges">
                    <span class="sm-badge sm-badge-code"><i class="fas fa-id-card"></i> s01284d</span>
                    <span class="sm-badge sm-badge-carrera"><i class="fas fa-graduation-cap"></i> Ing. Sistemas y Computación</span>
                    <span class="sm-badge sm-badge-upla"><i class="fas fa-university"></i> UPLA</span>
                </div>
                <div class="sm-hero-loc">
                    <i class="fas fa-map-marker-alt"></i> Huancayo, Perú
                    <span style="color:#334155">·</span>
                    <i class="fas fa-calendar"></i> Semestre 2026-I
                    <span style="color:#334155">·</span>
                    <i class="fas fa-book"></i> Plan 2022
                </div>
            </div>
        </div>

        <!-- ── ¿Quién soy? ────────────────────────────────────── -->
        <div class="sm-section">
            <div class="sm-section-header">
                <i class="fas fa-user"></i><h2>¿Quién soy?</h2>
            </div>
            <div class="sm-section-body">
                <p>
                    Soy <strong>Elvis Ramirez Ore</strong>, estudiante de <strong>Ingeniería de Sistemas y Computación</strong>
                    en la Universidad Peruana Los Andes (UPLA), actualmente cursando el semestre 2026-I bajo el plan de estudios 2022.
                    Mi número de código estudiantil es <strong>s01284d</strong>.
                </p>
                <p>
                    Me apasiona el mundo del desarrollo de software, especialmente todo lo relacionado con el
                    <strong>diseño y arquitectura de sistemas</strong>. Disfruto modelar soluciones complejas
                    usando diagramas <strong>UML y BPMN 2.0</strong>, comprendiendo cómo los distintos
                    componentes de un sistema interactúan entre sí para lograr una solución robusta, escalable y mantenible.
                </p>
                <p>
                    También tengo experiencia en <strong>administración de bases de datos relacionales</strong>,
                    trabajando con <strong>PostgreSQL</strong>, <strong>Supabase</strong> y <strong>Microsoft SQL Server</strong>,
                    desde el modelado de entidades hasta la optimización de consultas y la gestión de usuarios y permisos.
                </p>
                <p>
                    En el área de desarrollo, he trabajado con <strong>Java (Servlets/JSP)</strong> para aplicaciones web
                    empresariales con arquitectura MVC, y también exploro el desarrollo móvil con <strong>Kotlin</strong>
                    y <strong>Flutter</strong> para crear aplicaciones multiplataforma. Adicionalmente tengo conocimientos
                    en redes y telecomunicaciones usando <strong>Cisco Packet Tracer</strong> y en administración de
                    servidores con <strong>Debian Linux</strong>.
                </p>
            </div>
        </div>

        <!-- ── A qué me dedico ────────────────────────────────── -->
        <div class="sm-section">
            <div class="sm-section-header">
                <i class="fas fa-briefcase"></i><h2>A qué me dedico</h2>
            </div>
            <div class="sm-section-body">
                <p>
                    Actualmente me enfoco en el estudio y aplicación de la <strong>Arquitectura de Software</strong>,
                    investigando los fundamentos teóricos de los principales estilos arquitectónicos
                    (Capas, MVC, Microservicios, SOA, Event-Driven) y su aplicación práctica en proyectos reales.
                </p>
                <p>
                    Desarrollo proyectos académicos aplicando metodología <strong>ABP (Aprendizaje Basado en Proyectos)</strong>,
                    donde integro análisis de requerimientos, diseño de componentes con <strong>UML</strong>,
                    implementación con frameworks modernos y documentación técnica detallada.
                </p>
                <p>
                    Estoy interesado en construir soluciones que sean no solo funcionales, sino también
                    <strong>escalables, seguras y mantenibles</strong>, aplicando principios como SOLID,
                    patrones de diseño GoF, y estándares internacionales de calidad de software como ISO/IEC 25010.
                </p>
            </div>
        </div>

        <!-- ── Tecnologías ────────────────────────────────────── -->
        <div class="sm-section">
            <div class="sm-section-header">
                <i class="fas fa-tools"></i><h2>Herramientas y Tecnologías</h2>
            </div>
            <div class="sm-tech-grid">
                <div class="sm-tech-item">
                    <div class="sm-tech-icon ti-java"><i class="fab fa-java"></i></div>
                    <div>
                        <div class="sm-tech-name">Java (Servlets/JSP)</div>
                        <div class="sm-tech-desc">Aplicaciones web MVC con Tomcat</div>
                    </div>
                </div>
                <div class="sm-tech-item">
                    <div class="sm-tech-icon ti-db"><i class="fas fa-database"></i></div>
                    <div>
                        <div class="sm-tech-name">PostgreSQL / Supabase</div>
                        <div class="sm-tech-desc">BD relacional + backend as a service</div>
                    </div>
                </div>
                <div class="sm-tech-item">
                    <div class="sm-tech-icon ti-sql"><i class="fas fa-server"></i></div>
                    <div>
                        <div class="sm-tech-name">Microsoft SQL Server</div>
                        <div class="sm-tech-desc">Administración y consultas avanzadas</div>
                    </div>
                </div>
                <div class="sm-tech-item">
                    <div class="sm-tech-icon ti-devops"><i class="fab fa-docker"></i></div>
                    <div>
                        <div class="sm-tech-name">Docker &amp; Render</div>
                        <div class="sm-tech-desc">Contenedores y despliegue en la nube</div>
                    </div>
                </div>
                <div class="sm-tech-item">
                    <div class="sm-tech-icon ti-uml"><i class="fas fa-project-diagram"></i></div>
                    <div>
                        <div class="sm-tech-name">BPMN 2.0 / UML</div>
                        <div class="sm-tech-desc">Modelado de procesos y sistemas</div>
                    </div>
                </div>
                <div class="sm-tech-item">
                    <div class="sm-tech-icon ti-mobile"><i class="fas fa-mobile-alt"></i></div>
                    <div>
                        <div class="sm-tech-name">Kotlin / Flutter</div>
                        <div class="sm-tech-desc">Desarrollo móvil nativo y multiplataforma</div>
                    </div>
                </div>
                <div class="sm-tech-item">
                    <div class="sm-tech-icon ti-net"><i class="fas fa-network-wired"></i></div>
                    <div>
                        <div class="sm-tech-name">Cisco Packet Tracer</div>
                        <div class="sm-tech-desc">Simulación y diseño de redes</div>
                    </div>
                </div>
                <div class="sm-tech-item">
                    <div class="sm-tech-icon ti-linux"><i class="fab fa-linux"></i></div>
                    <div>
                        <div class="sm-tech-name">Debian Linux</div>
                        <div class="sm-tech-desc">Administración de servidores Linux</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ── Áreas de interés ───────────────────────────────── -->
        <div class="sm-section">
            <div class="sm-section-header">
                <i class="fas fa-star"></i><h2>Áreas de Interés</h2>
            </div>
            <div class="sm-interests">
                <span class="sm-interest"><i class="fas fa-sitemap"></i> Arquitectura de Software</span>
                <span class="sm-interest"><i class="fas fa-project-diagram"></i> Modelado UML/BPMN</span>
                <span class="sm-interest"><i class="fas fa-database"></i> Administración de BD</span>
                <span class="sm-interest"><i class="fas fa-code"></i> Desarrollo Web</span>
                <span class="sm-interest"><i class="fas fa-mobile-alt"></i> Desarrollo Móvil</span>
                <span class="sm-interest"><i class="fab fa-docker"></i> DevOps / Cloud</span>
                <span class="sm-interest"><i class="fas fa-network-wired"></i> Redes y Telecomunicaciones</span>
                <span class="sm-interest"><i class="fas fa-shield-alt"></i> Seguridad en Software</span>
                <span class="sm-interest"><i class="fas fa-cubes"></i> Microservicios</span>
                <span class="sm-interest"><i class="fas fa-robot"></i> Automatización de Procesos</span>
            </div>
        </div>

        <!-- ── Información académica ──────────────────────────── -->
        <div class="sm-section">
            <div class="sm-section-header">
                <i class="fas fa-graduation-cap"></i><h2>Información Académica</h2>
            </div>
            <div class="sm-info-grid">
                <div class="sm-info-item">
                    <i class="fas fa-id-card"></i>
                    <div><div class="sm-info-label">Código</div><div class="sm-info-value">s01284d</div></div>
                </div>
                <div class="sm-info-item">
                    <i class="fas fa-university"></i>
                    <div><div class="sm-info-label">Universidad</div><div class="sm-info-value">Universidad Peruana Los Andes</div></div>
                </div>
                <div class="sm-info-item">
                    <i class="fas fa-laptop-code"></i>
                    <div><div class="sm-info-label">Carrera</div><div class="sm-info-value">Ingeniería de Sistemas y Computación</div></div>
                </div>
                <div class="sm-info-item">
                    <i class="fas fa-calendar-alt"></i>
                    <div><div class="sm-info-label">Semestre actual</div><div class="sm-info-value">2026-I</div></div>
                </div>
                <div class="sm-info-item">
                    <i class="fas fa-book"></i>
                    <div><div class="sm-info-label">Plan de estudios</div><div class="sm-info-value">2022</div></div>
                </div>
                <div class="sm-info-item">
                    <i class="fas fa-map-marker-alt"></i>
                    <div><div class="sm-info-label">Ciudad</div><div class="sm-info-value">Huancayo, Perú</div></div>
                </div>
                <div class="sm-info-item">
                    <i class="fas fa-chalkboard-teacher"></i>
                    <div><div class="sm-info-label">Curso actual</div><div class="sm-info-value">Arquitectura de Software (332181)</div></div>
                </div>
                <div class="sm-info-item">
                    <i class="fas fa-user-tie"></i>
                    <div><div class="sm-info-label">Docente</div><div class="sm-info-value">Mg. Raúl Enrique Fernández Bejarano</div></div>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
