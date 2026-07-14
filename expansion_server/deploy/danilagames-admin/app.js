(function () {
  const cfg = window.DANILAGAMES_ADMIN_CONFIG || { apiBase: '/api' };
  const TOKEN_KEY = 'dg_admin_token';
  const USER_KEY = 'dg_admin_user';

  const app = document.getElementById('app');

  function token() {
    return localStorage.getItem(TOKEN_KEY);
  }

  function setSession(accessToken, username) {
    localStorage.setItem(TOKEN_KEY, accessToken);
    localStorage.setItem(USER_KEY, username);
  }

  function clearSession() {
    localStorage.removeItem(TOKEN_KEY);
    localStorage.removeItem(USER_KEY);
  }

  async function api(path, options = {}) {
    const headers = { 'Content-Type': 'application/json', ...(options.headers || {}) };
    const t = token();
    if (t) headers.Authorization = `Bearer ${t}`;

    let res;
    try {
      res = await fetch(`${cfg.apiBase}${path}`, { ...options, headers });
    } catch (networkErr) {
      const err = new Error(
        'Нет связи с API. Обновите страницу (Ctrl+F5) или проверьте интернет.',
      );
      err.cause = networkErr;
      throw err;
    }

    const text = await res.text();
    let data = {};
    if (text) {
      try {
        data = JSON.parse(text);
      } catch {
        data = { error: text.slice(0, 200) || res.statusText };
      }
    }

    if (!res.ok) {
      let msg = data.error || res.statusText || 'Ошибка запроса';
      if (res.status === 401 && path.includes('/admin/login')) {
        msg = 'Неверный логин или пароль';
      } else if (res.status === 401) {
        msg = 'Сессия истекла — войдите снова';
      } else if (res.status >= 500) {
        msg = `Ошибка сервера (${res.status}): ${msg}`;
      }
      const err = new Error(msg);
      err.status = res.status;
      throw err;
    }
    return data;
  }

  function showLoginError(message) {
    const errEl = document.getElementById('login-error');
    if (!errEl) return;
    errEl.textContent = message;
    errEl.classList.add('visible');
  }

  function clearLoginError() {
    const errEl = document.getElementById('login-error');
    if (!errEl) return;
    errEl.textContent = '';
    errEl.classList.remove('visible');
  }

  function route() {
    const hash = location.hash.replace(/^#\/?/, '') || 'login';
    const parts = hash.split('/').filter(Boolean);
    return { page: parts[0] || 'login', tab: parts[1] || 'settings' };
  }

  function navigate(hash) {
    location.hash = hash;
    render();
  }

  function esc(s) {
    return String(s ?? '')
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;');
  }

  function fmtDate(v) {
    if (!v) return '—';
    try {
      return new Date(v).toLocaleString('ru-RU');
    } catch {
      return esc(v);
    }
  }

  function shortId(id) {
    const s = String(id || '');
    if (s.length <= 12) return s;
    return `${s.slice(0, 6)}…${s.slice(-4)}`;
  }

  async function render() {
    const r = route();
    try {
      if (r.page === 'login') return renderLogin();
      if (!token()) return navigate('#/login');

      if (r.page === 'games') return await renderGames();
      if (r.page === 'expansion') return await renderExpansion(r.tab);
      navigate('#/games');
    } catch (e) {
      if (e.status === 401) {
        clearSession();
        if (route().page !== 'login') {
          location.hash = '#/login';
          await render();
          showLoginError(e.message);
        }
        return;
      }
      app.innerHTML = `<div class="wrap"><div class="card error">${esc(e.message)}</div></div>`;
    }
  }

  function renderLogin() {
    clearSession();
    clearLoginError();

    app.innerHTML = `
      <div class="wrap">
        <div class="topbar"><h1>Danila Games — Admin</h1></div>
        <div class="card login-card">
          <h2>Вход</h2>
          <div id="login-error" class="alert-error" role="alert"></div>
          <form id="login-form">
            <label for="login-username">Логин</label>
            <input id="login-username" name="username" type="text" value="admin" autocomplete="username" required>
            <label for="login-password">Пароль</label>
            <div class="password-wrap">
              <input id="login-password" name="password" type="password" autocomplete="current-password" required>
              <button type="button" class="password-toggle" id="password-toggle" aria-label="Показать пароль" title="Показать пароль">👁</button>
            </div>
            <button type="submit" class="primary" id="login-submit">Войти</button>
          </form>
        </div>
      </div>`;

    document.getElementById('password-toggle').onclick = () => {
      const input = document.getElementById('login-password');
      const btn = document.getElementById('password-toggle');
      const show = input.type === 'password';
      input.type = show ? 'text' : 'password';
      btn.textContent = show ? '🙈' : '👁';
      btn.setAttribute('aria-label', show ? 'Скрыть пароль' : 'Показать пароль');
    };

    document.getElementById('login-form').onsubmit = async (ev) => {
      ev.preventDefault();
      clearLoginError();
      const submitBtn = document.getElementById('login-submit');
      const fd = new FormData(ev.target);
      submitBtn.disabled = true;
      submitBtn.textContent = 'Вход…';
      try {
        const data = await api('/platform/admin/login', {
          method: 'POST',
          body: JSON.stringify({
            username: String(fd.get('username') || '').trim(),
            password: String(fd.get('password') || ''),
          }),
        });
        if (!data.accessToken) {
          throw new Error('Сервер не вернул токен — попробуйте снова');
        }
        setSession(data.accessToken, data.username || 'admin');
        location.hash = '#/games';
        await render();
      } catch (e) {
        showLoginError(e.message || 'Ошибка входа');
      } finally {
        submitBtn.disabled = false;
        submitBtn.textContent = 'Войти';
      }
    };
  }

  async function renderGames() {
    const data = await api('/platform/games');
    const games = data.games || [];
    app.innerHTML = `
      <div class="wrap">
        <div class="topbar">
          <h1>Выбор игры</h1>
          <button type="button" id="logout">Выйти</button>
        </div>
        <div class="grid-games">
          ${games
            .map(
              (g) => `
            <a class="game-tile" href="#/${esc(g.slug)}/settings">
              <strong>${esc(g.title)}</strong>
              <span>${esc(g.slug)}</span>
            </a>`,
            )
            .join('')}
        </div>
        <p class="hint">Пока доступна только Expansion. Новые игры добавятся сюда.</p>
      </div>`;
    document.getElementById('logout').onclick = () => {
      clearSession();
      navigate('#/login');
    };
  }

  async function renderExpansion(tab) {
    const sections = [
      ['settings', 'Настройки'],
      ['players', 'Игроки'],
      ['finance', 'Финансы'],
    ];

    app.innerHTML = `
      <div class="wrap wrap-wide">
        <div class="topbar">
          <h1>Expansion — админка</h1>
          <div>
            <a href="#/games" class="btn">← Игры</a>
            <button type="button" id="logout2" style="margin-left:8px">Выйти</button>
          </div>
        </div>
        <div class="admin-layout">
          <nav class="sidebar" aria-label="Разделы">
            ${sections
              .map(
                ([id, label]) =>
                  `<a href="#/expansion/${id}" class="nav-item ${tab === id ? 'active' : ''}">${label}</a>`,
              )
              .join('')}
          </nav>
          <div class="admin-main" id="tab-body"><p class="hint">Загрузка…</p></div>
        </div>
      </div>`;

    document.getElementById('logout2').onclick = () => {
      clearSession();
      navigate('#/login');
    };

    const body = document.getElementById('tab-body');
    if (tab === 'settings') body.innerHTML = await settingsView();
    else if (tab === 'players') body.innerHTML = await playersView();
    else if (tab === 'finance') body.innerHTML = await financeView();
    else body.innerHTML = '<div class="card">Неизвестная вкладка</div>';

    bindSettingsHandlers();
    bindPlayerTabs();
  }

  async function settingsView() {
    const s = await api('/admin/expansion/settings');
    return `
      <div class="card">
        <h2>Монетизация</h2>
        <div class="toggle-row">
          <div><strong>Реклама</strong><br><span class="hint">Баннер, interstitial, rewarded в приложении</span></div>
          <label class="switch"><input type="checkbox" id="ads-enabled" ${s.adsEnabled ? 'checked' : ''}><span class="slider"></span></label>
        </div>
        <div class="toggle-row">
          <div><strong>Донаты</strong><br><span class="hint">IAP на экране «Поддержать»</span></div>
          <label class="switch"><input type="checkbox" id="donations-enabled" ${s.donationsEnabled ? 'checked' : ''}><span class="slider"></span></label>
        </div>
        <p class="hint" id="settings-status">Обновлено: ${fmtDate(s.updatedAt)}</p>
      </div>`;
  }

  function bindSettingsHandlers() {
    const ads = document.getElementById('ads-enabled');
    const don = document.getElementById('donations-enabled');
    const status = document.getElementById('settings-status');
    if (!ads || !don) return;

    async function patch() {
      try {
        const data = await api('/admin/expansion/settings', {
          method: 'PATCH',
          body: JSON.stringify({
            adsEnabled: ads.checked,
            donationsEnabled: don.checked,
          }),
        });
        status.textContent = `Сохранено · ${fmtDate(data.updatedAt)}`;
      } catch (e) {
        status.textContent = `Ошибка: ${e.message}`;
      }
    }

    ads.onchange = patch;
    don.onchange = patch;
  }

  async function playersView() {
    const [reg, guest] = await Promise.all([
      api('/admin/expansion/players/registered?limit=200'),
      api('/admin/expansion/players/guests?limit=200'),
    ]);

    return `
      <div class="subtabs" id="player-subtabs">
        <button type="button" class="tab active" data-ptab="reg">Зарегистрированные (${reg.total})</button>
        <button type="button" class="tab" data-ptab="guest">Гости (${guest.total})</button>
      </div>
      <div id="player-table">${registeredTable(reg)}</div>`;
  }

  function registeredTable(data) {
    const rows = (data.players || [])
      .map(
        (p) => `<tr>
          <td>${esc(p.nick)}</td>
          <td>${esc(p.email)}</td>
          <td>${p.mapClassic}</td>
          <td>${p.scoreClassic}</td>
          <td>${p.supporterTier}</td>
          <td>${p.adsRemoved ? 'да' : '—'}</td>
          <td>${fmtDate(p.createdAt)}</td>
        </tr>`,
      )
      .join('');
    return `<div class="card"><table>
      <thead><tr><th>Nick</th><th>Email</th><th>Миссия</th><th>Очки</th><th>Tier</th><th>Без рекл.</th><th>Регистрация</th></tr></thead>
      <tbody>${rows || '<tr><td colspan="7">Пусто</td></tr>'}</tbody>
    </table></div>`;
  }

  function guestsTable(data) {
    const rows = (data.guests || [])
      .map(
        (g) => `<tr>
          <td class="mono" title="${esc(g.deviceId)}">${esc(shortId(g.deviceId))}</td>
          <td>${g.mapClassic}</td>
          <td>${g.scoreClassic}</td>
          <td>${g.supporterTier}</td>
          <td>${g.adsRemoved ? 'да' : '—'}</td>
          <td>${fmtDate(g.lastSeen)}</td>
        </tr>`,
      )
      .join('');
    return `<div class="card"><table>
      <thead><tr><th>Device ID</th><th>Миссия</th><th>Очки</th><th>Tier</th><th>Без рекл.</th><th>Был онлайн</th></tr></thead>
      <tbody>${rows || '<tr><td colspan="6">Пусто</td></tr>'}</tbody>
    </table></div>`;
  }

  let cachedGuests = null;
  let cachedReg = null;

  async function bindPlayerTabs() {
    const subtabs = document.getElementById('player-subtabs');
    const table = document.getElementById('player-table');
    if (!subtabs || !table) return;

    if (!cachedReg) {
      cachedReg = await api('/admin/expansion/players/registered?limit=200');
      cachedGuests = await api('/admin/expansion/players/guests?limit=200');
    }

    subtabs.querySelectorAll('[data-ptab]').forEach((btn) => {
      btn.onclick = () => {
        subtabs.querySelectorAll('.tab').forEach((t) => t.classList.remove('active'));
        btn.classList.add('active');
        table.innerHTML =
          btn.dataset.ptab === 'guest'
            ? guestsTable(cachedGuests)
            : registeredTable(cachedReg);
      };
    });
  }

  async function financeView() {
    const [summary, purchases] = await Promise.all([
      api('/admin/expansion/finance/summary?months=12'),
      api('/admin/expansion/finance/purchases?limit=100'),
    ]);

    const monthRows = (summary.months || [])
      .map(
        (m) => `<tr>
          <td>${esc(m.month)}</td>
          <td>${m.donations.count} (${m.donations.totalRub} ₽)</td>
          <td>${m.ads.banner}</td>
          <td>${m.ads.interstitial}</td>
          <td>${m.ads.rewarded}</td>
          <td>${m.ads.total}</td>
        </tr>`,
      )
      .join('');

    const purchaseRows = (purchases.purchases || [])
      .map(
        (p) => `<tr>
          <td>${fmtDate(p.createdAt)}</td>
          <td>${esc(p.productId)}</td>
          <td>${p.priceRub ?? '—'} ₽</td>
          <td>${esc(p.store)}</td>
          <td>${esc(p.nick || shortId(p.deviceId))}</td>
        </tr>`,
      )
      .join('');

    return `
      <div class="card">
        <h2>Сводка по месяцам</h2>
        <p class="hint">${esc(summary.yandexRevenueNote || '')}</p>
        <table>
          <thead><tr><th>Месяц</th><th>Донаты</th><th>Banner</th><th>Interstitial</th><th>Rewarded</th><th>Всего показов</th></tr></thead>
          <tbody>${monthRows || '<tr><td colspan="6">Нет данных</td></tr>'}</tbody>
        </table>
      </div>
      <div class="card">
        <h2>Последние покупки</h2>
        <table>
          <thead><tr><th>Дата</th><th>Product</th><th>Сумма</th><th>Store</th><th>Игрок</th></tr></thead>
          <tbody>${purchaseRows || '<tr><td colspan="5">Нет покупок</td></tr>'}</tbody>
        </table>
      </div>`;
  }

  window.addEventListener('hashchange', render);
  if (!location.hash || location.hash === '#') {
    location.replace('#/login');
  } else {
    render();
  }
})();
