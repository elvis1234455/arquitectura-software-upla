<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión — Arquitectura de Software | UPLA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pokemon-theme.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* ══ LOGIN POKÉMON ═══════════════════════════════════════ */
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Poppins', sans-serif;
            background: #0d1117;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
            overflow: hidden;
            position: relative;
        }

        /* Fondo animado Pokémon */
        .poke-bg {
            position: fixed; inset: 0;
            background:
                radial-gradient(ellipse 80% 60% at 20% 40%, rgba(238,21,21,.12) 0%, transparent 60%),
                radial-gradient(ellipse 60% 50% at 80% 70%, rgba(59,76,202,.1) 0%, transparent 50%),
                radial-gradient(ellipse 40% 40% at 50% 10%, rgba(255,222,0,.06) 0%, transparent 50%);
            pointer-events: none;
            z-index: 0;
        }

        /* Pokébolas flotantes de fondo */
        .float-ball {
            position: fixed;
            border-radius: 50%;
            opacity: .04;
            pointer-events: none;
            z-index: 0;
        }
        .float-ball::before {
            content: '';
            position: absolute; inset: 0;
            border-radius: 50%;
            background: linear-gradient(to bottom,
                #EE1515 0%, #EE1515 46%, #111 46%, #111 54%, #fff 54%, #fff 100%);
        }
        .fb1 { width: 220px; height: 220px; top: -40px; left: -40px; animation: fbFloat1 8s ease-in-out infinite; }
        .fb2 { width: 160px; height: 160px; bottom: -30px; right: -30px; animation: fbFloat2 10s ease-in-out infinite; }
        .fb3 { width: 100px; height: 100px; top: 40%; right: 8%; animation: fbFloat3 7s ease-in-out infinite; }

        @keyframes fbFloat1 { 0%,100%{transform:translate(0,0) rotate(0deg)} 50%{transform:translate(15px,20px) rotate(180deg)} }
        @keyframes fbFloat2 { 0%,100%{transform:translate(0,0) rotate(0deg)} 50%{transform:translate(-12px,-18px) rotate(-180deg)} }
        @keyframes fbFloat3 { 0%,100%{transform:translate(0,0) rotate(0deg)} 50%{transform:translate(8px,12px) rotate(90deg)} }

        /* Tarjeta principal */
        .login-card {
            position: relative; z-index: 1;
            width: 100%; max-width: 420px;

            /* Carta Pokémon */
            background: linear-gradient(160deg, #fffde7 0%, #fff9c4 35%, #fff3e0 100%);
            border: 3px solid #c8a400;
            box-shadow:
                0 0 0 1px #e8c700,
                0 0 60px rgba(238,21,21,.25),
                0 25px 60px rgba(0,0,0,.6),
                inset 0 1px 0 rgba(255,255,255,.7);
            border-radius: 16px;
            overflow: hidden;
            animation: cardIn .5s cubic-bezier(.34,1.56,.64,1);
        }

        /* Borde interior dorado */
        .login-card::before {
            content: '';
            position: absolute; inset: 6px;
            border: 1.5px solid rgba(200,164,0,.4);
            border-radius: 11px;
            pointer-events: none; z-index: 0;
        }

        /* Brillo hover holográfico */
        .login-card::after {
            content: '';
            position: absolute; inset: 0;
            background: linear-gradient(115deg, transparent 20%, rgba(255,255,255,.12) 50%, transparent 80%);
            opacity: 0; pointer-events: none; z-index: 0;
            transition: opacity .3s;
        }
        .login-card:hover::after { opacity: 1; }

        @keyframes cardIn {
            from { opacity:0; transform: translateY(30px) scale(.95); }
            to   { opacity:1; transform: translateY(0) scale(1); }
        }

        /* Header de la carta */
        .card-header {
            background: linear-gradient(90deg, #EE1515, #cc0000);
            padding: .6rem 1.2rem;
            display: flex; align-items: center; justify-content: space-between;
            position: relative; z-index: 1;
            box-shadow: 0 2px 8px rgba(0,0,0,.3);
        }
        .card-header-title {
            font-family: 'Press Start 2P', monospace;
            font-size: .5rem; color: #fff;
            text-shadow: 1px 1px 0 rgba(0,0,0,.5);
            letter-spacing: .06em;
        }
        .card-header-hp {
            font-family: 'Press Start 2P', monospace;
            font-size: .42rem; color: #ffdd00;
        }

        /* Ilustración / Avatar */
        .card-illustration {
            margin: .5rem .6rem .3rem;
            height: 100px;
            background: linear-gradient(135deg, #0f1647 0%, #1a237e 40%, #1565c0 100%);
            border-radius: 8px;
            border: 2px solid #c8a400;
            display: flex; align-items: center; justify-content: center;
            position: relative; overflow: hidden; z-index: 1;
            box-shadow: inset 0 2px 10px rgba(0,0,0,.5);
        }
        .card-illustration::before {
            content: '';
            position: absolute; inset: 0;
            background:
                radial-gradient(circle at 25% 35%, rgba(255,255,255,.12), transparent 50%),
                repeating-linear-gradient(-45deg, transparent, transparent 8px,
                    rgba(255,255,255,.03) 8px, rgba(255,255,255,.03) 9px);
        }
        .card-illus-inner {
            text-align: center; position: relative; z-index: 1;
        }

        /* Pokébola SVG en la ilustración */
        .pokeball-icon {
            width: 56px; height: 56px;
            animation: pokeRotate 3s ease-in-out infinite alternate;
            filter: drop-shadow(0 0 12px rgba(238,21,21,.6));
        }
        @keyframes pokeRotate {
            from { transform: rotate(-8deg) scale(1); filter: drop-shadow(0 0 8px rgba(238,21,21,.4)); }
            to   { transform: rotate(8deg) scale(1.08); filter: drop-shadow(0 0 20px rgba(255,222,0,.6)); }
        }

        .card-illus-label {
            font-family: 'Press Start 2P', monospace;
            font-size: .38rem; color: rgba(255,255,255,.5);
            letter-spacing: .1em; display: block; margin-top: .3rem;
        }

        /* Tipo badge */
        .card-type-bar {
            padding: .2rem .7rem;
            display: flex; align-items: center; gap: .5rem;
            position: relative; z-index: 1;
        }
        .card-type-badge {
            font-family: 'Press Start 2P', monospace;
            font-size: .32rem; padding: .18rem .5rem;
            background: #3B4CCA; color: #fff;
            border-radius: 1rem;
        }
        .card-type-name {
            font-family: 'Press Start 2P', monospace;
            font-size: .35rem; color: #555;
        }

        /* Cuerpo del formulario */
        .card-body {
            padding: .4rem .7rem .5rem;
            position: relative; z-index: 1;
        }

        /* Alertas */
        .poke-alert {
            display: flex; align-items: center; gap: .6rem;
            padding: .55rem .75rem;
            border-radius: 6px;
            font-family: 'Press Start 2P', monospace;
            font-size: .4rem;
            margin-bottom: .75rem;
            line-height: 1.6;
        }
        .poke-alert-error   { background: rgba(238,21,21,.1); border: 1px solid rgba(238,21,21,.3); color: #EE1515; }
        .poke-alert-success { background: rgba(255,222,0,.1); border: 1px solid rgba(255,222,0,.3); color: #c8a400; }
        .poke-alert-warn    { background: rgba(255,222,0,.08); border: 1px solid rgba(255,222,0,.25); color: #b8940a; }

        /* Campos */
        .poke-field { margin-bottom: .6rem; }
        .poke-label {
            display: flex; align-items: center; gap: .35rem;
            font-family: 'Press Start 2P', monospace;
            font-size: .38rem; color: #555;
            text-transform: uppercase; letter-spacing: .06em;
            margin-bottom: .35rem;
        }
        .poke-label i { color: #EE1515; font-size: .75rem; }

        .poke-input-wrap { position: relative; }
        .poke-input {
            width: 100%;
            padding: .7rem 2.5rem .7rem .85rem;
            background: rgba(255,249,196,.4);
            border: 2px solid rgba(200,164,0,.5);
            border-radius: 6px;
            color: #1a1a2e;
            font-size: .88rem;
            font-family: 'Poppins', sans-serif;
            outline: none;
            transition: .2s ease;
        }
        .poke-input:focus {
            border-color: #EE1515;
            background: rgba(255,249,196,.7);
            box-shadow: 0 0 0 3px rgba(238,21,21,.15);
        }
        .poke-input::placeholder { color: #aaa; }
        .poke-input-icon {
            position: absolute; right: .75rem; top: 50%;
            transform: translateY(-50%);
            color: rgba(200,164,0,.6); pointer-events: none;
        }
        .poke-toggle {
            position: absolute; right: .6rem; top: 50%;
            transform: translateY(-50%);
            background: none; border: none;
            color: rgba(200,164,0,.6); cursor: pointer;
            padding: .2rem; font-size: .9rem;
            transition: color .2s;
        }
        .poke-toggle:hover { color: #EE1515; }
        .poke-field-error {
            font-family: 'Press Start 2P', monospace;
            font-size: .32rem; color: #EE1515;
            margin-top: .25rem; display: block; min-height: .8rem;
        }

        /* Botón submit */
        .poke-submit {
            width: 100%; margin-top: .3rem;
            padding: .7rem;
            background: linear-gradient(135deg, #EE1515, #cc1111);
            color: #fff;
            font-family: 'Press Start 2P', monospace;
            font-size: .48rem;
            letter-spacing: .05em;
            border: 2px solid #800000;
            box-shadow: 0 4px 0 #800000, inset 0 1px 0 rgba(255,255,255,.2);
            border-radius: 6px;
            cursor: pointer;
            transition: .12s ease;
            display: flex; align-items: center; justify-content: center; gap: .5rem;
        }
        .poke-submit:hover { background: linear-gradient(135deg, #cc1111, #EE1515); }
        .poke-submit:active { transform: translateY(3px); box-shadow: 0 1px 0 #800000; }
        .poke-submit:disabled { opacity: .6; cursor: not-allowed; transform: none; }

        /* Pie de la carta */
        .card-footer {
            background: linear-gradient(90deg, rgba(200,164,0,.08), rgba(200,164,0,.12), rgba(200,164,0,.08));
            border-top: 1px solid rgba(200,164,0,.3);
            padding: .35rem .8rem;
            display: flex; align-items: center; justify-content: space-between;
            position: relative; z-index: 1;
        }
        .card-footer-text {
            font-family: 'Press Start 2P', monospace;
            font-size: .28rem; color: #aaa;
        }
        .card-footer-rarity { color: #c8a400; font-size: .8rem; }
    </style>
</head>
<body>
    <div class="poke-bg"></div>

    <%-- Pokébolas flotantes decorativas --%>
    <div class="float-ball fb1"></div>
    <div class="float-ball fb2"></div>
    <div class="float-ball fb3"></div>

    <div class="login-card">

        <%-- Header --%>
        <div class="card-header">
            <span class="card-header-title">ADMIN TRAINER</span>
            <span class="card-header-hp">HP ∞</span>
        </div>

        <%-- Ilustración --%>
        <div class="card-illustration">
            <div class="card-illus-inner">
                <%-- Pokébola SVG animada --%>
                <svg class="pokeball-icon" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
                    <circle cx="50" cy="50" r="48" fill="none" stroke="rgba(255,255,255,0.15)" stroke-width="2"/>
                    <path d="M4,50 A46,46 0 0,1 96,50 Z" fill="#EE1515"/>
                    <path d="M4,50 A46,46 0 0,0 96,50 Z" fill="#f0f0f0"/>
                    <rect x="4" y="44" width="92" height="12" fill="#1a1a1a"/>
                    <circle cx="50" cy="50" r="13" fill="white" stroke="#1a1a1a" stroke-width="3"/>
                    <circle cx="50" cy="50" r="7" fill="#ddd" stroke="#ccc" stroke-width="1"/>
                    <circle cx="44" cy="44" r="3" fill="rgba(255,255,255,0.7)"/>
                </svg>
                <span class="card-illus-label">UPLA · 332181</span>
            </div>
        </div>

        <%-- Tipo --%>
        <div class="card-type-bar">
            <span class="card-type-badge">⚡ ADMIN</span>
            <span class="card-type-name">Arquitectura de Software</span>
        </div>

        <%-- Cuerpo --%>
        <div class="card-body">

            <%-- Alertas --%>
            <c:if test="${not empty param.logout}">
                <div class="poke-alert poke-alert-success" id="alertMsg">
                    <i class="fas fa-check-circle"></i> ¡Hasta pronto, Trainer!
                </div>
            </c:if>
            <c:if test="${param.error eq 'cuenta_inactiva'}">
                <div class="poke-alert poke-alert-warn" id="alertMsg">
                    <i class="fas fa-exclamation-triangle"></i> Cuenta desactivada.
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="poke-alert poke-alert-error" id="alertMsg">
                    <i class="fas fa-times-circle"></i> ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm" novalidate>

                <div class="poke-field">
                    <label class="poke-label" for="correo">
                        <i class="fas fa-envelope"></i> Correo
                    </label>
                    <div class="poke-input-wrap">
                        <input type="email" id="correo" name="correo"
                               class="poke-input" placeholder="trainer@upla.edu.pe"
                               value="${param.correo}" autocomplete="email" required>
                        <span class="poke-input-icon"><i class="fas fa-at"></i></span>
                    </div>
                    <span class="poke-field-error" id="correoError"></span>
                </div>

                <div class="poke-field">
                    <label class="poke-label" for="contrasena">
                        <i class="fas fa-lock"></i> Contraseña
                    </label>
                    <div class="poke-input-wrap">
                        <input type="password" id="contrasena" name="contrasena"
                               class="poke-input" placeholder="••••••••"
                               autocomplete="current-password" required>
                        <button type="button" class="poke-toggle" onclick="togglePassword()">
                            <i class="fas fa-eye" id="eyeIcon"></i>
                        </button>
                    </div>
                    <span class="poke-field-error" id="contrasenaError"></span>
                </div>

                <button type="submit" class="poke-submit" id="btnLogin">
                    <span class="btn-text"><i class="fas fa-sign-in-alt"></i> ¡USAR INICIO!</span>
                    <span class="btn-loading" style="display:none;"><i class="fas fa-spinner fa-spin"></i> CARGANDO...</span>
                </button>

            </form>
        </div>

        <%-- Pie --%>
        <div class="card-footer">
            <span class="card-footer-text">UPLA · Ing. Sistemas · 2026-I</span>
            <span class="card-footer-rarity">★</span>
        </div>

    </div>

    <script>
    function togglePassword() {
        var i = document.getElementById('contrasena');
        var e = document.getElementById('eyeIcon');
        i.type = i.type === 'password' ? 'text' : 'password';
        e.className = i.type === 'password' ? 'fas fa-eye' : 'fas fa-eye-slash';
    }

    document.getElementById('loginForm').addEventListener('submit', function(e) {
        var c = document.getElementById('correo');
        var p = document.getElementById('contrasena');
        var ce = document.getElementById('correoError');
        var pe = document.getElementById('contrasenaError');
        var valid = true;
        ce.textContent = ''; pe.textContent = '';
        c.style.borderColor = ''; p.style.borderColor = '';

        if (!c.value.trim()) {
            ce.textContent = 'Campo requerido.';
            c.style.borderColor = '#EE1515'; valid = false;
        } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(c.value)) {
            ce.textContent = 'Correo inválido.';
            c.style.borderColor = '#EE1515'; valid = false;
        }
        if (!p.value) {
            pe.textContent = 'Campo requerido.';
            p.style.borderColor = '#EE1515'; valid = false;
        }
        if (!valid) { e.preventDefault(); return; }

        var btn = document.getElementById('btnLogin');
        btn.querySelector('.btn-text').style.display = 'none';
        btn.querySelector('.btn-loading').style.display = 'flex';
        btn.disabled = true;
    });

    ['correo','contrasena'].forEach(function(id) {
        var el = document.getElementById(id);
        el.addEventListener('input', function() {
            document.getElementById(id+'Error').textContent = '';
            el.style.borderColor = '';
        });
    });

    // Auto-ocultar alertas
    var alert = document.getElementById('alertMsg');
    if (alert) setTimeout(function() {
        alert.style.transition = 'opacity .4s';
        alert.style.opacity = '0';
        setTimeout(function() { alert.remove(); }, 400);
    }, 4000);

    // Auto-focus
    var correoEl = document.getElementById('correo');
    if (correoEl && !correoEl.value) correoEl.focus();

    // Estrellas de fondo
    (function() {
        var s = document.createElement('style');
        s.textContent = '@keyframes twinkle{from{opacity:.03}to{opacity:.4}}';
        document.head.appendChild(s);
        var c = document.createElement('div');
        c.style.cssText = 'position:fixed;inset:0;pointer-events:none;z-index:0;overflow:hidden';
        for (var i=0; i<50; i++) {
            var st = document.createElement('div');
            var sz = (Math.random()*2+.5).toFixed(1);
            st.style.cssText='position:absolute;border-radius:50%;background:#fff;width:'+sz+'px;height:'+sz+'px;'+
                'left:'+(Math.random()*100).toFixed(1)+'%;top:'+(Math.random()*100).toFixed(1)+'%;'+
                'animation:twinkle '+(2+Math.random()*3).toFixed(1)+'s ease-in-out '+(Math.random()*4).toFixed(1)+'s infinite alternate;';
            c.appendChild(st);
        }
        document.body.insertBefore(c, document.body.firstChild);
    })();
    </script>
</body>
</html>
