# Монетизация Expansion (РФ): Яндекс РСЯ + донаты

Пошаговая инструкция **на твоей стороне** — регистрация, кабинеты, выплаты.  
Код уже в `expansion_app`: реклама Yandex Mobile Ads, IAP через `in_app_purchase`.

---

## Модель v1 (как в игре)

| Источник | Что даёт игроку |
|----------|-----------------|
| **Кампания** | Все 40 миссий бесплатно |
| **Rewarded** | После победы: опционально +50% очков за просмотр |
| **Interstitial** | Редко при выходе бой → карта (≥3 боя, пауза ≥5 мин) |
| **Banner** | Низ экрана: карта, настройки, «Поддержать» — **не в бою** |
| **Донат tier 1–3** | Косметический уровень поддержки (0→3), без P2W |
| **Remove ads** | Отключает баннер и interstitial |

---

## Часть 1. Яндекс РСЯ (реклама)

### 1. Регистрация

1. [partner.yandex.ru](https://partner.yandex.ru) → войти через Яндекс ID.
2. **Рекламная сеть (РСЯ)** → добавить площадку типа **Мобильное приложение**.
3. Указать:
   - название: `Expansion`;
   - платформа: Android (позже iOS);
   - package: `com.ryjovs.expansion` (как в `build.gradle.kts`).

### 2. Создать ad unit’ы

В кабинете РСЯ для приложения создай **три блока**:

| Формат | Имя в кабинете | ID в коде (`--dart-define`) |
|--------|----------------|----------------------------|
| Banner (sticky) | Expansion Banner Menu | `YANDEX_BANNER_AD_UNIT` |
| Interstitial | Expansion Inter Battle | `YANDEX_INTERSTITIAL_AD_UNIT` |
| Rewarded | Expansion Reward Victory | `YANDEX_REWARDED_AD_UNIT` |

Скопируй **Ad Unit ID** из кабинета (строка вида `R-M-XXXXXX-Y`).

### 3. Тест до публикации

В debug сборке по умолчанию **demo-ID** (`demo-banner-yandex` и т.д.) — реклама тестовая, деньги не начисляются.

Проверка на устройстве:

```powershell
cd expansion_app
flutter run
```

После победы в бою — кнопка «Реклама: +N очков». На карте/в настройках — баннер внизу.

### 4. Release-сборка с боевыми ID

Подставь свои ID при сборке (или в CI):

```powershell
flutter run --release `
  --dart-define=YANDEX_BANNER_AD_UNIT=R-M-XXXXXX-1 `
  --dart-define=YANDEX_INTERSTITIAL_AD_UNIT=R-M-XXXXXX-2 `
  --dart-define=YANDEX_REWARDED_AD_UNIT=R-M-XXXXXX-3
```

### 5. Модерация и выплаты РСЯ

- Приложение должно быть **опубликовано** в сторе (или тестовый трек) — РСЯ часто просит ссылку на карточку.
- В кабинете: **Финансы → Реквизиты** — расчётный счёт **ИП или юрлица** (самозанятому РСЯ обычно не платит напрямую на «Мой налог»; типичный путь — **ИП на УСН** + расчётный счёт).
- Минимальная выплата и сроки — в [help.yandex.ru/adv](https://yandex.ru/support/partner/).
- Налоги: доход от рекламы декларируешь как **ИП/самозанятый** (см. часть 3).

---

## Часть 2. Донаты (Google Play + RuStore)

Product ID **зашиты в коде** (можно переопределить `--dart-define`):

| Product ID | Тип | Цена (UI) |
|------------|-----|-----------|
| `com.ryjovs.expansion.donate_tier1` | consumable | 99 ₽ |
| `com.ryjovs.expansion.donate_tier2` | consumable | 299 ₽ |
| `com.ryjovs.expansion.donate_tier3` | consumable + идея | 599 ₽ |
| `com.ryjovs.expansion.remove_ads` | non-consumable | 199 ₽ |

Экран: **Настройки → Поддержать** (`/donate`).

Tier3 («Поддержка + Ваша идея»): перед оплатой — описание идеи → `POST /expansion/donations/idea`; после оплаты — админка (Финансы) + письмо игроку.

### Google Play Console

1. [play.google.com/console](https://play.google.com/console) → приложение `Expansion`.
2. **Монетизация → Продукты в приложении** → создать 4 продукта с ID **точно как в таблице**.
3. Consumable — для tier 1–3; **Non-consumable** — для remove_ads.
4. Цены: базовая **Россия (RUB)**.
5. **Лицензионное тестирование** — добавь свой Google-аккаунт для тестовых покупок без списания.
6. AAB в internal testing → установи через Play → проверь `/donate`.

### RuStore Console

1. [console.rustore.ru](https://console.rustore.ru) → приложение с package `com.ryjovs.expansion`.
2. **Монетизация → In-app продукты** — те же **product ID** и цены в ₽.
3. RuStore использует **свой billing SDK**; сейчас в коде — `in_app_purchase` (Google Play Billing).  
   **Для RuStore-only установок** позже понадобится `flutter_rustore_billing` — до тех пор донаты работают в сборке из **Google Play**.
4. AAB: см. `expansion_app/.cursor/rustore_aab_signature.md` (тот же keystore, что Play).

### Восстановление покупок

На экране «Поддержать» — **«Восстановить покупки»** (важно для remove_ads при смене устройства).

---

## Часть 3. Деньги и налоги (кратко)

| Статус | Реклама РСЯ | IAP сторы |
|--------|-------------|-----------|
| **Самозанятый (НПД)** | Обычно **нельзя** получать выплаты от Яндекса на личный счёт как от юрлица; на практике — **ИП** | Google/RuStore платят **юрлицу/ИП** по договору; самозанятость для IAP редко подходит |
| **ИП УСН 6%** | Расчётный счёт, договор с Яндексом, акты | Merchant account Play / RuStore → вывод на р/с |
| **Физлицо без статуса** | Не вариант для легальных выплат | Не вариант |

**Практичный старт для РФ:** ИП на УСН 6%, расчётный счёт (Тинькoff/Сбер/Точка), договор с РСЯ + merchant в Play и RuStore.

Чеки покупателям IAP выставляет **стор**; тебе — отчёты и выплаты на р/с минус комиссия (~15–30%).

---

## Чеклист перед релизом

- [ ] РСЯ: 3 ad unit, модерация приложения
- [ ] Play: 4 IAP продукта, internal test пройден
- [ ] RuStore: 4 IAP (если выкладываешь туда)
- [ ] Release-сборка с `--dart-define` для Yandex ID
- [ ] Privacy policy: упомянуть рекламу Яндекса и покупки (URL в карточке стора)
- [ ] Проверить: после «убрать рекламу» нет баннера и interstitial; rewarded по желанию остаётся

---

## Файлы в репозитории

| Путь | Назначение |
|------|------------|
| `lib/core/monetization/monetization_config.dart` | ID рекламы и IAP |
| `lib/core/monetization/game_ads_service.dart` | Yandex Ads |
| `lib/core/monetization/donate_billing_service.dart` | IAP |
| `lib/presentation/pages/donate_page.dart` | UI донатов |
| `lib/presentation/widgets/monetization/game_banner_ad_slot.dart` | Баннер |

---

## Если что-то не работает

| Симптом | Что проверить |
|---------|----------------|
| Баннер пустой | Demo-ID в debug; интернет; модерация блока в РСЯ |
| IAP «скоро в сторе» | Сборка не из Play; продукты не созданы / не active |
| Покупка зависла | Play Console → заказ; `completePurchase` в логах |
| RuStore нет доната | Нужен RuStore Billing SDK (отдельный этап) |

Вопросы по коду — в чат агента; по договору РСЯ — поддержка partner.yandex.ru.
