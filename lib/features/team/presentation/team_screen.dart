import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../shared_ui/empty_view.dart';
import '../../../shared_ui/responsive.dart';
import '../../../shared_ui/section_card.dart';
import '../data/team_repository.dart';
import '../domain/agent.dart';
import 'widgets/agent_avatar.dart';
import 'widgets/create_agent_sheet.dart';

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agents = ref.watch(agentListProvider);
    final perf = ref.watch(agentPerformanceProvider);
    final isTablet = context.isTablet;

    return Scaffold(
      backgroundColor: sdScaffoldBg,
      appBar: AppBar(
        title: const Text('Équipe municipale'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(agentListProvider);
              ref.invalidate(agentPerformanceProvider);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final ok = await CreateAgentSheet.show(context);
          if (ok == true) {
            ref.invalidate(agentListProvider);
            ref.invalidate(agentPerformanceProvider);
          }
        },
        backgroundColor: sdGreenBaobab,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Ajouter'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(agentListProvider);
          ref.invalidate(agentPerformanceProvider);
        },
        child: agents.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => EmptyView(
            icon: Icons.cloud_off_outlined,
            title: 'Impossible de charger l\'équipe',
            message: e.toString(),
            action: FilledButton.icon(
              onPressed: () => ref.invalidate(agentListProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ),
          data: (list) {
            if (list.isEmpty) {
              return const EmptyView(
                icon: Icons.groups_outlined,
                title: 'Aucun agent',
                message: 'Ajoutez votre premier collaborateur municipal.',
              );
            }
            return _Body(
              agents: list,
              perfAsync: perf,
              twoCols: isTablet,
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final List<Agent> agents;
  final AsyncValue<List<AgentPerformance>> perfAsync;
  final bool twoCols;
  const _Body({
    required this.agents,
    required this.perfAsync,
    required this.twoCols,
  });

  @override
  Widget build(BuildContext context) {
    final actifs = agents.where((a) => a.actif).length;
    final inactifs = agents.length - actifs;
    final padding = twoCols
        ? const EdgeInsets.symmetric(horizontal: 32, vertical: 24)
        : const EdgeInsets.all(16);

    return ListView(
      padding: padding,
      children: [
        _Summary(total: agents.length, actifs: actifs, inactifs: inactifs),
        const SizedBox(height: 16),
        perfAsync.maybeWhen(
          data: (perfs) => SectionCard(
            title: 'Top performance',
            subtitle: 'Taux de clôture sur dossiers assignés',
            child: _PerformanceList(perfs: perfs),
          ),
          orElse: () => const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Collaborateurs (${agents.length})',
          child: Column(
            children: [
              for (var i = 0; i < agents.length; i++) ...[
                _AgentTile(agent: agents[i]),
                if (i < agents.length - 1)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Divider(height: 1),
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  final int total;
  final int actifs;
  final int inactifs;
  const _Summary({
    required this.total,
    required this.actifs,
    required this.inactifs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatBox(label: 'Total', value: total, color: sdGreenBaobab, icon: Icons.groups_outlined)),
        const SizedBox(width: 12),
        Expanded(child: _StatBox(label: 'Actifs', value: actifs, color: sdGreenDigital, icon: Icons.check_circle_outline)),
        const SizedBox(width: 12),
        Expanded(child: _StatBox(label: 'Bloqués', value: inactifs, color: sdRed, icon: Icons.block_outlined)),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;
  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
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
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: sdTextSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceList extends StatelessWidget {
  final List<AgentPerformance> perfs;
  const _PerformanceList({required this.perfs});

  @override
  Widget build(BuildContext context) {
    if (perfs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Aucune donnée de performance',
          style: TextStyle(color: sdTextSecondary),
        ),
      );
    }
    final sorted = [...perfs]
      ..sort((a, b) => b.tauxCompletion.compareTo(a.tauxCompletion));
    return Column(
      children: [
        for (final p in sorted.take(5))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                AgentAvatar(agent: p.agent, size: 36),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.agent.nomComplet,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (p.tauxCompletion / 100).clamp(0.0, 1.0),
                          minHeight: 6,
                          backgroundColor: sdLightGrey,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            p.tauxCompletion >= 75
                                ? sdGreenDigital
                                : p.tauxCompletion >= 50
                                    ? sdGoldTeranga
                                    : sdRed,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${p.totalClos} / ${p.totalAssignes} clos • ${p.enRetard} en retard',
                        style: const TextStyle(
                          color: sdTextSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${p.tauxCompletion.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: sdGreenBaobab,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _AgentTile extends StatelessWidget {
  final Agent agent;
  const _AgentTile({required this.agent});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('${AppRoute.team}/${agent.id}'),
      borderRadius: BorderRadius.circular(sdRadiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            AgentAvatar(agent: agent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agent.nomComplet,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    agent.role == 'admin'
                        ? 'Administrateur'
                        : (agent.email ?? agent.telephone ?? 'Agent'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: sdTextSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: sdTextSecondary),
          ],
        ),
      ),
    );
  }
}
