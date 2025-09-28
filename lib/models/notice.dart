import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Notice {
  final String? id;
  final String title; // 제목
  final String content; // 내용
  final String author; // 작성자
  final DateTime createdAt; // 작성일
  final DateTime? updatedAt; // 수정일
  final bool isImportant; // 중요 공지 여부
  final String? category; // 카테고리 (선택사항)
  final int viewCount; // 조회수

  Notice({
    this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    this.updatedAt,
    this.isImportant = false,
    this.category,
    this.viewCount = 0,
  });

  // Firestore에서 데이터를 가져올 때 사용
  factory Notice.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Notice(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      author: data['author'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isImportant: data['isImportant'] ?? false,
      category: data['category'],
      viewCount: data['viewCount'] ?? 0,
    );
  }

  // Firestore에 저장할 때 사용
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'author': author,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isImportant': isImportant,
      'category': category,
      'viewCount': viewCount,
    };
  }

  // 중요 공지 여부에 따른 색상 반환
  Color get importanceColor {
    return isImportant ? const Color(0xFFFF6B6B) : const Color(0xFF4A90E2);
  }

  // 중요 공지 여부에 따른 아이콘 반환
  IconData get importanceIcon {
    return isImportant ? Icons.priority_high : Icons.notifications_outlined;
  }

  // 작성일 포맷팅 (한국 시간대 적용)
  String get formattedDate {
    // Firebase에서 가져온 시간을 그대로 사용 (이미 로컬 시간)
    return '${createdAt.year}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.day.toString().padLeft(2, '0')}';
  }

  // 작성일과 시간 포맷팅 (한국 시간대 적용)
  String get formattedDateTime {
    return '${createdAt.year}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.day.toString().padLeft(2, '0')} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  // 상대적 시간 표시 (예: 2시간 전, 1일 전)
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    // 음수 차이면 미래 시간이므로 "방금 전"으로 표시
    if (difference.isNegative) {
      return '방금 전';
    }

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
}
