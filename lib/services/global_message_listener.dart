import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'simple_notification_service.dart';
import 'notification_service.dart';

/// 앱 전체에서 새 메시지를 감지하는 글로벌 리스너
class GlobalMessageListener {
  static final GlobalMessageListener _instance =
      GlobalMessageListener._internal();
  factory GlobalMessageListener() => _instance;
  GlobalMessageListener._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<QuerySnapshot>? _chatListSubscription;
  Map<String, StreamSubscription<QuerySnapshot>> _messageSubscriptions = {};

  String? _currentStudentId;
  String? _currentUserName;
  bool _isInitialized = false;

  /// 글로벌 메시지 리스너 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    print('🔔 글로벌 메시지 리스너 초기화 시작');

    try {
      // 현재 사용자 정보 가져오기
      await _getCurrentUserInfo();

      // 사용자의 모든 채팅방 목록을 감시
      await _startChatListListener();

      _isInitialized = true;
      print('🔔 글로벌 메시지 리스너 초기화 완료');
    } catch (e) {
      print('🔔 글로벌 메시지 리스너 초기화 오류: $e');
    }
  }

  /// 현재 사용자 정보 가져오기
  Future<void> _getCurrentUserInfo() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        _currentStudentId = user.uid;

        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(_currentStudentId).get();
        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          _currentUserName = userData['name'];
          _currentStudentId = userData['studentId'];
        }
      } else {
        // 임시 사용자 정보 (테스트용)
        _currentStudentId = '20230709';
        _currentUserName = '이민구';
      }

      print('🔔 현재 사용자: $_currentUserName ($_currentStudentId)');
    } catch (e) {
      print('🔔 사용자 정보 가져오기 오류: $e');
      _currentStudentId = '20230709';
      _currentUserName = '이민구';
    }
  }

  /// 사용자의 모든 채팅방 목록을 감시
  Future<void> _startChatListListener() async {
    if (_currentStudentId == null) return;

    try {
      // 현재 학생의 모든 채팅방을 감시
      _chatListSubscription = _firestore
          .collection('chats')
          .where('studentId', isEqualTo: _currentStudentId)
          .snapshots()
          .listen((snapshot) {
        print('🔔 채팅방 목록 업데이트: ${snapshot.docs.length}개 채팅방');

        for (var chatDoc in snapshot.docs) {
          String chatId = chatDoc.id;

          // 이미 리스너가 있는 채팅방은 건너뛰기
          if (_messageSubscriptions.containsKey(chatId)) {
            continue;
          }

          // 새로운 채팅방에 메시지 리스너 추가
          _addMessageListener(chatId);
        }
      });

      print('🔔 채팅방 목록 리스너 시작');
    } catch (e) {
      print('🔔 채팅방 목록 리스너 오류: $e');
    }
  }

  /// 특정 채팅방의 메시지 리스너 추가
  void _addMessageListener(String chatId) {
    try {
      print('🔔 채팅방 메시지 리스너 추가: $chatId');

      // 마지막 메시지 시간을 기준으로 새 메시지만 감지
      DateTime startTime = DateTime.now();

      _messageSubscriptions[chatId] = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('timestamp', isGreaterThan: Timestamp.fromDate(startTime))
          .orderBy('timestamp', descending: false)
          .snapshots()
          .listen((snapshot) {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            var messageData = change.doc.data() as Map<String, dynamic>;
            _handleNewMessage(chatId, messageData);
          }
        }
      });
    } catch (e) {
      print('🔔 메시지 리스너 추가 오류: $e');
    }
  }

  /// 새 메시지 처리
  void _handleNewMessage(String chatId, Map<String, dynamic> messageData) {
    try {
      String messageText = messageData['text'] ?? '';
      String senderName = messageData['senderName'] ?? '알 수 없음';
      bool isAdmin = messageData['isAdmin'] ?? false;
      String senderId = messageData['senderId'] ?? '';

      print('🔔 새 메시지 감지 (글로벌): $messageText');
      print('🔔 발신자: $senderName, isAdmin: $isAdmin, senderId: $senderId');

      // 자신이 보낸 메시지는 알림 제외
      if (senderId == 'student' && senderName == _currentUserName) {
        print('🔔 자신이 보낸 메시지 - 알림 생략');
        return;
      }

      // AI 어시스턴트 메시지는 알림 제외
      if (senderName == 'AI 어시스턴트') {
        print('🔔 AI 어시스턴트 메시지 - 알림 생략');
        return;
      }

      // 현재 채팅방에 있는지 확인
      if (_isCurrentChatRoom(chatId, senderName)) {
        print('🔔 현재 채팅방($senderName)에 있으므로 알림 생략');
        return;
      }

      // 새로운 메시지 알림 표시 (현재 채팅방이 아닌 경우만)
      print('🔔 새 메시지 알림 표시 (글로벌)');
      SimpleNotificationService().showNewMessageNotification(
        senderName: senderName,
        message: messageText,
        isFromAdmin: isAdmin,
      );
    } catch (e) {
      print('🔔 새 메시지 처리 오류: $e');
    }
  }

  /// 현재 채팅방인지 확인
  bool _isCurrentChatRoom(String chatId, String senderName) {
    try {
      // NotificationService에서 현재 채팅방 상태 확인
      String? currentRole = NotificationService().currentChatRole;
      String? currentStudentId = NotificationService().currentStudentId;

      if (currentRole == null || currentStudentId == null) {
        return false;
      }

      // 채팅방 ID 패턴: chat_{studentId}_{adminType}
      // 발신자 이름으로 adminType 추정
      String? expectedAdminType = _getAdminTypeFromSenderName(senderName);
      if (expectedAdminType == null) {
        return false;
      }

      String expectedChatId = 'chat_${currentStudentId}_$expectedAdminType';

      print('🔔 현재 채팅방 확인: chatId=$chatId, expectedChatId=$expectedChatId');
      return chatId == expectedChatId;
    } catch (e) {
      print('🔔 현재 채팅방 확인 오류: $e');
      return false;
    }
  }

  /// 발신자 이름으로 관리자 타입 추정
  String? _getAdminTypeFromSenderName(String senderName) {
    switch (senderName) {
      case '실장님':
        return 'director';
      case '사감님':
        return 'supervisor';
      case '층장님':
        return 'floor_manager';
      default:
        return null;
    }
  }

  /// 리스너 정리
  void dispose() {
    print('🔔 글로벌 메시지 리스너 정리');

    _chatListSubscription?.cancel();
    _chatListSubscription = null;

    for (var subscription in _messageSubscriptions.values) {
      subscription.cancel();
    }
    _messageSubscriptions.clear();

    _isInitialized = false;
  }

  /// 특정 채팅방의 리스너 제거 (채팅방에 들어갔을 때)
  void pauseChatListener(String chatId) {
    if (_messageSubscriptions.containsKey(chatId)) {
      print('🔔 채팅방 리스너 일시정지: $chatId');
      _messageSubscriptions[chatId]?.cancel();
      _messageSubscriptions.remove(chatId);
    }
  }

  /// 특정 채팅방의 리스너 재시작 (채팅방에서 나왔을 때)
  void resumeChatListener(String chatId) {
    if (!_messageSubscriptions.containsKey(chatId)) {
      print('🔔 채팅방 리스너 재시작: $chatId');
      _addMessageListener(chatId);
    }
  }
}
