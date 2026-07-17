(function () {
  const lang = document.documentElement.lang || 'ru';
  const labels = {
    close: lang.startsWith('en') ? 'Close' : 'Закрыть',
    prev: lang.startsWith('en') ? 'Previous screenshot' : 'Предыдущий скриншот',
    next: lang.startsWith('en') ? 'Next screenshot' : 'Следующий скриншот',
    enlarge: lang.startsWith('en') ? 'Enlarge screenshot' : 'Увеличить скриншот',
  };

  let lightboxEl = null;
  let lightboxImg = null;
  let lightboxCaption = null;
  let lightboxItems = [];
  let lightboxIndex = 0;

  function ensureLightbox() {
    if (lightboxEl) return;

    lightboxEl = document.createElement('div');
    lightboxEl.className = 'screenshot-lightbox';
    lightboxEl.hidden = true;
    lightboxEl.innerHTML = `
      <button type="button" class="screenshot-lightbox-backdrop" aria-label="${labels.close}"></button>
      <div class="screenshot-lightbox-panel" role="dialog" aria-modal="true" aria-label="${labels.enlarge}">
        <button type="button" class="screenshot-lightbox-close" aria-label="${labels.close}">×</button>
        <button type="button" class="screenshot-lightbox-nav screenshot-lightbox-prev" aria-label="${labels.prev}">‹</button>
        <figure class="screenshot-lightbox-figure">
          <img class="screenshot-lightbox-img" src="" alt="">
          <figcaption class="screenshot-lightbox-caption"></figcaption>
        </figure>
        <button type="button" class="screenshot-lightbox-nav screenshot-lightbox-next" aria-label="${labels.next}">›</button>
      </div>
    `;
    document.body.appendChild(lightboxEl);

    lightboxImg = lightboxEl.querySelector('.screenshot-lightbox-img');
    lightboxCaption = lightboxEl.querySelector('.screenshot-lightbox-caption');

    lightboxEl.querySelector('.screenshot-lightbox-backdrop').addEventListener('click', closeLightbox);
    lightboxEl.querySelector('.screenshot-lightbox-close').addEventListener('click', closeLightbox);
    lightboxEl.querySelector('.screenshot-lightbox-prev').addEventListener('click', () => {
      stepLightbox(-1);
    });
    lightboxEl.querySelector('.screenshot-lightbox-next').addEventListener('click', () => {
      stepLightbox(1);
    });

    document.addEventListener('keydown', (event) => {
      if (lightboxEl.hidden) return;
      if (event.key === 'Escape') closeLightbox();
      if (event.key === 'ArrowLeft') stepLightbox(-1);
      if (event.key === 'ArrowRight') stepLightbox(1);
    });
  }

  function renderLightbox() {
    const item = lightboxItems[lightboxIndex];
    if (!item) return;
    lightboxImg.src = item.src;
    lightboxImg.alt = item.alt;
    lightboxCaption.textContent = item.caption;
    lightboxEl.querySelector('.screenshot-lightbox-prev').disabled = lightboxIndex <= 0;
    lightboxEl.querySelector('.screenshot-lightbox-next').disabled =
      lightboxIndex >= lightboxItems.length - 1;
  }

  function openLightbox(items, index) {
    ensureLightbox();
    lightboxItems = items;
    lightboxIndex = index;
    renderLightbox();
    lightboxEl.hidden = false;
    document.body.classList.add('lightbox-open');
    lightboxEl.querySelector('.screenshot-lightbox-close').focus();
  }

  function closeLightbox() {
    if (!lightboxEl || lightboxEl.hidden) return;
    lightboxEl.hidden = true;
    document.body.classList.remove('lightbox-open');
    lightboxImg.removeAttribute('src');
  }

  function stepLightbox(delta) {
    const next = lightboxIndex + delta;
    if (next < 0 || next >= lightboxItems.length) return;
    lightboxIndex = next;
    renderLightbox();
  }

  function bindLightbox(root, slides) {
    const items = slides.map((slide) => {
      const img = slide.querySelector('img');
      const caption = slide.querySelector('figcaption');
      return {
        src: img?.currentSrc || img?.src || '',
        alt: img?.alt || '',
        caption: caption?.textContent?.trim() || img?.alt || '',
      };
    });

    slides.forEach((slide, index) => {
      const img = slide.querySelector('img');
      if (!img) return;

      slide.classList.add('carousel-slide-clickable');
      img.tabIndex = 0;
      img.setAttribute('role', 'button');
      img.setAttribute(
        'aria-label',
        `${labels.enlarge}: ${items[index].caption || items[index].alt}`,
      );

      const open = () => openLightbox(items, index);

      img.addEventListener('click', open);
      img.addEventListener('keydown', (event) => {
        if (event.key === 'Enter' || event.key === ' ') {
          event.preventDefault();
          open();
        }
      });
    });
  }

  document.querySelectorAll('[data-carousel]').forEach((root) => {
    const viewport = root.querySelector('.carousel-viewport');
    const track = root.querySelector('.carousel-track');
    const slides = [...root.querySelectorAll('.carousel-slide')];
    const prev = root.querySelector('.carousel-prev');
    const next = root.querySelector('.carousel-next');
    const gap = 14;
    const visibleCount = 3;
    let index = 0;

    bindLightbox(root, slides);

    function slideStep() {
      const slideW = slides[0]?.offsetWidth ?? 0;
      return slideW + gap;
    }

    function maxIndex() {
      return Math.max(0, slides.length - visibleCount);
    }

    function layout() {
      const w = viewport.clientWidth;
      const slideW = (w - gap * (visibleCount - 1)) / visibleCount;
      slides.forEach((slide) => {
        slide.style.width = `${slideW}px`;
      });
      index = Math.min(index, maxIndex());
      apply();
    }

    function apply() {
      track.style.transform = `translateX(${-index * slideStep()}px)`;
      prev.disabled = index <= 0;
      next.disabled = index >= maxIndex();
    }

    prev.addEventListener('click', () => {
      index = Math.max(0, index - 1);
      apply();
    });

    next.addEventListener('click', () => {
      index = Math.min(maxIndex(), index + 1);
      apply();
    });

    window.addEventListener('resize', layout);
    if (document.fonts?.ready) {
      document.fonts.ready.then(layout);
    }
    layout();
  });
})();
