'use strict';

// ── Sidebar toggle ─────────────────────────────────────────────
function toggleSidebar() {
  const sidebar = document.getElementById('sidebar');
  const overlay = document.getElementById('sidebarOverlay');
  if (!sidebar) return;
  sidebar.classList.toggle('open');
  if (overlay) overlay.classList.toggle('open');
  document.body.style.overflow = sidebar.classList.contains('open') ? 'hidden' : '';
}

// ── Modales ────────────────────────────────────────────────────
function abrirModal(id) {
  const modal = document.getElementById(id);
  if (!modal) return;
  modal.classList.add('open');
  document.body.style.overflow = 'hidden';
  const primer = modal.querySelector('input, textarea, select');
  if (primer) setTimeout(() => primer.focus(), 100);
}

function cerrarModal(id) {
  const modal = document.getElementById(id);
  if (!modal) return;
  modal.classList.remove('open');
  document.body.style.overflow = '';
}

document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') {
    document.querySelectorAll('.modal-overlay.open').forEach(m => {
      m.classList.remove('open');
      document.body.style.overflow = '';
    });
  }
});

document.addEventListener('click', (e) => {
  if (e.target.classList.contains('modal-overlay')) {
    e.target.classList.remove('open');
    document.body.style.overflow = '';
  }
});

// ── Toast auto-dismiss ──────────────────────────────────────────
(function autoHideToast() {
  const toast = document.getElementById('toastMsg');
  if (!toast) return;
  setTimeout(() => {
    toast.style.transition = 'opacity .5s ease, transform .5s ease';
    toast.style.opacity = '0';
    toast.style.transform = 'translateY(-8px)';
    setTimeout(() => toast.remove(), 500);
  }, 4000);
})();

// ── Animaciones scroll ─────────────────────────────────────────
(function observeCards() {
  if (!('IntersectionObserver' in window)) return;
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.opacity = '1';
        entry.target.style.transform = 'translateY(0)';
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1 });
  document.querySelectorAll('.stat-card, .info-card, .section-card, .semana-card').forEach(el => {
    if (!el.style.opacity) {
      el.style.opacity = '0';
      el.style.transform = 'translateY(16px)';
      el.style.transition = 'opacity .5s ease, transform .5s ease';
    }
    observer.observe(el);
  });
})();

// ── Animación de barras ────────────────────────────────────────
(function animateBars() {
  if (!('IntersectionObserver' in window)) return;
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const bar = entry.target;
        const target = bar.style.width;
        bar.style.width = '0%';
        setTimeout(() => { bar.style.width = target; }, 100);
        observer.unobserve(bar);
      }
    });
  }, { threshold: 0.3 });
  document.querySelectorAll('.eval-bar, .tipo-bar').forEach(el => observer.observe(el));
})();

function formatBytes(bytes) {
  if (bytes < 1024) return bytes + ' B';
  if (bytes < 1048576) return (bytes / 1024).toFixed(1) + ' KB';
  return (bytes / 1048576).toFixed(1) + ' MB';
}

function getExtension(filename) {
  const parts = filename.split('.');
  return parts.length > 1 ? parts.pop().toLowerCase() : '';
}

function getFileIcon(ext) {
  const map = { pdf:'fa-file-pdf', jpg:'fa-file-image', jpeg:'fa-file-image', png:'fa-file-image', gif:'fa-file-image',
    doc:'fa-file-word', docx:'fa-file-word', xls:'fa-file-excel', xlsx:'fa-file-excel',
    ppt:'fa-file-powerpoint', pptx:'fa-file-powerpoint', txt:'fa-file-alt', zip:'fa-file-archive' };
  return map[ext] || 'fa-file';
}

function getFileColorClass(ext) {
  const map = { pdf:'type-pdf', jpg:'type-image', jpeg:'type-image', png:'type-image', gif:'type-image',
    doc:'type-word', docx:'type-word', xls:'type-excel', xlsx:'type-excel',
    ppt:'type-ppt', pptx:'type-ppt', zip:'type-zip', txt:'type-other' };
  return map[ext] || 'type-other';
}
