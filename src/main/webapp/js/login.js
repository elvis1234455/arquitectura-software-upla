'use strict';

function togglePassword() {
  const input = document.getElementById('contrasena');
  const icon  = document.getElementById('eyeIcon');
  if (!input) return;
  if (input.type === 'password') { input.type = 'text';     icon.className = 'fas fa-eye-slash'; }
  else                           { input.type = 'password'; icon.className = 'fas fa-eye'; }
}

(function setupLoginForm() {
  const form     = document.getElementById('loginForm');
  const btnLogin = document.getElementById('btnLogin');
  if (!form) return;

  form.addEventListener('submit', function (e) {
    const correo    = document.getElementById('correo');
    const contrasena = document.getElementById('contrasena');
    const correoErr  = document.getElementById('correoError');
    const passErr    = document.getElementById('contrasenaError');
    let valid = true;

    correoErr.textContent = '';
    passErr.textContent = '';
    correo.style.borderColor = '';
    contrasena.style.borderColor = '';

    if (!correo.value.trim()) {
      correoErr.textContent = 'El correo es obligatorio.';
      correo.style.borderColor = '#ef4444';
      valid = false;
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(correo.value.trim())) {
      correoErr.textContent = 'Ingresa un correo válido.';
      correo.style.borderColor = '#ef4444';
      valid = false;
    }

    if (!contrasena.value) {
      passErr.textContent = 'La contraseña es obligatoria.';
      contrasena.style.borderColor = '#ef4444';
      valid = false;
    }

    if (!valid) { e.preventDefault(); return; }

    const btnText    = btnLogin.querySelector('.btn-text');
    const btnLoading = btnLogin.querySelector('.btn-loading');
    if (btnText && btnLoading) {
      btnText.style.display    = 'none';
      btnLoading.style.display = 'flex';
      btnLogin.disabled = true;
    }
  });

  ['correo', 'contrasena'].forEach(id => {
    const input = document.getElementById(id);
    const errEl = document.getElementById(id + 'Error');
    if (input && errEl) {
      input.addEventListener('input', () => { errEl.textContent = ''; input.style.borderColor = ''; });
    }
  });
})();

window.addEventListener('DOMContentLoaded', () => {
  const correo = document.getElementById('correo');
  if (correo && !correo.value) correo.focus();

  const alert = document.getElementById('alertMsg');
  if (!alert) return;
  setTimeout(() => {
    alert.style.transition = 'opacity .5s ease';
    alert.style.opacity = '0';
    setTimeout(() => alert.remove(), 500);
  }, 5000);
});
