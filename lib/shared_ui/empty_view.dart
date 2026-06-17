import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Etat vide reutilisable : icone + titre + sous-titre + CTA optionnel.
class EmptyView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  const EmptyView({
    super.key,
    this.icon = Icons.inbox_outlined,
    required this.title,
    this.message,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: sdLightGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: sdStoneGrey),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (message != null) ...[
              const SizedBox(height: 6),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: sdTextSecondary, fontSize: 13),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 20),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
