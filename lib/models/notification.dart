import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationItem {
  final String id;
  final String title;
  final String content;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final String? relatedId; // 관련된 메시지, 댓글, 공지사항의 ID
  final String? senderName; // 발신자 이름 (메시지, 댓글의 경우)
  final String? senderId; // 발신자 ID

  NotificationItem({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.relatedId,
    this.senderName,
    this.senderId,
  });

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      type: _parseNotificationType(map['type']),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      isRead: map['isRead'] ?? false,
      relatedId: map['relatedId'],
      senderName: map['senderName'],
      senderId: map['senderId'],
    );
  }

  static NotificationType _parseNotificationType(dynamic typeValue) {
    if (typeValue == null) return NotificationType.message;

    String typeString = typeValue.toString().toLowerCase();
    switch (typeString) {
      case 'notice':
        return NotificationType.notice;
      case 'comment':
        return NotificationType.comment;
      case 'message':
        return NotificationType.message;
      default:
        return NotificationType.message; // 기본값
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type.toString(),
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'relatedId': relatedId,
      'senderName': senderName,
      'senderId': senderId,
    };
  }

  NotificationItem copyWith({
    String? id,
    String? title,
    String? content,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    String? relatedId,
    String? senderName,
    String? senderId,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      relatedId: relatedId ?? this.relatedId,
      senderName: senderName ?? this.senderName,
      senderId: senderId ?? this.senderId,
    );
  }

  // 상대적 시간 표시
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  // 날짜 포맷팅
  String get formattedDate {
    return '${createdAt.year}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.day.toString().padLeft(2, '0')}';
  }

  // 알림 타입별 아이콘
  String get iconName {
    switch (type) {
      case NotificationType.message:
        return 'message';
      case NotificationType.comment:
        return 'comment';
      case NotificationType.notice:
        return 'notice';
    }
  }

  // 알림 타입별 색상
  int get colorValue {
    switch (type) {
      case NotificationType.message:
        return 0xFF3C63B7; // 파란색
      case NotificationType.comment:
        return 0xFF60A9F0; // 하늘색
      case NotificationType.notice:
        return 0xFFFF6B6B; // 빨간색
    }
  }
}

enum NotificationType {
  message, // 메시지
  comment, // 게시판 댓글
  notice, // 새로운 공지사항
}
