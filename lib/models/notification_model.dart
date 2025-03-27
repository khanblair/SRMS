class Notification {
  final String id;
  final String userId;
  final String subject;
  final String content;
  final bool isRead;
  final DateTime? readAt;
  final String? actionUrl;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.userId,
    required this.subject,
    required this.content,
    this.isRead = false,
    this.readAt,
    this.actionUrl,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      subject: json['subject'] as String,
      content: json['content'] as String,
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      actionUrl: json['action_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Notification copyWith({
    String? id,
    String? userId,
    String? subject,
    String? content,
    bool? isRead,
    DateTime? readAt,
    String? actionUrl,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      actionUrl: actionUrl ?? this.actionUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}