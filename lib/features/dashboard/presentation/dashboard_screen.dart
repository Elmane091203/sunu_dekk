import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// SQUELETTE — Dashboard administrateur.
/// A implementer :
/// - 4 KPI cards (dossiers en cours, valides, en retard, total)
/// - Graphique dossiers/jour sur 30j (fl_chart : LineChart)
/// - Top 5 categories de demarches
/// - Endpoint a appeler : GET /api/stats (deja expose par Flask)
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tableau de bord')),
      body: const Center(
        child: Text('TODO: dashboard'),
      ),
    );
  }
}
