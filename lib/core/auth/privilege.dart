/// Catalogue ferme des privileges metier, miroir exact du backend
/// (`app/models/base.py::Privilege`). Toute modification ici doit etre
/// synchronisee avec le catalogue Flask, sinon `Privilege.fromCode` lira
/// une valeur inconnue et la traitera comme un refus.
///
/// Reference: route GET /api/roles/privileges.
enum Privilege {
  gererDossiers('gerer_dossiers'),
  validerDocuments('valider_documents'),
  changerStatut('changer_statut'),
  gererUtilisateurs('gerer_utilisateurs'),
  voirStats('voir_stats'),
  gererProcedures('gerer_procedures'),
  assignerDossiers('assigner_dossiers'),
  envoyerMessages('envoyer_messages');

  const Privilege(this.code);

  /// Code transmis par le backend dans `utilisateur.privileges`.
  final String code;

  static Privilege? fromCode(String code) {
    for (final p in Privilege.values) {
      if (p.code == code) return p;
    }
    return null;
  }

  static Set<Privilege> parseAll(Iterable<dynamic>? raw) {
    if (raw == null) return const <Privilege>{};
    final out = <Privilege>{};
    for (final item in raw) {
      if (item is String) {
        final p = fromCode(item);
        if (p != null) out.add(p);
      }
    }
    return out;
  }
}
