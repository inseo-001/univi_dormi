import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notice.dart';

class NoticeService {
  static final NoticeService _instance = NoticeService._internal();
  factory NoticeService() => _instance;
  NoticeService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 공지사항 목록 가져오기 (최신순)
  Future<List<Notice>> getNotices({int limit = 10}) async {
    try {
      print('📢 공지사항 목록 가져오기 시작 - limit: $limit');
      print('📢 Firebase 프로젝트: ${_firestore.app.options.projectId}');
      print('📢 Firebase 앱 이름: ${_firestore.app.name}');
      print('📢 Firebase 앱 옵션: ${_firestore.app.options}');

      // Firebase 연결 상태 확인
      print('📢 Firebase 연결 상태 확인 중...');

      final querySnapshot = await _firestore
          .collection('notices')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      print('📢 쿼리 결과: ${querySnapshot.docs.length}개 문서');

      // 각 문서의 내용을 로그로 출력
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        final doc = querySnapshot.docs[i];
        print('📢 문서 $i: ${doc.id} - ${doc.data()}');
      }

      if (querySnapshot.docs.isEmpty) {
        print('⚠️ 공지사항이 없습니다. Firestore에 notices 컬렉션이 있는지 확인하세요.');
        return [];
      }

      final notices =
          querySnapshot.docs.map((doc) => Notice.fromFirestore(doc)).toList();

      print('✅ 공지사항 목록 변환 완료: ${notices.length}개');
      for (int i = 0; i < notices.length; i++) {
        print(
            '✅ 공지사항 $i: ${notices[i].title} - ${notices[i].formattedDateTime}');
      }
      return notices;
    } catch (e) {
      print('❌ 공지사항 목록 가져오기 오류: $e');
      print('❌ 오류 타입: ${e.runtimeType}');
      print('❌ 스택 트레이스: ${StackTrace.current}');
      throw Exception('공지사항 목록을 가져오는 중 오류가 발생했습니다: $e');
    }
  }

  // 공지사항 목록 실시간 스트림
  Stream<List<Notice>> getNoticesStream({int limit = 10}) {
    return _firestore
        .collection('notices')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Notice.fromFirestore(doc)).toList();
    });
  }

  // 중요 공지사항만 가져오기
  Future<List<Notice>> getImportantNotices({int limit = 5}) async {
    try {
      print('📢 중요 공지사항 목록 가져오기 시작');

      final querySnapshot = await _firestore
          .collection('notices')
          .where('isImportant', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      print('📢 중요 공지사항 쿼리 결과: ${querySnapshot.docs.length}개 문서');

      if (querySnapshot.docs.isEmpty) {
        print('⚠️ 중요 공지사항이 없습니다.');
        return [];
      }

      final notices =
          querySnapshot.docs.map((doc) => Notice.fromFirestore(doc)).toList();

      print('✅ 중요 공지사항 목록 변환 완료: ${notices.length}개');
      return notices;
    } catch (e) {
      print('❌ 중요 공지사항 목록 가져오기 오류: $e');
      throw Exception('중요 공지사항 목록을 가져오는 중 오류가 발생했습니다: $e');
    }
  }

  // 공지사항 상세 정보 가져오기
  Future<Notice?> getNoticeById(String noticeId) async {
    try {
      print('🔍 NoticeService - getNoticeById 호출: $noticeId');

      final doc = await _firestore.collection('notices').doc(noticeId).get();

      print('🔍 NoticeService - 문서 존재 여부: ${doc.exists}');
      print('🔍 NoticeService - 문서 데이터: ${doc.data()}');

      if (!doc.exists) {
        print('⚠️ NoticeService - 문서가 존재하지 않음: $noticeId');
        return null;
      }

      final notice = Notice.fromFirestore(doc);
      print('🔍 NoticeService - 변환된 공지사항: ${notice.title}');
      return notice;
    } catch (e) {
      print('❌ 공지사항 상세 정보 가져오기 오류: $e');
      throw Exception('공지사항을 가져오는 중 오류가 발생했습니다: $e');
    }
  }

  // 공지사항 작성 (관리자용)
  Future<String> createNotice({
    required String title,
    required String content,
    required String author,
    bool isImportant = false,
    String? category,
  }) async {
    try {
      print('📢 앱에서 공지사항 작성 시작');
      print('📢 제목: $title');
      print('📢 작성자: $author');
      print('📢 중요도: $isImportant');
      print('📢 카테고리: $category');

      final notice = Notice(
        title: title,
        content: content,
        author: author,
        createdAt: DateTime.now(),
        isImportant: isImportant,
        category: category,
      );

      print('📢 Notice 객체 생성 완료');
      print('📢 저장할 데이터: ${notice.toFirestore()}');

      final docRef =
          await _firestore.collection('notices').add(notice.toFirestore());

      print('✅ 공지사항 작성 완료: ${docRef.id}');
      print('✅ 문서 경로: notices/${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ 공지사항 작성 오류: $e');
      print('❌ 오류 타입: ${e.runtimeType}');
      print('❌ 스택 트레이스: ${StackTrace.current}');
      throw Exception('공지사항 작성 중 오류가 발생했습니다: $e');
    }
  }

  // 공지사항 조회수 증가
  Future<void> incrementViewCount(String noticeId) async {
    try {
      await _firestore.collection('notices').doc(noticeId).update({
        'viewCount': FieldValue.increment(1),
        'updatedAt': Timestamp.now(),
      });
      print('✅ 공지사항 조회수 증가 완료: $noticeId');
    } catch (e) {
      print('❌ 공지사항 조회수 증가 오류: $e');
      throw Exception('조회수 증가 중 오류가 발생했습니다: $e');
    }
  }

  // 공지사항 수정 (관리자용)
  Future<void> updateNotice({
    required String noticeId,
    required String title,
    required String content,
    bool? isImportant,
    String? category,
  }) async {
    try {
      final updateData = {
        'title': title,
        'content': content,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (isImportant != null) {
        updateData['isImportant'] = isImportant;
      }

      if (category != null) {
        updateData['category'] = category;
      }

      await _firestore.collection('notices').doc(noticeId).update(updateData);

      print('✅ 공지사항 수정 완료: $noticeId');
    } catch (e) {
      print('❌ 공지사항 수정 오류: $e');
      throw Exception('공지사항 수정 중 오류가 발생했습니다: $e');
    }
  }

  // 공지사항 삭제 (관리자용)
  Future<void> deleteNotice(String noticeId) async {
    try {
      await _firestore.collection('notices').doc(noticeId).delete();

      print('✅ 공지사항 삭제 완료: $noticeId');
    } catch (e) {
      print('❌ 공지사항 삭제 오류: $e');
      throw Exception('공지사항 삭제 중 오류가 발생했습니다: $e');
    }
  }
}
