# Sunu Dekk

**Sunu Dekk** ("notre cité" en wolof) est l'application mobile destinée aux **administrateurs** et **agents** des collectivités territoriales sénégalaises pour gérer et suivre les démarches administratives en mobilité.

Elle se connecte à la même API Flask que le tableau de bord web Angular (`demarche_admin_angular`), et est **totalement indépendante** de l'app citoyen Flutter (`demarche_admin_flutter`).

---

## 🎯 Pourquoi une app mobile en plus du web ?

Le mobile n'est pas un clone du dashboard Angular. Il existe pour les cas d'usage qui n'ont aucun sens sur PC :

| Feature mobile | Pourquoi le web ne suffit pas |
|---|---|
| **Notifications push** (FCM) | L'admin n'est pas devant son PC 24/7 |
| **Swipe-validation** des dossiers | Geste 1-tap, plus rapide qu'un clic |
| **Scan documents** (caméra + OCR) | Pas de scanner sur PC en mobilité |
| **Signature électronique** au doigt | Impossible sur PC sans tablette |
| **Mode hors-ligne** avec sync différée | Connexion 4G capricieuse en région |

Le dashboard Angular reste le « cockpit complet » (analytics, gestion utilisateurs, config workflows). Sunu Dekk = **compagnon de terrain**.

---

## 🚀 Démarrage rapide

### Prérequis

- Flutter **3.44+** (`flutter --version`)
- Android Studio + émulateur Android, OU appareil physique
- Le backend Flask **doit tourner** sur `http://localhost:5001` (voir `demarche_admin.fask/README.md`)

### Installation

```bash
cd sunu_dekk
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

> ⚠️ La 2e commande génère les fichiers `*.freezed.dart` et `*.g.dart` pour les modèles. À relancer après toute modification de `lib/models/*.dart`.

### Variables d'environnement

Toutes les variables d'env de l'app sont passées en **compile-time** via `String.fromEnvironment` (voir `lib/app/constants.dart`). On utilise le mécanisme natif Flutter `--dart-define-from-file` (pas de package `dotenv`, pas d'IO au boot).

```bash
# 1. Copier le template versionné vers ton .env.json local (gitignoré)
cp .env.example.json .env.json
# 2. Adapter API_BASE_URL selon ta cible (émulateur / device / prod)
```

| Cible | Valeur à mettre dans `.env.json` |
|---|---|
| Émulateur Android | `http://10.0.2.2:5001/api` (défaut) |
| iOS simulator / web | `http://localhost:5001/api` |
| Device physique (même Wi-Fi) | `http://192.168.x.x:5001/api` |
| Prod | `https://sunudekk-api.djazael.com/api` |

Pour un build prod, créer un `.env.prod.json` (également gitignoré via le pattern `.env.*.json`).

### Lancement

```bash
flutter run --dart-define-from-file=.env.json

# Build APK prod
flutter build apk --release --dart-define-from-file=.env.prod.json
```

Sous VS Code, les profils sont câblés dans `.vscode/launch.json` (Run → "Sunu Dekk (dev, .env.json)").

### Tests

```bash
flutter test                    # tous les tests
flutter test test/models        # uniquement les tests de contrat
```

---

## 👥 Équipe & répartition

Projet à 2 développeurs. Pour travailler en parallèle sans conflits Git, chacun prend des **features distinctes** (pas des fichiers distincts dans la même feature). La structure `lib/features/<nom>/` isole le code par périmètre métier.

| Dev | Features suggérées |
|---|---|
| Dev A | `auth`, `dashboard` |
| Dev B | `dossiers`, `notifications` |

`lib/core/`, `lib/models/`, `lib/app/` sont **partagés** : tout changement doit être discuté.

---

## 📐 Architecture & conventions

Voir **[ARCHITECTURE.md](ARCHITECTURE.md)** pour le détail (couches, packages, comment ajouter une feature, comment ajouter un modèle).

---

## 🔗 Liens utiles

- Backend Flask : `../demarche_admin.fask/`
- Comptes démo : `superadmin@terreadmin.sn` / `Admin@2026!`
- Swagger : http://localhost:5001/api/swagger

---

## 📦 Stack

| Couche | Choix | Justification |
|---|---|---|
| State management | **Riverpod 2.x** | Async-friendly, compile-time safe, AutoDispose |
| Navigation | **go_router** | Déclarative, deep-links natifs pour FCM |
| HTTP | **dio** | Intercepteurs (JWT auto), retry, multipart upload |
| Modèles | **freezed + json_serializable** | Immuables + sérialisation auto |
| Stockage sécurisé | **flutter_secure_storage** | Keychain iOS / Keystore Android pour le JWT |
| Cache local | **sqflite** | Mode hors-ligne, file d'attente de sync |
| Graphes | **fl_chart** | Dashboards KPI |
| Push | **firebase_messaging** | Notifications hors-app |
| Signature | **signature** | Pad de signature au doigt |
| Photo / scan | **image_picker** | Camera + galerie |
