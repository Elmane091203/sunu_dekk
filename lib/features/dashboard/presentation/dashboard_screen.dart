import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../shared_ui/empty_view.dart';
import '../../../shared_ui/responsive.dart';
import '../../../shared_ui/section_card.dart';
import '../../../shared_ui/sunu_logo.dart';
import '../../notifications/presentation/notifications_controller.dart';
import '../domain/dashboard_stats.dart';
import 'dashboard_controller.dart';
import 'widgets/kpi_card.dart';
import 'widgets/volume_chart.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final isTablet = context.isTablet;

    return Scaffold(
      backgroundColor: sdScaffoldBg,
      appBar: AppBar(
        toolbarHeight: 64,
        titleSpacing: 12,
        // On retire le sous-texte "Bonjour {prenom}" en haut : il fait doublon
        // avec le profil et provoque des overflows sur 360dp + 3 actions.
        // Le prenom reste dans le PopupMenu profil.
        title: Row(
          children: [
            const SunuLogoWordmark(logoSize: 100, version: SunuLogoVersion.logo1, showTagline: false),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Centre de commandement',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        actions: [
          Consumer(
            builder: (_, ref, _) {
              final unread = ref.watch(unreadCountProvider);
              final btn = IconButton(
                tooltip: 'Notifications',
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => context.go(AppRoute.notifications),
              );
              return unread > 0
                  ? Badge.count(
                      count: unread,
                      backgroundColor: sdRed,
                      textColor: Colors.white,
                      offset: const Offset(-4, 4),
                      child: btn,
                    )
                  : btn;
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(dashboardStatsProvider),
        child: statsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => EmptyView(
            icon: Icons.cloud_off_outlined,
            title: 'Données indisponibles',
            message: e.toString(),
            action: FilledButton.icon(
              onPressed: () => ref.invalidate(dashboardStatsProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ),
          data: (stats) => _DashboardBody(stats: stats, twoCols: isTablet),
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final DashboardStats stats;
  final bool twoCols;
  const _DashboardBody({required this.stats, required this.twoCols});

  @override
  Widget build(BuildContext context) {
    final padding = twoCols
        ? const EdgeInsets.symmetric(horizontal: 32, vertical: 24)
        : const EdgeInsets.all(16);

    final kpiGrid = _KpiGrid(stats: stats, crossAxisCount: twoCols ? 4 : 2);

    final volumeCard = SectionCard(
      title: 'Volume - 7 derniers jours',
      subtitle: 'Évolution des dépôts de dossiers',
      child: VolumeChart(data: stats.volume7Jours),
    );

    final perfCard = SectionCard(
      title: 'Performance',
      child: _Performance(stats: stats),
    );

    final catCard = SectionCard(
      title: 'Top catégories',
      subtitle: 'Répartition par type de démarche',
      child: _Categories(items: stats.parCategorie),
    );

    return ListView(
      padding: padding,
      children: [
        kpiGrid,
        const SizedBox(height: 16),
        const _QuickActions(),
        const SizedBox(height: 16),
        if (twoCols)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: volumeCard),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: perfCard),
            ],
          )
        else ...[
          volumeCard,
          const SizedBox(height: 16),
          perfCard,
        ],
        const SizedBox(height: 16),
        catCard,
        const SizedBox(height: 24),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.folder_outlined, 'Dossiers', sdGreenBaobab, AppRoute.dossiers),
      (Icons.groups_outlined, 'Équipe', sdGreenDigital, AppRoute.team),
      (
        Icons.assignment_outlined,
        'Démarches',
        sdGoldTeranga,
        AppRoute.demarches,
      ),
    ];
    return Row(
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          Expanded(
            child: _QuickAction(
              icon: actions[i].$1,
              label: actions[i].$2,
              color: actions[i].$3,
              onTap: () => context.go(actions[i].$4),
            ),
          ),
          if (i < actions.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: sdSurface,
      borderRadius: BorderRadius.circular(sdRadiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(sdRadiusMd),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8E6)),
            borderRadius: BorderRadius.circular(sdRadiusMd),
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(sdRadiusSm),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  final DashboardStats stats;
  final int crossAxisCount;
  const _KpiGrid({required this.stats, required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    final cards = [
      KpiCard(
        label: 'Total dossiers',
        value: '${stats.total}',
        icon: Icons.folder_copy_outlined,
        color: sdGreenBaobab,
      ),
      KpiCard(
        label: 'En cours',
        value: '${stats.enCours}',
        icon: Icons.pending_actions_outlined,
        color: sdGoldTeranga,
      ),
      KpiCard(
        label: 'Clôturés',
        value: '${stats.clotures}',
        icon: Icons.check_circle_outline,
        color: sdGreenDigital,
      ),
      KpiCard(
        label: 'En retard',
        value: '${stats.enRetard}',
        icon: Icons.warning_amber_outlined,
        color: sdRed,
      ),
    ];

    // Auto-extent : chaque carte ~190px de large minimum. Empeche le cramped
    // sur tablette etroite (600px = 3 cols), garde 2 cols sur mobile.
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisExtent: 148,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: cards.length,
      itemBuilder: (_, i) => cards[i],
    );
  }
}

class _Categories extends StatelessWidget {
  final List<CategorieCount> items;
  const _Categories({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Aucune catégorie sur la période',
          style: TextStyle(color: sdTextSecondary),
        ),
      );
    }
    final top = [...items]..sort((a, b) => b.count.compareTo(a.count));
    final max = top.first.count.clamp(1, 1 << 30);
    return Column(
      children: top.take(5).map((c) {
        final pct = c.count / max;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _humanize(c.categorie),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${c.count}',
                    style: const TextStyle(
                      color: sdTextSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 8,
                  backgroundColor: sdLightGrey,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    sdGreenDigital,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _humanize(String raw) => raw
      .replaceAll('_', ' ')
      .split(' ')
      .map((s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}')
      .join(' ');
}

class _Performance extends StatelessWidget {
  final DashboardStats stats;
  const _Performance({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _PerfTile(
                label: 'Délai moyen',
                value: '${stats.delaiMoyenJours.toStringAsFixed(1)} j',
                icon: Icons.timer_outlined,
                color: sdGreenBaobab,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PerfTile(
                label: 'Satisfaction',
                value: stats.satisfactionMoyenne > 0
                    ? '${stats.satisfactionMoyenne.toStringAsFixed(1)} / 5'
                    : '-',
                icon: Icons.sentiment_satisfied_outlined,
                color: sdGoldTeranga,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PerfTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _PerfTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: sdScaffoldBg,
        borderRadius: BorderRadius.circular(sdRadiusSm),
        border: Border.all(color: const Color(0xFFE2E8E6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: sdTextSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
