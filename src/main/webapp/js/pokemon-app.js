'use strict';

// ── Loader ─────────────────────────────────────────────────────
(function initLoader() {
    const loader = document.getElementById('pokemon-loader');
    if (!loader) return;

    const hide = () => loader.classList.add('hidden');

    // Ocultar cuando la página termine de cargar
    if (document.readyState === 'complete') {
        setTimeout(hide, 800);
    } else {
        window.addEventListener('load', () => setTimeout(hide, 800));
    }

    // Fallback máximo 3 segundos
    setTimeout(hide, 3000);
})();

// ── Audio Pokédex retro ────────────────────────────────────────
const PokemonSound = {
    ctx: null,

    init() {
        if (this.ctx) return;
        try {
            this.ctx = new (window.AudioContext || window.webkitAudioContext)();
        } catch (e) {
            // Audio no disponible
        }
    },

    // Sonido retro de apertura
    playOpen() {
        this.init();
        if (!this.ctx) return;
        const notes = [440, 550, 660, 880];
        notes.forEach((freq, i) => {
            const osc = this.ctx.createOscillator();
            const gain = this.ctx.createGain();
            osc.connect(gain);
            gain.connect(this.ctx.destination);
            osc.type = 'square';
            osc.frequency.setValueAtTime(freq, this.ctx.currentTime + i * 0.08);
            gain.gain.setValueAtTime(0.08, this.ctx.currentTime + i * 0.08);
            gain.gain.exponentialRampToValueAtTime(0.001, this.ctx.currentTime + i * 0.08 + 0.15);
            osc.start(this.ctx.currentTime + i * 0.08);
            osc.stop(this.ctx.currentTime + i * 0.08 + 0.15);
        });
    },

    // Sonido de click en botón
    playClick() {
        this.init();
        if (!this.ctx) return;
        const osc = this.ctx.createOscillator();
        const gain = this.ctx.createGain();
        osc.connect(gain);
        gain.connect(this.ctx.destination);
        osc.type = 'square';
        osc.frequency.setValueAtTime(200, this.ctx.currentTime);
        osc.frequency.exponentialRampToValueAtTime(100, this.ctx.currentTime + 0.1);
        gain.gain.setValueAtTime(0.1, this.ctx.currentTime);
        gain.gain.exponentialRampToValueAtTime(0.001, this.ctx.currentTime + 0.1);
        osc.start(this.ctx.currentTime);
        osc.stop(this.ctx.currentTime + 0.1);
    },

    // Sonido de hover
    playHover() {
        this.init();
        if (!this.ctx) return;
        const osc = this.ctx.createOscillator();
        const gain = this.ctx.createGain();
        osc.connect(gain);
        gain.connect(this.ctx.destination);
        osc.type = 'sine';
        osc.frequency.setValueAtTime(600, this.ctx.currentTime);
        osc.frequency.exponentialRampToValueAtTime(800, this.ctx.currentTime + 0.05);
        gain.gain.setValueAtTime(0.05, this.ctx.currentTime);
        gain.gain.exponentialRampToValueAtTime(0.001, this.ctx.currentTime + 0.1);
        osc.start(this.ctx.currentTime);
        osc.stop(this.ctx.currentTime + 0.1);
    }
};

// ── Interactividad de Pokébolas ────────────────────────────────
(function initPokeballs() {
    document.addEventListener('DOMContentLoaded', () => {

        const wrappers = document.querySelectorAll('.pokeball-wrapper');

        wrappers.forEach(wrapper => {

            // Hover: sonido al abrir
            wrapper.addEventListener('mouseenter', () => {
                PokemonSound.playHover();
            });

            // Click: toggle flip en móvil / touch
            wrapper.addEventListener('click', (e) => {
                // No flipar si se clickeó un botón de admin o el botón "entrar"
                if (e.target.closest('.pokeball-admin-actions') ||
                    e.target.closest('.pb-btn')) return;

                PokemonSound.playClick();

                // En móvil sin hover, usar toggle
                if (window.matchMedia('(hover: none)').matches) {
                    wrapper.classList.toggle('flipped');
                    if (wrapper.classList.contains('flipped')) {
                        PokemonSound.playOpen();
                    }
                }
            });
        });

        // Botones "Entrar a la semana"
        document.querySelectorAll('.pb-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                PokemonSound.playOpen();
            });
        });

        // Partículas de estrellas en el fondo
        createStars();

        // Animación de entrada escalonada
        wrappers.forEach((w, i) => {
            w.style.opacity = '0';
            w.style.transform = 'scale(.7) translateY(20px)';
            w.style.transition = `opacity .5s ease ${i * 0.08}s, transform .5s ease ${i * 0.08}s`;
            setTimeout(() => {
                w.style.opacity = '1';
                w.style.transform = 'scale(1) translateY(0)';
            }, 100 + i * 80);
        });
    });
})();

// ── Estrellas de fondo ─────────────────────────────────────────
function createStars() {
    const content = document.querySelector('.page-content');
    if (!content) return;

    const starsContainer = document.createElement('div');
    starsContainer.style.cssText = `
        position: fixed; inset: 0; pointer-events: none;
        z-index: 0; overflow: hidden;
    `;

    for (let i = 0; i < 60; i++) {
        const star = document.createElement('div');
        const size = Math.random() * 2 + 1;
        const x = Math.random() * 100;
        const y = Math.random() * 100;
        const delay = Math.random() * 3;
        const dur = 2 + Math.random() * 3;

        star.style.cssText = `
            position: absolute;
            width: ${size}px; height: ${size}px;
            background: #fff;
            border-radius: 50%;
            left: ${x}%; top: ${y}%;
            opacity: ${Math.random() * 0.6 + 0.1};
            animation: starTwinkle ${dur}s ease-in-out ${delay}s infinite alternate;
        `;
        starsContainer.appendChild(star);
    }

    // Agregar keyframe si no existe
    if (!document.getElementById('star-style')) {
        const style = document.createElement('style');
        style.id = 'star-style';
        style.textContent = `
            @keyframes starTwinkle {
                from { opacity: .1; transform: scale(1); }
                to   { opacity: .8; transform: scale(1.5); }
            }
        `;
        document.head.appendChild(style);
    }

    document.body.insertBefore(starsContainer, document.body.firstChild);
}
