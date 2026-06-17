import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Carte de section reutilisable : titre + action a droite + contenu.
/// Style "centre de commandement" : fond blanc, contour fin, ombre tres legere.
class SectionCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const SectionCard({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: sdSurface,
        borderRadius: BorderRadius.circular(sdRadiusMd),
        border: Border.all(color: const Color(0xFFE2E8E6)),
        boxShadow: sdShadowSubtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: sdTextSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          if (title != null) const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
