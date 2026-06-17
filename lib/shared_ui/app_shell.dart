import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app/router.dart';
import '../app/theme.dart';
import '../core/auth/permission_service.dart';
import '../core/auth/privilege.dart';
import 'responsive.dart';
import 'sunu_logo.dart';

/// Shell de navigation : NavigationBar en mobile, NavigationRail en tablette/desktop.
/// Le current index est derive de la route active (la source de verite reste l'URL).
class AppShell extends ConsumerWidget {
  final Widget child;
  final String location;
  const AppShell({super.key, required this.child, required this.location});

  static const _allDestinations = <_NavDest>[
    _NavDest(
      route: AppRoute.dashboard,
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Accueil',
    ),
    _NavDest(
      route: AppRoute.dossiers,
      icon: Icons.folder_outlined,
      selectedIcon: Icons.folder,
      label: 'Dossiers',
      required: Privilege.gererDossiers,
    ),
    _NavDest(
      route: AppRoute.team,
      icon: Icons.groups_outlined,
      selectedIcon: Icons.groups,
      label: 'Équipe',
      required: Privilege.gererUtilisateurs,
    ),
    _NavDest(
      route: AppRoute.demarches,
      icon: Icons.assignment_outlined,
      selectedIcon: Icons.assignment,
      label: 'Démarches',
    ),
    _NavDest(
      route: AppRoute.profile,
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Profil',
    ),
  ];

  int _indexFor(String loc, List<_NavDest> destinations) {
    for (var i = 0; i < destinations.length; i++) {
      if (loc.startsWith(destinations[i].route)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perms = ref.watch(permissionServiceProvider);
    // Une destination protegee disparait completement si le privilege manque.
    // L'AGENT ne voit jamais ce qu'il ne peut pas faire.
    final destinations = [
      for (final d in _allDestinations)
        if (d.required == null || perms.has(d.required!)) d,
    ];
    final idx = _indexFor(location, destinations);
    final isTablet = context.isTablet;

    if (!isTablet) {
      return Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: idx,
          onDestinationSelected: (i) => context.go(destinations[i].route),
          destinations: [
            for (final d in destinations)
              NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon),
                label: d.label,
              ),
          ],
        ),
      );
    }

    // Tablette / desktop : rail a gauche + contenu a droite.
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            _SideRail(
              destinations: destinations,
              selectedIndex: idx,
              onSelected: (i) => context.go(destinations[i].route),
              expanded: context.isDesktop,
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _SideRail extends StatelessWidget {
  final List<_NavDest> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool expanded;
  const _SideRail({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    required this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: expanded ? 240 : 88,
      color: sdSurface,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: expanded ? 16 : 16),
            child: expanded
                ? const SunuLogoWordmark(logoSize: 40, showTagline: false)
                : const SunuLogo(size: 40),
          ),
          const SizedBox(height: 24),
          for (var i = 0; i < destinations.length; i++)
            _RailItem(
              destination: destinations[i],
              selected: i == selectedIndex,
              expanded: expanded,
              onTap: () => onSelected(i),
            ),
        ],
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  final _NavDest destination;
  final bool selected;
  final bool expanded;
  final VoidCallback onTap;
  const _RailItem({
    required this.destination,
    required this.selected,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(sdRadiusSm),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: expanded ? 12 : 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFD5EDE2) : null,
            borderRadius: BorderRadius.circular(sdRadiusSm),
          ),
          child: Row(
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            children: [
              Icon(
                selected ? destination.selectedIcon : destination.icon,
                color: selected ? sdGreenBaobab : sdTextSecondary,
                size: 22,
              ),
              if (expanded) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    destination.label,
                    style: TextStyle(
                      color: selected ? sdGreenBaobab : sdTextSecondary,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NavDest {
  final String route;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final Privilege? required;
  const _NavDest({
    required this.route,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.required,
  });
}
