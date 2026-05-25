# Android Edge-to-Edge (Google Play)

Цель: снизить риск предупреждения о неподдерживаемых API/параметрах edge-to-edge.

## Не задавать вручную

- `android:statusBarColor` / `android:navigationBarColor` в `styles.xml`
- Принудительный `statusBarColor` / `navigationBarColor` в `SystemUiOverlayStyle` без необходимости

## Допустимо

- `statusBarIconBrightness` / `systemNavigationBarIconBrightness` для читаемости
- `SafeArea` / `MediaQuery.padding` для контента

## Проверка перед релизом

```text
rg "statusBarColor|navigationBarColor|windowOptOutEdgeToEdgeEnforcement" android lib
```

Smoke: запуск, статус-бар читаем, нет артефактов сверху/снизу.
