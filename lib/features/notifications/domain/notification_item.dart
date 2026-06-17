class NotificationItem {
  final int id;
  final String? titre;
  final String? message;
  final String? type;
  final bool lu;
  final int? dossierId;
  final DateTime? createdAt;

  const NotificationItem({
    required this.id,
    this.titre,
    this.message,
    this.type,
    required this.lu,
    this.dossierId,
    this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    DateTime? parse(dynamic raw) {
      if (raw == null) return null;
      try {
        return DateTime.parse(raw.toString()).toLocal();
      } catch (_) {
        return null;
      }
    }

    return NotificationItem(
      id: (json['id'] as num).toInt(),
      titre: json['titre']?.toString(),
      message: json['message']?.toString() ?? json['contenu']?.toString(),
      type: json['type']?.toString(),
      lu: json['lu'] as bool? ?? false,
      dossierId: (json['dossier_id'] as num?)?.toInt(),
      createdAt: parse(json['created_at']),
    );
  }
}

class NotificationsPayload {
  final List<NotificationItem> items;
  final int nonLues;
  const NotificationsPayload({required this.items, required this.nonLues});

  factory NotificationsPayload.fromJson(Map<String, dynamic> json) {
    final list = (json['notifications'] as List? ?? [])
        .whereType<Map>()
        .map((e) => NotificationItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return NotificationsPayload(
      items: list,
      nonLues: (json['non_lues'] as num?)?.toInt() ?? 0,
    );
  }
}
