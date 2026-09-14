'use strict';
// Animaciones específicas del dashboard
document.addEventListener('DOMContentLoaded', () => {
  // Contadores animados para stats
  document.querySelectorAll('.stat-value').forEach(el => {
    const target = parseInt(el.textContent) || 0;
    if (target === 0) return;
    let current = 0;
    const step = Math.ceil(target / 30);
    const timer = setInterval(() => {
      current = Math.min(current + step, target);
      el.textContent = current;
      if (current >= target) clearInterval(timer);
    }, 40);
  });
});
