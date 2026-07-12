// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Expansion';

  @override
  String get splashTitleSpace => 'КОСМИЧЕСКАЯ';

  @override
  String get splashTitleExpansion => 'ЭКСПАНСИЯ';

  @override
  String get splashPretext =>
      '2222 год. Перенаселение Земли, голод и нехватка ресурсов вынудили человечество осваивать планеты Солнечной системы. Тем временем со спутников сообщили: Плутон захвачен пришельцами. Наша экспансия столкнулась с чужой. Руководить этим непростым делом решили доверить вам — бывшему военному. Судьба человечества в ваших руках!';

  @override
  String get splashLoadLabel => 'загрузка...';

  @override
  String get splashBeginGame => 'Начать новую игру';

  @override
  String get splashMenuProfile => 'Профиль';

  @override
  String get splashMenuSettings => 'Настройки';

  @override
  String get splashMenuProgress => 'Прогресс';

  @override
  String get splashMenuNewGame => 'Новая игра';

  @override
  String get splashMenuUpgrades => 'Улучшения';

  @override
  String get splashMenuContinue => 'Продолжить';

  @override
  String get splashFeatureSoon => 'Раздел в разработке — скоро будет доступен.';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSectionGeneral => 'Общие';

  @override
  String get settingsReplayIntro => 'Показать вступление снова';

  @override
  String get settingsReplayIntroHint =>
      'Показать вступительный текст на стартовом экране';

  @override
  String get settingsLanguage => 'Язык интерфейса';

  @override
  String get settingsLanguageHint => 'Применяется ко всем экранам';

  @override
  String get settingsLanguageRu => 'Русский';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsDifficulty => 'Сложность кампании';

  @override
  String get settingsDifficultyHint =>
      'Влияет на темп и тактику чужих. Применится со следующего боя.';

  @override
  String get battleDefeatHintStreakBody =>
      'Несколько поражений подряд на этой миссии. Попробуйте снизить сложность в настройках — мета-апгрейды сохранятся.';

  @override
  String get battleLowerDifficulty => 'Снизить сложность';

  @override
  String get splashDontShowAgain => 'Не показывать при следующей загрузке';

  @override
  String get introStoryTitle => 'История';

  @override
  String get campaignEpilogueTitle => 'Победа';

  @override
  String get campaignEpilogueDismiss => 'К карте';

  @override
  String campaignEpilogueText(int missionCount) {
    return 'Командир! Благодаря только вашему командованию мы разгромили вторгшихся захватчиков и очистили звёздный сектор от угрозы. Все $missionCount систем этой кампании — под нашим контролем.\n\nРазведка докладывает: открыты новые маршруты. Впереди десятки звёздных систем, готовых принять колонистов. Человечество снова смотрит в глубину космоса с надеждой — и снова на вас.\n\nОтдышитесь, укрепите базы, готовьте флот. Экспансия продолжается. Это ваша победа.';
  }

  @override
  String get mapsTitle => 'Карта кампании';

  @override
  String get beginTitle => 'Новая игра';

  @override
  String get battleTitle => 'Бой';

  @override
  String get battleLayoutNotFound =>
      'Раскладка боя для этой миссии не найдена.';

  @override
  String get guestDefaultName => 'Гость';

  @override
  String get battlePauseTitle => 'Пауза';

  @override
  String get battlePauseContinue => 'Продолжить';

  @override
  String get battlePauseRestart => 'Перезапустить';

  @override
  String get battlePauseExitMain => 'Выйти в главное';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get progressTitle => 'Прогресс';

  @override
  String get upgradesTitle => 'Улучшения';

  @override
  String get screenPlaceholderBody =>
      'Раздел в разработке. Контент и логика — на следующих этапах.';

  @override
  String get bootstrapInitFailed =>
      'Не удалось подготовить локальную базу. Повторите запуск приложения.';

  @override
  String get mapsStartBattle => 'Экспансия';

  @override
  String get mapsDescriptionFallback =>
      'Разведка системы продолжается. Готовьтесь к бою.';

  @override
  String get mapsLoadFailed => 'Не удалось загрузить карту кампании.';

  @override
  String get mapsMissionCompleted => 'Пройдено';

  @override
  String get mapsUnknownSystem => '???????';

  @override
  String get beginDifficultyHint =>
      'Выберите сложность. От неё зависит темп и непредсказуемость чужих.';

  @override
  String get beginDifficultyEasy => 'Лёгкая';

  @override
  String get beginDifficultyAverage => 'Средняя';

  @override
  String get beginDifficultyHard => 'Сложная';

  @override
  String get beginStartMission => 'Спасти человечество';

  @override
  String get beginUniverHint => 'Вселенная (режим кампании)';

  @override
  String get beginUniverClassic => 'Классическая';

  @override
  String get beginUniverClassicHint => '40 миссий кампании';

  @override
  String get beginUniverGenerated => 'Случайная';

  @override
  String get beginUniverStrategic => 'Стратегическая';

  @override
  String get beginUniverComingSoon => 'Скоро';

  @override
  String get beginResetConfirmTitle => 'Начать заново?';

  @override
  String get beginResetConfirmBody =>
      'Прогресс кампании, очки и улучшения будут сброшены. Это нельзя отменить.';

  @override
  String get beginResetConfirm => 'Сбросить и начать';

  @override
  String get beginResetCancel => 'Отмена';

  @override
  String get progressDifficulty => 'Сложность';

  @override
  String get progressUniver => 'Вселенная';

  @override
  String get battleBriefingFallback => 'Захватите все вражеские базы.';

  @override
  String get battleDragHint =>
      'Проведите палец от своей базы к цели. Тап по своей базе — улучшения.';

  @override
  String battleBaseSummary(int ships, int shield, int resources) {
    return 'Корабли $ships · Щит $shield · Ресурсы $resources';
  }

  @override
  String get tacticalUpgradeShieldShort => 'Щит';

  @override
  String get tacticalUpgradeBuildShort => 'Постр.';

  @override
  String get tacticalUpgradeMaxShipsShort => 'Лимит';

  @override
  String get battleMeteoriteTutorialTitle => 'Астероид!';

  @override
  String get battleMeteoriteTutorialBody =>
      'Астероид пролетает через поле. При столкновении с базой сначала снимает щит, затем уничтожает корабли. Держите щит или уводите флот с траектории.';

  @override
  String get battleMeteoriteTutorialDismiss => 'Понятно';

  @override
  String get battleTacticalSwipeHint => 'Смахните вниз или нажмите ✕';

  @override
  String get battleTacticalClose => 'Закрыть';

  @override
  String get battleSendFailed =>
      'Не удалось отправить флот: выберите свою базу, дождитесь конца полёта или проверьте линию.';

  @override
  String get battleTacticalTitle => 'Улучшения базы';

  @override
  String battleTacticalResources(int amount) {
    return 'Ресурсы: $amount';
  }

  @override
  String get tacticalUpgradeShield => 'Усилить щит (+20)';

  @override
  String get tacticalUpgradeBuild => 'Ускорить постройку';

  @override
  String get tacticalUpgradeMaxShips => 'Расширить лимит кораблей';

  @override
  String battleTacticalBuy(int cost) {
    return '$cost';
  }

  @override
  String get battleTacticalMaxLabel => 'Макс.';

  @override
  String get battleTacticalSuccess => 'Улучшение применено';

  @override
  String get battleTacticalNotEnough => 'Недостаточно ресурсов на базе';

  @override
  String get battleTacticalMax => 'Достигнут максимум улучшений';

  @override
  String get battleTacticalBusy =>
      'Дождитесь завершения полёта флота или астероида';

  @override
  String get battleVictoryTitle => 'Победа';

  @override
  String get battleVictoryBody =>
      'Система под контролем. Следующая миссия открыта на карте.';

  @override
  String battleVictoryBodyWithScore(int score) {
    return 'Система под контролем. Награда: $score очков. Следующая миссия на карте.';
  }

  @override
  String metaUpgradeScore(int score) {
    return 'Очки: $score';
  }

  @override
  String get metaUpgradeShipSpeed => 'Скорость флота';

  @override
  String get metaUpgradeShipDurability => 'Сила атаки';

  @override
  String get metaUpgradeShipBuildSpeed => 'Постройка кораблей';

  @override
  String get metaUpgradeResourceIncome => 'Доход ресурсов';

  @override
  String get metaUpgradeShield => 'Прочность щита';

  @override
  String get metaUpgradeBeginShips => 'Стартовые корабли';

  @override
  String metaUpgradeLevel(int level, int percent) {
    return 'Ур. $level (+$percent%)';
  }

  @override
  String metaUpgradeBuy(int cost) {
    return '$cost';
  }

  @override
  String get metaUpgradeMax => 'Макс.';

  @override
  String get metaUpgradePurchased => 'Улучшение куплено';

  @override
  String get metaUpgradeNotEnough => 'Недостаточно очков';

  @override
  String get progressCurrentMission => 'Текущая миссия';

  @override
  String get progressCompleted => 'Пройдено миссий';

  @override
  String get progressScore => 'Очки';

  @override
  String get progressEnemyPower => 'Сила чужих (кампания)';

  @override
  String get battleDefeatTitle => 'Поражение';

  @override
  String get battleDefeatBody =>
      'Флот разбит. Попробуйте снова или снизьте сложность.';

  @override
  String get battleContinue => 'Продолжить';

  @override
  String battleVictoryRewardDetail(int base, int bonus, int total) {
    return 'База: $base + миссия: $bonus = $total очков.';
  }

  @override
  String get battleVictoryToMap => 'На карту';

  @override
  String get battleVictoryToUpgrades => 'Улучшения';

  @override
  String battleVictoryNextMission(int id) {
    return 'Следующая миссия ($id)';
  }

  @override
  String get battleTutorialDragTitle => 'Отправка флота';

  @override
  String get battleTutorialDragBody =>
      'Свайп от своей базы (синяя) к соседней цели. Отправится половина кораблей на базе.';

  @override
  String get battleTutorialCaptureTitle => 'Захват';

  @override
  String get battleTutorialCaptureBody =>
      'Смотрите на поле: флот летит к цели (пульс на базе). После захвата тапните захваченную базу.';

  @override
  String get battleTutorialUpgradeTitle => 'Улучшения базы';

  @override
  String get battleTutorialUpgradeBody =>
      'Тапните захваченную базу на поле. Купите улучшение или нажмите «Понятно» — дальше расскажем про врага и цель боя.';

  @override
  String get battleTutorialGoalTitle => 'Цель боя';

  @override
  String get battleTutorialGoalBody =>
      'Красные базы врага тоже отправляют флоты и захватывают ваши и нейтральные базы. Победа — когда не останется вражеских баз. Поражение — если потеряете все свои базы.';

  @override
  String get battleTutorialDismiss => 'Понятно';

  @override
  String get battleTutorialSkip => 'Пропустить';

  @override
  String get battleIntroMediumBaseTitle => 'Средняя база';

  @override
  String get battleIntroMediumBaseBody =>
      'Старт 40 кораблей, лимит 50. Сложнее захватить, чем малую (20/30).';

  @override
  String get battleIntroLargeBaseTitle => 'Большая база';

  @override
  String get battleIntroLargeBaseBody =>
      'Старт 60 кораблей, лимит 80. Берите последней — нужен крупный флот.';

  @override
  String get battleIntroRichBaseTitle => 'Богатая база';

  @override
  String get battleIntroRichBaseBody =>
      'Даёт в 5 раз больше ресурсов (×5). Захватывайте для улучшений. Не отправляйте отсюда флот в атаку — держите базу в тылу.';

  @override
  String get battleIntroShieldedBaseTitle => 'База со щитом';

  @override
  String get battleIntroShieldedBaseBody =>
      'Стартовый щит поглощает урон от астероидов, комет и прочих космических угроз. Сначала бейте по щиту, потом по кораблям.';

  @override
  String get battleIntroFactoryBaseTitle => 'Фабрика';

  @override
  String get battleIntroFactoryBaseBody =>
      'Строит корабли в 5 раз быстрее (×5), но стартовый гарнизон меньше. Захватите и удержите — фабрика быстро разгонится.';

  @override
  String get battleIntroBunkerBaseTitle => 'Бункер';

  @override
  String get battleIntroBunkerBaseBody =>
      'Высокий лимит кораблей и крепкий гарнизон, но медленный рост. Сложнее выбить, нужен крупный флот.';

  @override
  String get battleIntroCometTitle => 'Комета!';

  @override
  String get battleIntroCometBody =>
      'Комета влетает по дуге от угла поля. Бьёт базы и флоты на пути — следите за неожиданными траекториями.';

  @override
  String get battleIntroPulseTitle => 'Энергоимпульс!';

  @override
  String get battleIntroPulseBody =>
      'Импульс расходится от центра по кресту. Задевает базы и флоты на линиях — планируйте маршруты с запасом.';

  @override
  String get battleIntroDroneTitle => 'Дроны снабжения';

  @override
  String get battleIntroDroneBody =>
      'Периодически подкидывают корабли на базы врага. Давите вражеские базы быстрее, пока дроны их усиливают.';

  @override
  String get battleDebrisTutorialTitle => 'Метеоритный поток!';

  @override
  String get battleDebrisTutorialBody =>
      'Метеоритный поток летит поперёк по центру поля. Уничтожает 80% кораблей флота и гарнизона на пути и пролетает дальше — не ведите корабли через центр без нужды.';

  @override
  String metaUpgradeLevelShort(int level) {
    return 'Ур. $level';
  }

  @override
  String get mapTutorialTitle => 'Карта кампании';

  @override
  String get mapTutorialBody =>
      'Выберите систему и нажмите «Экспансия», чтобы начать бой. Пройденные миссии можно переигрывать.';

  @override
  String get mapTutorialDismiss => 'Вперёд';

  @override
  String get mapTutorialLater => 'Позже';

  @override
  String get helpTitle => 'Справка';

  @override
  String get helpBattleTitle => 'Бой';

  @override
  String get helpBattleBody =>
      'Свайп между базами отправляет флот по прямой, если путь свободен. Захватите все вражеские базы. Астероиды бьют по щиту и кораблям.';

  @override
  String get helpMapTitle => 'Карта';

  @override
  String get helpMapBody =>
      '40 миссий Classic. Текущая отмечена мишенью. После победы открывается следующая система.';

  @override
  String get helpUpgradesTitle => 'Апгрейды';

  @override
  String get helpUpgradesBody =>
      'Мета-апгрейды покупаются за очки между боями и сохраняются. Тактические — только внутри боя за ресурсы базы.';

  @override
  String get helpDifficultyTitle => 'Сложность';

  @override
  String get helpDifficultyBody =>
      'Лёгкая — медленнее AI и чуть быстрее ваш флот. Сложная — агрессивнее чужие. Мета-апгрейды при поражении не сбрасываются.';

  @override
  String get settingsSound => 'Звук';

  @override
  String get settingsSoundHint =>
      'Эффекты боя (ассеты подключаются по мере переноса)';

  @override
  String get settingsHelp => 'Справка по игре';

  @override
  String get profileGuestLabel => 'Гость';

  @override
  String get profileDisplayName => 'Имя';

  @override
  String get profileDisplayNameHint => 'Как отображать в профиле';

  @override
  String get profileSave => 'Сохранить';

  @override
  String get profileMission => 'Текущая миссия';

  @override
  String get profileScore => 'Очки';

  @override
  String get profileStarted => 'Кампания с';

  @override
  String get profileAccountHint =>
      'Аккаунт сохраняет прогресс в облаке и открывает рейтинг.';

  @override
  String get profileRegister => 'Зарегистрироваться';

  @override
  String get profileLogin => 'Войти';

  @override
  String get profileAccountTitle => 'Аккаунт';

  @override
  String get profileLogout => 'Выйти';

  @override
  String get profileLogoutSuccess => 'Вы вышли из аккаунта';

  @override
  String get profileDeleteAccount => 'Удалить аккаунт';

  @override
  String get profileDeleteAccountTitle => 'Удалить аккаунт?';

  @override
  String get profileDeleteAccountBody =>
      'Прогресс на сервере и рейтинг будут удалены без возможности восстановления.';

  @override
  String get profileDeleteAccountConfirm => 'Удалить';

  @override
  String get profileDeleteAccountSuccess => 'Аккаунт удалён';

  @override
  String get progressLeaderboard => 'Лучшие результаты';

  @override
  String get leaderboardTitle => 'Рейтинг';

  @override
  String get leaderboardEmpty => 'Пока никого в таблице — будьте первым!';

  @override
  String get leaderboardLoadFailed => 'Не удалось загрузить рейтинг';

  @override
  String get leaderboardGuestHint => 'Можешь быть в таблице — зарегистрируйся';

  @override
  String leaderboardMission(int mission) {
    return 'Миссия $mission';
  }

  @override
  String get authLoginTitle => 'Вход';

  @override
  String get authRegisterTitle => 'Регистрация';

  @override
  String get authForgotTitle => 'Забыл пароль';

  @override
  String get authResetTitle => 'Новый пароль';

  @override
  String get authVerifyTitle => 'Подтверждение email';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Пароль';

  @override
  String get authPasswordHint => 'Минимум 6 символов';

  @override
  String get authNewPassword => 'Новый пароль';

  @override
  String get authNick => 'Ник';

  @override
  String get authNickHint => '3–20 символов, буквы, цифры, _';

  @override
  String get authRealName => 'Имя';

  @override
  String get authLoginAction => 'Войти';

  @override
  String get authRegisterAction => 'Зарегистрироваться';

  @override
  String get authForgotLink => 'Забыл пароль';

  @override
  String get authForgotAction => 'Отправить код';

  @override
  String get authResetAction => 'Сохранить пароль';

  @override
  String get authVerifyAction => 'Подтвердить';

  @override
  String get authVerifyCode => 'Код из письма';

  @override
  String get authNoAccount => 'Нет аккаунта?';

  @override
  String get authHaveAccount => 'Уже есть аккаунт?';

  @override
  String get authBackToLogin => 'К входу';

  @override
  String get authRegisterHint =>
      'Ник виден в рейтинге. Имя — в скобках рядом с ником.';

  @override
  String get authForgotBody =>
      'Введите email — отправим код для сброса пароля.';

  @override
  String authVerifyBody(String email) {
    return 'Код отправлен на $email. Введите его ниже.';
  }

  @override
  String authResetBody(String email) {
    return 'Код отправлен на $email. Придумайте новый пароль.';
  }

  @override
  String get authVerifySent => 'Код отправлен на почту';

  @override
  String get authResetSent => 'Код для сброса отправлен';

  @override
  String get authLoginSuccess => 'Вы вошли в аккаунт';

  @override
  String get authRegisterSuccess => 'Аккаунт создан';

  @override
  String get authResetSuccess => 'Пароль обновлён — войдите с новым';

  @override
  String get authErrorGeneric => 'Не удалось выполнить запрос';

  @override
  String get authErrorEmailExists => 'Этот email уже зарегистрирован — войдите';

  @override
  String get authErrorNickTaken => 'Этот ник занят';

  @override
  String get authErrorEmailSend =>
      'Не удалось отправить письмо — попробуйте позже';

  @override
  String get authErrorInvalidCredentials => 'Неверный email или пароль';

  @override
  String get authErrorInvalidCode => 'Неверный или просроченный код';

  @override
  String get authNickChecking => 'Проверяем ник…';

  @override
  String get authNickAvailable => 'Ник свободен';

  @override
  String get authNickTaken => 'Ник занят';

  @override
  String get authNickTooShort => 'Ник слишком короткий';

  @override
  String get authNickInvalid => 'Недопустимые символы в нике';

  @override
  String get authNickReserved => 'Этот ник зарезервирован';

  @override
  String get authMergeTitle => 'Два сохранения';

  @override
  String get authMergeBody =>
      'На устройстве и на сервере есть прогресс. Что оставить?';

  @override
  String get authMergeLocal => 'На устройстве';

  @override
  String get authMergeServer => 'На сервере';

  @override
  String authMergeMissionScore(int mission, int score) {
    return 'Миссия $mission · очки $score';
  }

  @override
  String get newMissionsBannerTitle => 'Новые миссии!';

  @override
  String get newMissionsBannerBody =>
      'На сервере появились новые уровни — они уже на устройстве, можно играть офлайн.';

  @override
  String get newMissionsBannerAction => 'На карту';

  @override
  String get newMissionsBannerDismiss => 'Понятно';

  @override
  String get donateTitle => 'Поддержать';

  @override
  String get donateBody =>
      'Expansion — инди-проект. Ссылка на репозиторий и будущие способы поддержки.';

  @override
  String get donateGithub => 'GitHub проекта';

  @override
  String get donateThanks => 'Спасибо, что играете!';

  @override
  String get donateOpenFailed => 'Не удалось открыть ссылку';

  @override
  String battleScenePlaceholder(int sceneId) {
    return 'Миссия $sceneId. Бой — в разработке (фаза 3).';
  }
}
