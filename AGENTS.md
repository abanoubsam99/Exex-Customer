# EVEX User App — Project Guide

> اقرأ الملف ده الأول قبل ما تمسح المشروع. فيه كل اللي محتاجه عن الهيكل والقواعد.
> Read this file first before scanning the codebase. It has everything about structure & rules.

---

## Stack

- **Flutter** app (`name: evex_user`)
- **State management:** `flutter_bloc` (Cubit) — **NO GetX** anywhere
- **Networking:** `dio` via a static `DioHelper`
- **Localization:** `easy_localization` (NO flutter gen-l10n, NO custom AppLocalizations)
- **DI:** constructor injection only — **NO** GetIt / injectable / service locator
- **Models:** plain Dart, manual `fromJson`/`toJson` — **NO** json_serializable / freezed / retrofit / code-gen

---

## Architecture / Folder Layout

```
lib/
├── app/
│   ├── bloc_providers.dart      # كل الـ repos + cubits متعرّفة هنا (مركزياً)
│   ├── helpers/
│   │   ├── dio_helper.dart      # static DioHelper.getData/postData/putData/deleteData
│   │   ├── cache_helper.dart    # wraps SharedPreferences (constructor-injected)
│   │   └── navigation_helper.dart # static, GlobalKey<NavigatorState>
│   └── constants/
├── core/
│   ├── routing/
│   │   ├── app_router.dart      # بيربط كل Cubit بالـ Screen (onGenerateRoute)
│   │   └── routes.dart          # أسماء الـ routes
│   ├── services/
│   │   ├── user_service.dart    # current user persistence (constructor-injected)
│   │   └── local_auth_service.dart
│   ├── localization/app_strings.dart  # مفاتيح الترجمة (keys ثابتة)
│   ├── theme/  ui/  helpers/  constants/
├── data/
│   ├── models/                  # كل الموديلات (plain Dart) - serialization بس
│   ├── repos/                   # كل الـ repos - كل API requests عبر DioHelper
│   └── cubits/<feature>/        # كل الـ cubits + states (logic + state)
└── features/<feature>/ui/       # الـ UI بس (Screens + Widgets) - مفيش logic
```

> ملحوظة: حالياً الـ UI في `features/<f>/ui/` والـ cubits في `data/cubits/`.
> (كان فيه خطة اختيارية لنقلهم لـ `lib/presentation/` لسه متعملتش.)

---

## Layer Responsibilities

| Layer  | Location              | Responsibility                               |
|--------|-----------------------|----------------------------------------------|
| Model  | `data/models/`        | serialization فقط (`fromJson`/`toJson`)      |
| Repo   | `data/repos/`         | كل الـ API requests عبر `DioHelper`، يرجّع model أو null |
| Cubit  | `data/cubits/<f>/`    | بينده الـ repo و يدير الـ state               |
| UI     | `features/<f>/ui/`    | عرض فقط، مفيش business logic                  |
| Router | `core/routing/`       | بيوصّل الـ Cubit بالـ Screen                  |

---

## Conventions / Rules (اتبعها دايماً)

### Repos — `lib/data/repos/`
- ملف واحد لكل module: `auth_repo.dart`, `home_repo.dart`, ...
- يستخدم `DioHelper` مباشرة. يرجّع `Model?` (model أو `null`).
- **ممنوع:** `Either` / `Result` / `Resource` / `DataState` / أي wrapper.
- **ممنوع:** remote data sources / repository interfaces / abstract repos / use cases.

```dart
class XxxRepo {
  Future<XxxModel?> getXxx() async {
    try {
      final response = await DioHelper.getData(url: AppEndpoints.xxx);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return XxxModel.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
```

### Cubits — `lib/data/cubits/<feature>/`
- بينده الـ repo بس. يتعامل مع النتيجة بـ `if (result != null) {...} else {...}`.
- **ممنوع** `.fold()` (مفيش Either خالص).

### Models — `lib/data/models/`
- plain Dart class، manual `fromJson` / `toJson`. مفيش code-gen.

### DI — constructor injection
- الـ repos + cubits متعرّفة في `lib/app/bloc_providers.dart`:
  - `BlocProviders.repositories({cacheHelper, userService, localAuthService})` → `RepositoryProvider` list
  - `BlocProviders.providers` → app-wide `BlocProvider` list
- `main.dart` بيبني الـ 3 core services بس (محتاجين `await`) وبيمرّرهم.
- الـ cubits الباقية بتتعمل per-route في `app_router.dart` عن طريق `context.read<XxxRepo>()`.

### Localization — `easy_localization`
- ملفات الترجمة: `assets/translations/en.json` + `assets/translations/ar.json`
- الاستخدام: `"key".tr()` أو `context.tr("key")`
- تغيير اللغة: `context.setLocale(Locale('ar'))`

### Navigation
- `NavigationHelper.pushNamed(...)`, `.pushNamedAndRemoveUntil(...)`, `.pop()`

---

## Commands

```bash
flutter pub get
flutter run
flutter analyze
```

> مفيش build_runner مطلوب للموديلات (كلها plain Dart). build_runner لسه موجود لأغراض تانية بس.

---

## Token-saving tips for the assistant

- متمسحش المشروع كله — الملف ده فيه الهيكل والقواعد.
- لو محتاج تعدّل feature معيّن، روح على: `data/repos/<x>_repo.dart` + `data/cubits/<x>/` + `features/<x>/ui/`.
- مفاتيح الترجمة في `core/localization/app_strings.dart`.
- الـ endpoints في `core/constants/app_endpoints.dart`.
