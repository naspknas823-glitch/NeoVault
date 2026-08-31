# NeoVault 🎮💰

Гейміфікований додаток-«скарбничка» для Android: накопичуй на **PS5 + Монітор**,
отримуй XP, рівні, ачівки, доглялай віртуального пета і стеж за цінами в
українських магазинах. **Online-only**, преміальний графіт-золотий UI.

> Повне ТЗ: `app-prompt-NeoVault-v2.md` (33 екрани, Retention Layer, Bundle
> Search, API Settings).

## Швидкий старт

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # Drift-код
flutter analyze          # 0 issues
flutter test             # 91 тест (55 юніт + 36 widget)
flutter build apk --debug
```

Вимоги: Flutter 3.44+ (SDK-міграція v0.9.1: `CardThemeData`/`DialogThemeData`/
`TabBarThemeData`, `intl ^0.20.2`), JDK 17, Android SDK 34.

## Архітектура

```
lib/
├── core/            # тема (§4), l10n UA/EN, роутер (33 маршрути + vault:// deep links),
│                    # Drift+SQLCipher БД (37 таблиць), sync-черга (backoff), PIN (PBKDF2)
├── domain/          # чиста логіка: XP-движок 5.1, ачівки, квести, Daily Drop, пет,
│                    # лідерборд з привидами, Buddy, Bundle Engine (7.1ter), Trust Score
├── data/
│   ├── cloud/       # CloudGateway контракт (Firebase ⇄ LocalOnly офлайн-fallback)
│   ├── repositories # Drift-стріми → Riverpod; seed-дані ІЗОЛЬОВАНО тут (isSeed=true)
│   └── seed         # ціни/гоно-картки/події — контракт підключення getPrices CF
├── features/        # екрани 6.1–6.33 (секція 6 ТЗ)
└── shared/          # неон-віджети, стани loading/error/empty/content (§8.2)
```

## Ключові рішення

- **Online-only (рішення v0.9.2):** офлайн-режиму НЕМАЄ. Ціни/пошук — тільки
  з мережі (Tavily); без мережі — чесні стани помилок + глобальний банер,
  БЕЗ підміни даних локальними seed/mock значеннями (⛔). Запис → Drift
  (`synced=false`) → `sync_queue` → flush на сервер (exponential backoff 1м→32м).
  Тест airplane-mode = юніт-тести черги.
- **Firebase:** SDK підключено; без `google-services.json` застосунок працює
  повністю локально через `LocalOnlyGateway` (контракт у
  `lib/data/cloud/cloud_gateway.dart`). Після `flutterfire configure` замінюється
  на `FirebaseGateway` без змін у UI.
- **⛔ Без фейків в UI:** ціни/магазини приходять лише з репозиторіїв; seed-рядки
  позначені `isSeed=true` і в UI мають маркер 🟡 «Потрібно підтвердити».
- **⚠️ Таблиця рівнів у ТЗ:** рядок «L7..L10: 760, 1141, 1711, 2567» суперечить
  зафіксованій формулі `L_n = ceil(prev*1.5)` (дає 761, 1142, 1713, 2570).
  Реалізовано формулу (⛔ §9.3); див. звіт у `delivery-report.md`.
- **Kotlin 2.1.0** у `android/settings.gradle` — потрібно для
  play-services-measurement 22.5.0.

## Приховане зберігання

- **PIN:** PBKDF2-HMAC-SHA256 (RFC 2898), 50 000 ітерацій, формат хешу
  самоописний — `pbkdf2-sha256$<iterations>$<base64>`. Хеші старих білдів
  (10 000 ітерацій, інший конструктив) перевіряються далі й **прозоро
  переобчислюються** при першому вдалому вводі PIN — без міграції схеми та без
  повторного налаштування PIN. Blacklist простих PIN (⛔ §6.21). Lockout: з 3-ї
  невдалої спроби кожна наступна помилка знову вмикає блок на 30 с; 10 спроб →
  вихід з акаунта.
  ⚠️ **Залишковий ризик:** 4–6-значний PIN — це лише 10⁴–10⁶ варіантів, тож
  жодна кількість ітерацій не робить офлайн-перебір *неможливим*, вона лише
  підвищує його вартість. Сіль і хеш лежать у таблиці `pin_meta`, тобто їхній
  реальний захист — це шифрування всієї БД (SQLCipher) плюс вимкнені бекапи.
  Наступний крок посилення — прив'язка хешу до Keystore-pepper.
- **API-ключі магазинів:** тільки salted SHA-256 + last-4 preview (⛔ §7.1quin.1).
- **БД:** SQLCipher, passphrase — 256-бітний ключ з CSPRNG, що зберігається
  **виключно** у `FlutterSecureStorage` (Android Keystore / EncryptedSharedPreferences).
  ⛔ Plaintext-fallback у файл `.nv_db_key` **видалено**: ключ шифрування ніколи
  не пишеться на диск, у Drift чи в SharedPreferences. Якщо Keystore
  недоступний — застосунок **не стартує** (fail-fast) і показує
  `BootstrapErrorApp` з чесною причиною та кнопкою Retry, замість того щоб
  тихо відкрити сейф ключем, який лежить поруч у відкритому вигляді.
  Успадкований `.nv_db_key` зі старих білдів одноразово переноситься в
  Keystore, після чого файл затирається й видаляється.
- **Бекапи:** `android:allowBackup="false"` + `dataExtractionRules`
  (Android 12+ device-to-device) + `fullBackupContent` (API ≤ 30) — сейф і
  налаштування не потрапляють ані в хмарний бекап, ані в перенесення на новий
  пристрій.

## CI/CD

`.github/workflows/ci.yml` — analyze + тести + debug/release APK +
Firebase App Distribution (секрети `FIREBASE_TOKEN`, `ANDROID_APP_ID` після
`flutterfire configure`).
