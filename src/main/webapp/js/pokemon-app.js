'use strict';

/* ── Loader ────────────────────────────────────────────────── */
(function() {
    var loader = document.getElementById('pokemon-loader');
    if (!loader) return;
    var hide = function() { loader.classList.add('hidden'); };
    if (document.readyState === 'complete') {
        setTimeout(hide, 700);
    } else {
        window.addEventListener('load', function() { setTimeout(hide, 700); });
    }
    setTimeout(hide, 3000);
})();

/* ── Audio retro ───────────────────────────────────────────── */
var PokemonSound = {
    ctx: null,
    init: function() {
        if (this.ctx) return;
        try { this.ctx = new (window.AudioContext || window.webkitAudioContext)(); } catch(e) {}
    },
    beep: function(freqs, type) {
        this.init();
        if (!this.ctx) return;
        var self = this;
        (freqs || [440]).forEach(function(f, i) {
            try {
                var o = self.ctx.createOscillator();
                var g = self.ctx.createGain();
                o.connect(g); g.connect(self.ctx.destination);
                o.type = type || 'square';
                var t = self.ctx.currentTime + i * 0.07;
                o.frequency.setValueAtTime(f, t);
                g.gain.setValueAtTime(0.07, t);
                g.gain.exponentialRampToValueAtTime(0.001, t + 0.12);
                o.start(t); o.stop(t + 0.12);
            } catch(e) {}
        });
    },
    flip:  function() { this.beep([523, 659, 784]); },
    unflip: function() { this.beep([784, 659, 523]); },
    enter: function() { this.beep([880, 1047, 1319], 'sine'); }
};

/* ── Cartas Pokémon — flip por click ───────────────────────── */
document.addEventListener('DOMContentLoaded', function() {

    var scenes = Array.prototype.slice.call(
        document.querySelectorAll('.pcard-scene')
    );

    scenes.forEach(function(scene) {

        var wrapper = scene.querySelector('.pcard-wrapper');
        if (!wrapper) return;

        scene.addEventListener('click', function(e) {

            /* Clic en botón "ENTRAR" → navegar */
            var enterBtn = e.target.closest('.pcard-enter-btn');
            if (enterBtn) {
                e.stopPropagation();
                PokemonSound.enter();
                setTimeout(function() {
                    window.location.href = enterBtn.getAttribute('href');
                }, 180);
                return;
            }

            /* Clic en botones admin → no flipar */
            if (e.target.closest('.pcard-admin-actions')) return;

            var isFlipped = scene.classList.contains('flipped');

            /* Cerrar todas las demás */
            scenes.forEach(function(s) { if (s !== scene) s.classList.remove('flipped'); });

            if (isFlipped) {
                scene.classList.remove('flipped');
                PokemonSound.unflip();
            } else {
                scene.classList.add('flipped');
                PokemonSound.flip();
            }
        });
    });

    /* ── Animación de entrada escalonada ─────────────────── */
    scenes.forEach(function(s, i) {
        var w = s.querySelector('.pcard-wrapper');
        if (!w) return;
        w.style.opacity   = '0';
        w.style.transform = 'translateY(30px) rotateY(-15deg)';
        w.style.transition = 'opacity .45s ease ' + (i * 0.06) + 's, transform .45s ease ' + (i * 0.06) + 's';
        setTimeout(function() {
            w.style.opacity   = '1';
            w.style.transform = 'translateY(0) rotateY(0)';
        }, 150 + i * 60);
    });

    /* ── Estrellas de fondo ───────────────────────────────── */
    if (!document.getElementById('poke-star-style')) {
        var st = document.createElement('style');
        st.id = 'poke-star-style';
        st.textContent = '@keyframes twinkle{from{opacity:.05}to{opacity:.55}}';
        document.head.appendChild(st);
    }
    var container = document.createElement('div');
    container.style.cssText = 'position:fixed;inset:0;pointer-events:none;z-index:0;overflow:hidden';
    for (var i = 0; i < 60; i++) {
        var star = document.createElement('div');
        var sz = (Math.random() * 2 + .5).toFixed(1);
        star.style.cssText =
            'position:absolute;border-radius:50%;background:#fff;' +
            'width:' + sz + 'px;height:' + sz + 'px;' +
            'left:' + (Math.random()*100).toFixed(1) + '%;' +
            'top:' + (Math.random()*100).toFixed(1) + '%;' +
            'animation:twinkle ' + (2+Math.random()*3).toFixed(1) + 's ease-in-out ' +
            (Math.random()*4).toFixed(1) + 's infinite alternate;';
        container.appendChild(star);
    }
    document.body.insertBefore(container, document.body.firstChild);
});
