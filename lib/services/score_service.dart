import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // 상벌점 신청 데이터 저장
  static Future<bool> submitScoreApplication({
    required String applicationType,
    required String reason,
    required String description,
    required int points,
  }) async {
    try {
      print('🔄 상벌점 신청 저장 시작...');
      print('📝 신청 정보: $applicationType - $reason ($points점)');

      final user = _auth.currentUser;
      if (user == null) {
        print('❌ 사용자가 로그인되지 않았습니다.');
        throw Exception('사용자가 로그인되지 않았습니다.');
      }

      print('👤 사용자 ID: ${user.uid}');

      // 사용자 정보 가져오기 (실제 앱에서는 사용자 프로필에서 가져와야 함)
      String userName = '테스트 사용자';
      String studentId = '20240001';

      try {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        final userData = userDoc.data();
        userName = userData?['name'] ?? '테스트 사용자';
        studentId = userData?['studentId'] ?? '20240001';
        print('👤 사용자 정보: $userName ($studentId)');
      } catch (e) {
        print('⚠️ 사용자 정보 조회 실패, 기본값 사용: $e');
      }

      final scoreData = {
        'userId': user.uid,
        'userName': userName,
        'studentId': studentId,
        'type': applicationType,
        'reason': reason,
        'description': description,
        'points': points,
        'status': '처리중', // 기본 상태: 처리중
        'adminResponse': '', // 관리자 응답
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      print('💾 저장할 데이터: $scoreData');
      print('🔍 최종 저장되는 points 값: ${scoreData['points']}');

      final docRef = await _firestore.collection('scores').add(scoreData);
      print('✅ 상벌점 신청이 성공적으로 저장되었습니다. 문서 ID: ${docRef.id}');

      return true;
    } catch (e) {
      print('❌ 상벌점 신청 저장 오류: $e');
      print('❌ 스택 트레이스: ${e.toString()}');
      return false;
    }
  }

  // 사용자의 상벌점 신청 목록 가져오기
  static Future<List<Map<String, dynamic>>> getUserScoreApplications() async {
    try {
      print('🔄 상벌점 신청 목록 조회 시작...');

      final user = _auth.currentUser;
      if (user == null) {
        print('❌ 사용자가 로그인되지 않았습니다.');
        throw Exception('사용자가 로그인되지 않았습니다.');
      }

      print('👤 사용자 ID: ${user.uid}');

      // 먼저 전체 scores 컬렉션 확인
      final allSnapshot = await _firestore.collection('scores').get();
      print('📊 전체 scores 컬렉션 문서 수: ${allSnapshot.docs.length}개');

      for (final doc in allSnapshot.docs) {
        final data = doc.data();
        print(
            '📄 문서 ID: ${doc.id}, userId: ${data['userId']}, type: ${data['type']}');
      }

      // 사용자별 쿼리 (orderBy 제거하여 인덱스 문제 해결)
      final snapshot = await _firestore
          .collection('scores')
          .where('userId', isEqualTo: user.uid)
          .get();

      print('📋 사용자별 신청 수: ${snapshot.docs.length}개');

      final applications = snapshot.docs.map((doc) {
        final data = doc.data();
        final application = {
          'id': doc.id,
          ...data,
          'createdAt': data['createdAt']?.toDate(),
          'updatedAt': data['updatedAt']?.toDate(),
        };
        print('📝 신청: ${data['type']} - ${data['reason']} (${data['status']})');
        return application;
      }).toList();

      // 클라이언트에서 정렬 (최신순)
      applications.sort((a, b) {
        final aTime = a['createdAt'] as DateTime?;
        final bTime = b['createdAt'] as DateTime?;

        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;

        return bTime.compareTo(aTime); // 최신순
      });

      print('✅ 신청 목록 조회 완료: ${applications.length}개');
      return applications;
    } catch (e) {
      print('❌ 상벌점 신청 목록 조회 오류: $e');
      print('❌ 스택 트레이스: ${e.toString()}');
      return [];
    }
  }

  // 사용자의 현재 상벌점 점수 계산
  static Future<Map<String, int>> getUserScoreSummary() async {
    try {
      print('🔄 상벌점 점수 계산 시작...');

      final user = _auth.currentUser;
      if (user == null) {
        print('❌ 사용자가 로그인되지 않았습니다.');
        throw Exception('사용자가 로그인되지 않았습니다.');
      }

      print('👤 사용자 ID: ${user.uid}');

      final snapshot = await _firestore
          .collection('scores')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: '승인')
          .get();

      print('📊 승인된 상벌점 신청 수: ${snapshot.docs.length}');

      int totalRewardPoints = 0;
      int totalPenaltyPoints = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final points = data['points'] ?? 0;
        final type = data['type'] ?? '알 수 없음';

        final pointsInt = (points as num).toInt();
        print('📝 ${type}: ${pointsInt}점');

        // 벌점 신청인 경우 벌점으로 분류, 상점 신청인 경우 상점으로 분류
        if (type.contains('벌점')) {
          totalPenaltyPoints += pointsInt.abs();
          print('   → 벌점으로 분류: ${pointsInt.abs()}점');
        } else if (type.contains('상점')) {
          totalRewardPoints += pointsInt.abs();
          print('   → 상점으로 분류: ${pointsInt.abs()}점');
        } else {
          // 기존 로직 (점수로 판단)
          if (pointsInt > 0) {
            totalRewardPoints += pointsInt;
            print('   → 상점으로 분류 (점수 기준): ${pointsInt}점');
          } else {
            totalPenaltyPoints += pointsInt.abs();
            print('   → 벌점으로 분류 (점수 기준): ${pointsInt.abs()}점');
          }
        }
      }

      print(
          '✅ 최종 계산 결과 - 상점: ${totalRewardPoints}점, 벌점: ${totalPenaltyPoints}점');

      return {
        'rewardPoints': totalRewardPoints,
        'penaltyPoints': totalPenaltyPoints,
      };
    } catch (e) {
      print('❌ 상벌점 점수 계산 오류: $e');
      return {'rewardPoints': 0, 'penaltyPoints': 0};
    }
  }

  // 기존 "완료" 상태를 "승인"으로 변경하는 함수
  static Future<void> updateCompletedToApproved() async {
    try {
      print('🔄 완료 상태를 승인으로 변경 시작...');

      final snapshot = await _firestore
          .collection('scores')
          .where('status', isEqualTo: '완료')
          .get();

      print('📊 완료 상태인 문서 수: ${snapshot.docs.length}개');

      for (final doc in snapshot.docs) {
        await doc.reference.update({
          'status': '승인',
          'updatedAt': FieldValue.serverTimestamp(),
        });
        print('✅ 문서 ${doc.id} 상태를 승인으로 변경');
      }

      print('✅ 모든 완료 상태가 승인으로 변경되었습니다.');
    } catch (e) {
      print('❌ 상태 변경 오류: $e');
    }
  }

  // 테스트용 샘플 데이터 생성 (개발 중에만 사용)
  static Future<void> createSampleData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('❌ 사용자가 로그인되지 않았습니다.');
        return;
      }

      print('🔄 테스트 데이터 생성 중...');

      // 샘플 상벌점 데이터 생성
      final sampleData = [
        {
          'userId': user.uid,
          'userName': '테스트 사용자',
          'studentId': '20240001',
          'type': '상점 신청',
          'reason': '기숙사 규칙 준수',
          'description': '테스트 상점 신청입니다.',
          'points': 5,
          'status': '승인',
          'adminResponse': '승인되었습니다.',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'userId': user.uid,
          'userName': '테스트 사용자',
          'studentId': '20240001',
          'type': '벌점 신청',
          'reason': '소음 발생',
          'description': '테스트 벌점 신청입니다.',
          'points': -3,
          'status': '승인',
          'adminResponse': '승인되었습니다.',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      ];

      for (final data in sampleData) {
        await _firestore.collection('scores').add(data);
      }

      print('✅ 테스트 데이터 생성 완료');
    } catch (e) {
      print('❌ 테스트 데이터 생성 오류: $e');
    }
  }
}
