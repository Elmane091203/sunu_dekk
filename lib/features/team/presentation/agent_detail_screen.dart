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

class AgentDetailScreen extends ConsumerWidget {
  final int agentId;
  const AgentDetailScreen({super.key, required this.agentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(agentDetailProvider(agentId));
    final perfsAsync = ref.watch(agentPerformanceProvider);
    final isTablet = context.isTablet;

    return Scaffold(
      backgroundColor: sdScaffoldBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoute.team),
        ),
        title: const Text('Fiche collaborateur'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EmptyView(
          icon: Icons.cloud_off_outlined,
          title: 'Impossible de charger la fiche',
          message: e.toString(),
        ),
        data: (agent) {
          final perf = perfsAsync.maybeWhen(
            data: (perfs) {
              try {
                return perfs.firstWhere((p) => p.agent.id == agent.id);
              } catch (_) {
                return null;
              }
            },
            orElse: () => null,
          );
          return _Body(agent: agent, perf: perf, twoCols: isTablet, ref: ref);
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final Agent agent;
  final AgentPerformance? perf;
  final bool twoCols;
  final WidgetRef ref;
  const _Body({
    required this.agent,
    required this.perf,
    required this.twoCols,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final padding = twoCols
        ? const EdgeInsets.symmetric(horizontal: 32, vertical: 24)
        : const EdgeInsets.all(16);

    final header = _Header(agent: agent);
    final infos = SectionCard(
      title: 'Coordonnées',
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.mail_outline,
            label: 'Email',
            value: agent.email ?? '-',
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Téléphone',
            value: agent.telephone ?? '-',
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.schedule_outlined,
            label: 'Dernière connexion',
            value: agent.derniereConnexion != null
                ? _fmtRelative(agent.derniereConnexion!)
                : 'Jamais',
          ),
        ],
      ),
    );

    final perfCard = SectionCard(
      title: 'Performance',
      child: perf == null
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Aucune statistique disponible',
                style: TextStyle(color: sdTextSecondary),
              ),
            )
          : _PerfBlock(perf: perf!),
    );

    final actions = SectionCard(
      title: 'Actions',
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: agent.actif ? sdRed : sdGreenDigital,
                side: BorderSide(
                  color: agent.actif ? sdRed : sdGreenDigital,
                  width: 1.2,
                ),
              ),
              icon: Icon(agent.actif ? Icons.block : Icons.lock_open),
              label: Text(
                agent.actif ? 'Bloquer ce compte' : 'Réactiver ce compte',
              ),
              onPressed: () async {
                try {
                  if (agent.actif) {
                    await ref.read(teamRepositoryProvider).block(agent.id);
                  } else {
                    await ref.read(teamRepositoryProvider).unblock(agent.id);
                  }
                  ref.invalidate(agentDetailProvider(agent.id));
                  ref.invalidate(agentListProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          agent.actif ? 'Compte bloqué' : 'Compte réactivé',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
                  }
                }
              },
            ),
          ),
        ],
      ),
    );

    return ListView(
      padding: padding,
      children: [
        header,
        const SizedBox(height: 16),
        if (twoCols)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [infos, const SizedBox(height: 16), perfCard],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: actions),
            ],
          )
        else ...[
          infos,
          const SizedBox(height: 16),
          perfCard,
          const SizedBox(height: 16),
          actions,
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  String _fmtRelative(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return 'à l\'instant';
    if (diff.inHours < 1) return 'il y a ${diff.inMinutes} min';
    if (diff.inDays < 1) return 'il y a ${diff.inHours} h';
    if (diff.inDays < 30) return 'il y a ${diff.inDays} j';
    return '${d.day}/${d.month}/${d.year}';
  }
}

class _Header extends StatelessWidget {
  final Agent agent;
  const _Header({required this.agent});

  @override
  Widget build(BuildContext context) {
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
          AgentAvatar(
            agent: agent,
            size: 64,
            background: Colors.white.withValues(alpha: 0.18),
            foreground: Colors.white,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  agent.nomComplet,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(sdRadiusSm),
                      ),
                      child: Text(
                        agent.role == 'admin' ? 'Admin' : 'Agent',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!agent.actif)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: sdRed,
                          borderRadius: BorderRadius.circular(sdRadiusSm),
                        ),
                        child: const Text(
                          'Bloqué',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PerfBlock extends StatelessWidget {
  final AgentPerformance perf;
  const _PerfBlock({required this.perf});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _Stat(
                label: 'Assignés',
                value: '${perf.totalAssignes}',
                color: sdGreenBaobab,
              ),
            ),
            Expanded(
              child: _Stat(
                label: 'Clos',
                value: '${perf.totalClos}',
                color: sdGreenDigital,
              ),
            ),
            Expanded(
              child: _Stat(
                label: 'En retard',
                value: '${perf.enRetard}',
                color: sdRed,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Taux de complétion',
          style: TextStyle(fontSize: 12, color: sdTextSecondary),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (perf.tauxCompletion / 100).clamp(0.0, 1.0),
                  minHeight: 10,
                  backgroundColor: sdLightGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    perf.tauxCompletion >= 75
                        ? sdGreenDigital
                        : perf.tauxCompletion >= 50
                        ? sdGoldTeranga
                        : sdRed,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${perf.tauxCompletion.toStringAsFixed(0)}%',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Stat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 24,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: sdTextSecondary),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: sdStoneGrey),
          const SizedBox(width: 12),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(color: sdTextSecondary, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
