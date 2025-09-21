import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BBSService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 게시글 작성
  Future<String> createPost({
    required String title,
    required String content,
    String? imageUrl,
  }) async {
    try {
      print('=== 게시글 작성 시작 ===');
      print('제목: $title');
      print('내용: $content');

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

      // 게시글 데이터 생성
      final postData = {
        'userId': user.uid,
        'userName': userName,
        'studentId': studentId,
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
        'viewCount': 0,
        'likeCount': 0,
        'commentCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      print('💾 저장할 게시글 데이터: $postData');

      // Firestore에 저장
      print('📡 Firestore 저장 시작...');
      final docRef = await _firestore.collection('posts').add(postData);
      print('✅ Firestore 저장 완료: ${docRef.id}');

      return docRef.id;
    } catch (e) {
      print('❌ 게시글 작성 오류: $e');
      print('❌ 오류 타입: ${e.runtimeType}');
      print('❌ 스택 트레이스: ${StackTrace.current}');
      throw Exception('게시글 작성 중 오류가 발생했습니다: $e');
    }
  }

  // 게시글 목록 가져오기
  Future<List<Map<String, dynamic>>> getPosts() async {
    try {
      print('=== 게시글 목록 조회 시작 ===');

      final querySnapshot = await _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();

      print('📊 쿼리 결과: ${querySnapshot.docs.length}개 문서');

      List<Map<String, dynamic>> posts = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        // Timestamp를 DateTime으로 변환
        if (data['createdAt'] != null) {
          data['createdAt'] = (data['createdAt'] as Timestamp).toDate();
        }
        if (data['updatedAt'] != null) {
          data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate();
        }

        posts.add(data);
        print('📄 게시글: ${data['title']} - ${data['userName']}');
      }

      return posts;
    } catch (e) {
      print('❌ 게시글 목록 조회 오류: $e');
      throw Exception('게시글 목록을 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  // 특정 게시글 가져오기
  Future<Map<String, dynamic>?> getPost(String postId) async {
    try {
      print('=== 게시글 상세 조회 시작 ===');
      print('게시글 ID: $postId');

      final doc = await _firestore.collection('posts').doc(postId).get();

      if (!doc.exists) {
        print('❌ 게시글을 찾을 수 없음');
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;

      // Timestamp를 DateTime으로 변환
      if (data['createdAt'] != null) {
        data['createdAt'] = (data['createdAt'] as Timestamp).toDate();
      }
      if (data['updatedAt'] != null) {
        data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate();
      }

      print('✅ 게시글 조회 완료: ${data['title']}');
      return data;
    } catch (e) {
      print('❌ 게시글 상세 조회 오류: $e');
      throw Exception('게시글을 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  // 게시글 조회수 증가
  Future<void> incrementViewCount(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'viewCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('✅ 조회수 증가 완료: $postId');
    } catch (e) {
      print('❌ 조회수 증가 오류: $e');
    }
  }

  // 사용자의 좋아요 상태 확인
  Future<bool> isLiked(String postId, String userId) async {
    try {
      final likeDoc = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(userId)
          .get();

      return likeDoc.exists;
    } catch (e) {
      print('❌ 좋아요 상태 확인 오류: $e');
      return false;
    }
  }

  // 게시글 좋아요
  Future<void> toggleLike(String postId, String userId) async {
    try {
      final likeRef = _firestore
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(userId);

      final likeDoc = await likeRef.get();

      if (likeDoc.exists) {
        // 좋아요 취소
        await likeRef.delete();
        await _firestore.collection('posts').doc(postId).update({
          'likeCount': FieldValue.increment(-1),
        });
        print('✅ 좋아요 취소 완료: $postId');
      } else {
        // 좋아요 추가
        await likeRef.set({
          'userId': userId,
          'createdAt': FieldValue.serverTimestamp(),
        });
        await _firestore.collection('posts').doc(postId).update({
          'likeCount': FieldValue.increment(1),
        });
        print('✅ 좋아요 추가 완료: $postId');
      }
    } catch (e) {
      print('❌ 좋아요 토글 오류: $e');
      throw Exception('좋아요 처리 중 오류가 발생했습니다: $e');
    }
  }

  // 댓글 작성
  Future<String> addComment({
    required String postId,
    required String content,
  }) async {
    try {
      print('=== 댓글 작성 시작 ===');
      print('게시글 ID: $postId');
      print('댓글 내용: $content');

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다.');
      }

      // 사용자 정보 가져오기
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data() as Map<String, dynamic>;
      final userName = userData['name'] ?? 'Unknown';

      final commentData = {
        'postId': postId,
        'userId': user.uid,
        'userName': userName,
        'content': content,
        'likeCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add(commentData);

      // 게시글의 댓글 수 증가
      await _firestore.collection('posts').doc(postId).update({
        'commentCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ 댓글 작성 완료: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ 댓글 작성 오류: $e');
      throw Exception('댓글 작성 중 오류가 발생했습니다: $e');
    }
  }

  // 댓글 목록 가져오기
  Future<List<Map<String, dynamic>>> getComments(String postId) async {
    try {
      print('=== 댓글 목록 조회 시작 ===');
      print('게시글 ID: $postId');

      final querySnapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('createdAt', descending: false)
          .get();

      print('📊 댓글 수: ${querySnapshot.docs.length}개');

      List<Map<String, dynamic>> comments = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        if (data['createdAt'] != null) {
          data['createdAt'] = (data['createdAt'] as Timestamp).toDate();
        }

        comments.add(data);
      }

      return comments;
    } catch (e) {
      print('❌ 댓글 목록 조회 오류: $e');
      throw Exception('댓글 목록을 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  // 게시글 삭제
  Future<void> deletePost(String postId) async {
    try {
      print('=== 게시글 삭제 시작 ===');
      print('게시글 ID: $postId');

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다.');
      }

      // 게시글 정보 가져오기
      final postDoc = await _firestore.collection('posts').doc(postId).get();
      if (!postDoc.exists) {
        throw Exception('게시글을 찾을 수 없습니다.');
      }

      final postData = postDoc.data() as Map<String, dynamic>;

      // 작성자 확인
      if (postData['userId'] != user.uid) {
        throw Exception('삭제 권한이 없습니다.');
      }

      // 게시글과 관련된 모든 데이터 삭제
      final batch = _firestore.batch();

      // 댓글 삭제
      final commentsSnapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();

      for (var commentDoc in commentsSnapshot.docs) {
        batch.delete(commentDoc.reference);
      }

      // 좋아요 삭제
      final likesSnapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .get();

      for (var likeDoc in likesSnapshot.docs) {
        batch.delete(likeDoc.reference);
      }

      // 게시글 삭제
      batch.delete(postDoc.reference);

      // 모든 삭제 작업 실행
      await batch.commit();

      print('✅ 게시글 삭제 완료: $postId');
    } catch (e) {
      print('❌ 게시글 삭제 오류: $e');
      throw Exception('게시글 삭제 중 오류가 발생했습니다: $e');
    }
  }

  // 게시글 신고
  Future<void> reportPost(String postId, String reporterId) async {
    try {
      print('=== 게시글 신고 시작 ===');
      print('게시글 ID: $postId');
      print('신고자 ID: $reporterId');

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다.');
      }

      if (user.uid != reporterId) {
        throw Exception('신고 권한이 없습니다.');
      }

      // 게시글 정보 가져오기
      final postDoc = await _firestore.collection('posts').doc(postId).get();
      if (!postDoc.exists) {
        throw Exception('게시글을 찾을 수 없습니다.');
      }

      // 이미 신고했는지 확인
      final reportDoc = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('reports')
          .doc(reporterId)
          .get();

      if (reportDoc.exists) {
        throw Exception('이미 신고한 게시글입니다.');
      }

      // 신고 데이터 저장
      final reportData = {
        'postId': postId,
        'reporterId': reporterId,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('reports')
          .doc(reporterId)
          .set(reportData);

      print('✅ 게시글 신고 완료: $postId');
    } catch (e) {
      print('❌ 게시글 신고 오류: $e');
      throw Exception('게시글 신고 중 오류가 발생했습니다: $e');
    }
  }
}
