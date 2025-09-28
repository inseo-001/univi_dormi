import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 사용자의 모든 신청 목록 가져오기
  Future<Map<String, int>> getUserApplicationCounts() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다.');
      }

      // 각 신청 유형별 개수 조회
      final joinQuery = await _firestore
          .collection('users_join')
          .where('userId', isEqualTo: user.uid)
          .get();

      final leaveQuery = await _firestore
          .collection('users_leave')
          .where('userId', isEqualTo: user.uid)
          .get();

      final sleepoverQuery = await _firestore
          .collection('sleepover_applications')
          .where('userId', isEqualTo: user.uid)
          .get();

      final complaintQuery = await _firestore
          .collection('civil_complaints')
          .where('userId', isEqualTo: user.uid)
          .get();

      return {
        'join': joinQuery.docs.length,
        'leave': leaveQuery.docs.length,
        'sleepover': sleepoverQuery.docs.length,
        'complaint': complaintQuery.docs.length,
      };
    } catch (e) {
      print('신청 목록 조회 오류: $e');
      return {
        'join': 0,
        'leave': 0,
        'sleepover': 0,
        'complaint': 0,
      };
    }
  }

  // 사용자의 최근 신청 목록 가져오기 (최대 5개)
  Future<List<Map<String, dynamic>>> getRecentApplications() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다.');
      }

      List<Map<String, dynamic>> allApplications = [];

      // 입사 신청
      final joinQuery = await _firestore
          .collection('users_join')
          .where('userId', isEqualTo: user.uid)
          .get();

      for (var doc in joinQuery.docs) {
        final data = doc.data();
        allApplications.add({
          'id': doc.id,
          'type': '입사신청',
          'title': '입사 신청',
          'date': data['applyday'],
          'status': data['status'] ?? '대기',
          'description': data['reason'] ?? '',
        });
      }

      // 퇴사 신청
      final leaveQuery = await _firestore
          .collection('users_leave')
          .where('userId', isEqualTo: user.uid)
          .get();

      for (var doc in leaveQuery.docs) {
        final data = doc.data();
        allApplications.add({
          'id': doc.id,
          'type': '퇴사신청',
          'title': '퇴사 신청',
          'date': data['applyday'],
          'status': data['status'] ?? '대기',
          'description': data['reason'] ?? '',
        });
      }

      // 외박 신청
      final sleepoverQuery = await _firestore
          .collection('sleepover_applications')
          .where('userId', isEqualTo: user.uid)
          .get();

      for (var doc in sleepoverQuery.docs) {
        final data = doc.data();
        allApplications.add({
          'id': doc.id,
          'type': '외박신청',
          'title': '외박 신청',
          'date': data['submissionDate'],
          'status': data['status'] ?? '대기',
          'description': data['reason'] ?? '',
        });
      }

      // 민원 신청
      final complaintQuery = await _firestore
          .collection('civil_complaints')
          .where('userId', isEqualTo: user.uid)
          .get();

      for (var doc in complaintQuery.docs) {
        final data = doc.data();
        allApplications.add({
          'id': doc.id,
          'type': '민원신청',
          'title': data['title'] ?? '민원 신청',
          'date': data['createdAt'],
          'status': data['status'] ?? '대기',
          'description': data['description'] ?? '',
        });
      }

      // 날짜순으로 정렬 (최신순)
      allApplications.sort((a, b) {
        final dateA = a['date'] as Timestamp?;
        final dateB = b['date'] as Timestamp?;

        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;

        return dateB.compareTo(dateA);
      });

      // 최대 5개만 반환
      return allApplications.take(5).toList();
    } catch (e) {
      print('최근 신청 목록 조회 오류: $e');
      return [];
    }
  }

  // 신청 상태별 색상 반환
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case '승인':
        return Color(0xFF429F74);
      case '거부':
        return Color(0xFFFF6B6B);
      case '대기':
      case '처리중':
        return Color(0xFF3C63B7);
      default:
        return Color(0xFFB3B8BD);
    }
  }

  // 신청 유형별 아이콘 반환
  IconData getTypeIcon(String type) {
    switch (type) {
      case '입사신청':
        return Icons.login;
      case '퇴사신청':
        return Icons.logout;
      case '외박신청':
        return Icons.night_shelter;
      case '민원신청':
        return Icons.report_problem;
      default:
        return Icons.description;
    }
  }
}
