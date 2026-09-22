'use strict';

/* ── Loader ────────────────────────────────────────────────── */
(function() {
    var loader = document.getElementById('pokemon-loader');
    if (!loader) return;
    var hide = function() { loader.classList.add('hidden'); };
    if (document.readyState === 'complete') setTimeout(hide, 700);
    else window.addEventListener('load', function() { setTimeout(hide, 700); });
    setTimeout(hide, 3000);
})();

/* ── Audio retro ───────────────────────────────────────────── */
var PokemonSound = {
    ctx: null,
    init: function() {
        if (this.ctx) return;
        try { this.ctx = new (window.AudioContext || window.webkitAudioContext)(); } catch(e){}
    },
    play: function(freqs, type) {
        this.init();
        if (!this.ctx) return;
        var self = this;
        (freqs||[440]).forEach(function(f,i){
            try {
                var o = self.ctx.createOscillator(), g = self.ctx.createGain();
                o.connect(g); g.connect(self.ctx.destination);
                o.type = type||'square';
                var t = self.ctx.currentTime + i*0.07;
                o.frequency.setValueAtTime(f,t);
                g.gain.setValueAtTime(0.07,t);
                g.gain.exponentialRampToValueAtTime(0.001,t+0.12);
                o.start(t); o.stop(t+0.12);
            } catch(e){}
        });
    },
    enter: function(){ this.play([880,1047,1319],'sine'); },
    hover: function(){ this.play([600,750],'sine'); }
};

/* ── Cartas: hover sound + animación entrada ───────────────── */
document.addEventListener('DOMContentLoaded', function() {

    var cards = Array.prototype.slice.call(document.querySelectorAll('.pcard'));

    /* Sonido hover */
    cards.forEach(function(card) {
        card.addEventListener('mouseenter', function() {
            PokemonSound.hover();
        });
    });

    /* Botones "ENTRAR" */
    document.querySelectorAll('.pcard-enter-btn').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            PokemonSound.enter();
            var href = btn.getAttribute('href');
            setTimeout(function() { window.location.href = href; }, 180);
            e.preventDefault();
        });
    });

    /* Animación entrada escalonada */
    cards.forEach(function(card, i) {
        card.style.opacity   = '0';
        card.style.transform = 'translateY(25px) scale(.92)';
        card.style.transition = 'opacity .4s ease '+(i*0.055)+'s, transform .4s ease '+(i*0.055)+'s';
        setTimeout(function() {
            card.style.opacity   = '1';
            card.style.transform = 'translateY(0) scale(1)';
        }, 120 + i*55);
    });

    /* Estrellas de fondo */
    createStars();
});

function createStars() {
    if (!document.getElementById('poke-star-style')) {
        var s = document.createElement('style');
        s.id = 'poke-star-style';
        s.textContent = '@keyframes twinkle{from{opacity:.04}to{opacity:.5}}';
        document.head.appendChild(s);
    }
    var c = document.createElement('div');
    c.style.cssText = 'position:fixed;inset:0;pointer-events:none;z-index:0;overflow:hidden';
    for (var i=0;i<60;i++){
        var st=document.createElement('div');
        var sz=(Math.random()*2+.5).toFixed(1);
        st.style.cssText='position:absolute;border-radius:50%;background:#fff;'+
            'width:'+sz+'px;height:'+sz+'px;'+
            'left:'+(Math.random()*100).toFixed(1)+'%;'+
            'top:'+(Math.random()*100).toFixed(1)+'%;'+
            'animation:twinkle '+(2+Math.random()*3).toFixed(1)+'s ease-in-out '+
            (Math.random()*4).toFixed(1)+'s infinite alternate;';
        c.appendChild(st);
    }
    document.body.insertBefore(c,document.body.firstChild);
}
