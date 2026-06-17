import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../shared_ui/empty_view.dart';
import '../../../shared_ui/responsive.dart';
import '../../../shared_ui/section_card.dart';
import '../../../shared_ui/status_chip.dart';
import '../data/dossier_repository_impl.dart';
import '../domain/dossier_detail.dart';
import 'widgets/assign_agent_sheet.dart';
import 'widgets/dossier_messages.dart';
import 'widgets/scan_document_sheet.dart';
import 'widgets/signature_sheet.dart';

final dossierDetailProvider = FutureProvider.autoDispose
    .family<DossierDetail, int>((ref, id) async {
      return ref.watch(dossierRepositoryProvider).detail(id);
    });

class DossierDetailScreen extends ConsumerWidget {
  final int dossierId;
  const DossierDetailScreen({super.key, required this.dossierId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dossierDetailProvider(dossierId));
    return Scaffold(
      backgroundColor: sdScaffoldBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoute.dossiers),
        ),
        title: const Text('Dossier'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(dossierDetailProvider(dossierId)),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EmptyView(
          icon: Icons.cloud_off_outlined,
          title: 'Impossible de charger ce dossier',
          message: e.toString(),
          action: FilledButton.icon(
            onPressed: () => ref.invalidate(dossierDetailProvider(dossierId)),
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
          ),
        ),
        data: (d) => _Body(detail: d),
      ),
      floatingActionButton: async.maybeWhen(
        data: (d) => _DocsFab(
          dossierId: d.id,
          onChanged: () {
            ref.invalidate(dossierDetailProvider(dossierId));
          },
        ),
        orElse: () => null,
      ),
    );
  }
}

/// SpeedDial maison : un bouton qui s'expand en deux mini-FABs (scan, signature).
class _DocsFab extends StatefulWidget {
  final int dossierId;
  final VoidCallback onChanged;
  const _DocsFab({required this.dossierId, required this.onChanged});

  @override
  State<_DocsFab> createState() => _DocsFabState();
}

class _DocsFabState extends State<_DocsFab>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late final AnimationController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    if (_open) {
      _ctl.forward();
    } else {
      _ctl.reverse();
    }
  }

  Future<void> _open_(Future<bool?> Function() launch) async {
    _toggle();
    final ok = await launch();
    if (ok == true) widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_open)
          _MiniFab(
            icon: Icons.edit_outlined,
            label: 'Signature',
            onTap: () =>
                _open_(() => SignatureSheet.show(context, widget.dossierId)),
          ),
        if (_open) const SizedBox(height: 12),
        if (_open)
          _MiniFab(
            icon: Icons.document_scanner_outlined,
            label: 'Scanner',
            onTap: () =>
                _open_(() => ScanDocumentSheet.show(context, widget.dossierId)),
          ),
        if (_open) const SizedBox(height: 12),
        FloatingActionButton(
          backgroundColor: sdGreenBaobab,
          foregroundColor: Colors.white,
          onPressed: _toggle,
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 200),
            turns: _open ? 0.125 : 0,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class _MiniFab extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MiniFab({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: sdTextPrimary,
            borderRadius: BorderRadius.circular(sdRadiusSm),
            boxShadow: sdShadowSubtle,
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        FloatingActionButton.small(
          heroTag: 'fab-$label',
          backgroundColor: sdSurface,
          foregroundColor: sdGreenBaobab,
          elevation: 2,
          onPressed: onTap,
          child: Icon(icon),
        ),
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  final DossierDetail detail;
  const _Body({required this.detail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = context.isTablet;
    final padding = isTablet
        ? const EdgeInsets.symmetric(horizontal: 32, vertical: 24)
        : const EdgeInsets.all(16);

    final header = _Header(detail: detail);
    final infos = SectionCard(
      title: 'Informations',
      child: _InfoGrid(detail: detail),
    );
    final actions = SectionCard(
      title: 'Actions',
      child: _Actions(detail: detail),
    );
    final docs = SectionCard(
      title: 'Documents',
      subtitle: '${detail.documents.length} fichier(s)',
      child: _Documents(items: detail.documents),
    );
    final histo = SectionCard(
      title: 'Historique',
      child: _Historique(items: detail.historique),
    );
    final messages = SectionCard(
      title: 'Messagerie',
      subtitle: 'Échangez avec le citoyen et l\'agent',
      child: DossierMessages(dossierId: detail.id),
    );

    return ListView(
      padding: padding,
      children: [
        header,
        const SizedBox(height: 16),
        if (isTablet)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    infos,
                    const SizedBox(height: 16),
                    docs,
                    const SizedBox(height: 16),
                    messages,
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  children: [actions, const SizedBox(height: 16), histo],
                ),
              ),
            ],
          )
        else ...[
          infos,
          const SizedBox(height: 16),
          actions,
          const SizedBox(height: 16),
          messages,
          const SizedBox(height: 16),
          docs,
          const SizedBox(height: 16),
          histo,
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final DossierDetail detail;
  const _Header({required this.detail});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wrap : protege contre l'overflow si la priorite a un label long.
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              StatusChip(statut: detail.statut),
              PriorityChip(priorite: detail.priorite),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            detail.titre,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 22,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            detail.numero,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (detail.description != null) ...[
            const SizedBox(height: 14),
            Text(
              detail.description!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final DossierDetail detail;
  const _InfoGrid({required this.detail});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd MMM yyyy', 'fr_FR');
    final entries = <(IconData, String, String)>[
      (Icons.person_outline, 'Citoyen', detail.citoyen?.nomComplet ?? '-'),
      (
        Icons.support_agent_outlined,
        'Agent',
        detail.agent?.nomComplet ?? 'Non assigné',
      ),
      (
        Icons.account_balance_outlined,
        'Commune',
        detail.collectivite?.nom ?? '-',
      ),
      (Icons.category_outlined, 'Type', detail.typeDemarche?.nom ?? '-'),
      (
        Icons.event_outlined,
        'Soumis le',
        detail.dateSoumission != null ? df.format(detail.dateSoumission!) : '-',
      ),
      (
        Icons.schedule_outlined,
        'Échéance',
        detail.dateEcheance != null ? df.format(detail.dateEcheance!) : '-',
      ),
    ];
    return Column(
      children: [
        for (final e in entries) ...[
          _InfoRow(icon: e.$1, label: e.$2, value: e.$3),
          if (e != entries.last)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Divider(height: 1),
            ),
        ],
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
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: sdLightGrey,
              borderRadius: BorderRadius.circular(sdRadiusSm),
            ),
            child: Icon(icon, size: 16, color: sdStoneGrey),
          ),
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: sdTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Actions extends ConsumerWidget {
  final DossierDetail detail;
  const _Actions({required this.detail});

  bool get _canAct =>
      detail.statut != 'cloture' &&
      detail.statut != 'rejete' &&
      detail.statut != 'valide';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!_canAct) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'Ce dossier est cloturé. Aucune action disponible.',
          style: TextStyle(color: sdTextSecondary),
        ),
      );
    }

    Future<void> run({
      required Future<void> Function(String?) call,
      required String label,
    }) async {
      final c = await _askComment(context, label.toLowerCase());
      if (c == null) return;
      try {
        await call(c);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dossier ${label.toLowerCase()}')),
          );
          ref.invalidate(dossierDetailProvider(detail.id));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
        }
      }
    }

    final repo = ref.read(dossierRepositoryProvider);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: sdGreenDigital),
            icon: const Icon(Icons.check),
            label: const Text('Valider'),
            onPressed: () => run(
              call: (c) => repo.validerWorkflow(detail.id, commentaire: c),
              label: 'Validé',
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.assignment_ind_outlined),
            label: Text(
              detail.agent == null
                  ? 'Assigner un agent'
                  : 'Changer l\'agent assigné',
            ),
            onPressed: () async {
              final ok = await AssignAgentSheet.show(
                context,
                dossierId: detail.id,
                currentAgentId: detail.agent?.id,
              );
              if (ok == true) {
                ref.invalidate(dossierDetailProvider(detail.id));
              }
            },
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.update),
            label: const Text('Passer en cours'),
            onPressed: () => run(
              call: (c) => repo.changerStatut(
                detail.id,
                statut: 'en_cours',
                commentaire: c,
              ),
              label: 'En cours',
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: sdRed,
              side: const BorderSide(color: sdRed, width: 1.2),
            ),
            icon: const Icon(Icons.close),
            label: const Text('Rejeter'),
            onPressed: () => run(
              call: (c) => repo.rejeterWorkflow(detail.id, commentaire: c),
              label: 'Rejeté',
            ),
          ),
        ),
      ],
    );
  }

  Future<String?> _askComment(BuildContext context, String action) async {
    final controller = TextEditingController();
    return showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Commentaire ($action)'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Optionnel - sera tracé dans l\'historique',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
}

class _Documents extends StatelessWidget {
  final List<DocumentItem> items;
  const _Documents({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Aucun document fourni',
          style: TextStyle(color: sdTextSecondary),
        ),
      );
    }
    return Column(
      children: [
        for (final d in items)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: sdScaffoldBg,
              borderRadius: BorderRadius.circular(sdRadiusSm),
              border: Border.all(color: const Color(0xFFE2E8E6)),
            ),
            child: Row(
              children: [
                Icon(
                  d.mimeType?.contains('pdf') == true
                      ? Icons.picture_as_pdf_outlined
                      : Icons.insert_drive_file_outlined,
                  color: sdGreenBaobab,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.nom,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${d.requis ? 'Requis' : 'Optionnel'} • ${_fmtSize(d.taille)}',
                        style: const TextStyle(
                          color: sdTextSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (d.valide == true)
                  const Icon(Icons.verified, color: sdGreenDigital, size: 20)
                else if (d.valide == false)
                  const Icon(Icons.error_outline, color: sdRed, size: 20)
                else
                  const Icon(
                    Icons.hourglass_empty,
                    color: sdStoneGrey,
                    size: 18,
                  ),
              ],
            ),
          ),
      ],
    );
  }

  String _fmtSize(int? bytes) {
    if (bytes == null) return '-';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} Ko';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} Mo';
  }
}

class _Historique extends StatelessWidget {
  final List<HistoriqueItem> items;
  const _Historique({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Aucun événement',
          style: TextStyle(color: sdTextSecondary),
        ),
      );
    }
    final df = DateFormat('dd MMM • HH:mm', 'fr_FR');
    return Column(
      children: [
        for (final h in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: sdGreenBaobab,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (h != items.last)
                      Container(
                        width: 1,
                        height: 32,
                        color: const Color(0xFFE2E8E6),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (h.statutAncien != null) ...[
                            StatusChip(statut: h.statutAncien!, dense: true),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward, size: 12),
                            const SizedBox(width: 4),
                          ],
                          StatusChip(statut: h.statutNouveau, dense: true),
                        ],
                      ),
                      if (h.commentaire?.isNotEmpty == true) ...[
                        const SizedBox(height: 4),
                        Text(
                          h.commentaire!,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                      if (h.createdAt != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          df.format(h.createdAt!),
                          style: const TextStyle(
                            color: sdTextSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
