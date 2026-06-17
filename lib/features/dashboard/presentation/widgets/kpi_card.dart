import 'package:flutter/material.dart';

import '../../../../app/theme.dart';

/// Carte KPI : icone teintee + chiffre + libelle.
/// Layout : icone en haut, valeur+label remontes vers le centre via Spacer.
/// Toutes les hauteurs sont fluides pour eviter les overflows de 1px sur
/// petits ecrans / text scaling > 1.0.
class KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? hint;

  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: sdSurface,
        borderRadius: BorderRadius.circular(sdRadiusMd),
        border: Border.all(color: const Color(0xFFE2E8E6)),
        boxShadow: sdShadowSubtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(sdRadiusSm),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          // FittedBox protege la valeur du text scaling agressif.
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: sdTextPrimary,
                height: 1.0,
              ),
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: sdTextSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
