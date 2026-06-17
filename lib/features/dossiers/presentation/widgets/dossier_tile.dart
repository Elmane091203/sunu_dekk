import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme.dart';
import '../../../../shared_ui/status_chip.dart';
import '../../domain/dossier_summary.dart';

class DossierTile extends StatelessWidget {
  final DossierSummary dossier;
  final VoidCallback onTap;
  const DossierTile({super.key, required this.dossier, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd MMM', 'fr_FR');
    final echeance = dossier.dateEcheance;
    final retard = dossier.enRetard;

    return Material(
      color: sdSurface,
      borderRadius: BorderRadius.circular(sdRadiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(sdRadiusMd),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sdRadiusMd),
            border: Border.all(color: const Color(0xFFE2E8E6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _categoryColor(
                        dossier.categorie,
                      ).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(sdRadiusSm),
                    ),
                    child: Icon(
                      _categoryIcon(dossier.categorie),
                      color: _categoryColor(dossier.categorie),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dossier.titre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: sdTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dossier.numero,
                          style: const TextStyle(
                            color: sdTextSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusChip(statut: dossier.statut, dense: true),
                ],
              ),
              const SizedBox(height: 10),
              // Wrap : evite l'overflow sur petits ecrans en passant a la ligne
              // si necessaire (citoyen long + priorite + date).
              Wrap(
                spacing: 12,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _MetaIcon(
                    icon: Icons.person_outline,
                    text: dossier.citoyenNomComplet ?? '-',
                  ),
                  PriorityChip(priorite: dossier.priorite),
                  if (echeance != null)
                    _MetaIcon(
                      icon: Icons.schedule_outlined,
                      text: df.format(echeance),
                      color: retard ? sdRed : sdTextSecondary,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String? c) {
    switch (c) {
      case 'etat_civil':
        return Icons.badge_outlined;
      case 'urbanisme':
        return Icons.map_outlined;
      case 'entreprise':
        return Icons.storefront_outlined;
      case 'citoyennete':
        return Icons.how_to_vote_outlined;
      case 'sante':
        return Icons.local_hospital_outlined;
      default:
        return Icons.folder_outlined;
    }
  }

  Color _categoryColor(String? c) {
    switch (c) {
      case 'etat_civil':
        return sdGreenBaobab;
      case 'urbanisme':
        return sdGoldTeranga;
      case 'entreprise':
        return sdGreenDigital;
      case 'citoyennete':
        return const Color(0xFF6366F1);
      case 'sante':
        return sdRed;
      default:
        return sdStoneGrey;
    }
  }
}

class _MetaIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  const _MetaIcon({required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? sdTextSecondary;
    // ConstrainedBox + Flexible interne : laisse le texte ellipser sans casser
    // le Wrap parent.
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: c),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: c),
            ),
          ),
        ],
      ),
    );
  }
}
