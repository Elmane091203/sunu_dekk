import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme.dart';
import '../../../../core/auth/permission_service.dart';
import '../../../../core/auth/privilege.dart';
import '../../../auth/presentation/auth_controller.dart';
import '../../data/message_repository.dart';
import '../../domain/message.dart';

/// Fil de discussion sur un dossier (citoyen ↔ agent ↔ admin).
/// Bulles a droite pour les messages envoyes par l'utilisateur courant,
/// a gauche pour les autres.
class DossierMessages extends ConsumerStatefulWidget {
  final int dossierId;
  const DossierMessages({super.key, required this.dossierId});

  @override
  ConsumerState<DossierMessages> createState() => _DossierMessagesState();
}

class _DossierMessagesState extends ConsumerState<DossierMessages> {
  final _ctl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final t = _ctl.text.trim();
    if (t.isEmpty) return;
    setState(() => _sending = true);
    try {
      await ref.read(messageRepositoryProvider).send(widget.dossierId, t);
      _ctl.clear();
      ref.invalidate(dossierMessagesProvider(widget.dossierId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec : $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(dossierMessagesProvider(widget.dossierId));
    final me = ref.watch(authControllerProvider).valueOrNull?.id ?? 0;
    final canSend =
        ref.watch(permissionServiceProvider).has(Privilege.envoyerMessages);

    return Column(
      children: [
        SizedBox(
          height: 320,
          child: async.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text(
                'Impossible de charger les messages : $e',
                style: const TextStyle(color: sdTextSecondary, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            data: (msgs) {
              if (msgs.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: sdScaffoldBg,
                    borderRadius: BorderRadius.circular(sdRadiusSm),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          color: sdStoneGrey, size: 32),
                      SizedBox(height: 8),
                      Text(
                        'Aucun message',
                        style: TextStyle(
                          color: sdTextSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Démarrez la conversation avec le citoyen.',
                        style:
                            TextStyle(color: sdTextSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                reverse: false,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: msgs.length,
                itemBuilder: (_, i) {
                  final m = msgs[i];
                  final mine = m.auteurId == me;
                  return _Bubble(message: m, mine: mine);
                },
              );
            },
          ),
        ),
        if (canSend) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctl,
                  decoration: const InputDecoration(
                    hintText: 'Écrire un message...',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 48,
                width: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: const CircleBorder(),
                  ),
                  onPressed: _sending ? null : _send,
                  child: _sending
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send, size: 18),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  final DossierMessage message;
  final bool mine;
  const _Bubble({required this.message, required this.mine});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('HH:mm', 'fr_FR');
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.72,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: mine ? sdGreenBaobab : sdSurface,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(sdRadiusMd),
              topRight: const Radius.circular(sdRadiusMd),
              bottomLeft: Radius.circular(mine ? sdRadiusMd : 4),
              bottomRight: Radius.circular(mine ? 4 : sdRadiusMd),
            ),
            border: mine ? null : Border.all(color: const Color(0xFFE2E8E6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!mine && message.auteurNom != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    message.auteurNom!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: sdGreenBaobab,
                    ),
                  ),
                ),
              Text(
                message.contenu,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.35,
                  color: mine ? Colors.white : sdTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.createdAt != null
                        ? df.format(message.createdAt!)
                        : '',
                    style: TextStyle(
                      fontSize: 10,
                      color: mine
                          ? Colors.white.withValues(alpha: 0.7)
                          : sdTextSecondary,
                    ),
                  ),
                  if (mine) ...[
                    const SizedBox(width: 4),
                    Icon(
                      message.lu ? Icons.done_all : Icons.done,
                      size: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
