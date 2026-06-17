import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../shared_ui/empty_view.dart';
import '../../../shared_ui/responsive.dart';
import '../data/notification_repository_impl.dart';
import '../domain/notification_item.dart';
import 'notifications_controller.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: sdScaffoldBg,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if ((async.valueOrNull?.nonLues ?? 0) > 0)
            TextButton.icon(
              icon: const Icon(Icons.done_all, size: 18),
              label: const Text('Tout lire'),
              onPressed: () async {
                try {
                  await ref
                      .read(notificationRepositoryProvider)
                      .markAllRead();
                  ref.invalidate(notificationsProvider);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur : $e')),
                    );
                  }
                }
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(notificationsProvider),
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => EmptyView(
            icon: Icons.cloud_off_outlined,
            title: 'Impossible de charger les notifications',
            message: e.toString(),
            action: FilledButton.icon(
              onPressed: () => ref.invalidate(notificationsProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ),
          data: (p) {
            if (p.items.isEmpty) {
              return const EmptyView(
                icon: Icons.notifications_none_outlined,
                title: 'Aucune notification',
                message:
                    'Vous serez alerté dès qu\'un événement nécessite votre attention.',
              );
            }
            return _List(payload: p);
          },
        ),
      ),
    );
  }
}

class _List extends ConsumerWidget {
  final NotificationsPayload payload;
  const _List({required this.payload});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = context.isTablet;
    final padding = isTablet
        ? const EdgeInsets.symmetric(horizontal: 32, vertical: 16)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

    return ListView.separated(
      padding: padding,
      itemCount: payload.items.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  payload.nonLues > 0
                      ? '${payload.nonLues} non lue(s)'
                      : 'Toutes lues',
                  style: const TextStyle(
                    color: sdTextSecondary,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Text(
                  '${payload.items.length} récente(s)',
                  style: const TextStyle(
                    color: sdTextSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }
        final n = payload.items[i - 1];
        return _NotifTile(notif: n);
      },
    );
  }
}

class _NotifTile extends ConsumerWidget {
  final NotificationItem notif;
  const _NotifTile({required this.notif});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final df = DateFormat('dd MMM • HH:mm', 'fr_FR');
    final iconSpec = _iconFor(notif.type);

    return Material(
      color: notif.lu ? sdSurface : const Color(0xFFD5EDE2),
      borderRadius: BorderRadius.circular(sdRadiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(sdRadiusMd),
        onTap: () async {
          if (!notif.lu) {
            try {
              await ref
                  .read(notificationRepositoryProvider)
                  .markRead(notif.id);
              ref.invalidate(notificationsProvider);
            } catch (_) {/* refresh manuel possible */}
          }
          if (notif.dossierId != null && context.mounted) {
            context.go('${AppRoute.dossiers}/${notif.dossierId}');
          }
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sdRadiusMd),
            border: Border.all(
              color: notif.lu
                  ? const Color(0xFFE2E8E6)
                  : sdGreenBaobab.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconSpec.$2.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(sdRadiusSm),
                ),
                child: Icon(iconSpec.$1, color: iconSpec.$2, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notif.titre ?? 'Notification',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight:
                                  notif.lu ? FontWeight.w500 : FontWeight.w700,
                              fontSize: 14,
                              color: sdTextPrimary,
                            ),
                          ),
                        ),
                        if (!notif.lu)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: sdGreenBaobab,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    if (notif.message?.isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Text(
                        notif.message!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: sdTextSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                    if (notif.createdAt != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        df.format(notif.createdAt!),
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
      ),
    );
  }

  (IconData, Color) _iconFor(String? type) {
    switch (type) {
      case 'dossier_assigne':
        return (Icons.assignment_ind_outlined, sdGreenBaobab);
      case 'dossier_valide':
        return (Icons.check_circle_outline, sdGreenDigital);
      case 'dossier_rejete':
        return (Icons.cancel_outlined, sdRed);
      case 'echeance_proche':
        return (Icons.schedule_outlined, sdGoldTeranga);
      case 'message':
        return (Icons.mail_outline, sdGreenDigital);
      default:
        return (Icons.notifications_outlined, sdStoneGrey);
    }
  }
}
