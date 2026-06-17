import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Couleurs/labels associes aux statuts de dossier remontes par l'API.
/// Strings parce que le backend evolue et qu'on accepte aussi les nouveaux
/// statuts (doc_requis, en_validation) que le modele freezed du repo ne porte
/// pas encore.
class StatusChip extends StatelessWidget {
  final String statut;
  final bool dense;
  const StatusChip({super.key, required this.statut, this.dense = false});

  @override
  Widget build(BuildContext context) {
    final spec = _specFor(statut);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 10,
        vertical: dense ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: spec.bg,
        borderRadius: BorderRadius.circular(sdRadiusSm),
        border: Border.all(color: spec.fg.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: spec.fg,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: dense ? 6 : 8),
          Text(
            spec.label,
            style: TextStyle(
              color: spec.fg,
              fontSize: dense ? 11 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _ChipSpec _specFor(String s) {
    switch (s) {
      case 'nouveau':
        return _ChipSpec('Nouveau', sdGreenDigital, const Color(0xFFDFF6EA));
      case 'en_cours':
        return _ChipSpec('En cours', sdGoldTeranga, const Color(0xFFFFEFC2));
      case 'doc_requis':
        return _ChipSpec('Doc. requis', sdStoneGrey, sdLightGrey);
      case 'en_validation':
        return _ChipSpec('Validation', sdGreenBaobab, const Color(0xFFD5EDE2));
      case 'en_attente':
        return _ChipSpec('En attente', sdStoneGrey, sdLightGrey);
      case 'valide':
      case 'cloture':
        return _ChipSpec(
          s == 'valide' ? 'Validé' : 'Clôturé',
          sdGreenBaobab,
          const Color(0xFFD5EDE2),
        );
      case 'rejete':
        return _ChipSpec('Rejeté', sdRed, const Color(0xFFFADADA));
      default:
        return _ChipSpec(s, sdStoneGrey, sdLightGrey);
    }
  }
}

class _ChipSpec {
  final String label;
  final Color fg;
  final Color bg;
  _ChipSpec(this.label, this.fg, this.bg);
}

/// Chip de priorite.
class PriorityChip extends StatelessWidget {
  final String priorite;
  const PriorityChip({super.key, required this.priorite});

  @override
  Widget build(BuildContext context) {
    final (label, fg) = switch (priorite) {
      'urgente' || 'critique' => ('Urgente', sdRed),
      'haute' => ('Haute', sdGoldTeranga),
      'normale' => ('Normale', sdStoneGrey),
      'basse' => ('Basse', sdStoneGrey),
      _ => (priorite, sdStoneGrey),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.flag_outlined, size: 14, color: fg),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: fg,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
