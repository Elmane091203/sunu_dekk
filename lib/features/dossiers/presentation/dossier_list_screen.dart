import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../shared_ui/empty_view.dart';
import '../../../shared_ui/responsive.dart';
import '../data/dossier_repository_impl.dart';
import '../domain/dossier_repository.dart';
import '../domain/dossier_summary.dart';
import 'dossier_list_controller.dart';
import 'widgets/dossier_tile.dart';

class DossierListScreen extends ConsumerStatefulWidget {
  const DossierListScreen({super.key});

  @override
  ConsumerState<DossierListScreen> createState() => _DossierListScreenState();
}

class _DossierListScreenState extends ConsumerState<DossierListScreen> {
  final _scroll = ScrollController();
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _search.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      ref.read(dossierListControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dossierListControllerProvider);
    final notifier = ref.read(dossierListControllerProvider.notifier);
    final isTablet = context.isTablet;

    return Scaffold(
      backgroundColor: sdScaffoldBg,
      appBar: AppBar(
        title: const Text('Dossiers'),
        actions: [
          IconButton(
            tooltip: 'Filtrer',
            icon: Icon(
              state.filter.isEmpty ? Icons.tune_outlined : Icons.filter_alt,
              color: state.filter.isEmpty ? null : sdGreenBaobab,
            ),
            onPressed: () => _openFilters(state.filter, notifier.setFilter),
          ),
          IconButton(
            tooltip: 'Actualiser',
            icon: const Icon(Icons.refresh),
            onPressed: notifier.refresh,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: 'Rechercher un numéro, citoyen, démarche...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: state.filter.search?.isNotEmpty == true
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _search.clear();
                          notifier
                              .setFilter(state.filter.copyWith(search: ''));
                        },
                      )
                    : null,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (v) => notifier
                  .setFilter(state.filter.copyWith(search: v.trim())),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: notifier.refresh,
        child: _buildBody(state, isTablet),
      ),
    );
  }

  Widget _buildBody(DossierListState state, bool isTablet) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null && state.items.isEmpty) {
      return EmptyView(
        icon: Icons.cloud_off_outlined,
        title: 'Impossible de charger les dossiers',
        message: state.error.toString(),
        action: FilledButton.icon(
          onPressed: () =>
              ref.read(dossierListControllerProvider.notifier).refresh(),
          icon: const Icon(Icons.refresh),
          label: const Text('Réessayer'),
        ),
      );
    }
    if (state.items.isEmpty) {
      return const EmptyView(
        icon: Icons.folder_off_outlined,
        title: 'Aucun dossier',
        message: 'Ajustez vos filtres ou attendez de nouvelles demandes.',
      );
    }

    final content = isTablet
        ? GridView.builder(
            controller: _scroll,
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 460,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 132,
            ),
            itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (_, i) {
              if (i >= state.items.length) {
                return const Center(child: CircularProgressIndicator());
              }
              return _Swipeable(
                dossier: state.items[i],
                onTap: () => context
                    .go('${AppRoute.dossiers}/${state.items[i].id}'),
              );
            },
          )
        : ListView.separated(
            controller: _scroll,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              if (i >= state.items.length) {
                return const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return _Swipeable(
                dossier: state.items[i],
                onTap: () => context
                    .go('${AppRoute.dossiers}/${state.items[i].id}'),
              );
            },
          );

    return Column(
      children: [
        if (!state.filter.isEmpty) _ActiveFiltersBar(filter: state.filter),
        Expanded(child: content),
      ],
    );
  }

  Future<void> _openFilters(
    DossierFilter current,
    void Function(DossierFilter) onApply,
  ) async {
    final result = await showModalBottomSheet<DossierFilter>(
      context: context,
      backgroundColor: sdSurface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(sdRadiusLg)),
      ),
      builder: (_) => _FilterSheet(initial: current),
    );
    if (result != null) onApply(result);
  }
}

/// Wrapper Dismissible : swipe droite = "Valider", swipe gauche = "Rejeter".
/// Geste 1-tap, valeur ajoutee terrain.
class _Swipeable extends ConsumerWidget {
  final DossierSummary dossier;
  final VoidCallback onTap;
  const _Swipeable({required this.dossier, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowSwipe =
        dossier.statut != 'cloture' && dossier.statut != 'rejete';

    if (!allowSwipe) {
      return DossierTile(dossier: dossier, onTap: onTap);
    }

    return Dismissible(
      key: ValueKey('dossier-${dossier.id}'),
      background: const _SwipeBg(
        align: Alignment.centerLeft,
        color: sdGreenDigital,
        icon: Icons.check_circle_outline,
        label: 'Valider',
      ),
      secondaryBackground: const _SwipeBg(
        align: Alignment.centerRight,
        color: sdRed,
        icon: Icons.cancel_outlined,
        label: 'Rejeter',
      ),
      confirmDismiss: (direction) async {
        final action = direction == DismissDirection.startToEnd
            ? 'valider'
            : 'rejeter';
        final commentaire = await _askComment(context, action);
        if (commentaire == null) return false;
        final notif = ref.read(dossierListControllerProvider.notifier);
        final repo = ref.read(dossierRepositoryProvider);
        try {
          if (action == 'valider') {
            await repo.validerWorkflow(dossier.id, commentaire: commentaire);
          } else {
            await repo.rejeterWorkflow(dossier.id, commentaire: commentaire);
          }
          notif.removeById(dossier.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Dossier ${dossier.numero} ${action == 'valider' ? 'validé' : 'rejeté'}',
                ),
              ),
            );
          }
          return true;
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Échec : $e')),
            );
          }
          return false;
        }
      },
      child: DossierTile(dossier: dossier, onTap: onTap),
    );
  }

  Future<String?> _askComment(BuildContext context, String action) async {
    final controller = TextEditingController();
    return showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
            action == 'valider' ? 'Valider le dossier' : 'Rejeter le dossier'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: action == 'valider'
                ? 'Commentaire optionnel'
                : 'Motif du rejet (requis)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: action == 'valider' ? sdGreenDigital : sdRed,
            ),
            onPressed: () {
              final t = controller.text.trim();
              if (action == 'rejeter' && t.isEmpty) return;
              Navigator.pop(ctx, t);
            },
            child: Text(action == 'valider' ? 'Valider' : 'Rejeter'),
          ),
        ],
      ),
    );
  }
}

class _SwipeBg extends StatelessWidget {
  final Alignment align;
  final Color color;
  final IconData icon;
  final String label;
  const _SwipeBg({
    required this.align,
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: align,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(sdRadiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveFiltersBar extends StatelessWidget {
  final DossierFilter filter;
  const _ActiveFiltersBar({required this.filter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (filter.statut?.isNotEmpty == true)
            _ActiveChip(
              icon: Icons.flag_outlined,
              label: 'Statut: ${filter.statut}',
            ),
          if (filter.priorite?.isNotEmpty == true)
            _ActiveChip(
              icon: Icons.priority_high,
              label: 'Priorité: ${filter.priorite}',
            ),
          if (filter.search?.isNotEmpty == true)
            _ActiveChip(icon: Icons.search, label: '"${filter.search}"'),
        ],
      ),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActiveChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFD5EDE2),
        borderRadius: BorderRadius.circular(sdRadiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: sdGreenBaobab),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: sdGreenBaobab,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  final DossierFilter initial;
  const _FilterSheet({required this.initial});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String? statut = widget.initial.statut;
  late String? priorite = widget.initial.priorite;

  static const _statuts = [
    'nouveau',
    'en_cours',
    'doc_requis',
    'en_validation',
    'cloture',
    'rejete',
  ];
  static const _priorites = ['basse', 'normale', 'haute', 'urgente'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Filtres',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() {
                    statut = null;
                    priorite = null;
                  }),
                  child: const Text('Réinitialiser'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Statut',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in _statuts)
                  ChoiceChip(
                    label: Text(_humanize(s)),
                    selected: statut == s,
                    onSelected: (v) => setState(() => statut = v ? s : null),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Priorité',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final p in _priorites)
                  ChoiceChip(
                    label: Text(_humanize(p)),
                    selected: priorite == p,
                    onSelected: (v) =>
                        setState(() => priorite = v ? p : null),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.pop(
                context,
                widget.initial.copyWith(
                  statut: statut ?? '',
                  priorite: priorite ?? '',
                ),
              ),
              child: const Text('Appliquer'),
            ),
          ],
        ),
      ),
    );
  }

  String _humanize(String raw) => raw
      .replaceAll('_', ' ')
      .split(' ')
      .map((s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}')
      .join(' ');
}
