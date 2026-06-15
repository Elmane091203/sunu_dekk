import 'package:flutter_test/flutter_test.dart';
import 'package:sunu_dekk/models/dossier.dart';

/// Test de contrat : verifie que la deserialisation d'un JSON cote backend
/// continue de fonctionner apres modification. A repliquer pour CHAQUE modele.
///
/// Le JSON fixture doit etre extrait depuis l'API Flask reelle :
/// curl http://localhost:5001/api/dossiers/1 | jq > test/fixtures/dossier.json
void main() {
  group('Dossier.fromJson', () {
    test('parse un dossier minimal', () {
      final json = {
        'id': 1,
        'numero': 'TA-2026-00001',
        'statut': 'nouveau',
        'priorite': 'normale',
        'typeDemarcheId': 5,
      };

      final dossier = Dossier.fromJson(json);

      expect(dossier.id, 1);
      expect(dossier.numero, 'TA-2026-00001');
      expect(dossier.statut, StatutDossier.nouveau);
      expect(dossier.priorite, PrioriteDossier.normale);
      expect(dossier.typeDemarcheId, 5);
    });

    test('parse un dossier complet avec citoyen et agent', () {
      final json = {
        'id': 40,
        'numero': 'TA-2026-00040',
        'statut': 'en_cours',
        'priorite': 'haute',
        'typeDemarcheId': 12,
        'citoyenId': 12,
        'agentId': 8,
        'collectiviteId': 4,
        'description': 'Demande de certificat de residence',
        'dateSoumission': '2026-05-29T17:25:31Z',
      };

      final dossier = Dossier.fromJson(json);

      expect(dossier.statut, StatutDossier.enCours);
      expect(dossier.priorite, PrioriteDossier.haute);
      expect(dossier.citoyenId, 12);
      expect(dossier.dateSoumission, isNotNull);
    });
  });
}
