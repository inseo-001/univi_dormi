import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CivilComplaint {
  final String? id;
  final String userId;
  final String userName;
  final String studentId;
  final String complaintType; // 민원 종류
  final String category; // 카테고리
  final String title; // 제목
  final String description; // 상세 내용
  final String status; // 상태 (접수, 처리중, 완료)
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? adminResponse; // 관리자 답변
  final DateTime? completedAt; // 완료일

  CivilComplaint({
    this.id,
    required this.userId,
    required this.userName,
    required this.studentId,
    required this.complaintType,
    required this.category,
    required this.title,
    required this.description,
    this.status = '접수',
    required this.createdAt,
    this.updatedAt,
    this.adminResponse,
    this.completedAt,
  });

  // Firestore에서 데이터를 가져올 때 사용
  factory CivilComplaint.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return CivilComplaint(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      studentId: data['studentId'] ?? '',
      complaintType: data['complaintType'] ?? '',
      category: data['category'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? '접수',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      adminResponse: data['adminResponse'],
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Firestore에 저장할 때 사용
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'studentId': studentId,
      'complaintType': complaintType,
      'category': category,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'adminResponse': adminResponse,
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  // 상태에 따른 색상 반환
  Color get statusColor {
    switch (status) {
      case '접수':
        return const Color(0xFF11BD4A); // 초록색
      case '처리중':
        return const Color(0xFF0B64F4); // 파란색
      case '완료':
        return const Color(0xFF11BD4A); // 초록색
      default:
        return const Color(0xFF88898D); // 회색
    }
  }

  // 상태에 따른 아이콘 반환
  IconData get statusIcon {
    switch (status) {
      case '접수':
        return Icons.chat_bubble_outline;
      case '처리중':
        return Icons.warning_amber_sharp;
      case '완료':
        return Icons.check_circle_outline;
      default:
        return Icons.help_outline;
    }
  }
}
