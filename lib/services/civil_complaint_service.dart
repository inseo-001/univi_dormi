import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/civil_complaint.dart';

class CivilComplaintService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 민원 신청하기
  Future<String> submitComplaint({
    required String complaintType,
    required String category,
    required String title,
    required String description,
  }) async {
    try {
      print('=== submitComplaint 시작 ===');
      print('민원 종류: $complaintType');
      print('카테고리: $category');
      print('제목: $title');
      print('상세내용: $description');

      final user = _auth.currentUser;
      if (user == null) {
        print('❌ 사용자가 로그인되지 않음');
        throw Exception('로그인이 필요합니다.');
      }
      print('✅ 사용자 로그인 확인: ${user.uid}');

      // 사용자 정보 가져오기
      print('📡 사용자 정보 조회 시작...');
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        print('❌ 사용자 문서가 존재하지 않음');
        throw Exception('사용자 정보를 찾을 수 없습니다.');
      }
      print('✅ 사용자 문서 존재 확인');

      final userData = userDoc.data() as Map<String, dynamic>;
      final userName = userData['name'] ?? 'Unknown';
      final studentId = userData['studentId'] ?? 'Unknown';
      print('✅ 사용자 정보: $userName ($studentId)');

      // 민원 데이터 생성
      print('🔄 민원 객체 생성 시작...');
      final complaint = CivilComplaint(
        userId: user.uid,
        userName: userName,
        studentId: studentId,
        complaintType: complaintType,
        category: category,
        title: title,
        description: description,
        createdAt: DateTime.now(),
      );
      print('✅ 민원 객체 생성 완료');

      // Firestore에 저장
      print('📡 Firestore 저장 시작...');
      final docRef = await _firestore
          .collection('civil_complaints')
          .add(complaint.toFirestore());
      print('✅ Firestore 저장 완료: ${docRef.id}');

      return docRef.id;
    } catch (e) {
      print('❌ submitComplaint 오류: $e');
      print('❌ 오류 타입: ${e.runtimeType}');
      print('❌ 스택 트레이스: ${StackTrace.current}');
      throw Exception('민원 신청 중 오류가 발생했습니다: $e');
    }
  }

  // 사용자의 민원 목록 가져오기
  Future<List<CivilComplaint>> getUserComplaints() async {
    try {
      print('=== getUserComplaints 시작 ===');
      final user = _auth.currentUser;
      if (user == null) {
        print('❌ 사용자가 로그인되지 않음');
        throw Exception('로그인이 필요합니다.');
      }

      print('✅ 사용자 ID: ${user.uid}');
      print('✅ 사용자 이메일: ${user.email}');

      print('📡 Firestore 쿼리 시작...');
      final querySnapshot = await _firestore
          .collection('civil_complaints')
          .where('userId', isEqualTo: user.uid)
          .get();

      print('📊 쿼리 결과 (인덱스 없이): ${querySnapshot.docs.length}개 문서');

      // 클라이언트에서 정렬 (임시 해결책)
      final sortedDocs = querySnapshot.docs.toList()
        ..sort((a, b) {
          final aData = a.data();
          final bData = b.data();
          final aTime = aData['createdAt'] as Timestamp?;
          final bTime = bData['createdAt'] as Timestamp?;

          if (aTime == null && bTime == null) return 0;
          if (aTime == null) return 1;
          if (bTime == null) return -1;

          return bTime.compareTo(aTime); // 내림차순 정렬
        });

      print('🔄 클라이언트 정렬 완료: ${sortedDocs.length}개 문서');

      if (sortedDocs.isEmpty) {
        print('⚠️ 민원이 없습니다.');
        return [];
      }

      print('🔄 문서 변환 시작...');
      final complaints = <CivilComplaint>[];

      for (int i = 0; i < sortedDocs.length; i++) {
        final doc = sortedDocs[i];
        print('문서 $i ID: ${doc.id}');
        print('문서 $i 데이터: ${doc.data()}');

        try {
          final complaint = CivilComplaint.fromFirestore(doc);
          complaints.add(complaint);
          print('✅ 민원 $i 변환 성공: ${complaint.title} - ${complaint.status}');
        } catch (e) {
          print('❌ 민원 $i 변환 실패: $e');
        }
      }

      print('✅ 민원 목록 변환 완료: ${complaints.length}개');
      print('=== getUserComplaints 완료 ===');
      return complaints;
    } catch (e) {
      print('❌ getUserComplaints 오류: $e');
      print('❌ 오류 타입: ${e.runtimeType}');
      print('❌ 스택 트레이스: ${StackTrace.current}');
      throw Exception('민원 목록을 가져오는 중 오류가 발생했습니다: $e');
    }
  }

  // 사용자의 민원 목록 실시간 스트림
  Stream<List<CivilComplaint>> getUserComplaintsStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('civil_complaints')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      // 클라이언트에서 정렬 (인덱스 없이)
      final sortedDocs = snapshot.docs.toList()
        ..sort((a, b) {
          final aData = a.data();
          final bData = b.data();
          final aTime = aData['createdAt'] as Timestamp?;
          final bTime = bData['createdAt'] as Timestamp?;

          if (aTime == null && bTime == null) return 0;
          if (aTime == null) return 1;
          if (bTime == null) return -1;

          return bTime.compareTo(aTime); // 내림차순 정렬
        });

      return sortedDocs
          .map((doc) => CivilComplaint.fromFirestore(doc))
          .toList();
    });
  }

  // 모든 민원 목록 가져오기 (관리자용)
  Future<List<CivilComplaint>> getAllComplaints() async {
    try {
      final querySnapshot = await _firestore
          .collection('civil_complaints')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CivilComplaint.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('민원 목록을 가져오는 중 오류가 발생했습니다: $e');
    }
  }

  // 민원 상태 업데이트 (관리자용)
  Future<void> updateComplaintStatus({
    required String complaintId,
    required String status,
    String? adminResponse,
  }) async {
    try {
      final updateData = {
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (adminResponse != null) {
        updateData['adminResponse'] = adminResponse;
      }

      if (status == '완료') {
        updateData['completedAt'] = FieldValue.serverTimestamp();
      }

      await _firestore
          .collection('civil_complaints')
          .doc(complaintId)
          .update(updateData);
    } catch (e) {
      throw Exception('민원 상태 업데이트 중 오류가 발생했습니다: $e');
    }
  }

  // 민원 상세 정보 가져오기
  Future<CivilComplaint?> getComplaintById(String complaintId) async {
    try {
      final doc = await _firestore
          .collection('civil_complaints')
          .doc(complaintId)
          .get();

      if (doc.exists) {
        return CivilComplaint.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('민원 정보를 가져오는 중 오류가 발생했습니다: $e');
    }
  }

  // 민원 삭제
  Future<void> deleteComplaint(String complaintId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다.');
      }

      // 민원이 해당 사용자의 것인지 확인
      final complaint = await getComplaintById(complaintId);
      if (complaint == null) {
        throw Exception('민원을 찾을 수 없습니다.');
      }

      if (complaint.userId != user.uid) {
        throw Exception('본인의 민원만 삭제할 수 있습니다.');
      }

      await _firestore.collection('civil_complaints').doc(complaintId).delete();
    } catch (e) {
      throw Exception('민원 삭제 중 오류가 발생했습니다: $e');
    }
  }

  // 민원 통계 가져오기
  Future<Map<String, int>> getComplaintStats() async {
    try {
      final querySnapshot =
          await _firestore.collection('civil_complaints').get();

      int total = querySnapshot.docs.length;
      int received = 0;
      int processing = 0;
      int completed = 0;

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final status = data['status'] ?? '접수';

        switch (status) {
          case '접수':
            received++;
            break;
          case '처리중':
            processing++;
            break;
          case '완료':
            completed++;
            break;
        }
      }

      return {
        'total': total,
        'received': received,
        'processing': processing,
        'completed': completed,
      };
    } catch (e) {
      throw Exception('민원 통계를 가져오는 중 오류가 발생했습니다: $e');
    }
  }
}
