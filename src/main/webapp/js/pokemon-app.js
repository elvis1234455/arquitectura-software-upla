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

// ── Audio Pokédex retro (Web Audio API) ───────────────────────
const PokemonSound = {
    ctx: null,
    init() {
        if (this.ctx) return;
        try { this.ctx = new (window.AudioContext || window.webkitAudioContext)(); }
        catch(e) {}
    },
    play(freqs, type = 'square') {
        this.init();
        if (!this.ctx) return;
        freqs.forEach((freq, i) => {
            const osc  = this.ctx.createOscillator();
            const gain = this.ctx.createGain();
            osc.connect(gain);
            gain.connect(this.ctx.destination);
            osc.type = type;
            const t = this.ctx.currentTime + i * 0.08;
            osc.frequency.setValueAtTime(freq, t);
            gain.gain.setValueAtTime(0.07, t);
            gain.gain.exponentialRampToValueAtTime(0.001, t + 0.15);
            osc.start(t);
            osc.stop(t + 0.15);
        });
    },
    playOpen()  { this.play([440, 550, 660, 880]); },
    playClose() { this.play([880, 660, 440, 330]); },
    playHover() { this.play([600, 800], 'sine'); }
};

// ── Flip de Pokébolas ──────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function() {

    const wrappers = document.querySelectorAll('.pokeball-wrapper');
    const isTouch  = window.matchMedia('(hover: none)').matches;

    wrappers.forEach(function(wrapper) {

        // ── En dispositivos táctiles: flip por click ───────────
        if (isTouch) {
            wrapper.addEventListener('click', function(e) {
                // No flip si se clickeó un botón
                if (e.target.closest('.pokeball-admin-actions') ||
                    e.target.closest('.pb-btn')) return;

                const isFlipped = wrapper.classList.contains('flipped');
                // Cerrar todos los demás
                wrappers.forEach(w => w !== wrapper && w.classList.remove('flipped'));

                if (isFlipped) {
                    wrapper.classList.remove('flipped');
                    PokemonSound.playClose();
                } else {
                    wrapper.classList.add('flipped');
                    PokemonSound.playOpen();
                }
            });
        } else {
            // ── Desktop: sonido en hover ───────────────────────
            wrapper.addEventListener('mouseenter', function() {
                PokemonSound.playHover();
            });
        }

        // Botón "ENTRAR" — sonido al hacer clic
        const btn = wrapper.querySelector('.pb-btn');
        if (btn) {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                PokemonSound.playOpen();
                // La navegación continúa normalmente
            });
        }
    });

    // ── Animación de entrada escalonada ───────────────────────
    wrappers.forEach(function(w, i) {
        w.style.opacity    = '0';
        w.style.transform  = 'scale(0.6) translateY(30px)';
        w.style.transition = 'opacity .5s ease ' + (i * 0.07) + 's, transform .5s ease ' + (i * 0.07) + 's';
        setTimeout(function() {
            w.style.opacity   = '1';
            w.style.transform = 'scale(1) translateY(0)';
        }, 150 + i * 70);
    });

    // ── Estrellas de fondo ────────────────────────────────────
    createStars();
});

// ── Estrellas decorativas ──────────────────────────────────────
function createStars() {
    // Agregar keyframe
    if (!document.getElementById('poke-star-style')) {
        const s = document.createElement('style');
        s.id = 'poke-star-style';
        s.textContent = '@keyframes starTwinkle{from{opacity:.1;transform:scale(1)}to{opacity:.7;transform:scale(1.5)}}';
        document.head.appendChild(s);
    }

    const container = document.createElement('div');
    container.style.cssText = 'position:fixed;inset:0;pointer-events:none;z-index:0;overflow:hidden;';

    for (let i = 0; i < 50; i++) {
        const star = document.createElement('div');
        const size  = (Math.random() * 2 + 1).toFixed(1);
        const x     = (Math.random() * 100).toFixed(1);
        const y     = (Math.random() * 100).toFixed(1);
        const delay = (Math.random() * 4).toFixed(2);
        const dur   = (2 + Math.random() * 3).toFixed(2);
        star.style.cssText =
            'position:absolute;width:' + size + 'px;height:' + size + 'px;' +
            'background:#fff;border-radius:50%;' +
            'left:' + x + '%;top:' + y + '%;' +
            'animation:starTwinkle ' + dur + 's ease-in-out ' + delay + 's infinite alternate;';
        container.appendChild(star);
    }
    document.body.insertBefore(container, document.body.firstChild);
}
