import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../shared_ui/empty_view.dart';
import '../../../shared_ui/responsive.dart';
import '../data/demarche_repository.dart';
import '../domain/demarche.dart';

class DemarchesScreen extends ConsumerStatefulWidget {
  const DemarchesScreen({super.key});

  @override
  ConsumerState<DemarchesScreen> createState() => _DemarchesScreenState();
}

class _DemarchesScreenState extends ConsumerState<DemarchesScreen> {
  String _search = '';
  final _ctl = TextEditingController();

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(demarcheListProvider(_search));
    final isTablet = context.isTablet;

    return Scaffold(
      backgroundColor: sdScaffoldBg,
      appBar: AppBar(
        title: const Text('Catalogue démarches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(demarcheListProvider(_search)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _ctl,
              decoration: InputDecoration(
                hintText: 'Rechercher une démarche...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _ctl.clear();
                          setState(() => _search = '');
                        },
                      )
                    : null,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (v) => setState(() => _search = v.trim()),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(demarcheListProvider(_search)),
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => EmptyView(
            icon: Icons.cloud_off_outlined,
            title: 'Impossible de charger le catalogue',
            message: e.toString(),
          ),
          data: (list) {
            if (list.isEmpty) {
              return const EmptyView(
                icon: Icons.assignment_outlined,
                title: 'Aucune démarche',
                message: 'Aucune procédure ne correspond à votre recherche.',
              );
            }
            // Group by categorie
            final grouped = <String, List<Demarche>>{};
            for (final d in list) {
              grouped.putIfAbsent(d.categorie ?? 'autres', () => []).add(d);
            }
            final entries = grouped.entries.toList()
              ..sort((a, b) => a.key.compareTo(b.key));

            return ListView(
              padding: isTablet
                  ? const EdgeInsets.symmetric(horizontal: 32, vertical: 16)
                  : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                for (final entry in entries) ...[
                  _CategoryHeader(label: entry.key, count: entry.value.length),
                  if (isTablet)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 380,
                        mainAxisExtent: 120,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: entry.value.length,
                      itemBuilder: (_, i) =>
                          _DemarcheTile(demarche: entry.value[i]),
                    )
                  else
                    Column(
                      children: [
                        for (final d in entry.value) ...[
                          _DemarcheTile(demarche: d),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  const SizedBox(height: 16),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final String label;
  final int count;
  const _CategoryHeader({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFD5EDE2),
              borderRadius: BorderRadius.circular(sdRadiusSm),
            ),
            child: Text(
              _humanize(label),
              style: const TextStyle(
                color: sdGreenBaobab,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: const TextStyle(
              color: sdTextSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _humanize(String raw) => raw
      .replaceAll('_', ' ')
      .split(' ')
      .map((s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}')
      .join(' ');
}

class _DemarcheTile extends StatelessWidget {
  final Demarche demarche;
  const _DemarcheTile({required this.demarche});

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'FCFA',
      decimalDigits: 0,
    );
    return Material(
      color: sdSurface,
      borderRadius: BorderRadius.circular(sdRadiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(sdRadiusMd),
        onTap: () => context.go('${AppRoute.demarches}/${demarche.id}'),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sdRadiusMd),
            border: Border.all(color: const Color(0xFFE2E8E6)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: sdGoldTeranga.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(sdRadiusSm),
                ),
                child: const Icon(Icons.description_outlined,
                    color: sdGoldTeranga),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      demarche.nom,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    if (demarche.nomWolof?.isNotEmpty == true) ...[
                      const SizedBox(height: 2),
                      Text(
                        demarche.nomWolof!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: sdTextSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _MetaIcon(
                          icon: Icons.schedule,
                          text: '${demarche.delaiTraitementJours} j',
                        ),
                        _MetaIcon(
                          icon: Icons.payments_outlined,
                          text: demarche.frais > 0
                              ? money.format(demarche.frais)
                              : 'Gratuit',
                        ),
                        _MetaIcon(
                          icon: Icons.attach_file,
                          text: '${demarche.documentsRequis.length} doc.',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!demarche.actif)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.toggle_off_outlined,
                      color: sdRed, size: 22),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaIcon({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: sdTextSecondary),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(color: sdTextSecondary, fontSize: 11),
        ),
      ],
    );
  }
}
