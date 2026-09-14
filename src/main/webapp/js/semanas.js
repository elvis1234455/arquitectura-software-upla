'use strict';

function abrirModalEditar(id, numero, titulo, descripcion, contenido) {
  document.getElementById('editSemanaId').value     = id;
  document.getElementById('editNumero').value        = numero;
  document.getElementById('editTitulo').value        = titulo;
  document.getElementById('editDescripcion').value   = descripcion || '';
  document.getElementById('editContenido').value     = contenido || '';
  abrirModal('modalEditar');
}

function abrirModalCrear() {
  abrirModal('modalCrear');
}

function confirmarEliminarSemana(id, titulo) {
  document.getElementById('deleteSemanaId').value        = id;
  document.getElementById('deleteSemananombre').textContent = titulo;
  abrirModal('modalEliminar');
}
