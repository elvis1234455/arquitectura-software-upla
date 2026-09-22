'use strict';

// ── Loader ─────────────────────────────────────────────────────
(function initLoader() {
    const loader = document.getElementById('pokemon-loader');
    if (!loader) return;
    const hide = () => loader.classList.add('hidden');
    if (document.readyState === 'complete') {
        setTimeout(hide, 800);
    } else {
        window.addEventListener('load', () => setTimeout(hide, 800));
    }
    setTimeout(hide, 3000);
})();

// ── Audio retro (Web Audio API) ────────────────────────────────
const PokemonSound = {
    ctx: null,
    init() {
        if (this.ctx) return;
        try { this.ctx = new (window.AudioContext || window.webkitAudioContext)(); }
        catch(e) {}
    },
    play(freqs, type) {
        this.init();
        if (!this.ctx) return;
        type = type || 'square';
        freqs.forEach(function(freq, i) {
            try {
                const osc  = this.ctx.createOscillator();
                const gain = this.ctx.createGain();
                osc.connect(gain);
                gain.connect(this.ctx.destination);
                osc.type = type;
                const t = this.ctx.currentTime + i * 0.07;
                osc.frequency.setValueAtTime(freq, t);
                gain.gain.setValueAtTime(0.06, t);
                gain.gain.exponentialRampToValueAtTime(0.001, t + 0.13);
                osc.start(t);
                osc.stop(t + 0.13);
            } catch(e) {}
        }.bind(this));
    },
    playOpen()  { this.play([440, 554, 660, 880]); },
    playClose() { this.play([880, 660, 440, 330]); },
    playClick() { this.play([300, 400], 'sine'); }
};

// ── Pokébolas: flip por CLICK ──────────────────────────────────
document.addEventListener('DOMContentLoaded', function() {

    // Seleccionamos los wrappers (el elemento que tiene la clase pokeball-wrapper)
    var wrappers = Array.prototype.slice.call(
        document.querySelectorAll('.pokeball-wrapper')
    );

    if (wrappers.length === 0) return;

    wrappers.forEach(function(wrapper) {

        // Click sobre el wrapper → toggle flip
        wrapper.addEventListener('click', function(e) {
            // Si se hizo clic en el botón "ENTRAR" → dejar que navegue
            var pbBtn = e.target.closest('.pb-btn');
            if (pbBtn) {
                PokemonSound.playClick();
                // Navegar manualmente usando el href del enlace
                window.location.href = pbBtn.getAttribute('href');
                return;
            }

            // Si se hizo clic en botones de admin → no flipar
            if (e.target.closest('.pokeball-admin-actions')) return;

            var isFlipped = wrapper.classList.contains('flipped');

            // Cerrar todos los demás
            wrappers.forEach(function(w) {
                if (w !== wrapper) w.classList.remove('flipped');
            });

            if (isFlipped) {
                wrapper.classList.remove('flipped');
                PokemonSound.playClose();
            } else {
                wrapper.classList.add('flipped');
                PokemonSound.playOpen();
            }
        });

        // Botones admin — no propaguen el flip
        var adminBtns = wrapper.querySelectorAll('.pokeball-admin-actions button');
        adminBtns.forEach(function(b) {
            b.addEventListener('click', function(e) { e.stopPropagation(); });
        });
    });

    // ── Animación de entrada escalonada ───────────────────────
    wrappers.forEach(function(w, i) {
        w.style.opacity    = '0';
        w.style.transform  = 'scale(0.5) translateY(40px)';
        w.style.transition = 'opacity .5s ease ' + (i * 0.08) + 's, transform .5s ease ' + (i * 0.08) + 's';
        setTimeout(function() {
            w.style.opacity   = '1';
            w.style.transform = 'scale(1) translateY(0)';
        }, 200 + i * 80);
    });

    // ── Estrellas de fondo ────────────────────────────────────
    createStars();
});

function createStars() {
    if (!document.getElementById('poke-star-style')) {
        var s = document.createElement('style');
        s.id = 'poke-star-style';
        s.textContent = '@keyframes starTwinkle{from{opacity:.08;transform:scale(1)}to{opacity:.6;transform:scale(1.4)}}';
        document.head.appendChild(s);
    }
    var c = document.createElement('div');
    c.style.cssText = 'position:fixed;inset:0;pointer-events:none;z-index:0;overflow:hidden;';
    for (var i = 0; i < 55; i++) {
        var star = document.createElement('div');
        var sz = (Math.random() * 2 + 1).toFixed(1);
        var x  = (Math.random() * 100).toFixed(1);
        var y  = (Math.random() * 100).toFixed(1);
        var dl = (Math.random() * 4).toFixed(2);
        var dr = (2 + Math.random() * 3).toFixed(2);
        star.style.cssText =
            'position:absolute;width:' + sz + 'px;height:' + sz + 'px;background:#fff;border-radius:50%;' +
            'left:' + x + '%;top:' + y + '%;' +
            'animation:starTwinkle ' + dr + 's ease-in-out ' + dl + 's infinite alternate;';
        c.appendChild(star);
    }
    document.body.insertBefore(c, document.body.firstChild);
}
