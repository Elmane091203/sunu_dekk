# Architecture technique - Sunu Dekk

> Ce document est la **référence unique** pour les choix d'architecture du projet. Toute déviation doit être discutée en équipe et reportée ici.

---

## 1. Principes directeurs

1. **Indépendance totale** vis-à-vis de l'app citoyen Flutter (`demarche_admin_flutter`). Pas de package partagé, pas d'import croisé. La duplication est assumée et compensée par les tests de contrat (§7).
2. **Organisation par feature**, pas par couche. Une feature = un dossier `lib/features/<nom>/` qui contient *tout* ce qui la concerne (data, domain, presentation). Les développeurs peuvent travailler en parallèle sans conflits Git.
3. **Clean architecture allégée** dans chaque feature : 3 couches (data, domain, presentation), dépendances unidirectionnelles `presentation → domain ← data`.
4. **State management Riverpod** partout. Pas de Provider classique, pas de setState pour de l'état partagé.
5. **Failure-based error handling**. Les widgets ne catchent jamais `Exception` ou `DioException`. La couche `data/` convertit toujours en `Failure` (voir `lib/core/network/failure.dart`).

---

## 2. Structure du projet

```
sunu_dekk/
├── pubspec.yaml
├── analysis_options.yaml             # règles lint + Riverpod lint
├── README.md
├── ARCHITECTURE.md                   # ← ce fichier
├── lib/
│   ├── main.dart                     # entry point, lance SunuDekkApp
│   ├── app/                          # bootstrap & config globale
│   │   ├── app.dart                  # MaterialApp.router + ProviderScope
│   │   ├── router.dart               # go_router : toutes les routes
│   │   ├── theme.dart                # thème Material 3
│   │   └── constants.dart            # API URL, clés storage
│   ├── core/                         # infrastructure réutilisable
│   │   ├── network/
│   │   │   ├── api_client.dart       # provider Dio + helper mapDioToFailure
│   │   │   ├── failure.dart          # hiérarchie d'erreurs
│   │   │   └── interceptors/
│   │   │       └── auth_interceptor.dart  # injecte JWT, gère 401
│   │   ├── storage/
│   │   │   └── secure_token_storage.dart  # FlutterSecureStorage wrapper
│   │   └── database/
│   │       └── local_database.dart   # SQLite, schéma pending_actions
│   ├── models/                       # entités métier (freezed)
│   │   ├── dossier.dart
│   │   ├── utilisateur.dart
│   │   ├── collectivite.dart
│   │   └── type_demarche.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── auth_remote_data_source.dart   # appels HTTP bruts
│   │   │   │   └── auth_repository_impl.dart      # implémente AuthRepository
│   │   │   ├── domain/
│   │   │   │   └── auth_repository.dart           # interface abstraite
│   │   │   └── presentation/
│   │   │       ├── auth_controller.dart           # AsyncNotifier Riverpod
│   │   │       └── login_screen.dart              # UI
│   │   ├── dashboard/
│   │   │   └── presentation/
│   │   │       ├── dashboard_screen.dart
│   │   │       └── widgets/
│   │   ├── dossiers/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       └── dossier_list_screen.dart
│   │   └── notifications/
│   │       ├── data/
│   │       └── presentation/
│   │           └── notifications_screen.dart
│   └── shared_ui/                    # widgets réutilisables
│       ├── loading_view.dart
│       └── error_view.dart
└── test/
    └── models/
        └── dossier_test.dart         # test de contrat (voir §7)
```

---

## 3. Découpage en couches (par feature)

```
┌──────────────────────────────────────────────────┐
│  presentation/                                   │
│  - Widgets (Screen, Widget personnalisé)         │
│  - Controllers Riverpod (AsyncNotifier)          │
│  ⇡ ne dépend QUE de domain/                      │
└──────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────┐
│  domain/                                         │
│  - Interfaces (abstract class Repository)        │
│  - Use cases si nécessaire                       │
│  ⇡ AUCUNE dépendance (pas dio, pas flutter)      │
└──────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────┐
│  data/                                           │
│  - DataSources (HTTP, SQLite)                    │
│  - Repository implementations                    │
│  ⇡ implémente domain/, parle aux APIs            │
└──────────────────────────────────────────────────┘
```

**Règle clé** : si tu importes `package:dio` ou `package:flutter` depuis `domain/`, **c'est faux**. Le `domain/` doit être testable sans Flutter ni réseau.

---

## 4. Conventions de code

### Nommage
- Fichiers : `snake_case.dart`
- Classes : `PascalCase`
- Constantes, paramètres, variables locales : `camelCase`
- Routes : préfixées par `/` (`/login`, `/dashboard`), définies en `AppRoute.X` dans `lib/app/router.dart`

### Providers Riverpod
- Repositories : `<nom>RepositoryProvider`
- Controllers (AsyncNotifier) : `<nom>ControllerProvider`
- Données réactives : `<nom>Provider`

### Imports
- Toujours en relatif (`../../core/...`), jamais en `package:sunu_dekk/...` à l'intérieur du projet.
- Imports `dart:`, `package:`, relatifs : un saut de ligne entre chaque groupe.

### Erreurs
- **Jamais** `try/catch (e)` brut dans un widget. Utiliser `AsyncValue.when` ou `AsyncValue.guard`.
- Dans `data/`, toujours convertir `DioException` → `Failure` via `mapDioToFailure(e)`.

### Async
- Privilégier `async/await` à `.then()`.
- Pas de `Future<void>` ignoré (`unawaited(...)` si vraiment nécessaire).

---

## 5. Comment ajouter une feature

Exemple : tu veux ajouter une feature `stats/`.

1. Créer l'arbo :
   ```
   lib/features/stats/
   ├── data/
   │   ├── stats_remote_data_source.dart
   │   └── stats_repository_impl.dart
   ├── domain/
   │   └── stats_repository.dart
   └── presentation/
       ├── stats_controller.dart
       └── stats_screen.dart
   ```
2. Définir l'**interface** `StatsRepository` dans `domain/`.
3. Implémenter `StatsRemoteDataSource` (appels HTTP via `apiClientProvider`).
4. Implémenter `StatsRepositoryImpl` qui `implements StatsRepository`, et exposer un `statsRepositoryProvider` Riverpod.
5. Créer `StatsController extends AsyncNotifier<StatsData>` dans `presentation/`.
6. Créer `StatsScreen extends ConsumerWidget` qui écoute `statsControllerProvider`.
7. Ajouter la route dans `lib/app/router.dart` :
   ```dart
   GoRoute(path: AppRoute.stats, builder: (_, __) => const StatsScreen())
   ```
8. **Ne pas oublier** un test dans `test/features/stats/` si la logique est non triviale.

---

## 6. Comment ajouter un modèle

Exemple : nouveau modèle `Document`.

1. Créer `lib/models/document.dart` avec freezed :
   ```dart
   import 'package:freezed_annotation/freezed_annotation.dart';
   part 'document.freezed.dart';
   part 'document.g.dart';

   @freezed
   class Document with _$Document {
     const factory Document({
       required int id,
       required String nom,
       required int dossierId,
       @Default(false) bool valide,
     }) = _Document;

     factory Document.fromJson(Map<String, dynamic> json) =>
         _$DocumentFromJson(json);
   }
   ```
2. Lancer la génération de code :
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
3. **Obligatoire** : créer `test/models/document_test.dart` (voir §7).

---

## 7. Tests de contrat (anti-dérive backend)

Le projet n'utilise pas de génération OpenAPI. Pour éviter que les modèles Dart divergent silencieusement du schéma Flask, **chaque modèle DOIT avoir un test de désérialisation** alimenté par un JSON réel extrait du backend.

### Procédure pour récupérer une fixture

```bash
# Récupérer un dossier réel depuis le backend en local
curl -H "Authorization: Bearer $TOKEN" \
     http://localhost:5001/api/dossiers/1 \
     | jq > test/fixtures/dossier_sample.json
```

### Structure du test

Voir `test/models/dossier_test.dart` comme template. Au minimum :
- 1 test avec les champs **obligatoires uniquement** (vérifie qu'aucun champ requis n'a été ajouté côté backend sans synchro).
- 1 test avec un payload **complet réel** (vérifie que les champs optionnels et les enums se désérialisent correctement).

Quand un test casse, ça veut dire que le contrat backend a évolué → mettre à jour le modèle Dart **et** le modèle côté `demarche_admin_flutter` (citoyen) pour rester cohérent.

---

## 8. Flux d'authentification

```
LoginScreen
  ↓ user tape email/password, appuie Connecter
authControllerProvider.signIn(email, password)
  ↓
AuthRepositoryImpl.login(...)
  ↓ POST /api/auth/login
AuthRemoteDataSource → dio (avec AuthInterceptor)
  ↓ 200 { access_token, refresh_token, user }
SecureTokenStorage.save(access, refresh)   ← persistence JWT
  ↓
authControllerProvider state = AsyncData(Utilisateur)
  ↓ écouté par le router
go_router redirect : / → /dashboard
```

**2FA** : si la réponse `/api/auth/login` renvoie `{requires_2fa: true}` au lieu des tokens, `LoginScreen` doit afficher un champ supplémentaire et rappeler `signIn(..., twoFactorCode: ...)`.

---

## 9. Roadmap features signature (V1)

| # | Feature | Owner | Priorité | Status |
|---|---|---|---|---|
| 1 | auth (login email/password + 2FA) | Dev A | P0 | squelette |
| 2 | dashboard (KPI + graph fl_chart) | Dev A | P1 | squelette |
| 3 | dossiers (liste + swipe-validation) | Dev B | P0 | squelette |
| 4 | notifications (FCM + WebSocket) | Dev B | P1 | squelette |

**V2** (post-démo) : scan documents (image_picker), signature électronique (signature pad), géolocalisation terrain, mode hors-ligne complet.

---

## 10. Décisions ouvertes

À trancher dès le sprint 1 :

- [ ] Mode sombre nécessaire ? (toggle `theme.dart` ou support système ?)
- [ ] Internationalisation : seulement français pour V1, ou français + wolof ?
- [ ] Stratégie de refresh token : interceptor automatique ou redirect vers login ?
- [ ] Tests E2E : on commence avec `integration_test` ou juste tests unitaires ?
