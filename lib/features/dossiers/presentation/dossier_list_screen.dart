import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// SQUELETTE — Liste des dossiers a traiter pour l'admin/agent connecte.
/// Features signature a implementer :
/// - Liste paginee (GET /api/dossiers?page=N&statut=...)
/// - Swipe pour valider/rejeter (Dismissible)
/// - Filtres : statut, priorite, type de demarche
/// - Vue detail au tap (cf. dossier_detail_screen.dart a creer)
/// - Mode hors-ligne : afficher cache + drapeau "pending sync"
class DossierListScreen extends ConsumerWidget {
  const DossierListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dossiers')),
      body: const Center(child: Text('TODO: liste + swipe validation')),
    );
  }
}
