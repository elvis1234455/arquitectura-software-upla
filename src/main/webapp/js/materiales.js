'use strict';

// ── Drag & Drop en el dropzone ─────────────────────────────────
(function setupDropzone() {
  const dropzone = document.getElementById('dropzone');
  const fileInput = document.getElementById('archivoInput');
  if (!dropzone || !fileInput) return;

  dropzone.addEventListener('dragover', (e) => { e.preventDefault(); dropzone.classList.add('drag-over'); });
  dropzone.addEventListener('dragleave', () => dropzone.classList.remove('drag-over'));
  dropzone.addEventListener('drop', (e) => {
    e.preventDefault();
    dropzone.classList.remove('drag-over');
    const files = e.dataTransfer.files;
    if (files.length > 0) {
      fileInput.files = files;
      mostrarPreview(files[0]);
    }
  });

  fileInput.addEventListener('change', () => {
    if (fileInput.files.length > 0) mostrarPreview(fileInput.files[0]);
  });
})();

function mostrarPreview(file) {
  const preview  = document.getElementById('filePreview');
  const dropzone = document.getElementById('dropzone');
  const name     = document.getElementById('previewName');
  const size     = document.getElementById('previewSize');
  const icon     = document.getElementById('previewIcon');

  if (!preview) return;

  const ext = getExtension(file.name);
  name.textContent = file.name;
  size.textContent = formatBytes(file.size);
  icon.innerHTML   = `<i class="fas ${getFileIcon(ext)} ${getFileColorClass(ext)}"></i>`;

  dropzone.style.display = 'none';
  preview.style.display  = 'flex';
}

function resetUpload() {
  const preview  = document.getElementById('filePreview');
  const dropzone = document.getElementById('dropzone');
  const fileInput = document.getElementById('archivoInput');
  if (preview)  preview.style.display  = 'none';
  if (dropzone) dropzone.style.display = '';
  if (fileInput) fileInput.value = '';
}

// ── Simulación de progreso en el form de subida ────────────────
(function setupUploadProgress() {
  const form     = document.getElementById('uploadForm');
  const progress = document.getElementById('uploadProgress');
  const fill     = document.getElementById('progressFill');
  const text     = document.getElementById('progressText');
  const btn      = document.getElementById('btnUpload');
  if (!form || !progress) return;

  form.addEventListener('submit', () => {
    if (progress) progress.style.display = 'block';
    if (btn) btn.disabled = true;
    let pct = 0;
    const interval = setInterval(() => {
      pct = Math.min(pct + Math.random() * 15, 90);
      if (fill) fill.style.width = pct + '%';
      if (text) text.textContent  = 'Subiendo... ' + Math.round(pct) + '%';
    }, 400);
    // Limpiar al navegar fuera
    window.addEventListener('beforeunload', () => clearInterval(interval));
  });
})();
