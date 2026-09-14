-- ═══════════════════════════════════════════════════════════════════════════
-- DATABASE.SQL — Arquitectura de Software | UPLA
-- Código: 332181 | Semestre 2026-I
-- Ejecutar en Supabase SQL Editor
-- ═══════════════════════════════════════════════════════════════════════════

-- ── Tabla: usuarios ──────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS usuarios (
    id              SERIAL PRIMARY KEY,
    auth_id         UUID UNIQUE NOT NULL,
    nombre          VARCHAR(100) NOT NULL,
    correo          VARCHAR(150) UNIQUE NOT NULL,
    rol             VARCHAR(20) NOT NULL DEFAULT 'USUARIO'
                        CHECK (rol IN ('ADMINISTRADOR', 'USUARIO')),
    avatar_url      TEXT,
    activo          BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ── Tabla: semanas ────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS semanas (
    id                    SERIAL PRIMARY KEY,
    numero                INTEGER UNIQUE NOT NULL CHECK (numero > 0),
    titulo                VARCHAR(200) NOT NULL,
    descripcion           TEXT,
    contenido             TEXT,
    fecha_creacion        TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    fecha_actualizacion   TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ── Tabla: materiales ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS materiales (
    id              SERIAL PRIMARY KEY,
    semana_id       INTEGER NOT NULL REFERENCES semanas(id) ON DELETE CASCADE,
    usuario_id      INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    nombre          VARCHAR(255) NOT NULL,
    nombre_original VARCHAR(255) NOT NULL,
    tipo            VARCHAR(20) NOT NULL DEFAULT 'OTHER'
                        CHECK (tipo IN ('PDF','IMAGE','WORD','EXCEL','POWERPOINT','TEXT','ZIP','OTHER')),
    extension       VARCHAR(10) NOT NULL,
    mime_type       VARCHAR(100),
    tamano          BIGINT NOT NULL DEFAULT 0,
    storage_path    TEXT NOT NULL,
    url             TEXT,
    descripcion     TEXT,
    fecha_subida    TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ── Índices ───────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_materiales_semana_id    ON materiales(semana_id);
CREATE INDEX IF NOT EXISTS idx_materiales_usuario_id   ON materiales(usuario_id);
CREATE INDEX IF NOT EXISTS idx_materiales_tipo          ON materiales(tipo);
CREATE INDEX IF NOT EXISTS idx_materiales_fecha_subida  ON materiales(fecha_subida DESC);
CREATE INDEX IF NOT EXISTS idx_usuarios_auth_id         ON usuarios(auth_id);
CREATE INDEX IF NOT EXISTS idx_usuarios_correo          ON usuarios(correo);
CREATE INDEX IF NOT EXISTS idx_semanas_numero           ON semanas(numero);

-- ── Semanas del curso: Arquitectura de Software (332181) ──────────────────
INSERT INTO semanas (numero, titulo, descripcion, contenido) VALUES
(1, 'Introducción a la Arquitectura de Software',
    'Identifica los conceptos, objetivos, importancia y elementos fundamentales de la arquitectura de software.',
    'Conceptos fundamentales de la arquitectura de software. Análisis de casos de estudio reales para reconocer su impacto en la calidad y sostenibilidad de un proyecto de software. Definición inicial del proyecto integrador.'),
(2, 'Principios, Atributos de Calidad y Estándares Internacionales',
    'Analiza los principios arquitectónicos, atributos de calidad y estándares internacionales aplicables al desarrollo de software.',
    'Principios arquitectónicos. Atributos de calidad: disponibilidad, rendimiento, seguridad, mantenibilidad. Estándares internacionales. Evaluación de su contribución al cumplimiento de requisitos del proyecto ABP.'),
(3, 'Estilos y Patrones Arquitectónicos',
    'Compara estilos y patrones arquitectónicos de software mediante el análisis de escenarios de aplicación.',
    'Estilos arquitectónicos: Capas, Cliente-Servidor, MVC, Microservicios, SOA, Event-Driven. Patrones de diseño GoF aplicados a la arquitectura. Selección del patrón más adecuado para el proyecto ABP.'),
(4, 'Documentación y Representación Arquitectónica',
    'Elabora la documentación preliminar de la arquitectura de software utilizando modelos y diagramas reconocidos internacionalmente.',
    'Modelos de documentación arquitectónica. Vistas 4+1. Diagramas C4. Justificación de decisiones arquitectónicas adoptadas. Buenas prácticas internacionales. Ingreso de notas al sistema.'),
(5, 'Principios de POO aplicados a la Arquitectura de Software',
    'Analiza los principios fundamentales de la POO identificando su aplicación en la construcción de modelos arquitectónicos.',
    'Abstracción, encapsulamiento, herencia y polimorfismo. Aplicación en la construcción de modelos arquitectónicos. Identificación de componentes y capas del proyecto de software desarrollado mediante ABP.'),
(6, 'Modelado Arquitectónico con UML',
    'Diseña diagramas UML que representen la estructura lógica del proyecto de software.',
    'Diagramas UML: casos de uso, clases y paquetes. Principios de modelado orientado a objetos. Buenas prácticas de arquitectura. Herramientas CASE para modelado arquitectónico.'),
(7, 'Diseño de Componentes y Capas de la Arquitectura',
    'Construye el modelo arquitectónico del proyecto mediante la definición de componentes, capas y responsabilidades entre objetos.',
    'Definición de componentes y capas arquitectónicas. Responsabilidades y relaciones entre objetos. Cohesión y bajo acoplamiento. Arquitectura en capas: presentación, lógica de negocio, acceso a datos.'),
(8, 'Elaboración y Validación del Modelo Arquitectónico',
    'Integra los artefactos de modelado orientado a objetos para elaborar y validar la arquitectura del software del proyecto.',
    'Integración de artefactos UML. Validación de la arquitectura del proyecto. Sustentación técnica de decisiones de diseño adoptadas según los requisitos establecidos. Ingreso de notas al sistema.'),
(9, 'Fundamentos de la Comunicación entre Arquitecturas de Software',
    'Analiza los mecanismos de comunicación entre componentes y arquitecturas de software.',
    'Mecanismos de comunicación entre componentes. Protocolos de comunicación (HTTP, HTTPS, WebSockets). Modelos de interacción y flujos de información. Integración efectiva de módulos del proyecto ABP.'),
(10, 'Métodos y Tecnologías para la Integración de Sistemas',
     'Selecciona métodos, tecnologías y estándares de comunicación para la integración de aplicaciones.',
     'Servicios web SOAP y REST. APIs RESTful. Mensajería (RabbitMQ, Kafka). Evaluación de alternativas de integración. Requerimientos funcionales y no funcionales del proyecto.'),
(11, 'Diseño de Interfaces y Transmisión de Datos',
     'Diseña interfaces de comunicación y mecanismos de intercambio de datos entre componentes de software.',
     'Diseño de interfaces de comunicación. Intercambio de datos en formatos estándar: JSON, XML. Técnicas de interoperabilidad. Modelado de servicios para garantizar la correcta transmisión de información en el proyecto.'),
(12, 'Implementación y Validación de la Comunicación Arquitectónica',
     'Implementa y valida los mecanismos de comunicación definidos para la arquitectura del proyecto.',
     'Implementación de mecanismos de comunicación. Verificación de integridad, disponibilidad y eficiencia. Pruebas de integración. Herramientas de monitoreo. Ingreso de notas al sistema.'),
(13, 'Fundamentos de Frameworks de Arquitectura de Software',
     'Analiza las características, ventajas y ámbitos de aplicación de los principales frameworks de arquitectura.',
     'Frameworks de arquitectura: Spring, TOGAF, .NET, Django. Características y ventajas comparativas. Contribución al desarrollo de soluciones escalables y mantenibles alineadas con los requisitos del proyecto ABP.'),
(14, 'Normas y Buenas Prácticas en Arquitectura de Software',
     'Aplica normas internacionales, estándares y buenas prácticas de arquitectura de software para seleccionar el framework más adecuado.',
     'ISO/IEC 25010 (calidad del software). TOGAF Standard. Buenas prácticas de arquitectura. Criterios de selección: calidad, interoperabilidad, seguridad y rendimiento del proyecto.'),
(15, 'Implementación de la Arquitectura utilizando Frameworks',
     'Implementa componentes arquitectónicos del proyecto mediante un framework de software apropiado.',
     'Implementación con Spring Framework o framework seleccionado. Integración de patrones de diseño. Mecanismos de comunicación y principios de arquitectura previamente definidos. Pruebas funcionales.'),
(16, 'Evaluación y Optimización de la Arquitectura de Software',
     'Evalúa la arquitectura implementada mediante pruebas y métricas de calidad, proponiendo mejoras y optimizaciones.',
     'Evaluación mediante pruebas y métricas de calidad. Atributos: mantenibilidad, escalabilidad, interoperabilidad y seguridad. Propuesta de mejoras. Sustentación final del proyecto integrador. Ingreso de notas al sistema.')
ON CONFLICT (numero) DO NOTHING;

-- ── Notas ─────────────────────────────────────────────────────────────────
-- 1. Crear bucket "materiales" en Supabase Storage (público)
-- 2. Los usuarios se registran automáticamente al primer login
-- 3. Para dar rol ADMINISTRADOR ejecutar:
--    UPDATE usuarios SET rol = 'ADMINISTRADOR' WHERE correo = 'tu@correo.com';
