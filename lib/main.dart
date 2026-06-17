import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charge les symboles fr_FR : DateFormat('dd MMM', 'fr_FR') sinon plante.
  await initializeDateFormatting('fr_FR', null);

  // Firebase - guarde : si google-services.json / GoogleService-Info.plist sont
  // absents (build dev sans config), on log et on continue sans push. Cela
  // permet de demarrer l'app meme sans Firebase prepare cote natif.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('[main] Firebase.initializeApp() failed: $e - push desactive');
  }

  runApp(const ProviderScope(child: SunuDekkApp()));
}
