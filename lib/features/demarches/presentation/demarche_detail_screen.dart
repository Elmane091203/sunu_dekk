import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../core/auth/permission_service.dart';
import '../../../core/auth/privilege.dart';
import '../../../shared_ui/empty_view.dart';
import '../../../shared_ui/responsive.dart';
import '../../../shared_ui/section_card.dart';
import '../data/demarche_repository.dart';
import '../domain/demarche.dart';

class DemarcheDetailScreen extends ConsumerWidget {
  final int typeId;
  const DemarcheDetailScreen({super.key, required this.typeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(demarcheDetailProvider(typeId));
    final isTablet = context.isTablet;

    return Scaffold(
      backgroundColor: sdScaffoldBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoute.demarches),
        ),
        title: const Text('Procédure'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EmptyView(
          icon: Icons.cloud_off_outlined,
          title: 'Impossible de charger la procédure',
          message: e.toString(),
        ),
        data: (d) => _Body(demarche: d, twoCols: isTablet, ref: ref),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final Demarche demarche;
  final bool twoCols;
  final WidgetRef ref;
  const _Body({
    required this.demarche,
    required this.twoCols,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'FCFA',
      decimalDigits: 0,
    );
    final padding = twoCols
        ? const EdgeInsets.symmetric(horizontal: 32, vertical: 24)
        : const EdgeInsets.all(16);
    final canManage =
        ref.watch(permissionServiceProvider).has(Privilege.gererProcedures);

    final header = _Header(demarche: demarche, money: money);
    final docs = SectionCard(
      title: 'Documents requis',
      subtitle: '${demarche.documentsRequis.length} pièce(s)',
      child: demarche.documentsRequis.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Aucun document obligatoire',
                style: TextStyle(color: sdTextSecondary),
              ),
            )
          : Column(
              children: [
                for (final doc in demarche.documentsRequis)
                  _DocRow(doc: doc),
              ],
            ),
    );
    final criteres = SectionCard(
      title: 'Critères d\'éligibilité',
      child: demarche.criteres.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Aucun critère spécifique',
                style: TextStyle(color: sdTextSecondary),
              ),
            )
          : Column(
              children: [
                for (final c in demarche.criteres)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: Icon(Icons.check,
                              size: 16, color: sdGreenDigital),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            c,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
    final admin = SectionCard(
      title: 'Administration',
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: demarche.actif ? sdRed : sdGreenDigital,
                side: BorderSide(
                  color: demarche.actif ? sdRed : sdGreenDigital,
                  width: 1.2,
                ),
              ),
              icon: Icon(demarche.actif
                  ? Icons.toggle_on_outlined
                  : Icons.toggle_off_outlined),
              label: Text(demarche.actif
                  ? 'Désactiver cette procédure'
                  : 'Réactiver cette procédure'),
              onPressed: () async {
                try {
                  await ref
                      .read(demarcheRepositoryProvider)
                      .toggleActif(demarche.id, !demarche.actif);
                  ref.invalidate(demarcheDetailProvider(demarche.id));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(demarche.actif
                            ? 'Procédure désactivée'
                            : 'Procédure réactivée'),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur : $e')),
                    );
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
                flex: 3,
                child: Column(children: [
                  docs,
                  const SizedBox(height: 16),
                  criteres,
                ]),
              ),
              if (canManage) ...[
                const SizedBox(width: 16),
                Expanded(flex: 2, child: admin),
              ],
            ],
          )
        else ...[
          docs,
          const SizedBox(height: 16),
          criteres,
          if (canManage) ...[
            const SizedBox(height: 16),
            admin,
          ],
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final Demarche demarche;
  final NumberFormat money;
  const _Header({required this.demarche, required this.money});

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
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _HeaderChip(
                icon: Icons.qr_code_2_outlined,
                label: demarche.code,
              ),
              if (demarche.categorie != null)
                _HeaderChip(
                  icon: Icons.category_outlined,
                  label: demarche.categorie!,
                ),
              if (!demarche.actif)
                const _HeaderChip(
                  icon: Icons.power_settings_new,
                  label: 'Désactivée',
                  bg: sdRed,
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            demarche.nom,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          if (demarche.nomWolof?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(
              demarche.nomWolof!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 15,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          if (demarche.description != null) ...[
            const SizedBox(height: 12),
            Text(
              demarche.description!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  icon: Icons.schedule,
                  label: 'Délai',
                  value: '${demarche.delaiTraitementJours} j',
                ),
              ),
              Expanded(
                child: _HeroStat(
                  icon: Icons.payments_outlined,
                  label: 'Frais',
                  value: demarche.frais > 0
                      ? money.format(demarche.frais)
                      : 'Gratuit',
                ),
              ),
              Expanded(
                child: _HeroStat(
                  icon: Icons.attach_file,
                  label: 'Docs',
                  value: '${demarche.documentsRequis.length}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? bg;
  const _HeaderChip({required this.icon, required this.label, this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg ?? Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(sdRadiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _HeroStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.85), size: 16),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _DocRow extends StatelessWidget {
  final DocumentRequis doc;
  const _DocRow({required this.doc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: sdLightGrey,
              borderRadius: BorderRadius.circular(sdRadiusSm),
            ),
            child: const Icon(Icons.insert_drive_file_outlined,
                size: 16, color: sdStoneGrey),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.nom,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 13),
                ),
                if (doc.rolesValidateurs.isNotEmpty)
                  Text(
                    'Validé par : ${doc.rolesValidateurs.join(", ")}',
                    style: const TextStyle(
                      color: sdTextSecondary,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
