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

  Notice({
    this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    this.updatedAt,
    this.isImportant = false,
    this.category,
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

  // 작성일 포맷팅
  String get formattedDate {
    return '${createdAt.year}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.day.toString().padLeft(2, '0')}';
  }
}
