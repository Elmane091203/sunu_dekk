import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../models/utilisateur.dart';
import '../../../shared_ui/responsive.dart';
import '../../../shared_ui/section_card.dart';
import '../../../shared_ui/sunu_logo.dart';
import '../../auth/presentation/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull;
    final isTablet = context.isTablet;
    final padding = isTablet
        ? const EdgeInsets.symmetric(horizontal: 32, vertical: 24)
        : const EdgeInsets.all(16);

    return Scaffold(
      backgroundColor: sdScaffoldBg,
      appBar: AppBar(title: const Text('Mon profil')),
      body: ListView(
        padding: padding,
        children: [
          if (user != null) _Header(user: user),
          const SizedBox(height: 16),
          SectionCard(
            title: 'Préférences',
            child: Column(
              children: [
                _PrefRow(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications push',
                  subtitle: 'Recevoir les alertes hors-app',
                  trailing: Switch(
                    value: true,
                    onChanged: (_) {/* TODO: brancher FCM */},
                  ),
                ),
                const Divider(height: 1),
                _PrefRow(
                  icon: Icons.fingerprint,
                  title: 'Verrouillage biométrique',
                  subtitle: 'Empreinte ou Face ID au démarrage',
                  trailing: Switch(
                    value: false,
                    onChanged: (_) {/* TODO: local_auth */},
                  ),
                ),
                const Divider(height: 1),
                _PrefRow(
                  icon: Icons.language,
                  title: 'Langue',
                  subtitle: 'Français',
                  trailing: const Icon(Icons.chevron_right,
                      color: sdTextSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: 'Sécurité',
            child: Column(
              children: [
                _PrefRow(
                  icon: Icons.lock_outline,
                  title: 'Changer mon mot de passe',
                  subtitle: 'Recommandé tous les 90 jours',
                  trailing: const Icon(Icons.chevron_right,
                      color: sdTextSecondary),
                ),
                const Divider(height: 1),
                _PrefRow(
                  icon: Icons.security,
                  title: 'Vérification 2FA',
                  subtitle: user?.twoFactorEnabled == true
                      ? 'Activée'
                      : 'Désactivée',
                  trailing: Icon(
                    user?.twoFactorEnabled == true
                        ? Icons.check_circle
                        : Icons.chevron_right,
                    color: user?.twoFactorEnabled == true
                        ? sdGreenDigital
                        : sdTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: 'À propos',
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const SunuLogo(size: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'SunuDekk',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Version 0.1.0 • La performance au service du territoire.',
                              style: const TextStyle(
                                color: sdTextSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: sdRed,
                side: const BorderSide(color: sdRed, width: 1.2),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Se déconnecter'),
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).signOut();
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Utilisateur user;
  const _Header({required this.user});

  String _roleLabel(RoleUtilisateur r) {
    switch (r) {
      case RoleUtilisateur.superAdmin:
        return 'Super administrateur';
      case RoleUtilisateur.admin:
        return 'Administrateur';
      case RoleUtilisateur.agent:
        return 'Agent municipal';
      case RoleUtilisateur.citoyen:
        return 'Citoyen';
    }
  }

  @override
  Widget build(BuildContext context) {
    final initials = ('${user.prenom.isNotEmpty ? user.prenom[0] : ''}${user.nom.isNotEmpty ? user.nom[0] : ''}')
        .toUpperCase();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [sdGreenBaobab, Color(0xFF0A5740)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(sdRadiusMd),
        boxShadow: sdShadowSoft,
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${user.prenom} ${user.nom}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _roleLabel(user.role),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
                if (user.email != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    user.email!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrefRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  const _PrefRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: sdLightGrey,
              borderRadius: BorderRadius.circular(sdRadiusSm),
            ),
            child: Icon(icon, size: 18, color: sdStoneGrey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: sdTextSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
