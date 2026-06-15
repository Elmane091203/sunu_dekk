import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// SQUELETTE — Centre de notifications.
/// A implementer :
/// - Liste paginee depuis GET /api/notifications
/// - WebSocket Flask-SocketIO pour push temps reel (room utilisateur_<id>)
/// - FCM (firebase_messaging) pour push hors-app
/// - Marquer comme lu : PATCH /api/notifications/<id>/lu
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(child: Text('TODO: notifications temps reel')),
    );
  }
}
