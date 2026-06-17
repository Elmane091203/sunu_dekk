import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../../../core/network/api_client.dart';
import '../../../team/data/team_repository.dart';
import '../../../team/domain/agent.dart';
import '../../../team/presentation/widgets/agent_avatar.dart';

class AssignAgentSheet extends ConsumerWidget {
  final int dossierId;
  final int? currentAgentId;
  const AssignAgentSheet({
    super.key,
    required this.dossierId,
    this.currentAgentId,
  });

  static Future<bool?> show(
    BuildContext context, {
    required int dossierId,
    int? currentAgentId,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: sdSurface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(sdRadiusLg)),
      ),
      builder: (_) => AssignAgentSheet(
        dossierId: dossierId,
        currentAgentId: currentAgentId,
      ),
    );
  }

  Future<void> _assign(BuildContext context, WidgetRef ref, int? agentId) async {
    final dio = ref.read(apiClientProvider);
    try {
      await dio.patch(
        '/dossiers/$dossierId/assigner',
        data: {'agent_id': agentId},
      );
      if (context.mounted) Navigator.pop(context, true);
    } on DioException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${mapDioToFailure(e)}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agents = ref.watch(agentListProvider);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: sdLightGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.assignment_ind_outlined,
                    color: sdGreenBaobab),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Assigner à un agent',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.55,
              ),
              child: agents.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Impossible de charger les agents : $e'),
                ),
                data: (list) {
                  final actifs = list
                      .where((a) => a.actif && a.role == 'agent')
                      .toList();
                  if (actifs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Aucun agent disponible.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: sdTextSecondary),
                      ),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      _UnassignTile(
                        active: currentAgentId == null,
                        onTap: () => _assign(context, ref, null),
                      ),
                      const Divider(height: 1),
                      for (final a in actifs)
                        _AgentSelectTile(
                          agent: a,
                          active: currentAgentId == a.id,
                          onTap: () => _assign(context, ref, a.id),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnassignTile extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  const _UnassignTile({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(sdRadiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: sdLightGrey,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_off_outlined, color: sdStoneGrey),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Aucun agent (désassigner)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            if (active)
              const Icon(Icons.check_circle, color: sdGreenDigital),
          ],
        ),
      ),
    );
  }
}

class _AgentSelectTile extends StatelessWidget {
  final Agent agent;
  final bool active;
  final VoidCallback onTap;
  const _AgentSelectTile({
    required this.agent,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(sdRadiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
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
                  if (agent.email != null)
                    Text(
                      agent.email!,
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
            if (active)
              const Icon(Icons.check_circle, color: sdGreenDigital),
          ],
        ),
      ),
    );
  }
}
