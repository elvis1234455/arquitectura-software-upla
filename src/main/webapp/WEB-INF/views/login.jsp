<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión — Arquitectura de Software | UPLA</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --upla-blue:   #1B7EC2;
            --upla-dark:   #0F172A;
            --upla-card:   #1E293B;
            --upla-border: #334155;
            --upla-text:   #F8FAFC;
            --upla-muted:  #94A3B8;
            --upla-error:  #ef4444;
            --upla-success:#22c55e;
        }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: var(--upla-dark);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
            position: relative;
            overflow: hidden;
        }

        /* Fondo animado */
        body::before {
            content: '';
            position: fixed; inset: 0;
            background:
                radial-gradient(ellipse 80% 60% at 20% 40%, rgba(27,126,194,.18) 0%, transparent 60%),
                radial-gradient(ellipse 60% 50% at 80% 70%, rgba(27,126,194,.12) 0%, transparent 50%);
            pointer-events: none;
        }

        /* ── Tarjeta principal ── */
        .login-card {
            background: rgba(30,41,59,.95);
            border: 1px solid rgba(255,255,255,.08);
            border-radius: 1.5rem;
            padding: 2.75rem 2.5rem;
            width: 100%;
            max-width: 420px;
            position: relative;
            z-index: 1;
            backdrop-filter: blur(20px);
            box-shadow:
                0 0 0 1px rgba(27,126,194,.15),
                0 25px 60px rgba(0,0,0,.5),
                0 0 80px rgba(27,126,194,.08);
            animation: cardIn .5s cubic-bezier(.34,1.56,.64,1);
        }

        @keyframes cardIn {
            from { opacity:0; transform: translateY(24px) scale(.97); }
            to   { opacity:1; transform: translateY(0) scale(1); }
        }

        /* ── Header con logo ── */
        .login-header {
            text-align: center;
            margin-bottom: 2.25rem;
        }

        .upla-hex-logo {
            width: 88px;
            height: 88px;
            margin: 0 auto 1.1rem;
            animation: logoFloat 3s ease-in-out infinite;
        }

        .upla-logo-img {
            width: 88px;
            height: 88px;
            object-fit: contain;
            border-radius: 1rem;
            filter: drop-shadow(0 8px 24px rgba(27,126,194,.5));
        }

        .login-title {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--upla-text);
            margin-bottom: .35rem;
            letter-spacing: -.02em;
        }

        .login-subtitle {
            font-size: .82rem;
            color: var(--upla-muted);
            line-height: 1.5;
        }

        .login-subtitle strong {
            color: #38BDF8;
            display: block;
            font-size: .88rem;
        }

        /* Divisor */
        .login-divider {
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(27,126,194,.4), transparent);
            margin-bottom: 1.75rem;
        }

        /* ── Alertas ── */
        .alert {
            display: flex;
            align-items: center;
            gap: .65rem;
            padding: .8rem 1rem;
            border-radius: .65rem;
            font-size: .85rem;
            margin-bottom: 1.25rem;
            animation: alertIn .3s ease;
        }
        @keyframes alertIn { from{opacity:0;transform:translateY(-8px)}to{opacity:1;transform:translateY(0)} }
        .alert-error   { background:rgba(239,68,68,.12);  border:1px solid rgba(239,68,68,.25);  color:#fca5a5; }
        .alert-success { background:rgba(34,197,94,.12);  border:1px solid rgba(34,197,94,.25);  color:#86efac; }
        .alert-warning { background:rgba(245,158,11,.12); border:1px solid rgba(245,158,11,.25); color:#fde68a; }

        /* ── Campos ── */
        .field {
            margin-bottom: 1.1rem;
        }

        .field-label {
            display: flex;
            align-items: center;
            gap: .4rem;
            font-size: .78rem;
            font-weight: 700;
            color: var(--upla-muted);
            text-transform: uppercase;
            letter-spacing: .07em;
            margin-bottom: .45rem;
        }

        .field-label i { color: var(--upla-blue); font-size: .85rem; }

        .field-wrap {
            position: relative;
        }

        .field-input {
            width: 100%;
            padding: .85rem 3rem .85rem 1rem;
            background: rgba(255,255,255,.04);
            border: 1.5px solid var(--upla-border);
            border-radius: .75rem;
            color: var(--upla-text);
            font-size: .95rem;
            font-family: inherit;
            outline: none;
            transition: .25s ease;
        }

        .field-input:focus {
            border-color: var(--upla-blue);
            background: rgba(27,126,194,.06);
            box-shadow: 0 0 0 3px rgba(27,126,194,.18);
        }

        .field-input::placeholder { color: #475569; }

        .field-icon {
            position: absolute;
            right: 1rem; top: 50%;
            transform: translateY(-50%);
            color: #475569;
            pointer-events: none;
        }

        .field-toggle {
            position: absolute;
            right: .85rem; top: 50%;
            transform: translateY(-50%);
            background: none; border: none;
            color: #475569; cursor: pointer;
            padding: .2rem;
            transition: color .2s;
            font-size: .9rem;
        }
        .field-toggle:hover { color: var(--upla-blue); }

        .field-error-msg {
            font-size: .75rem;
            color: var(--upla-error);
            margin-top: .3rem;
            display: block;
            min-height: .9rem;
        }

        /* ── Botón submit ── */
        .btn-submit {
            width: 100%;
            padding: .95rem;
            background: linear-gradient(135deg, #1B7EC2, #155f92);
            color: #fff;
            border: none;
            border-radius: .75rem;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            font-family: inherit;
            letter-spacing: .02em;
            transition: .25s ease;
            margin-top: .25rem;
            position: relative;
            overflow: hidden;
        }

        .btn-submit::after {
            content: '';
            position: absolute; inset: 0;
            background: linear-gradient(135deg, #155f92, #1B7EC2);
            opacity: 0;
            transition: opacity .25s;
        }

        .btn-submit:hover::after { opacity: 1; }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 8px 28px rgba(27,126,194,.45); }
        .btn-submit:active { transform: translateY(0); }
        .btn-submit:disabled { opacity: .6; cursor: not-allowed; transform: none; }

        .btn-submit span {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: .5rem;
        }

        /* ── Footer ── */
        .login-footer {
            text-align: center;
            margin-top: 1.75rem;
            padding-top: 1.25rem;
            border-top: 1px solid rgba(255,255,255,.06);
        }

        .login-footer-logo {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: .6rem;
            margin-bottom: .4rem;
        }

        .login-footer-logo svg {
            width: 22px; height: 22px;
            opacity: .5;
        }

        .login-footer p {
            font-size: .75rem;
            color: #475569;
        }

        .login-footer strong { color: #64748B; }

        /* Partículas decorativas */
        .particle {
            position: fixed;
            width: 3px; height: 3px;
            background: rgba(27,126,194,.4);
            border-radius: 50%;
            pointer-events: none;
            animation: float linear infinite;
        }
        @keyframes float {
            from { transform: translateY(100vh) rotate(0deg); opacity: 1; }
            to   { transform: translateY(-100px) rotate(720deg); opacity: 0; }
        }

        /* Responsive */
        @media(max-width:480px) {
            .login-card { padding: 2rem 1.5rem; }
            .login-title { font-size: 1.3rem; }
        }
    </style>
</head>
<body>

<!-- Partículas decorativas -->
<div class="particle" style="left:10%;animation-duration:8s;animation-delay:0s"></div>
<div class="particle" style="left:25%;animation-duration:12s;animation-delay:2s"></div>
<div class="particle" style="left:50%;animation-duration:9s;animation-delay:4s"></div>
<div class="particle" style="left:70%;animation-duration:11s;animation-delay:1s"></div>
<div class="particle" style="left:85%;animation-duration:7s;animation-delay:3s"></div>

<div class="login-card">

    <!-- Header con logo hexagonal UPLA -->
    <div class="login-header">
        <div class="upla-hex-logo">
            <img src="${pageContext.request.contextPath}/images/upla-logo.png"
                 alt="Universidad Peruana Los Andes"
                 class="upla-logo-img">
        </div>

        <h1 class="login-title">Arquitectura de Software</h1>
        <p class="login-subtitle">
            <strong>Universidad Peruana Los Andes</strong>
            Ingeniería de Sistemas y Computación · 2026-I
        </p>
    </div>

    <div class="login-divider"></div>

    <!-- Alertas -->
    <c:if test="${not empty param.logout}">
        <div class="alert alert-success" id="alertMsg">
            <i class="fas fa-check-circle"></i><span>Sesión cerrada correctamente.</span>
        </div>
    </c:if>
    <c:if test="${param.error eq 'cuenta_inactiva'}">
        <div class="alert alert-warning" id="alertMsg">
            <i class="fas fa-exclamation-triangle"></i><span>Cuenta desactivada. Contacta al docente.</span>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error" id="alertMsg">
            <i class="fas fa-times-circle"></i><span>${error}</span>
        </div>
    </c:if>

    <!-- Formulario -->
    <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm" novalidate>

        <div class="field">
            <label class="field-label" for="correo">
                <i class="fas fa-envelope"></i> Correo electrónico
            </label>
            <div class="field-wrap">
                <input type="email" id="correo" name="correo"
                       class="field-input"
                       placeholder="correo@institucional.edu.pe"
                       value="${param.correo}"
                       autocomplete="email" required>
                <span class="field-icon"><i class="fas fa-at"></i></span>
            </div>
            <span class="field-error-msg" id="correoError"></span>
        </div>

        <div class="field">
            <label class="field-label" for="contrasena">
                <i class="fas fa-lock"></i> Contraseña
            </label>
            <div class="field-wrap">
                <input type="password" id="contrasena" name="contrasena"
                       class="field-input"
                       placeholder="••••••••"
                       autocomplete="current-password" required>
                <button type="button" class="field-toggle" onclick="togglePassword()">
                    <i class="fas fa-eye" id="eyeIcon"></i>
                </button>
            </div>
            <span class="field-error-msg" id="contrasenaError"></span>
        </div>

        <button type="submit" class="btn-submit" id="btnLogin">
            <span class="btn-text">
                <i class="fas fa-sign-in-alt"></i> Iniciar Sesión
            </span>
            <span class="btn-loading" style="display:none;">
                <i class="fas fa-spinner fa-spin"></i> Verificando...
            </span>
        </button>

    </form>

    <!-- Footer -->
    <div class="login-footer">
        <div class="login-footer-logo">
            <img src="${pageContext.request.contextPath}/images/upla-logo.png"
                 alt="UPLA" style="height:22px;opacity:.5;">
            <strong>UPLA</strong>
        </div>
        <p>Facultad de Ingeniería &copy; <span id="yearLogin"></span></p>
        <p style="margin-top:.2rem;font-size:.7rem;color:#334155;">Código: 332181 · Mg. Raúl Fernández Bejarano</p>
    </div>
</div>

<script>
function togglePassword() {
    const input = document.getElementById('contrasena');
    const icon  = document.getElementById('eyeIcon');
    input.type  = input.type === 'password' ? 'text' : 'password';
    icon.className = input.type === 'password' ? 'fas fa-eye' : 'fas fa-eye-slash';
}

document.getElementById('yearLogin').textContent = new Date().getFullYear();

const form = document.getElementById('loginForm');
const btnLogin = document.getElementById('btnLogin');
form.addEventListener('submit', function(e) {
    const correo = document.getElementById('correo');
    const pass   = document.getElementById('contrasena');
    const cErr   = document.getElementById('correoError');
    const pErr   = document.getElementById('contrasenaError');
    let valid = true;

    cErr.textContent = ''; pErr.textContent = '';
    correo.style.borderColor = ''; pass.style.borderColor = '';

    if (!correo.value.trim()) {
        cErr.textContent = 'El correo es obligatorio.';
        correo.style.borderColor = '#ef4444'; valid = false;
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(correo.value)) {
        cErr.textContent = 'Ingresa un correo válido.';
        correo.style.borderColor = '#ef4444'; valid = false;
    }
    if (!pass.value) {
        pErr.textContent = 'La contraseña es obligatoria.';
        pass.style.borderColor = '#ef4444'; valid = false;
    }

    if (!valid) { e.preventDefault(); return; }

    const btnText    = btnLogin.querySelector('.btn-text');
    const btnLoading = btnLogin.querySelector('.btn-loading');
    btnText.style.display    = 'none';
    btnLoading.style.display = 'flex';
    btnLogin.disabled = true;
});

['correo','contrasena'].forEach(id => {
    const el = document.getElementById(id);
    el.addEventListener('input', () => {
        document.getElementById(id+'Error').textContent = '';
        el.style.borderColor = '';
    });
});

// Auto-ocultar alerta
const alert = document.getElementById('alertMsg');
if (alert) setTimeout(() => {
    alert.style.transition = 'opacity .5s';
    alert.style.opacity = '0';
    setTimeout(() => alert.remove(), 500);
}, 5000);
</script>
</body>
</html>
